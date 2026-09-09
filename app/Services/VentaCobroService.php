<?php

namespace App\Services;

use App\Services\HistorialAccionService;
use App\Models\VentaCobro;
use App\Models\Venta;
use App\Models\Producto;
use App\Models\User;
use Illuminate\Http\UploadedFile;
use Exception;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\ValidationException;

class VentaCobroService
{
    private $modulo = "PAGOS DE INGRESO DE PRODUCTOS";

    public function __construct(
        private  CargarArchivoService $cargarArchivoService,
        private HistorialAccionService $historialAccionService,
        private MovimientoCajaService $movimiento_caja_service
    ) {}

    public function listado($venta_id = null): Collection
    {
        $venta_cobros = VentaCobro::with([
            "sucursal:id,nombre",
            "almacen:id,nombre",
            "cliente:id,nombre",
            "user:id,nombre,paterno,materno",
        ])
            ->select("venta_cobros.*");
        if ($venta_id) {
            $venta_cobros->where("venta_id", $venta_id);
        }
        $venta_cobros = $venta_cobros->get();
        return $venta_cobros;
    }
    /**
     * Lista de venta_cobros paginado con filtros
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
        $venta_cobros = VentaCobro::select("venta_cobros.*");

        // Filtros exactos
        foreach ($columnsFilter as $key => $value) {
            if (!is_null($value)) {
                $venta_cobros->where("venta_cobros.$key", $value);
            }
        }

        // Filtros por rango
        foreach ($columnsBetweenFilter as $key => $value) {
            if (isset($value[0], $value[1])) {
                $venta_cobros->whereBetween("venta_cobros.$key", $value);
            }
        }

        // Búsqueda en múltiples columnas con LIKE
        if (!empty($search) && !empty($columnsSerachLike)) {
            $venta_cobros->where(function ($query) use ($search, $columnsSerachLike) {
                foreach ($columnsSerachLike as $col) {
                    $query->orWhere("$col", "LIKE", "%$search%");
                }
            });
        }

        // Ordenamiento
        foreach ($orderBy as $value) {
            if (isset($value[0], $value[1])) {
                $venta_cobros->orderBy($value[0], $value[1]);
            }
        }


        $venta_cobros = $venta_cobros->paginate($length, ['*'], 'page', $page);
        return $venta_cobros;
    }

    /**
     * Crear venta_cobro
     *
     * @param array $datos
     * @return VentaCobro
     */
    public function crear(array $datos): VentaCobro
    {
        $venta_cobro = VentaCobro::create([
            "sucursal_id" => $datos["sucursal_id"],
            "almacen_id" => $datos["almacen_id"],
            "venta_id" => $datos["venta_id"],
            "cliente_id" => $datos["cliente_id"],
            "tipo_pago" => $datos["tipo_pago"],
            "monto" => $datos["monto"],
            "saldo" => 0,
            "fecha" => date("Y-m-d"),
            "hora" => date("H:i:s"),
            "user_id" => Auth::user()->id,
        ]);

        $venta = Venta::findOrFail($venta_cobro->venta_id);
        if ((float)$venta_cobro->monto > (float)$venta->saldo) {
            throw new Exception("El monto cancelado no puede ser mayor al saldo actual de $venta->saldo");
        }

        // INGRESO CAJA
        $movimiento_caja = [
            "sucursal_id" => $venta_cobro->sucursal_id,
            "almacen_id" => $venta_cobro->almacen_id,
            "tipo" => "COBRO POR VENTA DE PRODUCTOS",
            "modulo" => "VentaCobro",
            "registro_id" => $venta_cobro->id,
            "monto" => $venta_cobro->monto,
            "tipo_movimiento" => "INGRESO",
            "tipo_pago" => $venta_cobro->tipo_pago,
            "descripcion" => "COBRO POR VENTA DE PRODUCTOS",
        ];

        // SALDO
        $venta->saldo = (float)$venta->saldo - (float)$venta_cobro->monto;
        $venta->save();
        if ($venta->saldo < 0) {
            throw new Exception("No se pudo realizar el registro por que el saldo calculado es menor a 0");
        }

        $this->movimiento_caja_service->crear($movimiento_caja);

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "CREACIÓN", "REGISTRO UN PAGO POR COMPRA DE PRODUCTOS", $venta_cobro);

        return $venta_cobro;
    }

    /**
     * Actualizar venta_cobro
     *
     * @param array $datos
     * @param VentaCobro $venta_cobro
     * @return VentaCobro
     */
    public function actualizar(array $datos, VentaCobro $venta_cobro): VentaCobro
    {
        $old_venta_cobro = clone $venta_cobro;

        $venta_cobro->update([
            "nombre" => mb_strtoupper($datos["nombre"]),
        ]);

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "MODIFICACIÓN", "ACTUALIZÓ UN PAGO POR COMPRA DE PRODUCTOS", $old_venta_cobro, $venta_cobro->withoutRelations());

        return $venta_cobro;
    }

    /**
     * Eliminar venta_cobro
     *
     * @param VentaCobro $venta_cobro
     * @return boolean
     */
    public function eliminar(VentaCobro $venta_cobro): bool|Exception
    {
        $old_venta_cobro = clone $venta_cobro;
        $usos = Producto::where("venta_cobro_id", $venta_cobro->id)->count();
        if ($usos > 0) {
            throw new Exception("No se puede eliminar este tipo de documento porque está siendo utilizado por $usos productos.");
        }

        $venta_cobro->delete();

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "ELIMINACIÓN", "ELIMINÓ UN PAGO POR COMPRA DE PRODUCTOS", $old_venta_cobro, $venta_cobro);

        return true;
    }
}
