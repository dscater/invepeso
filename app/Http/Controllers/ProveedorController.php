<?php

namespace App\Http\Controllers;

use App\Http\Requests\ProveedorStoreRequest;
use App\Http\Requests\ProveedorUpdateRequest;
use App\Models\Proveedor;
use App\Models\User;
use App\Services\ProveedorService;
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

class ProveedorController extends Controller
{
    public function __construct(private ProveedorService $proveedorService) {}

    /**
     * Página index
     *
     * @return Response
     */
    public function index(): ResponseInertia
    {
        return Inertia::render("Admin/Proveedors/Index");
    }

    /**
     * Listado de proveedors sin ids: 1 y 2
     *
     * @return JsonResponse
     */
    public function listado(): JsonResponse
    {
        return response()->JSON([
            "proveedors" => $this->proveedorService->listado()
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

        $proveedors = $this->proveedorService->listadoPaginado($perPage, $page, $search, $columnsSerachLike, $columnsFilter, $columnsBetweenFilter, $arrayOrderBy);
        return response()->JSON([
            "data" => $proveedors->items(),
            "total" => $proveedors->total(),
            "lastPage" => $proveedors->lastPage()
        ]);
    }

    /**
     * Registrar un nuevo proveedor
     *
     * @param ProveedorStoreRequest $request
     * @return RedirectResponse|Response
     */
    public function store(ProveedorStoreRequest $request): RedirectResponse|Response
    {
        DB::beginTransaction();
        try {
            // crear el Proveedor
            $this->proveedorService->crear($request->validated());
            DB::commit();
            return redirect()->route("proveedors.index")->with("bien", "Registro realizado");
        } catch (\Exception $e) {
            DB::rollBack();
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    /**
     * Mostrar un proveedor
     *
     * @param Proveedor $proveedor
     * @return JsonResponse
     */
    public function show(Proveedor $proveedor): JsonResponse
    {
        return response()->JSON($proveedor);
    }

    public function update(Proveedor $proveedor, ProveedorUpdateRequest $request)
    {
        DB::beginTransaction();
        try {
            // actualizar proveedor
            $this->proveedorService->actualizar($request->validated(), $proveedor);
            DB::commit();
            return redirect()->route("proveedors.index")->with("bien", "Registro actualizado");
        } catch (\Exception $e) {
            DB::rollBack();
            // Log::debug($e->getMessage());
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    /**
     * Eliminar proveedor
     *
     * @param Proveedor $proveedor
     * @return JsonResponse|Response
     */
    public function destroy(Proveedor $proveedor): JsonResponse|Response
    {
        DB::beginTransaction();
        try {
            $this->proveedorService->eliminar($proveedor);
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
