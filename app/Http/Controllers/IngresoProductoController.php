<?php

namespace App\Http\Controllers;

use App\Http\Requests\IngresoPagoStoreRequest;
use App\Http\Requests\IngresoProductoFaltantesRequest;
use App\Http\Requests\IngresoProductoStoreRequest;
use App\Http\Requests\IngresoProductoUpdateRequest;
use App\Http\Requests\IngresoProductoVerificarRequest;
use App\Models\Almacen;
use App\Models\IngresoPago;
use App\Models\IngresoProducto;
use App\Models\User;
use App\Services\IngresoPagoService;
use App\Services\IngresoProductoService;
use Exception;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Response;
use Illuminate\Validation\ValidationException;
use PDF;
use Inertia\Inertia;
use Inertia\Response as ResponseInertia;

class IngresoProductoController extends Controller
{
    public function __construct(
        private IngresoProductoService $ingreso_productoService,
        private IngresoPagoService $ingreso_pago_service
    ) {}

    /**
     * Página index
     *
     * @return Response
     */
    public function index(): ResponseInertia
    {
        return Inertia::render("Admin/IngresoProductos/Index");
    }

    public function pagos(): ResponseInertia
    {
        return Inertia::render("Admin/IngresoProductos/Pagos");
    }

    public function lista_pagos_pendientes(Request $request): JsonResponse
    {
        $almacen_id = $request->input("almacen_id", null);
        $fecha_ini = $request->input("fecha_ini", null);
        $fecha_fin = $request->input("fecha_fin", null);
        $ingreso_productos = IngresoProducto::with([
            "sucursal:id,nombre",
            "almacen:id,nombre",
            "proveedor:id,nombre",
            "tipo_ingreso:id,nombre",
            "user:id,nombre,paterno,materno",
            "ingreso_detalles",
            "ingreso_pagos.user",
            "ingreso_pagos.sucursal",
            "ingreso_pagos.almacen",
        ]);

        $ingreso_productos->where("saldo", ">", 0);
        $ingreso_productos->where("tipo_compra", "CRÉDITO");

        if ($almacen_id && $almacen_id != 'todos') {
            $ingreso_productos->where("almacen_id", $almacen_id);
        }

        if ($fecha_ini && $fecha_fin) {
            $ingreso_productos->whereBetween("fecha_registro", [$fecha_ini, $fecha_fin]);
        }
        $ingreso_productos = $ingreso_productos->get();

        return response()->JSON([
            "ingreso_productos" => $ingreso_productos
        ]);
    }

    public function registrar_pago(IngresoPagoStoreRequest $request, IngresoProducto $ingreso_producto)
    {
        DB::beginTransaction();
        try {
            // crear el IngresoProducto
            $datos = $request->validated();
            $almacen = Almacen::findOrFail($datos["almacen_id"]);
            $datos["ingreso_producto_id"] = $ingreso_producto->id;
            $datos["sucursal_id"] = $almacen->sucursal_id;
            $datos["proveedor_id"] = $ingreso_producto->proveedor_id;
            $this->ingreso_pago_service->crear($datos);
            DB::commit();

            return response()->JSON([
                "sw" => true,
                "message" => "Registro realizado"
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    public function actualizar_pago(IngresoPagoStoreRequest $request, IngresoPago $ingreso_pago)
    {
        DB::beginTransaction();
        try {
            // crear el IngresoProducto
            $datos = $request->validated();
            $almacen = Almacen::findOrFail($datos["almacen_id"]);
            $datos["ingreso_producto_id"] = $ingreso_pago->ingreso_producto_id;
            $datos["sucursal_id"] = $almacen->sucursal_id;
            $datos["proveedor_id"] = $ingreso_pago->proveedor_id;
            $ingreso_pago = $this->ingreso_pago_service->actualizar($datos, $ingreso_pago);
            DB::commit();

            return response()->JSON([
                "sw" => true,
                "message" => "Registro realizado",
                "ingreso_pago" => $ingreso_pago,
                "ingreso_producto" => $ingreso_pago->ingreso_producto,
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    public function eliminar_pago(IngresoPago $ingreso_pago): JsonResponse|Response
    {
        DB::beginTransaction();
        try {
            $ingreso_producto = $ingreso_pago->ingreso_producto;
            $this->ingreso_pago_service->eliminar($ingreso_pago);
            DB::commit();
            return response()->JSON([
                'sw' => true,
                'message' => 'El registro se eliminó correctamente',
                "ingreso_producto" => $ingreso_producto,
            ], 200);
        } catch (\Exception $e) {
            DB::rollBack();
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    /**
     * Listado de ingreso_productos sin ids: 1 y 2
     *
     * @return JsonResponse
     */
    public function listado(): JsonResponse
    {
        return response()->JSON([
            "ingreso_productos" => $this->ingreso_productoService->listado()
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

        $ingreso_productos = $this->ingreso_productoService->listadoPaginado($perPage, $page, $search, $columnsSerachLike, $columnsFilter, $columnsBetweenFilter, $arrayOrderBy);
        return response()->JSON([
            "data" => $ingreso_productos->items(),
            "total" => $ingreso_productos->total(),
            "lastPage" => $ingreso_productos->lastPage()
        ]);
    }

    public function create(): ResponseInertia
    {
        return Inertia::render("Admin/IngresoProductos/Create");
    }

    /**
     * Registrar un nuevo ingreso_producto
     *
     * @param IngresoProductoStoreRequest $request
     * @return RedirectResponse|Response
     */
    public function store(IngresoProductoStoreRequest $request): RedirectResponse|Response
    {
        DB::beginTransaction();
        try {
            // crear el IngresoProducto
            $ingreso_producto = $this->ingreso_productoService->crear($request->validated());
            DB::commit();

            return redirect()->route("ingreso_productos.create")
                ->with("bien", "Registro realizado")
                ->with("url_blank", route('ingreso_productos.pdf', $ingreso_producto->id));
        } catch (\Exception $e) {
            DB::rollBack();
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }
    public function lista_sin_verificar(Request $request)
    {
        $fecha_ini = $request->input("fecha_ini", null);
        $fecha_fin = $request->input("fecha_fin", null);
        $almacen_id = $request->input("almacen_id", null);

        $ingreso_productos = IngresoProducto::with(["sucursal", "almacen", "tipo_ingreso", "proveedor", "ingreso_detalles.producto"])
            ->where("estado_ingreso", "PENDIENTE");

        if ($almacen_id && $almacen_id != 'todos') {
            $ingreso_productos->where("almacen_id", $almacen_id);
        }

        if ($fecha_ini && $fecha_fin) {
            $ingreso_productos->whereBetween("fecha_registro", [$fecha_ini, $fecha_fin]);
        }

        $ingreso_productos = $ingreso_productos->get();
        return response()->JSON($ingreso_productos);
    }


    public function lista_faltantes(Request $request)
    {
        $fecha_ini = $request->input("fecha_ini", null);
        $fecha_fin = $request->input("fecha_fin", null);
        $almacen_id = $request->input("almacen_id", null);

        $ingreso_productos = IngresoProducto::with(["sucursal", "almacen", "tipo_ingreso", "proveedor", "ingreso_detalles.producto"])
            ->where("estado_faltantes", "PENDIENTE");

        if ($almacen_id && $almacen_id != 'todos') {
            $ingreso_productos->where("almacen_id", $almacen_id);
        }

        if ($fecha_ini && $fecha_fin) {
            $ingreso_productos->whereBetween("fecha_registro", [$fecha_ini, $fecha_fin]);
        }

        $ingreso_productos = $ingreso_productos->get();
        return response()->JSON($ingreso_productos);
    }

    public function verificacion_ingresos()
    {
        return Inertia::render("Admin/IngresoProductos/VerificacionIngresos");
    }


    public function verificar(IngresoProductoVerificarRequest $request, IngresoProducto $ingreso_producto)
    {
        DB::beginTransaction();
        try {
            // actualizar ingreso_producto
            $this->ingreso_productoService->verificar($request->validated(), $ingreso_producto);
            DB::commit();
            return redirect()->route("ingreso_productos.verificacion_ingresos")
                ->with("bien", "Registro actualizado")->with("url_blank", route('ingreso_productos.verificar_pdf', $ingreso_producto->id));
        } catch (\Exception $e) {
            DB::rollBack();
            // Log::debug($e->getMessage());
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }
    public function faltantes_ingresos()
    {
        return Inertia::render("Admin/IngresoProductos/FaltantesIngresos");
    }

    public function faltante(IngresoProductoFaltantesRequest $request, IngresoProducto $ingreso_producto)
    {
        DB::beginTransaction();
        try {
            // actualizar ingreso_producto
            $this->ingreso_productoService->faltante($request->validated(), $ingreso_producto);
            DB::commit();
            return redirect()->route("ingreso_productos.faltantes_ingresos")->with("bien", "Registro actualizado");
        } catch (\Exception $e) {
            DB::rollBack();
            // Log::debug($e->getMessage());
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    /**
     * Mostrar un ingreso_producto
     *
     * @param IngresoProducto $ingreso_producto
     * @return JsonResponse
     */
    public function show(IngresoProducto $ingreso_producto): JsonResponse
    {
        return response()->JSON($ingreso_producto);
    }

    public function pdf(IngresoProducto $ingreso_producto)
    {
        $pdf = PDF::loadView('reportes.ingreso_producto', compact('ingreso_producto'))->setPaper('letter', 'portrait');
        // ENUMERAR LAS PÁGINAS USANDO CANVAS
        $pdf->output();
        $dom_pdf = $pdf->getDomPDF();
        $canvas = $dom_pdf->get_canvas();
        $alto = $canvas->get_height();
        $ancho = $canvas->get_width();
        $canvas->page_text($ancho - 90, $alto - 25, "Página {PAGE_NUM} de {PAGE_COUNT}", null, 9, array(0, 0, 0));
        return $pdf->stream('orden_compra' . $ingreso_producto->codigo . '.pdf');
    }

    public function verificar_pdf(IngresoProducto $ingreso_producto)
    {
        $pdf = PDF::loadView('reportes.ingreso_producto_verificar', compact('ingreso_producto'))->setPaper('letter', 'portrait');
        // ENUMERAR LAS PÁGINAS USANDO CANVAS
        $pdf->output();
        $dom_pdf = $pdf->getDomPDF();
        $canvas = $dom_pdf->get_canvas();
        $alto = $canvas->get_height();
        $ancho = $canvas->get_width();
        $canvas->page_text($ancho - 90, $alto - 25, "Página {PAGE_NUM} de {PAGE_COUNT}", null, 9, array(0, 0, 0));
        return $pdf->stream('orden_compra_verificacion_' . $ingreso_producto->codigo . '.pdf');
    }

    public function edit(IngresoProducto $ingreso_producto): ResponseInertia
    {
        $ingreso_producto = $ingreso_producto->load(["ingreso_detalles.producto", "ingreso_detalles.tipo_ingreso"]);
        return Inertia::render("Admin/IngresoProductos/Edit", compact("ingreso_producto"));
    }

    public function update(IngresoProducto $ingreso_producto, IngresoProductoUpdateRequest $request)
    {
        DB::beginTransaction();
        try {
            // actualizar ingreso_producto
            $this->ingreso_productoService->actualizar($request->validated(), $ingreso_producto);
            DB::commit();
            return redirect()->route("ingreso_productos.index")
                ->with("bien", "Registro actualizado")
                ->with("url_blank", route('ingreso_productos.pdf', $ingreso_producto->id));;
        } catch (\Exception $e) {
            DB::rollBack();
            // Log::debug($e->getMessage());
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    /**
     * Eliminar ingreso_producto
     *
     * @param IngresoProducto $ingreso_producto
     * @return JsonResponse|Response
     */
    public function destroy(IngresoProducto $ingreso_producto): JsonResponse|Response
    {
        DB::beginTransaction();
        try {
            $this->ingreso_productoService->eliminar($ingreso_producto);
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
}
