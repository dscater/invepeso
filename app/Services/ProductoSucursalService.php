<?php

namespace App\Services;

use App\Services\HistorialAccionService;
use App\Models\ProductoSucursal;
use App\Models\Producto;
use App\Models\User;
use Illuminate\Http\UploadedFile;
use Exception;
use Illuminate\Container\Attributes\Auth;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Validation\ValidationException;

class ProductoSucursalService
{
    private $modulo = "CATEGORIAS";

    public function __construct(private  CargarArchivoService $cargarArchivoService, private HistorialAccionService $historialAccionService) {}

    public function listado(
        $almacen_id = "",
        $categoria_id = "",
        $marca_id = "",
        $nombreProducto = "",
    ): Collection {
        $productos = Producto::select(
            'productos.*',
            DB::raw('COALESCE(SUM(producto_sucursals.stock_actual),0) as stock_total')

        )->with(["categoria:id,nombre", "marca:id,nombre"])
            ->leftJoin('producto_sucursals', function ($join) use ($almacen_id) {
                $join->on('productos.id', '=', 'producto_sucursals.producto_id');
                if (!empty($almacen_id) && $almacen_id != 'todos') {
                    $join->where('producto_sucursals.almacen_id', $almacen_id);
                }
            });

        if (!empty($categoria_id) && $categoria_id != 'todos') {
            Log::debug("categoria");
            $productos->where('productos.categoria_id', $categoria_id);
        }

        if (!empty($marca_id) && $marca_id != 'todos') {
            $productos->where('productos.marca_id', $marca_id);
        }

        if (!empty(trim($nombreProducto))) {
            $productos->where('productos.nombre', 'like', "%{$nombreProducto}%");
        }

        return $productos
            ->groupBy('productos.id')
            ->get();
    }
    /**
     * Lista de producto_sucursals paginado con filtros
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
        $producto_sucursals = ProductoSucursal::select("producto_sucursals.*");

        // Filtros exactos
        foreach ($columnsFilter as $key => $value) {
            if (!is_null($value)) {
                $producto_sucursals->where("producto_sucursals.$key", $value);
            }
        }

        // Filtros por rango
        foreach ($columnsBetweenFilter as $key => $value) {
            if (isset($value[0], $value[1])) {
                $producto_sucursals->whereBetween("producto_sucursals.$key", $value);
            }
        }

        // Búsqueda en múltiples columnas con LIKE
        if (!empty($search) && !empty($columnsSerachLike)) {
            $producto_sucursals->where(function ($query) use ($search, $columnsSerachLike) {
                foreach ($columnsSerachLike as $col) {
                    $query->orWhere("$col", "LIKE", "%$search%");
                }
            });
        }

        // Ordenamiento
        foreach ($orderBy as $value) {
            if (isset($value[0], $value[1])) {
                $producto_sucursals->orderBy($value[0], $value[1]);
            }
        }

        $producto_sucursals = $producto_sucursals->paginate($length, ['*'], 'page', $page);
        return $producto_sucursals;
    }

    /**
     * Crear producto_sucursal
     *
     * @param array $datos
     * @return ProductoSucursal
     */
    public function crear(array $datos): ProductoSucursal
    {
        $producto_sucursal = ProductoSucursal::create([
            "nombre" => mb_strtoupper($datos["nombre"]),
        ]);

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "CREACIÓN", "REGISTRO UNA CATEGORIA", $producto_sucursal);

        return $producto_sucursal;
    }

    /**
     * Actualizar producto_sucursal
     *
     * @param array $datos
     * @param ProductoSucursal $producto_sucursal
     * @return ProductoSucursal
     */
    public function actualizar(array $datos, ProductoSucursal $producto_sucursal): ProductoSucursal
    {
        $old_producto_sucursal = clone $producto_sucursal;

        $producto_sucursal->update([
            "nombre" => mb_strtoupper($datos["nombre"]),
        ]);

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "MODIFICACIÓN", "ACTUALIZÓ UNA CATEGORIA", $old_producto_sucursal, $producto_sucursal->withoutRelations());

        return $producto_sucursal;
    }

    /**
     * Eliminar producto_sucursal
     *
     * @param ProductoSucursal $producto_sucursal
     * @return boolean
     */
    public function eliminar(ProductoSucursal $producto_sucursal): bool|Exception
    {
        $old_producto_sucursal = clone $producto_sucursal;
        $usos = Producto::where("producto_sucursal_id", $producto_sucursal->id)->count();
        if ($usos > 0) {
            throw new Exception("No se puede eliminar este tipo de documento porque está siendo utilizado por $usos productos.");
        }

        $producto_sucursal->delete();

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "ELIMINACIÓN", "ELIMINÓ UNA CATEGORIA", $old_producto_sucursal, $producto_sucursal);

        return true;
    }
}
