<?php

namespace App\Http\Controllers;

use App\Http\Requests\TipoIngresoStoreRequest;
use App\Http\Requests\TipoIngresoUpdateRequest;
use App\Models\TipoIngreso;
use App\Models\User;
use App\Services\TipoIngresoService;
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

class TipoIngresoController extends Controller
{
    public function __construct(private TipoIngresoService $tipo_ingresoService) {}

    /**
     * Página index
     *
     * @return Response
     */
    public function index(): ResponseInertia
    {
        return Inertia::render("Admin/TipoIngresos/Index");
    }

    /**
     * Listado de tipo_ingresos sin ids: 1 y 2
     *
     * @return JsonResponse
     */
    public function listado(): JsonResponse
    {
        return response()->JSON([
            "tipo_ingresos" => $this->tipo_ingresoService->listado()
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

        $tipo_ingresos = $this->tipo_ingresoService->listadoPaginado($perPage, $page, $search, $columnsSerachLike, $columnsFilter, $columnsBetweenFilter, $arrayOrderBy);
        return response()->JSON([
            "data" => $tipo_ingresos->items(),
            "total" => $tipo_ingresos->total(),
            "lastPage" => $tipo_ingresos->lastPage()
        ]);
    }

    /**
     * Registrar un nuevo tipo_ingreso
     *
     * @param TipoIngresoStoreRequest $request
     * @return RedirectResponse|Response
     */
    public function store(TipoIngresoStoreRequest $request): RedirectResponse|Response
    {
        DB::beginTransaction();
        try {
            // crear el TipoIngreso
            $this->tipo_ingresoService->crear($request->validated());
            DB::commit();
            return redirect()->route("tipo_ingresos.index")->with("bien", "Registro realizado");
        } catch (\Exception $e) {
            DB::rollBack();
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    /**
     * Mostrar un tipo_ingreso
     *
     * @param TipoIngreso $tipo_ingreso
     * @return JsonResponse
     */
    public function show(TipoIngreso $tipo_ingreso): JsonResponse
    {
        return response()->JSON($tipo_ingreso);
    }

    public function update(TipoIngreso $tipo_ingreso, TipoIngresoUpdateRequest $request)
    {
        DB::beginTransaction();
        try {
            // actualizar tipo_ingreso
            $this->tipo_ingresoService->actualizar($request->validated(), $tipo_ingreso);
            DB::commit();
            return redirect()->route("tipo_ingresos.index")->with("bien", "Registro actualizado");
        } catch (\Exception $e) {
            DB::rollBack();
            // Log::debug($e->getMessage());
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    /**
     * Eliminar tipo_ingreso
     *
     * @param TipoIngreso $tipo_ingreso
     * @return JsonResponse|Response
     */
    public function destroy(TipoIngreso $tipo_ingreso): JsonResponse|Response
    {
        DB::beginTransaction();
        try {
            $this->tipo_ingresoService->eliminar($tipo_ingreso);
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
