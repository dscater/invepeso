<?php

namespace App\Services;

use App\Models\SalidaProducto;
use App\Services\HistorialAccionService;
use App\Models\TipoSalida;
use App\Models\User;
use Illuminate\Http\UploadedFile;
use Exception;
use Illuminate\Container\Attributes\Auth;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Validation\ValidationException;

class TipoSalidaService
{
    private $modulo = "TIPO DE SALIDAS";

    public function __construct(private  CargarArchivoService $cargarArchivoService, private HistorialAccionService $historialAccionService) {}

    public function listado(): Collection
    {
        $tipo_salidas = TipoSalida::select("tipo_salidas.*")->get();
        return $tipo_salidas;
    }
    /**
     * Lista de tipo_salidas paginado con filtros
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
        $tipo_salidas = TipoSalida::select("tipo_salidas.*");

        // Filtros exactos
        foreach ($columnsFilter as $key => $value) {
            if (!is_null($value)) {
                $tipo_salidas->where("tipo_salidas.$key", $value);
            }
        }

        // Filtros por rango
        foreach ($columnsBetweenFilter as $key => $value) {
            if (isset($value[0], $value[1])) {
                $tipo_salidas->whereBetween("tipo_salidas.$key", $value);
            }
        }

        // Búsqueda en múltiples columnas con LIKE
        if (!empty($search) && !empty($columnsSerachLike)) {
            $tipo_salidas->where(function ($query) use ($search, $columnsSerachLike) {
                foreach ($columnsSerachLike as $col) {
                    $query->orWhere("$col", "LIKE", "%$search%");
                }
            });
        }

        // Ordenamiento
        foreach ($orderBy as $value) {
            if (isset($value[0], $value[1])) {
                $tipo_salidas->orderBy($value[0], $value[1]);
            }
        }


        $tipo_salidas = $tipo_salidas->paginate($length, ['*'], 'page', $page);
        return $tipo_salidas;
    }

    /**
     * Crear tipo_salida
     *
     * @param array $datos
     * @return TipoSalida
     */
    public function crear(array $datos): TipoSalida
    {
        $tipo_salida = TipoSalida::create([
            "nombre" => mb_strtoupper($datos["nombre"]),
            "descripcion" => mb_strtoupper($datos["descripcion"]) ?? null,
        ]);

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "CREACIÓN", "REGISTRO UN TIPO DE SALIDA", $tipo_salida);

        return $tipo_salida;
    }

    /**
     * Actualizar tipo_salida
     *
     * @param array $datos
     * @param TipoSalida $tipo_salida
     * @return TipoSalida
     */
    public function actualizar(array $datos, TipoSalida $tipo_salida): TipoSalida
    {
        $old_tipo_salida = clone $tipo_salida;

        $tipo_salida->update([
            "nombre" => mb_strtoupper($datos["nombre"]),
            "descripcion" => mb_strtoupper($datos["descripcion"]) ?? null,
        ]);

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "MODIFICACIÓN", "ACTUALIZÓ UN TIPO DE SALIDA", $old_tipo_salida, $tipo_salida->withoutRelations());

        return $tipo_salida;
    }

    /**
     * Eliminar tipo_salida
     *
     * @param TipoSalida $tipo_salida
     * @return boolean
     */
    public function eliminar(TipoSalida $tipo_salida): bool|Exception
    {
        $old_tipo_salida = clone $tipo_salida;

        $usos = SalidaProducto::where("tipo_salida_id", $tipo_salida->id)->count();
        if ($usos > 0) {
            throw new Exception("No se puede eliminar este tipo de salida porque está siendo utilizado por $usos salida de productos.");
        }

        $tipo_salida->delete();

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "ELIMINACIÓN", "ELIMINÓ UN TIPO DE SALIDA", $old_tipo_salida, $tipo_salida);

        return true;
    }
}
