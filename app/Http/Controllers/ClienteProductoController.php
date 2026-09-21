<?php

namespace App\Http\Controllers;

use App\Http\Requests\ClienteProductoStoreRequest;
use App\Http\Requests\ClienteProductoUpdateRequest;
use App\Models\Cliente;
use App\Models\ClienteProducto;
use App\Models\User;
use App\Services\ClienteProductoService;
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

class ClienteProductoController extends Controller
{
    public function __construct(private ClienteProductoService $cliente_productoService) {}

    /**
     * Página index
     *
     * @return Response
     */
    public function index(Cliente $cliente): ResponseInertia
    {
        $cliente = $cliente->load(["tipo_documento"]);
        return Inertia::render("Admin/ClienteProductos/Index", compact("cliente"));
    }

    /**
     * Listado de cliente_productos
     *
     * @return JsonResponse
     */
    public function listado(Request $request): JsonResponse
    {
        return response()->JSON([
            "cliente_productos" => $this->cliente_productoService->listado($request->input("cliente_id", 0))
        ]);
    }

    public function byCi(Request $request)
    {
        $ci = $request->input("ci", "");
        $cliente_productos = ClienteProducto::where("ci", $ci)->get();
        return response()->JSON($cliente_productos);
    }

    public function paginado(Request $request)
    {
        $perPage = $request->perPage;
        $page = (int)($request->input("page", 1));
        $cliente_id = (string)$request->input("cliente_id", 0);
        $search = (string)$request->input("search", "");
        $orderBy = $request->orderBy;
        $orderAsc = $request->orderAsc;

        $columnsSerachLike = [
            "ci",
        ];
        $columnsFilter = [];
        $columnsBetweenFilter = [];
        $arrayOrderBy = [];
        if ($orderBy && $orderAsc) {
            $arrayOrderBy = [
                [$orderBy, $orderAsc]
            ];
        }

        $cliente_productos = $this->cliente_productoService->listadoPaginado($perPage, $page, $cliente_id, $search, $columnsSerachLike, $columnsFilter, $columnsBetweenFilter, $arrayOrderBy);
        return response()->JSON([
            "data" => $cliente_productos->items(),
            "total" => $cliente_productos->total(),
            "lastPage" => $cliente_productos->lastPage()
        ]);
    }

    /**
     * Registrar un nuevo cliente_producto
     *
     * @param ClienteProductoStoreRequest $request
     * @return RedirectResponse|Response
     */
    public function store(ClienteProductoStoreRequest $request): RedirectResponse|Response|JsonResponse
    {
        DB::beginTransaction();
        try {
            // crear el ClienteProducto
            $data = $request->validated();
            $cliente_producto = $this->cliente_productoService->crear($data);
            DB::commit();

            if (isset($data["tipo_envio"]) && $data["tipo_envio"] == "ajax") {
                return response()->JSON([
                    "sw" => true,
                    "message" => "Registro realizado",
                    "cliente_producto" => $cliente_producto->load(["tipo_documento:id,nombre"])
                ]);
            }

            return redirect()->route("cliente_productos.index", $data["cliente_id"])->with("bien", "Registro realizado");
        } catch (\Exception $e) {
            DB::rollBack();
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    public function nuevo(ClienteProductoStoreRequest $request): JsonResponse|Response
    {
        DB::beginTransaction();
        try {
            // crear el ClienteProducto
            $cliente_producto = $this->cliente_productoService->crear($request->validated());
            DB::commit();
            return response()->JSON([
                "cliente_producto" => $cliente_producto,
                "sw" => true,
                "message" => "Registro realizado"
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    /**
     * Mostrar un cliente_producto
     *
     * @param ClienteProducto $cliente_producto
     * @return JsonResponse
     */
    public function show(ClienteProducto $cliente_producto): JsonResponse
    {
        return response()->JSON($cliente_producto);
    }

    public function update(ClienteProducto $cliente_producto, ClienteProductoUpdateRequest $request)
    {
        DB::beginTransaction();
        try {
            // actualizar cliente_producto
            $this->cliente_productoService->actualizar($request->validated(), $cliente_producto);
            DB::commit();
            return redirect()->route("cliente_productos.index", $cliente_producto->cliente_id)->with("bien", "Registro actualizado");
        } catch (\Exception $e) {
            DB::rollBack();
            // Log::debug($e->getMessage());
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    /**
     * Eliminar cliente_producto
     *
     * @param ClienteProducto $cliente_producto
     * @return JsonResponse|Response
     */
    public function destroy(ClienteProducto $cliente_producto): JsonResponse|Response
    {
        DB::beginTransaction();
        try {
            $this->cliente_productoService->eliminar($cliente_producto);
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
