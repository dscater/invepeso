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
    public function listadoPaginado(int $length, int $page, string $search, array $columnsSerachLike = [], array $columnsFilter = [], array $columnsBetweenFilter = [], array $orderBy = []): LengthAwarePaginator
    {
        $movimiento_cajas = MovimientoCaja::with([
            "sucursal:id,nombre",
            "almacen:id,nombre",
            "user:id,nombre,paterno,materno",
        ])
            ->select("movimiento_cajas.*")
            ->where("status", 1);

        // Filtros exactos
        foreach ($columnsFilter as $key => $value) {
            if (!is_null($value)) {
                $movimiento_cajas->where("movimiento_cajas.$key", $value);
            }
        }

        // Filtros por rango
        foreach ($columnsBetweenFilter as $key => $value) {
            if (isset($value[0], $value[1])) {
                $movimiento_cajas->whereBetween("movimiento_cajas.$key", $value);
            }
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

        $movimiento_caja = MovimientoCaja::create([
            "sucursal_id" => $datos["sucursal_id"],
            "almacen_id" => $datos["almacen_id"],
            "tipo" => $datos["tipo"],
            "modulo" => $datos["modulo"],
            "registro_id" => $datos["registro_id"] ?? NULL,
            "monto" => $datos["monto"],
            "tipo_movimiento" => $datos["tipo_movimiento"],
            "tipo_pago" => $datos["tipo_pago"],
            "descripcion" => isset($datos["descripcion"]) && $datos["descripcion"] ? $datos["descripcion"] : $datos["tipo_movimiento"],
            "fecha" => $datos["fecha"] ?? $fecha_actual,
            "hora" => $datos["hora"] ?? $hora_actual,
            "user_id" => Auth::user()->id,
        ]);

        // registrar accion
        $descripcion_accion = "REGISTRO UN " . $datos["tipo_movimiento"] . " DE BS. " . $datos["monto"];
        if ($sucursal) {
            $descripcion_accion = "REGISTRO UN " . $datos["tipo_movimiento"] . " DE BS. " . $datos["monto"] . " EN LA SUCURSAL " . $sucursal->nombre;
        }

        if ($sucursal && $almacen) {
            $descripcion_accion = "REGISTRO UN " . $datos["tipo_movimiento"] . " DE BS. " . $datos["monto"] . " EN LA SUCURSAL " . $sucursal->nombre . "; almacén " . $almacen->nombre;
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

        $movimiento_caja->update([
            "sucursal_id" => $datos["sucursal_id"],
            "almacen_id" => $datos["almacen_id"],
            "tipo" => $datos["tipo"],
            "modulo" => $datos["modulo"],
            "registro_id" => $datos["registro_id"] ?? NULL,
            "monto" => $datos["monto"],
            "tipo_movimiento" => $datos["tipo_movimiento"],
            "tipo_pago" => $datos["tipo_pago"],
            "descripcion" => isset($datos["descripcion"]) && $datos["descripcion"] ? $datos["descripcion"] : $datos["tipo_movimiento"],
            "fecha" => $datos["fecha"] ?? $fecha_actual,
            "hora" => $datos["hora"] ?? $hora_actual,
            // "user_id" => Auth::user()->id,
        ]);

        // registrar accion
        $descripcion_accion = "REGISTRO UN " . $datos["tipo_movimiento"] . " DE BS. " . $datos["monto"];
        if ($sucursal) {
            $descripcion_accion = "REGISTRO UN " . $datos["tipo_movimiento"] . " DE BS. " . $datos["monto"] . " EN LA SUCURSAL " . $sucursal->nombre;
        }

        if ($sucursal && $almacen) {
            $descripcion_accion = "REGISTRO UN " . $datos["tipo_movimiento"] . " DE BS. " . $datos["monto"] . " EN LA SUCURSAL " . $sucursal->nombre . "; almacén " . $almacen->nombre;
        }

        // REGISTR MOVIMIENTO
        if ($movimiento_caja->tipo == 'MOVIMIENTO DE CAJA') {
            $movimiento_caja->registro_id = $movimiento_caja->id;
            $movimiento_caja->save();
        }

        $this->historialAccionService->registrarAccion($this->modulo, "MODIFICACIÓN", $descripcion_accion, $movimiento_caja, $old_movmiento_caja);

        return $movimiento_caja;
    }

    public function eliminar(MovimientoCaja $movimiento_caja): bool|Exception
    {
        $old_movimiento_caja = clone $movimiento_caja;

        if ($movimiento_caja->tipo != 'MOVIMIENTO DE CAJA') {
            throw new Exception("No se puede eliminar este registro porque se registro desde un módulo diferente a MOVIMIENTO DE CAJA");
        }
        $movimiento_caja->status = 0;
        $movimiento_caja->save();

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "ELIMINACIÓN", "ELIMINÓ UN MOVIMIENTO DE CAJA", $old_movimiento_caja, $movimiento_caja);

        return true;
    }
}
