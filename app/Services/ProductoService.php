<?php

namespace App\Services;

use App\Models\IngresoDetalle;
use App\Services\HistorialAccionService;
use App\Models\Producto;
use App\Models\ProductoSucursal;
use App\Models\SalidaProducto;
use App\Models\User;
use App\Models\VentaDetalle;
use App\Models\VentaDetalleLote;
use Illuminate\Http\UploadedFile;
use Exception;
use Illuminate\Container\Attributes\Auth;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Support\Facades\Log;
use Illuminate\Validation\ValidationException;

class ProductoService
{
    private $modulo = "PRODUCTOS";

    public function __construct(private  CargarArchivoService $cargarArchivoService, private HistorialAccionService $historialAccionService) {}

    public function listado($activo = null): Collection
    {
        $productos = Producto::select("productos.*")
            ->with(["marca:id,nombre", "categoria:id,nombre"]);
        if ($activo && $activo == 1) {
            $productos->where("activo", 1);
        }

        $productos = $productos->get();
        return $productos;
    }
    /**
     * Lista de productos paginado con filtros
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
        $productos = Producto::select("productos.*")
            ->with(["categoria", "marca", "unidad_medida"]);

        // Filtros exactos
        foreach ($columnsFilter as $key => $value) {
            if (!is_null($value)) {
                $productos->where("productos.$key", $value);
            }
        }

        // Filtros por rango
        foreach ($columnsBetweenFilter as $key => $value) {
            if (isset($value[0], $value[1])) {
                $productos->whereBetween("productos.$key", $value);
            }
        }

        // Búsqueda en múltiples columnas con LIKE
        if (!empty($search) && !empty($columnsSerachLike)) {
            $productos->where(function ($query) use ($search, $columnsSerachLike) {
                foreach ($columnsSerachLike as $col) {
                    $query->orWhere("$col", "LIKE", "%$search%");
                }
            });
        }

        // Ordenamiento
        foreach ($orderBy as $value) {
            if (isset($value[0], $value[1])) {
                $productos->orderBy($value[0], $value[1]);
            }
        }


        $productos = $productos->paginate($length, ['*'], 'page', $page);
        return $productos;
    }

    /**
     * Crear producto
     *
     * @param array $datos
     * @return Producto
     */
    public function crear(array $datos): Producto
    {
        $producto = Producto::create([
            "codigo" => mb_strtoupper($datos["codigo"]),
            "nombre" => mb_strtoupper($datos["nombre"]),
            "categoria_id" => $datos["categoria_id"],
            "marca_id" => $datos["marca_id"],
            "unidad_medida_id" => $datos["unidad_medida_id"],
            "precio" => $datos["precio"],
            "precio2" => $datos["precio2"],
            "precio3" => $datos["precio3"],
            "precio4" => $datos["precio4"],
            "precio_compra" => $datos["precio_compra"],
            "stock_min" => $datos["stock_min"],
            "activo" => $datos["activo"],
            // "descripcion" => mb_strtoupper($datos["descripcion"]) ?? null,
            "fecha_registro" => date("Y-m-d")
        ]);

        // cargar imagen
        if (isset($datos["imagen"]) && !is_string($datos["imagen"])) {
            $this->cargarImagen($producto, $datos["imagen"]);
        }

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "CREACIÓN", "REGISTRO UNA PRODUCTO", $producto);

        return $producto;
    }

    /**
     * Actualizar producto
     *
     * @param array $datos
     * @param Producto $producto
     * @return Producto
     */
    public function actualizar(array $datos, Producto $producto): Producto
    {
        $old_producto = clone $producto;

        $producto->update([
            "codigo" => mb_strtoupper($datos["codigo"]),
            "nombre" => mb_strtoupper($datos["nombre"]),
            "categoria_id" => $datos["categoria_id"],
            "marca_id" => $datos["marca_id"],
            "unidad_medida_id" => $datos["unidad_medida_id"],
            "precio" => $datos["precio"],
            "precio2" => $datos["precio2"],
            "precio3" => $datos["precio3"],
            "precio4" => $datos["precio4"],
            "precio_compra" => $datos["precio_compra"],
            "stock_min" => $datos["stock_min"],
            "activo" => $datos["activo"],
        ]);

        // cargar imagen
        if (isset($datos["imagen"]) && !is_string($datos["imagen"])) {
            $this->cargarImagen($producto, $datos["imagen"]);
        }

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "MODIFICACIÓN", "ACTUALIZÓ UNA PRODUCTO", $old_producto, $producto->withoutRelations());

        return $producto;
    }

    /**
     * Cargar imagen
     *
     * @param Producto $producto
     * @param UploadedFile $imagen
     * @return void
     */
    public function cargarImagen(Producto $producto, UploadedFile $imagen): void
    {
        if ($producto->imagen) {
            \File::delete(public_path("imgs/productos/" . $producto->imagen));
        }

        $nombre = $producto->id . time();
        $producto->imagen = $this->cargarArchivoService->cargarArchivo($imagen, public_path("imgs/productos"), $nombre);
        $producto->save();
    }

    /**
     * Eliminar producto
     *
     * @param Producto $producto
     * @return boolean
     */
    public function eliminar(Producto $producto): bool|Exception
    {
        $old_producto = clone $producto;

        $usos = IngresoDetalle::where("producto_id")->count();
        if ($usos > 0) {
            throw new Exception("No se puede eliminar este producto porque está siendo utilizado por $usos ingreso de productos.");
        }

        $usos = SalidaProducto::where("producto_id")->count();
        if ($usos > 0) {
            throw new Exception("No se puede eliminar este producto porque está siendo utilizado por $usos salida de productos.");
        }

        $usos = VentaDetalle::where("producto_id")->count();
        if ($usos > 0) {
            throw new Exception("No se puede eliminar este producto porque está siendo utilizado por $usos ventas.");
        }

        $usos = VentaDetalleLote::where("producto_id")->count();
        if ($usos > 0) {
            throw new Exception("No se puede eliminar este producto porque está siendo utilizado por $usos ventas.");
        }

        $producto->delete();

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "ELIMINACIÓN", "ELIMINÓ UNA PRODUCTO", $old_producto, $producto);

        return true;
    }

    public function incrementarStock(int $sucursal_id, int $almacen_id, int $producto_id, int $cantidad = 1)
    {
        $producto = ProductoSucursal::where("producto_id", $producto_id)
            ->where("sucursal_id", $sucursal_id)
            ->where("almacen_id", $almacen_id)
            ->get()
            ->first();

        if (!$producto) {
            $producto = ProductoSucursal::create([
                "sucursal_id" => $sucursal_id,
                "almacen_id" => $almacen_id,
                "producto_id" => $producto_id,
                "stock_actual" => 0,
            ]);
        }

        $producto->stock_actual = (float)$producto->stock_actual + $cantidad;
        $producto->save();
        return $producto;
    }
    public function decrementarStock(int $sucursal_id, int $almacen_id, int $producto_id, int $cantidad = 1)
    {
        $producto = ProductoSucursal::where("producto_id", $producto_id)
            ->where("sucursal_id", $sucursal_id)
            ->where("almacen_id", $almacen_id)
            ->get()
            ->first();
        // validar stock
        if (!$this->verificaStock($sucursal_id, $almacen_id, $producto_id, $cantidad)) {
            throw new Exception("Stock insuficiente del producto " . $producto->nombre . ", disponible " . $producto->stock_actual);
        }

        $producto->stock_actual = (float)$producto->stock_actual - $cantidad;
        $producto->save();

        return $producto;
    }

    // stock_actual
    public function verificaStock($sucursal_id, $almacen_id, $producto_id, $cantidad): bool
    {
        $producto = ProductoSucursal::where("producto_id", $producto_id)
            ->where("sucursal_id", $sucursal_id)
            ->where("almacen_id", $almacen_id)
            ->get()
            ->first();


        Log::debug("producto:");
        Log::debug($producto);

        $disponible = false;
        if ($producto->stock_actual >= $cantidad) {
            $disponible = true;
        }

        return $disponible;
    }

    // stock_actual
    public function verificaStockCantidad($sucursal_id, $almacen_id, $producto_id, $cantidad): array
    {
        $producto = ProductoSucursal::where("producto_id", $producto_id)
            ->where("sucursal_id", $sucursal_id)
            ->where("almacen_id", $almacen_id)
            ->get()
            ->first();
        $disponible = false;
        if ($producto->stock_actual >= $cantidad) {
            $disponible = true;
        }

        return [$disponible, $producto->stock_actual];
    }

    // stock_actual
    public function validaStockCantidad($sucursal_id, $almacen_id, $producto_id, $cantidad)
    {
        $producto = ProductoSucursal::where("producto_id", $producto_id)
            ->where("sucursal_id", $sucursal_id)
            ->where("almacen_id", $almacen_id)
            ->get()
            ->first();
        $disponible = false;
        if ($producto->stock_actual >= $cantidad) {
            $disponible = true;
        }
        if (!$disponible) {
            throw new Exception("Stock insuficiente del producto $producto->nombre, stock actual " . $producto->stock_actual, 422);
        }
        return true;
    }

    // // cantidad disponible
    // // VERIFICAR EN UNA TABLA DONDE SE GUARDAN MOVIMIENTOS ACTUALES COMO VENTAS
    // // TODO: modificar y aplicar
    // public function verificaStockDisponible($sucursal_id, $almacen_id, $producto_id, $cantidad, $pedido_id = 0): array
    // {
    //     $producto = ProductoSucursal::where("producto_id", $producto_id)
    //         ->where("sucursal_id", $sucursal_id)
    //         ->where("almacen_id", $almacen_id)
    //         ->get()
    //         ->first();
    //     $disponible = false;
    //     $c_pedidos_pendientes = PedidoDetalle::where("producto_id", $producto_id)
    //         ->whereHas("pedido", function ($q) use ($pedido_id) {
    //             $q->where("estado", "PENDIENTE");
    //             $q->where("status", 1);
    //             if ($pedido_id != 0) {
    //                 $q->where("id", "!=", $pedido_id);
    //             }
    //         })->sum("cantidad_total");

    //     $stock_disponible = (float)$producto->stock_actual - (float)$c_pedidos_pendientes;

    //     if ($stock_disponible >= $cantidad) {
    //         $disponible = true;
    //     }

    //     return [$disponible, $stock_disponible];
    // }
}
