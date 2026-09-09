<?php

namespace App\Services;

use App\Models\Almacen;
use App\Models\Cliente;
use App\Models\Producto;
use App\Services\HistorialAccionService;
use App\Models\Proforma;
use App\Models\User;
use App\Models\ProformaDetalle;
use Illuminate\Http\UploadedFile;
use Exception;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;
use Illuminate\Validation\ValidationException;

class ProformaService
{
    private $modulo = "PROFORMAS";

    public function __construct(
        private  CargarArchivoService $cargarArchivoService,
        private HistorialAccionService $historialAccionService,
        private KardexProductoService $kardex_producto_service,
        private ProductoService $producto_service,
        private MovimientoCajaService $movimiento_caja_service
    ) {}

    public function listado($fecha_ini = null, $fecha_fin = null): Collection
    {
        $proformas = Proforma::with([
            "sucursal:id,nombre",
            "almacen:id,nombre",
            "cliente.tipo_documento",
            "user:id,nombre,paterno,materno",
        ])
            ->select("proformas.*")
            ->where("status", 1);
        if ($fecha_ini && $fecha_fin) {
            $proformas->whereBetween("fecha_registro", [$fecha_ini, $fecha_fin]);
        }
        $proformas = $proformas->get();
        return $proformas;
    }
    /**
     * Lista de proformas paginado con filtros
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
        $proformas = Proforma::with([
            "sucursal:id,nombre",
            "almacen:id,nombre",
            "cliente.tipo_documento",
            "user:id,nombre,paterno,materno",
        ])
            ->select("proformas.*")
            ->where("status", 1);

        // Filtros exactos
        foreach ($columnsFilter as $key => $value) {
            if (!is_null($value)) {
                $proformas->where("proformas.$key", $value);
            }
        }

        // Filtros por rango
        foreach ($columnsBetweenFilter as $key => $value) {
            if (isset($value[0], $value[1])) {
                $proformas->whereBetween("proformas.$key", $value);
            }
        }

        // Búsqueda en múltiples columnas con LIKE
        if (!empty($search) && !empty($columnsSerachLike)) {
            $proformas->where(function ($query) use ($search, $columnsSerachLike) {
                foreach ($columnsSerachLike as $col) {
                    $query->orWhere("$col", "LIKE", "%$search%");
                }
            });
        }

        // Ordenamiento
        foreach ($orderBy as $value) {
            if (isset($value[0], $value[1])) {
                $proformas->orderBy($value[0], $value[1]);
            }
        }


        $proformas = $proformas->paginate($length, ['*'], 'page', $page);
        return $proformas;
    }

    /**
     * Crear proforma
     *
     * @param array $datos
     * @return Proforma
     */
    public function crear(array $datos): Proforma
    {
        $almacen = Almacen::findOrFail($datos["almacen_id"]);
        $cliente = Cliente::findOrFail($datos["cliente_id"]);

        $proforma = Proforma::create([
            "sucursal_id" => $almacen->sucursal_id,
            "almacen_id" => $almacen->id,
            "cliente_id" => $cliente->id,
            "tipo_documento_id" => $cliente->tipo_documento_id,
            "nit_ci" => $cliente->full_ci,
            "subtotal" => $datos["subtotal"],
            "descuento" => $datos["descuento"] ?? 0,
            "porcentaje_descuento" => $datos["porcentaje_descuento"] ?? 0,
            "total" => $datos["total"],
            "cancelado" => $datos["total"],
            "saldo" => 0,
            "fecha" => date("Y-m-d"),
            "hora" => date("H:i:s"),
            "fecha_registro" => date("Y-m-d"),
            "user_id" => Auth::user()->id
        ]);

        $proforma->codigo_proforma = "P" . $proforma->id;
        $proforma->save();
        foreach ($datos["proforma_detalles"] as $item) {
            $dato_proforma_detalle = [
                "proforma_id" => $proforma->id,
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

            $proforma_detalle = ProformaDetalle::create($dato_proforma_detalle);
        }

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "CREACIÓN", "REGISTRO UNA PROFORMA", $proforma, null, ["proforma_detalles"]);

        return $proforma;
    }

    /**
     * Actualizar proforma
     *
     * @param array $datos
     * @param Proforma $proforma
     * @return Proforma
     */
    public function actualizar(array $datos, Proforma $proforma): Proforma
    {
        $old_proforma = clone $proforma;
        $old_proforma = $old_proforma->loadMissing(["proforma_detalles"]);

        $almacen = Almacen::findOrFail($datos["almacen_id"]);
        $cliente = Cliente::findOrFail($datos["cliente_id"]);

        $proforma->update([
            "sucursal_id" => $almacen->sucursal_id,
            "almacen_id" => $almacen->id,
            "cliente_id" => $cliente->id,
            "tipo_documento_id" => $cliente->tipo_documento_id,
            "nit_ci" => $cliente->full_ci,
            "subtotal" => $datos["subtotal"],
            "descuento" => $datos["descuento"] ?? 0,
            "porcentaje_descuento" => $datos["porcentaje_descuento"] ?? 0,
            "total" => $datos["total"],
            "cancelado" => $datos["cancelado"],
            "saldo" => $datos["saldo"],
        ]);

        foreach ($datos["proforma_detalles"] as $item) {
            $datos_proforma_detalle = [
                "proforma_id" => $proforma->id,
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
                $proforma_detalle = ProformaDetalle::create($datos_proforma_detalle);
            } else {
                $proforma_detalle = ProformaDetalle::findOrFail($item["id"]);
                $proforma_detalle->update($datos_proforma_detalle);
            }
        }

        // ELIMINADOS
        if (isset($datos["eliminados"])) {
            foreach ($datos["eliminados"] as $id) {
                $proforma_detalle = ProformaDetalle::findOrFail($id);
                $proforma_detalle->delete();
            }
        }

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "MODIFICACIÓN", "ACTUALIZÓ UNA PROFORMA", $old_proforma, $proforma->withoutRelations(), ["proforma_detalles"]);

        return $proforma;
    }

    /**
     * Eliminar proforma
     *
     * @param Proforma $proforma
     * @return boolean
     */
    public function eliminar(Proforma $proforma): bool|Exception
    {
        $old_proforma = clone $proforma;

        $proforma->status = 0;
        $proforma->save();

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "ELIMINACIÓN", "ELIMINÓ UNA PROFORMA", $old_proforma, $proforma, ["proforma_detalles"]);

        return true;
    }
}
