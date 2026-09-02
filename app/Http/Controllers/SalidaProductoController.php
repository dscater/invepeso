<?php

namespace App\Http\Controllers;

use App\Http\Requests\SalidaProductoStoreRequest;
use App\Http\Requests\SalidaProductoUpdateRequest;
use App\Models\SalidaProducto;
use App\Models\User;
use App\Services\SalidaProductoService;
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

class SalidaProductoController extends Controller
{
    public function __construct(private SalidaProductoService $salida_productoService) {}

    /**
     * Página index
     *
     * @return Response
     */
    public function index(): ResponseInertia
    {
        return Inertia::render("Admin/SalidaProductos/Index");
    }

    /**
     * Listado de salida_productos sin ids: 1 y 2
     *
     * @return JsonResponse
     */
    public function listado(): JsonResponse
    {
        return response()->JSON([
            "salida_productos" => $this->salida_productoService->listado()
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

        $salida_productos = $this->salida_productoService->listadoPaginado($perPage, $page, $search, $columnsSerachLike, $columnsFilter, $columnsBetweenFilter, $arrayOrderBy);
        return response()->JSON([
            "data" => $salida_productos->items(),
            "total" => $salida_productos->total(),
            "lastPage" => $salida_productos->lastPage()
        ]);
    }

    public function create(): ResponseInertia
    {
        return Inertia::render("Admin/SalidaProductos/Create");
    }

    /**
     * Registrar un nuevo salida_producto
     *
     * @param SalidaProductoStoreRequest $request
     * @return RedirectResponse|Response
     */
    public function store(SalidaProductoStoreRequest $request): RedirectResponse|Response
    {
        DB::beginTransaction();
        try {
            // crear el SalidaProducto
            $this->salida_productoService->crear($request->validated());
            DB::commit();
            return redirect()->route("salida_productos.index")->with("bien", "Registro realizado");
        } catch (\Exception $e) {
            DB::rollBack();
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    /**
     * Mostrar un salida_producto
     *
     * @param SalidaProducto $salida_producto
     * @return JsonResponse
     */
    public function show(SalidaProducto $salida_producto): JsonResponse
    {
        return response()->JSON($salida_producto);
    }

    public function edit(SalidaProducto $salida_producto): ResponseInertia
    {
        $salida_producto = $salida_producto->load(["salida_detalles.producto", "salida_detalles.tipo_salida"]);
        return Inertia::render("Admin/SalidaProductos/Edit", compact("salida_producto"));
    }

    public function update(SalidaProducto $salida_producto, SalidaProductoUpdateRequest $request)
    {
        DB::beginTransaction();
        try {
            // actualizar salida_producto
            $this->salida_productoService->actualizar($request->validated(), $salida_producto);
            DB::commit();
            return redirect()->route("salida_productos.index")->with("bien", "Registro actualizado");
        } catch (\Exception $e) {
            DB::rollBack();
            // Log::debug($e->getMessage());
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    /**
     * Eliminar salida_producto
     *
     * @param SalidaProducto $salida_producto
     * @return JsonResponse|Response
     */
    public function destroy(SalidaProducto $salida_producto): JsonResponse|Response
    {
        DB::beginTransaction();
        try {
            $this->salida_productoService->eliminar($salida_producto);
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
