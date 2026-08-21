<?php

namespace App\Http\Controllers;

use App\Http\Requests\CategoriaStoreRequest;
use App\Http\Requests\CategoriaUpdateRequest;
use App\Models\Categoria;
use App\Models\User;
use App\Services\CategoriaService;
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

class CategoriaController extends Controller
{
    public function __construct(private CategoriaService $categoriaService) {}

    /**
     * Página index
     *
     * @return Response
     */
    public function index(): ResponseInertia
    {
        return Inertia::render("Admin/Categorias/Index");
    }

    /**
     * Listado de categorias sin ids: 1 y 2
     *
     * @return JsonResponse
     */
    public function listado(): JsonResponse
    {
        return response()->JSON([
            "categorias" => $this->categoriaService->listado()
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

        $categorias = $this->categoriaService->listadoPaginado($perPage, $page, $search, $columnsSerachLike, $columnsFilter, $columnsBetweenFilter, $arrayOrderBy);
        return response()->JSON([
            "data" => $categorias->items(),
            "total" => $categorias->total(),
            "lastPage" => $categorias->lastPage()
        ]);
    }

    /**
     * Registrar un nuevo categoria
     *
     * @param CategoriaStoreRequest $request
     * @return RedirectResponse|Response
     */
    public function store(CategoriaStoreRequest $request): RedirectResponse|Response
    {
        DB::beginTransaction();
        try {
            // crear el Categoria
            $this->categoriaService->crear($request->validated());
            DB::commit();
            return redirect()->route("categorias.index")->with("bien", "Registro realizado");
        } catch (\Exception $e) {
            DB::rollBack();
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    /**
     * Mostrar un categoria
     *
     * @param Categoria $categoria
     * @return JsonResponse
     */
    public function show(Categoria $categoria): JsonResponse
    {
        return response()->JSON($categoria);
    }

    public function update(Categoria $categoria, CategoriaUpdateRequest $request)
    {
        DB::beginTransaction();
        try {
            // actualizar categoria
            $this->categoriaService->actualizar($request->validated(), $categoria);
            DB::commit();
            return redirect()->route("categorias.index")->with("bien", "Registro actualizado");
        } catch (\Exception $e) {
            DB::rollBack();
            // Log::debug($e->getMessage());
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    /**
     * Eliminar categoria
     *
     * @param Categoria $categoria
     * @return JsonResponse|Response
     */
    public function destroy(Categoria $categoria): JsonResponse|Response
    {
        DB::beginTransaction();
        try {
            $this->categoriaService->eliminar($categoria);
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
