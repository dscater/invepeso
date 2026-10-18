<?php

namespace App\Services;

use App\Models\Almacen;
use App\Models\CertificadoDetalle;
use App\Models\MovimientoCaja;
use App\Models\Sucursal;
use App\Services\HistorialAccionService;
use Carbon\Carbon;
use Illuminate\Http\UploadedFile;
use Exception;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;
use Illuminate\Validation\ValidationException;

class MovimientoCajaService
{
    private $modulo = "MOVIMIENTO DE CAJAS";

    public function __construct(private HistorialAccionService $historialAccionService) {}

    public function listado(): Collection
    {
        $movimiento_cajas = MovimientoCaja::select("movimiento_cajas.*")
            ->where("status", 1);



        $movimiento_cajas = $movimiento_cajas->get();
        return $movimiento_cajas;
    }
    public function resumen_movimientos(
        $user_id = "",
        $almacen_id = "",
        $fecha_ini = "",
        $fecha_fin = "",
    ) {
        $movimientos = MovimientoCaja::select("movimiento_cajas.*")
            ->where("status", 1);

        if ($user_id) {
            $movimientos->where("user_id", $user_id);
        }

        if ($almacen_id) {
            $movimientos->where("almacen_id", $almacen_id);
        }

        if ($fecha_ini && $fecha_fin) {
            $movimientos->whereBetween("fecha", [$fecha_ini, $fecha_fin]);
        }

        $ingresos = (clone $movimientos)
            ->where("tipo_movimiento", "INGRESO")
            ->sum("monto_total");

        $ingresos_qr = (clone $movimientos)
            ->where("tipo_movimiento", "INGRESO")
            ->sum("monto_qr");

        $ingresos_efectivo = (clone $movimientos)
            ->where("tipo_movimiento", "INGRESO")
            ->sum("monto_efectivo");

        $egresos = (clone $movimientos)
            ->where("tipo_movimiento", "EGRESO")
            ->sum("monto_total");

        $egresos_qr = (clone $movimientos)
            ->where("tipo_movimiento", "EGRESO")
            ->sum("monto_qr");

        $egresos_efectivo = (clone $movimientos)
            ->where("tipo_movimiento", "EGRESO")
            ->sum("monto_efectivo");

        $total_caja = $ingresos - $egresos;
        $total_caja_qr = $ingresos_qr - $egresos_qr;
        $total_caja_efectivo = $ingresos_efectivo - $egresos_efectivo;

        return [
            "ingresos" => $ingresos,
            "ingresos_qr" => $ingresos_qr,
            "ingresos_efectivo" => $ingresos_efectivo,
            "egresos" => $egresos,
            "egresos_qr" => $egresos_qr,
            "egresos_efectivo" => $egresos_efectivo,
            "total_caja" => $total_caja,
            "total_caja_qr" => $total_caja_qr,
            "total_caja_efectivo" => $total_caja_efectivo,
        ];
    }

    /**
     * Lista de movimiento_cajas paginado con filtros
     *
     * @param integer $length
     * @param integer $page
     * @param string $search
     * @param array $columnsSerachLike
     * @param array $columnsFilter
     * @return LengthAwarePaginator
     */
    public function listadoPaginado(
        int $length,
        int $page,
        string $search,
        $user_id = "",
        $almacen_id = "",
        $fecha_ini = "",
        $fecha_fin = "",
        array $orderBy = []
    ): LengthAwarePaginator {
        $movimiento_cajas = MovimientoCaja::with([
            "sucursal:id,nombre",
            "almacen:id,nombre",
            "user:id,nombre,paterno,materno",
        ])
            ->select("movimiento_cajas.*")
            ->where("status", 1);


        if ($user_id) {
            $movimiento_cajas->where("user_id", $user_id);
        }

        if ($almacen_id) {
            $movimiento_cajas->where("almacen_id", $almacen_id);
        }

        if ($fecha_ini && $fecha_fin) {
            $movimiento_cajas->whereBetween("fecha", [$fecha_ini, $fecha_fin]);
        }

        // Búsqueda en múltiples columnas con LIKE
        if (!empty($search) && !empty($columnsSerachLike)) {
            $movimiento_cajas->where(function ($query) use ($search, $columnsSerachLike) {
                foreach ($columnsSerachLike as $col) {
                    $query->orWhere("$col", "LIKE", "%$search%");
                }
            });
        }

        // Ordenamiento
        foreach ($orderBy as $value) {
            if (isset($value[0], $value[1])) {
                $movimiento_cajas->orderBy($value[0], $value[1]);
            }
        }


        $movimiento_cajas = $movimiento_cajas->paginate($length, ['*'], 'page', $page);
        return $movimiento_cajas;
    }

    public function crear($datos)
    {
        $fecha_actual = Carbon::now("America/La_Paz")->format("Y-m-d");
        $hora_actual = Carbon::now("America/La_Paz")->format("H:i:s");

        $sucursal = Sucursal::findOrFail($datos["sucursal_id"]);
        $almacen = Almacen::findOrFail($datos["almacen_id"]);

        if (!$datos["monto_efectivo"] && !$datos["monto_qr"]) {
            throw new Exception("No puedes dejar vacíos los campos EFECTIVO y QR");
        }

        if ((float)$datos["monto_efectivo"] <= 0 && (float)$datos["monto_qr"] <= 0) {
            throw new Exception("No puedes registrar EFECTIVO y QR con un valor menor o igual a 0");
        }


        $tipo_pago = 'EFECTIVO';
        if ((float)$datos["monto_qr"] > 0) {
            $tipo_pago = 'QR';
        }
        if ((float)$datos["monto_efectivo"] > 0 && (float)$datos["monto_qr"] > 0) {
            $tipo_pago = 'EFECTIVO-QR';
        }

        $monto_total = (float)($datos["monto_efectivo"] ?? 0) + (float)($datos["monto_qr"] ?? 0);

        $movimiento_caja = MovimientoCaja::create([
            "sucursal_id" => $datos["sucursal_id"],
            "almacen_id" => $datos["almacen_id"],
            "tipo" => $datos["tipo"],
            "modulo" => $datos["modulo"],
            "registro_id" => $datos["registro_id"] ?? NULL,
            "monto_efectivo" => $datos["monto_efectivo"],
            "monto_qr" => $datos["monto_qr"],
            "monto_total" => $monto_total,
            "tipo_movimiento" => $datos["tipo_movimiento"],
            "tipo_pago" => $tipo_pago,
            "descripcion" => isset($datos["descripcion"]) && $datos["descripcion"] ? $datos["descripcion"] : $datos["tipo_movimiento"],
            "fecha" => $datos["fecha"] ?? $fecha_actual,
            "hora" => $datos["hora"] ?? $hora_actual,
            "user_id" => Auth::user()->id,
        ]);

        // registrar accion
        $descripcion_accion = "REGISTRO UN " . $datos["tipo_movimiento"] . " DE BS. " . $monto_total;
        if ($sucursal) {
            $descripcion_accion = "REGISTRO UN " . $datos["tipo_movimiento"] . " DE BS. " . $monto_total . " EN LA SUCURSAL " . $sucursal->nombre;
        }

        if ($sucursal && $almacen) {
            $descripcion_accion = "REGISTRO UN " . $datos["tipo_movimiento"] . " DE BS. " . $monto_total . " EN LA SUCURSAL " . $sucursal->nombre . "; almacén " . $almacen->nombre;
        }

        // REGISTR MOVIMIENTO
        if ($movimiento_caja->tipo == 'MOVIMIENTO DE CAJA') {
            $movimiento_caja->registro_id = $movimiento_caja->id;
            $movimiento_caja->save();
        }

        $this->historialAccionService->registrarAccion($this->modulo, "CREACIÓN", $descripcion_accion, $movimiento_caja, null);

        return $movimiento_caja;
    }

    public function actualizar($datos, MovimientoCaja $movimiento_caja)
    {
        $old_movmiento_caja = clone $movimiento_caja; // Clonar el objeto original para compararlo después

        $fecha_actual = Carbon::now("America/La_Paz")->format("Y-m-d");
        $hora_actual = Carbon::now("America/La_Paz")->format("H:i:s");

        $sucursal = Sucursal::findOrFail($datos["sucursal_id"]);
        $almacen = Almacen::findOrFail($datos["almacen_id"]);


        if (!$datos["monto_efectivo"] && !$datos["monto_qr"]) {
            throw new Exception("No puedes dejar vacíos los campos EFECTIVO y QR");
        }

        if ((float)$datos["monto_efectivo"] <= 0 && (float)$datos["monto_qr"] <= 0) {
            throw new Exception("No puedes registrar EFECTIVO y QR con un valor menor o igual a 0");
        }

        $tipo_pago = 'EFECTIVO';
        if ((float)$datos["monto_qr"] > 0) {
            $tipo_pago = 'QR';
        }
        if ((float)$datos["monto_efectivo"] > 0 && (float)$datos["monto_qr"] > 0) {
            $tipo_pago = 'EFECTIVO-QR';
        }

        $monto_total = (float)($datos["monto_efectivo"] ?? 0) + (float)($datos["monto_qr"] ?? 0);

        $movimiento_caja->update([
            "sucursal_id" => $datos["sucursal_id"],
            "almacen_id" => $datos["almacen_id"],
            "tipo" => $datos["tipo"],
            "modulo" => $datos["modulo"],
            "registro_id" => $datos["registro_id"] ?? NULL,
            "monto_efectivo" => $datos["monto_efectivo"],
            "monto_qr" => $datos["monto_qr"],
            "monto_total" => $monto_total,
            "tipo_movimiento" => $datos["tipo_movimiento"],
            "tipo_pago" => $tipo_pago,
            "descripcion" => isset($datos["descripcion"]) && $datos["descripcion"] ? $datos["descripcion"] : $datos["tipo_movimiento"],
            // "fecha" => $datos["fecha"] ?? $fecha_actual,
            // "hora" => $datos["hora"] ?? $hora_actual,
            // "user_id" => Auth::user()->id,
        ]);

        // registrar accion
        $descripcion_accion = "REGISTRO UN " . $datos["tipo_movimiento"] . " DE BS. " . $monto_total;
        if ($sucursal) {
            $descripcion_accion = "REGISTRO UN " . $datos["tipo_movimiento"] . " DE BS. " . $monto_total . " EN LA SUCURSAL " . $sucursal->nombre;
        }

        if ($sucursal && $almacen) {
            $descripcion_accion = "REGISTRO UN " . $datos["tipo_movimiento"] . " DE BS. " . $monto_total . " EN LA SUCURSAL " . $sucursal->nombre . "; almacén " . $almacen->nombre;
        }

        // REGISTR MOVIMIENTO
        if ($movimiento_caja->tipo == 'MOVIMIENTO DE CAJA') {
            $movimiento_caja->registro_id = $movimiento_caja->id;
            $movimiento_caja->save();
        }

        $this->historialAccionService->registrarAccion($this->modulo, "MODIFICACIÓN", $descripcion_accion, $movimiento_caja, $old_movmiento_caja);

        return $movimiento_caja;
    }

    public function eliminar(MovimientoCaja $movimiento_caja, $valida_movimiento = true): bool|Exception
    {
        $old_movimiento_caja = clone $movimiento_caja;

        if ($movimiento_caja->tipo != 'MOVIMIENTO DE CAJA' && $valida_movimiento) {
            throw new Exception("No se puede eliminar este registro porque se registro desde un módulo diferente a MOVIMIENTO DE CAJA");
        }
        $movimiento_caja->status = 0;
        $movimiento_caja->save();

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "ELIMINACIÓN", "ELIMINÓ UN MOVIMIENTO DE CAJA", $old_movimiento_caja, $movimiento_caja);

        return true;
    }
}
