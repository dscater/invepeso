<?php

namespace App\Services;

use App\Services\HistorialAccionService;
use App\Models\Caja;
use App\Models\User;
use Illuminate\Http\UploadedFile;
use Exception;
use Illuminate\Container\Attributes\Auth;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Validation\ValidationException;

class CajaService
{
    private $modulo = "SUCURSALES";

    public function __construct(private  CargarArchivoService $cargarArchivoService, private HistorialAccionService $historialAccionService) {}

    public function listado(): Collection
    {
        $cajas = Caja::select("cajas.*")->get();
        return $cajas;
    }
    /**
     * Lista de cajas paginado con filtros
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
        $cajas = Caja::select("cajas.*");

        // Filtros exactos
        foreach ($columnsFilter as $key => $value) {
            if (!is_null($value)) {
                $cajas->where("cajas.$key", $value);
            }
        }

        // Filtros por rango
        foreach ($columnsBetweenFilter as $key => $value) {
            if (isset($value[0], $value[1])) {
                $cajas->whereBetween("cajas.$key", $value);
            }
        }

        // Búsqueda en múltiples columnas con LIKE
        if (!empty($search) && !empty($columnsSerachLike)) {
            $cajas->where(function ($query) use ($search, $columnsSerachLike) {
                foreach ($columnsSerachLike as $col) {
                    $query->orWhere("$col", "LIKE", "%$search%");
                }
            });
        }

        // Ordenamiento
        foreach ($orderBy as $value) {
            if (isset($value[0], $value[1])) {
                $cajas->orderBy($value[0], $value[1]);
            }
        }


        $cajas = $cajas->paginate($length, ['*'], 'page', $page);
        return $cajas;
    }

    /**
     * Crear caja
     *
     * @param array $datos
     * @return Caja
     */
    public function crear(array $datos): Caja
    {
        $caja = Caja::create([
            "nombre" => mb_strtoupper($datos["nombre"]),
            "ventas" => $datos["ventas"],
            "activo" => $datos["activo"],
            "descripcion" => mb_strtoupper($datos["descripcion"]) ?? null,
            "fecha_registro" => date("Y-m-d")
        ]);

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "CREACIÓN", "REGISTRO UNA SUCURSAL", $caja);

        return $caja;
    }

    /**
     * Actualizar caja
     *
     * @param array $datos
     * @param Caja $caja
     * @return Caja
     */
    public function actualizar(array $datos, Caja $caja): Caja
    {
        $old_caja = clone $caja;

        $caja->update([
            "nombre" => mb_strtoupper($datos["nombre"]),
            "ventas" => $datos["ventas"],
            "activo" => $datos["activo"],
            "descripcion" => mb_strtoupper($datos["descripcion"]) ?? null,
        ]);

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "MODIFICACIÓN", "ACTUALIZÓ UNA SUCURSAL", $old_caja, $caja->withoutRelations());

        return $caja;
    }

    /**
     * Eliminar caja
     *
     * @param Caja $caja
     * @return boolean
     */
    public function eliminar(Caja $caja): bool|Exception
    {
        $old_caja = clone $caja;
        $caja->delete();

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "ELIMINACIÓN", "ELIMINÓ UNA SUCURSAL", $old_caja, $caja);

        return true;
    }
}
