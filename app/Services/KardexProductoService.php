<?php

namespace App\Services;

use App\Models\DetalleOrden;
use App\Models\IngresoDetalle;
use App\Models\IngresoProducto;
use App\Models\KardexProducto;
use App\Models\Producto;
use App\Models\ProductoSucursal;
use App\Models\SalidaProducto;
use Carbon\Carbon;
use Exception;
use Illuminate\Support\Facades\Log;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Models\Almacen;

use App\Services\ReporteServiceTcpdf;
use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;
use PhpOffice\PhpSpreadsheet\Style\Alignment;
use PhpOffice\PhpSpreadsheet\Style\Border;
use PhpOffice\PhpSpreadsheet\Style\Fill;


class KardexProductoService
{

    public function __construct(private ProductoService $productoService) {}

    /**
     * Registrar el ingreso de un producto en kardex
     *
     * @param integer $sucursal_id
     * @param string $tipo_registro
     * @param string $ingreso_salida (INGRESO/EGRESO)
     * @param integer $ingreso_detalle_id
     * @param Producto $producto
     * @param float $cantidad
     * @param float $precio
     * @param string $detalle
     * @param string $modulo
     * @param integer $registro_id
     * @return $registro_producto
     */
    public function registrarMovimiento(
        int $sucursal_id,
        int $almacen_id,
        string $tipo_registro,
        string $ingreso_salida,
        ?int $ingreso_detalle_id = null,
        Producto $producto,
        float $cantidad,
        float $precio,
        string $detalle = "",
        string $modulo = "",
        int $registro_id = 0
    ): ProductoSucursal {
        if ($cantidad <= 0) {
            throw new \InvalidArgumentException(
                'La cantidad debe ser mayor que cero.'
            );
        }

        if (!in_array($ingreso_salida, ['INGRESO', 'EGRESO'], true)) {
            throw new \InvalidArgumentException(
                'El movimiento debe ser INGRESO o EGRESO.'
            );
        }

        $ultimo = KardexProducto::where('producto_id', $producto->id)
            ->where('almacen_id', $almacen_id)
            ->where('sucursal_id', $sucursal_id)
            ->where('status', 1)
            ->orderByDesc('id')
            ->first();

        $cantidadAnterior = (float) ($ultimo->cantidad_saldo ?? 0);
        $montoAnterior = (float) ($ultimo->monto_saldo ?? 0);

        $cantidadIngreso = 0;
        $cantidadSalida = 0;
        $montoIngreso = 0;
        $montoSalida = 0;
        $montoSaldo = 0;

        if ($ingreso_salida === 'INGRESO') {
            // El precio recibido representa el costo unitario de compra.
            if ($precio < 0) {
                throw new \InvalidArgumentException(
                    'El costo de ingreso no puede ser negativo.'
                );
            }

            $cantidadIngreso = $cantidad;
            $montoIngreso = $cantidad * $precio;

            $cantidadSaldo = $cantidadAnterior + $cantidadIngreso;
            $montoSaldo = $montoAnterior + $montoIngreso;

            // Promedio ponderado después de la compra.
            $cu = $cantidadSaldo > 0
                ? $montoSaldo / $cantidadSaldo
                : 0;
        } else {
            if (!$ultimo) {
                throw new \Exception(
                    'No existen movimientos previos para registrar el egreso.'
                );
            }

            if ($cantidadAnterior <= 0) {
                throw new \Exception(
                    'No hay existencias disponibles para registrar el egreso.'
                );
            }

            if ($cantidad > $cantidadAnterior) {
                throw new \Exception(
                    'La cantidad del egreso supera el stock disponible.'
                );
            }

            // Costo promedio vigente ANTES de la salida.
            $cu = $montoAnterior / $cantidadAnterior;

            $cantidadSalida = $cantidad;
            $montoSalida = $cantidadSalida * $cu;

            $cantidadSaldo = $cantidadAnterior - $cantidadSalida;
            $montoSaldo = $montoAnterior - $montoSalida;

            // Evitar pequeños residuos por precisión decimal.
            if (abs($cantidadSaldo) < 0.000001) {
                $cantidadSaldo = 0;
                $montoSaldo = 0;
            }
        }

        $datosMovimiento = [
            'sucursal_id' => $sucursal_id,
            'almacen_id' => $almacen_id,
            'tipo_registro' => $tipo_registro,
            'registro_id' => $registro_id !== 0 ? $registro_id : null,
            'modulo' => $modulo,
            'ingreso_detalle_id' => $ingreso_detalle_id,
            'producto_id' => $producto->id,
            'presentacion_producto_id' => null,
            'detalle' => $detalle,
            'precio' => $ingreso_salida === 'INGRESO' ? $precio : $cu,
            'tipo_is' => $ingreso_salida,
            'cantidad_ingreso' => $cantidadIngreso,
            'cantidad_salida' => $cantidadSalida,
            'monto_ingreso' => $montoIngreso,
            'monto_salida' => $montoSalida,
            'cantidad_saldo' => $cantidadSaldo,
            'monto_saldo' => $montoSaldo,
            'cu' => $cu,
            'fecha' => now('America/La_Paz')->toDateString(),
        ];

        KardexProducto::create($datosMovimiento);

        if ($ingreso_salida === 'INGRESO') {
            return $this->productoService->incrementarStock(
                $sucursal_id,
                $almacen_id,
                $producto->id,
                $cantidad
            );
        }

        return $this->productoService->decrementarStock(
            $sucursal_id,
            $almacen_id,
            $producto->id,
            $cantidad
        );
    }

    // REPORTE INGRESO BRUTO

    public function obtenerDatosIngresoBrutoProductos(Request $request)
    {
        $categoria_id = $request->categoria_id ?? 'todos';
        $marca_id = $request->marca_id ?? 'todos';
        $unidad_medida_id = $request->unidad_medida_id ?? 'todos';
        $almacen_id = $request->almacen_id ?? 'todos';

        /*
    |--------------------------------------------------------------------------
    | Costo de ventas registrado en el Kardex
    |--------------------------------------------------------------------------
    |
    | Cada movimiento de salida por venta se relaciona con VentaDetalle
    | mediante registro_id y modulo.
    |
    */
        $costosKardex = DB::table('kardex_productos')
            ->select(
                'registro_id',
                DB::raw('SUM(monto_salida) as costo_venta')
            )
            ->where('modulo', 'VentaDetalle')
            ->where('tipo_is', 'EGRESO')
            ->where('status', 1)
            ->groupBy('registro_id');

        /*
    |--------------------------------------------------------------------------
    | Consulta de ventas agrupadas por producto
    |--------------------------------------------------------------------------
    */

        $consulta = DB::table('venta_detalles as vd')
            ->join('ventas as v', 'v.id', '=', 'vd.venta_id')
            ->join('productos as p', 'p.id', '=', 'vd.producto_id')
            ->leftJoinSub(
                $costosKardex,
                'kc',
                function ($join) {
                    $join->on('kc.registro_id', '=', 'vd.id');
                }
            )
            ->leftJoin(
                'categorias as c',
                'c.id',
                '=',
                'p.categoria_id'
            )
            ->leftJoin(
                'marcas as m',
                'm.id',
                '=',
                'p.marca_id'
            )
            ->leftJoin(
                'unidad_medidas as um',
                'um.id',
                '=',
                'p.unidad_medida_id'
            )
            ->select(
                'p.id as producto_id',
                'p.nombre as producto',
                'c.nombre as categoria',
                'm.nombre as marca',
                'um.nombre as unidad_medida',
                DB::raw('SUM(vd.cantidad) as cantidad_vendida'),
                DB::raw('SUM(vd.total) as ingreso_bruto'),
                DB::raw(
                    'SUM(COALESCE(kc.costo_venta, 0)) as costo_ventas'
                )
            )
            ->where('vd.status', 1);

        /*
    |--------------------------------------------------------------------------
    | Filtros
    |--------------------------------------------------------------------------
    */

        if ($categoria_id !== 'todos') {
            $consulta->where('p.categoria_id', $categoria_id);
        }

        if ($marca_id !== 'todos') {
            $consulta->where('p.marca_id', $marca_id);
        }

        if ($unidad_medida_id !== 'todos') {
            $consulta->where(
                'p.unidad_medida_id',
                $unidad_medida_id
            );
        }

        if ($almacen_id !== 'todos') {
            $consulta->where('v.almacen_id', $almacen_id);
        }

        $productos = $consulta
            ->groupBy(
                'p.id',
                'p.nombre',
                'c.nombre',
                'm.nombre',
                'um.nombre'
            )
            ->orderBy('p.nombre')
            ->get()
            ->map(function ($producto) {
                $producto->cantidad_vendida =
                    (float) $producto->cantidad_vendida;

                $producto->ingreso_bruto =
                    (float) $producto->ingreso_bruto;

                $producto->costo_ventas =
                    (float) $producto->costo_ventas;

                $producto->utilidad_bruta =
                    $producto->ingreso_bruto - $producto->costo_ventas;

                return $producto;
            });

        /*
    |--------------------------------------------------------------------------
    | Nombre del almacén para el encabezado
    |--------------------------------------------------------------------------
    */

        $nombreAlmacen = 'TODOS LOS ALMACENES';

        if ($almacen_id !== 'todos') {
            $nombreAlmacen = Almacen::whereKey($almacen_id)
                ->value('nombre') ?? 'ALMACÉN NO ENCONTRADO';
        }

        return [
            'productos' => $productos,
            'nombreAlmacen' => $nombreAlmacen,
            'totales' => [
                'cantidad_vendida' => $productos->sum('cantidad_vendida'),
                'ingreso_bruto' => $productos->sum('ingreso_bruto'),
                'costo_ventas' => $productos->sum('costo_ventas'),
                'utilidad_bruta' => $productos->sum('utilidad_bruta'),
            ],
        ];
    }


    public function generarExcelIngresoBrutoProductos(array $datos)
    {
        $productos = $datos['productos'];
        $nombreAlmacen = $datos['nombreAlmacen'];
        $totales = $datos['totales'];

        $spreadsheet = new Spreadsheet();
        $hoja = $spreadsheet->getActiveSheet();

        $hoja->setTitle('Ingreso bruto productos');

        // Ancho de columnas.
        $hoja->getColumnDimension('A')->setWidth(8);
        $hoja->getColumnDimension('B')->setWidth(35);
        $hoja->getColumnDimension('C')->setWidth(22);
        $hoja->getColumnDimension('D')->setWidth(20);
        $hoja->getColumnDimension('E')->setWidth(18);
        $hoja->getColumnDimension('F')->setWidth(16);
        $hoja->getColumnDimension('G')->setWidth(18);
        $hoja->getColumnDimension('H')->setWidth(18);
        $hoja->getColumnDimension('I')->setWidth(18);
        $hoja->getColumnDimension('J')->setWidth(18);

        // Título.
        $hoja->mergeCells('A1:J1');
        $hoja->setCellValue('A1', 'REPORTE DE INGRESO BRUTO POR PRODUCTO');

        $hoja->getStyle('A1:J1')->applyFromArray([
            'font' => [
                'bold' => true,
                'size' => 16,
            ],
            'alignment' => [
                'horizontal' => Alignment::HORIZONTAL_CENTER,
                'vertical' => Alignment::VERTICAL_CENTER,
            ],
        ]);

        $hoja->getRowDimension(1)->setRowHeight(30);

        // Almacén.
        $hoja->mergeCells('A2:J2');
        $hoja->setCellValue('A2', 'ALMACÉN: ' . $nombreAlmacen);

        $hoja->getStyle('A2:J2')->applyFromArray([
            'font' => [
                'bold' => true,
                'size' => 12,
            ],
            'alignment' => [
                'horizontal' => Alignment::HORIZONTAL_CENTER,
            ],
        ]);

        // Encabezados.
        $encabezados = [
            'N°',
            'Producto',
            'Categoría',
            'Marca',
            'Unidad',
            'Cantidad vendida',
            'Ingreso bruto',
            'Costo de ventas',
            'Utilidad bruta',
            '% Utilidad',
        ];

        $filaEncabezado = 4;

        foreach ($encabezados as $indice => $encabezado) {
            $columna = chr(65 + $indice);
            $hoja->setCellValue(
                $columna . $filaEncabezado,
                $encabezado
            );
        }

        $hoja->getStyle('A4:J4')->applyFromArray([
            'font' => [
                'bold' => true,
                'color' => ['rgb' => 'FFFFFF'],
            ],
            'fill' => [
                'fillType' => Fill::FILL_SOLID,
                'startColor' => ['rgb' => '244062'],
            ],
            'alignment' => [
                'horizontal' => Alignment::HORIZONTAL_CENTER,
                'vertical' => Alignment::VERTICAL_CENTER,
                'wrapText' => true,
            ],
            'borders' => [
                'allBorders' => [
                    'borderStyle' => Border::BORDER_THIN,
                ],
            ],
        ]);

        $fila = 5;
        $numero = 1;

        foreach ($productos as $producto) {
            $ingresoBruto = (float) $producto->ingreso_bruto;
            $costoVentas = (float) $producto->costo_ventas;
            $utilidadBruta = (float) $producto->utilidad_bruta;

            $porcentajeUtilidad = $ingresoBruto != 0
                ? ($utilidadBruta / $ingresoBruto) * 100
                : 0;

            $valores = [
                $numero++,
                $producto->producto,
                $producto->categoria ?? '',
                $producto->marca ?? '',
                $producto->unidad_medida ?? '',
                (float) $producto->cantidad_vendida,
                $ingresoBruto,
                $costoVentas,
                $utilidadBruta,
                $porcentajeUtilidad / 100,
            ];

            foreach ($valores as $indice => $valor) {
                $columna = chr(65 + $indice);
                $hoja->setCellValue(
                    $columna . $fila,
                    $valor
                );
            }

            $fila++;
        }

        // Fila de totales.
        $hoja->setCellValue('A' . $fila, 'TOTALES');
        $hoja->mergeCells("A{$fila}:E{$fila}");

        $hoja->setCellValue(
            'F' . $fila,
            (float) $totales['cantidad_vendida']
        );
        $hoja->setCellValue(
            'G' . $fila,
            (float) $totales['ingreso_bruto']
        );
        $hoja->setCellValue(
            'H' . $fila,
            (float) $totales['costo_ventas']
        );
        $hoja->setCellValue(
            'I' . $fila,
            (float) $totales['utilidad_bruta']
        );

        $porcentajeTotal = (float) $totales['ingreso_bruto'] != 0
            ? $totales['utilidad_bruta'] / $totales['ingreso_bruto']
            : 0;

        $hoja->setCellValue('J' . $fila, $porcentajeTotal);

        $hoja->getStyle("A{$fila}:J{$fila}")->applyFromArray([
            'font' => ['bold' => true],
            'fill' => [
                'fillType' => Fill::FILL_SOLID,
                'startColor' => ['rgb' => 'D9EAF7'],
            ],
            'borders' => [
                'allBorders' => [
                    'borderStyle' => Border::BORDER_THIN,
                ],
            ],
        ]);

        // Formatos numéricos.
        if ($fila > 5) {
            $hoja->getStyle("F5:F{$fila}")
                ->getNumberFormat()
                ->setFormatCode('#,##0.00');

            $hoja->getStyle("G5:I{$fila}")
                ->getNumberFormat()
                ->setFormatCode('"Bs " #,##0.00');

            $hoja->getStyle("J5:J{$fila}")
                ->getNumberFormat()
                ->setFormatCode('0.00%');

            $hoja->getStyle("A5:J{$fila}")->applyFromArray([
                'borders' => [
                    'allBorders' => [
                        'borderStyle' => Border::BORDER_THIN,
                        'color' => ['rgb' => 'D9D9D9'],
                    ],
                ],
            ]);
        }

        // Mantener visibles los encabezados al desplazarse.
        $hoja->freezePane('A5');

        // Mostrar las flechas de filtro en los encabezados.
        $hoja->setAutoFilter("A4:J" . max(4, $fila - 1));

        $nombreArchivo = 'ingreso_bruto_productos_'
            . now()->format('Ymd_His')
            . '.xlsx';

        $writer = new Xlsx($spreadsheet);

        return response()->streamDownload(
            function () use ($writer) {
                $writer->save('php://output');
            },
            $nombreArchivo,
            [
                'Content-Type' =>
                'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
            ]
        );
    }

    public function generarPdfIngresoBrutoProductos(array $datos)
    {
        $productos = $datos['productos'];
        $nombreAlmacen = $datos['nombreAlmacen'];
        $totales = $datos['totales'];

        $pdf = new ReporteServiceTcpdf();

        $pdf->SetTitle('Ingreso bruto por producto');
        $pdf->SetMargins(8, 12, 8);
        $pdf->SetAutoPageBreak(true, 12);
        $pdf->AddPage('L', 'A4');

        $pdf->SetFont('helvetica', 'B', 14);
        $pdf->Cell(
            0,
            8,
            'REPORTE DE INGRESO BRUTO POR PRODUCTO',
            0,
            1,
            'C'
        );

        $pdf->SetFont('helvetica', 'B', 10);
        $pdf->Cell(
            0,
            7,
            'ALMACÉN: ' . $nombreAlmacen,
            0,
            1,
            'C'
        );

        $pdf->Ln(3);

        $encabezados = [
            ['NRO', 10],
            ['PRODUCTO', 55],
            ['CATEGORÍA', 35],
            ['MARCA', 35],
            ['UNIDAD', 22],
            ['CANTIDAD', 20],
            ['INGRESO BRUTO BS.', 30],
            ['COSTO VENTAS BS.', 30],
            ['UTILIDAD BRUTA BS.', 30],
            ['% UTILIDAD', 20],
        ];

        $anchoTotal = array_sum(array_column($encabezados, 1));

        $pdf->SetFont('helvetica', 'B', 8);
        $pdf->SetFillColor(36, 64, 98);
        $pdf->SetTextColor(255, 255, 255);
        $pdf->setY(33);

        foreach ($encabezados as [$titulo, $ancho]) {
            $pdf->Cell(
                $ancho,
                9,
                $titulo,
                1,
                0,
                'C',
                true
            );
        }

        $pdf->Ln();

        $pdf->SetFont('helvetica', '', 8);
        $pdf->SetTextColor(0, 0, 0);
        $pdf->SetFillColor(245, 245, 245);

        $numero = 1;
        $alternar = false;

        foreach ($productos as $producto) {
            $ingresoBruto = (float) $producto->ingreso_bruto;
            $costoVentas = (float) $producto->costo_ventas;
            $utilidadBruta = (float) $producto->utilidad_bruta;
            $porcentajeUtilidad = $ingresoBruto != 0
                ? ($utilidadBruta / $ingresoBruto) * 100
                : 0;
            $valores = [
                (string) $numero++,
                $producto->producto,
                $producto->categoria ?? '',
                $producto->marca ?? '',
                $producto->unidad_medida ?? '',
                (float) $producto->cantidad_vendida,
                number_format(
                    (float) $ingresoBruto,
                    2,
                    '.',
                    ''
                ),
                number_format(
                    (float) $costoVentas,
                    2,
                    '.',
                    ''
                ),
                number_format(
                    (float) $utilidadBruta,
                    2,
                    '.',
                    ''
                ),
                round($porcentajeUtilidad, 2),
            ];

            foreach ($encabezados as $indice => [$titulo, $ancho]) {
                $alineacion = $indice >= 5 ? 'R' : 'L';

                $pdf->Cell(
                    $ancho,
                    7,
                    $valores[$indice],
                    1,
                    0,
                    $alineacion,
                    $alternar
                );
            }

            $pdf->Ln();
            $alternar = !$alternar;
        }

        // Totales.
        $pdf->SetFont('helvetica', 'B', 8);
        $pdf->SetFillColor(217, 234, 247);

        $pdf->Cell(
            157,
            8,
            'TOTALES',
            1,
            0,
            'R',
            true
        );

        $pdf->Cell(
            20,
            8,
            number_format(
                (float) $totales['cantidad_vendida'],
                2,
                '.',
                ''
            ),
            1,
            0,
            'R',
            true
        );

        $pdf->Cell(
            30,
            8,
            number_format(
                (float) $totales['ingreso_bruto'],
                2,
                '.',
                ''
            ),
            1,
            0,
            'R',
            true
        );

        $pdf->Cell(
            30,
            8,
            number_format(
                (float) $totales['costo_ventas'],
                2,
                '.',
                ''
            ),
            1,
            0,
            'R',
            true
        );

        $pdf->Cell(
            30,
            8,
            number_format(
                (float) $totales['utilidad_bruta'],
                2,
                '.',
                ''
            ),
            1,
            0,
            'R',
            true
        );
        $porcentajeTotal = (float) $totales['ingreso_bruto'] != 0
            ? ($totales['utilidad_bruta'] / $totales['ingreso_bruto']) * 100
            : 0;

        $pdf->Cell(
            20,
            8,
            number_format($porcentajeTotal, 2, ',', '.') . '%',
            1,
            1,
            'R',
            true
        );

        $nombreArchivo = 'ingreso_bruto_productos_'
            . now()->format('Ymd_His')
            . '.pdf';

        $contenido = $pdf->Output($nombreArchivo, 'S');

        return response($contenido, 200, [
            'Content-Type' => 'application/pdf',
            'Content-Disposition' =>
            'inline; filename="' . $nombreArchivo . '"',
        ]);
    }
}
