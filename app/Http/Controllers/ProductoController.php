<?php

namespace App\Http\Controllers;

use App\Http\Requests\ProductoStoreRequest;
use App\Http\Requests\ProductoUpdateRequest;
use App\Models\Producto;
use App\Models\User;
use App\Services\ProductoService;
use Exception;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Response;
use Illuminate\Validation\ValidationException;
use Inertia\Inertia;
use Inertia\Response as ResponseInertia;

use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\IOFactory;

class ProductoController extends Controller
{
    public function __construct(private ProductoService $productoService) {}

    /**
     * Página index
     *
     * @return Response
     */
    public function index(): ResponseInertia
    {
        return Inertia::render("Admin/Productos/Index");
    }

    /**
     * Listado de productos sin ids: 1 y 2
     *
     * @return JsonResponse
     */
    public function listado(Request $request): JsonResponse
    {
        return response()->JSON([
            "productos" => $this->productoService->listado($request->input("activo", null))
        ]);
    }

    public function paginado(Request $request)
    {
        $perPage = $request->perPage;
        $page = (int)($request->input("page", 1));
        $search = (string)$request->input("search", "");
        $orderBy = $request->orderBy;
        $orderAsc = $request->orderAsc;

        $columnsSerachLike = [
            "nombre",
            "descripcion",
        ];
        $columnsFilter = [];
        $columnsBetweenFilter = [];
        $arrayOrderBy = [];
        if ($orderBy && $orderAsc) {
            $arrayOrderBy = [
                [$orderBy, $orderAsc]
            ];
        }

        $productos = $this->productoService->listadoPaginado($perPage, $page, $search, $columnsSerachLike, $columnsFilter, $columnsBetweenFilter, $arrayOrderBy);
        return response()->JSON([
            "data" => $productos->items(),
            "total" => $productos->total(),
            "lastPage" => $productos->lastPage()
        ]);
    }

    /**
     * Registrar un nuevo producto
     *
     * @param ProductoStoreRequest $request
     * @return RedirectResponse|Response
     */
    public function store(ProductoStoreRequest $request): RedirectResponse|Response
    {
        DB::beginTransaction();
        try {
            // crear el Producto
            $this->productoService->crear($request->validated());
            DB::commit();
            return redirect()->route("productos.index")->with("bien", "Registro realizado");
        } catch (\Exception $e) {
            DB::rollBack();
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    /**
     * Mostrar un producto
     *
     * @param Producto $producto
     * @return JsonResponse
     */
    public function show(Producto $producto): JsonResponse
    {
        return response()->JSON($producto);
    }

    public function update(Producto $producto, ProductoUpdateRequest $request)
    {
        DB::beginTransaction();
        try {
            // actualizar producto
            $this->productoService->actualizar($request->validated(), $producto);
            DB::commit();
            return redirect()->route("productos.index")->with("bien", "Registro actualizado");
        } catch (\Exception $e) {
            DB::rollBack();
            // Log::debug($e->getMessage());
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    /**
     * Eliminar producto
     *
     * @param Producto $producto
     * @return JsonResponse|Response
     */
    public function destroy(Producto $producto): JsonResponse|Response
    {
        DB::beginTransaction();
        try {
            $this->productoService->eliminar($producto);
            DB::commit();
            return response()->JSON([
                'sw' => true,
                'message' => 'El registro se eliminó correctamente'
            ], 200);
        } catch (\Exception $e) {
            DB::rollBack();
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    public function formato()
    {
        return response()->download(
            public_path("files/formato_productos.xlsx"),
            "formato_productos" . time() . ".xlsx"
        );
    }

    public function cargaProductos(Request $request)
    {
        $request->validate([
            "archivo" => [
                "required",
                "file",
                "mimes:xlsx,xls",
                "max:8192",
            ],
        ], [
            "archivo.required" => "Debe seleccionar un archivo.",
            "archivo.file" => "El archivo seleccionado no es válido.",
            "archivo.mimes" => "El archivo debe ser de tipo Excel (.xlsx o .xls).",
            "archivo.max" => "El archivo no debe superar los 8 MB.",
        ]);
        DB::beginTransaction();
        try {
            // crear el Producto
            $datos["archivo"] = $request->file("archivo");
            $this->productoService->cargarProductos($datos);
            DB::commit();
            return redirect()->route("productos.index")->with("bien", "Registro realizado");
        } catch (\Exception $e) {
            DB::rollBack();
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }



    public function producto_precios()
    {
        $productos = Producto::select([
            "id",
            "codigo",
            "nombre",
            "precio",
            "precio2",
            "precio3",
            "precio4",
        ])
            ->where("activo", 1)
            ->get();

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
        $sheet->setCellValue('A' . $fila, 'CÓDIGO*');
        $sheet->setCellValue('B' . $fila, 'NOMBRE');
        $sheet->setCellValue('C' . $fila, 'PRECIO 1*');
        $sheet->setCellValue('D' . $fila, 'PRECIO 2');
        $sheet->setCellValue('E' . $fila, 'PRECIO 3');
        $sheet->setCellValue('F' . $fila, 'PRECIO 4');
        $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray([
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
        ]);
        $fila++;

        foreach ($productos as $key => $item) {
            $sheet->setCellValue('A' . $fila, $item->codigo);
            $sheet->setCellValue('B' . $fila, $item->nombre);
            $sheet->setCellValue('C' . $fila, $item->precio);
            $sheet->setCellValue('D' . $fila, $item->precio2);
            $sheet->setCellValue('E' . $fila, $item->precio3);
            $sheet->setCellValue('F' . $fila, $item->precio4);
            $sheet->getStyle('A' . $fila . ':F' . $fila)->applyFromArray([
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
            ]);
            $fila++;
        }

        $sheet->getColumnDimension('A')->setWidth(15);
        $sheet->getColumnDimension('B')->setWidth(17);
        $sheet->getColumnDimension('C')->setWidth(25);
        $sheet->getColumnDimension('D')->setWidth(15);
        $sheet->getColumnDimension('E')->setWidth(15);
        $sheet->getColumnDimension('F')->setWidth(15);

        foreach (range('A', 'F') as $columnID) {
            $sheet->getStyle($columnID)->getAlignment()->setWrapText(true);
        }


        // Mantener visibles los encabezados al desplazarse.
        $sheet->freezePane('A2');
        // Mostrar las flechas de filtro en los encabezados.
        $sheet->setAutoFilter("A1:F1");

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
            'producto_precios_' . time() . '.xlsx',
            [
                'Content-Type' => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
            ]
        );
    }

    public function cargarPrecioProductos(Request $request)
    {
        $request->validate([
            "archivo" => [
                "required",
                "file",
                "mimes:xlsx,xls",
                "max:8192",
            ],
        ], [
            "archivo.required" => "Debe seleccionar un archivo.",
            "archivo.file" => "El archivo seleccionado no es válido.",
            "archivo.mimes" => "El archivo debe ser de tipo Excel (.xlsx o .xls).",
            "archivo.max" => "El archivo no debe superar los 8 MB.",
        ]);
        DB::beginTransaction();
        try {
            // crear el Producto
            $datos["archivo"] = $request->file("archivo");
            $this->productoService->cargarPrecioProductos($datos);
            DB::commit();

            if (isset($request->redirect_ruta)) {
                return redirect()->route($request->redirect_ruta)->with("bien", "Registro realizado");
            }

            return redirect()->route("productos.index")->with("bien", "Registro realizado");
        } catch (\Exception $e) {
            DB::rollBack();
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }
}
