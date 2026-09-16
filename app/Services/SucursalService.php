<?php

namespace App\Services;

use App\Models\Almacen;
use App\Models\IngresoProducto;
use App\Models\SalidaProducto;
use App\Services\HistorialAccionService;
use App\Models\Sucursal;
use App\Models\Traspaso;
use App\Models\User;
use App\Models\Venta;
use Illuminate\Http\UploadedFile;
use Exception;
use Illuminate\Container\Attributes\Auth;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Validation\ValidationException;

class SucursalService
{
    private $modulo = "SUCURSALES";

    public function __construct(private  CargarArchivoService $cargarArchivoService, private HistorialAccionService $historialAccionService) {}

    public function listado($activo = null): Collection
    {
        $sucursals = Sucursal::select("sucursals.*");

        if ($activo && $activo == 1) {
            $sucursals->where("activo", 1);
        }

        $sucursals = $sucursals->get();
        return $sucursals;
    }
    /**
     * Lista de sucursals paginado con filtros
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
        $sucursals = Sucursal::select("sucursals.*");

        // Filtros exactos
        foreach ($columnsFilter as $key => $value) {
            if (!is_null($value)) {
                $sucursals->where("sucursals.$key", $value);
            }
        }

        // Filtros por rango
        foreach ($columnsBetweenFilter as $key => $value) {
            if (isset($value[0], $value[1])) {
                $sucursals->whereBetween("sucursals.$key", $value);
            }
        }

        // Búsqueda en múltiples columnas con LIKE
        if (!empty($search) && !empty($columnsSerachLike)) {
            $sucursals->where(function ($query) use ($search, $columnsSerachLike) {
                foreach ($columnsSerachLike as $col) {
                    $query->orWhere("$col", "LIKE", "%$search%");
                }
            });
        }

        // Ordenamiento
        foreach ($orderBy as $value) {
            if (isset($value[0], $value[1])) {
                $sucursals->orderBy($value[0], $value[1]);
            }
        }


        $sucursals = $sucursals->paginate($length, ['*'], 'page', $page);
        return $sucursals;
    }

    /**
     * Crear sucursal
     *
     * @param array $datos
     * @return Sucursal
     */
    public function crear(array $datos): Sucursal
    {
        $sucursal = Sucursal::create([
            "nombre" => mb_strtoupper($datos["nombre"]),
            "activo" => $datos["activo"],
            "descripcion" => mb_strtoupper($datos["descripcion"]) ?? null,
            "fecha_registro" => date("Y-m-d")
        ]);

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "CREACIÓN", "REGISTRO UNA SUCURSAL", $sucursal);

        return $sucursal;
    }

    /**
     * Actualizar sucursal
     *
     * @param array $datos
     * @param Sucursal $sucursal
     * @return Sucursal
     */
    public function actualizar(array $datos, Sucursal $sucursal): Sucursal
    {
        $old_sucursal = clone $sucursal;

        $almacenes_activos = Almacen::where("sucursal_id", $sucursal->id)
            ->where("activo", 1)->count();
        if ($almacenes_activos > 0 && $datos["activo"] == 0) {
            throw new Exception("No es posible poner INACTIVA la sucursal {$sucursal->nombre}, porque tiene {$almacenes_activos} almacenes activos");
        }

        $sucursal->update([
            "nombre" => mb_strtoupper($datos["nombre"]),
            "activo" => $datos["activo"],
            "descripcion" => mb_strtoupper($datos["descripcion"]) ?? null,
        ]);

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "MODIFICACIÓN", "ACTUALIZÓ UNA SUCURSAL", $old_sucursal, $sucursal->withoutRelations());

        return $sucursal;
    }

    /**
     * Eliminar sucursal
     *
     * @param Sucursal $sucursal
     * @return boolean
     */
    public function eliminar(Sucursal $sucursal): bool|Exception
    {
        $old_sucursal = clone $sucursal;
        $usos = Venta::where("sucursal_id", $sucursal->id)->count();
        if ($usos > 0) {
            throw new Exception("No es posible eliminar el registro " . $sucursal->nombre . ", porque fue usado en ventas");
        }

        $usos = IngresoProducto::where("sucursal_id", $sucursal->id)->count();
        if ($usos > 0) {
            throw new Exception("No es posible eliminar el registro " . $sucursal->nombre . ", porque fue usado en ingreso de productos");
        }

        $usos = SalidaProducto::where("sucursal_id", $sucursal->id)->count();
        if ($usos > 0) {
            throw new Exception("No es posible eliminar el registro " . $sucursal->nombre . ", porque fue usado en salida de productos");
        }

        $usos = Traspaso::where("sucursal_origen_id", $sucursal->id)->count();
        if ($usos > 0) {
            throw new Exception("No es posible eliminar el registro " . $sucursal->nombre . ", porque fue usado en traspasos/transferencias");
        }

        $usos = Traspaso::where("sucursal_destino_id", $sucursal->id)->count();
        if ($usos > 0) {
            throw new Exception("No es posible eliminar el registro " . $sucursal->nombre . ", porque fue usado en traspasos/transferencias");
        }

        $almacenes_activos = Almacen::where("sucursal_id", $sucursal->id)
            ->where("activo", 1)->count();
        if ($almacenes_activos > 0) {
            throw new Exception("No es posible eliminar la sucursal {$sucursal->nombre}, porque tiene {$almacenes_activos} almacenes activos");
        }
        $sucursal->delete();

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "ELIMINACIÓN", "ELIMINÓ UNA SUCURSAL", $old_sucursal, $sucursal);

        return true;
    }
}
