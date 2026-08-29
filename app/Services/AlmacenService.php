<?php

namespace App\Services;

use App\Services\HistorialAccionService;
use App\Models\Almacen;
use App\Models\IngresoProducto;
use App\Models\SalidaProducto;
use App\Models\User;
use App\Models\Venta;
use Illuminate\Http\UploadedFile;
use Exception;
use Illuminate\Container\Attributes\Auth;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Validation\ValidationException;

class AlmacenService
{
    private $modulo = "ALMACENES";

    public function __construct(private  CargarArchivoService $cargarArchivoService, private HistorialAccionService $historialAccionService) {}

    public function listado($activo = null): Collection
    {
        $almacens = Almacen::select("almacens.*")
            ->with(["sucursal:id,nombre"]);

        if ($activo && $activo == 1) {
            $almacens->where("activo", 1);
        }

        $almacens = $almacens->get();
        return $almacens;
    }
    /**
     * Lista de almacens paginado con filtros
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
        $almacens = Almacen::with(["sucursal:id,nombre"])->select("almacens.*");

        // Filtros exactos
        foreach ($columnsFilter as $key => $value) {
            if (!is_null($value)) {
                $almacens->where("almacens.$key", $value);
            }
        }

        // Filtros por rango
        foreach ($columnsBetweenFilter as $key => $value) {
            if (isset($value[0], $value[1])) {
                $almacens->whereBetween("almacens.$key", $value);
            }
        }

        // Búsqueda en múltiples columnas con LIKE
        if (!empty($search) && !empty($columnsSerachLike)) {
            $almacens->where(function ($query) use ($search, $columnsSerachLike) {
                foreach ($columnsSerachLike as $col) {
                    $query->orWhere("$col", "LIKE", "%$search%");
                }
            });
        }

        // Ordenamiento
        foreach ($orderBy as $value) {
            if (isset($value[0], $value[1])) {
                $almacens->orderBy($value[0], $value[1]);
            }
        }


        $almacens = $almacens->paginate($length, ['*'], 'page', $page);
        return $almacens;
    }

    /**
     * Crear almacen
     *
     * @param array $datos
     * @return Almacen
     */
    public function crear(array $datos): Almacen
    {
        $almacen = Almacen::create([
            "sucursal_id" => $datos["sucursal_id"],
            "nombre" => mb_strtoupper($datos["nombre"]),
            "activo" => $datos["activo"],
            "descripcion" => mb_strtoupper($datos["descripcion"]) ?? null,
            "fecha_registro" => date("Y-m-d")
        ]);

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "CREACIÓN", "REGISTRO UN ALMACÉN", $almacen);

        return $almacen;
    }

    /**
     * Actualizar almacen
     *
     * @param array $datos
     * @param Almacen $almacen
     * @return Almacen
     */
    public function actualizar(array $datos, Almacen $almacen): Almacen
    {
        $old_almacen = clone $almacen;

        $almacen->update([
            "sucursal_id" => $datos["sucursal_id"],
            "nombre" => mb_strtoupper($datos["nombre"]),
            "activo" => $datos["activo"],
            "descripcion" => mb_strtoupper($datos["descripcion"]) ?? null,
        ]);

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "MODIFICACIÓN", "ACTUALIZÓ UN ALMACÉN", $old_almacen, $almacen->withoutRelations());

        return $almacen;
    }

    /**
     * Eliminar almacen
     *
     * @param Almacen $almacen
     * @return boolean
     */
    public function eliminar(Almacen $almacen): bool|Exception
    {
        $old_almacen = clone $almacen;

        $usos = Venta::where("almacen_id", $almacen->id)->count();
        if ($usos > 0) {
            throw new Exception("No es posible eliminar el registro " . $almacen->nombre . ", porque fue usado en ventas");
        }

        $usos = IngresoProducto::where("almacen_id", $almacen->id)->count();
        if ($usos > 0) {
            throw new Exception("No es posible eliminar el registro " . $almacen->nombre . ", porque fue usado en ingreso de productos");
        }

        $usos = SalidaProducto::where("almacen_id", $almacen->id)->count();
        if ($usos > 0) {
            throw new Exception("No es posible eliminar el registro " . $almacen->nombre . ", porque fue usado en salida de productos");
        }

        // TODO: PARA TRANSFERENCIAS

        $almacen->delete();

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "ELIMINACIÓN", "ELIMINÓ UN ALMACÉN", $old_almacen, $almacen);

        return true;
    }
}
