<?php

namespace App\Http\Controllers;

use App\Http\Requests\TipoDocumentoStoreRequest;
use App\Http\Requests\TipoDocumentoUpdateRequest;
use App\Models\TipoDocumento;
use App\Models\User;
use App\Services\TipoDocumentoService;
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

class TipoDocumentoController extends Controller
{
    public function __construct(private TipoDocumentoService $tipo_documentoService) {}

    /**
     * Página index
     *
     * @return Response
     */
    public function index(): ResponseInertia
    {
        return Inertia::render("Admin/TipoDocumentos/Index");
    }

    /**
     * Listado de tipo_documentos sin ids: 1 y 2
     *
     * @return JsonResponse
     */
    public function listado(): JsonResponse
    {
        return response()->JSON([
            "tipo_documentos" => $this->tipo_documentoService->listado()
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

        $tipo_documentos = $this->tipo_documentoService->listadoPaginado($perPage, $page, $search, $columnsSerachLike, $columnsFilter, $columnsBetweenFilter, $arrayOrderBy);
        return response()->JSON([
            "data" => $tipo_documentos->items(),
            "total" => $tipo_documentos->total(),
            "lastPage" => $tipo_documentos->lastPage()
        ]);
    }

    /**
     * Registrar un nuevo tipo_documento
     *
     * @param TipoDocumentoStoreRequest $request
     * @return RedirectResponse|Response
     */
    public function store(TipoDocumentoStoreRequest $request): RedirectResponse|Response
    {
        DB::beginTransaction();
        try {
            // crear el TipoDocumento
            $this->tipo_documentoService->crear($request->validated());
            DB::commit();
            return redirect()->route("tipo_documentos.index")->with("bien", "Registro realizado");
        } catch (\Exception $e) {
            DB::rollBack();
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    /**
     * Mostrar un tipo_documento
     *
     * @param TipoDocumento $tipo_documento
     * @return JsonResponse
     */
    public function show(TipoDocumento $tipo_documento): JsonResponse
    {
        return response()->JSON($tipo_documento);
    }

    public function update(TipoDocumento $tipo_documento, TipoDocumentoUpdateRequest $request)
    {
        DB::beginTransaction();
        try {
            // actualizar tipo_documento
            $this->tipo_documentoService->actualizar($request->validated(), $tipo_documento);
            DB::commit();
            return redirect()->route("tipo_documentos.index")->with("bien", "Registro actualizado");
        } catch (\Exception $e) {
            DB::rollBack();
            // Log::debug($e->getMessage());
            throw ValidationException::withMessages([
                'error' =>  $e->getMessage(),
            ]);
        }
    }

    /**
     * Eliminar tipo_documento
     *
     * @param TipoDocumento $tipo_documento
     * @return JsonResponse|Response
     */
    public function destroy(TipoDocumento $tipo_documento): JsonResponse|Response
    {
        DB::beginTransaction();
        try {
            $this->tipo_documentoService->eliminar($tipo_documento);
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
