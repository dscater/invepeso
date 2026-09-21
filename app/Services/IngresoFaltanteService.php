<?php

namespace App\Services;

use App\Services\HistorialAccionService;
use App\Models\IngresoFaltante;
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

class IngresoFaltanteService
{
    private $modulo = "INGRESO DE FALTANTES";

    public function __construct(
        private  CargarArchivoService $cargarArchivoService,
        private HistorialAccionService $historialAccionService,
        private KardexProductoService $kardex_producto_service
    ) {}

    public function listado($ingreso_producto_id = null): Collection
    {
        $ingreso_faltantes = IngresoFaltante::with([
            "ingreso_detalle.ingreso_producto",
            "user:id,nombre,paterno,materno"
        ])
            ->select("ingreso_faltantes.*");
        if ($ingreso_producto_id) {
            $ingreso_faltantes->where("ingreso_producto_id", $ingreso_producto_id);
        }
        $ingreso_faltantes = $ingreso_faltantes->get();
        return $ingreso_faltantes;
    }
    /**
     * Lista de ingreso_faltantes paginado con filtros
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
        $ingreso_faltantes = IngresoFaltante::select("ingreso_faltantes.*");

        // Filtros exactos
        foreach ($columnsFilter as $key => $value) {
            if (!is_null($value)) {
                $ingreso_faltantes->where("ingreso_faltantes.$key", $value);
            }
        }

        // Filtros por rango
        foreach ($columnsBetweenFilter as $key => $value) {
            if (isset($value[0], $value[1])) {
                $ingreso_faltantes->whereBetween("ingreso_faltantes.$key", $value);
            }
        }

        // Búsqueda en múltiples columnas con LIKE
        if (!empty($search) && !empty($columnsSerachLike)) {
            $ingreso_faltantes->where(function ($query) use ($search, $columnsSerachLike) {
                foreach ($columnsSerachLike as $col) {
                    $query->orWhere("$col", "LIKE", "%$search%");
                }
            });
        }

        // Ordenamiento
        foreach ($orderBy as $value) {
            if (isset($value[0], $value[1])) {
                $ingreso_faltantes->orderBy($value[0], $value[1]);
            }
        }

        $ingreso_faltantes = $ingreso_faltantes->paginate($length, ['*'], 'page', $page);
        return $ingreso_faltantes;
    }

    /**
     * Crear ingreso_faltante
     *
     * @param array $datos
     * @return IngresoFaltante
     */
    public function crear(array $datos): IngresoFaltante
    {
        $ingreso_faltante = IngresoFaltante::create([
            "ingreso_producto_id" => $datos["ingreso_producto_id"],
            "ingreso_detalle_id" => $datos["ingreso_detalle_id"],
            "cantidad" => $datos["cantidad"],
            "fecha" => date("Y-m-d"),
            "hora" => date("H:i:s"),
            "user_id" => Auth::user()->id,
        ]);
        // registrar accion
        // $this->historialAccionService->registrarAccion($this->modulo, "CREACIÓN", "REGISTRO UN INGRESO DE FALTANTES", $ingreso_faltante);

        return $ingreso_faltante;
    }

    /**
     * Actualizar ingreso_faltante
     *
     * @param array $datos
     * @param IngresoFaltante $ingreso_faltante
     * @return IngresoFaltante
     */
    public function actualizar(array $datos, IngresoFaltante $ingreso_faltante): IngresoFaltante
    {
        $old_ingreso_faltante = clone $ingreso_faltante;

        return $ingreso_faltante;
    }

    /**
     * Eliminar ingreso_faltante
     *
     * @param IngresoFaltante $ingreso_faltante
     * @return boolean
     */
    public function eliminar(IngresoFaltante $ingreso_faltante): bool|Exception
    {
        $old_ingreso_faltante = clone $ingreso_faltante;
        $ingreso_faltante->delete();

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "ELIMINACIÓN", "ELIMINÓ UN INGRESO DE FALTANTES", $old_ingreso_faltante, null);

        return true;
    }
}
