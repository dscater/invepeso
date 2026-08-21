<?php

namespace App\Http\Controllers;

use App\Http\Requests\ProductoSucursalStoreRequest;
use App\Http\Requests\ProductoSucursalUpdateRequest;
use App\Models\ProductoSucursal;
use App\Models\User;
use App\Services\ProductoSucursalService;
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

class ProductoSucursalController extends Controller
{
    public function __construct(private ProductoSucursalService $producto_sucursalService) {}

    /**
     * Página index
     *
     * @return Response
     */
    public function index(): ResponseInertia
    {
        return Inertia::render("Admin/ProductoSucursals/Index");
    }

    /**
     * Listado de producto_sucursals sin ids: 1 y 2
     *
     * @return JsonResponse
     */
    public function listado(Request $request): JsonResponse
    {
        return response()->JSON([
            "producto_sucursals" => $this->producto_sucursalService->listado(
                $request->input("sucursal_id", ""),
                $request->input("categoria_id", ""),
                $request->input("marca_id", ""),
                $request->input("nombreProducto", "")
            )
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

        $producto_sucursals = $this->producto_sucursalService->listadoPaginado($perPage, $page, $search, $columnsSerachLike, $columnsFilter, $columnsBetweenFilter, $arrayOrderBy);
        return response()->JSON([
            "data" => $producto_sucursals->items(),
            "total" => $producto_sucursals->total(),
            "lastPage" => $producto_sucursals->lastPage()
        ]);
    }

    /**
     * Registrar un nuevo producto_sucursal
     *
     * @param ProductoSucursalStoreRequest $request
     * @return RedirectResponse|Response
     */
    public function store(ProductoSucursalStoreRequest $request): RedirectResponse|Response
    {
        DB::beginTransaction();
        try {
            // crear el ProductoSucursal
            $this->producto_sucursalService->crear($request->validated());
            DB::commit();
            return redirect()->route("producto_sucursals.index")->with("bien", "Registro realizado");
        } catch (\Exception $e) {
            DB::rollBack();
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    /**
     * Mostrar un producto_sucursal
     *
     * @param ProductoSucursal $producto_sucursal
     * @return JsonResponse
     */
    public function show(ProductoSucursal $producto_sucursal): JsonResponse
    {
        return response()->JSON($producto_sucursal);
    }

    public function update(ProductoSucursal $producto_sucursal, ProductoSucursalUpdateRequest $request)
    {
        DB::beginTransaction();
        try {
            // actualizar producto_sucursal
            $this->producto_sucursalService->actualizar($request->validated(), $producto_sucursal);
            DB::commit();
            return redirect()->route("producto_sucursals.index")->with("bien", "Registro actualizado");
        } catch (\Exception $e) {
            DB::rollBack();
            // Log::debug($e->getMessage());
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    /**
     * Eliminar producto_sucursal
     *
     * @param ProductoSucursal $producto_sucursal
     * @return JsonResponse|Response
     */
    public function destroy(ProductoSucursal $producto_sucursal): JsonResponse|Response
    {
        DB::beginTransaction();
        try {
            $this->producto_sucursalService->eliminar($producto_sucursal);
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
