<?php

namespace App\Services;

use App\Models\Almacen;
use App\Models\IngresoDetalle;
use App\Services\HistorialAccionService;
use App\Models\IngresoProducto;
use App\Models\IngresoRecepcion;
use App\Models\Producto;
use App\Models\User;
use Illuminate\Http\UploadedFile;
use Exception;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;
use Illuminate\Validation\ValidationException;

class IngresoProductoService
{
    private $modulo = "INGRESO DE PRODUCTOS";

    public function __construct(
        private  CargarArchivoService $cargarArchivoService,
        private HistorialAccionService $historialAccionService,
        private KardexProductoService $kardex_producto_service,
        private MovimientoCajaService $movimiento_caja_service,
        private IngresoFaltanteService $ingreso_faltante_service
    ) {}

    public function listado(): Collection
    {
        $ingreso_productos = IngresoProducto::select("ingreso_productos.*");

        if (Auth::user()->tipo != 'ADMINISTRACIÓN') {
            $ingreso_productos->where("sucursal_id", Auth::user()->sucursal_id);
        }

        $ingreso_productos = $ingreso_productos->get();
        return $ingreso_productos;
    }
    /**
     * Lista de ingreso_productos paginado con filtros
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
        $ingreso_productos = IngresoProducto::with([
            "sucursal:id,nombre",
            "almacen:id,nombre",
            "proveedor:id,nombre",
            "tipo_ingreso:id,nombre",
        ])
            ->select("ingreso_productos.*")
            ->where("status", 1);

        if (Auth::user()->tipo != 'ADMINISTRACIÓN') {
            $ingreso_productos->where("sucursal_id", Auth::user()->sucursal_id);
        }

        // Filtros exactos
        foreach ($columnsFilter as $key => $value) {
            if (!is_null($value)) {
                $ingreso_productos->where("ingreso_productos.$key", $value);
            }
        }

        // Filtros por rango
        foreach ($columnsBetweenFilter as $key => $value) {
            if (isset($value[0], $value[1])) {
                $ingreso_productos->whereBetween("ingreso_productos.$key", $value);
            }
        }

        // Búsqueda en múltiples columnas con LIKE
        if (!empty($search) && !empty($columnsSerachLike)) {
            $ingreso_productos->where(function ($query) use ($search, $columnsSerachLike) {
                foreach ($columnsSerachLike as $col) {
                    $query->orWhere("$col", "LIKE", "%$search%");
                }
            });
        }

        // Ordenamiento
        foreach ($orderBy as $value) {
            if (isset($value[0], $value[1])) {
                $ingreso_productos->orderBy($value[0], $value[1]);
            }
        }


        $ingreso_productos = $ingreso_productos->paginate($length, ['*'], 'page', $page);
        return $ingreso_productos;
    }

    /**
     * Crear ingreso_producto
     *
     * @param array $datos
     * @return IngresoProducto
     */
    public function crear(array $datos): IngresoProducto
    {
        $almacen = Almacen::findOrFail($datos["almacen_id"]);

        $tipo_pago = '';
        if ((float)$datos["cancelado_efectivo"] > 0) {
            $tipo_pago = 'EFECTIVO';
        }
        if ((float)$datos["cancelado_qr"] > 0) {
            $tipo_pago = 'QR';
        }
        if ((float)$datos["cancelado_efectivo"] > 0 && (float)$datos["cancelado_qr"] > 0) {
            $tipo_pago = 'EFECTIVO-QR';
        }

        $total_cancelado = (float)($datos["cancelado_efectivo"] ?? 0) + (float)($datos["cancelado_qr"] ?? 0);

        $ingreso_producto = IngresoProducto::create([
            "codigo" => mb_strtoupper($datos["codigo"]),
            "sucursal_id" => $almacen->sucursal_id,
            "almacen_id" => $almacen->id,
            "tipo_ingreso_id" => $datos["tipo_ingreso_id"],
            "proveedor_id" => $datos["proveedor_id"],
            "descripcion" => mb_strtoupper($datos["descripcion"]) ?? NULL,
            "total" => $datos["total"],
            "cancelado_efectivo" => $datos["cancelado_efectivo"],
            "cancelado_qr" => $datos["cancelado_qr"],
            "total_cancelado" => $total_cancelado,
            "saldo" => $datos["saldo"],
            "tipo_compra" => (float)$datos["saldo"] > 0 ? 'CRÉDITO' : 'CONTADO,',
            "fecha_registro" => date("Y-m-d"),
            "user_id" => Auth::user()->id,
        ]);

        if (!$ingreso_producto->codigo) {
            $ingreso_producto->codigo = $this->generarCodigoIngreso($ingreso_producto->id);
            $ingreso_producto->save();
        }

        foreach ($datos["ingreso_detalles"] as $item) {
            $dato_ingreso_detalle = [
                "ingreso_producto_id" => $ingreso_producto->id,
                "tipo_ingreso_id" => $ingreso_producto->tipo_ingreso_id,
                "producto_id" => $item["producto_id"],
                "cantidad" => $item["cantidad"],
                "verificado" => NULL, // AÚN NO SE VERIFICO
                "faltantes" => NULL, // AÚN NO SE VERIFICO
                "respuesto" => NULL, // AÚN NO SE VERIFICO
                "observacion" => NULL, // AÚN NO SE VERIFICO
                "cantidad_fisica" => NULL, // AÚN NO SE VERIFICO
                "costo" => $item["costo"],
                "subtotal" => $item["subtotal"],
            ];

            $ingreso_detalle = IngresoDetalle::create($dato_ingreso_detalle);

            // $producto = Producto::findOrFail($ingreso_detalle->producto_id);
            // REGISTRAR INGRESO STOCK
            // $this->kardex_producto_service->registrarMovimiento(
            //     $ingreso_producto->sucursal_id,
            //     $ingreso_producto->almacen_id,
            //     "INGRESO DE PRODUCTO",
            //     "INGRESO",
            //     $ingreso_detalle->id,
            //     $producto,
            //     $ingreso_detalle->cantidad,
            //     $ingreso_detalle->costo,
            //     $ingreso_producto->descripcion,
            //     "IngresoDetalle",
            //     $ingreso_detalle->id
            // );
        }

        // REGISTRAR VALOR CANCELADO EN MOVIMIENTO DE CAJAS
        if ((float)$total_cancelado > 0) {
            $movimiento_caja = [
                "sucursal_id" => $ingreso_producto->sucursal_id,
                "almacen_id" => $ingreso_producto->almacen_id,
                "tipo" => "COMPRA DE PRODUCTOS",
                "modulo" => "IngresoProducto",
                "registro_id" => $ingreso_producto->id,
                "monto_efectivo" => $ingreso_producto->cancelado_efectivo,
                "monto_qr" => $ingreso_producto->cancelado_qr,
                "tipo_movimiento" => "EGRESO",
                "tipo_pago" => $tipo_pago,
                "descripcion" => "COMPRA DE PRODUCTOS",
            ];
            $this->movimiento_caja_service->crear($movimiento_caja);
        }

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "CREACIÓN", "REGISTRO UNA INGRESO DE PRODUCTO", $ingreso_producto, null, ["ingreso_detalles"]);
        return $ingreso_producto;
    }

    public function generarCodigoIngreso($id)
    {
        $codigo = "L-" . $id;
        if ($id < 10) {
            $codigo = "L-0000" . $id;
        } elseif ($id < 100) {
            $codigo = "L-000" . $id;
        } elseif ($id < 1000) {
            $codigo = "L-00" . $id;
        } elseif ($id < 10000) {
            $codigo = "L-0" . $id;
        }

        return $codigo;
    }

    public function verificar(array $datos, IngresoProducto $ingreso_producto)
    {
        $count_faltantes = 0;

        $fecha_actual  = date("Y-m-d");
        $hora_actual  = date("H:i:s");
        foreach ($datos["ingreso_detalles"] as $detalle) {
            $producto = Producto::findOrFail($detalle["producto_id"]);
            $total_verificado = 0;
            // recorrer las recepciones
            $array_recepcions = [];
            foreach ($detalle["ingreso_recepcions"] as $key_detalle => $recepcion) {
                $almacen = Almacen::find($recepcion["almacen_id"]);
                if (!$recepcion["cantidad"] || (float)$recepcion["cantidad"] <= 0) {
                    throw new Exception("La cantidad ingresada del producto {$producto->nombre}, en el almacén {$almacen->nombre} es invalida");
                }
                $total_verificado += (float)$recepcion["cantidad"];
                $array_recepcions[] = [
                    "ingreso_producto_id" => $ingreso_producto->id,
                    "ingreso_detalle_id" => $detalle["id"],
                    "sucursal_id" => $almacen->sucursal_id,
                    "almacen_id" => $almacen->id,
                    "producto_id" => $detalle["producto_id"],
                    "cantidad" => $recepcion["cantidad"],
                    "tipo" => "RECEPCION",
                    "fecha" => $fecha_actual,
                    "hora" => $hora_actual,
                    "user_id" => Auth::user()->id
                ];
            }

            $total_faltantes = (float)$detalle["cantidad"] - (float)$total_verificado;
            $total_faltantes = number_format($total_faltantes, 2, ".", "");

            $dato_ingreso_detalle = [
                "verificado" => $total_verificado,
                "faltantes" => $total_faltantes,
                "observacion" => $detalle["observacion"] ?? NULL,
                "cantidad_fisica" => $total_verificado,
            ];

            if ((float)$total_faltantes > 0) {
                $count_faltantes++;
            }

            $ingreso_detalle = IngresoDetalle::findOrFail($detalle["id"]);
            // ACTUALIZAR CANTIDADES DEL DETALLE
            $ingreso_detalle->update($dato_ingreso_detalle);

            // REGISTRAR STOCKS
            foreach ($array_recepcions as $recepcion) {
                $ingreso_recepcion = IngresoRecepcion::create($recepcion);

                $this->kardex_producto_service->registrarMovimiento(
                    $ingreso_recepcion->sucursal_id,
                    $ingreso_recepcion->almacen_id,
                    "INGRESO DE PRODUCTO",
                    "INGRESO",
                    $ingreso_detalle->id,
                    $producto,
                    $ingreso_recepcion->cantidad,
                    $ingreso_detalle->costo,
                    $ingreso_producto->tipo_ingreso->nombre,
                    "IngresoRecepcion",
                    $ingreso_recepcion->id
                );
            }
        }
        $ingreso_producto->estado_faltantes = $count_faltantes > 0 ? 'PENDIENTE' : 'SIN FALTANTES';
        $ingreso_producto->estado_ingreso = 'VERIFICADO';
        $ingreso_producto->save();

        return $ingreso_producto;
    }

    public function faltante(array $datos, IngresoProducto $ingreso_producto)
    {
        $count_faltantes = 0;

        $fecha_actual  = date("Y-m-d");
        $hora_actual  = date("H:i:s");
        foreach ($datos["ingreso_detalles"] as $detalle) {
            $producto = Producto::findOrFail($detalle["producto_id"]);
            $total_verificado = 0;
            // recorrer las recepciones
            $array_recepcions = [];
            if (!isset($detalle["ingreso_recepcions_faltantes"]))
                continue;

            foreach ($detalle["ingreso_recepcions_faltantes"] as $key_detalle => $recepcion) {
                $almacen = Almacen::find($recepcion["almacen_id"]);
                if (!$recepcion["cantidad"] || (float)$recepcion["cantidad"] <= 0) {
                    continue;
                }
                $total_verificado += (float)$recepcion["cantidad"];
                $array_recepcions[] = [
                    "ingreso_producto_id" => $ingreso_producto->id,
                    "ingreso_detalle_id" => $detalle["id"],
                    "sucursal_id" => $almacen->sucursal_id,
                    "almacen_id" => $almacen->id,
                    "producto_id" => $detalle["producto_id"],
                    "cantidad" => $recepcion["cantidad"],
                    "tipo" => "FALTANTE",
                    "fecha" => $fecha_actual,
                    "hora" => $hora_actual,
                ];
            }

            $ingreso_detalle = IngresoDetalle::findOrFail($detalle["id"]);
            $total_repuesto = $total_verificado + (float)$ingreso_detalle->repuesto;

            $total_verificado = (float)$ingreso_detalle->verificado + (float)$total_repuesto;
            $total_faltantes = (float)$ingreso_detalle->cantidad - (float)$total_verificado;
            $total_faltantes = number_format($total_faltantes, 2, ".", "");

            $dato_ingreso_detalle = [
                "faltantes" => $total_faltantes,
                "repuesto" => $total_repuesto,
                "observacion" => $item["observacion"] ?? NULL,
                "cantidad_fisica" => $total_verificado,
            ];
            if ((float)$total_faltantes > 0) {
                $count_faltantes++;
            }

            // ACTUALIZAR CANTIDAD
            $ingreso_detalle->update($dato_ingreso_detalle);

            // REGISTRAR STOCKS
            foreach ($array_recepcions as $recepcion) {
                $ingreso_recepcion = IngresoRecepcion::create($recepcion);

                $this->kardex_producto_service->registrarMovimiento(
                    $ingreso_recepcion->sucursal_id,
                    $ingreso_recepcion->almacen_id,
                    "INGRESO DE PRODUCTO",
                    "INGRESO",
                    $ingreso_detalle->id,
                    $producto,
                    $ingreso_recepcion->cantidad,
                    $ingreso_detalle->costo,
                    $ingreso_producto->tipo_ingreso->nombre,
                    "IngresoRecepcion",
                    $ingreso_recepcion->id
                );
            }

            // HISTORIAL REPOSICIÓN faltantes
            $this->ingreso_faltante_service->crear([
                "ingreso_producto_id" => $ingreso_detalle->ingreso_producto_id,
                "ingreso_detalle_id" => $ingreso_detalle->id,
                "cantidad" => $total_repuesto,
            ]);
        }
        if ($count_faltantes == 0) {
            // VOLVER A VERIFICAR POR CONSULTA
            $count_faltantes = $ingreso_producto->ingreso_detalles_faltantes()->count();
        }
        $ingreso_producto->estado_faltantes = $count_faltantes > 0 ? 'PENDIENTE' : 'COMPLETO';
        $ingreso_producto->save();
    }

    /**
     * Actualizar ingreso_producto
     *
     * @param array $datos
     * @param IngresoProducto $ingreso_producto
     * @return IngresoProducto
     */
    public function actualizar(array $datos, IngresoProducto $ingreso_producto): IngresoProducto
    {
        $old_ingreso_producto = clone $ingreso_producto;
        $old_ingreso_producto->loadMissing(["ingreso_detalles"]);
        $ingreso_producto->update([
            "codigo" => mb_strtoupper($datos["codigo"]),
            "sucursal_id" => $datos["sucursal_id"],
            "tipo_ingreso_id" => $datos["tipo_ingreso_id"],
            "proveedor_id" => $datos["proveedor_id"],
            "descripcion" => mb_strtoupper($datos["descripcion"]) ?? NULL,
            "total" => $datos["total"],
            "cancelado" => $datos["cancelado"],
            "saldo" => $datos["saldo"],
            "user_id" => Auth::user()->id,
        ]);

        if (!$ingreso_producto->codigo) {
            $ingreso_producto->codigo = $this->generarCodigoIngreso($ingreso_producto->id);
            $ingreso_producto->save();
        }

        foreach ($datos["ingreso_detalles"] as $item) {
            $dato_ingreso_detalle = [
                "ingreso_producto_id" => $ingreso_producto->id,
                "tipo_ingreso_id" => $ingreso_producto->tipo_ingreso_id,
                "producto_id" => $item["producto_id"],
                "cantidad" => $item["cantidad"],
                "costo" => $item["costo"],
                "subtotal" => $item["subtotal"],
                "disponible" => $item["cantidad"],
                // "fecha_vencimiento" => $item["fecha_vencimiento"] ?? NULL,
            ];

            $producto = Producto::findOrFail($ingreso_detalle->producto_id);
            if ($item["id"] == 0) {
                $ingreso_detalle = IngresoDetalle::create($dato_ingreso_detalle);
                // REGISTRAR INGRESO STOCK
                $this->kardex_producto_service->registrarMovimiento(
                    $ingreso_producto->sucursal_id,
                    "INGRESO DE PRODUCTO",
                    "INGRESO",
                    $ingreso_detalle->id,
                    $producto,
                    $ingreso_detalle->cantidad,
                    $ingreso_detalle->costo,
                    $ingreso_producto->descripcion,
                    "IngresoDetalle",
                    $ingreso_detalle->id
                );
            } else {
                // descontar stock y actualizar
                $ingreso_detalle = IngresoDetalle::findOrFail($item["id"]);
                if ($ingreso_detalle->cantidad != $ingreso_detalle->disponible) {
                    // se uso un producto del lote no se puede actualizar
                    throw new Exception("No es posible modificar el LOTE " . $ingreso_producto->codigo . " porque ya se utilizó el producto " . $ingreso_detalle->producto->nombre);
                }
                // REGISTRAR EGRESO STOCK
                $this->kardex_producto_service->registrarMovimiento(
                    $ingreso_producto->sucursal_id,
                    "INGRESO DE PRODUCTO",
                    "EGRESO",
                    $ingreso_detalle->id,
                    $producto,
                    $ingreso_detalle->cantidad,
                    $ingreso_detalle->costo,
                    "Egreso por ajuste de Ingreso/Compra de Producto",
                    "IngresoDetalle",
                    $ingreso_detalle->id
                );

                // ACTUALIZAR CANTIDAD
                $ingreso_detalle->update($dato_ingreso_detalle);
                // REGISTRAR INGRESO STOCK
                $this->kardex_producto_service->registrarMovimiento(
                    $ingreso_producto->sucursal_id,
                    "INGRESO DE PRODUCTO",
                    "INGRESO",
                    $ingreso_detalle->id,
                    $producto,
                    $ingreso_detalle->cantidad,
                    $ingreso_detalle->costo,
                    $ingreso_producto->descripcion,
                    "IngresoDetalle",
                    $ingreso_detalle->id
                );
            }
        }


        if (isset($datos["eliminados"]) && count($datos["eliminados"]) > 0) {
            // ELIMINADOS
            foreach ($datos["eliminados"] as $value) {
                $ingreso_detalle = IngresoDetalle::findOrFail($value);
                if ($ingreso_detalle->cantidad != $ingreso_detalle->disponible) {
                    // se uso un producto del lote no se puede actualizar
                    throw new Exception("No es posible eliminar el detalle del LOTE " . $ingreso_detalle->ingreso_producto->codigo . " porque ya se utilizó el producto " . $ingreso_detalle->producto->nombre);
                }

                $producto = Producto::findOrFail($ingreso_detalle->producto_id);
                // REGISTRAR EGRESO STOCK
                $this->kardex_producto_service->registrarMovimiento(
                    $ingreso_detalle->ingreso_producto->sucursal_id,
                    "INGRESO DE PRODUCTO",
                    "EGRESO",
                    $ingreso_detalle->id,
                    $producto,
                    $ingreso_detalle->cantidad,
                    $ingreso_detalle->costo,
                    "Egreso por ajuste de Ingreso/Compra de Producto",
                    "IngresoDetalle",
                    $ingreso_detalle->id
                );
                $ingreso_detalle->delete();
            }
        }

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "MODIFICACIÓN", "ACTUALIZÓ UNA INGRESO DE PRODUCTO", $old_ingreso_producto, $ingreso_producto, ["ingreso_detalles"]);

        return $ingreso_producto;
    }

    /**
     * Eliminar ingreso_producto
     *
     * @param IngresoProducto $ingreso_producto
     * @return boolean
     */
    public function eliminar(IngresoProducto $ingreso_producto): bool|Exception
    {
        $old_ingreso_producto = clone $ingreso_producto;

        foreach ($ingreso_producto->ingreso_detalles as $ingreso_detalle) {
            $ingreso_detalle = IngresoDetalle::findOrFail($ingreso_detalle->id);
            if ($ingreso_detalle->cantidad != $ingreso_detalle->disponible) {
                // se uso un producto del lote no se puede actualizar
                throw new Exception("No es posible eliminar el LOTE " . $ingreso_producto->codigo . " porque ya se utilizó el producto " . $ingreso_detalle->producto->nombre);
            }

            $producto = Producto::findOrFail($ingreso_detalle->producto_id);
            // REGISTRAR EGRESO STOCK
            $this->kardex_producto_service->registrarMovimiento(
                $ingreso_producto->sucursal_id,
                "INGRESO DE PRODUCTO",
                "EGRESO",
                $ingreso_detalle->id,
                $producto,
                $ingreso_detalle->cantidad,
                $ingreso_detalle->costo,
                "Egreso por eliminación de Ingreso/Compra de Producto",
                "IngresoDetalle",
                $ingreso_detalle->id
            );
            $ingreso_detalle->delete();
        }

        $ingreso_producto->status = 0;
        $ingreso_producto->save();

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "ELIMINACIÓN", "ELIMINÓ UNA INGRESO DE PRODUCTO", $old_ingreso_producto, $ingreso_producto, ["ingreso_detalles"]);

        return true;
    }
}
