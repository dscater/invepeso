<?php

namespace App\Services;

use App\Services\HistorialAccionService;
use App\Models\IngresoPago;
use App\Models\IngresoProducto;
use App\Models\MovimientoCaja;
use App\Models\Producto;
use App\Models\User;
use Illuminate\Http\UploadedFile;
use Exception;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\ValidationException;

class IngresoPagoService
{
    private $modulo = "PAGOS DE INGRESO DE PRODUCTOS";

    public function __construct(
        private  CargarArchivoService $cargarArchivoService,
        private HistorialAccionService $historialAccionService,
        private MovimientoCajaService $movimiento_caja_service
    ) {}

    public function listado($ingreso_producto_id = null): Collection
    {
        $ingreso_pagos = IngresoPago::with([
            "sucursal:id,nombre",
            "almacen:id,nombre",
            "proveedor:id,nombre",
            "user:id,nombre,paterno,materno",
        ])
            ->select("ingreso_pagos.*");
        if ($ingreso_producto_id) {
            $ingreso_pagos->where("ingreso_producto_id", $ingreso_producto_id);
        }
        $ingreso_pagos = $ingreso_pagos->get();
        return $ingreso_pagos;
    }
    /**
     * Lista de ingreso_pagos paginado con filtros
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
        $ingreso_pagos = IngresoPago::select("ingreso_pagos.*");

        // Filtros exactos
        foreach ($columnsFilter as $key => $value) {
            if (!is_null($value)) {
                $ingreso_pagos->where("ingreso_pagos.$key", $value);
            }
        }

        // Filtros por rango
        foreach ($columnsBetweenFilter as $key => $value) {
            if (isset($value[0], $value[1])) {
                $ingreso_pagos->whereBetween("ingreso_pagos.$key", $value);
            }
        }

        // Búsqueda en múltiples columnas con LIKE
        if (!empty($search) && !empty($columnsSerachLike)) {
            $ingreso_pagos->where(function ($query) use ($search, $columnsSerachLike) {
                foreach ($columnsSerachLike as $col) {
                    $query->orWhere("$col", "LIKE", "%$search%");
                }
            });
        }

        // Ordenamiento
        foreach ($orderBy as $value) {
            if (isset($value[0], $value[1])) {
                $ingreso_pagos->orderBy($value[0], $value[1]);
            }
        }


        $ingreso_pagos = $ingreso_pagos->paginate($length, ['*'], 'page', $page);
        return $ingreso_pagos;
    }

    /**
     * Crear ingreso_pago
     *
     * @param array $datos
     * @return IngresoPago
     */
    public function crear(array $datos): IngresoPago
    {
        $ingreso_pago = IngresoPago::create([
            "sucursal_id" => $datos["sucursal_id"],
            "almacen_id" => $datos["almacen_id"],
            "ingreso_producto_id" => $datos["ingreso_producto_id"],
            "proveedor_id" => $datos["proveedor_id"],
            "monto" => $datos["monto"],
            "fecha" => date("Y-m-d"),
            "hora" => date("H:i:s"),
            "user_id" => Auth::user()->id,
        ]);

        $ingreso_producto = IngresoProducto::findOrFail($ingreso_pago->ingreso_producto_id);
        if ((float)$ingreso_pago->monto > (float)$ingreso_producto->saldo) {
            throw new Exception("El monto cancelado no puede ser mayor al saldo actual de $ingreso_producto->saldo");
        }

        // EGRESO CAJA
        $movimiento_caja = [
            "sucursal_id" => $ingreso_pago->sucursal_id,
            "almacen_id" => $ingreso_pago->almacen_id,
            "tipo" => "PAGO POR COMPRA DE PRODUCTOS",
            "modulo" => "IngresoPago",
            "registro_id" => $ingreso_pago->id,
            "monto" => $ingreso_pago->monto,
            "tipo_movimiento" => "EGRESO",
            "tipo_pago" => "EFECTIVO",
            "descripcion" => "PAGO POR COMPRA DE PRODUCTOS",
        ];

        // SALDO
        $ingreso_producto->saldo = (float)$ingreso_producto->saldo - (float)$ingreso_pago->monto;
        $ingreso_producto->save();
        if ($ingreso_producto->saldo < 0) {
            throw new Exception("No se pudo realizar el registro por que el saldo calculado es menor a 0");
        }

        $this->movimiento_caja_service->crear($movimiento_caja);

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "CREACIÓN", "REGISTRO UN PAGO POR COMPRA DE PRODUCTOS", $ingreso_pago);

        return $ingreso_pago;
    }

    /**
     * Actualizar ingreso_pago
     *
     * @param array $datos
     * @param IngresoPago $ingreso_pago
     * @return IngresoPago
     */
    public function actualizar(array $datos, IngresoPago $ingreso_pago): IngresoPago
    {
        $old_ingreso_pago = clone $ingreso_pago;

        $ingreso_pago->update([
            "sucursal_id" => $datos["sucursal_id"],
            "almacen_id" => $datos["almacen_id"],
            "ingreso_producto_id" => $datos["ingreso_producto_id"],
            "proveedor_id" => $datos["proveedor_id"],
            "monto" => $datos["monto"],
            // "fecha" => date("Y-m-d"),
            // "hora" => date("H:i:s"),
            // "user_id" => Auth::user()->id,
        ]);
        $cancelado = $ingreso_pago->ingreso_producto->cancelado;
        $monto_total_cancelado = IngresoPago::where("id", "!=", $ingreso_pago->id)
            ->where("ingreso_producto_id", $ingreso_pago->ingreso_producto_id)
            ->sum("monto");
        $monto_total_cancelado = (float)$monto_total_cancelado + (float)$ingreso_pago->monto + $cancelado;

        $ingreso_producto = IngresoProducto::findOrFail($ingreso_pago->ingreso_producto_id);
        if ((float)$monto_total_cancelado > (float)$ingreso_pago->ingreso_producto->total) {
            throw new Exception("El monto cancelado no puede ser mayor al total de la compra " . $ingreso_pago->ingreso_producto->total);
        }

        // DATOS CAJA
        $datos_movimiento_caja = [
            "sucursal_id" => $ingreso_pago->sucursal_id,
            "almacen_id" => $ingreso_pago->almacen_id,
            "tipo" => "PAGO POR COMPRA DE PRODUCTOS",
            "modulo" => "IngresoPago",
            "registro_id" => $ingreso_pago->id,
            "monto" => $ingreso_pago->monto,
            "tipo_movimiento" => "EGRESO",
            "tipo_pago" => "EFECTIVO",
            "descripcion" => "PAGO POR COMPRA DE PRODUCTOS",
        ];

        // SALDO
        $ingreso_producto = $ingreso_pago->ingreso_producto;
        $ingreso_producto->saldo = (float)$ingreso_producto->total - (float)$monto_total_cancelado;
        $ingreso_producto->save();
        if ($ingreso_producto->saldo < 0) {
            throw new Exception("No se pudo realizar el registro por que el saldo calculado es menor a 0");
        }

        $movimiento_caja = MovimientoCaja::where("registro_id", $ingreso_pago->id)
            ->where("modulo", "IngresoPago")
            ->where("tipo", "PAGO POR COMPRA DE PRODUCTOS")
            ->get()->first();

        $this->movimiento_caja_service->actualizar($datos_movimiento_caja, $movimiento_caja);

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "MODIFICACIÓN", "ACTUALIZÓ UN PAGO POR COMPRA DE PRODUCTOS", $old_ingreso_pago, $ingreso_pago->withoutRelations());

        return $ingreso_pago;
    }

    /**
     * Eliminar ingreso_pago
     *
     * @param IngresoPago $ingreso_pago
     * @return boolean
     */
    public function eliminar(IngresoPago $ingreso_pago): bool|Exception
    {
        $old_ingreso_pago = clone $ingreso_pago;
        $ingreso_producto = $ingreso_pago->ingreso_producto;

        $cancelado = $ingreso_pago->ingreso_producto->cancelado;
        $monto_total_cancelado = IngresoPago::where("id", "!=", $ingreso_pago->id)
            ->where("ingreso_producto_id", $ingreso_pago->ingreso_producto_id)
            ->sum("monto");
        $monto_total_cancelado = (float)$monto_total_cancelado + $cancelado;
        $ingreso_producto->saldo = (float)$ingreso_producto->total - (float)$monto_total_cancelado;
        $ingreso_producto->save();

        $movimiento_caja = MovimientoCaja::where("registro_id", $ingreso_pago->id)
            ->where("modulo", "IngresoPago")
            ->where("tipo", "PAGO POR COMPRA DE PRODUCTOS")
            ->get()->first();
        $this->movimiento_caja_service->eliminar($movimiento_caja, false);
        $ingreso_pago->delete();

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "ELIMINACIÓN", "ELIMINÓ UN PAGO POR COMPRA DE PRODUCTOS", $old_ingreso_pago, null);

        return true;
    }
}
