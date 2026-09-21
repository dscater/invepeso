<?php

namespace App\Services;

use App\Services\HistorialAccionService;
use App\Models\ClienteProducto;
use App\Models\TipoDocumento;
use App\Models\User;
use App\Models\Venta;
use Illuminate\Http\UploadedFile;
use Exception;
use Illuminate\Container\Attributes\Auth;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Support\Facades\Log;
use Illuminate\Validation\ValidationException;

class ClienteProductoService
{
    private $modulo = "PRECIO PRODUCTOS CLIENTES";

    public function __construct(private  CargarArchivoService $cargarArchivoService, private HistorialAccionService $historialAccionService) {}

    public function listado($cliente_id): Collection
    {
        $cliente_productos = ClienteProducto::with([
            "producto:id,codigo,nombre,precio,precio2,precio3,precio4",
            "cliente:id,nombre",
        ])
            ->select("cliente_productos.*");

        if ($cliente_id) {
            $cliente_productos->where("cliente_id", $cliente_id);
        }

        $cliente_productos = $cliente_productos->get();
        return $cliente_productos;
    }
    /**
     * Lista de cliente_productos paginado con filtros
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
        $cliente_id,
        string $search,
        array $columnsSerachLike = [],
        array $columnsFilter = [],
        array $columnsBetweenFilter = [],
        array $orderBy = []
    ): LengthAwarePaginator {
        $cliente_productos = ClienteProducto::select("cliente_productos.*")
            ->with([
                "producto:id,codigo,nombre,precio,precio2,precio3,precio4",
                "cliente:id,nombre",
            ]);

        if ($cliente_id) {
            $cliente_productos->where("cliente_id", $cliente_id);
        }

        // Filtros exactos
        foreach ($columnsFilter as $key => $value) {
            if (!is_null($value)) {
                $cliente_productos->where("cliente_productos.$key", $value);
            }
        }

        // Filtros por rango
        foreach ($columnsBetweenFilter as $key => $value) {
            if (isset($value[0], $value[1])) {
                $cliente_productos->whereBetween("cliente_productos.$key", $value);
            }
        }

        // Búsqueda en múltiples columnas con LIKE
        if (!empty($search) && !empty($columnsSerachLike)) {
            $cliente_productos->where(function ($query) use ($search, $columnsSerachLike) {
                foreach ($columnsSerachLike as $col) {
                    $query->orWhere("$col", "LIKE", "%$search%");
                }
            });
        }

        // Ordenamiento
        foreach ($orderBy as $value) {
            if (isset($value[0], $value[1])) {
                $cliente_productos->orderBy($value[0], $value[1]);
            }
        }


        $cliente_productos = $cliente_productos->paginate($length, ['*'], 'page', $page);
        return $cliente_productos;
    }

    /**
     * Crear cliente_producto
     *
     * @param array $datos
     * @return ClienteProducto
     */
    public function crear(array $datos): ClienteProducto
    {
        $cliente_producto = ClienteProducto::create([
            "cliente_id" => $datos["cliente_id"],
            "producto_id" => $datos["producto_id"],
            "precio" => $datos["precio"],
        ]);

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "CREACIÓN", "REGISTRO UN PRECIO DE PRODUCTO DE CLIENTE", $cliente_producto);

        return $cliente_producto;
    }

    /**
     * Actualizar cliente_producto
     *
     * @param array $datos
     * @param ClienteProducto $cliente_producto
     * @return ClienteProducto
     */
    public function actualizar(array $datos, ClienteProducto $cliente_producto): ClienteProducto
    {
        $old_cliente_producto = clone $cliente_producto;

        $cliente_producto->update([
            "cliente_id" => $datos["cliente_id"],
            "producto_id" => $datos["producto_id"],
            "precio" => $datos["precio"],
        ]);

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "MODIFICACIÓN", "ACTUALIZÓ UN PRECIO DE PRODUCTO DE CLIENTE", $old_cliente_producto, $cliente_producto->withoutRelations());

        return $cliente_producto;
    }

    /**
     * Eliminar cliente_producto
     *
     * @param ClienteProducto $cliente_producto
     * @return boolean
     */
    public function eliminar(ClienteProducto $cliente_producto): bool|Exception
    {
        $old_cliente_producto = clone $cliente_producto;
        $cliente_producto->delete();

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "ELIMINACIÓN", "ELIMINÓ UN PRECIO DE PRODUCTO DE CLIENTE", $old_cliente_producto, $cliente_producto);

        return true;
    }
}
