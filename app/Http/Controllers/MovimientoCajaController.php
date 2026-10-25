<?php

namespace App\Http\Controllers;

use App\Http\Requests\MovimientoCajaStoreRequest;
use App\Http\Requests\MovimientoCajaUpdateRequest;
use App\Models\Almacen;
use App\Models\MovimientoCaja;
use App\Models\Sucursal;
use App\Models\User;
use App\Services\AlmacenService;
use App\Services\MovimientoCajaService;
use App\Services\UserService;
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

class MovimientoCajaController extends Controller
{
    public function __construct(
        private MovimientoCajaService $movimiento_cajaService,
        private UserService $user_service,
        private AlmacenService $almacen_service
    ) {}

    /**
     * Página index
     *
     * @return Response
     */
    public function index(): ResponseInertia
    {

        $almacens = $this->almacen_service->listado(1);
        $usuarios = $this->user_service->listado(1);

        return Inertia::render("Admin/MovimientoCajas/Index", [
            "almacens" => $almacens,
            "usuarios" => $usuarios,
        ]);
    }

    /**
     * Listado de movimiento_cajas sin ids: 1 y 2
     *
     * @return JsonResponse
     */
    public function listado(): JsonResponse
    {
        return response()->JSON([
            "movimiento_cajas" => $this->movimiento_cajaService->listado()
        ]);
    }

    public function resumen(Request $request)
    {
        $user_id = (string)$request->input("user_id", "");
        $almacen_id = (string)$request->input("almacen_id", "");
        $fecha_ini = (string)$request->input("fecha_ini", "");
        $fecha_fin = (string)$request->input("fecha_fin", "");
        $resumen = $this->movimiento_cajaService->resumen_movimientos($user_id, $almacen_id, $fecha_ini, $fecha_fin);
        return response()->JSON(["resumen" => $resumen]);
    }

    public function paginado(Request $request)
    {
        $perPage = $request->perPage;
        $page = (int)($request->input("page", 1));
        $search = (string)$request->input("search", "");
        $user_id = (string)$request->input("user_id", "");
        $almacen_id = (string)$request->input("almacen_id", "");
        $fecha_ini = (string)$request->input("fecha_ini", "");
        $fecha_fin = (string)$request->input("fecha_fin", "");
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

        $movimiento_cajas = $this->movimiento_cajaService->listadoPaginado(
            $perPage,
            $page,
            $search,
            $user_id,
            $almacen_id,
            $fecha_ini,
            $fecha_fin,
            $arrayOrderBy
        );


        return response()->JSON([
            "data" => $movimiento_cajas->items(),
            "total" => $movimiento_cajas->total(),
            "lastPage" => $movimiento_cajas->lastPage(),
        ]);
    }

    public function create(): ResponseInertia
    {
        return Inertia::render("Admin/MovimientoCajas/Create");
    }

    /**
     * Registrar un nuevo movimiento_caja
     *
     * @param MovimientoCajaStoreRequest $request
     * @return RedirectResponse|Response
     */
    public function store(MovimientoCajaStoreRequest $request): RedirectResponse|Response
    {
        DB::beginTransaction();
        try {
            // crear el MovimientoCaja
            $data = $request->validated();
            $data["tipo"] = "MOVIMIENTO DE CAJA";
            $almacen = Almacen::findOrFail($data["almacen_id"]);
            $sucursal = Sucursal::findOrFail($almacen->sucursal_id);
            $data["sucursal_id"] = $sucursal->id;
            $data["almacen_id"] = $almacen->id;
            $data["modulo"] = "MovimientoCaja";
            $this->movimiento_cajaService->crear($data);
            DB::commit();
            return redirect()->route("movimiento_cajas.index")->with("bien", "Registro realizado");
        } catch (\Exception $e) {
            DB::rollBack();
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    /**
     * Mostrar un movimiento_caja
     *
     * @param MovimientoCaja $movimiento_caja
     * @return JsonResponse
     */
    public function show(MovimientoCaja $movimiento_caja): JsonResponse
    {
        return response()->JSON($movimiento_caja);
    }

    public function edit(MovimientoCaja $movimiento_caja): ResponseInertia
    {
        // $movimiento_caja = $movimiento_caja->load([""]);
        return Inertia::render("Admin/MovimientoCajas/Edit", compact("movimiento_caja"));
    }

    public function update(MovimientoCaja $movimiento_caja, MovimientoCajaUpdateRequest $request)
    {
        DB::beginTransaction();
        try {
            // actualizar movimiento_caja
            $data = $request->validated();
            $data["tipo"] = "MOVIMIENTO DE CAJA";
            $almacen = Almacen::findOrFail($data["almacen_id"]);
            $sucursal = Sucursal::findOrFail($almacen->sucursal_id);
            $data["sucursal_id"] = $sucursal->id;
            $data["almacen_id"] = $almacen->id;
            $data["modulo"] = "MovimientoCaja";
            $this->movimiento_cajaService->actualizar($data, $movimiento_caja);
            DB::commit();
            return redirect()->route("movimiento_cajas.index")->with("bien", "Registro actualizado");
        } catch (\Exception $e) {
            DB::rollBack();
            // Log::debug($e->getMessage());
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    /**
     * Eliminar movimiento_caja
     *
     * @param MovimientoCaja $movimiento_caja
     * @return JsonResponse|Response
     */
    public function destroy(MovimientoCaja $movimiento_caja): JsonResponse|Response
    {
        DB::beginTransaction();
        try {
            $this->movimiento_cajaService->eliminar($movimiento_caja);
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
