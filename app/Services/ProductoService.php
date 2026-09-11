<?php

namespace App\Services;

use App\Models\Categoria;
use App\Models\IngresoDetalle;
use App\Models\Marca;
use App\Services\HistorialAccionService;
use App\Models\Producto;
use App\Models\ProductoSucursal;
use App\Models\SalidaProducto;
use App\Models\UnidadMedida;
use App\Models\User;
use App\Models\VentaDetalle;
use App\Models\VentaDetalleLote;
use Illuminate\Http\UploadedFile;
use Exception;
use Illuminate\Container\Attributes\Auth;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Support\Facades\Log;
use Illuminate\Validation\ValidationException;
use PhpOffice\PhpSpreadsheet\IOFactory;

class ProductoService
{
    private $modulo = "PRODUCTOS";

    public function __construct(private  CargarArchivoService $cargarArchivoService, private HistorialAccionService $historialAccionService) {}

    public function listado($activo = null): Collection
    {
        $productos = Producto::select("productos.*")
            ->with(["marca:id,nombre", "categoria:id,nombre"]);
        if ($activo && $activo == 1) {
            $productos->where("activo", 1);
        }

        $productos = $productos->get();
        return $productos;
    }
    /**
     * Lista de productos paginado con filtros
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
        $productos = Producto::select("productos.*")
            ->with(["categoria", "marca", "unidad_medida"]);

        // Filtros exactos
        foreach ($columnsFilter as $key => $value) {
            if (!is_null($value)) {
                $productos->where("productos.$key", $value);
            }
        }

        // Filtros por rango
        foreach ($columnsBetweenFilter as $key => $value) {
            if (isset($value[0], $value[1])) {
                $productos->whereBetween("productos.$key", $value);
            }
        }

        // Búsqueda en múltiples columnas con LIKE
        if (!empty($search) && !empty($columnsSerachLike)) {
            $productos->where(function ($query) use ($search, $columnsSerachLike) {
                foreach ($columnsSerachLike as $col) {
                    $query->orWhere("$col", "LIKE", "%$search%");
                }
            });
        }

        // Ordenamiento
        foreach ($orderBy as $value) {
            if (isset($value[0], $value[1])) {
                $productos->orderBy($value[0], $value[1]);
            }
        }


        $productos = $productos->paginate($length, ['*'], 'page', $page);
        return $productos;
    }

    /**
     * Crear producto
     *
     * @param array $datos
     * @return Producto
     */
    public function crear(array $datos): Producto
    {
        $producto = Producto::create([
            "codigo" => mb_strtoupper($datos["codigo"]),
            "nombre" => mb_strtoupper($datos["nombre"]),
            "categoria_id" => $datos["categoria_id"],
            "marca_id" => $datos["marca_id"],
            "unidad_medida_id" => $datos["unidad_medida_id"],
            "precio" => $datos["precio"],
            "precio2" => $datos["precio2"],
            "precio3" => $datos["precio3"],
            "precio4" => $datos["precio4"],
            "precio_compra" => $datos["precio_compra"],
            "stock_min" => $datos["stock_min"],
            "activo" => $datos["activo"],
            // "descripcion" => mb_strtoupper($datos["descripcion"]) ?? null,
            "fecha_registro" => date("Y-m-d")
        ]);

        // cargar imagen
        if (isset($datos["imagen"]) && !is_string($datos["imagen"])) {
            $this->cargarImagen($producto, $datos["imagen"]);
        }

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "CREACIÓN", "REGISTRO UNA PRODUCTO", $producto);

        return $producto;
    }

    /**
     * Actualizar producto
     *
     * @param array $datos
     * @param Producto $producto
     * @return Producto
     */
    public function actualizar(array $datos, Producto $producto): Producto
    {
        $old_producto = clone $producto;

        $producto->update([
            "codigo" => mb_strtoupper($datos["codigo"]),
            "nombre" => mb_strtoupper($datos["nombre"]),
            "categoria_id" => $datos["categoria_id"],
            "marca_id" => $datos["marca_id"],
            "unidad_medida_id" => $datos["unidad_medida_id"],
            "precio" => $datos["precio"],
            "precio2" => $datos["precio2"],
            "precio3" => $datos["precio3"],
            "precio4" => $datos["precio4"],
            "precio_compra" => $datos["precio_compra"],
            "stock_min" => $datos["stock_min"],
            "activo" => $datos["activo"],
        ]);

        // cargar imagen
        if (isset($datos["imagen"]) && !is_string($datos["imagen"])) {
            $this->cargarImagen($producto, $datos["imagen"]);
        }

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "MODIFICACIÓN", "ACTUALIZÓ UNA PRODUCTO", $old_producto, $producto->withoutRelations());

        return $producto;
    }

    /**
     * Cargar imagen
     *
     * @param Producto $producto
     * @param UploadedFile $imagen
     * @return void
     */
    public function cargarImagen(Producto $producto, UploadedFile $imagen): void
    {
        if ($producto->imagen) {
            \File::delete(public_path("imgs/productos/" . $producto->imagen));
        }

        $nombre = $producto->id . time();
        $producto->imagen = $this->cargarArchivoService->cargarArchivo($imagen, public_path("imgs/productos"), $nombre);
        $producto->save();
    }

    /**
     * Eliminar producto
     *
     * @param Producto $producto
     * @return boolean
     */
    public function eliminar(Producto $producto): bool|Exception
    {
        $old_producto = clone $producto;

        $usos = IngresoDetalle::where("producto_id")->count();
        if ($usos > 0) {
            throw new Exception("No se puede eliminar este producto porque está siendo utilizado por $usos ingreso de productos.");
        }

        $usos = SalidaProducto::where("producto_id")->count();
        if ($usos > 0) {
            throw new Exception("No se puede eliminar este producto porque está siendo utilizado por $usos salida de productos.");
        }

        $usos = VentaDetalle::where("producto_id")->count();
        if ($usos > 0) {
            throw new Exception("No se puede eliminar este producto porque está siendo utilizado por $usos ventas.");
        }

        $usos = VentaDetalleLote::where("producto_id")->count();
        if ($usos > 0) {
            throw new Exception("No se puede eliminar este producto porque está siendo utilizado por $usos ventas.");
        }

        $producto->delete();

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "ELIMINACIÓN", "ELIMINÓ UNA PRODUCTO", $old_producto, $producto);

        return true;
    }

    public function incrementarStock(int $sucursal_id, int $almacen_id, int $producto_id, int $cantidad = 1)
    {
        $producto = ProductoSucursal::where("producto_id", $producto_id)
            ->where("sucursal_id", $sucursal_id)
            ->where("almacen_id", $almacen_id)
            ->get()
            ->first();

        if (!$producto) {
            $producto = ProductoSucursal::create([
                "sucursal_id" => $sucursal_id,
                "almacen_id" => $almacen_id,
                "producto_id" => $producto_id,
                "stock_actual" => 0,
            ]);
        }

        $producto->stock_actual = (float)$producto->stock_actual + $cantidad;
        $producto->save();
        return $producto;
    }
    public function decrementarStock(int $sucursal_id, int $almacen_id, int $producto_id, int $cantidad = 1)
    {
        $producto = ProductoSucursal::where("producto_id", $producto_id)
            ->where("sucursal_id", $sucursal_id)
            ->where("almacen_id", $almacen_id)
            ->get()
            ->first();
        // validar stock
        if (!$this->verificaStock($sucursal_id, $almacen_id, $producto_id, $cantidad)) {
            throw new Exception("Stock insuficiente del producto " . $producto->nombre . ", disponible " . $producto->stock_actual);
        }

        $producto->stock_actual = (float)$producto->stock_actual - $cantidad;
        $producto->save();

        return $producto;
    }

    // stock_actual
    public function verificaStock($sucursal_id, $almacen_id, $producto_id, $cantidad): bool
    {
        $producto = ProductoSucursal::where("producto_id", $producto_id)
            ->where("sucursal_id", $sucursal_id)
            ->where("almacen_id", $almacen_id)
            ->get()
            ->first();

        $disponible = false;
        if ($producto->stock_actual >= $cantidad) {
            $disponible = true;
        }

        return $disponible;
    }

    // stock_actual
    public function verificaStockCantidad($sucursal_id, $almacen_id, $producto_id, $cantidad): array
    {
        $producto = ProductoSucursal::where("producto_id", $producto_id)
            ->where("sucursal_id", $sucursal_id)
            ->where("almacen_id", $almacen_id)
            ->get()
            ->first();
        $disponible = false;
        if ($producto->stock_actual >= $cantidad) {
            $disponible = true;
        }

        return [$disponible, $producto->stock_actual];
    }

    // stock_actual
    public function validaStockCantidad($sucursal_id, $almacen_id, $producto_id, $cantidad)
    {
        $producto = ProductoSucursal::where("producto_id", $producto_id)
            ->where("sucursal_id", $sucursal_id)
            ->where("almacen_id", $almacen_id)
            ->get()
            ->first();
        $disponible = false;
        if ($producto->stock_actual >= $cantidad) {
            $disponible = true;
        }
        if (!$disponible) {
            throw new Exception("Stock insuficiente del producto $producto->nombre, stock actual " . $producto->stock_actual, 422);
        }
        return true;
    }


    public function cargarProductos($datos)
    {
        $archivo = $datos["archivo"];
        $extension = '.' . $archivo->getClientOriginalExtension();
        if ($extension == '.xlsx') {
            $reader = new \PhpOffice\PhpSpreadsheet\Reader\Xlsx();
        } else {
            $reader = new \PhpOffice\PhpSpreadsheet\Reader\Xls();
        }
        $spreadsheet = $reader->load($archivo);

        $hoja = $spreadsheet->getActiveSheet();

        $filas = $hoja->toArray(null, true, true, true);

        if (empty($filas)) {
            throw new \Exception("El archivo Excel está vacío.");
        }

        /*
     * ============================================================
     * 1. VALIDAR ENCABEZADOS
     * ============================================================
     */

        $encabezadosEsperados = [
            "A" => "CÓDIGO*",
            "B" => "NOMBRE*",
            "C" => "CATEGORÍA*",
            "D" => "MARCA*",
            "E" => "UNIDAD MEDIDA*",
            "F" => "PRECIO 1*",
            "G" => "PRECIO 2",
            "H" => "PRECIO 3",
            "I" => "PRECIO 4",
            "J" => "STOCK MÍNIMO*",
            "K" => "PRECIO COMPRA*",
        ];

        $encabezados = array_shift($filas);

        foreach ($encabezadosEsperados as $columna => $encabezadoEsperado) {

            $encabezadoActual = trim(
                strtoupper($encabezados[$columna] ?? "")
            );

            if ($encabezadoActual !== $encabezadoEsperado) {
                throw new \Exception(
                    "El encabezado de la columna {$columna} debe ser '{$encabezadoEsperado}'."
                );
            }
        }

        /*
     * ============================================================
     * 2. CARGAR RELACIONES UNA SOLA VEZ
     * ============================================================
     *
     * Evitamos hacer una consulta a BD por cada producto.
     */

        $categorias = Categoria::get()
            ->keyBy(fn($item) => mb_strtoupper(trim($item->nombre)));

        $marcas = Marca::get()
            ->keyBy(fn($item) => mb_strtoupper(trim($item->nombre)));

        $unidades = UnidadMedida::get()
            ->keyBy(fn($item) => mb_strtoupper(trim($item->nombre)));

        /*
     * ============================================================
     * 3. CÓDIGOS EXISTENTES EN BD
     * ============================================================
     */

        $codigosExcel = [];

        foreach ($filas as $numero => $fila) {

            $codigo = trim($fila["A"] ?? "");

            if ($codigo !== "") {
                $codigosExcel[] = $codigo;
            }
        }

        $codigosExcel = array_unique($codigosExcel);

        $codigosExistentes = Producto::whereIn("codigo", $codigosExcel)
            ->pluck("codigo")
            ->toArray();

        $codigosExistentes = array_flip($codigosExistentes);

        /*
     * ============================================================
     * 4. PROCESAR PRODUCTOS
     * ============================================================
     */

        $productos = [];

        $codigosProcesados = [];

        foreach ($filas as $indice => $fila) {

            // Excel empieza en fila 1.
            // Como quitamos el encabezado, sumamos 2.
            $filaExcel = $indice + 2;

            /*
         * Ignorar filas completamente vacías
         */
            if (empty(array_filter($fila, fn($valor) => trim((string) $valor) !== ""))) {
                continue;
            }

            /*
         * ========================================================
         * DATOS
         * ========================================================
         */

            $codigo = trim((string) ($fila["A"] ?? ""));
            $nombre = trim((string) ($fila["B"] ?? ""));
            $categoria = trim((string) ($fila["C"] ?? ""));
            $marca = trim((string) ($fila["D"] ?? ""));
            $unidadMedida = trim((string) ($fila["E"] ?? ""));

            $precio1 = $fila["F"] ?? null;
            $precio2 = $fila["G"] ?? null;
            $precio3 = $fila["H"] ?? null;
            $precio4 = $fila["I"] ?? null;

            $stockMin = $fila["J"] ?? null;
            $precioCompra = $fila["K"] ?? null;

            /*
         * ========================================================
         * CAMPOS OBLIGATORIOS
         * ========================================================
         */

            if ($codigo === "") {
                throw new \Exception(
                    "La columna CÓDIGO es obligatoria. Fila: {$filaExcel}"
                );
            }

            if ($nombre === "") {
                throw new \Exception(
                    "La columna NOMBRE es obligatoria. Fila: {$filaExcel}"
                );
            }

            if ($categoria === "") {
                throw new \Exception(
                    "La columna CATEGORÍA es obligatoria. Fila: {$filaExcel}"
                );
            }

            if ($marca === "") {
                throw new \Exception(
                    "La columna MARCA es obligatoria. Fila: {$filaExcel}"
                );
            }

            if ($unidadMedida === "") {
                throw new \Exception(
                    "La columna UNIDAD MEDIDA es obligatoria. Fila: {$filaExcel}"
                );
            }

            if ($precio1 === null || $precio1 === "") {
                throw new \Exception(
                    "La columna PRECIO 1 es obligatoria. Fila: {$filaExcel}"
                );
            }

            if ($stockMin === null || $stockMin === "") {
                throw new \Exception(
                    "La columna STOCK MÍNIMO es obligatoria. Fila: {$filaExcel}"
                );
            }

            if ($precioCompra === null || $precioCompra === "") {
                throw new \Exception(
                    "La columna PRECIO COMPRA es obligatoria. Fila: {$filaExcel}"
                );
            }

            /*
         * ========================================================
         * VALIDAR NÚMEROS
         * ========================================================
         */

            $camposNumericos = [
                "PRECIO 1" => $precio1,
                "PRECIO 2" => $precio2,
                "PRECIO 3" => $precio3,
                "PRECIO 4" => $precio4,
                "STOCK MÍNIMO" => $stockMin,
                "PRECIO COMPRA" => $precioCompra,
            ];

            foreach ($camposNumericos as $campo => $valor) {

                if (
                    $valor !== null &&
                    $valor !== "" &&
                    !is_numeric($valor)
                ) {
                    throw new \Exception(
                        "El campo {$campo} debe ser numérico. Fila: {$filaExcel}"
                    );
                }
            }

            /*
         * ========================================================
         * VALIDAR CÓDIGO DUPLICADO EN EL EXCEL
         * ========================================================
         */

            if (isset($codigosProcesados[$codigo])) {
                throw new \Exception(
                    "El código '{$codigo}' está repetido en el Excel. " .
                        "Filas: {$codigosProcesados[$codigo]} y {$filaExcel}"
                );
            }

            $codigosProcesados[$codigo] = $filaExcel;

            /*
         * ========================================================
         * VALIDAR CÓDIGO EXISTENTE EN BD
         * ========================================================
         */

            if (isset($codigosExistentes[$codigo])) {
                throw new \Exception(
                    "El código '{$codigo}' ya existe en la base de datos. " .
                        "Fila: {$filaExcel}"
                );
            }

            /*
         * ========================================================
         * BUSCAR CATEGORÍA
         * ========================================================
         */

            $categoriaKey = mb_strtoupper(trim($categoria));
            if (!isset($categorias[$categoriaKey])) {
                $categorias[$categoriaKey] = Categoria::create([
                    "nombre" => $categoria,
                ]);
            }

            /*
         * ========================================================
         * BUSCAR MARCA
         * ========================================================
         */

            $marcaKey = mb_strtoupper(trim($marca));

            if (!isset($marcas[$marcaKey])) {
                $marcas[$marcaKey] = Marca::create([
                    "nombre" => $marca,
                ]);
            }

            /*
         * ========================================================
         * BUSCAR UNIDAD DE MEDIDA
         * ========================================================
         */

            $unidadKey = mb_strtoupper(trim($unidadMedida));

            if (!isset($unidades[$unidadKey])) {
                $unidades[$unidadKey] = UnidadMedida::create([
                    "nombre" => $unidadMedida,
                ]);
            }

            /*
         * ========================================================
         * PREPARAR PRODUCTO
         * ========================================================
         */

            $productos[] = [
                "codigo" => $codigo,
                "nombre" => $nombre,

                "categoria_id" => $categorias[$categoriaKey]->id,
                "marca_id" => $marcas[$marcaKey]->id,
                "unidad_medida_id" => $unidades[$unidadKey]->id,

                "precio" => $precio1,
                "precio2" => $precio2 ?: null,
                "precio3" => $precio3 ?: null,
                "precio4" => $precio4 ?: null,

                "precio_compra" => $precioCompra,
                "stock_min" => $stockMin,

                "activo" => 1,
                "fecha_registro" => now(),
            ];
        }

        /*
     * ============================================================
     * 5. INSERTAR PRODUCTOS
     * ============================================================
     */

        if (!empty($productos)) {
            Producto::insert($productos);
        }

        return count($productos);
    }
    // // cantidad disponible
    // // VERIFICAR EN UNA TABLA DONDE SE GUARDAN MOVIMIENTOS ACTUALES COMO VENTAS
    // // TODO: modificar y aplicar
    // public function verificaStockDisponible($sucursal_id, $almacen_id, $producto_id, $cantidad, $pedido_id = 0): array
    // {
    //     $producto = ProductoSucursal::where("producto_id", $producto_id)
    //         ->where("sucursal_id", $sucursal_id)
    //         ->where("almacen_id", $almacen_id)
    //         ->get()
    //         ->first();
    //     $disponible = false;
    //     $c_pedidos_pendientes = PedidoDetalle::where("producto_id", $producto_id)
    //         ->whereHas("pedido", function ($q) use ($pedido_id) {
    //             $q->where("estado", "PENDIENTE");
    //             $q->where("status", 1);
    //             if ($pedido_id != 0) {
    //                 $q->where("id", "!=", $pedido_id);
    //             }
    //         })->sum("cantidad_total");

    //     $stock_disponible = (float)$producto->stock_actual - (float)$c_pedidos_pendientes;

    //     if ($stock_disponible >= $cantidad) {
    //         $disponible = true;
    //     }

    //     return [$disponible, $stock_disponible];
    // }
}
