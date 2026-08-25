<?php

namespace App\Services;

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

    public function crear($datos)
    {
        $fecha_actual = Carbon::now("America/La_Paz")->format("Y-m-d");
        $hora_actual = Carbon::now("America/La_Paz")->format("H:i:s");

        $sucursal = Sucursal::findOrFail($datos["sucursal_id"]);

        $movimiento_caja = MovimientoCaja::create([
            "sucursal_id" => $datos["sucursal_id"],
            "modulo" => $datos["modulo"],
            "registro_id" => $datos["registro_id"],
            "monto" => $datos["monto"],
            "tipo_movimiento" => $datos["tipo_movimiento"],
            "tipo_pago" => $datos["tipo_pago"],
            "descripcion" => isset($datos["descripcion"]) && $datos["descripcion"] ? $datos["descripcion"] : $datos["tipo_movimiento"],
            "fecha" => $fecha_actual,
            "hora" => $hora_actual,
            "user_id" => Auth::user()->id,
        ]);

        // registrar accion

        $descripcion_accion = "REGISTRO UN " . $datos["tipo_movimiento"] . " DE BS. " . $datos["monto"];
        if ($sucursal) {
            $descripcion_accion = "REGISTRO UN " . $datos["tipo_movimiento"] . " DE BS. " . $datos["monto"] . " EN LA SUCURSAL " . $sucursal->nombre;
        }

        $this->historialAccionService->registrarAccion($this->modulo, "CREACIÓN", $descripcion_accion, $movimiento_caja, null);

        return $movimiento_caja;
    }
}
