<?php

namespace App\Services;

use App\Services\HistorialAccionService;
use App\Models\SalidaProducto;
use App\Models\User;
use Illuminate\Http\UploadedFile;
use Exception;
use Illuminate\Container\Attributes\Auth;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Validation\ValidationException;

class SalidaProductoService
{
    private $modulo = "SUCURSALES";

    public function __construct(private  CargarArchivoService $cargarArchivoService, private HistorialAccionService $historialAccionService) {}

    public function listado(): Collection
    {
        $salida_productos = SalidaProducto::select("salida_productos.*")->get();
        return $salida_productos;
    }
    /**
     * Lista de salida_productos paginado con filtros
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
        $salida_productos = SalidaProducto::select("salida_productos.*");

        // Filtros exactos
        foreach ($columnsFilter as $key => $value) {
            if (!is_null($value)) {
                $salida_productos->where("salida_productos.$key", $value);
            }
        }

        // Filtros por rango
        foreach ($columnsBetweenFilter as $key => $value) {
            if (isset($value[0], $value[1])) {
                $salida_productos->whereBetween("salida_productos.$key", $value);
            }
        }

        // Búsqueda en múltiples columnas con LIKE
        if (!empty($search) && !empty($columnsSerachLike)) {
            $salida_productos->where(function ($query) use ($search, $columnsSerachLike) {
                foreach ($columnsSerachLike as $col) {
                    $query->orWhere("$col", "LIKE", "%$search%");
                }
            });
        }

        // Ordenamiento
        foreach ($orderBy as $value) {
            if (isset($value[0], $value[1])) {
                $salida_productos->orderBy($value[0], $value[1]);
            }
        }


        $salida_productos = $salida_productos->paginate($length, ['*'], 'page', $page);
        return $salida_productos;
    }

    /**
     * Crear salida_producto
     *
     * @param array $datos
     * @return SalidaProducto
     */
    public function crear(array $datos): SalidaProducto
    {
        $salida_producto = SalidaProducto::create([
            "nombre" => mb_strtoupper($datos["nombre"]),
            "ventas" => $datos["ventas"],
            "activo" => $datos["activo"],
            "descripcion" => mb_strtoupper($datos["descripcion"]) ?? null,
            "fecha_registro" => date("Y-m-d")
        ]);

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "CREACIÓN", "REGISTRO UNA SUCURSAL", $salida_producto);

        return $salida_producto;
    }

    /**
     * Actualizar salida_producto
     *
     * @param array $datos
     * @param SalidaProducto $salida_producto
     * @return SalidaProducto
     */
    public function actualizar(array $datos, SalidaProducto $salida_producto): SalidaProducto
    {
        $old_salida_producto = clone $salida_producto;

        $salida_producto->update([
            "nombre" => mb_strtoupper($datos["nombre"]),
            "ventas" => $datos["ventas"],
            "activo" => $datos["activo"],
            "descripcion" => mb_strtoupper($datos["descripcion"]) ?? null,
        ]);

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "MODIFICACIÓN", "ACTUALIZÓ UNA SUCURSAL", $old_salida_producto, $salida_producto->withoutRelations());

        return $salida_producto;
    }

    /**
     * Eliminar salida_producto
     *
     * @param SalidaProducto $salida_producto
     * @return boolean
     */
    public function eliminar(SalidaProducto $salida_producto): bool|Exception
    {
        $old_salida_producto = clone $salida_producto;
        $salida_producto->delete();

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "ELIMINACIÓN", "ELIMINÓ UNA SUCURSAL", $old_salida_producto, $salida_producto);

        return true;
    }
}
