<?php

namespace App\Services;

use App\Models\Almacen;
use App\Models\Cliente;
use App\Models\Producto;
use App\Services\HistorialAccionService;
use App\Models\Venta;
use App\Models\User;
use App\Models\VentaDetalle;
use Illuminate\Http\UploadedFile;
use Exception;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;
use Illuminate\Validation\ValidationException;

class VentaService
{
    private $modulo = "VENTAS";

    public function __construct(
        private  CargarArchivoService $cargarArchivoService,
        private HistorialAccionService $historialAccionService,
        private KardexProductoService $kardex_producto_service,
        private ProductoService $producto_service,
        private MovimientoCajaService $movimiento_caja_service
    ) {}

    public function listado($fecha_ini = null, $fecha_fin = null): Collection
    {
        $ventas = Venta::with([
            "sucursal:id,nombre",
            "almacen:id,nombre",
            "cliente.tipo_documento",
            "user:id,nombre,paterno,materno",
        ])
            ->select("ventas.*")
            ->where("status", 1);
        if ($fecha_ini && $fecha_fin) {
            $ventas->whereBetween("fecha_registro", [$fecha_ini, $fecha_fin]);
        }
        $ventas = $ventas->get();
        return $ventas;
    }
    /**
     * Lista de ventas paginado con filtros
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
        $ventas = Venta::with([
            "sucursal:id,nombre",
            "almacen:id,nombre",
            "cliente.tipo_documento",
            "user:id,nombre,paterno,materno",
        ])
            ->select("ventas.*")
            ->where("status", 1);

        // Filtros exactos
        foreach ($columnsFilter as $key => $value) {
            if (!is_null($value)) {
                $ventas->where("ventas.$key", $value);
            }
        }

        // Filtros por rango
        foreach ($columnsBetweenFilter as $key => $value) {
            if (isset($value[0], $value[1])) {
                $ventas->whereBetween("ventas.$key", $value);
            }
        }

        // Búsqueda en múltiples columnas con LIKE
        if (!empty($search) && !empty($columnsSerachLike)) {
            $ventas->where(function ($query) use ($search, $columnsSerachLike) {
                foreach ($columnsSerachLike as $col) {
                    $query->orWhere("$col", "LIKE", "%$search%");
                }
            });
        }

        // Ordenamiento
        foreach ($orderBy as $value) {
            if (isset($value[0], $value[1])) {
                $ventas->orderBy($value[0], $value[1]);
            }
        }


        $ventas = $ventas->paginate($length, ['*'], 'page', $page);
        return $ventas;
    }

    /**
     * Crear venta
     *
     * @param array $datos
     * @return Venta
     */
    public function crear(array $datos): Venta
    {
        $almacen = Almacen::findOrFail($datos["almacen_id"]);
        $cliente = Cliente::findOrFail($datos["cliente_id"]);
        $venta = Venta::create([
            "sucursal_id" => $almacen->sucursal_id,
            "almacen_id" => $almacen->id,
            "cliente_id" => $cliente->id,
            "tipo_documento_id" => $cliente->tipo_documento_id,
            "nit_ci" => $cliente->full_ci,
            "tipo_venta" => mb_strtoupper($datos["tipo_venta"]),
            "tipo_pago" => $datos["tipo_pago"] ?? NULL,
            "subtotal" => $datos["subtotal"],
            "descuento" => $datos["descuento"] ?? 0,
            "porcentaje_descuento" => $datos["porcentaje_descuento"] ?? 0,
            "total" => $datos["total"],
            "cancelado" => $datos["cancelado"],
            "saldo" => $datos["saldo"],
            "fecha" => date("Y-m-d"),
            "hora" => date("H:i:s"),
            "fecha_registro" => date("Y-m-d"),
            "user_id" => Auth::user()->id
        ]);

        $venta->codigo_venta = "V" . $venta->id;

        foreach ($datos["venta_detalles"] as $item) {
            $dato_venta_detalle = [
                "venta_id" => $venta->id,
                "producto_id" => $item["producto_id"],
                "cantidad" => $item["cantidad"],
                "precio" => $item["precio"],
                "precio_descuento" => $item["precio"],
                "descuento" => 0,
                "porcentaje_descuento" => 0,
                "subtotal" => $item["subtotal"],
                "total" => $item["subtotal"],
            ];

            $venta_detalle = VentaDetalle::create($dato_venta_detalle);
            $producto = Producto::findOrFail($venta_detalle->producto_id);


            // VERIFICAR STOCK
            $verifica_stock = $this->producto_service->verificaStockCantidad($venta->sucursal_id, $venta->almacen_id, $producto->id, $item["cantidad"]);

            if (!$verifica_stock[0]) {
                throw new Exception("Stock insuficiente para el producto $producto->nombre. Disponible: $verifica_stock[1]");
            }

            // REGISTRAR EGRESO STOCK
            $this->kardex_producto_service->registrarMovimiento(
                $venta->sucursal_id,
                $venta->almacen_id,
                "VENTA DE PRODUCTO",
                "EGRESO",
                NULL,
                $producto,
                $venta_detalle->cantidad,
                $venta_detalle->precio_descuento,
                "SALIDA POR VENTA",
                "VentaDetalle",
                $venta_detalle->id
            );
        }

        // MOVIMIENTO CAJA
        if ($venta->cancelado > 0) {
            $movimiento_caja = [
                "sucursal_id" => $venta->sucursal_id,
                "almacen_id" => $venta->almacen_id,
                "tipo" => "VENTA",
                "modulo" => "Venta",
                "registro_id" => $venta->id,
                "monto" => $venta->cancelado,
                "tipo_movimiento" => "INGRESO",
                "tipo_pago" => $venta->tipo_pago,
                "descripcion" => "INGRESO POR VENTA",
                "fecha" => $venta->fecha,
                "hora" => $venta->hora,
            ];
            $this->movimiento_caja_service->crear($movimiento_caja);
        }

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "CREACIÓN", "REGISTRO UNA VENTA", $venta, null, ["venta_detalles"]);

        return $venta;
    }

    /**
     * Actualizar venta
     *
     * @param array $datos
     * @param Venta $venta
     * @return Venta
     */
    public function actualizar(array $datos, Venta $venta): Venta
    {
        $old_venta = clone $venta;

        $venta->update([
            "nombre" => mb_strtoupper($datos["nombre"]),
            "ventas" => $datos["ventas"],
            "activo" => $datos["activo"],
            "descripcion" => mb_strtoupper($datos["descripcion"]) ?? null,
        ]);

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "MODIFICACIÓN", "ACTUALIZÓ UNA VENTA", $old_venta, $venta->withoutRelations(), ["venta_detalles"]);

        return $venta;
    }

    /**
     * Eliminar venta
     *
     * @param Venta $venta
     * @return boolean
     */
    public function eliminar(Venta $venta): bool|Exception
    {
        $old_venta = clone $venta;

        $venta->status = 0;
        $venta->save();

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "ELIMINACIÓN", "ELIMINÓ UNA VENTA", $old_venta, $venta, ["venta_detalles"]);

        return true;
    }
}
