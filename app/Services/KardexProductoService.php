<?php

namespace App\Services;

use App\Models\DetalleOrden;
use App\Models\IngresoDetalle;
use App\Models\IngresoProducto;
use App\Models\KardexProducto;
use App\Models\Producto;
use App\Models\ProductoSucursal;
use App\Models\SalidaProducto;
use Carbon\Carbon;
use Exception;
use Illuminate\Support\Facades\Log;

class KardexProductoService
{

    public function __construct(private ProductoService $productoService) {}

    /**
     * Registrar el ingreso de un producto en kardex
     *
     * @param integer $sucursal_id
     * @param string $tipo_registro
     * @param string $ingreso_salida (INGRESO/EGRESO)
     * @param integer $ingreso_detalle_id
     * @param Producto $producto
     * @param float $cantidad
     * @param float $precio
     * @param string $detalle
     * @param string $modulo
     * @param integer $registro_id
     * @return $registro_producto
     */
    public function registrarMovimiento(
        int $sucursal_id,
        int $almacen_id,
        string $tipo_registro,
        string $ingreso_salida,
        int $ingreso_detalle_id = NULL,
        Producto $producto,
        float $cantidad,
        float $precio,
        string $detalle = "",
        string $modulo = "",
        int $registro_id = 0
    ): ProductoSucursal {
        //buscar el ultimo registro y usar sus valores
        $ultimo = KardexProducto::where('producto_id', $producto->id)
            ->where("almacen_id", $almacen_id)
            ->where("sucursal_id", $sucursal_id)
            ->where("status", 1);
        $ultimo = $ultimo->orderBy('created_at', 'asc')
            ->get()
            ->last();
        $monto = (float)$cantidad * (float)$precio;
        $fecha_actual = Carbon::now("America/La_Paz")->format("Y-m-d");

        // filtrar tipo
        $cantidad_saldo = 0;

        $datos_movimiento = [
            "sucursal_id" => $sucursal_id,
            "almacen_id" => $almacen_id,
            'tipo_registro' => $tipo_registro, //INGRESO, EGRESO, VENTA, COMPRA,etc...
            'registro_id' => $registro_id != 0 ? $registro_id : NULL,
            "modulo" => $modulo,
            "ingreso_detalle_id" => $ingreso_detalle_id,
            'producto_id' => $producto->id,
            'presentacion_producto_id' => $presentacion_producto_id ?? null,
            'detalle' => $detalle,
            'precio' => $precio,
            'tipo_is' => $ingreso_salida,
            'cantidad_saldo' => 0,
            'cu' => $precio,
            'fecha' => $fecha_actual,
        ];

        if ($ingreso_salida == 'INGRESO') {
            // INGRESO
            if (!$detalle || $detalle == "") {
                $detalle = "INGRESO DE PRODUCTO";
                if ($tipo_registro == "Compra") {
                    $detalle = "COMPRA DE PRODUCTO";
                }
                $datos_movimiento["detalle"] = $detalle;
            }
            if ($ultimo) {
                $cantidad_saldo = (float)$ultimo->cantidad_saldo + (float)$cantidad;
                $monto_saldo = (float)$ultimo->monto_saldo + $monto;
            } else {
                $cantidad_saldo = (float)$cantidad;
                $monto_saldo =  $monto;
            }
            $datos_movimiento["cantidad_ingreso"] = $cantidad;
            $datos_movimiento["monto_ingreso"] = $monto;
        } else {
            // EGRESO
            if (!$detalle || $detalle == "") {
                $detalle = "SALIDA DE PRODUCTO";
                $datos_movimiento["detalle"] = $detalle;
            }
            if ($ultimo) {
                $cantidad_saldo = (float)$ultimo->cantidad_saldo - (float)$cantidad;
                $monto_saldo = (float)$ultimo->monto_saldo - $monto;
            } else {
                throw new Exception("No se encontrarón movimientos para poder registrar un EGRESO");
            }
            $datos_movimiento["cantidad_salida"] = $cantidad;
            $datos_movimiento["monto_salida"] = $monto;
        }

        $datos_movimiento["cantidad_saldo"] = $cantidad_saldo;
        $datos_movimiento["monto_saldo"] = $monto_saldo;

        KardexProducto::create($datos_movimiento);

        $registro_producto = null;
        if ($ingreso_salida == 'INGRESO') {
            // INCREMENTAR STOCK
            // Log::debug("INCREMENTAR STOCK DEL PRODUCTO " . $producto->id . " CANTIDAD: " . $cantidad);
            $registro_producto = $this->productoService->incrementarStock($sucursal_id, $almacen_id, $producto->id, $cantidad);
        } else {
            $registro_producto = $this->productoService->decrementarStock($sucursal_id, $almacen_id, $producto->id, $cantidad);
        }

        return $registro_producto;
    }
}
