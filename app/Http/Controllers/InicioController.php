<?php

namespace App\Http\Controllers;

use App\Models\Almacen;
use Illuminate\Database\Eloquent\Builder;
use App\Models\User;
use App\Models\Venta;
use App\Models\Cliente;
use App\Models\VentaDetalle;
use App\Models\MovimientoCaja;
use App\Models\ProductoSucursal;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Inertia\Inertia;

class InicioController extends Controller
{

    public function verificaLogin()
    {
        $sw = false;
        if (Auth::check()) {
            $sw = true;
        }

        return response()->JSON(["sw" => $sw]);
    }

    public function inicio()
    {
        $array_infos = UserController::getInfoBoxUser();
        $usuarios = User::select('id', 'nombre', 'paterno', 'materno')
            ->where("id", "!=", 1)
            ->orderBy('paterno')
            ->get();
        $almacens = Almacen::with('sucursal:id,nombre')
            ->select('id', 'nombre', 'sucursal_id')
            ->orderBy('nombre')
            ->get();
        return Inertia::render('Admin/Home', [
            'array_infos' => $array_infos,

            'usuarios' => $usuarios,
            'almacens' => $almacens,
        ]);
    }

    public function login()
    {
        return Inertia::render("Auth/Login");
    }

    public function ventas_dia(Request $request)
    {
        $request->validate([
            'periodo' => 'nullable|in:7dias,mes,anio',
            'anio' => 'nullable|integer|min:2000|max:2100',
            'user_id' => 'nullable|integer|exists:users,id',
        ]);
        $almacenId = $request->input('almacen_id');
        $periodo = $request->input('periodo', '7dias');
        $usuarioId = $request->input('user_id');
        $anio = (int) $request->input('anio', now()->year);

        $hoy = Carbon::today();

        // Consulta base: únicamente ventas activas.
        $consulta = Venta::query()
            ->where('status', 1);

        if ($usuarioId) {
            $consulta->where('user_id', $usuarioId);
        }

        if ($almacenId) {
            $consulta->where('almacen_id', $almacenId);
        }

        /*
         * OPCIÓN 1: ÚLTIMOS 7 DÍAS
         */
        if ($periodo === '7dias') {
            $inicio = $hoy->copy()->subDays(6);

            $ventas = (clone $consulta)
                ->whereBetween('fecha', [
                    $inicio->copy()->startOfDay(),
                    $hoy->copy()->endOfDay(),
                ])
                ->selectRaw('DATE(fecha) as periodo')
                ->selectRaw('COUNT(*) as cantidad')
                ->groupByRaw('DATE(fecha)')
                ->orderBy('periodo')
                ->get()
                ->keyBy('periodo');

            $categorias = [];
            $datos = [];

            for ($i = 0; $i < 7; $i++) {
                $fecha = $inicio->copy()->addDays($i);
                $clave = $fecha->toDateString();

                $categorias[] = $fecha->format('d/m');
                $datos[] = (int) ($ventas->get($clave)->cantidad ?? 0);
            }
        }

        /*
         * OPCIÓN 2: POR MES
         * Muestra enero a diciembre del año seleccionado.
         */ elseif ($periodo === 'mes') {
            $ventas = (clone $consulta)
                ->whereYear('fecha', $anio)
                ->selectRaw('MONTH(fecha) as periodo')
                ->selectRaw('COUNT(*) as cantidad')
                ->groupByRaw('MONTH(fecha)')
                ->orderBy('periodo')
                ->get()
                ->keyBy('periodo');

            $categorias = [];
            $datos = [];

            for ($mes = 1; $mes <= 12; $mes++) {
                $categorias[] = Carbon::create($anio, $mes, 1)
                    ->locale('es')
                    ->translatedFormat('F');

                $datos[] = (int) (
                    $ventas->get($mes)->cantidad ?? 0
                );
            }
        }

        /*
         * OPCIÓN 3: POR AÑO
         * Muestra todos los años desde la primera venta
         * hasta el año actual.
         */ else {
            $primerAnio = (clone $consulta)
                ->min(DB::raw('YEAR(fecha)'));

            if (!$primerAnio) {
                $primerAnio = $hoy->year;
            }

            $ventas = (clone $consulta)
                ->selectRaw('YEAR(fecha) as periodo')
                ->selectRaw('COUNT(*) as cantidad')
                ->groupByRaw('YEAR(fecha)')
                ->orderBy('periodo')
                ->get()
                ->keyBy('periodo');

            $categorias = [];
            $datos = [];

            for (
                $year = (int) $primerAnio;
                $year <= $hoy->year;
                $year++
            ) {
                $categorias[] = (string) $year;

                $datos[] = (int) (
                    $ventas->get($year)->cantidad ?? 0
                );
            }
        }

        return response()->json([
            'categorias' => $categorias,
            'datos' => $datos,
            'periodo' => $periodo,
        ]);
    }

    public function clientes_nuevos(Request $request)
    {
        $filtros = $request->validate([
            'periodo' => 'required|in:7dias,mes,anio',
            'anio' => 'required|integer|min:2000|max:2100',
        ]);

        $periodo = $filtros['periodo'];
        $anio = (int) $filtros['anio'];

        $query = Cliente::query()
            ->where('status', 1);

        $query = $this->filtrarPorPeriodo(
            $query,
            'created_at',
            $periodo,
            $anio
        );

        $categorias = $this->obtenerCategorias(
            $periodo,
            $anio,
            Cliente::class,
            'created_at'
        );

        $agrupados = $this->agruparPorPeriodo(
            $query,
            'created_at',
            $periodo
        );

        return response()->json([
            'categorias' => $categorias,
            'datos' => $this->completarDatos(
                $categorias,
                $agrupados,
                $periodo
            ),
        ]);
    }

    public function ingresos_egresos(Request $request)
    {
        $filtros = $request->validate([
            'periodo' => 'required|in:7dias,mes,anio',
            'anio' => 'required|integer|min:2000|max:2100',
            'user_id' => 'nullable|integer',
        ]);

        $periodo = $filtros['periodo'];
        $anio = (int) $filtros['anio'];

        $base = MovimientoCaja::query()
            ->where('status', 1);

        if (!empty($filtros['user_id'])) {
            $base->where('user_id', $filtros['user_id']);
        }

        $almacenId = $request->input('almacen_id');
        if ($almacenId && $almacenId !== 'todos') {
            $base->where('almacen_id', $almacenId);
        }

        $base = $this->filtrarPorPeriodo(
            $base,
            'fecha',
            $periodo,
            $anio
        );

        $categorias = $this->obtenerCategorias(
            $periodo,
            $anio,
            MovimientoCaja::class,
            'fecha'
        );

        $ingresos = clone $base;
        $ingresos->where('tipo_movimiento', 'INGRESO');

        $egresos = clone $base;
        $egresos->where('tipo_movimiento', 'EGRESO');

        $datosIngresos = $this->agruparPorPeriodo(
            $ingresos,
            'fecha',
            $periodo,
            'SUM',
            'monto_total'
        );

        $datosEgresos = $this->agruparPorPeriodo(
            $egresos,
            'fecha',
            $periodo,
            'SUM',
            'monto_total'
        );

        return response()->json([
            'categorias' => $categorias,
            'series' => [
                [
                    'name' => 'Ingresos',
                    'data' => $this->completarDatos(
                        $categorias,
                        $datosIngresos,
                        $periodo
                    ),
                ],
                [
                    'name' => 'Egresos',
                    'data' => $this->completarDatos(
                        $categorias,
                        $datosEgresos,
                        $periodo
                    ),
                ],
            ],
        ]);
    }

    public function contado_credito(Request $request)
    {
        $filtros = $request->validate([
            'periodo' => 'required|in:7dias,mes,anio',
            'anio' => 'required|integer|min:2000|max:2100',
            'user_id' => 'nullable|integer',
        ]);

        $query = Venta::query()
            ->where('status', 1);

        if (!empty($filtros['user_id'])) {
            $query->where('user_id', $filtros['user_id']);
        }

        $almacenId = $request->input('almacen_id');
        if ($almacenId && $almacenId !== 'todos') {
            $query->where('almacen_id', $almacenId);
        }

        $query = $this->filtrarPorPeriodo(
            $query,
            'fecha',
            $filtros['periodo'],
            (int) $filtros['anio']
        );

        $resultados = $query
            ->select('tipo_venta', DB::raw('COUNT(*) AS total'))
            ->groupBy('tipo_venta')
            ->pluck('total', 'tipo_venta');

        return response()->json([
            'series' => [
                [
                    'name' => 'Ventas',
                    'data' => [
                        [
                            'name' => 'Al contado',
                            'y' => (int) ($resultados['AL CONTADO'] ?? 0),
                        ],
                        [
                            'name' => 'Crédito',
                            'y' => (int) ($resultados['CRÉDITO'] ?? 0),
                        ],
                    ],
                ],
            ],
        ]);
    }
    public function qrefectivo(Request $request)
    {
        $filtros = $request->validate([
            'periodo' => 'required|in:7dias,mes,anio',
            'anio' => 'required|integer|min:2000|max:2100',
            'user_id' => 'nullable|integer',
        ]);

        $query = Venta::query()
            ->where('status', 1);

        if (!empty($filtros['user_id'])) {
            $query->where('user_id', $filtros['user_id']);
        }

        $almacenId = $request->input('almacen_id');
        if ($almacenId && $almacenId !== 'todos') {
            $query->where('almacen_id', $almacenId);
        }


        $query = $this->filtrarPorPeriodo(
            $query,
            'fecha',
            $filtros['periodo'],
            (int) $filtros['anio']
        );

        $resultados = $query
            ->select('tipo_pago', DB::raw('COUNT(*) AS total'))
            ->groupBy('tipo_pago')
            ->pluck('total', 'tipo_pago');

        return response()->json([
            'series' => [
                [
                    'name' => 'Ventas',
                    'data' => [
                        [
                            'name' => 'Efectivo',
                            'y' => (int) ($resultados['EFECTIVO'] ?? 0),
                        ],
                        [
                            'name' => 'QR',
                            'y' => (int) ($resultados['QR'] ?? 0),
                        ],
                        [
                            'name' => 'Efectivo y QR',
                            'y' => (int) ($resultados['EFECTIVO-QR'] ?? 0),
                        ],
                    ],
                ],
            ],
        ]);
    }
    public function masVendidos(Request $request)
    {
        $filtros = $request->validate([
            'periodo' => 'required|in:7dias,mes,anio',
            'anio' => 'required|integer|min:2000|max:2100',
            'user_id' => 'nullable|integer',
        ]);

        $periodo = $filtros['periodo'];
        $anio = (int) $filtros['anio'];

        $query = VentaDetalle::query()
            ->join('ventas', 'ventas.id', '=', 'venta_detalles.venta_id')
            ->join('productos', 'productos.id', '=', 'venta_detalles.producto_id')
            ->where('venta_detalles.status', 1)
            ->where('ventas.status', 1);


        if (!empty($filtros['user_id'])) {
            $query->where('ventas.user_id', $filtros['user_id']);
        }

        $almacenId = $request->input('almacen_id');
        if ($almacenId && $almacenId !== 'todos') {
            $query->whereHas('venta', function ($q2) use ($almacenId) {
                $q2->where("almacen_id", $almacenId);
            });
        }

        $query = $this->filtrarPorPeriodo(
            $query,
            'ventas.fecha',
            $periodo,
            $anio
        );

        $productos = $query
            ->select(
                'productos.id',
                'productos.nombre',
                DB::raw('SUM(venta_detalles.cantidad) AS cantidad_vendida')
            )
            ->groupBy('productos.id', 'productos.nombre')
            ->orderByDesc('cantidad_vendida')
            ->limit(10)
            ->get();

        return response()->json([
            'categorias' => $productos->pluck('nombre')->values(),
            'datos' => $productos->pluck('cantidad_vendida')->map(
                fn($cantidad) => (float) $cantidad
            )->values(),
        ]);
    }
    public function pocoStock(Request $request)
    {
        $filtros = $request->validate([
            'sucursal_id' => 'nullable|integer',
            'almacen_id' => 'nullable|integer',
            'margen' => 'nullable|numeric|min:0|max:100',
        ]);

        $margen = (float) ($filtros['margen'] ?? 20);

        $query = ProductoSucursal::query()
            ->join(
                'productos',
                'productos.id',
                '=',
                'producto_sucursals.producto_id'
            )
            ->where('productos.activo', 1)
            ->whereNotNull('productos.stock_min')
            ->where('productos.stock_min', '>', 0)
            ->whereRaw(
                'producto_sucursals.stock_actual <= productos.stock_min * ?',
                [1 + ($margen / 100)]
            )
            ->select(
                'productos.id',
                'productos.nombre',
                'productos.stock_min',
                'producto_sucursals.stock_actual',
                'producto_sucursals.sucursal_id',
                'producto_sucursals.almacen_id'
            );

        if (!empty($filtros['sucursal_id'])) {
            $query->where(
                'producto_sucursals.sucursal_id',
                $filtros['sucursal_id']
            );
        }

        if (!empty($filtros['almacen_id'])) {
            $query->where(
                'producto_sucursals.almacen_id',
                $filtros['almacen_id']
            );
        }

        $productos = $query
            ->orderByRaw(
                '(producto_sucursals.stock_actual - productos.stock_min) ASC'
            )
            ->limit(10)
            ->get();

        return response()->json([
            'categorias' => $productos->map(function ($producto) {
                return $producto->nombre;
            })->values(),

            'datos' => $productos->pluck('stock_actual')->values(),

            'stock_minimo' => $productos->pluck('stock_min')->values(),

            'productos' => $productos,
        ]);
    }

    private function filtrarPorPeriodo(
        Builder $query,
        string $campoFecha,
        string $periodo,
        int $anio
    ): Builder {
        if ($periodo === '7dias') {
            $inicio = Carbon::today()->subDays(6);
            $fin = Carbon::today();

            return $query->whereBetween(
                $campoFecha,
                [
                    $inicio->startOfDay(),
                    $fin->endOfDay()
                ]
            );
        }

        if ($periodo === 'mes') {
            return $query->whereYear($campoFecha, $anio);
        }

        // Para "anio", se consideran todos los años disponibles.
        return $query;
    }

    private function obtenerCategorias(
        string $periodo,
        int $anio,
        string $modelo,
        string $campoFecha
    ): array {
        if ($periodo === '7dias') {
            $categorias = [];

            for ($i = 6; $i >= 0; $i--) {
                $categorias[] = Carbon::today()
                    ->subDays($i)
                    ->format('Y-m-d');
            }

            return $categorias;
        }

        if ($periodo === 'mes') {
            return collect(range(1, 12))
                ->map(fn($mes) => sprintf('%04d-%02d', $anio, $mes))
                ->all();
        }

        $primerAnio = $modelo::query()
            ->where('status', 1)
            ->min(DB::raw("YEAR($campoFecha)"));

        $primerAnio = $primerAnio ?: now()->year;

        return range((int) $primerAnio, now()->year);
    }

    private function agruparPorPeriodo(
        Builder $query,
        string $campoFecha,
        string $periodo,
        string $operacion = 'COUNT',
        string $campoValor = '*'
    ): array {
        if ($periodo === '7dias') {
            $formato = "DATE($campoFecha)";
            $alias = 'periodo';
        } elseif ($periodo === 'mes') {
            $formato = "DATE_FORMAT($campoFecha, '%Y-%m')";
            $alias = 'periodo';
        } else {
            $formato = "YEAR($campoFecha)";
            $alias = 'periodo';
        }

        $consulta = clone $query;

        $consulta->selectRaw(
            "$formato AS $alias, $operacion($campoValor) AS total"
        )->groupByRaw($formato);

        return $consulta->get()
            ->mapWithKeys(fn($item) => [
                (string) $item->periodo => (float) $item->total
            ])
            ->all();
    }

    private function completarDatos(
        array $categorias,
        array $agrupados,
        string $periodo
    ): array {
        return collect($categorias)
            ->map(function ($categoria) use ($agrupados, $periodo) {
                $clave = $periodo === 'anio'
                    ? (string) $categoria
                    : $categoria;

                return $agrupados[$clave] ?? 0;
            })
            ->all();
    }
}
