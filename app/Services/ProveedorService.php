<?php

namespace App\Services;

use App\Models\IngresoProducto;
use App\Services\HistorialAccionService;
use App\Models\Proveedor;
use App\Models\User;
use Illuminate\Http\UploadedFile;
use Exception;
use Illuminate\Container\Attributes\Auth;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Validation\ValidationException;

class ProveedorService
{
    private $modulo = "PROVEEDORES";

    public function __construct(private  CargarArchivoService $cargarArchivoService, private HistorialAccionService $historialAccionService) {}

    public function listado(): Collection
    {
        $proveedors = Proveedor::select("proveedors.*")->get();
        return $proveedors;
    }
    /**
     * Lista de proveedors paginado con filtros
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
        $proveedors = Proveedor::select("proveedors.*");

        // Filtros exactos
        foreach ($columnsFilter as $key => $value) {
            if (!is_null($value)) {
                $proveedors->where("proveedors.$key", $value);
            }
        }

        // Filtros por rango
        foreach ($columnsBetweenFilter as $key => $value) {
            if (isset($value[0], $value[1])) {
                $proveedors->whereBetween("proveedors.$key", $value);
            }
        }

        // Búsqueda en múltiples columnas con LIKE
        if (!empty($search) && !empty($columnsSerachLike)) {
            $proveedors->where(function ($query) use ($search, $columnsSerachLike) {
                foreach ($columnsSerachLike as $col) {
                    $query->orWhere("$col", "LIKE", "%$search%");
                }
            });
        }

        // Ordenamiento
        foreach ($orderBy as $value) {
            if (isset($value[0], $value[1])) {
                $proveedors->orderBy($value[0], $value[1]);
            }
        }


        $proveedors = $proveedors->paginate($length, ['*'], 'page', $page);
        return $proveedors;
    }

    /**
     * Crear proveedor
     *
     * @param array $datos
     * @return Proveedor
     */
    public function crear(array $datos): Proveedor
    {
        $proveedor = Proveedor::create([
            "nombre" => mb_strtoupper($datos["nombre"]),
            "contacto" => $datos["contacto"],
        ]);

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "CREACIÓN", "REGISTRO UN PROVEEDOR", $proveedor);

        return $proveedor;
    }

    /**
     * Actualizar proveedor
     *
     * @param array $datos
     * @param Proveedor $proveedor
     * @return Proveedor
     */
    public function actualizar(array $datos, Proveedor $proveedor): Proveedor
    {
        $old_proveedor = clone $proveedor;

        $proveedor->update([
            "nombre" => mb_strtoupper($datos["nombre"]),
            "contacto" => $datos["contacto"],
        ]);

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "MODIFICACIÓN", "ACTUALIZÓ UN PROVEEDOR", $old_proveedor, $proveedor->withoutRelations());

        return $proveedor;
    }

    /**
     * Eliminar proveedor
     *
     * @param Proveedor $proveedor
     * @return boolean
     */
    public function eliminar(Proveedor $proveedor): bool|Exception
    {
        $old_proveedor = clone $proveedor;

        $usos = IngresoProducto::where("proveedor_id", $proveedor->id)->count();
        if ($usos > 0) {
            throw new Exception("No se puede eliminar este proveedor porque está siendo utilizado por $usos ingreso de productos.");
        }

        $proveedor->delete();

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "ELIMINACIÓN", "ELIMINÓ UN PROVEEDOR", $old_proveedor, $proveedor);

        return true;
    }

    public function cargarProveedors($datos)
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
            "A" => "NOMBRE*",
            "B" => "CONTACTO",
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

        $codigosProcesados = [];
        $proveedors = [];
        $fecha_actual = date("Y-m-d");

        foreach ($filas as $indice => $fila) {

            // Excel empieza en fila 1.
            // Como quitamos el encabezado, sumamos 2.
            $filaExcel = $indice + 2;

            /*
         */
            if (empty(array_filter($fila, fn($valor) => trim((string) $valor) !== ""))) {
                continue;
            }

            /*
         * ========================================================
         * DATOS
         * ========================================================
         */
            $nombre = trim((string) ($fila["A"] ?? ""));
            $contacto = trim((string) ($fila["B"] ?? ""));

            /*
         * ========================================================
         * CAMPOS OBLIGATORIOS
         * ========================================================
         */

            if ($nombre === "") {
                throw new \Exception(
                    "La columna NOMBRE* es obligatorio. Fila: {$filaExcel}"
                );
            }

            /*
         * ========================================================
         * VALIDAR DATOS DUPLICADOS
         * ========================================================
         */
            $existe = Proveedor::where("nombre", $nombre);
            $existe = $existe->get()->first();

            $codigosProcesados[$nombre] = $filaExcel;
            if ($existe) {
                throw new \Exception(
                    "El proveedor con el nombre {$nombre} está repetido o ya existe en la base de datos. " .
                        "Filas: {$codigosProcesados[$nombre]} y {$filaExcel}"
                );
            }

            /*
         * ========================================================
         * PREPARAR CLIENTE
         * ========================================================
         */

            $proveedors[] = [
                "nombre" => $nombre,
                "contacto" => $contacto,
            ];
        }

        /*
     * ============================================================
     * INSERTAR CLIENTES
     * ============================================================
     */

        if (!empty($proveedors)) {
            Proveedor::insert($proveedors);
        }
        return count($proveedors);
    }
}
