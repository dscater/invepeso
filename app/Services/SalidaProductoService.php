<?php

namespace App\Services;

use App\Models\Almacen;
use App\Models\Producto;
use App\Models\SalidaDetalle;
use App\Services\HistorialAccionService;
use App\Models\SalidaProducto;
use App\Models\TipoSalida;
use App\Models\User;
use Illuminate\Http\UploadedFile;
use Exception;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;
use Illuminate\Validation\ValidationException;

class SalidaProductoService
{
    private $modulo = "SALIDA DE PRODUCTOS";

    public function __construct(
        private  CargarArchivoService $cargarArchivoService,
        private HistorialAccionService $historialAccionService,
        private KardexProductoService $kardex_producto_service
    ) {}

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
        $salida_productos = SalidaProducto::with([
            "sucursal:id,nombre",
            "almacen:id,nombre",
            "tipo_salida:id,nombre"
        ])
            ->select("salida_productos.*");

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
        $almacen = Almacen::findOrFail($datos["almacen_id"]);
        $salida_producto = SalidaProducto::create([
            "sucursal_id" => $almacen->sucursal_id,
            "almacen_id" => $almacen->id,
            "tipo_salida_id" => $datos["tipo_salida_id"],
            "cantidad" => $datos["cantidad"],
            "descripcion" => mb_strtoupper($datos["descripcion"]) ?? NULL,
            "fecha_registro" => date("Y-m-d"),
            "user_id" => Auth::user()->id,
        ]);

        foreach ($datos["salida_detalles"] as $item) {
            $dato_salida_detalle = [
                "salida_producto_id" => $salida_producto->id,
                "tipo_salida_id" => $item["tipo_salida_id"],
                "producto_id" => $item["producto_id"],
                "cantidad" => $item["cantidad"],
            ];

            $salida_detalle = SalidaDetalle::create($dato_salida_detalle);
            $producto = Producto::findOrFail($salida_detalle->producto_id);
            $tipo_salida = TipoSalida::findOrFail($salida_detalle->tipo_salida_id);
            // REGISTRAR EGRESO STOCK
            $this->kardex_producto_service->registrarMovimiento(
                $salida_producto->sucursal_id,
                $salida_producto->almacen_id,
                "SALIDA DE PRODUCTO",
                "EGRESO",
                $salida_detalle->id,
                $producto,
                $salida_detalle->cantidad,
                $producto->precio_compra,
                $tipo_salida->nombre,
                "SalidaDetalle",
                $salida_detalle->id
            );
        }

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "CREACIÓN", "REGISTRO UNA SALIDA DE PRODUCTOS", $salida_producto, null, ["salida_detalles"]);

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
        $this->historialAccionService->registrarAccion($this->modulo, "MODIFICACIÓN", "ACTUALIZÓ UNA SALIDA DE PRODUCTOS", $old_salida_producto, $salida_producto->withoutRelations());

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
        $this->historialAccionService->registrarAccion($this->modulo, "ELIMINACIÓN", "ELIMINÓ UNA SALIDA DE PRODUCTOS", $old_salida_producto, $salida_producto);

        return true;
    }
}
