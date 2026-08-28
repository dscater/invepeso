<?php

namespace App\Http\Controllers;

use App\Http\Requests\AlmacenStoreRequest;
use App\Http\Requests\AlmacenUpdateRequest;
use App\Models\Almacen;
use App\Models\User;
use App\Services\AlmacenService;
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

class AlmacenController extends Controller
{
    public function __construct(private AlmacenService $almacenService) {}

    /**
     * Página index
     *
     * @return Response
     */
    public function index(): ResponseInertia
    {
        return Inertia::render("Admin/Almacens/Index");
    }

    /**
     * Listado de almacens sin ids: 1 y 2
     *
     * @return JsonResponse
     */
    public function listado(): JsonResponse
    {
        return response()->JSON([
            "almacens" => $this->almacenService->listado()
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

        $almacens = $this->almacenService->listadoPaginado($perPage, $page, $search, $columnsSerachLike, $columnsFilter, $columnsBetweenFilter, $arrayOrderBy);
        return response()->JSON([
            "data" => $almacens->items(),
            "total" => $almacens->total(),
            "lastPage" => $almacens->lastPage()
        ]);
    }

    /**
     * Registrar un nuevo almacen
     *
     * @param AlmacenStoreRequest $request
     * @return RedirectResponse|Response
     */
    public function store(AlmacenStoreRequest $request): RedirectResponse|Response
    {
        DB::beginTransaction();
        try {
            // crear el Almacen
            $this->almacenService->crear($request->validated());
            DB::commit();
            return redirect()->route("almacens.index")->with("bien", "Registro realizado");
        } catch (\Exception $e) {
            DB::rollBack();
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    /**
     * Mostrar un almacen
     *
     * @param Almacen $almacen
     * @return JsonResponse
     */
    public function show(Almacen $almacen): JsonResponse
    {
        return response()->JSON($almacen);
    }

    public function update(Almacen $almacen, AlmacenUpdateRequest $request)
    {
        DB::beginTransaction();
        try {
            // actualizar almacen
            $this->almacenService->actualizar($request->validated(), $almacen);
            DB::commit();
            return redirect()->route("almacens.index")->with("bien", "Registro actualizado");
        } catch (\Exception $e) {
            DB::rollBack();
            // Log::debug($e->getMessage());
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    /**
     * Eliminar almacen
     *
     * @param Almacen $almacen
     * @return JsonResponse|Response
     */
    public function destroy(Almacen $almacen): JsonResponse|Response
    {
        DB::beginTransaction();
        try {
            $this->almacenService->eliminar($almacen);
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
