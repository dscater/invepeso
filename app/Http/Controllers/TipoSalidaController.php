<?php

namespace App\Http\Controllers;

use App\Http\Requests\TipoSalidaStoreRequest;
use App\Http\Requests\TipoSalidaUpdateRequest;
use App\Models\TipoSalida;
use App\Models\User;
use App\Services\TipoSalidaService;
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

class TipoSalidaController extends Controller
{
    public function __construct(private TipoSalidaService $tipo_salidaService) {}

    /**
     * Página index
     *
     * @return Response
     */
    public function index(): ResponseInertia
    {
        return Inertia::render("Admin/TipoSalidas/Index");
    }

    /**
     * Listado de tipo_salidas sin ids: 1 y 2
     *
     * @return JsonResponse
     */
    public function listado(): JsonResponse
    {
        return response()->JSON([
            "tipo_salidas" => $this->tipo_salidaService->listado()
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

        $tipo_salidas = $this->tipo_salidaService->listadoPaginado($perPage, $page, $search, $columnsSerachLike, $columnsFilter, $columnsBetweenFilter, $arrayOrderBy);
        return response()->JSON([
            "data" => $tipo_salidas->items(),
            "total" => $tipo_salidas->total(),
            "lastPage" => $tipo_salidas->lastPage()
        ]);
    }

    /**
     * Registrar un nuevo tipo_salida
     *
     * @param TipoSalidaStoreRequest $request
     * @return RedirectResponse|Response
     */
    public function store(TipoSalidaStoreRequest $request): RedirectResponse|Response
    {
        DB::beginTransaction();
        try {
            // crear el TipoSalida
            $this->tipo_salidaService->crear($request->validated());
            DB::commit();
            return redirect()->route("tipo_salidas.index")->with("bien", "Registro realizado");
        } catch (\Exception $e) {
            DB::rollBack();
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    /**
     * Mostrar un tipo_salida
     *
     * @param TipoSalida $tipo_salida
     * @return JsonResponse
     */
    public function show(TipoSalida $tipo_salida): JsonResponse
    {
        return response()->JSON($tipo_salida);
    }

    public function update(TipoSalida $tipo_salida, TipoSalidaUpdateRequest $request)
    {
        DB::beginTransaction();
        try {
            // actualizar tipo_salida
            $this->tipo_salidaService->actualizar($request->validated(), $tipo_salida);
            DB::commit();
            return redirect()->route("tipo_salidas.index")->with("bien", "Registro actualizado");
        } catch (\Exception $e) {
            DB::rollBack();
            // Log::debug($e->getMessage());
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    /**
     * Eliminar tipo_salida
     *
     * @param TipoSalida $tipo_salida
     * @return JsonResponse|Response
     */
    public function destroy(TipoSalida $tipo_salida): JsonResponse|Response
    {
        DB::beginTransaction();
        try {
            $this->tipo_salidaService->eliminar($tipo_salida);
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
