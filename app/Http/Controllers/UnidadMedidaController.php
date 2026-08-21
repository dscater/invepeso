<?php

namespace App\Http\Controllers;

use App\Http\Requests\UnidadMedidaStoreRequest;
use App\Http\Requests\UnidadMedidaUpdateRequest;
use App\Models\UnidadMedida;
use App\Models\User;
use App\Services\UnidadMedidaService;
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

class UnidadMedidaController extends Controller
{
    public function __construct(private UnidadMedidaService $unidad_medidaService) {}

    /**
     * Página index
     *
     * @return Response
     */
    public function index(): ResponseInertia
    {
        return Inertia::render("Admin/UnidadMedidas/Index");
    }

    /**
     * Listado de unidad_medidas sin ids: 1 y 2
     *
     * @return JsonResponse
     */
    public function listado(): JsonResponse
    {
        return response()->JSON([
            "unidad_medidas" => $this->unidad_medidaService->listado()
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

        $unidad_medidas = $this->unidad_medidaService->listadoPaginado($perPage, $page, $search, $columnsSerachLike, $columnsFilter, $columnsBetweenFilter, $arrayOrderBy);
        return response()->JSON([
            "data" => $unidad_medidas->items(),
            "total" => $unidad_medidas->total(),
            "lastPage" => $unidad_medidas->lastPage()
        ]);
    }

    /**
     * Registrar un nuevo unidad_medida
     *
     * @param UnidadMedidaStoreRequest $request
     * @return RedirectResponse|Response
     */
    public function store(UnidadMedidaStoreRequest $request): RedirectResponse|Response
    {
        DB::beginTransaction();
        try {
            // crear el UnidadMedida
            $this->unidad_medidaService->crear($request->validated());
            DB::commit();
            return redirect()->route("unidad_medidas.index")->with("bien", "Registro realizado");
        } catch (\Exception $e) {
            DB::rollBack();
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    /**
     * Mostrar un unidad_medida
     *
     * @param UnidadMedida $unidad_medida
     * @return JsonResponse
     */
    public function show(UnidadMedida $unidad_medida): JsonResponse
    {
        return response()->JSON($unidad_medida);
    }

    public function update(UnidadMedida $unidad_medida, UnidadMedidaUpdateRequest $request)
    {
        DB::beginTransaction();
        try {
            // actualizar unidad_medida
            $this->unidad_medidaService->actualizar($request->validated(), $unidad_medida);
            DB::commit();
            return redirect()->route("unidad_medidas.index")->with("bien", "Registro actualizado");
        } catch (\Exception $e) {
            DB::rollBack();
            // Log::debug($e->getMessage());
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    /**
     * Eliminar unidad_medida
     *
     * @param UnidadMedida $unidad_medida
     * @return JsonResponse|Response
     */
    public function destroy(UnidadMedida $unidad_medida): JsonResponse|Response
    {
        DB::beginTransaction();
        try {
            $this->unidad_medidaService->eliminar($unidad_medida);
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
