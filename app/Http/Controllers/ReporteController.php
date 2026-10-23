<?php

namespace App\Http\Controllers;

use App\Models\Almacen;
use App\Models\Certificado;
use App\Models\CertificadoDetalle;
use App\Models\Cliente;
use App\Models\Configuracion;
use App\Models\HistorialAccion;
use App\Models\IngresoProducto;
use App\Models\Inscripcion;
use App\Models\Pago;
use App\Models\Producto;
use App\Models\TipoCertificado;
use App\Models\User;
use App\Services\MovimientoCajaService;
use App\Services\PagoService;
use App\Services\ReporteService;
use App\Services\ReporteServiceTcpdf;
use App\Services\TipoPagoService;
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
use PhpOffice\PhpSpreadsheet\Worksheet\Drawing;
use PhpOffice\PhpSpreadsheet\Cell\Coordinate;
use PhpOffice\PhpSpreadsheet\Worksheet\PageSetup;

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
    public function __construct(private MovimientoCajaService $movimiento_caja_service, private TipoPagoService $tipo_pago_service)
    {
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
        return Inertia::render("Admin/Reportes/StockProductos");
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
            $pdf->SetTitle('Lista de Productos');
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


    public function exportarCaja(Request $request)
    {
        ini_set('memory_limit', '1024M');
        set_time_limit(-1);
        $fecha_ini = $request->fecha_ini;
        $fecha_fin = $request->fecha_fin;
        $sucursal_id = $request->sucursal_id;
        $user_id = $request->user_id;
        $formato = $request->formato;

        $array_res = $this->movimiento_caja_service->reporteMovimientos(
            $fecha_ini,
            $fecha_fin,
            $sucursal_id,
            $user_id
        );
        $pagos = $array_res[0];
        $suma_tipos = $array_res[1];
        $pagos_sin_verificar = $array_res[2];
        $suma_tipos_sin_verificar = $array_res[3];
        $suma_total_tipos = $array_res[4];

        $tipo_pagos = $this->tipo_pago_service->listado();

        if ($formato == 'pdf') {

            $pdf = new ReporteServiceTcpdf();
            $pdf->SetTitle('Caja');
            $pdf->setMargins(10, 5, 5);
            $pdf->AddPage();
            $pdf->setPrintHeader(false);
            $pdf->setY(13);
            $pdf->SetFont('helvetica', 'B', 12);
            $pdf->Cell(0, 6, "ARQUEO DE CAJA", 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 10);
            $pdf->Cell(0, 5, "Expedido: " . date("d/m/Y"), 0, 1, 'C', 0, '', 0, false);
            $pdf->SetFont('helvetica', 'B', 8);
            $ancho = 20;
            $font_size = 8;
            $font_size2 = 9;

            // Encabezado de tabla
            $pdf->Ln();
            $pdf->SetFont('helvetica', 'B', $font_size2);
            $pdf->SetX(9);
            $pdf->Cell(23, 5, "Elaborado por: ", 0, 0, 'L');

            $pdf->SetFont('helvetica', '', $font_size2);
            $pdf->Cell(40, 5,  Auth::user()->full_name, 0, 0);
            $pdf->Cell(133, 5, "Del " . date('d/m/Y', strtotime($fecha_ini)) . " al " . date('d/m/Y', strtotime($fecha_fin)), 0, 1, 'R');

            $pdf->SetFont('helvetica', 'B', $font_size);

            $thTipoPagos = '';
            foreach ($tipo_pagos as $item) {
                $thTipoPagos .= '<th style="font-weight:bold;background-color:#153f59;color:white; text-align:right;">' . $item['value'] . ' Bs.</th>';
            }

            $html = '   <table border="1" cellpadding="3">
            <thead class="bg-red" width="100%">
                <tr>
                    <th style="font-weight:bold;background-color:#153f59;color:white;" width="18">N°</th>
                    <th style="font-weight:bold;background-color:#153f59;color:white;" width="50">FECHA</th>
                    <th style="font-weight:bold;background-color:#153f59;color:white;" width="70">SUCURSAL</th>
                    <th style="font-weight:bold;background-color:#153f59;color:white;" width="90">PACIENTE</th>
                    <th style="font-weight:bold;background-color:#153f59;color:white;" width="120">DESCRIPCIÓN</th>
                    <th style="font-weight:bold;background-color:#153f59;color:white;">MÉDICO</th>
                    ' . $thTipoPagos . '
                </tr>
            </thead>
            <tbody>';

            $cont = 1;
            $pdf->SetFont('helvetica', 'N', $font_size);
            foreach ($pagos as $item) {
                $html .= '<tr>';
                $html .= '<td  width="18">' . $cont++ . '</td>';
                $html .= '<td  width="50">' . $item->fecha_verificado_t . '<br/>' . $item->hora_verificado . '</td>';
                $html .= '<td  width="70">' . $item->sucursal->nombre . '</td>';
                $html .= '<td width="90">' . $item->cliente->nombre . ' ' . $item->cliente->paterno . ' ' . $item->cliente->materno . '<br/>' . $item->cliente->full_ci . '</td>';
                $html .= '<td width="120">' . $item->certificado_detalle->tipo_certificado->nombre . '<br/><small style="font-size:6pt">(' . $item->certificado_detalle->certificado->tipo . ($item->certificado_detalle->certificado->tramitador ? ' - ' . $item->certificado_detalle->certificado->tramitador->nombre : '') . '</small>)</td>';
                $html .= '<td>' . ($item->medico ? $item->medico->nombre . ' ' . $item->medico->paterno . ' ' . $item->medico->materno : '') . '</td>';

                $tdTipoPagos = '';
                foreach ($tipo_pagos as $tipo_pago) {
                    $tdTipoPagos .= '<td style="text-align:right;">' . ($item->tipo_pago == $tipo_pago['value'] ? $item->monto : '') . '</td>';
                }

                $html .= $tdTipoPagos . '</tr>';
            }
            $suma_total = 0;
            $html .= '<tr>';
            $html .= '<td style="text-align:right;font-weight:bold;" colspan="6">TOTAL BS.</td>';
            foreach ($tipo_pagos as $tipo_pago) {
                $suma_total += (float) $suma_tipos[$tipo_pago['value']];
                $html .= '<td style="text-align:right;font-weight:bold;">' . number_format($suma_tipos[$tipo_pago["value"]], 2, '.', '') . '</td>';
            }

            $html .= '</tr>';
            $html .= '<tr>';
            $html .= '<td style="text-align:right;font-weight:bold;" colspan="6">TOTAL FINAL BS.</td>';
            $html .= '<td style="text-align:center;font-weight:bold;" colspan="2">' . number_format($suma_total, 2, '.', '') . '</td>';
            $html .= '</tr>';
            $html .= '</tbody></table>';
            $pdf->writeHTML($html, true, false, true, false, '');

            // SIN VERIFICAR
            if (count($pagos_sin_verificar) > 0) {
                $pdf->Ln();
                $pdf->SetFont('helvetica', 'B', 12);
                $pdf->Cell(0, 6, "PAGOS SIN RECEPCIÓN", 0, 1, 'C', 0, '', 0, false);
                $html = '   <table border="1" cellpadding="3">
                <thead class="bg-red" width="100%">
                    <tr>
                        <th style="font-weight:bold;background-color:#f02222;color:white;" width="18">N°</th>
                        <th style="font-weight:bold;background-color:#f02222;color:white;" width="50">FECHA</th>
                        <th style="font-weight:bold;background-color:#f02222;color:white;" width="70">SUCURSAL</th>
                        <th style="font-weight:bold;background-color:#f02222;color:white;">PACIENTE</th>
                        <th style="font-weight:bold;background-color:#f02222;color:white;" width="120">DESCRIPCIÓN</th>
                        <th style="font-weight:bold;background-color:#f02222;color:white;">MÉDICO</th>
                        ' . $thTipoPagos . '
                    </tr>
                </thead>
                <tbody>';

                $cont = 1;
                $suma_total = 0;
                $pdf->SetFont('helvetica', 'N', $font_size);
                foreach ($pagos_sin_verificar as $item) {
                    $html .= '<tr>';
                    $html .= '<td  width="18">' . $cont++ . '</td>';
                    $html .= '<td  width="50">' . $item->fecha_verificado_t . '<br/>' . $item->hora_verificado . '</td>';
                    $html .= '<td  width="70">' . $item->sucursal->nombre . '</td>';
                    $html .= '<td>' . $item->cliente->nombre . ' ' . $item->cliente->paterno . ' ' . $item->cliente->materno . '<br/>' . $item->cliente->full_ci . '</td>';
                    $html .= '<td width="120">' . $item->certificado_detalle->tipo_certificado->nombre . '<br/><small style="font-size:6pt">(' . $item->certificado_detalle->certificado->tipo . ($item->certificado_detalle->certificado->tramitador ? ' - ' . $item->certificado_detalle->certificado->tramitador->nombre : '') . '</small>)</td>';
                    $html .= '<td>' . ($item->medico ? $item->medico->nombre . ' ' . $item->medico->paterno . ' ' . $item->medico->materno : '') . '</td>';

                    $tdTipoPagos = '';
                    foreach ($tipo_pagos as $tipo_pago) {
                        $tdTipoPagos .= '<td style="text-align:right;">' . ($item->tipo_pago == $tipo_pago['value'] ? $item->monto : '') . '</td>';
                    }

                    $html .= $tdTipoPagos . '</tr>';
                }
                $suma_total = 0;
                $html .= '<tr>';
                $html .= '<td style="text-align:right;font-weight:bold;" colspan="6">TOTAL BS.</td>';
                foreach ($tipo_pagos as $tipo_pago) {
                    $suma_total += (float) $suma_tipos_sin_verificar[$tipo_pago['value']];
                    $html .= '<td style="text-align:right;font-weight:bold;">' . number_format($suma_tipos_sin_verificar[$tipo_pago["value"]], 2, '.', '') . '</td>';
                }

                $html .= '</tr>';
                $html .= '<tr>';
                $html .= '<td style="text-align:right;font-weight:bold;" colspan="6">TOTAL FINAL BS.</td>';
                $html .= '<td style="text-align:center;font-weight:bold;" colspan="2">' . number_format($suma_total, 2, '.', '') . '</td>';
                $html .= '</tr>';
                $html .= '</tbody></table>';
                $pdf->writeHTML($html, true, false, true, false, '');

                // resumen
                $pdf->Ln();
                $pdf->SetFont('helvetica', 'B', 12);
                $pdf->Cell(0, 6, "RESUMEN GENERAL", 0, 1, 'C', 0, '', 0, false);

                $html = '<table border="1" cellpadding="3">';
                $html .= '</thead>
                    <tr>
                    <th>TIPO DE PAGO</th>
                    <th>MONTO BS.</th>
                    </tr>
                </thead><tbody>';
                $total_final = 0;

                foreach ($tipo_pagos as $tipo_pago) {
                    $html .= '<tr>';
                    $html .= '<td style="font-weight:normal;">' . $tipo_pago["value"] . '</td>';
                    $html .= '<td style="font-weight:normal;">' . number_format($suma_total_tipos[$tipo_pago['value']], 2, '.', '') . '</td>';
                    $html .= '</tr>';
                    $total_final += (float) $suma_total_tipos[$tipo_pago['value']];
                }
                $html .= '<tr>';
                $html .= '<td>TOTAL GENERAL</td>';
                $html .= '<td>' . number_format($total_final, 2, '.', '') . '</td>';
                $html .= '</tr>';

                $html .= '</tbody></table>';
                $pdf->writeHTML($html, true, false, true, false, '');
            }



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

            $sheet = $spreadsheet->getActiveSheet();
            $spreadsheet->getDefaultStyle()->getFont()->setName('Arial');

            $fila = 1;

            /* ===================== LOGO ===================== */
            if (file_exists(public_path() . '/imgs/' . $this->configuracion->logo)) {
                $drawing = new Drawing();
                $drawing->setName('logo');
                $drawing->setDescription('logo');
                $drawing->setPath(public_path() . '/imgs/' . $this->configuracion->logo);
                $drawing->setCoordinates('A' . $fila);
                $drawing->setHeight(70);
                $drawing->setWorksheet($sheet);
            }

            /* ===================== TITULOS ===================== */
            $totalColumnas = 6 + count($tipo_pagos);
            $lastColumn = Coordinate::stringFromColumnIndex($totalColumnas);

            $fila = 2;

            $sheet->setCellValue('A' . $fila, $this->configuracion->nombre_sistema);
            $sheet->mergeCells("A{$fila}:{$lastColumn}{$fila}");
            $sheet->getStyle("A{$fila}:{$lastColumn}{$fila}")
                ->getAlignment()->setHorizontal('center');
            $sheet->getStyle("A{$fila}:{$lastColumn}{$fila}")
                ->applyFromArray($this->titulo);

            $fila++;

            $sheet->setCellValue('A' . $fila, "ARQUEO DE CAJA");
            $sheet->mergeCells("A{$fila}:{$lastColumn}{$fila}");
            $sheet->getStyle("A{$fila}:{$lastColumn}{$fila}")
                ->getAlignment()->setHorizontal('center');
            $sheet->getStyle("A{$fila}:{$lastColumn}{$fila}")
                ->applyFromArray($this->titulo);

            $fila += 2;
            /* ===================== ELABORADO ===================== */
            $sheet->setCellValue('A' . $fila, 'Elaborado por:');
            $sheet->mergeCells("A{$fila}:B{$fila}");
            $sheet->getStyle("A{$fila}:B{$fila}")->applyFromArray($this->textRight);
            $sheet->setCellValue('C' . $fila, Auth::user()->nombre . ' ' . AUth::user()->paterno . ' ' . Auth::user()->materno);
            $sheet->mergeCells("C{$fila}:{$lastColumn}{$fila}");
            $fila++;

            /* ===================== FECHA ===================== */
            $sheet->setCellValue('A' . $fila, 'Fecha:');
            $sheet->mergeCells("A{$fila}:B{$fila}");
            $sheet->getStyle("A{$fila}:B{$fila}")->applyFromArray($this->textRight);

            $sheet->setCellValue('C' . $fila, 'Del ' . date("d/m/Y", strtotime($fecha_ini)) . ' al ' . date("d/m/Y", strtotime($fecha_fin)));
            $sheet->mergeCells("C{$fila}:{$lastColumn}{$fila}");

            $fila++;
            /* ===================== HEADERS ===================== */
            $colIndex = 1;

            $sheet->setCellValue(Coordinate::stringFromColumnIndex($colIndex++) . $fila, 'N°');
            $sheet->setCellValue(Coordinate::stringFromColumnIndex($colIndex++) . $fila, 'FECHA');
            $sheet->setCellValue(Coordinate::stringFromColumnIndex($colIndex++) . $fila, 'SUCURSAL');
            $sheet->setCellValue(Coordinate::stringFromColumnIndex($colIndex++) . $fila, 'PACIENTE');
            $sheet->setCellValue(Coordinate::stringFromColumnIndex($colIndex++) . $fila, 'DESCRIPCIÓN');
            $sheet->setCellValue(Coordinate::stringFromColumnIndex($colIndex++) . $fila, 'MÉDICO');

            /* columnas dinámicas */
            foreach ($tipo_pagos as $tipo) {
                $sheet->setCellValue(
                    Coordinate::stringFromColumnIndex($colIndex++) . $fila,
                    $tipo['value'] . ' Bs.'
                );
            }

            $totalColumnas = $colIndex - 1;
            $lastColumn = Coordinate::stringFromColumnIndex($totalColumnas);

            $sheet->getStyle("A{$fila}:{$lastColumn}{$fila}")
                ->applyFromArray($this->headerTabla);

            $fila++;

            /* ===================== DATA ===================== */
            foreach ($pagos as $key => $item) {
                $colIndex = 1;

                $sheet->setCellValue(Coordinate::stringFromColumnIndex($colIndex++) . $fila, $key + 1);

                $sheet->setCellValue(
                    Coordinate::stringFromColumnIndex($colIndex++) . $fila,
                    $item->fecha_verificado_t . "\n" . $item->hora_verificado
                );

                $sheet->setCellValue(
                    Coordinate::stringFromColumnIndex($colIndex++) . $fila,
                    $item->sucursal->nombre
                );

                $sheet->setCellValue(
                    Coordinate::stringFromColumnIndex($colIndex++) . $fila,
                    $item->cliente->nombre . ' ' .
                        $item->cliente->paterno . ' ' .
                        $item->cliente->materno
                );

                $tramitador_txt = "";
                if ($item->certificado_detalle->certificado->tramitador) {
                    $tramitador_txt = " - " . $item->certificado_detalle->certificado->tramitador->nombre;
                }

                $sheet->setCellValue(
                    Coordinate::stringFromColumnIndex($colIndex++) . $fila,
                    $item->certificado_detalle->tipo_certificado->nombre . "\n(" .
                        $item->certificado_detalle->certificado->tipo . $tramitador_txt . ")"
                );

                if ($item->medico) {
                    $sheet->setCellValue(
                        Coordinate::stringFromColumnIndex($colIndex++) . $fila,
                        $item->medico->nombre . ' ' . $item->medico->paterno
                    );
                } else {
                    $sheet->setCellValue(
                        Coordinate::stringFromColumnIndex($colIndex++) . $fila,
                        ''
                    );
                }

                foreach ($tipo_pagos as $tipo) {
                    $value = ($item->tipo_pago == $tipo['value'])
                        ? number_format($item->monto, 2, ".", "")
                        : '';

                    $sheet->setCellValue(
                        Coordinate::stringFromColumnIndex($colIndex++) . $fila,
                        $value
                    );
                }

                $sheet->getStyle("A{$fila}:{$lastColumn}{$fila}")
                    ->applyFromArray($this->bodyTabla);

                $fila++;
            }

            /* ===================== TOTALES ===================== */
            $sheet->setCellValue("A{$fila}", "TOTAL BS.");
            $sheet->mergeCells("A{$fila}:" . Coordinate::stringFromColumnIndex(6) . "{$fila}");

            $colIndex = 7;
            $suma_total = 0;

            foreach ($tipo_pagos as $tipo) {
                $total = $suma_tipos[$tipo['value']] ?? 0;

                $sheet->setCellValue(
                    Coordinate::stringFromColumnIndex($colIndex++) . $fila,
                    number_format($total, 2, ".", "")
                );

                $suma_total += $total;
            }

            $sheet->getStyle("A{$fila}:{$lastColumn}{$fila}")
                ->applyFromArray($this->headerTabla);

            $fila++;

            /* ===================== TOTAL FINAL ===================== */
            $sheet->setCellValue("A{$fila}", "TOTAL FINAL BS.");
            $sheet->mergeCells("A{$fila}:" . Coordinate::stringFromColumnIndex(6) . "{$fila}");

            $sheet->setCellValue(
                Coordinate::stringFromColumnIndex(7) . $fila,
                number_format($suma_total, 2, ".", "")
            );
            $sheet->getStyle("A{$fila}:{$lastColumn}{$fila}")
                ->applyFromArray($this->headerTabla);

            /*******************************
             *  PAGO SIN VERIFICAR
             ****************************** */
            if (count($pagos_sin_verificar) > 0) {
                $fila++;
                $fila++;
                $sheet->setCellValue('A' . $fila, "PAGOS SIN RECEPCIÓN");
                $sheet->mergeCells("A{$fila}:{$lastColumn}{$fila}");
                $sheet->getStyle("A{$fila}:{$lastColumn}{$fila}")
                    ->getAlignment()->setHorizontal('center');
                $sheet->getStyle("A{$fila}:{$lastColumn}{$fila}")
                    ->applyFromArray($this->titulo);

                $fila++;
                /* ===================== HEADERS ===================== */
                $colIndex = 1;

                $sheet->setCellValue(Coordinate::stringFromColumnIndex($colIndex++) . $fila, 'N°');
                $sheet->setCellValue(Coordinate::stringFromColumnIndex($colIndex++) . $fila, 'FECHA');
                $sheet->setCellValue(Coordinate::stringFromColumnIndex($colIndex++) . $fila, 'SUCURSAL');
                $sheet->setCellValue(Coordinate::stringFromColumnIndex($colIndex++) . $fila, 'PACIENTE');
                $sheet->setCellValue(Coordinate::stringFromColumnIndex($colIndex++) . $fila, 'DESCRIPCIÓN');
                $sheet->setCellValue(Coordinate::stringFromColumnIndex($colIndex++) . $fila, 'MÉDICO');

                /* columnas dinámicas */
                foreach ($tipo_pagos as $tipo) {
                    $sheet->setCellValue(
                        Coordinate::stringFromColumnIndex($colIndex++) . $fila,
                        $tipo['value'] . ' Bs.'
                    );
                }

                $totalColumnas = $colIndex - 1;
                $lastColumn = Coordinate::stringFromColumnIndex($totalColumnas);

                $sheet->getStyle("A{$fila}:{$lastColumn}{$fila}")
                    ->applyFromArray($this->headerTablaRed);

                $fila++;

                /* ===================== DATA ===================== */
                foreach ($pagos_sin_verificar as $key => $item) {
                    $colIndex = 1;

                    $sheet->setCellValue(Coordinate::stringFromColumnIndex($colIndex++) . $fila, $key + 1);

                    $sheet->setCellValue(
                        Coordinate::stringFromColumnIndex($colIndex++) . $fila,
                        $item->fecha_verificado_t . "\n" . $item->hora_verificado
                    );

                    $sheet->setCellValue(
                        Coordinate::stringFromColumnIndex($colIndex++) . $fila,
                        $item->sucursal->nombre
                    );

                    $sheet->setCellValue(
                        Coordinate::stringFromColumnIndex($colIndex++) . $fila,
                        $item->cliente->nombre . ' ' .
                            $item->cliente->paterno . ' ' .
                            $item->cliente->materno
                    );

                    $tramitador_txt = "";
                    if ($item->certificado_detalle->certificado->tramitador) {
                        $tramitador_txt = " - " . $item->certificado_detalle->certificado->tramitador->nombre;
                    }

                    $sheet->setCellValue(
                        Coordinate::stringFromColumnIndex($colIndex++) . $fila,
                        $item->certificado_detalle->tipo_certificado->nombre . "\n(" .
                            $item->certificado_detalle->certificado->tipo . $tramitador_txt . ")"
                    );

                    if ($item->medico) {
                        $sheet->setCellValue(
                            Coordinate::stringFromColumnIndex($colIndex++) . $fila,
                            $item->medico->nombre . ' ' . $item->medico->paterno
                        );
                    } else {
                        $sheet->setCellValue(
                            Coordinate::stringFromColumnIndex($colIndex++) . $fila,
                            ''
                        );
                    }

                    foreach ($tipo_pagos as $tipo) {
                        $value = ($item->tipo_pago == $tipo['value'])
                            ? number_format($item->monto, 2, ".", "")
                            : '';

                        $sheet->setCellValue(
                            Coordinate::stringFromColumnIndex($colIndex++) . $fila,
                            $value
                        );
                    }

                    $sheet->getStyle("A{$fila}:{$lastColumn}{$fila}")
                        ->applyFromArray($this->bodyTabla);

                    $fila++;
                }

                /* ===================== TOTALES ===================== */
                $sheet->setCellValue("A{$fila}", "TOTAL BS.");
                $sheet->mergeCells("A{$fila}:" . Coordinate::stringFromColumnIndex(6) . "{$fila}");

                $colIndex = 7;
                $suma_total = 0;

                foreach ($tipo_pagos as $tipo) {
                    $total = $suma_tipos_sin_verificar[$tipo['value']] ?? 0;

                    $sheet->setCellValue(
                        Coordinate::stringFromColumnIndex($colIndex++) . $fila,
                        number_format($total, 2, ".", "")
                    );

                    $suma_total += $total;
                }

                $sheet->getStyle("A{$fila}:{$lastColumn}{$fila}")
                    ->applyFromArray($this->headerTablaRed);

                $fila++;

                /* ===================== TOTAL FINAL ===================== */
                $sheet->setCellValue("A{$fila}", "TOTAL FINAL BS.");
                $sheet->mergeCells("A{$fila}:" . Coordinate::stringFromColumnIndex(6) . "{$fila}");

                $sheet->setCellValue(
                    Coordinate::stringFromColumnIndex(7) . $fila,
                    number_format($suma_total, 2, ".", "")
                );
                $sheet->getStyle("A{$fila}:{$lastColumn}{$fila}")
                    ->applyFromArray($this->headerTablaRed);

                $fila++;
                $fila++;
                // RESUMEN
                $sheet->setCellValue("A{$fila}", "RESUMEN GENERAL");
                $sheet->mergeCells("A{$fila}:{$lastColumn}{$fila}");
                $sheet->getStyle("A{$fila}:{$lastColumn}{$fila}")
                    ->getAlignment()->setHorizontal('center');
                $fila++;
                $sheet->setCellValue("D{$fila}", "TIPO DE PAGO");
                $sheet->setCellValue("E{$fila}", "MONTO");
                $sheet->getStyle("D{$fila}:E{$fila}")
                    ->applyFromArray($this->headerTabla);
                $total_final = 0;
                $fila++;
                foreach ($tipo_pagos as $tipo) {
                    $total = $suma_tipos[$tipo['value']] ?? 0;
                    $total_sin_verificar = $suma_tipos_sin_verificar[$tipo['value']] ?? 0;
                    $total_final_tipo = $total + $total_sin_verificar;
                    $sheet->setCellValue(
                        "D{$fila}",
                        $tipo['value']
                    );
                    $sheet->setCellValue(
                        "E{$fila}",
                        number_format($total_final_tipo, 2, ".", "")
                    );
                    $total_final += (float)$total_final_tipo;
                    $fila++;
                }

                // TOTAL FINAL GENERAL
                $sheet->setCellValue("D{$fila}", "TOTAL GENERAL");
                $sheet->getStyle("D{$fila}:E{$fila}")
                    ->applyFromArray($this->titulo);
                $sheet->setCellValue(
                    "E{$fila}",
                    number_format($total_final, 2, ".", "")
                );
                $sheet->getStyle("D{$fila}:E{$fila}")
                    ->applyFromArray($this->headerTabla);
            }

            /* ===================== COLUMN WIDTH ===================== */
            $sheet->getColumnDimension('A')->setWidth(6);
            $sheet->getColumnDimension('B')->setWidth(18);
            $sheet->getColumnDimension('C')->setWidth(18);
            $sheet->getColumnDimension('D')->setWidth(30);
            $sheet->getColumnDimension('E')->setWidth(30);

            for ($i = 6; $i <= $totalColumnas; $i++) {
                $sheet->getColumnDimension(Coordinate::stringFromColumnIndex($i))->setWidth(15);
            }

            /* ===================== WRAP TEXT ===================== */
            for ($i = 1; $i <= $totalColumnas; $i++) {
                $sheet->getStyle(Coordinate::stringFromColumnIndex($i))
                    ->getAlignment()
                    ->setWrapText(true);
            }

            /* ===================== PAGE SETUP ===================== */
            $sheet->getPageSetup()->setOrientation(PageSetup::ORIENTATION_LANDSCAPE);
            $sheet->getPageMargins()->setTop(0.5);
            $sheet->getPageMargins()->setRight(0.1);
            $sheet->getPageMargins()->setLeft(0.1);
            $sheet->getPageMargins()->setBottom(0.1);

            $sheet->getPageSetup()->setPrintArea("A1:{$lastColumn}{$fila}");
            $sheet->getPageSetup()->setFitToWidth(1);
            $sheet->getPageSetup()->setFitToHeight(0);

            /* ===================== EXPORT ===================== */
            return response()->streamDownload(
                function () use ($spreadsheet) {
                    $writer = IOFactory::createWriter($spreadsheet, 'Xlsx');
                    $writer->save('php://output');
                },
                'caja_' . time() . '.xlsx',
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
