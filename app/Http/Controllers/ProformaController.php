<?php

namespace App\Http\Controllers;

use App\Http\Requests\ProformaCobroStoreRequest;
use App\Http\Requests\ProformaStoreRequest;
use App\Http\Requests\ProformaUpdateRequest;
use App\Models\Almacen;
use App\Models\Proforma;
use App\Models\User;
use App\Services\ProformaService;
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

class ProformaController extends Controller
{
    public function __construct(
        private ProformaService $proformaService
    ) {}

    /**
     * Página index
     *
     * @return Response
     */
    public function index(): ResponseInertia
    {
        return Inertia::render("Admin/Proformas/Index");
    }

    /**
     * Listado de proformas sin ids: 1 y 2
     *
     * @return JsonResponse
     */
    public function listado(Request $request): JsonResponse
    {
        return response()->JSON([
            "proformas" => $this->proformaService->listado($request->input("fecha_ini", null), $request->input("fecha_fin", null))
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

        $proformas = $this->proformaService->listadoPaginado($perPage, $page, $search, $columnsSerachLike, $columnsFilter, $columnsBetweenFilter, $arrayOrderBy);
        return response()->JSON([
            "data" => $proformas->items(),
            "total" => $proformas->total(),
            "lastPage" => $proformas->lastPage()
        ]);
    }

    public function create(): ResponseInertia
    {
        return Inertia::render("Admin/Proformas/Create");
    }

    /**
     * Registrar un nuevo proforma
     *
     * @param ProformaStoreRequest $request
     * @return RedirectResponse|Response
     */
    public function store(ProformaStoreRequest $request): RedirectResponse|Response
    {
        DB::beginTransaction();
        try {
            // crear el Proforma
            $this->proformaService->crear($request->validated());
            DB::commit();
            return redirect()->route("proformas.index")->with("bien", "Registro realizado");
        } catch (\Exception $e) {
            DB::rollBack();
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    /**
     * Mostrar un proforma
     *
     * @param Proforma $proforma
     * @return JsonResponse
     */
    public function show(Proforma $proforma): JsonResponse
    {
        $proforma = $proforma->load(["proforma_detalles.producto", "cliente", "sucursal:id,nombre", "almacen:id,nombre"]);
        return response()->JSON($proforma);
    }

    public function edit(Proforma $proforma): ResponseInertia
    {
        $proforma = $proforma->load(["proforma_detalles.producto", "cliente", "sucursal:id,nombre", "almacen:id,nombre"]);
        return Inertia::render("Admin/Proformas/Edit", compact("proforma"));
    }

    public function update(Proforma $proforma, ProformaUpdateRequest $request)
    {
        DB::beginTransaction();
        try {
            // actualizar proforma
            $this->proformaService->actualizar($request->validated(), $proforma);
            DB::commit();
            return redirect()->route("proformas.index")->with("bien", "Registro actualizado");
        } catch (\Exception $e) {
            DB::rollBack();
            // Log::debug($e->getMessage());
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    /**
     * Eliminar proforma
     *
     * @param Proforma $proforma
     * @return JsonResponse|Response
     */
    public function destroy(Proforma $proforma): JsonResponse|Response
    {
        DB::beginTransaction();
        try {
            $this->proformaService->eliminar($proforma);
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
