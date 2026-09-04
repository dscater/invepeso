<?php

namespace App\Http\Controllers;

use App\Http\Requests\TraspasoStoreRequest;
use App\Http\Requests\TraspasoUpdateRequest;
use App\Models\Traspaso;
use App\Models\User;
use App\Services\TraspasoService;
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

class TraspasoController extends Controller
{
    public function __construct(private TraspasoService $traspasoService) {}

    /**
     * Página index
     *
     * @return Response
     */
    public function index(): ResponseInertia
    {
        return Inertia::render("Admin/Traspasos/Index");
    }

    /**
     * Listado de traspasos sin ids: 1 y 2
     *
     * @return JsonResponse
     */
    public function listado(): JsonResponse
    {
        return response()->JSON([
            "traspasos" => $this->traspasoService->listado()
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

        $traspasos = $this->traspasoService->listadoPaginado($perPage, $page, $search, $columnsSerachLike, $columnsFilter, $columnsBetweenFilter, $arrayOrderBy);
        return response()->JSON([
            "data" => $traspasos->items(),
            "total" => $traspasos->total(),
            "lastPage" => $traspasos->lastPage()
        ]);
    }

    public function create(): ResponseInertia
    {
        return Inertia::render("Admin/Traspasos/Create");
    }

    /**
     * Registrar un nuevo traspaso
     *
     * @param TraspasoStoreRequest $request
     * @return RedirectResponse|Response
     */
    public function store(TraspasoStoreRequest $request): RedirectResponse|Response
    {
        DB::beginTransaction();
        try {
            // crear el Traspaso
            $this->traspasoService->crear($request->validated());
            DB::commit();
            return redirect()->route("traspasos.index")->with("bien", "Registro realizado");
        } catch (\Exception $e) {
            DB::rollBack();
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    /**
     * Mostrar un traspaso
     *
     * @param Traspaso $traspaso
     * @return JsonResponse
     */
    public function show(Traspaso $traspaso): JsonResponse
    {
        return response()->JSON($traspaso);
    }

    public function edit(Traspaso $traspaso): ResponseInertia
    {
        $traspaso = $traspaso->load(["salida_detalles.producto", "salida_detalles.tipo_salida"]);
        return Inertia::render("Admin/Traspasos/Edit", compact("traspaso"));
    }

    public function update(Traspaso $traspaso, TraspasoUpdateRequest $request)
    {
        DB::beginTransaction();
        try {
            // actualizar traspaso
            $this->traspasoService->actualizar($request->validated(), $traspaso);
            DB::commit();
            return redirect()->route("traspasos.index")->with("bien", "Registro actualizado");
        } catch (\Exception $e) {
            DB::rollBack();
            // Log::debug($e->getMessage());
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    /**
     * Eliminar traspaso
     *
     * @param Traspaso $traspaso
     * @return JsonResponse|Response
     */
    public function destroy(Traspaso $traspaso): JsonResponse|Response
    {
        DB::beginTransaction();
        try {
            $this->traspasoService->eliminar($traspaso);
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
