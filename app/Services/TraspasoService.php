<?php

namespace App\Services;

use App\Models\Almacen;
use App\Models\Producto;
use App\Services\HistorialAccionService;
use App\Models\Traspaso;
use App\Models\TraspasoDetalle;
use App\Models\User;
use Illuminate\Http\UploadedFile;
use Exception;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;
use Illuminate\Validation\ValidationException;

class TraspasoService
{
    private $modulo = "TRASPASOS DE PRODUCTOS";

    public function __construct(
        private  CargarArchivoService $cargarArchivoService,
        private HistorialAccionService $historialAccionService,
        private KardexProductoService $kardex_producto_service
    ) {}

    public function listado(): Collection
    {
        $traspasos = Traspaso::select("traspasos.*")->get();
        return $traspasos;
    }
    /**
     * Lista de traspasos paginado con filtros
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
        $traspasos = Traspaso::with([
            "sucursal_origen:id,nombre",
            "almacen_origen:id,nombre",
            "sucursal_destino:id,nombre",
            "almacen_destino:id,nombre",
            "user:id,nombre,paterno,materno"
        ])
            ->select("traspasos.*");

        // Filtros exactos
        foreach ($columnsFilter as $key => $value) {
            if (!is_null($value)) {
                $traspasos->where("traspasos.$key", $value);
            }
        }

        // Filtros por rango
        foreach ($columnsBetweenFilter as $key => $value) {
            if (isset($value[0], $value[1])) {
                $traspasos->whereBetween("traspasos.$key", $value);
            }
        }

        // Búsqueda en múltiples columnas con LIKE
        if (!empty($search) && !empty($columnsSerachLike)) {
            $traspasos->where(function ($query) use ($search, $columnsSerachLike) {
                foreach ($columnsSerachLike as $col) {
                    $query->orWhere("$col", "LIKE", "%$search%");
                }
            });
        }

        // Ordenamiento
        foreach ($orderBy as $value) {
            if (isset($value[0], $value[1])) {
                $traspasos->orderBy($value[0], $value[1]);
            }
        }


        $traspasos = $traspasos->paginate($length, ['*'], 'page', $page);
        return $traspasos;
    }

    /**
     * Crear traspaso
     *
     * @param array $datos
     * @return Traspaso
     */
    public function crear(array $datos): Traspaso
    {
        $almacen_origen = Almacen::findOrFail($datos["almacen_origen_id"]);
        $almacen_destino = Almacen::findOrFail($datos["almacen_destino_id"]);
        $traspaso = Traspaso::create([
            "sucursal_origen_id" => $almacen_origen->sucursal_id,
            "almacen_origen_id" => $almacen_origen->id,
            "sucursal_destino_id" => $almacen_destino->sucursal_id,
            "almacen_destino_id" => $almacen_destino->id,
            "cantidad" => $datos["cantidad"],
            "descripcion" => mb_strtoupper($datos["descripcion"]) ?? NULL,
            "fecha_registro" => date("Y-m-d"),
            "user_id" => Auth::user()->id,
        ]);

        foreach ($datos["traspaso_detalles"] as $item) {
            $dato_traspaso_detalle = [
                "traspaso_id" => $traspaso->id,
                "producto_id" => $item["producto_id"],
                "cantidad" => $item["cantidad"],
            ];

            $traspaso_detalle = TraspasoDetalle::create($dato_traspaso_detalle);
            $producto = Producto::findOrFail($traspaso_detalle->producto_id);

            // REGISTRAR EGRESO STOCK SUCURSAL ORIGEN
            $this->kardex_producto_service->registrarMovimiento(
                $traspaso->sucursal_origen_id,
                $traspaso->almacen_origen_id,
                "TRASPASO DE PRODUCTOS",
                "EGRESO",
                $traspaso_detalle->id,
                $producto,
                $traspaso_detalle->cantidad,
                $producto->precio_compra,
                $traspaso->descripcion,
                "TraspasoDetalle",
                $traspaso_detalle->id
            );

            // REGISTRAR INGRESO STOCK SUCURSAL DESTINO
            $this->kardex_producto_service->registrarMovimiento(
                $traspaso->sucursal_destino_id,
                $traspaso->almacen_destino_id,
                "TRASPASO DE PRODUCTOS",
                "INGRESO",
                $traspaso_detalle->id,
                $producto,
                $traspaso_detalle->cantidad,
                $producto->precio_compra,
                $traspaso->descripcion,
                "TraspasoDetalle",
                $traspaso_detalle->id
            );
        }

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "CREACIÓN", "REGISTRO UN TRASPASO DE PRODUCTOS DE " . $almacen_origen->nombre . " A " . $almacen_destino->nombre, $traspaso, null, ["traspaso_detalles"]);

        return $traspaso;
    }

    /**
     * Actualizar traspaso
     *
     * @param array $datos
     * @param Traspaso $traspaso
     * @return Traspaso
     */
    public function actualizar(array $datos, Traspaso $traspaso): Traspaso
    {
        $old_traspaso = clone $traspaso;

        $traspaso->update([
            "nombre" => mb_strtoupper($datos["nombre"]),
            "ventas" => $datos["ventas"],
            "activo" => $datos["activo"],
            "descripcion" => mb_strtoupper($datos["descripcion"]) ?? null,
        ]);

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "MODIFICACIÓN", "ACTUALIZÓ UN TRASPASO DE PRODUCTOS", $old_traspaso, $traspaso->withoutRelations());

        return $traspaso;
    }

    /**
     * Eliminar traspaso
     *
     * @param Traspaso $traspaso
     * @return boolean
     */
    public function eliminar(Traspaso $traspaso): bool|Exception
    {
        $old_traspaso = clone $traspaso;
        $traspaso->delete();

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "ELIMINACIÓN", "ELIMINÓ UN TRASPASO DE PRODUCTOS", $old_traspaso, $traspaso);

        return true;
    }
}
