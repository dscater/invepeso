<?php

namespace App\Http\Controllers;

use App\Http\Requests\VentaCobroStoreRequest;
use App\Http\Requests\VentaStoreRequest;
use App\Http\Requests\VentaUpdateRequest;
use App\Models\Almacen;
use App\Models\Venta;
use App\Models\User;
use App\Models\VentaCobro;
use App\Services\VentaCobroService;
use App\Services\VentaService;
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

class VentaController extends Controller
{
    public function __construct(
        private VentaService $ventaService,
        private VentaCobroService $venta_cobro_service
    ) {}

    /**
     * Página index
     *
     * @return Response
     */
    public function index(): ResponseInertia
    {
        return Inertia::render("Admin/Ventas/Index");
    }

    public function eliminados(): ResponseInertia
    {
        return Inertia::render("Admin/Ventas/Eliminados");
    }

    public function cobros(): ResponseInertia
    {
        return Inertia::render("Admin/Ventas/Cobros");
    }

    public function lista_cobros_pendientes(Request $request): JsonResponse
    {
        $almacen_id = $request->input("almacen_id", null);
        $fecha_ini = $request->input("fecha_ini", null);
        $fecha_fin = $request->input("fecha_fin", null);
        $ventas = Venta::with([
            "sucursal:id,nombre",
            "almacen:id,nombre",
            "cliente:id,nombre",
            "tipo_documento:id,nombre",
            "user:id,nombre,paterno,materno",
            "venta_detalles",
            "venta_cobros.user",
            "venta_cobros.sucursal",
            "venta_cobros.almacen",
        ]);

        $ventas->where("saldo", ">", 0);
        $ventas->where("tipo_venta", "CRÉDITO");

        if ($almacen_id && $almacen_id != 'todos') {
            $ventas->where("almacen_id", $almacen_id);
        }

        if ($fecha_ini && $fecha_fin) {
            $ventas->whereBetween("fecha_registro", [$fecha_ini, $fecha_fin]);
        }
        $ventas = $ventas->get();

        return response()->JSON([
            "ventas" => $ventas
        ]);
    }

    public function registrar_cobro(VentaCobroStoreRequest $request, Venta $venta)
    {
        DB::beginTransaction();
        try {
            // crear el Venta
            $datos = $request->validated();
            $almacen = Almacen::findOrFail($datos["almacen_id"]);
            $datos["venta_id"] = $venta->id;
            $datos["sucursal_id"] = $almacen->sucursal_id;
            $datos["cliente_id"] = $venta->cliente_id;
            $venta_cobro = $this->venta_cobro_service->crear($datos);
            DB::commit();

            return response()->JSON([
                "sw" => true,
                "message" => "Registro realizado",
                "url_blank" => route('ventas.pdf_cobros', $venta_cobro->venta_id)
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    public function actualizar_cobro(VentaCobroStoreRequest $request, VentaCobro $venta_cobro)
    {
        DB::beginTransaction();
        try {
            // crear el Venta
            $datos = $request->validated();
            $almacen = Almacen::findOrFail($datos["almacen_id"]);
            $datos["venta_id"] = $venta_cobro->venta_id;
            $datos["sucursal_id"] = $almacen->sucursal_id;
            $datos["cliente_id"] = $venta_cobro->cliente_id;
            $venta_cobro = $this->venta_cobro_service->actualizar($datos, $venta_cobro);
            DB::commit();

            return response()->JSON([
                "sw" => true,
                "message" => "Registro realizado",
                "venta_cobro" => $venta_cobro,
                "venta" => $venta_cobro->venta,
                "url_blank" => route('ventas.pdf_cobros', $venta_cobro->venta_id)
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    public function pdf_cobros(Venta $venta)
    {
        $pdf = PDF::loadView('reportes.venta_cobros', compact('venta'))->setPaper('letter', 'portrait');
        // ENUMERAR LAS PÁGINAS USANDO CANVAS
        $pdf->output();
        $dom_pdf = $pdf->getDomPDF();
        $canvas = $dom_pdf->get_canvas();
        $alto = $canvas->get_height();
        $ancho = $canvas->get_width();
        $canvas->page_text($ancho - 90, $alto - 25, "Página {PAGE_NUM} de {PAGE_COUNT}", null, 9, array(0, 0, 0));
        return $pdf->stream('venta_' . $venta->codigo_venta . '.pdf');
    }

    public function eliminar_cobro(VentaCobro $venta_cobro): JsonResponse|Response
    {
        DB::beginTransaction();
        try {
            $venta = $venta_cobro->venta;
            $this->venta_cobro_service->eliminar($venta_cobro);
            DB::commit();
            return response()->JSON([
                'sw' => true,
                'message' => 'El registro se eliminó correctamente',
                "venta" => $venta,
                "url_blank" => route('ventas.pdf_cobros', $venta_cobro->venta_id)
            ], 200);
        } catch (\Exception $e) {
            DB::rollBack();
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    /**
     * Listado de ventas sin ids: 1 y 2
     *
     * @return JsonResponse
     */
    public function listado(Request $request): JsonResponse
    {
        return response()->JSON([
            "ventas" => $this->ventaService->listado($request->input("fecha_ini", null), $request->input("fecha_fin", null))
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

        $ventas = $this->ventaService->listadoPaginado($perPage, $page, $search, $columnsSerachLike, $columnsFilter, $columnsBetweenFilter, $arrayOrderBy);
        return response()->JSON([
            "data" => $ventas->items(),
            "total" => $ventas->total(),
            "lastPage" => $ventas->lastPage()
        ]);
    }

    public function paginado_eliminados(Request $request)
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

        $ventas = $this->ventaService->listadoPaginadoEliminados($perPage, $page, $search, $columnsSerachLike, $columnsFilter, $columnsBetweenFilter, $arrayOrderBy);
        return response()->JSON([
            "data" => $ventas->items(),
            "total" => $ventas->total(),
            "lastPage" => $ventas->lastPage()
        ]);
    }

    public function create(): ResponseInertia
    {
        return Inertia::render("Admin/Ventas/Create");
    }

    /**
     * Registrar un nuevo venta
     *
     * @param VentaStoreRequest $request
     * @return RedirectResponse|Response
     */
    public function store(VentaStoreRequest $request): RedirectResponse|Response
    {
        DB::beginTransaction();
        try {
            // crear el Venta
            $venta = $this->ventaService->crear($request->validated());
            DB::commit();
            return redirect()->route("ventas.index")
                ->with("bien", "Registro realizado")
                ->with("url_blank", route('ventas.pdf', $venta->id));
        } catch (\Exception $e) {
            DB::rollBack();
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    /**
     * Mostrar un venta
     *
     * @param Venta $venta
     * @return JsonResponse
     */
    public function show(Venta $venta): JsonResponse
    {
        $venta = $venta->load(["venta_detalles.producto", "cliente", "sucursal:id,nombre", "almacen:id,nombre", "tipo_documento:id,nombre"]);
        return response()->JSON($venta);
    }


    public function pdf(Venta $venta)
    {
        $pdf = PDF::loadView('reportes.venta', compact('venta'))->setPaper('letter', 'portrait');
        // ENUMERAR LAS PÁGINAS USANDO CANVAS
        $pdf->output();
        $dom_pdf = $pdf->getDomPDF();
        $canvas = $dom_pdf->get_canvas();
        $alto = $canvas->get_height();
        $ancho = $canvas->get_width();
        $canvas->page_text($ancho - 90, $alto - 25, "Página {PAGE_NUM} de {PAGE_COUNT}", null, 9, array(0, 0, 0));
        return $pdf->stream('venta_' . $venta->codigo_venta . '.pdf');
    }

    public function pdf_rollo(Venta $venta)
    {
        $venta->load([
            'cliente',
            'tipo_documento',
            'user',
            'venta_detalles.producto',
        ]);

        // 80 mm = 226.771 puntos
        // Dejamos un ancho ligeramente menor para evitar desbordamientos.
        $ancho = 226.77;

        // Altura base del ticket
        $alto_base = 300;
        $cantidad_productos = $venta->venta_detalles->count();
        // Altura aproximada por producto
        $alto_por_producto = 35;

        // Altura adicional
        $alto_extra = 100;
        $alto = $alto_base
            + ($cantidad_productos * $alto_por_producto)
            + $alto_extra;
        // Evitar que sea demasiado pequeño
        $alto = max($alto, 400);

        $pdf = PDF::loadView(
            'reportes.venta_rollo',
            compact('venta')
        );

        $pdf->setPaper([0, 0, $ancho, $alto], 'portrait');

        return $pdf->stream(
            'venta_rollo_' . $venta->codigo_venta . '.pdf'
        );
    }

    public function edit(Venta $venta): ResponseInertia
    {
        $venta = $venta->load(["venta_detalles.producto", "cliente", "sucursal:id,nombre", "almacen:id,nombre", "tipo_documento:id,nombre"]);
        return Inertia::render("Admin/Ventas/Edit", compact("venta"));
    }

    public function update(Venta $venta, VentaUpdateRequest $request)
    {
        DB::beginTransaction();
        try {
            // actualizar venta
            $this->ventaService->actualizar($request->validated(), $venta);
            DB::commit();
            return redirect()->route("ventas.index")
                ->with("bien", "Registro actualizado")
                ->with("url_blank", route('ventas.pdf', $venta->id));
        } catch (\Exception $e) {
            DB::rollBack();
            // Log::debug($e->getMessage());
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    /**
     * Eliminar venta
     *
     * @param Venta $venta
     * @return JsonResponse|Response
     */
    public function destroy(Venta $venta): JsonResponse|Response
    {
        DB::beginTransaction();
        try {
            $this->ventaService->eliminar($venta);
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

    public function restaurar(Venta $venta): JsonResponse|Response
    {
        DB::beginTransaction();
        try {
            $this->ventaService->restaurar($venta);
            DB::commit();
            return response()->JSON([
                'sw' => true,
                'message' => 'El registro se restauró correctamente'
            ], 200);
        } catch (\Exception $e) {
            DB::rollBack();
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    public function eliminar_permanente(Venta $venta): JsonResponse|Response
    {
        DB::beginTransaction();
        try {
            $this->ventaService->eliminar_permanente($venta);
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
