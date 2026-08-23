<?php

namespace App\Services;

use App\Models\CertificadoDetalle;
use App\Models\MovimientoCaja;
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

    public function __construct(private HistorialAccionService $historialAccionService, private LoginUserService $login_user_service, private TipoMovimientoCajaService $tipo_MovimientoCaja_service) {}

    public function crear($datos)
    {
        $fecha_actual = Carbon::now("America/La_Paz")->format("Y-m-d");
        $hora_actual = Carbon::now("America/La_Paz")->format("H:i:s");

        $login_user = $this->login_user_service->verificaSucursal();
        if (!$login_user) {
            throw new Exception("Error no se encontró la sucursal del usuario");
        }
        $sucursal_id = $login_user->sucursal_id;
        $verificado = $this->obtieneEstadoVerificado($sucursal_id, $login_user);
        $fecha_verificado = $fecha_actual;
        $hora_verificado = $hora_actual;


        $MovimientoCaja = MovimientoCaja::create([
            "registro_id" => $datos["registro_id"],
            "modulo" => $datos["modulo"],
            "monto" => $datos["monto"],
            "descripcion" => isset($datos["descripcion"]) && $datos["descripcion"] ? $datos["descripcion"] : '',
            "tipo_MovimientoCaja" => $datos["tipo_MovimientoCaja"],
            "cliente_id" => isset($datos["cliente_id"]) ? $datos["cliente_id"] : NULL,
            "fecha" => $fecha_actual,
            "hora" => $hora_actual,
            "user_id" => Auth::user()->id, // ACTUALIZAR SI NO ESTA VERIFICADO EL MovimientoCaja (En verificación de MovimientoCaja)
            "sucursal_id" => $sucursal_id,
            "verificado" => $verificado,
            "fecha_verificado" => $fecha_verificado,
            "hora_verificado" => $hora_verificado,
        ]);

        if (isset($datos["certificado_atendido"])) {
            $MovimientoCaja->medico_id = $datos["certificado_atendido"] == 1 ? Auth::user()->id : NULL;
        }

        if (isset($datos["medico_id"])) {
            $MovimientoCaja->medico_id = $datos["medico_id"];
            $MovimientoCaja->save();
        }

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "CREACIÓN", "REGISTRO EL MovimientoCaja DE UN CERTIFICADO", $MovimientoCaja, null);

        return $MovimientoCaja;
    }


    public function registrarMovimientoCajas($ids)
    {
        $fecha_actual = Carbon::now("America/La_Paz")->format("Y-m-d");
        $hora_actual = Carbon::now("America/La_Paz")->format("H:i:s");
        MovimientoCaja::whereIn("id", $ids)->update([
            "verificado" => 1,
            "fecha_verificado" => $fecha_actual,
            "hora_verificado" => $hora_actual,
            "user_id" => Auth::user()->id // Usuario que recepciono el dinero
        ]);

        return true;
    }
}
