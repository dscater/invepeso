<?php

namespace App\Services;

use App\Models\Almacen;
use App\Models\Cliente;
use App\Models\MovimientoCaja;
use App\Models\Producto;
use App\Services\HistorialAccionService;
use App\Models\Venta;
use App\Models\User;
use App\Models\VentaCobro;
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

    public function listadoPaginadoEliminados(int $length, int $page, string $search, array $columnsSerachLike = [], array $columnsFilter = [], array $columnsBetweenFilter = [], array $orderBy = []): LengthAwarePaginator
    {
        $ventas = Venta::with([
            "sucursal:id,nombre",
            "almacen:id,nombre",
            "cliente.tipo_documento",
            "user:id,nombre,paterno,materno",
        ])
            ->select("ventas.*")
            ->where("status", 0);

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

        if ($datos["tipo_venta"] == 'AL CONTADO') {
            if ((float)$datos["total"] != (float)$datos["cancelado"] || $datos["saldo"] > 0) {
                throw new Exception("El monto cancelado debe ser igual al total y el saldo debe ser 0");
            }
        }

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
        $venta->save();
        foreach ($datos["venta_detalles"] as $item) {
            $datos_venta_detalle = [
                "venta_id" => $venta->id,
                "producto_id" => $item["producto_id"],
                "cantidad" => $item["cantidad"],
                "precio" => $item["precio"],
                "descuento_uni" => $item["descuento_uni"],
                "porcen_du" => $item["porcen_du"],
                "descuento_total" => $item["descuento_total"],
                "porcen_dt" => $item["porcen_dt"],
                "precio_final" => $item["precio_final"],
                "total" => $item["total"],
                "total_uni" => $item["total_uni"],
            ];

            $venta_detalle = VentaDetalle::create($datos_venta_detalle);
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
                $venta_detalle->precio_final,
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
        $old_venta = $old_venta->loadMissing(["venta_detalles"]);

        $almacen = Almacen::findOrFail($datos["almacen_id"]);
        $cliente = Cliente::findOrFail($datos["cliente_id"]);

        // verificar cobros por venta
        if ($old_venta->tipo_venta == 'CRÉDITO') {
            $cobros = VentaCobro::where("venta_id", $venta->id)->count();
            if ($cobros > 0) {
                throw new Exception("No se puede eliminar la venta $venta->codigo_venta; porque tiene $cobros registrados");
            }
        }

        if ($datos["tipo_venta"] == 'AL CONTADO') {
            if ((float)$datos["total"] != (float)$datos["cancelado"] || $datos["saldo"] > 0) {
                throw new Exception("El monto cancelado debe ser igual al total y el saldo debe ser 0");
            }
        }

        $venta->update([
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
        ]);

        foreach ($datos["venta_detalles"] as $item) {
            $datos_venta_detalle = [
                "venta_id" => $venta->id,
                "producto_id" => $item["producto_id"],
                "cantidad" => $item["cantidad"],
                "precio" => $item["precio"],
                "descuento_uni" => $item["descuento_uni"],
                "porcen_du" => $item["porcen_du"],
                "descuento_total" => $item["descuento_total"],
                "porcen_dt" => $item["porcen_dt"],
                "precio_final" => $item["precio_final"],
                "total" => $item["total"],
                "total_uni" => $item["total_uni"],
            ];

            $producto = Producto::findOrFail($item["producto_id"]);
            if ($item["id"] == 0) {
                // CREAR
                $venta_detalle = VentaDetalle::create($datos_venta_detalle);
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
                    $venta_detalle->precio_final,
                    "SALIDA POR VENTA",
                    "VentaDetalle",
                    $venta_detalle->id
                );
            } else {
                $venta_detalle = VentaDetalle::findOrFail($item["id"]);
                // REGISTRAR INGRESO STOCK POR MODIFICACIÓN $old_venta
                $this->kardex_producto_service->registrarMovimiento(
                    $old_venta->sucursal_id,
                    $old_venta->almacen_id,
                    "VENTA DE PRODUCTO",
                    "INGRESO",
                    NULL,
                    $producto,
                    $venta_detalle->cantidad,
                    $venta_detalle->precio_final,
                    "INGRESO POR MODIFICACIÓN DE VENTA",
                    "VentaDetalle",
                    $venta_detalle->id,
                );

                $venta_detalle->update($datos_venta_detalle);

                // REGISTRAR EGRESO STOCK
                $this->kardex_producto_service->registrarMovimiento(
                    $venta->sucursal_id,
                    $venta->almacen_id,
                    "VENTA DE PRODUCTO",
                    "EGRESO",
                    NULL,
                    $producto,
                    $venta_detalle->cantidad,
                    $venta_detalle->precio_final,
                    "SALIDA POR VENTA",
                    "VentaDetalle",
                    $venta_detalle->id
                );
            }
        }

        // ELIMINADOS
        if (isset($datos["eliminados"])) {
            foreach ($datos["eliminados"] as $id) {
                $venta_detalle = VentaDetalle::findOrFail($id);
                // REGISTRAR INGRESO STOCK POR ELIMINACIÓN
                $this->kardex_producto_service->registrarMovimiento(
                    $old_venta->sucursal_id,
                    $old_venta->almacen_id,
                    "VENTA DE PRODUCTO",
                    "INGRESO",
                    NULL,
                    $producto,
                    $venta_detalle->cantidad,
                    $venta_detalle->precio_final,
                    "INGRESO POR MODIFICACIÓN DE VENTA",
                    "VentaDetalle",
                    $venta_detalle->id,
                );
                // $venta_detalle->status = 0;
                $venta_detalle->delete();
            }
        }

        // SI TIENE MOVIMIENTO DE CAJA ELIMINARLO Y REGISTRAR CON LOS NUEVOS DATOS
        $movimiento_caja = MovimientoCaja::where("sucursal_id", $old_venta->sucursal_id)
            ->where("almacen_id", $old_venta->almacen_id)
            ->where("tipo", "VENTA")
            ->where("modulo", "Venta")
            ->where("registro_id", $venta->id)
            ->get()->first();

        if ($movimiento_caja) {
            $movimiento_caja->status = 0;
            $movimiento_caja->save();
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
        $this->historialAccionService->registrarAccion($this->modulo, "MODIFICACIÓN", "ACTUALIZÓ UNA VENTA", $old_venta, $venta->withoutRelations(), ["venta_detalles"]);

        return $venta;
    }

    public function restaurar(Venta $venta): bool|Exception
    {
        $old_venta = clone $venta;
        // verificar cobros por venta
        $cobros = VentaCobro::where("venta_id", $venta->id)->count();
        $cobros = VentaCobro::where("venta_id", $venta->id)->count();
        if ($cobros > 0) {
            foreach ($cobros as $item) {
                // SI TIENE MOVIMIENTO DE CAJA ELIMINARLO Y REGISTRAR CON LOS NUEVOS DATOS
                $movimiento_caja = MovimientoCaja::where("sucursal_id", $old_venta->sucursal_id)
                    ->where("almacen_id", $old_venta->almacen_id)
                    ->where("tipo", "COBRO POR VENTA DE PRODUCTOS")
                    ->where("modulo", "VentaCobro")
                    ->where("registro_id", $item->id)
                    ->get()->first();

                $movimiento_caja->status = 1;
                $movimiento_caja->save();
            }
        }
        foreach ($venta->venta_detalles as $venta_detalle) {
            $venta_detalle = VentaDetalle::findOrFail($venta_detalle->id);
            $producto = Producto::findOrFail($venta_detalle->producto_id);
            // REGISTRAR EGRESO STOCK POR ELIMINACIÓN
            $this->kardex_producto_service->registrarMovimiento(
                $old_venta->sucursal_id,
                $old_venta->almacen_id,
                "VENTA DE PRODUCTO",
                "EGRESO",
                NULL,
                $producto,
                $venta_detalle->cantidad,
                $venta_detalle->precio_final,
                "EGRESO POR RESTAURACIÓN DE VENTA",
                "VentaDetalle",
                $venta_detalle->id,
            );
            $venta_detalle->status = 1;
            $venta_detalle->save();
        }

        // SI TIENE MOVIMIENTO DE CAJA ELIMINARLO Y REGISTRAR CON LOS NUEVOS DATOS
        $movimiento_caja = MovimientoCaja::where("sucursal_id", $old_venta->sucursal_id)
            ->where("almacen_id", $old_venta->almacen_id)
            ->where("tipo", "VENTA")
            ->where("modulo", "Venta")
            ->where("registro_id", $venta->id)
            ->get()->first();

        if ($movimiento_caja) {
            $movimiento_caja->status = 1;
            $movimiento_caja->save();
        }

        $venta->status = 1;
        $venta->save();

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "ELIMINACIÓN", "RESTAURÓ UNA VENTA", $old_venta, $venta, ["venta_detalles"]);

        return true;
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
        // verificar cobros por venta
        $cobros = VentaCobro::where("venta_id", $venta->id)->count();
        if ($cobros > 0) {
            throw new Exception("No se puede eliminar la venta $venta->codigo_venta; porque tiene $cobros registrados");
        }
        foreach ($venta->venta_detalles as $venta_detalle) {
            $venta_detalle = VentaDetalle::findOrFail($venta_detalle->id);
            $producto = Producto::findOrFail($venta_detalle->producto_id);
            // REGISTRAR INGRESO STOCK POR ELIMINACIÓN
            $this->kardex_producto_service->registrarMovimiento(
                $old_venta->sucursal_id,
                $old_venta->almacen_id,
                "VENTA DE PRODUCTO",
                "INGRESO",
                NULL,
                $producto,
                $venta_detalle->cantidad,
                $venta_detalle->precio_final,
                "INGRESO POR ELIMINACIÓN DE VENTA",
                "VentaDetalle",
                $venta_detalle->id,
            );
            $venta_detalle->status = 0;
            $venta_detalle->save();
        }

        // SI TIENE MOVIMIENTO DE CAJA ELIMINARLO Y REGISTRAR CON LOS NUEVOS DATOS
        $movimiento_caja = MovimientoCaja::where("sucursal_id", $old_venta->sucursal_id)
            ->where("almacen_id", $old_venta->almacen_id)
            ->where("tipo", "VENTA")
            ->where("modulo", "Venta")
            ->where("registro_id", $venta->id)
            ->get()->first();

        if ($movimiento_caja) {
            $movimiento_caja->status = 0;
            $movimiento_caja->save();
        }

        $venta->status = 0;
        $venta->save();

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "ELIMINACIÓN", "ELIMINÓ UNA VENTA", $old_venta, $venta, ["venta_detalles"]);

        return true;
    }

    public function eliminar_permanente(Venta $venta): bool|Exception
    {
        $old_venta = clone $venta;
        $old_venta = $old_venta->loadMissing(["venta_detalles"]);
        // verificar cobros por venta
        $cobros = VentaCobro::where("venta_id", $venta->id)->count();
        if ($cobros > 0) {
            foreach ($cobros as $item) {
                // SI TIENE MOVIMIENTO DE CAJA ELIMINARLO Y REGISTRAR CON LOS NUEVOS DATOS
                $movimiento_caja = MovimientoCaja::where("sucursal_id", $old_venta->sucursal_id)
                    ->where("almacen_id", $old_venta->almacen_id)
                    ->where("tipo", "COBRO POR VENTA DE PRODUCTOS")
                    ->where("modulo", "VentaCobro")
                    ->where("registro_id", $item->id)
                    ->get()->first();

                $movimiento_caja->delete();
                $item->delete();
            }
        }

        foreach ($venta->venta_detalles_todos as $venta_detalle) {
            $venta_detalle = VentaDetalle::findOrFail($venta_detalle->id);
            $venta_detalle->delete();
        }

        // SI TIENE MOVIMIENTO DE CAJA ELIMINARLO Y REGISTRAR CON LOS NUEVOS DATOS
        $movimiento_caja = MovimientoCaja::where("sucursal_id", $old_venta->sucursal_id)
            ->where("almacen_id", $old_venta->almacen_id)
            ->where("tipo", "VENTA")
            ->where("modulo", "Venta")
            ->where("registro_id", $venta->id)
            ->get()->first();

        if ($movimiento_caja) {
            $movimiento_caja->delete();
        }

        $venta->delete();

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "ELIMINACIÓN", "ELIMINÓ PERMANENTEMENTE UNA VENTA", $old_venta, null, ["venta_detalles"]);

        return true;
    }
}
