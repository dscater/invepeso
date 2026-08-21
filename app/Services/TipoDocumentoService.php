<?php

namespace App\Services;

use App\Models\Cliente;
use App\Services\HistorialAccionService;
use App\Models\TipoDocumento;
use App\Models\User;
use Illuminate\Http\UploadedFile;
use Exception;
use Illuminate\Container\Attributes\Auth;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Validation\ValidationException;

class TipoDocumentoService
{
    private $modulo = "TIPO DE DOCUMENTOS";

    public function __construct(private  CargarArchivoService $cargarArchivoService, private HistorialAccionService $historialAccionService) {}

    public function listado(): Collection
    {
        $tipo_documentos = TipoDocumento::select("tipo_documentos.*")->get();
        return $tipo_documentos;
    }
    /**
     * Lista de tipo_documentos paginado con filtros
     *
     * @param integer $length
     * @param integer $page
     * @param string $search
     * @param array $columnsSerachLike
     * @param array $columnsFilter
     * @return LengthAwarePaginator
     */
    public function listadoPaginado(int $length, int $page, string $search, array $columnsSerachLike = [], array $columnsFilter = [], array $columnsBetweenFilter = [], array $orderBy = []): LengthAwarePaginator
    {
        $tipo_documentos = TipoDocumento::select("tipo_documentos.*");

        // Filtros exactos
        foreach ($columnsFilter as $key => $value) {
            if (!is_null($value)) {
                $tipo_documentos->where("tipo_documentos.$key", $value);
            }
        }

        // Filtros por rango
        foreach ($columnsBetweenFilter as $key => $value) {
            if (isset($value[0], $value[1])) {
                $tipo_documentos->whereBetween("tipo_documentos.$key", $value);
            }
        }

        // Búsqueda en múltiples columnas con LIKE
        if (!empty($search) && !empty($columnsSerachLike)) {
            $tipo_documentos->where(function ($query) use ($search, $columnsSerachLike) {
                foreach ($columnsSerachLike as $col) {
                    $query->orWhere("$col", "LIKE", "%$search%");
                }
            });
        }

        // Ordenamiento
        foreach ($orderBy as $value) {
            if (isset($value[0], $value[1])) {
                $tipo_documentos->orderBy($value[0], $value[1]);
            }
        }


        $tipo_documentos = $tipo_documentos->paginate($length, ['*'], 'page', $page);
        return $tipo_documentos;
    }

    /**
     * Crear tipo_documento
     *
     * @param array $datos
     * @return TipoDocumento
     */
    public function crear(array $datos): TipoDocumento
    {
        $tipo_documento = TipoDocumento::create([
            "nombre" => $datos["nombre"],
            "descripcion" => $datos["descripcion"] ?? NULL,
        ]);

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "CREACIÓN", "REGISTRO UN TIPO DE DOCUMENTO", $tipo_documento);

        return $tipo_documento;
    }

    /**
     * Actualizar tipo_documento
     *
     * @param array $datos
     * @param TipoDocumento $tipo_documento
     * @return TipoDocumento
     */
    public function actualizar(array $datos, TipoDocumento $tipo_documento): TipoDocumento
    {
        $old_tipo_documento = clone $tipo_documento;

        $tipo_documento->update([
            "nombre" => $datos["nombre"],
            "descripcion" => $datos["descripcion"] ?? NULL,
        ]);

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "MODIFICACIÓN", "ACTUALIZÓ UN TIPO DE DOCUMENTO", $old_tipo_documento, $tipo_documento->withoutRelations());

        return $tipo_documento;
    }

    /**
     * Eliminar tipo_documento
     *
     * @param TipoDocumento $tipo_documento
     * @return boolean
     */
    public function eliminar(TipoDocumento $tipo_documento): bool|Exception
    {
        $old_tipo_documento = clone $tipo_documento;

        $usos = Cliente::where("tipo_documento_id", $tipo_documento->id)->count();
        if ($usos > 0) {
            throw new Exception("No se puede eliminar este tipo de documento porque está siendo utilizado por $usos clientes.");
        }

        $tipo_documento->delete();

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "ELIMINACIÓN", "ELIMINÓ UN TIPO DE DOCUMENTO", $old_tipo_documento, $tipo_documento);

        return true;
    }
}
