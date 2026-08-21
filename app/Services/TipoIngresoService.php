<?php

namespace App\Services;

use App\Models\IngresoDetalle;
use App\Models\IngresoProducto;
use App\Services\HistorialAccionService;
use App\Models\TipoIngreso;
use App\Models\User;
use Illuminate\Http\UploadedFile;
use Exception;
use Illuminate\Container\Attributes\Auth;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Validation\ValidationException;

class TipoIngresoService
{
    private $modulo = "TIPO DE INGRESOS";

    public function __construct(private  CargarArchivoService $cargarArchivoService, private HistorialAccionService $historialAccionService) {}

    public function listado(): Collection
    {
        $tipo_ingresos = TipoIngreso::select("tipo_ingresos.*")->get();
        return $tipo_ingresos;
    }
    /**
     * Lista de tipo_ingresos paginado con filtros
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
        $tipo_ingresos = TipoIngreso::select("tipo_ingresos.*");

        // Filtros exactos
        foreach ($columnsFilter as $key => $value) {
            if (!is_null($value)) {
                $tipo_ingresos->where("tipo_ingresos.$key", $value);
            }
        }

        // Filtros por rango
        foreach ($columnsBetweenFilter as $key => $value) {
            if (isset($value[0], $value[1])) {
                $tipo_ingresos->whereBetween("tipo_ingresos.$key", $value);
            }
        }

        // Búsqueda en múltiples columnas con LIKE
        if (!empty($search) && !empty($columnsSerachLike)) {
            $tipo_ingresos->where(function ($query) use ($search, $columnsSerachLike) {
                foreach ($columnsSerachLike as $col) {
                    $query->orWhere("$col", "LIKE", "%$search%");
                }
            });
        }

        // Ordenamiento
        foreach ($orderBy as $value) {
            if (isset($value[0], $value[1])) {
                $tipo_ingresos->orderBy($value[0], $value[1]);
            }
        }


        $tipo_ingresos = $tipo_ingresos->paginate($length, ['*'], 'page', $page);
        return $tipo_ingresos;
    }

    /**
     * Crear tipo_ingreso
     *
     * @param array $datos
     * @return TipoIngreso
     */
    public function crear(array $datos): TipoIngreso
    {
        $tipo_ingreso = TipoIngreso::create([
            "nombre" => mb_strtoupper($datos["nombre"]),
            "descripcion" => mb_strtoupper($datos["descripcion"]) ?? null,
        ]);

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "CREACIÓN", "REGISTRO UN TIPO DE INGRESO", $tipo_ingreso);

        return $tipo_ingreso;
    }

    /**
     * Actualizar tipo_ingreso
     *
     * @param array $datos
     * @param TipoIngreso $tipo_ingreso
     * @return TipoIngreso
     */
    public function actualizar(array $datos, TipoIngreso $tipo_ingreso): TipoIngreso
    {
        $old_tipo_ingreso = clone $tipo_ingreso;

        $tipo_ingreso->update([
            "nombre" => mb_strtoupper($datos["nombre"]),
            "descripcion" => mb_strtoupper($datos["descripcion"]) ?? null,
        ]);

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "MODIFICACIÓN", "ACTUALIZÓ UN TIPO DE INGRESO", $old_tipo_ingreso, $tipo_ingreso->withoutRelations());

        return $tipo_ingreso;
    }

    /**
     * Eliminar tipo_ingreso
     *
     * @param TipoIngreso $tipo_ingreso
     * @return boolean
     */
    public function eliminar(TipoIngreso $tipo_ingreso): bool|Exception
    {
        $old_tipo_ingreso = clone $tipo_ingreso;

        $usos = IngresoDetalle::where("tipo_ingreso_id", $tipo_ingreso->id)->count();
        if ($usos > 0) {
            throw new Exception("No se puede eliminar este tipo de ingreso porque está siendo utilizado por $usos ingreso de productos.");
        }

        $tipo_ingreso->delete();

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "ELIMINACIÓN", "ELIMINÓ UN TIPO DE INGRESO", $old_tipo_ingreso, $tipo_ingreso);

        return true;
    }
}
