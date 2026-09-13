<?php

namespace App\Services;

use App\Services\HistorialAccionService;
use App\Models\Cliente;
use App\Models\TipoDocumento;
use App\Models\User;
use Illuminate\Http\UploadedFile;
use Exception;
use Illuminate\Container\Attributes\Auth;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Support\Facades\Log;
use Illuminate\Validation\ValidationException;

class ClienteService
{
    private $modulo = "CLIENTES";

    public function __construct(private  CargarArchivoService $cargarArchivoService, private HistorialAccionService $historialAccionService) {}

    public function listado(): Collection
    {
        $clientes = Cliente::with(["tipo_documento:id,nombre"])
            ->select("clientes.*");


        $clientes = $clientes->where("status", 1)->get();
        return $clientes;
    }
    /**
     * Lista de clientes paginado con filtros
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
        $clientes = Cliente::select("clientes.*")
            ->with(["tipo_documento:id,nombre"])
            ->where("status", 1);

        // Filtros exactos
        foreach ($columnsFilter as $key => $value) {
            if (!is_null($value)) {
                $clientes->where("clientes.$key", $value);
            }
        }

        // Filtros por rango
        foreach ($columnsBetweenFilter as $key => $value) {
            if (isset($value[0], $value[1])) {
                $clientes->whereBetween("clientes.$key", $value);
            }
        }

        // Búsqueda en múltiples columnas con LIKE
        if (!empty($search) && !empty($columnsSerachLike)) {
            $clientes->where(function ($query) use ($search, $columnsSerachLike) {
                foreach ($columnsSerachLike as $col) {
                    $query->orWhere("$col", "LIKE", "%$search%");
                }
            });
        }

        // Ordenamiento
        foreach ($orderBy as $value) {
            if (isset($value[0], $value[1])) {
                $clientes->orderBy($value[0], $value[1]);
            }
        }


        $clientes = $clientes->paginate($length, ['*'], 'page', $page);
        return $clientes;
    }

    /**
     * Crear cliente
     *
     * @param array $datos
     * @return Cliente
     */
    public function crear(array $datos): Cliente
    {
        $cliente = Cliente::create([
            "nombre" => mb_strtoupper($datos["nombre"]),
            "tipo_documento_id" => $datos["tipo_documento_id"],
            "nro_documento" => $datos["nro_documento"],
            "complemento" => $datos["complemento"] ?? NULL,
            "fono" => $datos["fono"] ?? NULL,
            "correo" => $datos["correo"] ?? NULL,
            "fecha_registro" => date("Y-m-d")
        ]);

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "CREACIÓN", "REGISTRO UN CLIENTE", $cliente);

        return $cliente;
    }

    /**
     * Actualizar cliente
     *
     * @param array $datos
     * @param Cliente $cliente
     * @return Cliente
     */
    public function actualizar(array $datos, Cliente $cliente): Cliente
    {
        $old_cliente = clone $cliente;

        $cliente->update([
            "nombre" => mb_strtoupper($datos["nombre"]),
            "tipo_documento_id" => $datos["tipo_documento_id"],
            "nro_documento" => $datos["nro_documento"],
            "complemento" => $datos["complemento"] ?? NULL,
            "fono" => $datos["fono"] ?? NULL,
            "correo" => $datos["correo"] ?? NULL,
        ]);

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "MODIFICACIÓN", "ACTUALIZÓ UN CLIENTE", $old_cliente, $cliente->withoutRelations());

        return $cliente;
    }

    /**
     * Eliminar cliente
     *
     * @param Cliente $cliente
     * @return boolean
     */
    public function eliminar(Cliente $cliente): bool|Exception
    {
        $old_cliente = clone $cliente;
        $cliente->delete();

        // registrar accion
        $this->historialAccionService->registrarAccion($this->modulo, "ELIMINACIÓN", "ELIMINÓ UN CLIENTE", $old_cliente, $cliente);

        return true;
    }

    public function cargarClientes($datos)
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
            "B" => "TIPO DOCUMENTO*",
            "C" => "NRO DOCUMENTO*",
            "D" => "COMPLEMENTO",
            "E" => "CONTACTO",
            "F" => "CORREO",
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
     * Evitamos hacer una consulta a BD por cada cliente.
     */

        $tipo_documentos = TipoDocumento::get()
            ->keyBy(fn($item) => mb_strtoupper(trim($item->nombre)));

        $codigosProcesados = [];
        $clientes = [];
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
            $tipo_documento = trim((string) ($fila["B"] ?? ""));
            $nro_documento = trim((string) ($fila["C"] ?? ""));
            $complemento = trim((string) ($fila["D"] ?? ""));
            $contacto = trim((string) ($fila["E"] ?? ""));
            $correo = trim((string) ($fila["F"] ?? ""));

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

            if ($tipo_documento === "") {
                throw new \Exception(
                    "La columna TIPO DOCUMENTO* es obligatorio. Fila: {$filaExcel}"
                );
            }

            if ($nro_documento === "") {
                throw new \Exception(
                    "La columna NRO DOCUMENTO* es obligatorio. Fila: {$filaExcel}"
                );
            }

            /*
         * ========================================================
         * VALIDAR DATOS DUPLICADOS
         * ========================================================
         */
            $tipoDocumentoKey = mb_strtoupper(trim($tipo_documento));
            if (!isset($tipo_documentos[$tipoDocumentoKey])) {
                $tipo_documentos[$tipoDocumentoKey] = TipoDocumento::firstOrCreate([
                    "nombre" => trim($tipo_documento),
                ]);
            }
            $existe = Cliente::where("tipo_documento_id", $tipo_documentos[$tipoDocumentoKey]->id)
                ->where("nro_documento", $nro_documento);

            if ($tipo_documentos[$tipoDocumentoKey]->id == 1 && $complemento != '' && $complemento != NULL) {
                $existe->where('complemento', $complemento);
            }
            $existe = $existe->get()->first();

            $codigosProcesados[$tipoDocumentoKey . $nro_documento . $complemento] = $filaExcel;
            if ($existe) {
                throw new \Exception(
                    "El nro. de documento {$nro_documento} del tipo '{$tipoDocumentoKey}' está repetido o ya éxiste en la base de datos. " .
                        "Filas: {$codigosProcesados[$tipoDocumentoKey .$nro_documento .$complemento]} y {$filaExcel}"
                );
            }

            /*
         * ========================================================
         * PREPARAR CLIENTE
         * ========================================================
         */

            $clientes[] = [
                "nombre" => $nombre,
                "tipo_documento_id" => $tipo_documentos[$tipoDocumentoKey]->id,
                "nro_documento" => $nro_documento,
                "complemento" => $complemento,
                "fono" => $contacto,
                "correo" => $correo,
                "fecha_registro" => $fecha_actual,
            ];
        }

        /*
     * ============================================================
     * INSERTAR CLIENTES
     * ============================================================
     */

        if (!empty($clientes)) {
            Cliente::insert($clientes);
        }
        return count($clientes);
    }
}
