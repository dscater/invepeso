<?php

namespace App\Http\Controllers;

use App\Models\Almacen;
use App\Models\Certificado;
use App\Models\CertificadoDetalle;
use App\Models\Cliente;
use App\Models\Configuracion;
use App\Models\HistorialAccion;
use App\Models\IngresoPago;
use App\Models\IngresoProducto;
use App\Models\Inscripcion;
use App\Models\KardexProducto;
use App\Models\Pago;
use App\Models\Producto;
use App\Models\Proforma;
use App\Models\Proveedor;
use App\Models\SalidaDetalle;
use App\Models\SalidaProducto;
use App\Models\TipoCertificado;
use App\Models\User;
use App\Models\Venta;
use App\Models\VentaCobro;
use App\Services\AlmacenService;
use App\Services\CategoriaService;
use App\Services\KardexProductoService;
use App\Services\MarcaService;
use App\Services\MovimientoCajaService;
use App\Services\PagoService;
use App\Services\ProveedorService;
use App\Services\ReporteService;
use App\Services\ReporteServiceTcpdf;
use App\Services\TipoCompraService;
use App\Services\TipoPagoService;
use App\Services\TipoVentaService;
use App\Services\UnidadMedidaService;
use App\Services\UserService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;
use Inertia\Inertia;
use PDF;
use Carbon\Carbon;
use FPDF;
use Illuminate\Support\Facades\DB;
use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\IOFactory;
use PhpOffice\PhpSpreadsheet\Worksheet\PageSetup;
use PhpOffice\PhpSpreadsheet\Worksheet\Drawing;
use PhpOffice\PhpSpreadsheet\Cell\Coordinate;

class ReporteController extends Controller
{
    public $titulo = [
        'font' => [
            'bold' => true,
            'size' => 12,
            'family' => 'Times New Roman'
        ],
        'borders' => [
            'allBorders' => [
                'borderStyle' => \PhpOffice\PhpSpreadsheet\Style\Border::BORDER_NONE,
            ],
        ],
    ];

    public $textoBold = [
        'font' => [
            'bold' => true,
            'size' => 10,
        ],
    ];

    public $headerTabla = [
        'font' => [
            'bold' => true,
            'size' => 10,
            'color' => ['argb' => 'ffffff'],
        ],
        'alignment' => [
            'vertical' => \PhpOffice\PhpSpreadsheet\Style\Alignment::VERTICAL_CENTER,
        ],
        'borders' => [
            'allBorders' => [
                'borderStyle' => \PhpOffice\PhpSpreadsheet\Style\Border::BORDER_THIN,
            ],
        ],
        'fill' => [
            'fillType' => \PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID,
            'color' => ['rgb' => '203764']
        ],
    ];

    public $headerTablaRed = [
        'font' => [
            'bold' => true,
            'size' => 10,
            'color' => ['argb' => 'ffffff'],
        ],
        'alignment' => [
            'vertical' => \PhpOffice\PhpSpreadsheet\Style\Alignment::VERTICAL_CENTER,
        ],
        'borders' => [
            'allBorders' => [
                'borderStyle' => \PhpOffice\PhpSpreadsheet\Style\Border::BORDER_THIN,
            ],
        ],
        'fill' => [
            'fillType' => \PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID,
            'color' => ['rgb' => 'f02222']
        ],
    ];

    public $headerTabla2 = [
        'font' => [
            'bold' => true,
            'size' => 10,
            'color' => ['argb' => '000000'],
        ],
        'alignment' => [
            'vertical' => \PhpOffice\PhpSpreadsheet\Style\Alignment::VERTICAL_CENTER,
        ],
        'borders' => [
            'allBorders' => [
                'borderStyle' => \PhpOffice\PhpSpreadsheet\Style\Border::BORDER_THIN,
            ],
        ],
    ];

    public $bodyTabla = [
        'font' => [
            'size' => 10,
        ],
        'alignment' => [
            'vertical' => \PhpOffice\PhpSpreadsheet\Style\Alignment::VERTICAL_CENTER,
            // 'horizontal' => \PhpOffice\PhpSpreadsheet\Style\Alignment::HORIZONTAL_CENTER,
        ],
        'borders' => [
            'allBorders' => [
                'borderStyle' => \PhpOffice\PhpSpreadsheet\Style\Border::BORDER_THIN,
            ],
        ],
    ];

    public $textLeft = [
        'alignment' => [
            'horizontal' => \PhpOffice\PhpSpreadsheet\Style\Alignment::HORIZONTAL_LEFT,
        ],
    ];

    public $textRight = [
        'alignment' => [
            'horizontal' => \PhpOffice\PhpSpreadsheet\Style\Alignment::HORIZONTAL_RIGHT,
        ],
    ];

    public $textCenter = [
        'alignment' => [
            'horizontal' => \PhpOffice\PhpSpreadsheet\Style\Alignment::HORIZONTAL_CENTER,
        ],
    ];

    public $bg0 = [
        'fill' => [
            'fillType' => \PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID,
            'color' => ['rgb' => 'cff3f3']
        ],
    ];

    public $bg1 = [
        'fill' => [
            'fillType' => \PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID,
            'color' => ['rgb' => 'ffe9ff']
        ],
    ];

    public $bg2 = [
        'fill' => [
            'fillType' => \PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID,
            'color' => ['rgb' => 'f7ffe0']
        ],
    ];

    public $bg3 = [
        'fill' => [
            'fillType' => \PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID,
            'color' => ['rgb' => 'ecfcdd']
        ],
    ];

    public $bg4 = [
        'fill' => [
            'fillType' => \PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID,
            'color' => ['rgb' => 'faeee4']
        ],
    ];

    private $configuracion = null;
    public function __construct(
        private MovimientoCajaService $movimiento_caja_service,
        private KardexProductoService $kardex_producto_service,
        private AlmacenService $almacen_service,
        private ProveedorService $proveedor_service,
        private CategoriaService $categoria_service,
        private MarcaService $marca_service,
        private UnidadMedidaService $unidad_medida_service,
        private TipoVentaService $tipo_venta_service,
        private TipoPagoService $tipo_pago_service,
        private TipoCompraService $tipo_compra_service,
        private UserService $user_service,
    ) {
        $this->configuracion = Configuracion::first();
        if (!$this->configuracion) {
            $this->configuracion = new Configuracion([
                "nombre_sistema" => "MEDINTER S.A.",
                "alias" => "MD",
                "logo" => "logo.png",
                "fono" => "2222222",
                "dir" => "LOS OLIVOS",
            ]);
        }
    }

    public function usuarios()
    {
        return Inertia::render("Admin/Reportes/Usuarios");
    }

    public function r_usuarios(Request $request)
    {
        ini_set('memory_limit', '1024M');
        set_time_limit(-1);
        $role_id =  $request->role_id;
        $tipo =  $request->tipo;
        $sucursal_id =  $request->sucursal_id;
        $formato =  $request->formato;
        $usuarios = User::select("users.*")
            ->where('id', '!=', 1);

        if ($tipo != 'todos') {
            $usuarios->where('tipo', $tipo);
        }

        if ($role_id != 'todos') {
            $usuarios->where('role_id', $role_id);
        }

        if ($sucursal_id != 'todos') {
            $usuarios->where('sucursal_id', $sucursal_id);
        }

        $usuarios = $usuarios->get();

        if ($formato == 'pdf') {
            $pdf = PDF::loadView('reportes.usuarios', compact('usuarios'))->setPaper('legal', 'landscape');

            // ENUMERAR LAS PÁGINAS USANDO CANVAS
            $pdf->output();
            $dom_pdf = $pdf->getDomPDF();
            $canvas = $dom_pdf->get_canvas();
            $alto = $canvas->get_height();
            $ancho = $canvas->get_width();
            $canvas->page_text($ancho - 90, $alto - 25, "Página {PAGE_NUM} de {PAGE_COUNT}", null, 9, array(0, 0, 0));

            return $pdf->stream('usuarios.pdf');
        } else {
            $spreadsheet = new Spreadsheet();
            $spreadsheet->getProperties()
                ->setCreator("ADMIN")
                ->setLastModifiedBy('Administración')
                ->setTitle('Registros')
                ->setSubject('Registros')
                ->setDescription('Registros')
                ->setKeywords('PHPSpreadsheet')
                ->setCategory('Listado');

            $sheet = $spreadsheet->getActiveSheet();

            $spreadsheet->getDefaultStyle()->getFont()->setName('Arial');

            $fila = 1;
            if (file_exists(public_path() . '/imgs/' . $this->configuracion->logo)) {
                $drawing = new \PhpOffice\PhpSpreadsheet\Worksheet\Drawing();
                $drawing->setName('logo');
                $drawing->setDescription('logo');
                $drawing->setPath(public_path() . '/imgs/' . $this->configuracion->logo); // put your path and image here
                $drawing->setCoordinates('A' . $fila);
                $drawing->setOffsetX(5);
                $drawing->setOffsetY(0);
                $drawing->setHeight(70);
                $drawing->setWorksheet($sheet);
            }

            $fila = 2;
            $sheet->setCellValue('A' . $fila, $this->configuracion->nombre_sistema);
            $sheet->mergeCells("A" . $fila . ":M" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':M' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':M' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $sheet->setCellValue('A' . $fila, "LISTA DE USUARIOS");
            $sheet->mergeCells("A" . $fila . ":M" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':M' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':M' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $fila++;
            $sheet->setCellValue('A' . $fila, 'N°');
            $sheet->setCellValue('B' . $fila, 'USUARIO');
            $sheet->setCellValue('C' . $fila, 'PATERNO');
            $sheet->setCellValue('D' . $fila, 'MATERNO');
            $sheet->setCellValue('E' . $fila, 'NOMBRE(S)');
            $sheet->setCellValue('F' . $fila, 'C.I.');
            $sheet->setCellValue('G' . $fila, 'DIRECCIÓN');
            $sheet->setCellValue('H' . $fila, 'CORREO');
            $sheet->setCellValue('I' . $fila, 'TELÉFONO/CELULAR');
            $sheet->setCellValue('J' . $fila, 'TIPO');
            $sheet->setCellValue('K' . $fila, 'ROLE');
            $sheet->setCellValue('L' . $fila, 'SUCURSAL');
            $sheet->setCellValue('M' . $fila, 'ACCESO');
            $sheet->getStyle('A' . $fila . ':M' . $fila)->applyFromArray($this->headerTabla);
            $fila++;

            foreach ($usuarios as $key => $item) {
                $sheet->setCellValue('A' . $fila, $key + 1);
                $sheet->setCellValue('B' . $fila, $item->usuario);
                $sheet->setCellValue('C' . $fila, $item->paterno);
                $sheet->setCellValue('D' . $fila, $item->materno);
                $sheet->setCellValue('E' . $fila, $item->nombre);
                $sheet->setCellValue('F' . $fila, $item->full_ci);
                $sheet->setCellValue('G' . $fila, $item->dir);
                $sheet->setCellValue('H' . $fila, $item->correo);
                $sheet->setCellValue('I' . $fila, $item->fono);
                $sheet->setCellValue('J' . $fila, $item->tipo);
                $sheet->setCellValue('K' . $fila, $item->role->nombre);
                $sheet->setCellValue('L' . $fila, $item->sucursal?->nombre);
                $sheet->setCellValue('M' . $fila, $item->acceso == 1 ? 'HABILITADO' : 'DENEGADO');
                $sheet->getStyle('A' . $fila . ':M' . $fila)->applyFromArray($this->bodyTabla);
                $fila++;
            }

            $sheet->getColumnDimension('A')->setWidth(6);
            $sheet->getColumnDimension('B')->setWidth(20);
            $sheet->getColumnDimension('C')->setWidth(15);
            $sheet->getColumnDimension('D')->setWidth(10);
            $sheet->getColumnDimension('E')->setWidth(15);
            $sheet->getColumnDimension('F')->setWidth(20);
            $sheet->getColumnDimension('G')->setWidth(15);
            $sheet->getColumnDimension('H')->setWidth(15);
            $sheet->getColumnDimension('I')->setWidth(15);
            $sheet->getColumnDimension('J')->setWidth(15);
            $sheet->getColumnDimension('K')->setWidth(15);
            $sheet->getColumnDimension('L')->setWidth(15);
            $sheet->getColumnDimension('M')->setWidth(15);

            foreach (range('A', 'M') as $columnID) {
                $sheet->getStyle($columnID)->getAlignment()->setWrapText(true);
            }

            $sheet->getPageSetup()->setOrientation(\PhpOffice\PhpSpreadsheet\Worksheet\PageSetup::ORIENTATION_LANDSCAPE);
            $sheet->getPageMargins()->setTop(0.5);
            $sheet->getPageMargins()->setRight(0.1);
            $sheet->getPageMargins()->setLeft(0.1);
            $sheet->getPageMargins()->setBottom(0.1);
            $sheet->getPageSetup()->setPrintArea('A:M');
            $sheet->getPageSetup()->setFitToWidth(1);
            $sheet->getPageSetup()->setFitToHeight(0);

            return response()->streamDownload(
                function () use ($spreadsheet) {
                    $writer = IOFactory::createWriter($spreadsheet, 'Xlsx');
                    $writer->save('php://output');
                },
                'usuarios_' . time() . '.xlsx',
                [
                    'Content-Type' => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                ]
            );
        }
    }

    public function clientes()
    {
        return Inertia::render("Admin/Reportes/Clientes");
    }

    public function r_clientes(Request $request)
    {
        ini_set('memory_limit', '1024M');
        set_time_limit(-1);
        $fecha_ini =  $request->fecha_ini;
        $fecha_fin =  $request->fecha_fin;
        $formato =  $request->formato;
        $clientes = Cliente::select("clientes.*");

        if ($fecha_ini && $fecha_fin) {
            $clientes->whereBetween('fecha_registro', [$fecha_ini, $fecha_fin]);
        }

        $clientes = $clientes->get();

        if ($formato == 'pdf') {
            $pdf = new ReporteServiceTcpdf();
            $pdf->SetTitle('Lista de Clientes');
            $pdf->setMargins(10, 5, 5);
            $pdf->AddPage();
            $pdf->setPrintHeader(false);
            $pdf->setY(13);
            $pdf->SetFont('helvetica', 'B', 12);
            $pdf->Cell(0, 6, "LISTA DE CLIENTES", 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 10);
            $pdf->Cell(0, 5, "Expedido: " . date("d/m/Y"), 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 8);
            $pdf->setY(33);
            $alto = 10;
            $font_size = 8;
            $font_size2 = 9;

            $pdf->setFont("helvetica", "B", $font_size2);
            $pdf->cellAutoFontSize($pdf, 12, $alto, 'NRO', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 35, $alto, 'NOMBRE', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 25, $alto, 'DOCUMENTO', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 25, $alto, 'NRO. DOCUMENTO', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 25, $alto, 'TELÉFONO/CELULAR', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 45, $alto, 'CORREO', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 25, $alto, 'FECHA DE REGISTRO', $font_size, 5, 'B');
            $pdf->Ln();
            $cont = 1;
            foreach ($clientes as $item) {
                $pdf->cellAutoFontSize($pdf, 12, $alto, $cont++, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 35, $alto, $item->nombre, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 25, $alto, $item->tipo_documento->nombre, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 25, $alto, $item->full_ci, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 25, $alto, $item->fono, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 45, $alto, $item->correo, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 25, $alto, $item->fecha_registro_t, $font_size, 5, 'N', 'L');
                $pdf->Ln();
            }
            // Guardar PDF o forzar descarga
            return response($pdf->Output('S'), 200)
                ->header('Content-Type', 'application/pdf')
                ->header('Content-Disposition', 'inline; filename="clientes' . time() . '.pdf"');
        } else {
            $spreadsheet = new Spreadsheet();
            $spreadsheet->getProperties()
                ->setCreator("ADMIN")
                ->setLastModifiedBy('Administración')
                ->setTitle('Registros')
                ->setSubject('Registros')
                ->setDescription('Registros')
                ->setKeywords('PHPSpreadsheet')
                ->setCategory('Listado');

            $sheet = $spreadsheet->getActiveSheet();

            $spreadsheet->getDefaultStyle()->getFont()->setName('Arial');

            $fila = 1;
            if (file_exists(public_path() . '/imgs/' . $this->configuracion->logo)) {
                $drawing = new \PhpOffice\PhpSpreadsheet\Worksheet\Drawing();
                $drawing->setName('logo');
                $drawing->setDescription('logo');
                $drawing->setPath(public_path() . '/imgs/' . $this->configuracion->logo); // put your path and image here
                $drawing->setCoordinates('A' . $fila);
                $drawing->setOffsetX(5);
                $drawing->setOffsetY(0);
                $drawing->setHeight(70);
                $drawing->setWorksheet($sheet);
            }

            $fila = 2;
            $sheet->setCellValue('A' . $fila, $this->configuracion->nombre_sistema);
            $sheet->mergeCells("A" . $fila . ":G" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':G' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':G' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $sheet->setCellValue('A' . $fila, "LISTA DE CLIENTES");
            $sheet->mergeCells("A" . $fila . ":G" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':G' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':G' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $fila++;
            $sheet->setCellValue('A' . $fila, 'NRO');
            $sheet->setCellValue('B' . $fila, 'NOMBRE');
            $sheet->setCellValue('C' . $fila, 'DOCUMENTO');
            $sheet->setCellValue('D' . $fila, 'NRO. DOCUMENTO');
            $sheet->setCellValue('E' . $fila, 'TELÉFONO/CELULAR');
            $sheet->setCellValue('F' . $fila, 'CORREO');
            $sheet->setCellValue('G' . $fila, 'FECHA DE REGISTRO');
            $sheet->getStyle('A' . $fila . ':G' . $fila)->applyFromArray($this->headerTabla);
            $fila++;

            foreach ($clientes as $key => $item) {
                $sheet->setCellValue('A' . $fila, $key + 1);
                $sheet->setCellValue('B' . $fila, $item->nombre);
                $sheet->setCellValue('C' . $fila, $item->tipo_documento->nombre);
                $sheet->setCellValue('D' . $fila, $item->nro_documento);
                $sheet->setCellValue('E' . $fila, $item->fono);
                $sheet->setCellValue('F' . $fila, $item->correo);
                $sheet->setCellValue('G' . $fila, $item->fecha_registro_t);
                $sheet->getStyle('A' . $fila . ':G' . $fila)->applyFromArray($this->bodyTabla);
                $fila++;
            }

            $sheet->getColumnDimension('A')->setWidth(6);
            $sheet->getColumnDimension('B')->setWidth(25);
            $sheet->getColumnDimension('C')->setWidth(10);
            $sheet->getColumnDimension('D')->setWidth(25);
            $sheet->getColumnDimension('E')->setWidth(15);
            $sheet->getColumnDimension('F')->setWidth(39);
            $sheet->getColumnDimension('G')->setWidth(10);

            foreach (range('A', 'G') as $columnID) {
                $sheet->getStyle($columnID)->getAlignment()->setWrapText(true);
            }

            $sheet->getPageSetup()->setOrientation(\PhpOffice\PhpSpreadsheet\Worksheet\PageSetup::ORIENTATION_DEFAULT);
            $sheet->getPageMargins()->setTop(0.5);
            $sheet->getPageMargins()->setRight(0.1);
            $sheet->getPageMargins()->setLeft(0.1);
            $sheet->getPageMargins()->setBottom(0.1);
            $sheet->getPageSetup()->setPrintArea('A:G');
            $sheet->getPageSetup()->setFitToWidth(1);
            $sheet->getPageSetup()->setFitToHeight(0);

            return response()->streamDownload(
                function () use ($spreadsheet) {
                    $writer = IOFactory::createWriter($spreadsheet, 'Xlsx');
                    $writer->save('php://output');
                },
                'clientes_' . time() . '.xlsx',
                [
                    'Content-Type' => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                ]
            );
        }
    }

    public function proveedors()
    {
        return Inertia::render("Admin/Reportes/Proveedors");
    }

    public function r_proveedors(Request $request)
    {
        ini_set('memory_limit', '1024M');
        set_time_limit(-1);
        $fecha_ini =  $request->fecha_ini;
        $fecha_fin =  $request->fecha_fin;
        $formato =  $request->formato;
        $proveedors = Proveedor::select("proveedors.*");

        $proveedors = $proveedors->get();

        if ($formato == 'pdf') {
            $pdf = new ReporteServiceTcpdf();
            $pdf->SetTitle('Lista de Proveedores');
            $pdf->setMargins(23, 5, 5);
            $pdf->AddPage();
            $pdf->setPrintHeader(false);
            $pdf->setY(13);
            $pdf->SetFont('helvetica', 'B', 12);
            $pdf->Cell(0, 6, "LISTA DE PROVEEDORES", 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 10);
            $pdf->Cell(0, 5, "Expedido: " . date("d/m/Y"), 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 8);
            $pdf->setY(33);
            $alto = 10;
            $font_size = 8;
            $font_size2 = 9;

            $pdf->setFont("helvetica", "B", $font_size2);
            $pdf->cellAutoFontSize($pdf, 12, $alto, 'NRO', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 85, $alto, 'NOMBRE', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 65, $alto, 'CONTACTO', $font_size2, 5, 'B');
            $pdf->Ln();
            $cont = 1;
            foreach ($proveedors as $item) {
                $pdf->cellAutoFontSize($pdf, 12, $alto, $cont++, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 85, $alto, $item->nombre, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 65, $alto, $item->contacto, $font_size, 5, 'N', 'L');
                $pdf->Ln();
            }
            // Guardar PDF o forzar descarga
            return response($pdf->Output('S'), 200)
                ->header('Content-Type', 'application/pdf')
                ->header('Content-Disposition', 'inline; filename="proveedors' . time() . '.pdf"');
        } else {
            $spreadsheet = new Spreadsheet();
            $spreadsheet->getProperties()
                ->setCreator("ADMIN")
                ->setLastModifiedBy('Administración')
                ->setTitle('Registros')
                ->setSubject('Registros')
                ->setDescription('Registros')
                ->setKeywords('PHPSpreadsheet')
                ->setCategory('Listado');

            $sheet = $spreadsheet->getActiveSheet();

            $spreadsheet->getDefaultStyle()->getFont()->setName('Arial');

            $fila = 1;
            if (file_exists(public_path() . '/imgs/' . $this->configuracion->logo)) {
                $drawing = new \PhpOffice\PhpSpreadsheet\Worksheet\Drawing();
                $drawing->setName('logo');
                $drawing->setDescription('logo');
                $drawing->setPath(public_path() . '/imgs/' . $this->configuracion->logo); // put your path and image here
                $drawing->setCoordinates('A' . $fila);
                $drawing->setOffsetX(5);
                $drawing->setOffsetY(0);
                $drawing->setHeight(70);
                $drawing->setWorksheet($sheet);
            }

            $fila = 2;
            $sheet->setCellValue('A' . $fila, $this->configuracion->nombre_sistema);
            $sheet->mergeCells("A" . $fila . ":C" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':C' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':C' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $sheet->setCellValue('A' . $fila, "LISTA DE PROVEEDORES");
            $sheet->mergeCells("A" . $fila . ":C" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':C' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':C' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $fila++;
            $sheet->setCellValue('A' . $fila, 'NRO');
            $sheet->setCellValue('B' . $fila, 'NOMBRE');
            $sheet->setCellValue('C' . $fila, 'CONTACTO');
            $sheet->getStyle('A' . $fila . ':C' . $fila)->applyFromArray($this->headerTabla);
            $fila++;

            foreach ($proveedors as $key => $item) {
                $sheet->setCellValue('A' . $fila, $key + 1);
                $sheet->setCellValue('B' . $fila, $item->nombre);
                $sheet->setCellValue('C' . $fila, $item->contacto);
                $sheet->getStyle('A' . $fila . ':C' . $fila)->applyFromArray($this->bodyTabla);
                $fila++;
            }

            $sheet->getColumnDimension('A')->setWidth(6);
            $sheet->getColumnDimension('B')->setWidth(85);
            $sheet->getColumnDimension('C')->setWidth(65);

            foreach (range('A', 'C') as $columnID) {
                $sheet->getStyle($columnID)->getAlignment()->setWrapText(true);
            }

            $sheet->getPageSetup()->setOrientation(\PhpOffice\PhpSpreadsheet\Worksheet\PageSetup::ORIENTATION_DEFAULT);
            $sheet->getPageMargins()->setTop(0.5);
            $sheet->getPageMargins()->setRight(0.1);
            $sheet->getPageMargins()->setLeft(0.1);
            $sheet->getPageMargins()->setBottom(0.1);
            $sheet->getPageSetup()->setPrintArea('A:C');
            $sheet->getPageSetup()->setFitToWidth(1);
            $sheet->getPageSetup()->setFitToHeight(0);

            return response()->streamDownload(
                function () use ($spreadsheet) {
                    $writer = IOFactory::createWriter($spreadsheet, 'Xlsx');
                    $writer->save('php://output');
                },
                'proveedors_' . time() . '.xlsx',
                [
                    'Content-Type' => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                ]
            );
        }
    }

    public function productos()
    {
        return Inertia::render("Admin/Reportes/Productos");
    }

    public function r_productos(Request $request)
    {
        ini_set('memory_limit', '1024M');
        set_time_limit(-1);
        $categoria_id =  $request->categoria_id;
        $marca_id =  $request->marca_id;
        $unidad_medida_id =  $request->unidad_medida_id;
        $fecha_ini =  $request->fecha_ini;
        $fecha_fin =  $request->fecha_fin;
        $formato =  $request->formato;
        $productos = Producto::select("productos.*");

        if ($categoria_id && $categoria_id != 'todos') {
            $productos->where('categoria_id', $categoria_id);
        }

        if ($marca_id && $marca_id != 'todos') {
            $productos->where('marca_id', $marca_id);
        }

        if ($unidad_medida_id && $unidad_medida_id != 'todos') {
            $productos->where('unidad_medida_id', $unidad_medida_id);
        }

        if ($fecha_ini && $fecha_fin) {
            $productos->whereBetween('fecha_registro', [$fecha_ini, $fecha_fin]);
        }

        $productos = $productos->get();

        if ($formato == 'pdf') {
            $pdf = new ReporteServiceTcpdf();
            $pdf->SetTitle('Lista de Productos');
            $pdf->setMargins(1, 2, 2);
            $pdf->AddPage('L', 'LEGAL');
            $pdf->setPrintHeader(false);
            $pdf->setY(13);
            $pdf->SetFont('helvetica', 'B', 12);
            $pdf->Cell(0, 6, "LISTA DE PRODUCTOS", 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 10);
            $pdf->Cell(0, 5, "Expedido: " . date("d/m/Y"), 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 8);
            $pdf->setY(33);
            $alto = 10;
            $font_size = 8;
            $font_size2 = 9;

            $pdf->setFont("helvetica", "B", $font_size2);
            $pdf->cellAutoFontSize($pdf, 10, $alto, 'NRO', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 20, $alto, 'CÓDIGO', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 45, $alto, 'NOMBRE', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 25, $alto, 'CATEGORÍA', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 25, $alto, 'MARCA', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 10, $alto, 'U. M.', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 55, $alto, 'CARACTERISTICAS', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 15, $alto, 'CALIDAD', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 15, $alto, 'COBERTURA', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 15, $alto, 'FORMATO', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 17, $alto, 'P. 1', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 17, $alto, 'P. 2', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 17, $alto, 'P. 3', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 17, $alto, 'P. 4', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 17, $alto, 'P. COMPRA', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 8, $alto, 'S. M.', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 10, $alto, 'ACTIVO', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 16, $alto, 'FECHA REGISTRO', $font_size, 5, 'B');
            $pdf->Ln();
            $cont = 1;
            foreach ($productos as $item) {
                $pdf->cellAutoFontSize($pdf, 10, $alto, $cont++, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 20, $alto, $item->codigo, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 45, $alto, $item->nombre, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 25, $alto, $item->categoria->nombre, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 25, $alto, $item->marca->nombre, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 10, $alto, $item->unidad_medida->nombre, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 55, $alto, $item->caracteristicas, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 15, $alto, $item->calidad, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 15, $alto, $item->cobertura, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 15, $alto, $item->formato, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 17, $alto, $item->precio, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 17, $alto, $item->precio2, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 17, $alto, $item->precio3, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 17, $alto, $item->precio4, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 17, $alto, $item->precio_compra, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 8, $alto, $item->stock_min, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 10, $alto, $item->activo == 1 ? 'SI' : 'NO', $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 16, $alto, $item->fecha_registro_t, $font_size, 5, 'N', 'L');
                $pdf->Ln();
            }
            // Guardar PDF o forzar descarga
            return response($pdf->Output('S'), 200)
                ->header('Content-Type', 'application/pdf')
                ->header('Content-Disposition', 'inline; filename="productos' . time() . '.pdf"');
        } else {
            $spreadsheet = new Spreadsheet();
            $spreadsheet->getProperties()
                ->setCreator("ADMIN")
                ->setLastModifiedBy('Administración')
                ->setTitle('Registros')
                ->setSubject('Registros')
                ->setDescription('Registros')
                ->setKeywords('PHPSpreadsheet')
                ->setCategory('Listado');

            $sheet = $spreadsheet->getActiveSheet();

            $spreadsheet->getDefaultStyle()->getFont()->setName('Arial');

            $fila = 1;
            if (file_exists(public_path() . '/imgs/' . $this->configuracion->logo)) {
                $drawing = new \PhpOffice\PhpSpreadsheet\Worksheet\Drawing();
                $drawing->setName('logo');
                $drawing->setDescription('logo');
                $drawing->setPath(public_path() . '/imgs/' . $this->configuracion->logo); // put your path and image here
                $drawing->setCoordinates('A' . $fila);
                $drawing->setOffsetX(5);
                $drawing->setOffsetY(0);
                $drawing->setHeight(70);
                $drawing->setWorksheet($sheet);
            }

            $fila = 2;
            $sheet->setCellValue('A' . $fila, $this->configuracion->nombre_sistema);
            $sheet->mergeCells("A" . $fila . ":R" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':R' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':R' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $sheet->setCellValue('A' . $fila, "LISTA DE PRODUCTOS");
            $sheet->mergeCells("A" . $fila . ":R" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':R' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':R' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $fila++;
            $sheet->setCellValue('A' . $fila, 'NRO');
            $sheet->setCellValue('B' . $fila, 'CÓDIGO');
            $sheet->setCellValue('C' . $fila, 'NOMBRE');
            $sheet->setCellValue('D' . $fila, 'CATEGORÍA');
            $sheet->setCellValue('E' . $fila, 'MARCA');
            $sheet->setCellValue('F' . $fila, 'UNIDAD MEDIDA');
            $sheet->setCellValue('G' . $fila, 'CARACTERISTICAS');
            $sheet->setCellValue('H' . $fila, 'CALIDAD');
            $sheet->setCellValue('I' . $fila, 'COBERTURA');
            $sheet->setCellValue('J' . $fila, 'FORMATO');
            $sheet->setCellValue('K' . $fila, 'P. 1');
            $sheet->setCellValue('L' . $fila, 'P. 2');
            $sheet->setCellValue('M' . $fila, 'P. 3');
            $sheet->setCellValue('N' . $fila, 'P. 4');
            $sheet->setCellValue('O' . $fila, 'P. COMPRA');
            $sheet->setCellValue('P' . $fila, 'STOCK MINIMO');
            $sheet->setCellValue('Q' . $fila, 'ACTIVO');
            $sheet->setCellValue('R' . $fila, 'FECHA REGISTRO');
            $sheet->getStyle('A' . $fila . ':R' . $fila)->applyFromArray($this->headerTabla);
            $fila++;

            foreach ($productos as $key => $item) {
                $sheet->setCellValue('A' . $fila, $key + 1);
                $sheet->setCellValue('B' . $fila, $item->codigo);
                $sheet->setCellValue('C' . $fila, $item->nombre);
                $sheet->setCellValue('D' . $fila, $item->categoria->nombre);
                $sheet->setCellValue('E' . $fila, $item->marca->nombre);
                $sheet->setCellValue('F' . $fila, $item->unidad_medida->nombre);
                $sheet->setCellValue('G' . $fila, $item->caracteristicas);
                $sheet->setCellValue('H' . $fila, $item->calidad);
                $sheet->setCellValue('I' . $fila, $item->cobertura);
                $sheet->setCellValue('J' . $fila, $item->formato);
                $sheet->setCellValue('K' . $fila, $item->precio);
                $sheet->setCellValue('L' . $fila, $item->precio2);
                $sheet->setCellValue('M' . $fila, $item->precio3);
                $sheet->setCellValue('N' . $fila, $item->precio4);
                $sheet->setCellValue('O' . $fila, $item->precio_compra);
                $sheet->setCellValue('P' . $fila, $item->stock_min);
                $sheet->setCellValue('Q' . $fila, $item->activo == 1 ? 'SI' : 'NO');
                $sheet->setCellValue('R' . $fila, $item->fecha_registro_t);
                $sheet->getStyle('A' . $fila . ':R' . $fila)->applyFromArray($this->bodyTabla);
                $fila++;
            }

            $sheet->getColumnDimension('A')->setWidth(6);
            $sheet->getColumnDimension('B')->setWidth(15);
            $sheet->getColumnDimension('C')->setWidth(30);
            $sheet->getColumnDimension('D')->setWidth(25);
            $sheet->getColumnDimension('E')->setWidth(20);
            $sheet->getColumnDimension('F')->setWidth(15);
            $sheet->getColumnDimension('G')->setWidth(30);
            $sheet->getColumnDimension('H')->setWidth(15);
            $sheet->getColumnDimension('I')->setWidth(15);
            $sheet->getColumnDimension('J')->setWidth(15);
            $sheet->getColumnDimension('K')->setWidth(10);
            $sheet->getColumnDimension('L')->setWidth(10);
            $sheet->getColumnDimension('M')->setWidth(10);
            $sheet->getColumnDimension('N')->setWidth(10);
            $sheet->getColumnDimension('O')->setWidth(10);
            $sheet->getColumnDimension('P')->setWidth(10);
            $sheet->getColumnDimension('Q')->setWidth(10);
            $sheet->getColumnDimension('R')->setWidth(15);

            foreach (range('A', 'R') as $columnID) {
                $sheet->getStyle($columnID)->getAlignment()->setWrapText(true);
            }

            $sheet->getPageSetup()->setOrientation(\PhpOffice\PhpSpreadsheet\Worksheet\PageSetup::ORIENTATION_LANDSCAPE);
            $sheet->getPageMargins()->setTop(0.5);
            $sheet->getPageMargins()->setRight(0.1);
            $sheet->getPageMargins()->setLeft(0.1);
            $sheet->getPageMargins()->setBottom(0.1);
            $sheet->getPageSetup()->setPrintArea('A:R');
            $sheet->getPageSetup()->setFitToWidth(1);
            $sheet->getPageSetup()->setFitToHeight(0);

            return response()->streamDownload(
                function () use ($spreadsheet) {
                    $writer = IOFactory::createWriter($spreadsheet, 'Xlsx');
                    $writer->save('php://output');
                },
                'productos_' . time() . '.xlsx',
                [
                    'Content-Type' => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                ]
            );
        }
    }


    public function stock_productos()
    {

        $almacens = $this->almacen_service->listado(1);
        $categorias = $this->categoria_service->listado();
        $marcas = $this->marca_service->listado();
        $unidad_medidas = $this->unidad_medida_service->listado();
        return Inertia::render("Admin/Reportes/StockProductos", [
            "almacens" => $almacens,
            "categorias" => $categorias,
            "marcas" => $marcas,
            "unidad_medidas" => $unidad_medidas,
        ]);
    }

    public function r_stock_productos(Request $request)
    {
        ini_set('memory_limit', '1024M');
        set_time_limit(-1);
        $categoria_id =  $request->categoria_id;
        $marca_id =  $request->marca_id;
        $unidad_medida_id =  $request->unidad_medida_id;
        $almacen_id =  $request->almacen_id;
        $formato =  $request->formato;
        $productos = Producto::select(
            'productos.*',
            DB::raw('COALESCE(SUM(producto_sucursals.stock_actual),0) as stock_total')

        )->with(["categoria:id,nombre", "marca:id,nombre"])
            ->leftJoin('producto_sucursals', function ($join) use ($almacen_id) {
                $join->on('productos.id', '=', 'producto_sucursals.producto_id');
                if (!empty($almacen_id) && $almacen_id != 'todos') {
                    $join->where('producto_sucursals.almacen_id', $almacen_id);
                }

                if (Auth::user()->tipo != 'ADMINISTRACIÓN') {
                    $join->where("producto_sucursals.sucursal_id", Auth::user()->sucursal_id);
                }
            });

        if (!empty($categoria_id) && $categoria_id != 'todos') {
            $productos->where('productos.categoria_id', $categoria_id);
        }

        if (!empty($marca_id) && $marca_id != 'todos') {
            $productos->where('productos.marca_id', $marca_id);
        }

        if (!empty($unidad_medida_id) && $unidad_medida_id != 'todos') {
            $productos->where('productos.unidad_medida_id', $unidad_medida_id);
        }

        $productos = $productos
            ->groupBy('productos.id')
            ->get();

        if ($formato == 'pdf') {
            $pdf = new ReporteServiceTcpdf();
            $pdf->SetTitle('Stock de Productos');
            $pdf->setMargins(1, 2, 2);
            $pdf->AddPage('L', 'LETTER');
            $pdf->setPrintHeader(false);
            $pdf->setY(13);
            $pdf->SetFont('helvetica', 'B', 12);
            $pdf->Cell(0, 6, "STOCK DE PRODUCTOS", 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 10);
            $pdf->Cell(0, 5, "Expedido: " . date("d/m/Y"), 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 11);
            $titulo = '"TODOS LOS ALMACENES"';
            if ($almacen_id != "todos") {
                $almacen = Almacen::find($almacen_id);
                $titulo = '"' . $almacen->nombre . ' - ' . $almacen->sucursal->nombre . '"';
            }
            $pdf->Cell(0, 6, $titulo, 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 8);
            $pdf->setY(33);
            $alto = 10;
            $font_size = 8;
            $font_size2 = 9;

            $pdf->setFont("helvetica", "B", $font_size2);
            $pdf->cellAutoFontSize($pdf, 10, $alto, 'NRO', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 20, $alto, 'CÓDIGO', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 45, $alto, 'NOMBRE', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 25, $alto, 'CATEGORÍA', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 25, $alto, 'MARCA', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 12, $alto, 'U. M.', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 55, $alto, 'CARACTERISTICAS', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 20, $alto, 'CALIDAD', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 15, $alto, 'COBERTURA', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 15, $alto, 'FORMATO', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 25, $alto, 'STOCK ACTUAL', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 10, $alto, 'ACTIVO', $font_size, 5, 'B');
            $pdf->Ln();
            $cont = 1;
            foreach ($productos as $item) {
                $pdf->cellAutoFontSize($pdf, 10, $alto, $cont++, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 20, $alto, $item->codigo, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 45, $alto, $item->nombre, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 25, $alto, $item->categoria->nombre, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 25, $alto, $item->marca->nombre, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 12, $alto, $item->unidad_medida->nombre, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 55, $alto, $item->caracteristicas, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 20, $alto, $item->calidad, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 15, $alto, $item->cobertura, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 15, $alto, $item->formato, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 25, $alto, $item->stock_total, $font_size, 5, 'N', 'C');
                $pdf->cellAutoFontSize($pdf, 10, $alto, $item->activo == 1 ? 'SI' : 'NO', $font_size, 5, 'N', 'L');
                $pdf->Ln();
            }

            // Guardar PDF o forzar descarga
            return response($pdf->Output('S'), 200)
                ->header('Content-Type', 'application/pdf')
                ->header('Content-Disposition', 'inline; filename="stock_productos' . time() . '.pdf"');
        } else {
            $spreadsheet = new Spreadsheet();
            $spreadsheet->getProperties()
                ->setCreator("ADMIN")
                ->setLastModifiedBy('Administración')
                ->setTitle('Registros')
                ->setSubject('Registros')
                ->setDescription('Registros')
                ->setKeywords('PHPSpreadsheet')
                ->setCategory('Listado');

            $sheet = $spreadsheet->getActiveSheet();

            $spreadsheet->getDefaultStyle()->getFont()->setName('Arial');

            $fila = 1;
            if (file_exists(public_path() . '/imgs/' . $this->configuracion->logo)) {
                $drawing = new \PhpOffice\PhpSpreadsheet\Worksheet\Drawing();
                $drawing->setName('logo');
                $drawing->setDescription('logo');
                $drawing->setPath(public_path() . '/imgs/' . $this->configuracion->logo); // put your path and image here
                $drawing->setCoordinates('A' . $fila);
                $drawing->setOffsetX(5);
                $drawing->setOffsetY(0);
                $drawing->setHeight(70);
                $drawing->setWorksheet($sheet);
            }

            $fila = 2;
            $sheet->setCellValue('A' . $fila, $this->configuracion->nombre_sistema);
            $sheet->mergeCells("A" . $fila . ":L" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':L' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':L' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $sheet->setCellValue('A' . $fila, "STOCK DE PRODUCTOS");
            $sheet->mergeCells("A" . $fila . ":L" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':L' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':L' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $titulo = '"TODOS LOS ALMACENES"';
            if ($almacen_id != "todos") {
                $almacen = Almacen::find($almacen_id);
                $titulo = '"' . $almacen->nombre . ' - ' . $almacen->sucursal->nombre . '"';
            }
            $sheet->setCellValue('A' . $fila, $titulo);
            $sheet->mergeCells("A" . $fila . ":L" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':L' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':L' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $fila++;
            $sheet->setCellValue('A' . $fila, 'NRO');
            $sheet->setCellValue('B' . $fila, 'CÓDIGO');
            $sheet->setCellValue('C' . $fila, 'NOMBRE');
            $sheet->setCellValue('D' . $fila, 'CATEGORÍA');
            $sheet->setCellValue('E' . $fila, 'MARCA');
            $sheet->setCellValue('F' . $fila, 'UNIDAD MEDIDA');
            $sheet->setCellValue('G' . $fila, 'CARACTERISTICAS');
            $sheet->setCellValue('H' . $fila, 'CALIDAD');
            $sheet->setCellValue('I' . $fila, 'COBERTURA');
            $sheet->setCellValue('J' . $fila, 'FORMATO');
            $sheet->setCellValue('K' . $fila, 'STOCK ACTUAL');
            $sheet->setCellValue('L' . $fila, 'ACTIVO');
            $sheet->getStyle('A' . $fila . ':L' . $fila)->applyFromArray($this->headerTabla);
            $fila++;

            foreach ($productos as $key => $item) {
                $sheet->setCellValue('A' . $fila, $key + 1);
                $sheet->setCellValue('B' . $fila, $item->codigo);
                $sheet->setCellValue('C' . $fila, $item->nombre);
                $sheet->setCellValue('D' . $fila, $item->categoria->nombre);
                $sheet->setCellValue('E' . $fila, $item->marca->nombre);
                $sheet->setCellValue('F' . $fila, $item->unidad_medida->nombre);
                $sheet->setCellValue('G' . $fila, $item->caracteristicas);
                $sheet->setCellValue('H' . $fila, $item->calidad);
                $sheet->setCellValue('I' . $fila, $item->cobertura);
                $sheet->setCellValue('J' . $fila, $item->formato);
                $sheet->setCellValue('K' . $fila, $item->stock_total);
                $sheet->setCellValue('L' . $fila,  $item->activo == 1 ? 'SI' : 'NO');
                $sheet->getStyle('A' . $fila . ':L' . $fila)->applyFromArray($this->bodyTabla);
                $fila++;
            }

            $sheet->getColumnDimension('A')->setWidth(6);
            $sheet->getColumnDimension('B')->setWidth(15);
            $sheet->getColumnDimension('C')->setWidth(30);
            $sheet->getColumnDimension('D')->setWidth(25);
            $sheet->getColumnDimension('E')->setWidth(20);
            $sheet->getColumnDimension('F')->setWidth(15);
            $sheet->getColumnDimension('G')->setWidth(30);
            $sheet->getColumnDimension('H')->setWidth(15);
            $sheet->getColumnDimension('I')->setWidth(15);
            $sheet->getColumnDimension('J')->setWidth(15);
            $sheet->getColumnDimension('K')->setWidth(10);
            $sheet->getColumnDimension('L')->setWidth(10);

            foreach (range('A', 'R') as $columnID) {
                $sheet->getStyle($columnID)->getAlignment()->setWrapText(true);
            }

            $sheet->getPageSetup()->setOrientation(\PhpOffice\PhpSpreadsheet\Worksheet\PageSetup::ORIENTATION_LANDSCAPE);
            $sheet->getPageMargins()->setTop(0.5);
            $sheet->getPageMargins()->setRight(0.1);
            $sheet->getPageMargins()->setLeft(0.1);
            $sheet->getPageMargins()->setBottom(0.1);
            $sheet->getPageSetup()->setPrintArea('A:L');
            $sheet->getPageSetup()->setFitToWidth(1);
            $sheet->getPageSetup()->setFitToHeight(0);

            return response()->streamDownload(
                function () use ($spreadsheet) {
                    $writer = IOFactory::createWriter($spreadsheet, 'Xlsx');
                    $writer->save('php://output');
                },
                'stock_productos_' . time() . '.xlsx',
                [
                    'Content-Type' => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                ]
            );
        }
    }
    public function kardex_productos()
    {
        $almacens = $this->almacen_service->listado(1);
        $categorias = $this->categoria_service->listado();
        $marcas = $this->marca_service->listado();
        $unidad_medidas = $this->unidad_medida_service->listado();
        return Inertia::render("Admin/Reportes/KardexProductos", [
            "almacens" => $almacens,
            "categorias" => $categorias,
            "marcas" => $marcas,
            "unidad_medidas" => $unidad_medidas,
        ]);
    }

    public function r_kardex_productos(Request $request)
    {
        ini_set('memory_limit', '1024M');
        set_time_limit(-1);
        $categoria_id =  $request->categoria_id;
        $marca_id =  $request->marca_id;
        $unidad_medida_id =  $request->unidad_medida_id;
        $almacen_id =  $request->almacen_id;
        $fecha_ini =  $request->fecha_ini;
        $fecha_fin =  $request->fecha_fin;
        $formato =  $request->formato;

        $almacens = Almacen::select("almacens.id", "almacens.nombre", "almacens.sucursal_id")
            ->with(["sucursal:id,nombre"]);
        if ($almacen_id != 'todos') {
            $almacens->where("id", $almacen_id);
        }
        $almacens = $almacens->get();

        $productos = Producto::select(
            'productos.id',
            'productos.nombre',
            'productos.precio',
            'productos.categoria_id',
            'productos.marca_id',
            'productos.unidad_medida_id'
        )
            ->with([
                'categoria:id,nombre',
                'marca:id,nombre',
                'unidad_medida:id,nombre',
            ])
            ->whereHas('kardex_productos', function ($query) use ($almacens) {
                $query->whereIn(
                    'almacen_id',
                    $almacens->pluck('id')
                );
            });

        if ($categoria_id != 'todos') {
            $productos->where('productos.categoria_id', $categoria_id);
        }

        if ($marca_id != 'todos') {
            $productos->where('productos.marca_id', $marca_id);
        }

        if ($unidad_medida_id != 'todos') {
            $productos->where('productos.unidad_medida_id', $unidad_medida_id);
        }

        $productos = $productos->get();



        $kardex_almacens = [];
        foreach ($almacens as $almacen) {
            $kardex_almacens[$almacen->id] = [
                "array_kardex" => [],
                "array_saldo_anterior" => [],
            ];
            $array_kardex = [];
            $array_saldo_anterior = [];
            foreach ($productos as $registro) {
                $kardex = KardexProducto::where('producto_id', $registro->id)
                    ->where("almacen_id", $almacen->id)->get();
                $array_saldo_anterior[$registro->id] = [
                    'sw' => false,
                    'saldo_anterior' => []
                ];
                if ($fecha_ini && $fecha_fin) {
                    $kardex = KardexProducto::where('producto_id', $registro->id)
                        ->where("almacen_id", $almacen->id)
                        ->whereBetween('fecha', [$fecha_ini, $fecha_fin])->get();
                    // buscar saldo anterior si existe
                    $saldo_anterior = KardexProducto::where('producto_id', $registro->id)
                        ->where("almacen_id", $almacen->id)
                        ->where('fecha', '<', $fecha_ini)
                        ->orderBy('created_at', 'asc')->get()->last();
                    if ($saldo_anterior) {
                        $cantidad_saldo = $saldo_anterior->cantidad_saldo;
                        $monto_saldo = $saldo_anterior->monto_saldo;
                        $array_saldo_anterior[$registro->id] = [
                            'sw' => true,
                            'saldo_anterior' => [
                                'cantidad_saldo' => $cantidad_saldo,
                                'monto_saldo' => $monto_saldo,
                            ]
                        ];
                    }
                }

                $array_kardex[$registro->id] = $kardex;
            }
            $kardex_almacens[$almacen->id]["array_kardex"] = $array_kardex;
            $kardex_almacens[$almacen->id]["array_saldo_anterior"] = $array_saldo_anterior;
        }

        $array_dias = [
            '0' => 'Domingo',
            '1' => 'Lunes',
            '2' => 'Martes',
            '3' => 'Miércoles',
            '4' => 'Jueves',
            '5' => 'Viernes',
            '6' => 'Sábado',
        ];
        $array_meses = [
            '01' => 'enero',
            '02' => 'febrero',
            '03' => 'marzo',
            '04' => 'abril',
            '05' => 'mayo',
            '06' => 'junio',
            '07' => 'julio',
            '08' => 'agosto',
            '09' => 'septiembre',
            '10' => 'octubre',
            '11' => 'noviembre',
            '12' => 'diciembre',
        ];

        if ($formato == 'pdf') {
            $pdf = new ReporteServiceTcpdf();
            $pdf->SetTitle('Kardex de Productos');
            $pdf->setMargins(10, 5, 5);

            foreach ($almacens as $almacen) {
                $pdf->AddPage();
                $pdf->setPrintHeader(false);
                $pdf->setY(13);
                $pdf->SetFont('helvetica', 'B', 12);
                $pdf->Cell(0, 6, "KARDEX DE PRODUCTOS", 0, 1, 'C', 0, '', 0, false);
                $pdf->SetFont('helvetica', 'B', 10);
                $pdf->Cell(0, 5, $almacen->nombre . ' - ' . $almacen->sucursal->nombre, 0, 1, 'C', 0, '', 0, false);
                $pdf->SetFont('helvetica', 'B', 8);
                $pdf->Cell(0, 5, $array_dias[date('w')] . ', ' . date('d') . ' de ' . $array_meses[date('m')] . ' de ' . date('Y'), 0, 1, 'C', 0, '', 0, false);
                $pdf->Cell(0, 5, "(Expresado en bolivianos)", 0, 1, 'C', 0, '', 0, false);
                $pdf->SetFont('helvetica', 'B', 8);
                $alto = 10;
                $font_size = 8;
                $font_size2 = 9;

                $html = '';

                foreach ($productos as $registro) {
                    $pdf->SetFont('helvetica', 'B', $font_size2);
                    $pdf->Cell(190, 10, $registro->nombre, 1, 1, 'C');
                    $pdf->MultiCell(15, 20, 'FECHA', 1, 'C', false, 0, $x = '',  $y = '',  $reseth = true,  $stretch = 0,  $ishtml = false,  $autopadding = true,  $maxh = 0,  $valign = 'M',  $fitcell = false);
                    $pdf->MultiCell(35, 20, 'DETALLE', 1, 'C', false, 0);
                    $pdf->cellAutoFontSize($pdf, 60, $alto, 'CANTIDADES', $font_size, 5, "B");
                    $pdf->cellAutoFontSize($pdf, 20, $alto, 'P/U', $font_size, 5, "B");
                    $pdf->cellAutoFontSize($pdf, 60, $alto, 'BOLIVIANOS', $font_size, 5, "B");
                    $pdf->Ln();
                    $pdf->SetX(60);
                    $pdf->cellAutoFontSize($pdf, 20, $alto, 'ENTRADA', $font_size, 5, "B");
                    $pdf->cellAutoFontSize($pdf, 20, $alto, 'SALIDA', $font_size, 5, "B");
                    $pdf->cellAutoFontSize($pdf, 20, $alto, 'SALDO', $font_size, 5, "B");
                    $pdf->SetX(140);
                    $pdf->cellAutoFontSize($pdf, 20, $alto, 'ENTRADA', $font_size, 5, "B");
                    $pdf->cellAutoFontSize($pdf, 20, $alto, 'SALIDA', $font_size, 5, "B");
                    $pdf->cellAutoFontSize($pdf, 20, $alto, 'SALDO', $font_size, 5, "B");
                    $pdf->Ln();

                    if (count($kardex_almacens[$almacen->id]['array_kardex'][$registro->id]) > 0 || $kardex_almacens[$almacen->id]['array_saldo_anterior'][$registro->id]['sw']) {

                        $total = 0;
                        if ($kardex_almacens[$almacen->id]['array_saldo_anterior'][$registro->id]['sw']) {
                            $pdf->cellAutoFontSize($pdf, 15, $alto, "",);
                            $pdf->cellAutoFontSize($pdf, 35, $alto, "SALDO ANTERIOR",);
                            $pdf->cellAutoFontSize($pdf, 20, $alto, "",);
                            $pdf->cellAutoFontSize($pdf, 20, $alto, "",);
                            $pdf->cellAutoFontSize($pdf, 20, $alto, $kardex_almacens[$almacen->id]['array_saldo_anterior'][$registro->id]['saldo_anterior']['cantidad_saldo'],);
                            $pdf->cellAutoFontSize($pdf, 20, $alto, $registro->precio,);
                            $pdf->cellAutoFontSize($pdf, 20, $alto, "",);
                            $pdf->cellAutoFontSize($pdf, 20, $alto, "",);
                            $pdf->cellAutoFontSize($pdf, 20, $alto, number_format($kardex_almacens[$almacen->id]['array_saldo_anterior'][$registro->id]['saldo_anterior']['monto_saldo'], 2, '.', ','),);
                            $pdf->Ln();
                        }
                        foreach ($kardex_almacens[$almacen->id]['array_kardex'][$registro->id] as $value) {
                            $pdf->cellAutoFontSize($pdf, 15, $alto, date("d/m/Y", strtotime($value["fecha"])));
                            $pdf->cellAutoFontSize($pdf, 35, $alto, $value["detalle"]);
                            $pdf->cellAutoFontSize($pdf, 20, $alto, $value["cantidad_ingreso"]);
                            $pdf->cellAutoFontSize($pdf, 20, $alto, $value["cantidad_salida"]);
                            $pdf->cellAutoFontSize($pdf, 20, $alto, $value["cantidad_saldo"]);
                            $pdf->cellAutoFontSize($pdf, 20, $alto, number_format($value["cu"], 2, '.', ','));
                            $pdf->cellAutoFontSize($pdf, 20, $alto, $value["monto_ingreso"]);
                            $pdf->cellAutoFontSize($pdf, 20, $alto, $value["monto_salida"]);
                            $pdf->cellAutoFontSize($pdf, 20, $alto, number_format($value["monto_saldo"], 2, '.', ','));
                            $pdf->Ln();
                        }
                    } else {
                        $pdf->Cell(190, 10, "NO SE ENCONTRARON REGISTROS", 1, 1);
                    }
                    $pdf->Ln();
                }
            }
            // Guardar PDF o forzar descarga
            return response($pdf->Output('S'), 200)
                ->header('Content-Type', 'application/pdf')
                ->header('Content-Disposition', 'inline; filename="kardex_productos' . time() . '.pdf"');
        } else {
            $spreadsheet = new Spreadsheet();

            $spreadsheet->getProperties()
                ->setCreator('ADMIN')
                ->setLastModifiedBy('Administración')
                ->setTitle('Kardex de Productos')
                ->setSubject('Kardex de Productos')
                ->setDescription('Reporte de movimientos de productos por almacén')
                ->setKeywords('Kardex, Productos, Almacenes')
                ->setCategory('Listado');

            $spreadsheet->getDefaultStyle()
                ->getFont()
                ->setName('Arial')
                ->setSize(10);

            $sheet = $spreadsheet->getActiveSheet();
            $sheet->setTitle('Kardex Productos');

            $fila = 1;

            // Logo, siguiendo la estructura de tu reporte anterior
            if (
                isset($this->configuracion->logo) &&
                file_exists(public_path() . '/imgs/' . $this->configuracion->logo)
            ) {
                $drawing = new \PhpOffice\PhpSpreadsheet\Worksheet\Drawing();
                $drawing->setName('logo');
                $drawing->setDescription('Logo');
                $drawing->setPath(
                    public_path() . '/imgs/' . $this->configuracion->logo
                );
                $drawing->setCoordinates('A1');
                $drawing->setOffsetX(5);
                $drawing->setOffsetY(0);
                $drawing->setHeight(60);
                $drawing->setWorksheet($sheet);

                $sheet->getRowDimension(1)->setRowHeight(45);
            }

            // Fecha en español
            $fechaReporte = date('d/m/Y');

            // Estilos para los encabezados
            $estiloTitulo = $this->titulo;
            $estiloEncabezado = $this->headerTabla;
            $estiloCuerpo = $this->bodyTabla;

            // Recorrer almacenes
            foreach ($almacens as $almacen) {

                // Encabezado del almacén
                $sheet->mergeCells("A{$fila}:I{$fila}");
                $sheet->setCellValue(
                    "A{$fila}",
                    $this->configuracion->nombre_sistema
                );
                $sheet->getStyle("A{$fila}:I{$fila}")
                    ->getAlignment()
                    ->setHorizontal('center');
                $sheet->getStyle("A{$fila}:I{$fila}")
                    ->applyFromArray($estiloTitulo);

                $fila++;

                $sheet->mergeCells("A{$fila}:I{$fila}");
                $sheet->setCellValue("A{$fila}", 'KARDEX DE PRODUCTOS');
                $sheet->getStyle("A{$fila}:I{$fila}")
                    ->getAlignment()
                    ->setHorizontal('center');
                $sheet->getStyle("A{$fila}:I{$fila}")
                    ->applyFromArray($estiloTitulo);

                $fila++;

                $sheet->mergeCells("A{$fila}:I{$fila}");
                $sheet->setCellValue("A{$fila}", $almacen->nombre . ' - ' . $almacen->sucursal->nombre);
                $sheet->getStyle("A{$fila}:I{$fila}")
                    ->getAlignment()
                    ->setHorizontal('center');
                $sheet->getStyle("A{$fila}:I{$fila}")
                    ->applyFromArray($estiloTitulo);

                $fila++;

                $sheet->mergeCells("A{$fila}:I{$fila}");
                $sheet->setCellValue(
                    "A{$fila}",
                    'Fecha de reporte: ' . $fechaReporte
                );
                $sheet->getStyle("A{$fila}:I{$fila}")
                    ->getAlignment()
                    ->setHorizontal('center');

                $fila++;

                $sheet->mergeCells("A{$fila}:I{$fila}");
                $sheet->setCellValue("A{$fila}", '(Expresado en bolivianos)');
                $sheet->getStyle("A{$fila}:I{$fila}")
                    ->getAlignment()
                    ->setHorizontal('center');

                $fila += 2;

                // Recorrer productos
                foreach ($productos as $registro) {

                    // Título del producto
                    $sheet->mergeCells("A{$fila}:I{$fila}");
                    $sheet->setCellValue("A{$fila}", $registro->nombre);

                    $sheet->getStyle("A{$fila}:I{$fila}")
                        ->applyFromArray($estiloTitulo);

                    $sheet->getStyle("A{$fila}:I{$fila}")
                        ->getAlignment()
                        ->setHorizontal('center');

                    $fila++;

                    /*
         * Encabezados agrupados:
         *
         * A = FECHA
         * B = DETALLE
         * C:E = CANTIDADES
         * F = P/U
         * G:I = BOLIVIANOS
         */

                    $filaCabecera = $fila;
                    $filaSubcabecera = $fila + 1;

                    $sheet->mergeCells("A{$filaCabecera}:A{$filaSubcabecera}");
                    $sheet->mergeCells("B{$filaCabecera}:B{$filaSubcabecera}");
                    $sheet->mergeCells("F{$filaCabecera}:F{$filaSubcabecera}");

                    $sheet->mergeCells("C{$filaCabecera}:E{$filaCabecera}");
                    $sheet->mergeCells("G{$filaCabecera}:I{$filaCabecera}");

                    $sheet->setCellValue("A{$filaCabecera}", 'FECHA');
                    $sheet->setCellValue("B{$filaCabecera}", 'DETALLE');
                    $sheet->setCellValue("C{$filaCabecera}", 'CANTIDADES');
                    $sheet->setCellValue("F{$filaCabecera}", 'P/U');
                    $sheet->setCellValue("G{$filaCabecera}", 'BOLIVIANOS');

                    $sheet->setCellValue("C{$filaSubcabecera}", 'ENTRADA');
                    $sheet->setCellValue("D{$filaSubcabecera}", 'SALIDA');
                    $sheet->setCellValue("E{$filaSubcabecera}", 'SALDO');

                    $sheet->setCellValue("G{$filaSubcabecera}", 'ENTRADA');
                    $sheet->setCellValue("H{$filaSubcabecera}", 'SALIDA');
                    $sheet->setCellValue("I{$filaSubcabecera}", 'SALDO');

                    $sheet->getStyle(
                        "A{$filaCabecera}:I{$filaSubcabecera}"
                    )->applyFromArray($estiloEncabezado);

                    $sheet->getStyle(
                        "A{$filaCabecera}:I{$filaSubcabecera}"
                    )->getAlignment()
                        ->setHorizontal('center')
                        ->setVertical('center')
                        ->setWrapText(true);

                    $sheet->getRowDimension($filaCabecera)->setRowHeight(22);
                    $sheet->getRowDimension($filaSubcabecera)->setRowHeight(22);

                    $fila += 2;

                    // Obtener los movimientos del producto en el almacén actual
                    $movimientos = $kardex_almacens[$almacen->id]['array_kardex'][$registro->id] ?? [];

                    // Verificar si existe saldo anterior
                    $saldoAnterior = $kardex_almacens[$almacen->id]['array_saldo_anterior'][$registro->id] ?? ['sw' => false];

                    if (count($movimientos) > 0 || !empty($saldoAnterior['sw'])) {

                        // Fila del saldo anterior
                        if (!empty($saldoAnterior['sw'])) {

                            $saldo = $saldoAnterior['saldo_anterior'];

                            $sheet->setCellValue("A{$fila}", '');
                            $sheet->setCellValue("B{$fila}", 'SALDO ANTERIOR');
                            $sheet->setCellValue("C{$fila}", '');
                            $sheet->setCellValue("D{$fila}", '');
                            $sheet->setCellValue(
                                "E{$fila}",
                                $saldo['cantidad_saldo']
                            );
                            $sheet->setCellValue(
                                "F{$fila}",
                                $registro->precio
                            );
                            $sheet->setCellValue("G{$fila}", '');
                            $sheet->setCellValue("H{$fila}", '');
                            $sheet->setCellValue(
                                "I{$fila}",
                                $saldo['monto_saldo']
                            );

                            $fila++;
                        }

                        // Filas de movimientos
                        foreach ($movimientos as $value) {

                            $fechaMovimiento = !empty($value['fecha'])
                                ? date('d/m/Y', strtotime($value['fecha']))
                                : '';

                            $sheet->setCellValue("A{$fila}", $fechaMovimiento);
                            $sheet->setCellValue("B{$fila}", $value['detalle'] ?? '');

                            $sheet->setCellValue(
                                "C{$fila}",
                                $value['cantidad_ingreso'] ?? 0
                            );

                            $sheet->setCellValue(
                                "D{$fila}",
                                $value['cantidad_salida'] ?? 0
                            );

                            $sheet->setCellValue(
                                "E{$fila}",
                                $value['cantidad_saldo'] ?? 0
                            );

                            $sheet->setCellValue(
                                "F{$fila}",
                                $value['cu'] ?? 0
                            );

                            $sheet->setCellValue(
                                "G{$fila}",
                                $value['monto_ingreso'] ?? 0
                            );

                            $sheet->setCellValue(
                                "H{$fila}",
                                $value['monto_salida'] ?? 0
                            );

                            $sheet->setCellValue(
                                "I{$fila}",
                                $value['monto_saldo'] ?? 0
                            );

                            $fila++;
                        }
                    } else {

                        // No existen movimientos ni saldo anterior
                        $sheet->mergeCells("A{$fila}:I{$fila}");
                        $sheet->setCellValue(
                            "A{$fila}",
                            'NO SE ENCONTRARON REGISTROS'
                        );

                        $sheet->getStyle("A{$fila}:I{$fila}")
                            ->applyFromArray($estiloCuerpo);

                        $sheet->getStyle("A{$fila}:I{$fila}")
                            ->getAlignment()
                            ->setHorizontal('center');

                        $fila++;
                    }

                    // Estilos de las filas del producto
                    $ultimaFila = $fila - 1;

                    if ($ultimaFila >= $filaSubcabecera + 1) {
                        $sheet->getStyle(
                            'A' . ($filaSubcabecera + 1) . ':I' . $ultimaFila
                        )->applyFromArray($estiloCuerpo);
                    }

                    // Formato numérico para cantidades, precios y montos
                    if ($ultimaFila >= $filaSubcabecera + 1) {
                        $filaInicio = $filaSubcabecera + 1;

                        foreach (['C', 'D', 'E'] as $columna) {
                            $sheet->getStyle(
                                $columna . $filaInicio . ':' . $columna . $ultimaFila
                            )->getNumberFormat()->setFormatCode('#,##0.###');
                        }

                        foreach (['F', 'G', 'H', 'I'] as $columna) {
                            $sheet->getStyle(
                                $columna . $filaInicio . ':' . $columna . $ultimaFila
                            )->getNumberFormat()->setFormatCode('#,##0.00');
                        }
                    }
                    $fila += 2;
                }

                // Separación entre almacenes
                $fila += 2;
            }

            // Anchos de las columnas
            $sheet->getColumnDimension('A')->setWidth(13);
            $sheet->getColumnDimension('B')->setWidth(35);
            $sheet->getColumnDimension('C')->setWidth(15);
            $sheet->getColumnDimension('D')->setWidth(15);
            $sheet->getColumnDimension('E')->setWidth(15);
            $sheet->getColumnDimension('F')->setWidth(13);
            $sheet->getColumnDimension('G')->setWidth(17);
            $sheet->getColumnDimension('H')->setWidth(17);
            $sheet->getColumnDimension('I')->setWidth(17);

            // Ajustes generales
            $sheet->getStyle('A:I')
                ->getAlignment()
                ->setVertical('center')
                ->setWrapText(true);

            $sheet->getPageSetup()
                ->setOrientation(PageSetup::ORIENTATION_LANDSCAPE);

            $sheet->getPageSetup()
                ->setPaperSize(PageSetup::PAPERSIZE_LETTER);

            $sheet->getPageMargins()
                ->setTop(0.5)
                ->setRight(0.2)
                ->setLeft(0.2)
                ->setBottom(0.5);

            $sheet->getPageSetup()->setPrintArea('A1:I' . max(1, $fila - 1));
            $sheet->getPageSetup()->setFitToWidth(1);
            $sheet->getPageSetup()->setFitToHeight(0);
            $sheet->getPageSetup()->setScale(0);

            // Repetir encabezados de impresión no se configura aquí porque
            // los encabezados se repiten por producto dentro del reporte.

            // Descargar Excel
            return response()->streamDownload(
                function () use ($spreadsheet) {
                    $writer = IOFactory::createWriter($spreadsheet, 'Xlsx');
                    $writer->save('php://output');
                },
                'kardex_productos_' . time() . '.xlsx',
                [
                    'Content-Type' =>
                    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                ]
            );
        }
    }

    public function ingreso_bruto_productos()
    {
        $almacens = $this->almacen_service->listado(1);
        $categorias = $this->categoria_service->listado();
        $marcas = $this->marca_service->listado();
        $unidad_medidas = $this->unidad_medida_service->listado();
        return Inertia::render("Admin/Reportes/IngresoBrutoProductos", [
            "almacens" => $almacens,
            "categorias" => $categorias,
            "marcas" => $marcas,
            "unidad_medidas" => $unidad_medidas,
        ]);
    }

    public function r_ingreso_bruto_productos(Request $request)
    {
        $datos = $this->kardex_producto_service->obtenerDatosIngresoBrutoProductos($request);

        if ($request->formato === 'excel') {
            return $this->kardex_producto_service->generarExcelIngresoBrutoProductos($datos);
        }

        return $this->kardex_producto_service->generarPdfIngresoBrutoProductos($datos);
    }


    public function orden_compras()
    {
        return Inertia::render("Admin/Reportes/OrdenCompras");
    }

    public function r_orden_compras(Request $request)
    {
        ini_set('memory_limit', '1024M');
        set_time_limit(-1);
        $almacen_id =  $request->almacen_id;
        $tipo_ingreso_id =  $request->tipo_ingreso_id;
        $proveedor_id =  $request->proveedor_id;
        $tipo_compra =  $request->tipo_compra;
        $estado_ingreso =  $request->estado_ingreso;
        $estado_faltantes =  $request->estado_faltantes;
        $fecha_ini =  $request->fecha_ini;
        $fecha_fin =  $request->fecha_fin;
        $formato =  $request->formato;
        $ingreso_productos = IngresoProducto::select("ingreso_productos.*");

        if ($almacen_id && $almacen_id != 'todos') {
            $ingreso_productos->where('almacen_id', $almacen_id);
        }

        if ($tipo_ingreso_id && $tipo_ingreso_id != 'todos') {
            $ingreso_productos->where('tipo_ingreso_id', $tipo_ingreso_id);
        }

        if ($proveedor_id && $proveedor_id != 'todos') {
            $ingreso_productos->where('proveedor_id', $proveedor_id);
        }

        if ($tipo_compra && $tipo_compra != 'todos') {
            $ingreso_productos->where('tipo_compra', $tipo_compra);
        }

        if ($estado_ingreso && $estado_ingreso != 'todos') {
            $ingreso_productos->where('estado_ingreso', $estado_ingreso);
        }

        if ($estado_faltantes && $estado_faltantes != 'todos') {
            $ingreso_productos->where('estado_faltantes', $estado_faltantes);
        }

        if ($fecha_ini && $fecha_fin) {
            $ingreso_productos->whereBetween('fecha_registro', [$fecha_ini, $fecha_fin]);
        }

        $ingreso_productos = $ingreso_productos->get();

        if ($formato == 'pdf') {
            $pdf = new ReporteServiceTcpdf();
            $pdf->SetTitle('Lista de Ordenes de Compra');
            $pdf->setMargins(1, 2, 2);
            $pdf->AddPage('L', 'LEGAL');
            $pdf->setPrintHeader(false);
            $pdf->setY(13);
            $pdf->SetFont('helvetica', 'B', 12);
            $pdf->Cell(0, 6, "LISTADO DE ORDENES DE COMPRA", 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 10);
            $pdf->Cell(0, 5, "Expedido: " . date("d/m/Y"), 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 11);
            $titulo = '"TODOS LOS ALMACENES"';
            if ($almacen_id != "todos") {
                $almacen = Almacen::find($almacen_id);
                $titulo = '"' . $almacen->nombre . ' - ' . $almacen->sucursal->nombre . '"';
            }
            $pdf->Cell(0, 6, $titulo, 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 8);
            $pdf->setY(33);
            $alto = 10;
            $font_size = 8;
            $font_size2 = 9;
            $font_size3 = 10;

            $pdf->setFont("helvetica", "B", $font_size2);
            $pdf->cellAutoFontSize($pdf, 20, $alto, 'CÓDIGO', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 25, $alto, 'SUCURSAL', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 25, $alto, 'ALMACÉN', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 25, $alto, 'TIPO INGRESO', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 25, $alto, 'PROVEEDOR', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 55, $alto, 'DESCRIPCIÓN', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 23.5, $alto, 'TOTAL', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 23.5, $alto, 'CANCELADO', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 23.5, $alto, 'SALDO', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 17, $alto, 'TIPO COMPRA', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 25, $alto, 'RESPONSABLE', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 22, $alto, 'ESTADO COMPRA', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 22, $alto, 'FALTANTES', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 22, $alto, 'FECHA REGISTRO', $font_size, 5, 'B');
            $pdf->Ln();
            $s_total = 0;
            $s_cancelado = 0;
            $s_saldo = 0;
            foreach ($ingreso_productos as $item) {
                $pdf->cellAutoFontSize($pdf, 20, $alto, $item->codigo, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 25, $alto, $item->sucursal->nombre, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 25, $alto, $item->almacen->nombre, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 25, $alto, $item->tipo_ingreso->nombre, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 25, $alto, $item->proveedor->nombre, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 55, $alto, $item->descripcion, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 23.5, $alto, $item->total, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 23.5, $alto, $item->total_cancelado, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 23.5, $alto, $item->saldo, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 17, $alto, $item->tipo_compra, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 25, $alto, $item->user->full_name, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 22, $alto, $item->estado_ingreso, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 22, $alto, $item->estado_faltantes, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 22, $alto, $item->fecha_registro_t, $font_size, 5, 'N', 'L');

                $s_total += (float)$item->total;
                $s_cancelado += (float)$item->total_cancelado;
                $s_saldo += (float)$item->saldo;
                $pdf->Ln();
            }
            $pdf->cellAutoFontSize($pdf, 175, $alto, 'TOTALES', $font_size3, 5, 'B', 'R');
            $pdf->cellAutoFontSize($pdf, 23.5, $alto, number_format($s_total, 2, ".", ""), $font_size2, 5, 'B', 'L');
            $pdf->cellAutoFontSize($pdf, 23.5, $alto, number_format($s_cancelado, 2, ".", ""), $font_size2, 5, 'B', 'L');
            $pdf->cellAutoFontSize($pdf, 23.5, $alto, number_format($s_saldo, 2, ".", ""), $font_size2, 5, 'B', 'L');


            // Guardar PDF o forzar descarga
            return response($pdf->Output('S'), 200)
                ->header('Content-Type', 'application/pdf')
                ->header('Content-Disposition', 'inline; filename="orden_compras' . time() . '.pdf"');
        } else {
            $spreadsheet = new Spreadsheet();
            $spreadsheet->getProperties()
                ->setCreator("ADMIN")
                ->setLastModifiedBy('Administración')
                ->setTitle('Registros')
                ->setSubject('Registros')
                ->setDescription('Registros')
                ->setKeywords('PHPSpreadsheet')
                ->setCategory('Listado');

            $sheet = $spreadsheet->getActiveSheet();

            $spreadsheet->getDefaultStyle()->getFont()->setName('Arial');

            $fila = 1;
            if (file_exists(public_path() . '/imgs/' . $this->configuracion->logo)) {
                $drawing = new \PhpOffice\PhpSpreadsheet\Worksheet\Drawing();
                $drawing->setName('logo');
                $drawing->setDescription('logo');
                $drawing->setPath(public_path() . '/imgs/' . $this->configuracion->logo); // put your path and image here
                $drawing->setCoordinates('A' . $fila);
                $drawing->setOffsetX(5);
                $drawing->setOffsetY(0);
                $drawing->setHeight(70);
                $drawing->setWorksheet($sheet);
            }

            $fila = 2;
            $sheet->setCellValue('A' . $fila, $this->configuracion->nombre_sistema);
            $sheet->mergeCells("A" . $fila . ":N" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':N' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':N' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $sheet->setCellValue('A' . $fila, "LISTADO DE ORDENES DE COMPRA");
            $sheet->mergeCells("A" . $fila . ":N" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':N' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':N' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $titulo = '"TODOS LOS ALMACENES"';
            if ($almacen_id != "todos") {
                $almacen = Almacen::find($almacen_id);
                $titulo = '"' . $almacen->nombre . ' - ' . $almacen->sucursal->nombre . '"';
            }
            $sheet->setCellValue('A' . $fila, $titulo);
            $sheet->mergeCells("A" . $fila . ":N" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':N' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':N' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $fila++;
            $sheet->setCellValue('A' . $fila, 'CÓDIGO');
            $sheet->setCellValue('B' . $fila, 'SUCURSAL');
            $sheet->setCellValue('C' . $fila, 'ALMACÉN');
            $sheet->setCellValue('D' . $fila, 'TIPO INGRESO');
            $sheet->setCellValue('E' . $fila, 'PROVEEDOR');
            $sheet->setCellValue('F' . $fila, 'DESCRIPCIÓN');
            $sheet->setCellValue('G' . $fila, 'TOTAL');
            $sheet->setCellValue('H' . $fila, 'CANCELADO');
            $sheet->setCellValue('I' . $fila, 'SALDO');
            $sheet->setCellValue('J' . $fila, 'TIPO COMPRA');
            $sheet->setCellValue('K' . $fila, 'RESPONSABLE');
            $sheet->setCellValue('L' . $fila, 'ESTADO COMPRA');
            $sheet->setCellValue('M' . $fila, 'FALTANTES');
            $sheet->setCellValue('N' . $fila, 'FECHA REGISTRO');
            $sheet->getStyle('A' . $fila . ':N' . $fila)->applyFromArray($this->headerTabla);
            $fila++;
            $s_total = 0;
            $s_cancelado = 0;
            $s_saldo = 0;
            foreach ($ingreso_productos as $key => $item) {
                $sheet->setCellValue('A' . $fila, $item->codigo);
                $sheet->setCellValue('B' . $fila, $item->sucursal->nombre);
                $sheet->setCellValue('C' . $fila, $item->almacen->nombre);
                $sheet->setCellValue('D' . $fila, $item->tipo_ingreso->nombre);
                $sheet->setCellValue('E' . $fila, $item->proveedor->nombre);
                $sheet->setCellValue('F' . $fila, $item->descripcion);
                $sheet->setCellValue('G' . $fila, $item->total);
                $sheet->setCellValue('H' . $fila, $item->total_cancelado);
                $sheet->setCellValue('I' . $fila, $item->saldo);
                $sheet->setCellValue('J' . $fila, $item->tipo_compra);
                $sheet->setCellValue('K' . $fila, $item->user->full_name);
                $sheet->setCellValue('L' . $fila, $item->estado_ingreso);
                $sheet->setCellValue('M' . $fila, $item->estado_faltantes);
                $sheet->setCellValue('N' . $fila, $item->fecha_registro_t);
                $sheet->getStyle('A' . $fila . ':N' . $fila)->applyFromArray($this->bodyTabla);

                $s_total += (float)$item->total;
                $s_cancelado += (float)$item->total_cancelado;
                $s_saldo += (float)$item->saldo;
                $fila++;
            }
            $sheet->setCellValue('A' . $fila, "TOTALES");
            $sheet->mergeCells("A" . $fila . ":F" . $fila);  //COMBINAR CELDAS
            $sheet->setCellValue('G' . $fila, number_format($s_total, 2, ".", ""));
            $sheet->setCellValue('H' . $fila, number_format($s_cancelado, 2, ".", ""));
            $sheet->setCellValue('I' . $fila, number_format($s_saldo, 2, ".", ""));
            $sheet->getStyle('A' . $fila . ':I' . $fila)->applyFromArray($this->headerTabla);

            $sheet->getColumnDimension('A')->setWidth(12);
            $sheet->getColumnDimension('B')->setWidth(20);
            $sheet->getColumnDimension('C')->setWidth(20);
            $sheet->getColumnDimension('D')->setWidth(20);
            $sheet->getColumnDimension('E')->setWidth(15);
            $sheet->getColumnDimension('F')->setWidth(30);
            $sheet->getColumnDimension('G')->setWidth(15);
            $sheet->getColumnDimension('H')->setWidth(15);
            $sheet->getColumnDimension('I')->setWidth(15);
            $sheet->getColumnDimension('J')->setWidth(10);
            $sheet->getColumnDimension('K')->setWidth(25);
            $sheet->getColumnDimension('L')->setWidth(15);
            $sheet->getColumnDimension('M')->setWidth(15);
            $sheet->getColumnDimension('N')->setWidth(10);

            foreach (range('A', 'N') as $columnID) {
                $sheet->getStyle($columnID)->getAlignment()->setWrapText(true);
            }

            $sheet->getPageSetup()->setOrientation(\PhpOffice\PhpSpreadsheet\Worksheet\PageSetup::ORIENTATION_LANDSCAPE);
            $sheet->getPageMargins()->setTop(0.5);
            $sheet->getPageMargins()->setRight(0.1);
            $sheet->getPageMargins()->setLeft(0.1);
            $sheet->getPageMargins()->setBottom(0.1);
            $sheet->getPageSetup()->setPrintArea('A:N');
            $sheet->getPageSetup()->setFitToWidth(1);
            $sheet->getPageSetup()->setFitToHeight(0);

            return response()->streamDownload(
                function () use ($spreadsheet) {
                    $writer = IOFactory::createWriter($spreadsheet, 'Xlsx');
                    $writer->save('php://output');
                },
                'orden_compras_' . time() . '.xlsx',
                [
                    'Content-Type' => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                ]
            );
        }
    }

    public function salida_productos()
    {
        return Inertia::render("Admin/Reportes/SalidaProductos");
    }

    public function r_salida_productos(Request $request)
    {
        ini_set('memory_limit', '1024M');
        set_time_limit(-1);
        $almacen_id =  $request->almacen_id;
        $tipo_salida_id =  $request->tipo_salida_id;
        $proveedor_id =  $request->proveedor_id;
        $tipo_compra =  $request->tipo_compra;
        $estado_ingreso =  $request->estado_ingreso;
        $estado_faltantes =  $request->estado_faltantes;
        $fecha_ini =  $request->fecha_ini;
        $fecha_fin =  $request->fecha_fin;
        $formato =  $request->formato;
        $salida_detalles = SalidaDetalle::select("salida_detalles.*");

        if ($almacen_id && $almacen_id != 'todos') {
            $salida_detalles->where('almacen_id', $almacen_id);
        }

        if ($tipo_salida_id && $tipo_salida_id != 'todos') {
            $salida_detalles->where('tipo_salida_id', $tipo_salida_id);
        }

        if ($fecha_ini && $fecha_fin) {
            $salida_detalles->whereHas("salida_producto", function ($q) use ($fecha_ini, $fecha_fin) {
                $q->whereBetween('fecha_registro', [$fecha_ini, $fecha_fin]);
            });
        }

        $salida_detalles = $salida_detalles->get();

        if ($formato == 'pdf') {
            $pdf = new ReporteServiceTcpdf();
            $pdf->SetTitle('Lista de Salida de Productos');
            $pdf->setMargins(1, 2, 2);
            $pdf->AddPage('P', 'LETTER');
            $pdf->setPrintHeader(false);
            $pdf->setY(13);
            $pdf->SetFont('helvetica', 'B', 12);
            $pdf->Cell(0, 6, "LISTADO DE SALIDA DE PRODUCTOS", 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 10);
            $pdf->Cell(0, 5, "Expedido: " . date("d/m/Y"), 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 11);
            $titulo = '"TODOS LOS ALMACENES"';
            if ($almacen_id != "todos") {
                $almacen = Almacen::find($almacen_id);
                $titulo = '"' . $almacen->nombre . ' - ' . $almacen->sucursal->nombre . '"';
            }
            $pdf->Cell(0, 6, $titulo, 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 8);
            $pdf->setY(33);
            $alto = 10;
            $font_size = 8;
            $font_size2 = 9;
            $font_size3 = 10;

            $pdf->setFont("helvetica", "B", $font_size2);
            $pdf->cellAutoFontSize($pdf, 12, $alto, 'NRO', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 40, $alto, 'SUCURSAL', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 40, $alto, 'ALMACÉN', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 40, $alto, 'TIPO SALIDA', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 19, $alto, 'CANTIDAD', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 30, $alto, 'RESPONSABLE', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 30, $alto, 'FECHA REGISTRO', $font_size, 5, 'B');
            $pdf->Ln();
            $cont = 1;
            foreach ($salida_detalles as $item) {
                $pdf->cellAutoFontSize($pdf, 12, $alto, $cont++, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 40, $alto, $item->salida_producto->sucursal->nombre, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 40, $alto, $item->salida_producto->almacen->nombre, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 40, $alto, $item->tipo_salida->nombre, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 19, $alto, $item->cantidad, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 30, $alto, $item->salida_producto->user->full_name, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 30, $alto, $item->salida_producto->fecha_registro_t, $font_size, 5, 'N', 'L');
                $pdf->Ln();
            }

            // Guardar PDF o forzar descarga
            return response($pdf->Output('S'), 200)
                ->header('Content-Type', 'application/pdf')
                ->header('Content-Disposition', 'inline; filename="salida_productos' . time() . '.pdf"');
        } else {
            $spreadsheet = new Spreadsheet();
            $spreadsheet->getProperties()
                ->setCreator("ADMIN")
                ->setLastModifiedBy('Administración')
                ->setTitle('Registros')
                ->setSubject('Registros')
                ->setDescription('Registros')
                ->setKeywords('PHPSpreadsheet')
                ->setCategory('Listado');

            $sheet = $spreadsheet->getActiveSheet();

            $spreadsheet->getDefaultStyle()->getFont()->setName('Arial');

            $fila = 1;
            if (file_exists(public_path() . '/imgs/' . $this->configuracion->logo)) {
                $drawing = new \PhpOffice\PhpSpreadsheet\Worksheet\Drawing();
                $drawing->setName('logo');
                $drawing->setDescription('logo');
                $drawing->setPath(public_path() . '/imgs/' . $this->configuracion->logo); // put your path and image here
                $drawing->setCoordinates('A' . $fila);
                $drawing->setOffsetX(5);
                $drawing->setOffsetY(0);
                $drawing->setHeight(70);
                $drawing->setWorksheet($sheet);
            }

            $fila = 2;
            $sheet->setCellValue('A' . $fila, $this->configuracion->nombre_sistema);
            $sheet->mergeCells("A" . $fila . ":G" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':G' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':G' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $sheet->setCellValue('A' . $fila, "LISTADO DE SALIDA DE PRODUCTOS");
            $sheet->mergeCells("A" . $fila . ":G" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':G' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':G' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $titulo = '"TODOS LOS ALMACENES"';
            if ($almacen_id != "todos") {
                $almacen = Almacen::find($almacen_id);
                $titulo = '"' . $almacen->nombre . ' - ' . $almacen->sucursal->nombre . '"';
            }
            $sheet->setCellValue('A' . $fila, $titulo);
            $sheet->mergeCells("A" . $fila . ":G" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':G' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':G' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $fila++;
            $sheet->setCellValue('A' . $fila, 'NRO');
            $sheet->setCellValue('B' . $fila, 'SUCURSAL');
            $sheet->setCellValue('C' . $fila, 'ALMACÉN');
            $sheet->setCellValue('D' . $fila, 'TIPO SALIDA');
            $sheet->setCellValue('E' . $fila, 'CANTIDAD');
            $sheet->setCellValue('F' . $fila, 'RESPONSABLE');
            $sheet->setCellValue('G' . $fila, 'FECHA REGISTRO');
            $sheet->getStyle('A' . $fila . ':G' . $fila)->applyFromArray($this->headerTabla);
            $fila++;
            $cont = 1;
            foreach ($salida_detalles as $key => $item) {
                $sheet->setCellValue('A' . $fila, $cont++);
                $sheet->setCellValue('B' . $fila, $item->salida_producto->sucursal->nombre);
                $sheet->setCellValue('C' . $fila, $item->salida_producto->almacen->nombre);
                $sheet->setCellValue('D' . $fila, $item->tipo_salida->nombre);
                $sheet->setCellValue('E' . $fila, $item->cantidad);
                $sheet->setCellValue('F' . $fila, $item->salida_producto->user->full_name);
                $sheet->setCellValue('G' . $fila, $item->salida_producto->fecha_registro_t);
                $sheet->getStyle('A' . $fila . ':G' . $fila)->applyFromArray($this->bodyTabla);

                $fila++;
            }

            $sheet->getColumnDimension('A')->setWidth(12);
            $sheet->getColumnDimension('B')->setWidth(20);
            $sheet->getColumnDimension('C')->setWidth(20);
            $sheet->getColumnDimension('D')->setWidth(20);
            $sheet->getColumnDimension('E')->setWidth(15);
            $sheet->getColumnDimension('F')->setWidth(30);
            $sheet->getColumnDimension('G')->setWidth(15);

            foreach (range('A', 'G') as $columnID) {
                $sheet->getStyle($columnID)->getAlignment()->setWrapText(true);
            }

            $sheet->getPageSetup()->setOrientation(\PhpOffice\PhpSpreadsheet\Worksheet\PageSetup::ORIENTATION_LANDSCAPE);
            $sheet->getPageMargins()->setTop(0.5);
            $sheet->getPageMargins()->setRight(0.1);
            $sheet->getPageMargins()->setLeft(0.1);
            $sheet->getPageMargins()->setBottom(0.1);
            $sheet->getPageSetup()->setPrintArea('A:G');
            $sheet->getPageSetup()->setFitToWidth(1);
            $sheet->getPageSetup()->setFitToHeight(0);

            return response()->streamDownload(
                function () use ($spreadsheet) {
                    $writer = IOFactory::createWriter($spreadsheet, 'Xlsx');
                    $writer->save('php://output');
                },
                'salida_productos_' . time() . '.xlsx',
                [
                    'Content-Type' => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                ]
            );
        }
    }

    public function ventas()
    {
        return Inertia::render("Admin/Reportes/Ventas");
    }

    public function r_ventas(Request $request)
    {
        ini_set('memory_limit', '1024M');
        set_time_limit(-1);
        $almacen_id =  $request->almacen_id;
        $cliente_id =  $request->cliente_id;
        $user_id =  $request->user_id;
        $tipo_venta =  $request->tipo_venta;
        $tipo_pago =  $request->tipo_pago;
        $fecha_ini =  $request->fecha_ini;
        $fecha_fin =  $request->fecha_fin;
        $formato =  $request->formato;
        $ventas = Venta::select("ventas.*");

        if ($almacen_id && $almacen_id != 'todos') {
            $ventas->where('almacen_id', $almacen_id);
        }

        if ($cliente_id && $cliente_id != 'todos') {
            $ventas->where('cliente_id', $cliente_id);
        }

        if ($user_id && $user_id != 'todos') {
            $ventas->where('user_id', $user_id);
        }

        if ($tipo_venta && $tipo_venta != 'todos') {
            $ventas->where('tipo_venta', $tipo_venta);
        }

        if ($tipo_pago && $tipo_pago != 'todos') {
            $ventas->where('tipo_pago', $tipo_pago);
        }

        if ($fecha_ini && $fecha_fin) {
            $ventas->whereBetween('fecha', [$fecha_ini, $fecha_fin]);
        }

        $ventas = $ventas->get();

        if ($formato == 'pdf') {
            $pdf = new ReporteServiceTcpdf();
            $pdf->SetTitle('Lista de Ventas');
            $pdf->setMargins(1, 2, 2);
            $pdf->AddPage('L', 'LEGAL');
            $pdf->setPrintHeader(false);
            $pdf->setY(13);
            $pdf->SetFont('helvetica', 'B', 12);
            $pdf->Cell(0, 6, "LISTADO DE VENTAS", 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 10);
            $pdf->Cell(0, 5, "Expedido: " . date("d/m/Y"), 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 11);
            $titulo = '"TODOS LOS ALMACENES"';
            if ($almacen_id != "todos") {
                $almacen = Almacen::find($almacen_id);
                $titulo = '"' . $almacen->nombre . ' - ' . $almacen->sucursal->nombre . '"';
            }
            $pdf->Cell(0, 6, $titulo, 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 8);
            $pdf->setY(33);
            $alto = 10;
            $font_size = 8;
            $font_size2 = 9;
            $font_size3 = 10;

            $pdf->setFont("helvetica", "B", $font_size2);
            $pdf->cellAutoFontSize($pdf, 20, $alto, 'CÓDIGO', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 30, $alto, 'SUCURSAL', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 30, $alto, 'ALMACÉN', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 25, $alto, 'CLIENTE', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 25, $alto, 'DOCUMENTO', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 25, $alto, 'TIPO VENTA', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 25, $alto, 'MODO PAGO', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 23.5, $alto, 'SUBTOTAL', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 23.5, $alto, 'DESCUENTO', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 23.5, $alto, 'TOTAL', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 23.5, $alto, 'CANCELADO', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 23.5, $alto, 'SALDO', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 30, $alto, 'RESPONSABLE', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 25, $alto, 'FECHA Y HORA', $font_size, 5, 'B');
            $pdf->Ln();
            $s_subtotal = 0;
            $s_descuento = 0;
            $s_total = 0;
            $s_total_cancelado = 0;
            $s_saldo = 0;
            foreach ($ventas as $item) {
                $pdf->cellAutoFontSize($pdf, 20, $alto, $item->codigo_venta, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 30, $alto, $item->sucursal->nombre, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 30, $alto, $item->almacen->nombre, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 25, $alto, $item->cliente->nombre, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 25, $alto, $item->tipo_documento->nombre . ' ' . $item->nit_ci, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 25, $alto, $item->tipo_venta, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 25, $alto, $item->tipo_pago, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 23.5, $alto, $item->subtotal, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 23.5, $alto, $item->descuento, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 23.5, $alto, $item->total, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 23.5, $alto, $item->total_cancelado, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 23.5, $alto, $item->saldo, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 30, $alto, $item->user->full_name, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 25, $alto, $item->fecha_hora_t, $font_size, 5, 'N', 'L');

                $s_subtotal += (float)$item->subtotal;
                $s_descuento += (float)$item->descuento;
                $s_total += (float)$item->total;
                $s_total_cancelado += (float)$item->total_cancelado;
                $s_saldo += (float)$item->saldo;
                $pdf->Ln();
            }
            $pdf->cellAutoFontSize($pdf, 180, $alto, 'TOTALES', $font_size3, 5, 'B', 'R');
            $pdf->cellAutoFontSize($pdf, 23.5, $alto, number_format($s_subtotal, 2, ".", ""), $font_size2, 5, 'B', 'L');
            $pdf->cellAutoFontSize($pdf, 23.5, $alto, number_format($s_descuento, 2, ".", ""), $font_size2, 5, 'B', 'L');
            $pdf->cellAutoFontSize($pdf, 23.5, $alto, number_format($s_total, 2, ".", ""), $font_size2, 5, 'B', 'L');
            $pdf->cellAutoFontSize($pdf, 23.5, $alto, number_format($s_total_cancelado, 2, ".", ""), $font_size2, 5, 'B', 'L');
            $pdf->cellAutoFontSize($pdf, 23.5, $alto, number_format($s_saldo, 2, ".", ""), $font_size2, 5, 'B', 'L');


            // Guardar PDF o forzar descarga
            return response($pdf->Output('S'), 200)
                ->header('Content-Type', 'application/pdf')
                ->header('Content-Disposition', 'inline; filename="ventas' . time() . '.pdf"');
        } else {
            $spreadsheet = new Spreadsheet();
            $spreadsheet->getProperties()
                ->setCreator("ADMIN")
                ->setLastModifiedBy('Administración')
                ->setTitle('Registros')
                ->setSubject('Registros')
                ->setDescription('Registros')
                ->setKeywords('PHPSpreadsheet')
                ->setCategory('Listado');

            $sheet = $spreadsheet->getActiveSheet();

            $spreadsheet->getDefaultStyle()->getFont()->setName('Arial');

            $fila = 1;
            if (file_exists(public_path() . '/imgs/' . $this->configuracion->logo)) {
                $drawing = new \PhpOffice\PhpSpreadsheet\Worksheet\Drawing();
                $drawing->setName('logo');
                $drawing->setDescription('logo');
                $drawing->setPath(public_path() . '/imgs/' . $this->configuracion->logo); // put your path and image here
                $drawing->setCoordinates('A' . $fila);
                $drawing->setOffsetX(5);
                $drawing->setOffsetY(0);
                $drawing->setHeight(70);
                $drawing->setWorksheet($sheet);
            }

            $fila = 2;
            $sheet->setCellValue('A' . $fila, $this->configuracion->nombre_sistema);
            $sheet->mergeCells("A" . $fila . ":N" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':N' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':N' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $sheet->setCellValue('A' . $fila, "LISTADO DE VENTAS");
            $sheet->mergeCells("A" . $fila . ":N" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':N' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':N' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $titulo = '"TODOS LOS ALMACENES"';
            if ($almacen_id != "todos") {
                $almacen = Almacen::find($almacen_id);
                $titulo = '"' . $almacen->nombre . ' - ' . $almacen->sucursal->nombre . '"';
            }
            $sheet->setCellValue('A' . $fila, $titulo);
            $sheet->mergeCells("A" . $fila . ":N" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':N' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':N' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $fila++;
            $sheet->setCellValue('A' . $fila, 'CÓDIGO');
            $sheet->setCellValue('B' . $fila, 'SUCURSAL');
            $sheet->setCellValue('C' . $fila, 'ALMACÉN');
            $sheet->setCellValue('D' . $fila, 'CLIENTE');
            $sheet->setCellValue('E' . $fila, 'DOCUMENTO');
            $sheet->setCellValue('F' . $fila, 'TIPO VENTA');
            $sheet->setCellValue('G' . $fila, 'MODO PAGO');
            $sheet->setCellValue('H' . $fila, 'SUBTOTAL');
            $sheet->setCellValue('I' . $fila, 'DESCUENTO');
            $sheet->setCellValue('J' . $fila, 'TOTAL');
            $sheet->setCellValue('K' . $fila, 'CANCELADO');
            $sheet->setCellValue('L' . $fila, 'SALDO');
            $sheet->setCellValue('M' . $fila, 'RESPONSABLE');
            $sheet->setCellValue('N' . $fila, 'FECHA Y HORA');
            $sheet->getStyle('A' . $fila . ':N' . $fila)->applyFromArray($this->headerTabla);
            $fila++;
            $s_subtotal = 0;
            $s_descuento = 0;
            $s_total = 0;
            $s_total_cancelado = 0;
            $s_saldo = 0;
            foreach ($ventas as $key => $item) {
                $sheet->setCellValue('A' . $fila, $item->codigo_venta);
                $sheet->setCellValue('B' . $fila, $item->sucursal->nombre);
                $sheet->setCellValue('C' . $fila, $item->almacen->nombre);
                $sheet->setCellValue('D' . $fila, $item->cliente->nombre);
                $sheet->setCellValue('E' . $fila, $item->tipo_documento->nombre . ' ' . $item->nit_ci);
                $sheet->setCellValue('F' . $fila, $item->tipo_venta);
                $sheet->setCellValue('G' . $fila, $item->tipo_pago);
                $sheet->setCellValue('H' . $fila, $item->subtotal);
                $sheet->setCellValue('I' . $fila, $item->descuento);
                $sheet->setCellValue('J' . $fila, $item->total);
                $sheet->setCellValue('K' . $fila, $item->total_cancelado);
                $sheet->setCellValue('L' . $fila, $item->saldo);
                $sheet->setCellValue('M' . $fila, $item->user->full_name);
                $sheet->setCellValue('N' . $fila, $item->fecha_hora_t);
                $sheet->getStyle('A' . $fila . ':N' . $fila)->applyFromArray($this->bodyTabla);

                $s_subtotal += (float)$item->subtotal;
                $s_descuento += (float)$item->descuento;
                $s_total += (float)$item->total;
                $s_total_cancelado += (float)$item->total_cancelado;
                $s_saldo += (float)$item->saldo;
                $fila++;
            }
            $sheet->setCellValue('A' . $fila, "TOTALES");
            $sheet->mergeCells("A" . $fila . ":G" . $fila);  //COMBINAR CELDAS
            $sheet->setCellValue('H' . $fila, number_format($s_subtotal, 2, ".", ""));
            $sheet->setCellValue('I' . $fila, number_format($s_descuento, 2, ".", ""));
            $sheet->setCellValue('J' . $fila, number_format($s_total, 2, ".", ""));
            $sheet->setCellValue('K' . $fila, number_format($s_total_cancelado, 2, ".", ""));
            $sheet->setCellValue('L' . $fila, number_format($s_saldo, 2, ".", ""));
            $sheet->getStyle('A' . $fila . ':L' . $fila)->applyFromArray($this->headerTabla);

            $sheet->getColumnDimension('A')->setWidth(12);
            $sheet->getColumnDimension('B')->setWidth(20);
            $sheet->getColumnDimension('C')->setWidth(20);
            $sheet->getColumnDimension('D')->setWidth(20);
            $sheet->getColumnDimension('E')->setWidth(15);
            $sheet->getColumnDimension('F')->setWidth(30);
            $sheet->getColumnDimension('G')->setWidth(15);
            $sheet->getColumnDimension('H')->setWidth(15);
            $sheet->getColumnDimension('I')->setWidth(15);
            $sheet->getColumnDimension('J')->setWidth(10);
            $sheet->getColumnDimension('K')->setWidth(25);
            $sheet->getColumnDimension('L')->setWidth(15);
            $sheet->getColumnDimension('M')->setWidth(15);
            $sheet->getColumnDimension('N')->setWidth(10);

            foreach (range('A', 'N') as $columnID) {
                $sheet->getStyle($columnID)->getAlignment()->setWrapText(true);
            }

            $sheet->getPageSetup()->setOrientation(\PhpOffice\PhpSpreadsheet\Worksheet\PageSetup::ORIENTATION_LANDSCAPE);
            $sheet->getPageMargins()->setTop(0.5);
            $sheet->getPageMargins()->setRight(0.1);
            $sheet->getPageMargins()->setLeft(0.1);
            $sheet->getPageMargins()->setBottom(0.1);
            $sheet->getPageSetup()->setPrintArea('A:N');
            $sheet->getPageSetup()->setFitToWidth(1);
            $sheet->getPageSetup()->setFitToHeight(0);

            return response()->streamDownload(
                function () use ($spreadsheet) {
                    $writer = IOFactory::createWriter($spreadsheet, 'Xlsx');
                    $writer->save('php://output');
                },
                'ventas_' . time() . '.xlsx',
                [
                    'Content-Type' => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                ]
            );
        }
    }

    public function venta_detalles()
    {
        $almacens = $this->almacen_service->listado(1);
        $usuarios = $this->user_service->listado(1);
        $tipo_ventas = $this->tipo_venta_service->listado();
        $tipo_pagos = $this->tipo_pago_service->listado();
        return Inertia::render("Admin/Reportes/VentaDetalles", [
            "almacens" => $almacens,
            "usuarios" => $usuarios,
            "tipo_ventas" => $tipo_ventas,
            "tipo_pagos" => $tipo_pagos,
        ]);
    }

    public function r_venta_detalles(Request $request)
    {
        ini_set('memory_limit', '1024M');
        set_time_limit(-1);
        $almacen_id =  $request->almacen_id;
        $cliente_id =  $request->cliente_id;
        $user_id =  $request->user_id;
        $tipo_venta =  $request->tipo_venta;
        $tipo_pago =  $request->tipo_pago;
        $fecha_ini =  $request->fecha_ini;
        $fecha_fin =  $request->fecha_fin;
        $formato =  $request->formato;
        $ventas = Venta::select("ventas.*");

        if ($almacen_id && $almacen_id != 'todos') {
            $ventas->where('almacen_id', $almacen_id);
        }

        if ($cliente_id && $cliente_id != 'todos') {
            $ventas->where('cliente_id', $cliente_id);
        }

        if ($user_id && $user_id != 'todos') {
            $ventas->where('user_id', $user_id);
        }

        if ($tipo_venta && $tipo_venta != 'todos') {
            $ventas->where('tipo_venta', $tipo_venta);
        }

        if ($tipo_pago && $tipo_pago != 'todos') {
            $ventas->where('tipo_pago', $tipo_pago);
        }

        if ($fecha_ini && $fecha_fin) {
            $ventas->whereBetween('fecha', [$fecha_ini, $fecha_fin]);
        }

        $ventas = $ventas->get();

        if ($formato == 'pdf') {
            $pdf = new ReporteServiceTcpdf();
            $pdf->SetTitle('Venta Detalles');
            $pdf->setMargins(10, 2, 2);
            $pdf->AddPage('P', 'LETTER');
            $pdf->setPrintHeader(false);
            $pdf->setY(13);
            $pdf->SetFont('helvetica', 'B', 12);
            $pdf->Cell(0, 6, "VENTAS DETALLES", 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 10);
            $pdf->Cell(0, 5, "Expedido: " . date("d/m/Y"), 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 11);
            $titulo = '"TODOS LOS ALMACENES"';
            if ($almacen_id != "todos") {
                $almacen = Almacen::find($almacen_id);
                $titulo = '"' . $almacen->nombre . ' - ' . $almacen->sucursal->nombre . '"';
            }
            $pdf->Cell(0, 6, $titulo, 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 8);
            $pdf->setY(33);
            $alto = 7;
            $font_size = 8;
            $font_size2 = 9;
            $font_size3 = 10;

            $s_subtotal = 0;
            $s_descuento = 0;
            $s_total = 0;
            $s_total_cancelado = 0;
            $s_saldo = 0;


            foreach ($ventas as $item) {
                $pdf->setFont("helvetica", "B", $font_size2);
                $pdf->cellAutoFontSize($pdf, 100, $alto, 'Código Venta: ' . $item->codigo_venta, $font_size2, 5, 'B', 'L', 0);
                $pdf->cellAutoFontSize($pdf, 100, $alto, 'Fecha: ' . $item->fecha_hora_t, $font_size2, 5, 'B', 'L', 0);
                $pdf->Ln();
                $pdf->cellAutoFontSize($pdf, 100, $alto, 'Cliente: ' . $item->cliente->nombre, $font_size2, 5, 'B', 'L', 0);
                $pdf->cellAutoFontSize($pdf, 100, $alto, $item->tipo_documento->nombre . ': ' . $item->nit_ci, $font_size2, 5, 'B', 'L', 0);
                $pdf->Ln();
                $pdf->cellAutoFontSize($pdf, 100, $alto, 'Tipo de Venta: ' . $item->tipo_venta, $font_size, 5, 'B', 'L', 0);
                $pdf->cellAutoFontSize($pdf, 100, $alto, 'Tipo de Pago: ' . $item->tipo_pago, $font_size2, 5, 'B', 'L', 0);
                $pdf->Ln();
                $pdf->cellAutoFontSize($pdf, 100, $alto, 'Usuario: ' . $item->user->full_name, $font_size, 5, 'B', 'L', 0);
                $pdf->cellAutoFontSize($pdf, 100, $alto, 'Almacén-Sucursal: ' . $item->almacen->nombre . ' - ' . $item->sucursal->nombre, $font_size2, 5, 'B', 'L', 0);
                $pdf->Ln();
                $cant_total = 0;
                $cont = 1;

                $pdf->setFont("helvetica", "B", $font_size2);
                $pdf->cellAutoFontSize($pdf, 17, $alto, 'NRO', $font_size2, 5, 'B');
                $pdf->cellAutoFontSize($pdf, 30, $alto, 'CÓDIGO', $font_size2, 5, 'B');
                $pdf->cellAutoFontSize($pdf, 65, $alto, 'PRODUCTO', $font_size2, 5, 'B');
                $pdf->cellAutoFontSize($pdf, 25, $alto, 'C/U BS.', $font_size, 5, 'B');
                $pdf->cellAutoFontSize($pdf, 25, $alto, 'CANT.', $font_size2, 5, 'B');
                $pdf->cellAutoFontSize($pdf, 35, $alto, 'TOTAL BS.', $font_size, 5, 'B');
                $pdf->Ln();
                $alto = 8;
                foreach ($item->venta_detalles as $item_detalle) {
                    $pdf->cellAutoFontSize($pdf, 17, $alto, $cont++, $font_size, 5, 'N', 'L');
                    $pdf->cellAutoFontSize($pdf, 30, $alto, $item_detalle->producto->codigo, $font_size, 5, 'N', 'L');
                    $pdf->cellAutoFontSize($pdf, 65, $alto, $item_detalle->producto->nombre, $font_size, 5, 'N', 'L');
                    $pdf->cellAutoFontSize($pdf, 25, $alto, $item_detalle->precio, $font_size, 5, 'N', 'R');
                    $pdf->cellAutoFontSize($pdf, 25, $alto, $item_detalle->cantidad, $font_size, 5, 'N', 'R');
                    $pdf->cellAutoFontSize($pdf, 35, $alto, $item_detalle->total_uni, $font_size, 5, 'N', 'R');

                    $cant_total += (float)$item_detalle->cantidad;
                    $pdf->Ln();
                }
                $pdf->cellAutoFontSize($pdf, 162, $alto, 'TOTAL BS.', $font_size, 5, 'B', 'R');
                $pdf->cellAutoFontSize($pdf, 35, $alto, number_format($item->subtotal, 2, ".", ""), $font_size, 5, 'B', 'R');
                $pdf->Ln();
                $pdf->cellAutoFontSize($pdf, 162, $alto, 'DESCUENTO BS.', $font_size, 5, 'B', 'R');
                $pdf->cellAutoFontSize($pdf, 35, $alto, number_format($item->descuento, 2, ".", ""), $font_size, 5, 'B', 'R');
                $pdf->Ln();
                $pdf->cellAutoFontSize($pdf, 162, $alto, 'TOTAL FINAL BS.', $font_size, 5, 'B', 'R');
                $pdf->cellAutoFontSize($pdf, 35, $alto, number_format($item->total, 2, ".", ""), $font_size, 5, 'B', 'R');

                if ($item->tipo_venta == 'CRÉDITO') {
                    $pdf->Ln();
                    $pdf->cellAutoFontSize($pdf, 162, $alto, 'CANCELADO BS.', $font_size, 5, 'B', 'R');
                    $pdf->cellAutoFontSize($pdf, 35, $alto, number_format($item->total_cancelado, 2, ".", ""), $font_size2, 5, 'B', 'R');
                    $pdf->Ln();
                    $pdf->cellAutoFontSize($pdf, 162, $alto, 'SALDO BS.', $font_size, 5, 'B', 'R');
                    $pdf->cellAutoFontSize($pdf, 35, $alto, number_format($item->saldo, 2, ".", ""), $font_size2, 5, 'B', 'R');
                }

                $s_subtotal += (float)$item->subtotal;
                $s_descuento += (float)$item->descuento;
                $s_total += (float)$item->total;
                $s_total_cancelado += (float)$item->total_cancelado;
                $s_saldo += (float)$item->saldo;

                $pdf->Ln();
                $pdf->Ln();
            }

            $pdf->cellAutoFontSize($pdf, 196, $alto, 'RESUMEN DE VENTAS', $font_size3, 5, 'B', 'C');
            $pdf->Ln();
            $pdf->cellAutoFontSize($pdf, 32.7, $alto, 'SUBTOTALES BS.', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 32.6, $alto, 'DESCUENTOS BS.', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 32.6, $alto, 'TOTALES BS.', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 32.6, $alto, 'CANCELADOS BS.', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 32.6, $alto, 'SALDOS BS.', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 32.6, $alto, 'DIFERENCIA BS.', $font_size, 5, 'B');
            $pdf->Ln();
            $pdf->cellAutoFontSize($pdf, 32.7, $alto, number_format($s_subtotal, 2, ".", ""), $font_size2, 5, 'B', 'R');
            $pdf->cellAutoFontSize($pdf, 32.6, $alto, number_format($s_descuento, 2, ".", ""), $font_size2, 5, 'B', 'R');
            $pdf->cellAutoFontSize($pdf, 32.6, $alto, number_format($s_total, 2, ".", ""), $font_size2, 5, 'B', 'R');
            $pdf->cellAutoFontSize($pdf, 32.6, $alto, number_format($s_total_cancelado, 2, ".", ""), $font_size2, 5, 'B', 'R');
            $pdf->cellAutoFontSize($pdf, 32.6, $alto, number_format($s_saldo, 2, ".", ""), $font_size2, 5, 'B', 'R');
            $diferencia = (float)$s_total_cancelado - (float)($s_saldo);
            $pdf->cellAutoFontSize($pdf, 32.6, $alto, number_format($diferencia, 2, ".", ""), $font_size2, 5, 'B', 'R');


            // Guardar PDF o forzar descarga
            return response($pdf->Output('S'), 200)
                ->header('Content-Type', 'application/pdf')
                ->header('Content-Disposition', 'inline; filename="venta_detalles' . time() . '.pdf"');
        } else {
            $spreadsheet = new Spreadsheet();
            $spreadsheet->getProperties()
                ->setCreator("ADMIN")
                ->setLastModifiedBy('Administración')
                ->setTitle('Registros')
                ->setSubject('Registros')
                ->setDescription('Registros')
                ->setKeywords('PHPSpreadsheet')
                ->setCategory('Listado');

            $sheet = $spreadsheet->getActiveSheet();

            $spreadsheet->getDefaultStyle()->getFont()->setName('Arial');

            $fila = 1;
            if (file_exists(public_path() . '/imgs/' . $this->configuracion->logo)) {
                $drawing = new \PhpOffice\PhpSpreadsheet\Worksheet\Drawing();
                $drawing->setName('logo');
                $drawing->setDescription('logo');
                $drawing->setPath(public_path() . '/imgs/' . $this->configuracion->logo); // put your path and image here
                $drawing->setCoordinates('A' . $fila);
                $drawing->setOffsetX(5);
                $drawing->setOffsetY(0);
                $drawing->setHeight(70);
                $drawing->setWorksheet($sheet);
            }

            $fila = 2;
            $sheet->setCellValue('A' . $fila, $this->configuracion->nombre_sistema);
            $sheet->mergeCells("A" . $fila . ":F" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':F' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $sheet->setCellValue('A' . $fila, "VENTA DETALLES");
            $sheet->mergeCells("A" . $fila . ":F" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':F' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $titulo = '"TODOS LOS ALMACENES"';
            if ($almacen_id != "todos") {
                $almacen = Almacen::find($almacen_id);
                $titulo = '"' . $almacen->nombre . ' - ' . $almacen->sucursal->nombre . '"';
            }
            $sheet->setCellValue('A' . $fila, $titulo);
            $sheet->mergeCells("A" . $fila . ":F" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':F' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $fila++;


            $s_subtotal = 0;
            $s_descuento = 0;
            $s_total = 0;
            $s_total_cancelado = 0;
            $s_saldo = 0;

            foreach ($ventas as $item) {
                $sheet->setCellValue('A' . $fila, "Código Venta:");
                $sheet->mergeCells("A" . $fila . ":B" . $fila);  //COMBINAR CELDAS
                $sheet->setCellValue('C' . $fila, $item->codigo_venta);
                $sheet->setCellValue('D' . $fila, "Fecha:");
                $sheet->setCellValue('E' . $fila, $item->fecha_hora_t);
                $sheet->mergeCells("E" . $fila . ":F" . $fila);  //COMBINAR CELDAS
                $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->bodyTabla);
                $fila++;
                $sheet->setCellValue('A' . $fila, "Cliente:");
                $sheet->mergeCells("A" . $fila . ":B" . $fila);  //COMBINAR CELDAS
                $sheet->setCellValue('C' . $fila, $item->cliente->nombre);
                $sheet->setCellValue('D' . $fila, $item->tipo_documento->nombre . ':');
                $sheet->setCellValue('E' . $fila, $item->nit_ci);
                $sheet->mergeCells("E" . $fila . ":F" . $fila);  //COMBINAR CELDAS
                $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->bodyTabla);
                $fila++;
                $sheet->setCellValue('A' . $fila, "Tipo de Venta:");
                $sheet->mergeCells("A" . $fila . ":B" . $fila);  //COMBINAR CELDAS
                $sheet->setCellValue('C' . $fila, $item->tipo_venta);
                $sheet->setCellValue('D' . $fila, "Tipo de Pago");
                $sheet->setCellValue('F' . $fila, $item->tipo_pago);
                $sheet->mergeCells("E" . $fila . ":F" . $fila);  //COMBINAR CELDAS
                $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->bodyTabla);
                $fila++;
                $sheet->setCellValue('A' . $fila, "Usuario:");
                $sheet->mergeCells("A" . $fila . ":B" . $fila);  //COMBINAR CELDAS
                $sheet->setCellValue('C' . $fila, $item->user->full_name);
                $sheet->setCellValue('D' . $fila, "Almacén-Sucursal");
                $sheet->setCellValue('F' . $fila, $item->almacen->nombre . ' - ' . $item->sucursal->nombre);
                $sheet->mergeCells("E" . $fila . ":F" . $fila);  //COMBINAR CELDAS
                $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->bodyTabla);
                $fila++;
                $cant_total = 0;
                $cont = 1;
                $sheet->setCellValue('A' . $fila, 'NRO');
                $sheet->setCellValue('B' . $fila, 'CÓDIGO');
                $sheet->setCellValue('C' . $fila, 'PRODUCTO');
                $sheet->setCellValue('D' . $fila, 'C/U BS.');
                $sheet->setCellValue('E' . $fila, 'CANT.');
                $sheet->setCellValue('F' . $fila, 'TOTAL BS.');
                $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->headerTabla);
                $fila++;
                $cont = 1;
                foreach ($item->venta_detalles as $key => $item_detalle) {
                    $sheet->setCellValue('A' . $fila, $cont++);
                    $sheet->setCellValue('B' . $fila, $item_detalle->producto->codigo);
                    $sheet->setCellValue('C' . $fila, $item_detalle->producto->nombre);
                    $sheet->setCellValue('D' . $fila, $item_detalle->precio);
                    $sheet->setCellValue('E' . $fila, $item_detalle->cantidad);
                    $sheet->setCellValue('F' . $fila, $item_detalle->total_uni);
                    $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->bodyTabla);

                    $cant_total += (float)$item_detalle->cantidad;
                    $fila++;
                }
                $sheet->setCellValue('A' . $fila, "TOTAL BS.");
                $sheet->mergeCells("A" . $fila . ":E" . $fila);  //COMBINAR CELDAS
                $sheet->setCellValue('F' . $fila, number_format($item->subtotal, 2, ".", ""));
                $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->headerTabla);
                $fila++;
                $sheet->setCellValue('A' . $fila, "DESCUENTO BS.");
                $sheet->mergeCells("A" . $fila . ":E" . $fila);  //COMBINAR CELDAS
                $sheet->setCellValue('F' . $fila, number_format($item->descuento, 2, ".", ""));
                $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->headerTabla);
                $fila++;
                $sheet->setCellValue('A' . $fila, "TOTAL FINAL BS.");
                $sheet->mergeCells("A" . $fila . ":E" . $fila);  //COMBINAR CELDAS
                $sheet->setCellValue('F' . $fila, number_format($item->total, 2, ".", ""));
                $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->headerTabla);
                $fila++;
                if ($item->tipo_venta == 'CRÉDITO') {
                    $sheet->setCellValue('A' . $fila, "CANCELADO BS.");
                    $sheet->mergeCells("A" . $fila . ":E" . $fila);  //COMBINAR CELDAS
                    $sheet->setCellValue('F' . $fila, number_format($item->total_cancelado, 2, ".", ""));
                    $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->headerTabla);
                    $fila++;
                    $sheet->setCellValue('A' . $fila, "SALDO BS.");
                    $sheet->mergeCells("A" . $fila . ":E" . $fila);  //COMBINAR CELDAS
                    $sheet->setCellValue('F' . $fila, number_format($item->saldo, 2, ".", ""));
                    $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->headerTabla);
                    $fila++;
                }

                $s_subtotal += (float)$item->subtotal;
                $s_descuento += (float)$item->descuento;
                $s_total += (float)$item->total;
                $s_total_cancelado += (float)$item->total_cancelado;
                $s_saldo += (float)$item->saldo;
                $fila++;
                $fila++;
                $fila++;
            }

            $sheet->setCellValue('A' . $fila, "RESUMEN DE VENTAS");
            $sheet->mergeCells("A" . $fila . ":F" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->headerTabla);
            $fila++;
            $sheet->setCellValue('A' . $fila, 'SUBTOTALES BS.');
            $sheet->setCellValue('B' . $fila, 'DESCUENTOS BS.');
            $sheet->setCellValue('C' . $fila, 'TOTALES BS.');
            $sheet->setCellValue('D' . $fila, 'CANCELADOS BS.');
            $sheet->setCellValue('E' . $fila, 'SALDOS BS.');
            $sheet->setCellValue('F' . $fila, 'DIFERENCIA BS.');
            $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->headerTabla);
            $fila++;
            $sheet->setCellValue('A' . $fila, number_format($s_subtotal, 2, ".", ""));
            $sheet->setCellValue('B' . $fila, number_format($s_descuento, 2, ".", ""));
            $sheet->setCellValue('C' . $fila, number_format($s_total, 2, ".", ""));
            $sheet->setCellValue('D' . $fila, number_format($s_total_cancelado, 2, ".", ""));
            $sheet->setCellValue('E' . $fila, number_format($s_saldo, 2, ".", ""));
            $diferencia = (float)$s_total_cancelado - (float)($s_saldo);
            $sheet->setCellValue('F' . $fila, number_format($diferencia, 2, ".", ""));
            $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->bodyTabla);

            $sheet->getColumnDimension('A')->setWidth(12);
            $sheet->getColumnDimension('B')->setWidth(20);
            $sheet->getColumnDimension('C')->setWidth(20);
            $sheet->getColumnDimension('D')->setWidth(20);
            $sheet->getColumnDimension('E')->setWidth(15);
            $sheet->getColumnDimension('F')->setWidth(30);

            foreach (range('A', 'F') as $columnID) {
                $sheet->getStyle($columnID)->getAlignment()->setWrapText(true);
            }

            $sheet->getPageSetup()->setOrientation(\PhpOffice\PhpSpreadsheet\Worksheet\PageSetup::ORIENTATION_LANDSCAPE);
            $sheet->getPageMargins()->setTop(0.5);
            $sheet->getPageMargins()->setRight(0.1);
            $sheet->getPageMargins()->setLeft(0.1);
            $sheet->getPageMargins()->setBottom(0.1);
            $sheet->getPageSetup()->setPrintArea('A:F');
            $sheet->getPageSetup()->setFitToWidth(1);
            $sheet->getPageSetup()->setFitToHeight(0);

            return response()->streamDownload(
                function () use ($spreadsheet) {
                    $writer = IOFactory::createWriter($spreadsheet, 'Xlsx');
                    $writer->save('php://output');
                },
                'venta_detalles_' . time() . '.xlsx',
                [
                    'Content-Type' => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                ]
            );
        }
    }

    public function proformas()
    {
        return Inertia::render("Admin/Reportes/Proformas");
    }

    public function r_proformas(Request $request)
    {
        ini_set('memory_limit', '1024M');
        set_time_limit(-1);
        $almacen_id =  $request->almacen_id;
        $cliente_id =  $request->cliente_id;
        $user_id =  $request->user_id;
        $fecha_ini =  $request->fecha_ini;
        $fecha_fin =  $request->fecha_fin;
        $formato =  $request->formato;
        $proformas = Proforma::select("proformas.*");

        if ($almacen_id && $almacen_id != 'todos') {
            $proformas->where('almacen_id', $almacen_id);
        }

        if ($cliente_id && $cliente_id != 'todos') {
            $proformas->where('cliente_id', $cliente_id);
        }

        if ($user_id && $user_id != 'todos') {
            $proformas->where('user_id', $user_id);
        }

        if ($fecha_ini && $fecha_fin) {
            $proformas->whereBetween('fecha', [$fecha_ini, $fecha_fin]);
        }

        $proformas = $proformas->get();

        if ($formato == 'pdf') {
            $pdf = new ReporteServiceTcpdf();
            $pdf->SetTitle('Lista de Proformas');
            $pdf->setMargins(1, 2, 2);
            $pdf->AddPage('L', 'LETTER');
            $pdf->setPrintHeader(false);
            $pdf->setY(13);
            $pdf->SetFont('helvetica', 'B', 12);
            $pdf->Cell(0, 6, "LISTADO DE PROFORMAS", 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 10);
            $pdf->Cell(0, 5, "Expedido: " . date("d/m/Y"), 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 11);
            $titulo = '"TODOS LOS ALMACENES"';
            if ($almacen_id != "todos") {
                $almacen = Almacen::find($almacen_id);
                $titulo = '"' . $almacen->nombre . ' - ' . $almacen->sucursal->nombre . '"';
            }
            $pdf->Cell(0, 6, $titulo, 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 8);
            $pdf->setY(33);
            $alto = 10;
            $font_size = 8;
            $font_size2 = 9;
            $font_size3 = 10;

            $pdf->setFont("helvetica", "B", $font_size2);
            $pdf->cellAutoFontSize($pdf, 20, $alto, 'CÓDIGO', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 30, $alto, 'SUCURSAL', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 30, $alto, 'ALMACÉN', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 35, $alto, 'CLIENTE', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 35, $alto, 'DOCUMENTO', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 23.5, $alto, 'SUBTOTAL', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 23.5, $alto, 'DESCUENTO', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 23.5, $alto, 'TOTAL', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 30, $alto, 'RESPONSABLE', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 25, $alto, 'FECHA Y HORA', $font_size, 5, 'B');
            $pdf->Ln();
            $s_subtotal = 0;
            $s_descuento = 0;
            $s_total = 0;
            foreach ($proformas as $item) {
                $pdf->cellAutoFontSize($pdf, 20, $alto, $item->codigo_proforma, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 30, $alto, $item->sucursal->nombre, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 30, $alto, $item->almacen->nombre, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 35, $alto, $item->cliente->nombre, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 35, $alto, $item->tipo_documento->nombre . ' ' . $item->nit_ci, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 23.5, $alto, $item->subtotal, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 23.5, $alto, $item->descuento, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 23.5, $alto, $item->total, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 30, $alto, $item->user->full_name, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 25, $alto, $item->fecha_hora_t, $font_size, 5, 'N', 'L');

                $s_subtotal += (float)$item->subtotal;
                $s_descuento += (float)$item->descuento;
                $s_total += (float)$item->total;
                $pdf->Ln();
            }
            $pdf->cellAutoFontSize($pdf, 150, $alto, 'TOTALES', $font_size3, 5, 'B', 'R');
            $pdf->cellAutoFontSize($pdf, 23.5, $alto, number_format($s_subtotal, 2, ".", ""), $font_size2, 5, 'B', 'L');
            $pdf->cellAutoFontSize($pdf, 23.5, $alto, number_format($s_descuento, 2, ".", ""), $font_size2, 5, 'B', 'L');
            $pdf->cellAutoFontSize($pdf, 23.5, $alto, number_format($s_total, 2, ".", ""), $font_size2, 5, 'B', 'L');


            // Guardar PDF o forzar descarga
            return response($pdf->Output('S'), 200)
                ->header('Content-Type', 'application/pdf')
                ->header('Content-Disposition', 'inline; filename="proformas' . time() . '.pdf"');
        } else {
            $spreadsheet = new Spreadsheet();
            $spreadsheet->getProperties()
                ->setCreator("ADMIN")
                ->setLastModifiedBy('Administración')
                ->setTitle('Registros')
                ->setSubject('Registros')
                ->setDescription('Registros')
                ->setKeywords('PHPSpreadsheet')
                ->setCategory('Listado');

            $sheet = $spreadsheet->getActiveSheet();

            $spreadsheet->getDefaultStyle()->getFont()->setName('Arial');

            $fila = 1;
            if (file_exists(public_path() . '/imgs/' . $this->configuracion->logo)) {
                $drawing = new \PhpOffice\PhpSpreadsheet\Worksheet\Drawing();
                $drawing->setName('logo');
                $drawing->setDescription('logo');
                $drawing->setPath(public_path() . '/imgs/' . $this->configuracion->logo); // put your path and image here
                $drawing->setCoordinates('A' . $fila);
                $drawing->setOffsetX(5);
                $drawing->setOffsetY(0);
                $drawing->setHeight(70);
                $drawing->setWorksheet($sheet);
            }

            $fila = 2;
            $sheet->setCellValue('A' . $fila, $this->configuracion->nombre_sistema);
            $sheet->mergeCells("A" . $fila . ":J" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':J' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':J' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $sheet->setCellValue('A' . $fila, "LISTADO DE PROFORMAS");
            $sheet->mergeCells("A" . $fila . ":J" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':J' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':J' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $titulo = '"TODOS LOS ALMACENES"';
            if ($almacen_id != "todos") {
                $almacen = Almacen::find($almacen_id);
                $titulo = '"' . $almacen->nombre . ' - ' . $almacen->sucursal->nombre . '"';
            }
            $sheet->setCellValue('A' . $fila, $titulo);
            $sheet->mergeCells("A" . $fila . ":J" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':J' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':J' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $fila++;
            $sheet->setCellValue('A' . $fila, 'CÓDIGO');
            $sheet->setCellValue('B' . $fila, 'SUCURSAL');
            $sheet->setCellValue('C' . $fila, 'ALMACÉN');
            $sheet->setCellValue('D' . $fila, 'CLIENTE');
            $sheet->setCellValue('E' . $fila, 'DOCUMENTO');
            $sheet->setCellValue('F' . $fila, 'SUBTOTAL');
            $sheet->setCellValue('G' . $fila, 'DESCUENTO');
            $sheet->setCellValue('H' . $fila, 'TOTAL');
            $sheet->setCellValue('I' . $fila, 'RESPONSABLE');
            $sheet->setCellValue('J' . $fila, 'FECHA Y HORA');
            $sheet->getStyle('A' . $fila . ':J' . $fila)->applyFromArray($this->headerTabla);
            $fila++;
            $s_subtotal = 0;
            $s_descuento = 0;
            $s_total = 0;
            $s_total_cancelado = 0;
            $s_saldo = 0;
            foreach ($proformas as $key => $item) {
                $sheet->setCellValue('A' . $fila, $item->codigo_proforma);
                $sheet->setCellValue('B' . $fila, $item->sucursal->nombre);
                $sheet->setCellValue('C' . $fila, $item->almacen->nombre);
                $sheet->setCellValue('D' . $fila, $item->cliente->nombre);
                $sheet->setCellValue('E' . $fila, $item->tipo_documento->nombre . ' ' . $item->nit_ci);
                $sheet->setCellValue('F' . $fila, $item->subtotal);
                $sheet->setCellValue('G' . $fila, $item->descuento);
                $sheet->setCellValue('H' . $fila, $item->total);
                $sheet->setCellValue('I' . $fila, $item->user->full_name);
                $sheet->setCellValue('J' . $fila, $item->fecha_hora_t);
                $sheet->getStyle('A' . $fila . ':J' . $fila)->applyFromArray($this->bodyTabla);

                $s_subtotal += (float)$item->subtotal;
                $s_descuento += (float)$item->descuento;
                $s_total += (float)$item->total;
                $fila++;
            }
            $sheet->setCellValue('A' . $fila, "TOTALES");
            $sheet->mergeCells("A" . $fila . ":E" . $fila);  //COMBINAR CELDAS
            $sheet->setCellValue('F' . $fila, number_format($s_subtotal, 2, ".", ""));
            $sheet->setCellValue('G' . $fila, number_format($s_descuento, 2, ".", ""));
            $sheet->setCellValue('H' . $fila, number_format($s_total, 2, ".", ""));
            $sheet->getStyle('A' . $fila . ':H' . $fila)->applyFromArray($this->headerTabla);

            $sheet->getColumnDimension('A')->setWidth(12);
            $sheet->getColumnDimension('B')->setWidth(20);
            $sheet->getColumnDimension('C')->setWidth(20);
            $sheet->getColumnDimension('D')->setWidth(20);
            $sheet->getColumnDimension('E')->setWidth(15);
            $sheet->getColumnDimension('F')->setWidth(30);
            $sheet->getColumnDimension('G')->setWidth(15);
            $sheet->getColumnDimension('H')->setWidth(15);
            $sheet->getColumnDimension('I')->setWidth(15);
            $sheet->getColumnDimension('J')->setWidth(10);

            foreach (range('A', 'J') as $columnID) {
                $sheet->getStyle($columnID)->getAlignment()->setWrapText(true);
            }

            $sheet->getPageSetup()->setOrientation(\PhpOffice\PhpSpreadsheet\Worksheet\PageSetup::ORIENTATION_LANDSCAPE);
            $sheet->getPageMargins()->setTop(0.5);
            $sheet->getPageMargins()->setRight(0.1);
            $sheet->getPageMargins()->setLeft(0.1);
            $sheet->getPageMargins()->setBottom(0.1);
            $sheet->getPageSetup()->setPrintArea('A:J');
            $sheet->getPageSetup()->setFitToWidth(1);
            $sheet->getPageSetup()->setFitToHeight(0);

            return response()->streamDownload(
                function () use ($spreadsheet) {
                    $writer = IOFactory::createWriter($spreadsheet, 'Xlsx');
                    $writer->save('php://output');
                },
                'proformas_' . time() . '.xlsx',
                [
                    'Content-Type' => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                ]
            );
        }
    }

    public function recepcions()
    {
        $almacens = $this->almacen_service->listado(1);
        $proveedors = $this->proveedor_service->listado();
        $usuarios = $this->user_service->listado(1);
        $tipo_compras = $this->tipo_compra_service->listado();
        return Inertia::render("Admin/Reportes/Recepcions", [
            "almacens" => $almacens,
            "usuarios" => $usuarios,
            "proveedors" => $proveedors,
            "tipo_compras" => $tipo_compras,
        ]);
    }

    public function r_recepcions(Request $request)
    {
        ini_set('memory_limit', '1024M');
        set_time_limit(-1);
        $almacen_id =  $request->almacen_id;
        $ingreso_producto_id =  $request->ingreso_producto_id;
        $proveedor_id =  $request->proveedor_id;
        $user_id =  $request->user_id;
        $tipo_compra =  $request->tipo_compra;
        $fecha_ini =  $request->fecha_ini;
        $fecha_fin =  $request->fecha_fin;
        $formato =  $request->formato;
        $ingreso_productos = IngresoProducto::select("ingreso_productos.*");

        if ($almacen_id && $almacen_id != 'todos') {
            $ingreso_productos->where('almacen_id', $almacen_id);
        }

        if ($ingreso_producto_id) {
            $ingreso_productos->where('id', $ingreso_producto_id);
        }

        if ($proveedor_id && $proveedor_id != 'todos') {
            $ingreso_productos->where('proveedor_id', $proveedor_id);
        }

        if ($user_id && $user_id != 'todos') {
            $ingreso_productos->where('user_id', $user_id);
        }

        if ($tipo_compra && $tipo_compra != 'todos') {
            $ingreso_productos->where('tipo_compra', $tipo_compra);
        }

        if ($fecha_ini && $fecha_fin && !$ingreso_producto_id) {
            $ingreso_productos->whereBetween('fecha_registro', [$fecha_ini, $fecha_fin]);
        }

        $ingreso_productos = $ingreso_productos->get();

        if ($formato == 'pdf') {
            $pdf = new ReporteServiceTcpdf();
            $pdf->SetTitle('Recepción Compras');
            $pdf->setMargins(10, 2, 2);
            $pdf->AddPage('P', 'LETTER');
            $pdf->setPrintHeader(false);
            $pdf->setY(13);
            $pdf->SetFont('helvetica', 'B', 12);
            $pdf->Cell(0, 6, "RECEPCIÓN DE COMPRAS", 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 10);
            $pdf->Cell(0, 5, "Expedido: " . date("d/m/Y"), 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 11);
            $titulo = '"TODOS LOS ALMACENES"';
            if ($almacen_id != "todos") {
                $almacen = Almacen::find($almacen_id);
                $titulo = '"' . $almacen->nombre . ' - ' . $almacen->sucursal->nombre . '"';
            }
            $pdf->Cell(0, 6, $titulo, 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 8);
            $pdf->setY(33);
            $alto = 7;
            $font_size = 8;
            $font_size2 = 9;
            $font_size3 = 10;

            foreach ($ingreso_productos as $item) {
                $pdf->setFont("helvetica", "B", $font_size2);
                $pdf->cellAutoFontSize($pdf, 100, $alto, 'Código Compra: ' . $item->codigo, $font_size2, 5, 'B', 'L', 0);
                $pdf->cellAutoFontSize($pdf, 100, $alto, 'Fecha: ' . $item->fecha_registro_t, $font_size2, 5, 'B', 'L', 0);
                $pdf->Ln();
                $pdf->cellAutoFontSize($pdf, 100, $alto, 'Proveedor: ' . $item->proveedor->nombre, $font_size2, 5, 'B', 'L', 0);
                $pdf->cellAutoFontSize($pdf, 100, $alto, 'Tipo de Ingreso: ' . $item->tipo_ingreso->nombre, $font_size2, 5, 'B', 'L', 0);
                $pdf->Ln();
                $pdf->cellAutoFontSize($pdf, 100, $alto, 'Tipo de Compra: ' . $item->tipo_compra, $font_size, 5, 'B', 'L', 0);
                $pdf->cellAutoFontSize($pdf, 100, $alto, 'Responsable: ' .  $item->user->full_name, $font_size2, 5, 'B', 'L', 0);
                $pdf->Ln();
                $pdf->cellAutoFontSize($pdf, 100, $alto, 'Almacén-Sucursal: ' . $item->user->full_name, $font_size, 5, 'B', 'L', 0);
                $pdf->cellAutoFontSize($pdf, 100, $alto, 'Descripción: ' . $item->descripcion, $font_size2, 5, 'B', 'L', 0);
                $pdf->Ln();
                $pdf->cellAutoFontSize($pdf, 100, $alto, 'Total Compra Bs.: ' . $item->total, $font_size, 5, 'B', 'L', 0);
                $pdf->cellAutoFontSize($pdf, 100, $alto, 'Total Cancelado Bs.: '  . $item->total_cancelado, $font_size2, 5, 'B', 'L', 0);
                $pdf->Ln();
                $pdf->cellAutoFontSize($pdf, 100, $alto, 'Saldo Bs.: ' . $item->saldo, $font_size, 5, 'B', 'L', 0);
                $pdf->cellAutoFontSize($pdf, 100, $alto, 'Estado Compra: ' .  $item->estado_ingreso, $font_size2, 5, 'B', 'L', 0);
                $pdf->Ln();
                $pdf->cellAutoFontSize($pdf, 100, $alto, 'Faltantes:  '
                    . $item->faltantes, $font_size2, 5, 'B', 'L', 0);
                $pdf->Ln();
                $cant_total = 0;
                $cont = 1;
                $alto = 8;
                foreach ($item->ingreso_detalles as $item_detalle) {
                    $pdf->SetFillColor(239, 239, 239);
                    $pdf->setFont("helvetica", "B", $font_size2);
                    $pdf->cellAutoFontSize($pdf, 196, $alto, $cont++ . ') ' . $item_detalle->producto->codigo . ' - ' . $item_detalle->producto->nombre, $font_size2, 5, 'B', 'L', 1, 1);
                    $pdf->Ln();
                    $pdf->cellAutoFontSize($pdf, 40, $alto, 'Solicitado: ' . $item_detalle->cantidad, $font_size2, 5, 'B', 'L', 1, 1);
                    $pdf->cellAutoFontSize($pdf, 40, $alto, 'Recibido: ' . $item_detalle->verificado, $font_size2, 5, 'B', 'L', 1, 1);
                    $pdf->cellAutoFontSize($pdf, 116, $alto, 'Faltantes: ' . $item_detalle->faltantes, $font_size2, 5, 'B', 'L', 1, 1);
                    $pdf->Ln();
                    $cant_total += (float)$item_detalle->cantidad;
                    $pdf->cellAutoFontSize($pdf, 20, $alto, 'NRO', $font_size2, 5, 'B', 'C');
                    $pdf->cellAutoFontSize($pdf, 100, $alto, 'ALMACÉN', $font_size2, 5, 'B', 'C');
                    $pdf->cellAutoFontSize($pdf, 25, $alto, 'CANTIDAD', $font_size2, 5, 'B', 'C');
                    $pdf->cellAutoFontSize($pdf, 51, $alto, 'RESPONSABLE', $font_size2, 5, 'B', 'C');
                    $pdf->Ln();
                    $cont_recep = 1;

                    $ingreso_recepcions = $item_detalle->ingreso_recepcions;
                    if ($fecha_ini && $fecha_fin && !$ingreso_producto_id) {
                        $$ingreso_recepcions = $item_detalle->ingreso_recepcions->where("tipo", "RECEPCION")->whereBetween('fecha_registro', [$fecha_ini, $fecha_fin]);
                    }

                    foreach ($ingreso_recepcions as $item_recepcion) {
                        $pdf->cellAutoFontSize($pdf, 20, $alto, $cont_recep++, $font_size2, 5, 'N', 'L');
                        $pdf->cellAutoFontSize($pdf, 100, $alto, $item_recepcion->almacen->nombre . ' - ' . $item_recepcion->sucursal->nombre, $font_size2, 5, 'N', 'L');
                        $pdf->cellAutoFontSize($pdf, 25, $alto, $item_recepcion->cantidad, $font_size2, 5, 'N', 'C');
                        $pdf->cellAutoFontSize($pdf, 51, $alto, $item_recepcion->user->full_name, $font_size2, 5, 'N', 'L');
                        $pdf->Ln();
                    }
                }
                $pdf->Ln();
            }

            // Guardar PDF o forzar descarga
            return response($pdf->Output('S'), 200)
                ->header('Content-Type', 'application/pdf')
                ->header('Content-Disposition', 'inline; filename="recepcions' . time() . '.pdf"');
        } else {
            $spreadsheet = new Spreadsheet();
            $spreadsheet->getProperties()
                ->setCreator("ADMIN")
                ->setLastModifiedBy('Administración')
                ->setTitle('Registros')
                ->setSubject('Registros')
                ->setDescription('Registros')
                ->setKeywords('PHPSpreadsheet')
                ->setCategory('Listado');

            $sheet = $spreadsheet->getActiveSheet();

            $spreadsheet->getDefaultStyle()->getFont()->setName('Arial');

            $fila = 1;
            if (file_exists(public_path() . '/imgs/' . $this->configuracion->logo)) {
                $drawing = new \PhpOffice\PhpSpreadsheet\Worksheet\Drawing();
                $drawing->setName('logo');
                $drawing->setDescription('logo');
                $drawing->setPath(public_path() . '/imgs/' . $this->configuracion->logo); // put your path and image here
                $drawing->setCoordinates('A' . $fila);
                $drawing->setOffsetX(5);
                $drawing->setOffsetY(0);
                $drawing->setHeight(70);
                $drawing->setWorksheet($sheet);
            }

            $fila = 2;
            $sheet->setCellValue('A' . $fila, $this->configuracion->nombre_sistema);
            $sheet->mergeCells("A" . $fila . ":F" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':F' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $sheet->setCellValue('A' . $fila, "RECEPCIÓN DE COMPRAS");
            $sheet->mergeCells("A" . $fila . ":F" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':F' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $titulo = '"TODOS LOS ALMACENES"';
            if ($almacen_id != "todos") {
                $almacen = Almacen::find($almacen_id);
                $titulo = '"' . $almacen->nombre . ' - ' . $almacen->sucursal->nombre . '"';
            }
            $sheet->setCellValue('A' . $fila, $titulo);
            $sheet->mergeCells("A" . $fila . ":F" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':F' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $fila++;

            foreach ($ingreso_productos as $item) {
                $sheet->setCellValue('A' . $fila, "Código Compra:");
                $sheet->mergeCells("A" . $fila . ":B" . $fila);  //COMBINAR CELDAS
                $sheet->setCellValue('C' . $fila, $item->codigo);
                $sheet->setCellValue('D' . $fila, "Fecha:");
                $sheet->setCellValue('E' . $fila, $item->fecha_registro_t);
                $sheet->mergeCells("E" . $fila . ":F" . $fila);  //COMBINAR CELDAS
                $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->bodyTabla);
                $fila++;
                $sheet->setCellValue('A' . $fila, "Proveedor:");
                $sheet->mergeCells("A" . $fila . ":B" . $fila);  //COMBINAR CELDAS
                $sheet->setCellValue('C' . $fila, $item->proveedor->nombre);
                $sheet->setCellValue('D' . $fila, 'Tipo de Ingreso:');
                $sheet->setCellValue('E' . $fila, $item->tipo_ingreso->nombre);
                $sheet->mergeCells("E" . $fila . ":F" . $fila);  //COMBINAR CELDAS
                $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->bodyTabla);
                $fila++;
                $sheet->setCellValue('A' . $fila, "Tipo de Compra:");
                $sheet->mergeCells("A" . $fila . ":B" . $fila);  //COMBINAR CELDAS
                $sheet->setCellValue('C' . $fila, $item->tipo_compra);
                $sheet->setCellValue('D' . $fila, "Responsable");
                $sheet->setCellValue('F' . $fila, $item->user->full_name);
                $sheet->mergeCells("E" . $fila . ":F" . $fila);  //COMBINAR CELDAS
                $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->bodyTabla);
                $fila++;
                $sheet->setCellValue('A' . $fila, "Almacén-Sucursal:");
                $sheet->mergeCells("A" . $fila . ":B" . $fila);  //COMBINAR CELDAS
                $sheet->setCellValue('C' . $fila, $item->almacen->nombre . ' - ' . $item->sucursal->nombre);
                $sheet->setCellValue('D' . $fila, "Descripción:");
                $sheet->setCellValue('F' . $fila, $item->descripcion);
                $sheet->mergeCells("E" . $fila . ":F" . $fila);  //COMBINAR CELDAS
                $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->bodyTabla);
                $fila++;
                $sheet->setCellValue('A' . $fila, "Total Compra Bs.:");
                $sheet->mergeCells("A" . $fila . ":B" . $fila);  //COMBINAR CELDAS
                $sheet->setCellValue('C' . $fila, $item->total);
                $sheet->setCellValue('D' . $fila, 'Total Cancelado Bs.:');
                $sheet->setCellValue('E' . $fila, $item->total_cancelado);
                $sheet->mergeCells("E" . $fila . ":F" . $fila);  //COMBINAR CELDAS
                $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->bodyTabla);
                $fila++;
                $sheet->setCellValue('A' . $fila, "Saldo Bs.:");
                $sheet->mergeCells("A" . $fila . ":B" . $fila);  //COMBINAR CELDAS
                $sheet->setCellValue('C' . $fila, $item->saldo);
                $sheet->setCellValue('D' . $fila, 'Estado Compra:');
                $sheet->setCellValue('E' . $fila, $item->estado_ingreso);
                $sheet->mergeCells("E" . $fila . ":F" . $fila);  //COMBINAR CELDAS
                $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->bodyTabla);
                $fila++;
                $sheet->setCellValue('A' . $fila, "Faltantes:");
                $sheet->mergeCells("A" . $fila . ":B" . $fila);  //COMBINAR CELDAS
                $sheet->setCellValue('C' . $fila, $item->faltantes);
                $sheet->getStyle('A' . $fila . ':B' . $fila)->applyFromArray($this->bodyTabla);
                $fila++;
                $cant_total = 0;
                $cont = 1;
                foreach ($item->ingreso_detalles as $key => $item_detalle) {
                    $sheet->setCellValue('A' . $fila, $cont++ . ') ' . $item_detalle->producto->codigo . ' - ' . $item_detalle->producto->nombre);
                    $sheet->mergeCells("A" . $fila . ":F" . $fila);  //COMBINAR CELDAS
                    $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->headerTabla);
                    $fila++;
                    $sheet->setCellValue('A' . $fila, 'Solicitado: ' . $item_detalle->cantidad . '  Recibido: ' . $item_detalle->verificado . '  Faltantes: ' . $item_detalle->faltantes);
                    $sheet->mergeCells("A" . $fila . ":F" . $fila);  //COMBINAR CELDAS
                    $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->headerTabla);
                    $fila++;

                    $sheet->setCellValue('A' . $fila, 'NRO');
                    $sheet->setCellValue('B' . $fila, 'ALMACÉN');
                    $sheet->mergeCells("B" . $fila . ":D" . $fila);  //COMBINAR CELDAS
                    $sheet->setCellValue('E' . $fila, 'CANTIDAD');
                    $sheet->setCellValue('F' . $fila, 'RESPONSABLE');
                    $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->headerTabla);
                    $fila++;

                    $ingreso_recepcions = $item_detalle->ingreso_recepcions;
                    if ($fecha_ini && $fecha_fin && !$ingreso_producto_id) {
                        $$ingreso_recepcions = $item_detalle->ingreso_recepcions->where("tipo", "RECEPCION")->whereBetween('fecha_registro', [$fecha_ini, $fecha_fin]);
                    }

                    $cont_recep = 1;
                    foreach ($ingreso_recepcions->where("tipo", "RECEPCION") as $item_recepcion) {
                        $sheet->setCellValue('A' . $fila, $cont_recep++);
                        $sheet->setCellValue('B' . $fila, $item_recepcion->almacen->nombre . ' - ' . $item_recepcion->sucursal->nombre);
                        $sheet->mergeCells("B" . $fila . ":D" . $fila);  //COMBINAR CELDAS
                        $sheet->setCellValue('E' . $fila, $item_recepcion->cantidad);
                        $sheet->setCellValue('F' . $fila, $item_recepcion->user->full_name);
                        $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->bodyTabla);
                        $cant_total += (float)$item_recepcion->cantidad;
                        $fila++;
                    }
                }

                $fila++;
                $fila++;
                $fila++;
            }
            $sheet->getColumnDimension('A')->setWidth(12);
            $sheet->getColumnDimension('B')->setWidth(20);
            $sheet->getColumnDimension('C')->setWidth(20);
            $sheet->getColumnDimension('D')->setWidth(20);
            $sheet->getColumnDimension('E')->setWidth(15);
            $sheet->getColumnDimension('F')->setWidth(30);

            foreach (range('A', 'F') as $columnID) {
                $sheet->getStyle($columnID)->getAlignment()->setWrapText(true);
            }

            $sheet->getPageSetup()->setOrientation(\PhpOffice\PhpSpreadsheet\Worksheet\PageSetup::ORIENTATION_DEFAULT);
            $sheet->getPageMargins()->setTop(0.5);
            $sheet->getPageMargins()->setRight(0.1);
            $sheet->getPageMargins()->setLeft(0.1);
            $sheet->getPageMargins()->setBottom(0.1);
            $sheet->getPageSetup()->setPrintArea('A:F');
            $sheet->getPageSetup()->setFitToWidth(1);
            $sheet->getPageSetup()->setFitToHeight(0);

            return response()->streamDownload(
                function () use ($spreadsheet) {
                    $writer = IOFactory::createWriter($spreadsheet, 'Xlsx');
                    $writer->save('php://output');
                },
                'recepcions_' . time() . '.xlsx',
                [
                    'Content-Type' => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                ]
            );
        }
    }

    public function faltantes()
    {
        $almacens = $this->almacen_service->listado(1);
        $proveedors = $this->proveedor_service->listado();
        $usuarios = $this->user_service->listado(1);
        $tipo_compras = $this->tipo_compra_service->listado();

        return Inertia::render("Admin/Reportes/Faltantes", [
            "almacens" => $almacens,
            "usuarios" => $usuarios,
            "proveedors" => $proveedors,
            "tipo_compras" => $tipo_compras,
        ]);
    }

    public function r_faltantes(Request $request)
    {
        ini_set('memory_limit', '1024M');
        set_time_limit(-1);
        $almacen_id =  $request->almacen_id;
        $ingreso_producto_id =  $request->ingreso_producto_id;
        $proveedor_id =  $request->proveedor_id;
        $user_id =  $request->user_id;
        $tipo_compra =  $request->tipo_compra;
        $fecha_ini =  $request->fecha_ini;
        $fecha_fin =  $request->fecha_fin;
        $formato =  $request->formato;
        $ingreso_productos = IngresoProducto::select("ingreso_productos.*");

        if ($almacen_id && $almacen_id != 'todos') {
            $ingreso_productos->where('almacen_id', $almacen_id);
        }

        if ($ingreso_producto_id) {
            $ingreso_productos->where('id', $ingreso_producto_id);
        }

        if ($proveedor_id && $proveedor_id != 'todos') {
            $ingreso_productos->where('proveedor_id', $proveedor_id);
        }

        if ($user_id && $user_id != 'todos') {
            $ingreso_productos->where('user_id', $user_id);
        }

        if ($tipo_compra && $tipo_compra != 'todos') {
            $ingreso_productos->where('tipo_compra', $tipo_compra);
        }

        $ingreso_productos = $ingreso_productos->get();

        if ($formato == 'pdf') {
            $pdf = new ReporteServiceTcpdf();
            $pdf->SetTitle('Recepción Faltantes');
            $pdf->setMargins(10, 2, 2);
            $pdf->AddPage('P', 'LETTER');
            $pdf->setPrintHeader(false);
            $pdf->setY(13);
            $pdf->SetFont('helvetica', 'B', 12);
            $pdf->Cell(0, 6, "RECEPCIÓN DE FALTANTES", 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 10);
            $pdf->Cell(0, 5, "Expedido: " . date("d/m/Y"), 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 11);
            $titulo = '"TODOS LOS ALMACENES"';
            if ($almacen_id != "todos") {
                $almacen = Almacen::find($almacen_id);
                $titulo = '"' . $almacen->nombre . ' - ' . $almacen->sucursal->nombre . '"';
            }
            $pdf->Cell(0, 6, $titulo, 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 8);
            $pdf->setY(33);
            $alto = 7;
            $font_size = 8;
            $font_size2 = 9;
            $font_size3 = 10;

            foreach ($ingreso_productos as $item) {
                $pdf->setFont("helvetica", "B", $font_size2);
                $pdf->cellAutoFontSize($pdf, 100, $alto, 'Código Compra: ' . $item->codigo, $font_size2, 5, 'B', 'L', 0);
                $pdf->cellAutoFontSize($pdf, 100, $alto, 'Fecha: ' . $item->fecha_registro_t, $font_size2, 5, 'B', 'L', 0);
                $pdf->Ln();
                $pdf->cellAutoFontSize($pdf, 100, $alto, 'Proveedor: ' . $item->proveedor->nombre, $font_size2, 5, 'B', 'L', 0);
                $pdf->cellAutoFontSize($pdf, 100, $alto, 'Tipo de Ingreso: ' . $item->tipo_ingreso->nombre, $font_size2, 5, 'B', 'L', 0);
                $pdf->Ln();
                $pdf->cellAutoFontSize($pdf, 100, $alto, 'Tipo de Compra: ' . $item->tipo_compra, $font_size, 5, 'B', 'L', 0);
                $pdf->cellAutoFontSize($pdf, 100, $alto, 'Responsable: ' .  $item->user->full_name, $font_size2, 5, 'B', 'L', 0);
                $pdf->Ln();
                $pdf->cellAutoFontSize($pdf, 100, $alto, 'Almacén-Sucursal: ' . $item->user->full_name, $font_size, 5, 'B', 'L', 0);
                $pdf->cellAutoFontSize($pdf, 100, $alto, 'Descripción: ' . $item->descripcion, $font_size2, 5, 'B', 'L', 0);
                $pdf->Ln();
                $pdf->cellAutoFontSize($pdf, 100, $alto, 'Total Compra Bs.: ' . $item->total, $font_size, 5, 'B', 'L', 0);
                $pdf->cellAutoFontSize($pdf, 100, $alto, 'Total Cancelado Bs.: '  . $item->total_cancelado, $font_size2, 5, 'B', 'L', 0);
                $pdf->Ln();
                $pdf->cellAutoFontSize($pdf, 100, $alto, 'Saldo Bs.: ' . $item->saldo, $font_size, 5, 'B', 'L', 0);
                $pdf->cellAutoFontSize($pdf, 100, $alto, 'Estado Compra: ' .  $item->estado_ingreso, $font_size2, 5, 'B', 'L', 0);
                $pdf->Ln();
                $pdf->cellAutoFontSize($pdf, 100, $alto, 'Faltantes:  '
                    . $item->faltantes, $font_size2, 5, 'B', 'L', 0);
                $pdf->Ln();
                $cant_total = 0;
                $cont = 1;
                $alto = 8;
                foreach ($item->ingreso_detalles as $item_detalle) {
                    $pdf->SetFillColor(239, 239, 239);
                    $pdf->setFont("helvetica", "B", $font_size2);
                    $pdf->cellAutoFontSize($pdf, 196, $alto, $cont++ . ') ' . $item_detalle->producto->codigo . ' - ' . $item_detalle->producto->nombre, $font_size2, 5, 'B', 'L', 1, 1);
                    $pdf->Ln();

                    $pdf->cellAutoFontSize($pdf, 40, $alto, 'Solicitado: ' . $item_detalle->cantidad, $font_size2, 5, 'B', 'L', 1, 1);
                    $pdf->cellAutoFontSize($pdf, 40, $alto, 'Recibido: ' . $item_detalle->verificado, $font_size2, 5, 'B', 'L', 1, 1);
                    $pdf->cellAutoFontSize($pdf, 116, $alto, 'Faltantes: ' . $item_detalle->faltantes, $font_size2, 5, 'B', 'L', 1, 1);
                    $pdf->Ln();
                    $cant_total += (float)$item_detalle->cantidad;
                    $pdf->cellAutoFontSize($pdf, 20, $alto, 'NRO', $font_size2, 5, 'B', 'C');
                    $pdf->cellAutoFontSize($pdf, 100, $alto, 'ALMACÉN', $font_size2, 5, 'B', 'C');
                    $pdf->cellAutoFontSize($pdf, 25, $alto, 'CANTIDAD', $font_size2, 5, 'B', 'C');
                    $pdf->cellAutoFontSize($pdf, 51, $alto, 'RESPONSABLE', $font_size2, 5, 'B', 'C');
                    $pdf->Ln();
                    $cont_recep = 1;

                    $ingreso_recepcions_faltantes = $item_detalle->ingreso_recepcions_faltantes;
                    if ($fecha_ini && $fecha_fin && !$ingreso_producto_id) {
                        $$ingreso_recepcions_faltantes = $item_detalle->ingreso_recepcions_faltantes->whereBetween('fecha_registro', [$fecha_ini, $fecha_fin]);
                    }

                    foreach ($ingreso_recepcions_faltantes as $item_recepcion) {
                        $pdf->cellAutoFontSize($pdf, 20, $alto, $cont_recep++, $font_size2, 5, 'N', 'L');
                        $pdf->cellAutoFontSize($pdf, 100, $alto, $item_recepcion->almacen->nombre . ' - ' . $item_recepcion->sucursal->nombre, $font_size2, 5, 'N', 'L');
                        $pdf->cellAutoFontSize($pdf, 25, $alto, $item_recepcion->cantidad, $font_size2, 5, 'N', 'C');
                        $pdf->cellAutoFontSize($pdf, 51, $alto, $item_recepcion->user->full_name, $font_size2, 5, 'N', 'L');
                        $pdf->Ln();
                    }
                }
                $pdf->Ln();
            }

            // Guardar PDF o forzar descarga
            return response($pdf->Output('S'), 200)
                ->header('Content-Type', 'application/pdf')
                ->header('Content-Disposition', 'inline; filename="faltantes' . time() . '.pdf"');
        } else {
            $spreadsheet = new Spreadsheet();
            $spreadsheet->getProperties()
                ->setCreator("ADMIN")
                ->setLastModifiedBy('Administración')
                ->setTitle('Registros')
                ->setSubject('Registros')
                ->setDescription('Registros')
                ->setKeywords('PHPSpreadsheet')
                ->setCategory('Listado');

            $sheet = $spreadsheet->getActiveSheet();

            $spreadsheet->getDefaultStyle()->getFont()->setName('Arial');

            $fila = 1;
            if (file_exists(public_path() . '/imgs/' . $this->configuracion->logo)) {
                $drawing = new \PhpOffice\PhpSpreadsheet\Worksheet\Drawing();
                $drawing->setName('logo');
                $drawing->setDescription('logo');
                $drawing->setPath(public_path() . '/imgs/' . $this->configuracion->logo); // put your path and image here
                $drawing->setCoordinates('A' . $fila);
                $drawing->setOffsetX(5);
                $drawing->setOffsetY(0);
                $drawing->setHeight(70);
                $drawing->setWorksheet($sheet);
            }

            $fila = 2;
            $sheet->setCellValue('A' . $fila, $this->configuracion->nombre_sistema);
            $sheet->mergeCells("A" . $fila . ":F" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':F' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $sheet->setCellValue('A' . $fila, "RECEPCIÓN DE FALTANTES");
            $sheet->mergeCells("A" . $fila . ":F" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':F' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $titulo = '"TODOS LOS ALMACENES"';
            if ($almacen_id != "todos") {
                $almacen = Almacen::find($almacen_id);
                $titulo = '"' . $almacen->nombre . ' - ' . $almacen->sucursal->nombre . '"';
            }
            $sheet->setCellValue('A' . $fila, $titulo);
            $sheet->mergeCells("A" . $fila . ":F" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':F' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $fila++;

            foreach ($ingreso_productos as $item) {
                $sheet->setCellValue('A' . $fila, "Código Compra:");
                $sheet->mergeCells("A" . $fila . ":B" . $fila);  //COMBINAR CELDAS
                $sheet->setCellValue('C' . $fila, $item->codigo);
                $sheet->setCellValue('D' . $fila, "Fecha:");
                $sheet->setCellValue('E' . $fila, $item->fecha_registro_t);
                $sheet->mergeCells("E" . $fila . ":F" . $fila);  //COMBINAR CELDAS
                $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->bodyTabla);
                $fila++;
                $sheet->setCellValue('A' . $fila, "Proveedor:");
                $sheet->mergeCells("A" . $fila . ":B" . $fila);  //COMBINAR CELDAS
                $sheet->setCellValue('C' . $fila, $item->proveedor->nombre);
                $sheet->setCellValue('D' . $fila, 'Tipo de Ingreso:');
                $sheet->setCellValue('E' . $fila, $item->tipo_ingreso->nombre);
                $sheet->mergeCells("E" . $fila . ":F" . $fila);  //COMBINAR CELDAS
                $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->bodyTabla);
                $fila++;
                $sheet->setCellValue('A' . $fila, "Tipo de Compra:");
                $sheet->mergeCells("A" . $fila . ":B" . $fila);  //COMBINAR CELDAS
                $sheet->setCellValue('C' . $fila, $item->tipo_compra);
                $sheet->setCellValue('D' . $fila, "Responsable");
                $sheet->setCellValue('F' . $fila, $item->user->full_name);
                $sheet->mergeCells("E" . $fila . ":F" . $fila);  //COMBINAR CELDAS
                $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->bodyTabla);
                $fila++;
                $sheet->setCellValue('A' . $fila, "Almacén-Sucursal:");
                $sheet->mergeCells("A" . $fila . ":B" . $fila);  //COMBINAR CELDAS
                $sheet->setCellValue('C' . $fila, $item->almacen->nombre . ' - ' . $item->sucursal->nombre);
                $sheet->setCellValue('D' . $fila, "Descripción:");
                $sheet->setCellValue('F' . $fila, $item->descripcion);
                $sheet->mergeCells("E" . $fila . ":F" . $fila);  //COMBINAR CELDAS
                $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->bodyTabla);
                $fila++;
                $sheet->setCellValue('A' . $fila, "Total Compra Bs.:");
                $sheet->mergeCells("A" . $fila . ":B" . $fila);  //COMBINAR CELDAS
                $sheet->setCellValue('C' . $fila, $item->total);
                $sheet->setCellValue('D' . $fila, 'Total Cancelado Bs.:');
                $sheet->setCellValue('E' . $fila, $item->total_cancelado);
                $sheet->mergeCells("E" . $fila . ":F" . $fila);  //COMBINAR CELDAS
                $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->bodyTabla);
                $fila++;
                $sheet->setCellValue('A' . $fila, "Saldo Bs.:");
                $sheet->mergeCells("A" . $fila . ":B" . $fila);  //COMBINAR CELDAS
                $sheet->setCellValue('C' . $fila, $item->saldo);
                $sheet->setCellValue('D' . $fila, 'Estado Compra:');
                $sheet->setCellValue('E' . $fila, $item->estado_ingreso);
                $sheet->mergeCells("E" . $fila . ":F" . $fila);  //COMBINAR CELDAS
                $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->bodyTabla);
                $fila++;
                $sheet->setCellValue('A' . $fila, "Faltantes:");
                $sheet->mergeCells("A" . $fila . ":B" . $fila);  //COMBINAR CELDAS
                $sheet->setCellValue('C' . $fila, $item->faltantes);
                $sheet->getStyle('A' . $fila . ':B' . $fila)->applyFromArray($this->bodyTabla);
                $fila++;
                $cant_total = 0;
                $cont = 1;
                foreach ($item->ingreso_detalles as $key => $item_detalle) {
                    $sheet->setCellValue('A' . $fila, $cont++ . ') ' . $item_detalle->producto->codigo . ' - ' . $item_detalle->producto->nombre);
                    $sheet->mergeCells("A" . $fila . ":F" . $fila);  //COMBINAR CELDAS
                    $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->headerTabla);
                    $fila++;
                    $sheet->setCellValue('A' . $fila, 'Solicitado: ' . $item_detalle->cantidad . '  Recibido: ' . $item_detalle->verificado . '  Faltantes: ' . $item_detalle->faltantes);
                    $sheet->mergeCells("A" . $fila . ":F" . $fila);  //COMBINAR CELDAS
                    $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->headerTabla);
                    $fila++;

                    $sheet->setCellValue('A' . $fila, 'NRO');
                    $sheet->setCellValue('B' . $fila, 'ALMACÉN');
                    $sheet->mergeCells("B" . $fila . ":D" . $fila);  //COMBINAR CELDAS
                    $sheet->setCellValue('E' . $fila, 'CANTIDAD');
                    $sheet->setCellValue('F' . $fila, 'RESPONSABLE');
                    $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->headerTabla);
                    $fila++;
                    $cont_recep = 1;

                    $ingreso_recepcions_faltantes = $item_detalle->ingreso_recepcions_faltantes;
                    if ($fecha_ini && $fecha_fin && !$ingreso_producto_id) {
                        $$ingreso_recepcions_faltantes = $item_detalle->ingreso_recepcions_faltantes->whereBetween('fecha_registro', [$fecha_ini, $fecha_fin]);
                    }

                    foreach ($ingreso_recepcions_faltantes as $item_recepcion) {
                        $sheet->setCellValue('A' . $fila, $cont_recep++);
                        $sheet->setCellValue('B' . $fila, $item_recepcion->almacen->nombre . ' - ' . $item_recepcion->sucursal->nombre);
                        $sheet->mergeCells("B" . $fila . ":D" . $fila);  //COMBINAR CELDAS
                        $sheet->setCellValue('E' . $fila, $item_recepcion->cantidad);
                        $sheet->setCellValue('F' . $fila, $item_recepcion->user->full_name);
                        $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->bodyTabla);
                        $cant_total += (float)$item_recepcion->cantidad;
                        $fila++;
                    }
                }

                $fila++;
                $fila++;
                $fila++;
            }
            $sheet->getColumnDimension('A')->setWidth(12);
            $sheet->getColumnDimension('B')->setWidth(20);
            $sheet->getColumnDimension('C')->setWidth(20);
            $sheet->getColumnDimension('D')->setWidth(20);
            $sheet->getColumnDimension('E')->setWidth(15);
            $sheet->getColumnDimension('F')->setWidth(30);

            foreach (range('A', 'F') as $columnID) {
                $sheet->getStyle($columnID)->getAlignment()->setWrapText(true);
            }

            $sheet->getPageSetup()->setOrientation(\PhpOffice\PhpSpreadsheet\Worksheet\PageSetup::ORIENTATION_DEFAULT);
            $sheet->getPageMargins()->setTop(0.5);
            $sheet->getPageMargins()->setRight(0.1);
            $sheet->getPageMargins()->setLeft(0.1);
            $sheet->getPageMargins()->setBottom(0.1);
            $sheet->getPageSetup()->setPrintArea('A:F');
            $sheet->getPageSetup()->setFitToWidth(1);
            $sheet->getPageSetup()->setFitToHeight(0);

            return response()->streamDownload(
                function () use ($spreadsheet) {
                    $writer = IOFactory::createWriter($spreadsheet, 'Xlsx');
                    $writer->save('php://output');
                },
                'faltantes_' . time() . '.xlsx',
                [
                    'Content-Type' => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                ]
            );
        }
    }

    public function pago_compras()
    {
        return Inertia::render("Admin/Reportes/PagoCompras");
    }

    public function r_pago_compras(Request $request)
    {
        ini_set('memory_limit', '1024M');
        set_time_limit(-1);
        $almacen_id =  $request->almacen_id;
        $proveedor_id =  $request->proveedor_id;
        $tipo_compra =  $request->tipo_compra;
        $ingreso_producto_id =  $request->ingreso_producto_id;
        $user_id =  $request->user_id;
        $fecha_ini =  $request->fecha_ini;
        $fecha_fin =  $request->fecha_fin;
        $formato =  $request->formato;
        $ingreso_pagos = IngresoPago::select("ingreso_pagos.*");

        if ($almacen_id && $almacen_id != 'todos') {
            $ingreso_pagos->where('almacen_id', $almacen_id);
        }

        if ($user_id && $user_id != 'todos') {
            $ingreso_pagos->where('user_id', $user_id);
        }

        if ($proveedor_id && $proveedor_id != 'todos') {
            $ingreso_pagos->where('proveedor_id', $proveedor_id);
        }

        if ($user_id && $user_id != 'todos') {
            $ingreso_pagos->where('user_id', $user_id);
        }

        if ($fecha_ini && $fecha_fin && !$ingreso_producto_id) {
            $ingreso_pagos->whereBetween('fecha', [$fecha_ini, $fecha_fin]);
        }

        $ingreso_pagos = $ingreso_pagos->get();

        if ($formato == 'pdf') {
            $pdf = new ReporteServiceTcpdf();
            $pdf->SetTitle('Lista Pago de Compras');
            $pdf->setMargins(1, 2, 2);
            $pdf->AddPage('P', 'LETTER');
            $pdf->setPrintHeader(false);
            $pdf->setY(13);
            $pdf->SetFont('helvetica', 'B', 12);
            $pdf->Cell(0, 6, "LISTA PAGO DE COMPRAS", 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 10);
            $pdf->Cell(0, 5, "Expedido: " . date("d/m/Y"), 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 11);
            $titulo = '"TODOS LOS ALMACENES"';
            if ($almacen_id != "todos") {
                $almacen = Almacen::find($almacen_id);
                $titulo = '"' . $almacen->nombre . ' - ' . $almacen->sucursal->nombre . '"';
            }
            $pdf->Cell(0, 6, $titulo, 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 8);
            $pdf->setY(33);
            $alto = 10;
            $font_size = 8;
            $font_size2 = 9;
            $font_size3 = 10;

            $pdf->setFont("helvetica", "B", $font_size2);
            $pdf->cellAutoFontSize($pdf, 15, $alto, 'NRO', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 32.5, $alto, 'SUCURSAL', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 32.5, $alto, 'ALMACÉN', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 35, $alto, 'PROVEEDOR', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 35, $alto, 'MONTO BS.', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 30, $alto, 'RESPONSABLE', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 30, $alto, 'FECHA Y HORA', $font_size, 5, 'B');
            $pdf->Ln();
            $s_total = 0;
            $cont = 1;
            foreach ($ingreso_pagos as $item) {
                $pdf->cellAutoFontSize($pdf, 15, $alto, $cont++, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 32.5, $alto, $item->sucursal->nombre, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 32.5, $alto, $item->almacen->nombre, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 35, $alto, $item->proveedor->nombre, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 35, $alto, $item->monto_total, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 30, $alto, $item->user->full_name, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 30, $alto, $item->fecha_hora_t, $font_size, 5, 'N', 'L');

                $s_total += (float)$item->monto_total;
                $pdf->Ln();
            }
            $pdf->cellAutoFontSize($pdf, 115, $alto, 'TOTAL BS.', $font_size3, 5, 'B', 'R');
            $pdf->cellAutoFontSize($pdf, 35, $alto, number_format($s_total, 2, ".", ""), $font_size2, 5, 'B', 'L');


            // Guardar PDF o forzar descarga
            return response($pdf->Output('S'), 200)
                ->header('Content-Type', 'application/pdf')
                ->header('Content-Disposition', 'inline; filename="pago_compras' . time() . '.pdf"');
        } else {
            $spreadsheet = new Spreadsheet();
            $spreadsheet->getProperties()
                ->setCreator("ADMIN")
                ->setLastModifiedBy('Administración')
                ->setTitle('Registros')
                ->setSubject('Registros')
                ->setDescription('Registros')
                ->setKeywords('PHPSpreadsheet')
                ->setCategory('Listado');

            $sheet = $spreadsheet->getActiveSheet();

            $spreadsheet->getDefaultStyle()->getFont()->setName('Arial');

            $fila = 1;
            if (file_exists(public_path() . '/imgs/' . $this->configuracion->logo)) {
                $drawing = new \PhpOffice\PhpSpreadsheet\Worksheet\Drawing();
                $drawing->setName('logo');
                $drawing->setDescription('logo');
                $drawing->setPath(public_path() . '/imgs/' . $this->configuracion->logo); // put your path and image here
                $drawing->setCoordinates('A' . $fila);
                $drawing->setOffsetX(5);
                $drawing->setOffsetY(0);
                $drawing->setHeight(70);
                $drawing->setWorksheet($sheet);
            }

            $fila = 2;
            $sheet->setCellValue('A' . $fila, $this->configuracion->nombre_sistema);
            $sheet->mergeCells("A" . $fila . ":G" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':G' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':G' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $sheet->setCellValue('A' . $fila, "LISTA PAGO DE COMPRAS");
            $sheet->mergeCells("A" . $fila . ":G" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':G' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':G' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $titulo = '"TODOS LOS ALMACENES"';
            if ($almacen_id != "todos") {
                $almacen = Almacen::find($almacen_id);
                $titulo = '"' . $almacen->nombre . ' - ' . $almacen->sucursal->nombre . '"';
            }
            $sheet->setCellValue('A' . $fila, $titulo);
            $sheet->mergeCells("A" . $fila . ":G" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':G' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':G' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $fila++;
            $sheet->setCellValue('A' . $fila, 'NRO');
            $sheet->setCellValue('B' . $fila, 'SUCURSAL');
            $sheet->setCellValue('C' . $fila, 'ALMACÉN');
            $sheet->setCellValue('D' . $fila, 'PROVEEDOR');
            $sheet->setCellValue('E' . $fila, 'MONTO BS.');
            $sheet->setCellValue('F' . $fila, 'RESPONSABLE');
            $sheet->setCellValue('G' . $fila, 'FECHA Y HORA');
            $sheet->getStyle('A' . $fila . ':G' . $fila)->applyFromArray($this->headerTabla);
            $fila++;
            $cont = 1;
            $s_total = 0;
            foreach ($ingreso_pagos as $key => $item) {
                $sheet->setCellValue('A' . $fila, $cont++);
                $sheet->setCellValue('B' . $fila, $item->sucursal->nombre);
                $sheet->setCellValue('C' . $fila, $item->almacen->nombre);
                $sheet->setCellValue('D' . $fila, $item->proveedor->nombre);
                $sheet->setCellValue('E' . $fila, $item->monto_total);
                $sheet->setCellValue('F' . $fila, $item->user->full_name);
                $sheet->setCellValue('G' . $fila, $item->fecha_hora_t);
                $sheet->getStyle('A' . $fila . ':G' . $fila)->applyFromArray($this->bodyTabla);

                $s_total += (float)$item->monto_total;
                $fila++;
            }
            $sheet->setCellValue('A' . $fila, "TOTALES");
            $sheet->mergeCells("A" . $fila . ":D" . $fila);  //COMBINAR CELDAS
            $sheet->setCellValue('E' . $fila, number_format($s_total, 2, ".", ""));
            $sheet->getStyle('A' . $fila . ':G' . $fila)->applyFromArray($this->headerTabla);

            $sheet->getColumnDimension('A')->setWidth(12);
            $sheet->getColumnDimension('B')->setWidth(20);
            $sheet->getColumnDimension('C')->setWidth(20);
            $sheet->getColumnDimension('D')->setWidth(20);
            $sheet->getColumnDimension('E')->setWidth(15);
            $sheet->getColumnDimension('F')->setWidth(30);
            $sheet->getColumnDimension('G')->setWidth(15);

            foreach (range('A', 'G') as $columnID) {
                $sheet->getStyle($columnID)->getAlignment()->setWrapText(true);
            }

            $sheet->getPageSetup()->setOrientation(\PhpOffice\PhpSpreadsheet\Worksheet\PageSetup::ORIENTATION_DEFAULT);
            $sheet->getPageMargins()->setTop(0.5);
            $sheet->getPageMargins()->setRight(0.1);
            $sheet->getPageMargins()->setLeft(0.1);
            $sheet->getPageMargins()->setBottom(0.1);
            $sheet->getPageSetup()->setPrintArea('A:G');
            $sheet->getPageSetup()->setFitToWidth(1);
            $sheet->getPageSetup()->setFitToHeight(0);

            return response()->streamDownload(
                function () use ($spreadsheet) {
                    $writer = IOFactory::createWriter($spreadsheet, 'Xlsx');
                    $writer->save('php://output');
                },
                'pago_compras_' . time() . '.xlsx',
                [
                    'Content-Type' => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                ]
            );
        }
    }

    public function cobro_creditos()
    {
        return Inertia::render("Admin/Reportes/CobroCreditos");
    }

    public function r_cobro_creditos(Request $request)
    {
        ini_set('memory_limit', '1024M');
        set_time_limit(-1);
        $almacen_id =  $request->almacen_id;
        $venta_id =  $request->venta_id;
        $cliente_id =  $request->cliente_id;
        $user_id =  $request->user_id;
        $fecha_ini =  $request->fecha_ini;
        $fecha_fin =  $request->fecha_fin;
        $formato =  $request->formato;
        $venta_cobros = VentaCobro::select("venta_cobros.*");

        if ($almacen_id && $almacen_id != 'todos') {
            $venta_cobros->where('almacen_id', $almacen_id);
        }

        if ($venta_id) {
            $venta_cobros->where('venta_id', $venta_id);
        }

        if ($cliente_id) {
            $venta_cobros->where('cliente_id', $cliente_id);
        }

        if ($user_id && $user_id != 'todos') {
            $venta_cobros->where('user_id', $user_id);
        }

        if ($fecha_ini && $fecha_fin && !$venta_id && !$cliente_id) {
            $venta_cobros->whereBetween('fecha', [$fecha_ini, $fecha_fin]);
        }

        $venta_cobros = $venta_cobros->get();

        if ($formato == 'pdf') {
            $pdf = new ReporteServiceTcpdf();
            $pdf->SetTitle('Lista Cobro de Créditos');
            $pdf->setMargins(1, 2, 2);
            $pdf->AddPage('P', 'LETTER');
            $pdf->setPrintHeader(false);
            $pdf->setY(13);
            $pdf->SetFont('helvetica', 'B', 12);
            $pdf->Cell(0, 6, "LISTA COBRO DE CRÉDITOS", 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 10);
            $pdf->Cell(0, 5, "Expedido: " . date("d/m/Y"), 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 11);
            $titulo = '"TODOS LOS ALMACENES"';
            if ($almacen_id != "todos") {
                $almacen = Almacen::find($almacen_id);
                $titulo = '"' . $almacen->nombre . ' - ' . $almacen->sucursal->nombre . '"';
            }
            $pdf->Cell(0, 6, $titulo, 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 8);
            $pdf->setY(33);
            $alto = 10;
            $font_size = 8;
            $font_size2 = 9;
            $font_size3 = 10;

            $pdf->setFont("helvetica", "B", $font_size2);
            $pdf->cellAutoFontSize($pdf, 15, $alto, 'NRO', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 32, $alto, 'SUCURSAL', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 32, $alto, 'ALMACÉN', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 35, $alto, 'CLIENTE', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 20, $alto, 'TIPO PAGO', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 25, $alto, 'MONTO BS.', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 25, $alto, 'RESPONSABLE', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 25, $alto, 'FECHA Y HORA', $font_size, 5, 'B');
            $pdf->Ln();
            $s_total = 0;
            $cont = 1;
            foreach ($venta_cobros as $item) {
                $pdf->cellAutoFontSize($pdf, 15, $alto, $cont++, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 32, $alto, $item->sucursal->nombre, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 32, $alto, $item->almacen->nombre, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 35, $alto, $item->cliente->nombre, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 20, $alto, $item->tipo_pago, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 25, $alto, $item->monto_total, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 25, $alto, $item->user->full_name, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 25, $alto, $item->fecha_hora_t, $font_size, 5, 'N', 'L');

                $s_total += (float)$item->monto_total;
                $pdf->Ln();
            }
            $pdf->cellAutoFontSize($pdf, 134, $alto, 'TOTAL BS.', $font_size3, 5, 'B', 'R');
            $pdf->cellAutoFontSize($pdf, 25, $alto, number_format($s_total, 2, ".", ""), $font_size2, 5, 'B', 'L');


            // Guardar PDF o forzar descarga
            return response($pdf->Output('S'), 200)
                ->header('Content-Type', 'application/pdf')
                ->header('Content-Disposition', 'inline; filename="cobro_creditos' . time() . '.pdf"');
        } else {
            $spreadsheet = new Spreadsheet();
            $spreadsheet->getProperties()
                ->setCreator("ADMIN")
                ->setLastModifiedBy('Administración')
                ->setTitle('Registros')
                ->setSubject('Registros')
                ->setDescription('Registros')
                ->setKeywords('PHPSpreadsheet')
                ->setCategory('Listado');

            $sheet = $spreadsheet->getActiveSheet();

            $spreadsheet->getDefaultStyle()->getFont()->setName('Arial');

            $fila = 1;
            if (file_exists(public_path() . '/imgs/' . $this->configuracion->logo)) {
                $drawing = new \PhpOffice\PhpSpreadsheet\Worksheet\Drawing();
                $drawing->setName('logo');
                $drawing->setDescription('logo');
                $drawing->setPath(public_path() . '/imgs/' . $this->configuracion->logo); // put your path and image here
                $drawing->setCoordinates('A' . $fila);
                $drawing->setOffsetX(5);
                $drawing->setOffsetY(0);
                $drawing->setHeight(70);
                $drawing->setWorksheet($sheet);
            }

            $fila = 2;
            $sheet->setCellValue('A' . $fila, $this->configuracion->nombre_sistema);
            $sheet->mergeCells("A" . $fila . ":H" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':H' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':H' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $sheet->setCellValue('A' . $fila, "LISTA COBRO DE CRÉDITOS");
            $sheet->mergeCells("A" . $fila . ":H" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':H' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':H' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $titulo = '"TODOS LOS ALMACENES"';
            if ($almacen_id != "todos") {
                $almacen = Almacen::find($almacen_id);
                $titulo = '"' . $almacen->nombre . ' - ' . $almacen->sucursal->nombre . '"';
            }
            $sheet->setCellValue('A' . $fila, $titulo);
            $sheet->mergeCells("A" . $fila . ":H" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':H' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':H' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $fila++;
            $sheet->setCellValue('A' . $fila, 'NRO');
            $sheet->setCellValue('B' . $fila, 'SUCURSAL');
            $sheet->setCellValue('C' . $fila, 'ALMACÉN');
            $sheet->setCellValue('D' . $fila, 'CLIENTE');
            $sheet->setCellValue('E' . $fila, 'TIPO PAGO');
            $sheet->setCellValue('F' . $fila, 'MONTO BS.');
            $sheet->setCellValue('G' . $fila, 'RESPONSABLE');
            $sheet->setCellValue('H' . $fila, 'FECHA Y HORA');
            $sheet->getStyle('A' . $fila . ':H' . $fila)->applyFromArray($this->headerTabla);
            $fila++;
            $cont = 1;
            $s_total = 0;
            foreach ($venta_cobros as $key => $item) {
                $sheet->setCellValue('A' . $fila, $cont++);
                $sheet->setCellValue('B' . $fila, $item->sucursal->nombre);
                $sheet->setCellValue('C' . $fila, $item->almacen->nombre);
                $sheet->setCellValue('D' . $fila, $item->cliente->nombre);
                $sheet->setCellValue('E' . $fila, $item->tipo_pago);
                $sheet->setCellValue('F' . $fila, $item->monto_total);
                $sheet->setCellValue('G' . $fila, $item->user->full_name);
                $sheet->setCellValue('H' . $fila, $item->fecha_hora_t);
                $sheet->getStyle('A' . $fila . ':H' . $fila)->applyFromArray($this->bodyTabla);

                $s_total += (float)$item->monto_total;
                $fila++;
            }
            $sheet->setCellValue('A' . $fila, "TOTALES");
            $sheet->mergeCells("A" . $fila . ":E" . $fila);  //COMBINAR CELDAS
            $sheet->setCellValue('F' . $fila, number_format($s_total, 2, ".", ""));
            $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->headerTabla);

            $sheet->getColumnDimension('A')->setWidth(12);
            $sheet->getColumnDimension('B')->setWidth(20);
            $sheet->getColumnDimension('C')->setWidth(20);
            $sheet->getColumnDimension('D')->setWidth(20);
            $sheet->getColumnDimension('E')->setWidth(15);
            $sheet->getColumnDimension('F')->setWidth(30);
            $sheet->getColumnDimension('G')->setWidth(15);
            $sheet->getColumnDimension('H')->setWidth(15);

            foreach (range('A', 'H') as $columnID) {
                $sheet->getStyle($columnID)->getAlignment()->setWrapText(true);
            }

            $sheet->getPageSetup()->setOrientation(\PhpOffice\PhpSpreadsheet\Worksheet\PageSetup::ORIENTATION_DEFAULT);
            $sheet->getPageMargins()->setTop(0.5);
            $sheet->getPageMargins()->setRight(0.1);
            $sheet->getPageMargins()->setLeft(0.1);
            $sheet->getPageMargins()->setBottom(0.1);
            $sheet->getPageSetup()->setPrintArea('A:H');
            $sheet->getPageSetup()->setFitToWidth(1);
            $sheet->getPageSetup()->setFitToHeight(0);

            return response()->streamDownload(
                function () use ($spreadsheet) {
                    $writer = IOFactory::createWriter($spreadsheet, 'Xlsx');
                    $writer->save('php://output');
                },
                'cobro_creditos_' . time() . '.xlsx',
                [
                    'Content-Type' => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                ]
            );
        }
    }

    public function ventas_creditos()
    {
        $almacens = $this->almacen_service->listado(1);
        $usuarios = $this->user_service->listado(1);
        return Inertia::render("Admin/Reportes/VentasCredito", [
            "almacens" => $almacens,
            "usuarios" => $usuarios,
        ]);
    }

    public function r_ventas_creditos(Request $request)
    {
        ini_set('memory_limit', '1024M');
        set_time_limit(-1);
        $almacen_id =  $request->almacen_id;
        $venta_id =  $request->venta_id;
        $cliente_id =  $request->cliente_id;
        $user_id =  $request->user_id;
        $fecha_ini =  $request->fecha_ini;
        $fecha_fin =  $request->fecha_fin;
        $formato =  $request->formato;
        $ventas = Venta::select("ventas.*")->where("tipo_venta", "CRÉDITO");

        if ($almacen_id && $almacen_id != 'todos') {
            $ventas->where('almacen_id', $almacen_id);
        }

        if ($venta_id) {
            $ventas->where('venta_id', $venta_id);
        }

        if ($cliente_id) {
            $ventas->where('cliente_id', $cliente_id);
        }

        if ($user_id && $user_id != 'todos') {
            $ventas->where('user_id', $user_id);
        }

        if ($fecha_ini && $fecha_fin && !$venta_id && !$cliente_id) {
            $ventas->whereBetween('fecha', [$fecha_ini, $fecha_fin]);
        }

        $ventas = $ventas->get();

        if ($formato == 'pdf') {
            $pdf = new ReporteServiceTcpdf();
            $pdf->SetTitle('Ventas a Crédito');
            $pdf->setMargins(1, 2, 2);
            $pdf->AddPage('P', 'LETTER');
            $pdf->setPrintHeader(false);
            $pdf->setY(13);
            $pdf->SetFont('helvetica', 'B', 12);
            $pdf->Cell(0, 6, "VENTAS A CRÉDITO", 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 10);
            $pdf->Cell(0, 5, "Expedido: " . date("d/m/Y"), 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 11);
            $titulo = '"TODOS LOS ALMACENES"';
            if ($almacen_id != "todos") {
                $almacen = Almacen::find($almacen_id);
                $titulo = '"' . $almacen->nombre . ' - ' . $almacen->sucursal->nombre . '"';
            }
            $pdf->Cell(0, 6, $titulo, 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 8);
            $pdf->setY(33);
            $alto = 10;
            $font_size = 8;
            $font_size2 = 9;
            $font_size3 = 10;

            $pdf->setFont("helvetica", "B", $font_size2);
            $pdf->cellAutoFontSize($pdf, 10, $alto, 'NRO', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 29, $alto, 'SUCURSAL', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 29, $alto, 'ALMACÉN', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 35, $alto, 'CLIENTE', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 20, $alto, 'TOTAL BS.', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 20, $alto, 'CANCELADO BS.', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 20, $alto, 'SALDO BS.', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 25, $alto, 'RESPONSABLE', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 25, $alto, 'FECHA Y HORA', $font_size, 5, 'B');
            $pdf->Ln();
            $s_total = 0;
            $s_total_cancelado = 0;
            $s_saldo = 0;
            $cont = 1;
            foreach ($ventas as $item) {
                $pdf->cellAutoFontSize($pdf, 10, $alto, $cont++, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 29, $alto, $item->sucursal->nombre, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 29, $alto, $item->almacen->nombre, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 35, $alto, $item->cliente->nombre, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 20, $alto, $item->total, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 20, $alto, $item->total_cancelado, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 20, $alto, $item->saldo, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 25, $alto, $item->user->full_name, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 25, $alto, $item->fecha_hora_t, $font_size, 5, 'N', 'L');

                $s_total += (float)$item->total;
                $s_total_cancelado += (float)$item->total_cancelado;
                $s_saldo += (float)$item->saldo;
                $pdf->Ln();
            }
            $pdf->cellAutoFontSize($pdf, 103, $alto, 'TOTAL BS.', $font_size3, 5, 'B', 'R');
            $pdf->cellAutoFontSize($pdf, 20, $alto, number_format($s_total, 2, ".", ""), $font_size2, 5, 'B', 'L');
            $pdf->cellAutoFontSize($pdf, 20, $alto, number_format($s_total_cancelado, 2, ".", ""), $font_size2, 5, 'B', 'L');
            $pdf->cellAutoFontSize($pdf, 20, $alto, number_format($s_saldo, 2, ".", ""), $font_size2, 5, 'B', 'L');


            // Guardar PDF o forzar descarga
            return response($pdf->Output('S'), 200)
                ->header('Content-Type', 'application/pdf')
                ->header('Content-Disposition', 'inline; filename="ventas_creditos' . time() . '.pdf"');
        } else {
            $spreadsheet = new Spreadsheet();
            $spreadsheet->getProperties()
                ->setCreator("ADMIN")
                ->setLastModifiedBy('Administración')
                ->setTitle('Registros')
                ->setSubject('Registros')
                ->setDescription('Registros')
                ->setKeywords('PHPSpreadsheet')
                ->setCategory('Listado');

            $sheet = $spreadsheet->getActiveSheet();

            $spreadsheet->getDefaultStyle()->getFont()->setName('Arial');

            $fila = 1;
            if (file_exists(public_path() . '/imgs/' . $this->configuracion->logo)) {
                $drawing = new \PhpOffice\PhpSpreadsheet\Worksheet\Drawing();
                $drawing->setName('logo');
                $drawing->setDescription('logo');
                $drawing->setPath(public_path() . '/imgs/' . $this->configuracion->logo); // put your path and image here
                $drawing->setCoordinates('A' . $fila);
                $drawing->setOffsetX(5);
                $drawing->setOffsetY(0);
                $drawing->setHeight(70);
                $drawing->setWorksheet($sheet);
            }

            $fila = 2;
            $sheet->setCellValue('A' . $fila, $this->configuracion->nombre_sistema);
            $sheet->mergeCells("A" . $fila . ":I" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':I' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':I' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $sheet->setCellValue('A' . $fila, "VENTAS A CRÉDITO");
            $sheet->mergeCells("A" . $fila . ":I" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':I' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':I' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $titulo = '"TODOS LOS ALMACENES"';
            if ($almacen_id != "todos") {
                $almacen = Almacen::find($almacen_id);
                $titulo = '"' . $almacen->nombre . ' - ' . $almacen->sucursal->nombre . '"';
            }
            $sheet->setCellValue('A' . $fila, $titulo);
            $sheet->mergeCells("A" . $fila . ":I" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':I' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':I' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $fila++;
            $sheet->setCellValue('A' . $fila, 'NRO');
            $sheet->setCellValue('B' . $fila, 'SUCURSAL');
            $sheet->setCellValue('C' . $fila, 'ALMACÉN');
            $sheet->setCellValue('D' . $fila, 'CLIENTE');
            $sheet->setCellValue('E' . $fila, 'TOTAL BS.');
            $sheet->setCellValue('F' . $fila, 'CANCELADO BS.');
            $sheet->setCellValue('G' . $fila, 'SALDO BS.');
            $sheet->setCellValue('H' . $fila, 'RESPONSABLE');
            $sheet->setCellValue('I' . $fila, 'FECHA Y HORA');
            $sheet->getStyle('A' . $fila . ':I' . $fila)->applyFromArray($this->headerTabla);
            $fila++;
            $cont = 1;
            $s_total = 0;
            $s_total_cancelado = 0;
            $s_saldo = 0;
            foreach ($ventas as $key => $item) {
                $sheet->setCellValue('A' . $fila, $cont++);
                $sheet->setCellValue('B' . $fila, $item->sucursal->nombre);
                $sheet->setCellValue('C' . $fila, $item->almacen->nombre);
                $sheet->setCellValue('D' . $fila, $item->cliente->nombre);
                $sheet->setCellValue('E' . $fila, $item->total);
                $sheet->setCellValue('F' . $fila, $item->total_cancelado);
                $sheet->setCellValue('G' . $fila, $item->saldo);
                $sheet->setCellValue('H' . $fila, $item->user->full_name);
                $sheet->setCellValue('I' . $fila, $item->fecha_hora_t);
                $sheet->getStyle('A' . $fila . ':I' . $fila)->applyFromArray($this->bodyTabla);

                $s_total += (float)$item->total;
                $s_total_cancelado += (float)$item->total_cancelado;
                $s_saldo += (float)$item->saldo;
                $fila++;
            }
            $sheet->setCellValue('A' . $fila, "TOTALES");
            $sheet->mergeCells("A" . $fila . ":D" . $fila);  //COMBINAR CELDAS
            $sheet->setCellValue('E' . $fila, number_format($s_total, 2, ".", ""));
            $sheet->setCellValue('F' . $fila, number_format($s_total_cancelado, 2, ".", ""));
            $sheet->setCellValue('G' . $fila, number_format($s_saldo, 2, ".", ""));
            $sheet->getStyle('A' . $fila . ':G' . $fila)->applyFromArray($this->headerTabla);

            $sheet->getColumnDimension('A')->setWidth(12);
            $sheet->getColumnDimension('B')->setWidth(20);
            $sheet->getColumnDimension('C')->setWidth(20);
            $sheet->getColumnDimension('D')->setWidth(20);
            $sheet->getColumnDimension('E')->setWidth(15);
            $sheet->getColumnDimension('F')->setWidth(30);
            $sheet->getColumnDimension('G')->setWidth(15);
            $sheet->getColumnDimension('H')->setWidth(15);
            $sheet->getColumnDimension('I')->setWidth(15);

            foreach (range('A', 'I') as $columnID) {
                $sheet->getStyle($columnID)->getAlignment()->setWrapText(true);
            }

            $sheet->getPageSetup()->setOrientation(\PhpOffice\PhpSpreadsheet\Worksheet\PageSetup::ORIENTATION_DEFAULT);
            $sheet->getPageMargins()->setTop(0.5);
            $sheet->getPageMargins()->setRight(0.1);
            $sheet->getPageMargins()->setLeft(0.1);
            $sheet->getPageMargins()->setBottom(0.1);
            $sheet->getPageSetup()->setPrintArea('A:I');
            $sheet->getPageSetup()->setFitToWidth(1);
            $sheet->getPageSetup()->setFitToHeight(0);

            return response()->streamDownload(
                function () use ($spreadsheet) {
                    $writer = IOFactory::createWriter($spreadsheet, 'Xlsx');
                    $writer->save('php://output');
                },
                'ventas_creditos_' . time() . '.xlsx',
                [
                    'Content-Type' => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                ]
            );
        }
    }
    public function compras_credito()
    {
        return Inertia::render("Admin/Reportes/ComprasCredito");
    }

    public function r_compras_credito(Request $request)
    {
        ini_set('memory_limit', '1024M');
        set_time_limit(-1);
        $almacen_id =  $request->almacen_id;
        $proveedor_id =  $request->proveedor_id;
        $ingreso_producto_id =  $request->ingreso_producto_id;
        $user_id =  $request->user_id;
        $fecha_ini =  $request->fecha_ini;
        $fecha_fin =  $request->fecha_fin;
        $formato =  $request->formato;
        $ingreso_productos = IngresoProducto::select("ingreso_productos.*")
            ->where("tipo_compra", "CRÉDITO");

        if ($almacen_id && $almacen_id != 'todos') {
            $ingreso_productos->where('almacen_id', $almacen_id);
        }

        if ($user_id && $user_id != 'todos') {
            $ingreso_productos->where('user_id', $user_id);
        }

        if ($proveedor_id && $proveedor_id != 'todos') {
            $ingreso_productos->where('proveedor_id', $proveedor_id);
        }

        if ($user_id && $user_id != 'todos') {
            $ingreso_productos->where('user_id', $user_id);
        }

        if ($fecha_ini && $fecha_fin && !$ingreso_producto_id) {
            $ingreso_productos->whereBetween('fecha_registro', [$fecha_ini, $fecha_fin]);
        }

        $ingreso_productos = $ingreso_productos->get();

        if ($formato == 'pdf') {
            $pdf = new ReporteServiceTcpdf();
            $pdf->SetTitle('Compras a Crédito');
            $pdf->setMargins(1, 2, 2);
            $pdf->AddPage('L', 'LETTER');
            $pdf->setPrintHeader(false);
            $pdf->setY(13);
            $pdf->SetFont('helvetica', 'B', 12);
            $pdf->Cell(0, 6, "COMPRAS A CRÉDITO", 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 10);
            $pdf->Cell(0, 5, "Expedido: " . date("d/m/Y"), 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 11);
            $titulo = '"TODOS LOS ALMACENES"';
            if ($almacen_id != "todos") {
                $almacen = Almacen::find($almacen_id);
                $titulo = '"' . $almacen->nombre . ' - ' . $almacen->sucursal->nombre . '"';
            }
            $pdf->Cell(0, 6, $titulo, 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 8);
            $pdf->setY(33);
            $alto = 10;
            $font_size = 8;
            $font_size2 = 9;
            $font_size3 = 10;

            $pdf->setFont("helvetica", "B", $font_size2);
            $pdf->cellAutoFontSize($pdf, 15, $alto, 'CÓDIGO', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 32.5, $alto, 'SUCURSAL', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 32.5, $alto, 'ALMACÉN', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 35, $alto, 'PROVEEDOR', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 25, $alto, 'TIPO DE INGRESO', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 25, $alto, 'TOTAL BS.', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 25, $alto, 'CANCELADO BS.', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 25, $alto, 'SALDO BS.', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 30, $alto, 'RESPONSABLE', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 30, $alto, 'FECHA', $font_size, 5, 'B');
            $pdf->Ln();
            $s_total = 0;
            $s_total_cancelado = 0;
            $s_saldo = 0;
            $cont = 1;
            foreach ($ingreso_productos as $item) {
                $pdf->cellAutoFontSize($pdf, 15, $alto, $cont++, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 32.5, $alto, $item->sucursal->nombre, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 32.5, $alto, $item->almacen->nombre, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 35, $alto, $item->proveedor->nombre, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 25, $alto, $item->tipo_ingreso->nombre, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 25, $alto, $item->total, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 25, $alto, $item->total_cancelado, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 25, $alto, $item->saldo, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 30, $alto, $item->user->full_name, $font_size, 5, 'N', 'L');
                $pdf->cellAutoFontSize($pdf, 30, $alto, $item->fecha_registro_t, $font_size, 5, 'N', 'L');

                $s_total += (float)$item->total;
                $s_total_cancelado += (float)$item->total_cancelado;
                $s_saldo += (float)$item->saldo;
                $pdf->Ln();
            }
            $pdf->cellAutoFontSize($pdf, 140, $alto, 'TOTAL BS.', $font_size3, 5, 'B', 'R');
            $pdf->cellAutoFontSize($pdf, 25, $alto, number_format($s_total, 2, ".", ""), $font_size2, 5, 'B', 'L');
            $pdf->cellAutoFontSize($pdf, 25, $alto, number_format($s_total_cancelado, 2, ".", ""), $font_size2, 5, 'B', 'L');
            $pdf->cellAutoFontSize($pdf, 25, $alto, number_format($s_saldo, 2, ".", ""), $font_size2, 5, 'B', 'L');


            // Guardar PDF o forzar descarga
            return response($pdf->Output('S'), 200)
                ->header('Content-Type', 'application/pdf')
                ->header('Content-Disposition', 'inline; filename="compras_credito' . time() . '.pdf"');
        } else {
            $spreadsheet = new Spreadsheet();
            $spreadsheet->getProperties()
                ->setCreator("ADMIN")
                ->setLastModifiedBy('Administración')
                ->setTitle('Registros')
                ->setSubject('Registros')
                ->setDescription('Registros')
                ->setKeywords('PHPSpreadsheet')
                ->setCategory('Listado');

            $sheet = $spreadsheet->getActiveSheet();

            $spreadsheet->getDefaultStyle()->getFont()->setName('Arial');

            $fila = 1;
            if (file_exists(public_path() . '/imgs/' . $this->configuracion->logo)) {
                $drawing = new \PhpOffice\PhpSpreadsheet\Worksheet\Drawing();
                $drawing->setName('logo');
                $drawing->setDescription('logo');
                $drawing->setPath(public_path() . '/imgs/' . $this->configuracion->logo); // put your path and image here
                $drawing->setCoordinates('A' . $fila);
                $drawing->setOffsetX(5);
                $drawing->setOffsetY(0);
                $drawing->setHeight(70);
                $drawing->setWorksheet($sheet);
            }

            $fila = 2;
            $sheet->setCellValue('A' . $fila, $this->configuracion->nombre_sistema);
            $sheet->mergeCells("A" . $fila . ":J" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':J' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':J' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $sheet->setCellValue('A' . $fila, "COMPRAS A CRÉDITO");
            $sheet->mergeCells("A" . $fila . ":J" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':J' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':J' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $titulo = '"TODOS LOS ALMACENES"';
            if ($almacen_id != "todos") {
                $almacen = Almacen::find($almacen_id);
                $titulo = '"' . $almacen->nombre . ' - ' . $almacen->sucursal->nombre . '"';
            }
            $sheet->setCellValue('A' . $fila, $titulo);
            $sheet->mergeCells("A" . $fila . ":J" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':J' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':J' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $fila++;
            $sheet->setCellValue('A' . $fila, 'CÓDIGO');
            $sheet->setCellValue('B' . $fila, 'SUCURSAL');
            $sheet->setCellValue('C' . $fila, 'ALMACÉN');
            $sheet->setCellValue('D' . $fila, 'PROVEEDOR');
            $sheet->setCellValue('E' . $fila, 'TIPO DE INGRESO');
            $sheet->setCellValue('F' . $fila, 'TOTAL BS.');
            $sheet->setCellValue('G' . $fila, 'CANCELADO BS.');
            $sheet->setCellValue('H' . $fila, 'SALDO BS.');
            $sheet->setCellValue('I' . $fila, 'RESPONSABLE');
            $sheet->setCellValue('J' . $fila, 'FECHA');
            $sheet->getStyle('A' . $fila . ':J' . $fila)->applyFromArray($this->headerTabla);
            $fila++;
            $cont = 1;
            $s_total = 0;
            $s_total_cancelado = 0;
            $s_saldo = 0;
            foreach ($ingreso_productos as $key => $item) {
                $sheet->setCellValue('A' . $fila, $cont++);
                $sheet->setCellValue('B' . $fila, $item->sucursal->nombre);
                $sheet->setCellValue('C' . $fila, $item->almacen->nombre);
                $sheet->setCellValue('D' . $fila, $item->proveedor->nombre);
                $sheet->setCellValue('E' . $fila, $item->tipo_ingreso->nombre);
                $sheet->setCellValue('F' . $fila, $item->total);
                $sheet->setCellValue('G' . $fila, $item->total_cancelado);
                $sheet->setCellValue('H' . $fila, $item->saldo);
                $sheet->setCellValue('I' . $fila, $item->user->full_name);
                $sheet->setCellValue('J' . $fila, $item->user->fecha_registro_t);
                $sheet->getStyle('A' . $fila . ':J' . $fila)->applyFromArray($this->bodyTabla);

                $s_total += (float)$item->total;
                $s_total_cancelado += (float)$item->total_cancelado;
                $s_saldo += (float)$item->saldo;
                $fila++;
            }
            $sheet->setCellValue('A' . $fila, "TOTALES");
            $sheet->mergeCells("A" . $fila . ":E" . $fila);  //COMBINAR CELDAS
            $sheet->setCellValue('F' . $fila, number_format($s_total, 2, ".", ""));
            $sheet->setCellValue('G' . $fila, number_format($s_total_cancelado, 2, ".", ""));
            $sheet->setCellValue('H' . $fila, number_format($s_saldo, 2, ".", ""));
            $sheet->getStyle('A' . $fila . ':H' . $fila)->applyFromArray($this->headerTabla);

            $sheet->getColumnDimension('A')->setWidth(12);
            $sheet->getColumnDimension('B')->setWidth(20);
            $sheet->getColumnDimension('C')->setWidth(20);
            $sheet->getColumnDimension('D')->setWidth(20);
            $sheet->getColumnDimension('E')->setWidth(15);
            $sheet->getColumnDimension('F')->setWidth(30);
            $sheet->getColumnDimension('G')->setWidth(15);
            $sheet->getColumnDimension('H')->setWidth(15);
            $sheet->getColumnDimension('I')->setWidth(15);
            $sheet->getColumnDimension('J')->setWidth(15);

            foreach (range('A', 'J') as $columnID) {
                $sheet->getStyle($columnID)->getAlignment()->setWrapText(true);
            }

            $sheet->getPageSetup()->setOrientation(\PhpOffice\PhpSpreadsheet\Worksheet\PageSetup::ORIENTATION_DEFAULT);
            $sheet->getPageMargins()->setTop(0.5);
            $sheet->getPageMargins()->setRight(0.1);
            $sheet->getPageMargins()->setLeft(0.1);
            $sheet->getPageMargins()->setBottom(0.1);
            $sheet->getPageSetup()->setPrintArea('A:J');
            $sheet->getPageSetup()->setFitToWidth(1);
            $sheet->getPageSetup()->setFitToHeight(0);

            return response()->streamDownload(
                function () use ($spreadsheet) {
                    $writer = IOFactory::createWriter($spreadsheet, 'Xlsx');
                    $writer->save('php://output');
                },
                'compras_credito_' . time() . '.xlsx',
                [
                    'Content-Type' => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                ]
            );
        }
    }

    public function movimiento_cajas()
    {
        $almacens = $this->almacen_service->listado(1);
        $usuarios = $this->user_service->listado(1);

        return Inertia::render("Admin/Reportes/MovimientoCajas", [
            "almacens" => $almacens,
            "usuarios" => $usuarios,
        ]);
    }

    public function r_movimiento_cajas(Request $request)
    {
        ini_set('memory_limit', '1024M');
        set_time_limit(-1);
        $fecha_ini = $request->fecha_ini;
        $fecha_fin = $request->fecha_fin;
        $almacen_id = $request->almacen_id;
        $user_id = $request->user_id;
        $formato = $request->formato;

        $movimiento_cajas = $this->movimiento_caja_service->reporteMovimientos(
            $fecha_ini,
            $fecha_fin,
            $almacen_id,
            $user_id
        );

        if ($formato == 'pdf') {
            $pdf = new ReporteServiceTcpdf();
            $pdf->SetTitle('Caja');
            $pdf->setMargins(10, 5, 5);
            $pdf->AddPage('L', 'LETTER');
            $pdf->setPrintHeader(false);
            $pdf->setY(13);
            $pdf->SetFont('helvetica', 'B', 12);
            $pdf->Cell(0, 6, "MOVIMIENTO DE CAJA", 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 10);
            $pdf->Cell(0, 5, "Expedido: " . date("d/m/Y"), 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 8);
            $ancho = 20;

            $font_size = 8;
            $font_size2 = 9;
            $font_size3 = 10;

            // Encabezado de tabla
            $pdf->Ln();
            $pdf->SetFont('helvetica', 'B', $font_size2);
            $pdf->SetX(9);
            $pdf->Ln(2);
            $pdf->Cell(23, 5, "Elaborado por: ", 0, 0, 'L');
            $pdf->SetFont('helvetica', '', $font_size2);
            $pdf->Cell(40, 5,  Auth::user()->full_name, 0, 0);
            $pdf->Cell(195, 5, "Del " . date('d/m/Y', strtotime($fecha_ini)) . " al " . date('d/m/Y', strtotime($fecha_fin)), 0, 1, 'R');

            $alto = 10;
            $font_size = 8;
            $font_size2 = 9;
            $font_size3 = 10;

            $pdf->setFont("helvetica", "B", $font_size2);
            $pdf->cellAutoFontSize($pdf, 15, $alto, 'NRO', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 31, $alto, 'SUCURSAL', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 31, $alto, 'ALMACÉN', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 35, $alto, 'DETALLE', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 20, $alto, 'TIPO', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 25, $alto, 'EFECTIVO BS.', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 25, $alto, 'QR BS.', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 25, $alto, 'TOTAL BS.', $font_size2, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 30, $alto, 'RESPONSABLE', $font_size, 5, 'B');
            $pdf->cellAutoFontSize($pdf, 30, $alto, 'FECHA Y HORA', $font_size, 5, 'B');
            $pdf->Ln();
            $s_monto_efectivo = 0;
            $s_monto_qr = 0;
            $s_monto_total = 0;
            $cont = 1;
            foreach ($movimiento_cajas as $item) {
                $pdf->cellAutoFontSize($pdf, 15, $alto, $cont++, $font_size, 5, 'N', 'L', 1, 0);
                $pdf->cellAutoFontSize($pdf, 31, $alto, $item->sucursal->nombre, $font_size, 5, 'N', 'L', 1, 0);
                $pdf->cellAutoFontSize($pdf, 31, $alto, $item->almacen->nombre, $font_size, 5, 'N', 'L', 1, 0);
                $pdf->cellAutoFontSize($pdf, 35, $alto, $item->tipo, $font_size, 5, 'N', 'L', 1, 0);
                $pdf->SetFillColor(255, 227, 227);
                if ($item->tipo_movimiento == 'INGRESO') {
                    $pdf->SetFillColor(211, 250, 229);
                }
                $pdf->cellAutoFontSize($pdf, 20, $alto, $item->tipo_movimiento, $font_size, 5, 'N', 'L', 1, 1);
                $pdf->cellAutoFontSize($pdf, 25, $alto, $item->monto_efectivo, $font_size, 5, 'N', 'L', 1, 1);
                $pdf->cellAutoFontSize($pdf, 25, $alto, $item->monto_qr, $font_size, 5, 'N', 'L', 1, 1);
                $pdf->cellAutoFontSize($pdf, 25, $alto, $item->monto_total, $font_size, 5, 'N', 'L', 1, 1);
                $pdf->cellAutoFontSize($pdf, 30, $alto, $item->user->full_name, $font_size, 5, 'N', 'L', 1, 0);
                $pdf->cellAutoFontSize($pdf, 30, $alto, $item->fecha_hora_t, $font_size, 5, 'N', 'L', 1, 0);

                if ($item->tipo_movimiento == 'INGRESO') {
                    $s_monto_total += (float)$item->monto_total;
                    $s_monto_efectivo += (float)$item->monto_efectivo;
                    $s_monto_qr += (float)$item->monto_qr;
                } else {
                    $s_monto_total -= (float)$item->monto_total;
                    $s_monto_efectivo -= (float)$item->monto_efectivo;
                    $s_monto_qr -= (float)$item->monto_qr;
                }

                $pdf->Ln();
            }
            $pdf->cellAutoFontSize($pdf, 132, $alto, 'TOTAL BS.', $font_size3, 5, 'B', 'R');
            $pdf->cellAutoFontSize($pdf, 25, $alto, number_format($s_monto_efectivo, 2, ".", ""), $font_size2, 5, 'B', 'L');
            $pdf->cellAutoFontSize($pdf, 25, $alto, number_format($s_monto_qr, 2, ".", ""), $font_size2, 5, 'B', 'L');
            $pdf->cellAutoFontSize($pdf, 25, $alto, number_format($s_monto_total, 2, ".", ""), $font_size2, 5, 'B', 'L');


            // Guardar PDF o forzar descarga
            return response($pdf->Output('S'), 200)
                ->header('Content-Type', 'application/pdf')
                ->header('Content-Disposition', 'inline; filename="caja.pdf"');
        } else {
            // EXCEL
            $spreadsheet = new Spreadsheet();

            $spreadsheet->getProperties()
                ->setCreator("ADMIN")
                ->setLastModifiedBy('Administración')
                ->setTitle('Registros')
                ->setSubject('Registros')
                ->setDescription('Registros')
                ->setKeywords('PHPSpreadsheet')
                ->setCategory('Listado');

            $spreadsheet->getProperties()
                ->setCreator("ADMIN")
                ->setLastModifiedBy('Administración')
                ->setTitle('Registros')
                ->setSubject('Registros')
                ->setDescription('Registros')
                ->setKeywords('PHPSpreadsheet')
                ->setCategory('Listado');

            $sheet = $spreadsheet->getActiveSheet();
            $spreadsheet->getDefaultStyle()->getFont()->setName('Arial');

            $sheet = $spreadsheet->getActiveSheet();
            $spreadsheet->getDefaultStyle()->getFont()->setName('Arial');

            $fila = 1;
            if (file_exists(public_path() . '/imgs/' . $this->configuracion->logo)) {
                $drawing = new \PhpOffice\PhpSpreadsheet\Worksheet\Drawing();
                $drawing->setName('logo');
                $drawing->setDescription('logo');
                $drawing->setPath(public_path() . '/imgs/' . $this->configuracion->logo); // put your path and image here
                $drawing->setCoordinates('A' . $fila);
                $drawing->setOffsetX(5);
                $drawing->setOffsetY(0);
                $drawing->setHeight(70);
                $drawing->setWorksheet($sheet);
            }

            $fila = 2;
            $sheet->setCellValue('A' . $fila, $this->configuracion->nombre_sistema);
            $sheet->mergeCells("A" . $fila . ":J" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':J' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':J' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $sheet->setCellValue('A' . $fila, "MOVIMIENTO DE CAJA");
            $sheet->mergeCells("A" . $fila . ":J" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':J' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':J' . $fila)->applyFromArray($this->titulo);
            $fila++;
            /* ===================== ELABORADO ===================== */
            $sheet->setCellValue('A' . $fila, 'Elaborado por:');
            $sheet->mergeCells("A{$fila}:B{$fila}");
            $sheet->getStyle("A{$fila}:B{$fila}")->applyFromArray($this->textRight);
            $sheet->setCellValue('C' . $fila, Auth::user()->nombre . ' ' . AUth::user()->paterno . ' ' . Auth::user()->materno);
            $sheet->mergeCells("C{$fila}:J{$fila}");
            $fila++;
            /* ===================== FECHA ===================== */
            $sheet->setCellValue('A' . $fila, 'Fecha:');
            $sheet->mergeCells("A{$fila}:B{$fila}");
            $sheet->getStyle("A{$fila}:B{$fila}")->applyFromArray($this->textRight);

            $sheet->setCellValue('C' . $fila, 'Del ' . date("d/m/Y", strtotime($fecha_ini)) . ' al ' . date("d/m/Y", strtotime($fecha_fin)));
            $sheet->mergeCells("C{$fila}:J{$fila}");

            $fila++;
            $fila++;
            $sheet->setCellValue('A' . $fila, 'NRO');
            $sheet->setCellValue('B' . $fila, 'SUCURSAL');
            $sheet->setCellValue('C' . $fila, 'ALMACÉN');
            $sheet->setCellValue('D' . $fila, 'DETALLE');
            $sheet->setCellValue('E' . $fila, 'TIPO');
            $sheet->setCellValue('F' . $fila, 'EFECTIVO BS.');
            $sheet->setCellValue('G' . $fila, 'QR BS.');
            $sheet->setCellValue('H' . $fila, 'TOTAL BS.');
            $sheet->setCellValue('I' . $fila, 'RESPONSABLE');
            $sheet->setCellValue('J' . $fila, 'FECHA Y HORA');
            $sheet->getStyle('A' . $fila . ':J' . $fila)->applyFromArray($this->headerTabla);
            $fila++;

            $s_monto_efectivo = 0;
            $s_monto_qr = 0;
            $s_monto_total = 0;
            $cont = 1;
            foreach ($movimiento_cajas as $key => $item) {
                $sheet->setCellValue('A' . $fila, $cont++);
                $sheet->setCellValue('B' . $fila, $item->sucursal->nombre);
                $sheet->setCellValue('C' . $fila, $item->almacen->nombre);
                $sheet->setCellValue('D' . $fila, $item->tipo);
                $sheet->setCellValue('E' . $fila, $item->tipo_movimiento);
                if ($item->tipo_movimiento == 'INGRESO') {
                    $sheet->setCellValue('F' . $fila, $item->monto_efectivo);
                    $sheet->setCellValue('G' . $fila, $item->monto_qr);
                    $sheet->setCellValue('H' . $fila, $item->monto_total);
                } else {
                    $sheet->setCellValue('F' . $fila, "-" . $item->monto_efectivo);
                    $sheet->setCellValue('G' . $fila, "-" . $item->monto_qr);
                    $sheet->setCellValue('H' . $fila, "-" . $item->monto_total);
                }
                $sheet->setCellValue('I' . $fila, $item->user->full_name);
                $sheet->setCellValue('J' . $fila, $item->fecha_hora_t);
                $sheet->getStyle('A' . $fila . ':J' . $fila)->applyFromArray($this->bodyTabla);
                if ($item->tipo_movimiento == 'INGRESO') {
                    $s_monto_total += (float)$item->monto_total;
                    $s_monto_efectivo += (float)$item->monto_efectivo;
                    $s_monto_qr += (float)$item->monto_qr;
                } else {
                    $s_monto_total -= (float)$item->monto_total;
                    $s_monto_efectivo -= (float)$item->monto_efectivo;
                    $s_monto_qr -= (float)$item->monto_qr;
                }

                $fila++;
            }
            $sheet->setCellValue('A' . $fila, "TOTALES");
            $sheet->mergeCells("A" . $fila . ":E" . $fila);  //COMBINAR CELDAS
            $sheet->setCellValue('F' . $fila, number_format($s_monto_efectivo, 2, ".", ""));
            $sheet->setCellValue('G' . $fila, number_format($s_monto_qr, 2, ".", ""));
            $sheet->setCellValue('H' . $fila, number_format($s_monto_total, 2, ".", ""));
            $sheet->getStyle('A' . $fila . ':H' . $fila)->applyFromArray($this->headerTabla);

            $sheet->getColumnDimension('A')->setWidth(6);
            $sheet->getColumnDimension('B')->setWidth(20);
            $sheet->getColumnDimension('C')->setWidth(15);
            $sheet->getColumnDimension('D')->setWidth(30);
            $sheet->getColumnDimension('E')->setWidth(15);
            $sheet->getColumnDimension('F')->setWidth(20);
            $sheet->getColumnDimension('G')->setWidth(15);
            $sheet->getColumnDimension('H')->setWidth(15);
            $sheet->getColumnDimension('I')->setWidth(15);
            $sheet->getColumnDimension('J')->setWidth(15);

            foreach (range('A', 'J') as $columnID) {
                $sheet->getStyle($columnID)->getAlignment()->setWrapText(true);
            }

            $sheet->getPageSetup()->setOrientation(\PhpOffice\PhpSpreadsheet\Worksheet\PageSetup::ORIENTATION_LANDSCAPE);
            $sheet->getPageMargins()->setTop(0.5);
            $sheet->getPageMargins()->setRight(0.1);
            $sheet->getPageMargins()->setLeft(0.1);
            $sheet->getPageMargins()->setBottom(0.1);
            $sheet->getPageSetup()->setPrintArea('A:J');
            $sheet->getPageSetup()->setFitToWidth(1);
            $sheet->getPageSetup()->setFitToHeight(0);

            return response()->streamDownload(
                function () use ($spreadsheet) {
                    $writer = IOFactory::createWriter($spreadsheet, 'Xlsx');
                    $writer->save('php://output');
                },
                'movimiento_caja_' . time() . '.xlsx',
                [
                    'Content-Type' => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                ]
            );
        }
    }


    public function historial_accions()
    {
        return Inertia::render("Admin/Reportes/HistorialAccions");
    }

    public function r_historial_accions(Request $request)
    {
        ini_set('memory_limit', '1024M');
        set_time_limit(-1);
        $user_id =  $request->user_id;
        $modulo =  $request->modulo;
        $fecha_ini =  $request->fecha_ini;
        $fecha_fin =  $request->fecha_fin;
        $formato =  $request->formato;
        $historial_accions = HistorialAccion::select("historial_accions.*");

        if ($user_id != 'todos') {
            $historial_accions->where('user_id', $user_id);
        }
        if ($modulo != 'todos') {
            $historial_accions->where('modulo', $modulo);
        }

        if ($fecha_ini && $fecha_fin) {
            $historial_accions->whereBetween('fecha', [$fecha_ini, $fecha_fin]);
        }

        $historial_accions = $historial_accions->get();

        if ($formato == 'pdf') {
            $pdf = PDF::loadView('reportes.historial_accions', compact('historial_accions'))->setPaper('letter', 'portrait');

            // ENUMERAR LAS PÁGINAS USANDO CANVAS
            $pdf->output();
            $dom_pdf = $pdf->getDomPDF();
            $canvas = $dom_pdf->get_canvas();
            $alto = $canvas->get_height();
            $ancho = $canvas->get_width();
            $canvas->page_text($ancho - 90, $alto - 25, "Página {PAGE_NUM} de {PAGE_COUNT}", null, 9, array(0, 0, 0));

            return $pdf->stream('historial_accions.pdf');
        } else {
            $spreadsheet = new Spreadsheet();
            $spreadsheet->getProperties()
                ->setCreator("ADMIN")
                ->setLastModifiedBy('Administración')
                ->setTitle('Registros')
                ->setSubject('Registros')
                ->setDescription('Registros')
                ->setKeywords('PHPSpreadsheet')
                ->setCategory('Listado');

            $sheet = $spreadsheet->getActiveSheet();

            $spreadsheet->getDefaultStyle()->getFont()->setName('Arial');

            $fila = 1;
            if (file_exists(public_path() . '/imgs/' . $this->configuracion->logo)) {
                $drawing = new \PhpOffice\PhpSpreadsheet\Worksheet\Drawing();
                $drawing->setName('logo');
                $drawing->setDescription('logo');
                $drawing->setPath(public_path() . '/imgs/' . $this->configuracion->logo); // put your path and image here
                $drawing->setCoordinates('A' . $fila);
                $drawing->setOffsetX(5);
                $drawing->setOffsetY(0);
                $drawing->setHeight(70);
                $drawing->setWorksheet($sheet);
            }

            $fila = 2;
            $sheet->setCellValue('A' . $fila, $this->configuracion->nombre_sistema);
            $sheet->mergeCells("A" . $fila . ":F" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':F' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $sheet->setCellValue('A' . $fila, "LOG DE USUARIOS");
            $sheet->mergeCells("A" . $fila . ":F" . $fila);  //COMBINAR CELDAS
            $sheet->getStyle('A' . $fila . ':F' . $fila)->getAlignment()->setHorizontal('center');
            $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->titulo);
            $fila++;
            $fila++;
            $sheet->setCellValue('A' . $fila, 'N°');
            $sheet->setCellValue('B' . $fila, 'FECHA Y HORA');
            $sheet->setCellValue('C' . $fila, 'USUARIO');
            $sheet->setCellValue('D' . $fila, 'DESCRIPCIÓN');
            $sheet->setCellValue('E' . $fila, 'MÓDULO');
            $sheet->setCellValue('F' . $fila, 'ACCIÓN');
            $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->headerTabla);
            $fila++;

            foreach ($historial_accions as $key => $item) {
                $sheet->setCellValue('A' . $fila, $key + 1);
                $sheet->setCellValue('B' . $fila, $item->fecha_t . ' ' . $item->hora);
                $sheet->setCellValue('C' . $fila, $item->user->full_name);
                $sheet->setCellValue('D' . $fila, $item->descripcion);
                $sheet->setCellValue('E' . $fila, $item->modulo);
                $sheet->setCellValue('F' . $fila, $item->accion);
                $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray($this->bodyTabla);
                $fila++;
            }

            $sheet->getColumnDimension('A')->setWidth(6);
            $sheet->getColumnDimension('B')->setWidth(20);
            $sheet->getColumnDimension('C')->setWidth(15);
            $sheet->getColumnDimension('D')->setWidth(25);
            $sheet->getColumnDimension('E')->setWidth(18);
            $sheet->getColumnDimension('F')->setWidth(15);

            foreach (range('A', 'F') as $columnID) {
                $sheet->getStyle($columnID)->getAlignment()->setWrapText(true);
            }

            $sheet->getPageSetup()->setOrientation(\PhpOffice\PhpSpreadsheet\Worksheet\PageSetup::ORIENTATION_LANDSCAPE);
            $sheet->getPageMargins()->setTop(0.5);
            $sheet->getPageMargins()->setRight(0.1);
            $sheet->getPageMargins()->setLeft(0.1);
            $sheet->getPageMargins()->setBottom(0.1);
            $sheet->getPageSetup()->setPrintArea('A:F');
            $sheet->getPageSetup()->setFitToWidth(1);
            $sheet->getPageSetup()->setFitToHeight(0);

            return response()->streamDownload(
                function () use ($spreadsheet) {
                    $writer = IOFactory::createWriter($spreadsheet, 'Xlsx');
                    $writer->save('php://output');
                },
                'historial_accions_' . time() . '.xlsx',
                [
                    'Content-Type' => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                ]
            );
        }
    }
}
