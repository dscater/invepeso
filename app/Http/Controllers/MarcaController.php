<?php

namespace App\Http\Controllers;

use App\Http\Requests\MarcaStoreRequest;
use App\Http\Requests\MarcaUpdateRequest;
use App\Models\Marca;
use App\Models\User;
use App\Services\MarcaService;
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

class MarcaController extends Controller
{
    public function __construct(private MarcaService $marcaService) {}

    /**
     * Página index
     *
     * @return Response
     */
    public function index(): ResponseInertia
    {
        return Inertia::render("Admin/Marcas/Index");
    }

    /**
     * Listado de marcas sin ids: 1 y 2
     *
     * @return JsonResponse
     */
    public function listado(): JsonResponse
    {
        return response()->JSON([
            "marcas" => $this->marcaService->listado()
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

        $marcas = $this->marcaService->listadoPaginado($perPage, $page, $search, $columnsSerachLike, $columnsFilter, $columnsBetweenFilter, $arrayOrderBy);
        return response()->JSON([
            "data" => $marcas->items(),
            "total" => $marcas->total(),
            "lastPage" => $marcas->lastPage()
        ]);
    }

    /**
     * Registrar un nuevo marca
     *
     * @param MarcaStoreRequest $request
     * @return RedirectResponse|Response
     */
    public function store(MarcaStoreRequest $request): RedirectResponse|Response
    {
        DB::beginTransaction();
        try {
            // crear el Marca
            $this->marcaService->crear($request->validated());
            DB::commit();
            return redirect()->route("marcas.index")->with("bien", "Registro realizado");
        } catch (\Exception $e) {
            DB::rollBack();
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    /**
     * Mostrar un marca
     *
     * @param Marca $marca
     * @return JsonResponse
     */
    public function show(Marca $marca): JsonResponse
    {
        return response()->JSON($marca);
    }

    public function update(Marca $marca, MarcaUpdateRequest $request)
    {
        DB::beginTransaction();
        try {
            // actualizar marca
            $this->marcaService->actualizar($request->validated(), $marca);
            DB::commit();
            return redirect()->route("marcas.index")->with("bien", "Registro actualizado");
        } catch (\Exception $e) {
            DB::rollBack();
            // Log::debug($e->getMessage());
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    /**
     * Eliminar marca
     *
     * @param Marca $marca
     * @return JsonResponse|Response
     */
    public function destroy(Marca $marca): JsonResponse|Response
    {
        DB::beginTransaction();
        try {
            $this->marcaService->eliminar($marca);
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
