<?php

namespace App\Http\Controllers;

use App\Http\Requests\CajaStoreRequest;
use App\Http\Requests\CajaUpdateRequest;
use App\Models\Caja;
use App\Models\User;
use App\Services\CajaService;
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

class CajaController extends Controller
{
    public function __construct(private CajaService $cajaService) {}

    /**
     * Página index
     *
     * @return Response
     */
    public function index(): ResponseInertia
    {
        return Inertia::render("Admin/Cajas/Index");
    }

    /**
     * Listado de cajas sin ids: 1 y 2
     *
     * @return JsonResponse
     */
    public function listado(): JsonResponse
    {
        return response()->JSON([
            "cajas" => $this->cajaService->listado()
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

        $cajas = $this->cajaService->listadoPaginado($perPage, $page, $search, $columnsSerachLike, $columnsFilter, $columnsBetweenFilter, $arrayOrderBy);
        return response()->JSON([
            "data" => $cajas->items(),
            "total" => $cajas->total(),
            "lastPage" => $cajas->lastPage()
        ]);
    }

    /**
     * Registrar un nuevo caja
     *
     * @param CajaStoreRequest $request
     * @return RedirectResponse|Response
     */
    public function store(CajaStoreRequest $request): RedirectResponse|Response
    {
        DB::beginTransaction();
        try {
            // crear el Caja
            $this->cajaService->crear($request->validated());
            DB::commit();
            return redirect()->route("cajas.index")->with("bien", "Registro realizado");
        } catch (\Exception $e) {
            DB::rollBack();
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    /**
     * Mostrar un caja
     *
     * @param Caja $caja
     * @return JsonResponse
     */
    public function show(Caja $caja): JsonResponse
    {
        return response()->JSON($caja);
    }

    public function update(Caja $caja, CajaUpdateRequest $request)
    {
        DB::beginTransaction();
        try {
            // actualizar caja
            $this->cajaService->actualizar($request->validated(), $caja);
            DB::commit();
            return redirect()->route("cajas.index")->with("bien", "Registro actualizado");
        } catch (\Exception $e) {
            DB::rollBack();
            // Log::debug($e->getMessage());
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    /**
     * Eliminar caja
     *
     * @param Caja $caja
     * @return JsonResponse|Response
     */
    public function destroy(Caja $caja): JsonResponse|Response
    {
        DB::beginTransaction();
        try {
            $this->cajaService->eliminar($caja);
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
