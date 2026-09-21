<?php

namespace App\Http\Controllers;

use App\Http\Requests\IngresoFaltanteStoreRequest;
use App\Http\Requests\IngresoFaltanteUpdateRequest;
use App\Models\IngresoFaltante;
use App\Models\User;
use App\Services\IngresoFaltanteService;
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

class IngresoFaltanteController extends Controller
{
    public function __construct(private IngresoFaltanteService $ingreso_faltanteService) {}

    /**
     * Página index
     *
     * @return Response
     */
    public function index(): ResponseInertia
    {
        return Inertia::render("Admin/IngresoFaltantes/Index");
    }

    /**
     * Listado de ingreso_faltantes sin ids: 1 y 2
     *
     * @return JsonResponse
     */
    public function listado(): JsonResponse
    {
        return response()->JSON([
            "ingreso_faltantes" => $this->ingreso_faltanteService->listado()
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

        $ingreso_faltantes = $this->ingreso_faltanteService->listadoPaginado($perPage, $page, $search, $columnsSerachLike, $columnsFilter, $columnsBetweenFilter, $arrayOrderBy);
        return response()->JSON([
            "data" => $ingreso_faltantes->items(),
            "total" => $ingreso_faltantes->total(),
            "lastPage" => $ingreso_faltantes->lastPage()
        ]);
    }

    /**
     * Registrar un nuevo ingreso_faltante
     *
     * @param IngresoFaltanteStoreRequest $request
     * @return RedirectResponse|Response
     */
    public function store(IngresoFaltanteStoreRequest $request): RedirectResponse|Response
    {
        DB::beginTransaction();
        try {
            // crear el IngresoFaltante
            $this->ingreso_faltanteService->crear($request->validated());
            DB::commit();
            return redirect()->route("ingreso_faltantes.index")->with("bien", "Registro realizado");
        } catch (\Exception $e) {
            DB::rollBack();
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    /**
     * Mostrar un ingreso_faltante
     *
     * @param IngresoFaltante $ingreso_faltante
     * @return JsonResponse
     */
    public function show(IngresoFaltante $ingreso_faltante): JsonResponse
    {
        return response()->JSON($ingreso_faltante);
    }

    public function update(IngresoFaltante $ingreso_faltante, IngresoFaltanteUpdateRequest $request)
    {
        DB::beginTransaction();
        try {
            // actualizar ingreso_faltante
            $this->ingreso_faltanteService->actualizar($request->validated(), $ingreso_faltante);
            DB::commit();
            return redirect()->route("ingreso_faltantes.index")->with("bien", "Registro actualizado");
        } catch (\Exception $e) {
            DB::rollBack();
            // Log::debug($e->getMessage());
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    /**
     * Eliminar ingreso_faltante
     *
     * @param IngresoFaltante $ingreso_faltante
     * @return JsonResponse|Response
     */
    public function destroy(IngresoFaltante $ingreso_faltante): JsonResponse|Response
    {
        DB::beginTransaction();
        try {
            $this->ingreso_faltanteService->eliminar($ingreso_faltante);
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
