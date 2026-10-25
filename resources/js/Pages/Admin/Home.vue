<script setup>
import {
    ref,
    reactive,
    computed,
    watch,
    onMounted,
    onBeforeUnmount,
} from "vue";
import { Head } from "@inertiajs/vue3";
import axios from "axios";
import Highcharts from "highcharts";

import App from "@/Layouts/App.vue";
import Content from "@/Components/Content.vue";

import { ElSelect, ElOption } from "element-plus";

import "element-plus/dist/index.css";

// --------------------------------------------------
// PROPS
// --------------------------------------------------

const props = defineProps({
    usuarios: {
        type: Array,
        default: () => [],
    },
    almacens: {
        type: Array,
        default: () => [],
    },
});

// --------------------------------------------------
// FILTROS
// --------------------------------------------------

const periodo = ref("7dias");
const anio = ref(new Date().getFullYear());
const userId = ref("");
const almacenId = ref("");

// --------------------------------------------------
// COLORES CENTRALIZADOS
// Puedes personalizarlos desde este objeto.
// --------------------------------------------------

const colores = {
    ingresos: "#16A34A",
    egresos: "#DC2626",

    stockActual: "#22C55E",
    stockMinimo: "#F59E0B",

    contado: "#06B6D4",
    credito: "#8B5CF6",

    efectivo: "#0EA5E9",
    qr: "#8B5CF6",
    efectivoQr: "#F59E0B",

    ventas: "#3B82F6",
    clientes: "#8B5CF6",
    productosVendidos: "#14B8A6",

    texto: "#334155",
    grid: "#E5E7EB",
};

// --------------------------------------------------
// CONFIGURACIÓN DE LOS GRÁFICOS
// --------------------------------------------------

const graficos = [
    {
        id: "ventas_dia",
        titulo: "Ventas realizadas",
        subtitulo: "Cantidad de ventas por fecha",
        ruta: "ventas_dia",
        tipo: "line",
        color: colores.ventas,
        unidad: "ventas",
        usaUsuario: true,
        usaAlmacen: true,
        usaPeriodo: true,
    },
    {
        id: "clientes_nuevos",
        titulo: "Clientes nuevos",
        subtitulo: "Nuevos clientes registrados",
        ruta: "clientes_nuevos",
        tipo: "line",
        color: colores.clientes,
        unidad: "clientes",
        usaUsuario: false,
        usaAlmacen: false,
        usaPeriodo: true,
    },
    {
        id: "ingresos_egresos",
        titulo: "Ingresos y egresos",
        subtitulo: "Comparación de movimientos de caja",
        ruta: "ingresos_egresos",
        tipo: "areaspline",
        unidad: "Bs",
        usaUsuario: true,
        usaAlmacen: true,
        usaPeriodo: true,
    },
    {
        id: "contado_credito",
        titulo: "Ventas al contado y crédito",
        subtitulo: "Distribución por tipo de venta",
        ruta: "contado_credito",
        tipo: "pie",
        usaUsuario: true,
        usaAlmacen: true,
        usaPeriodo: true,
    },
    {
        id: "qrefectivo",
        titulo: "Ventas por tipo de pago",
        subtitulo: "Efectivo, QR y pagos combinados",
        ruta: "qrefectivo",
        tipo: "pie",
        usaUsuario: true,
        usaAlmacen: true,
        usaPeriodo: true,
    },
    {
        id: "masVendidos",
        titulo: "Productos más vendidos",
        subtitulo: "Los 10 productos con mayor cantidad vendida",
        ruta: "masVendidos",
        tipo: "bar",
        color: colores.productosVendidos,
        unidad: "unidades",
        usaUsuario: true,
        usaAlmacen: true,
        usaPeriodo: true,
    },
    {
        id: "pocoStock",
        titulo: "Productos con poco stock",
        subtitulo: "Existencias próximas al mínimo requerido",
        ruta: "pocoStock",
        tipo: "bar",
        unidad: "unidades",
        usaUsuario: false,
        usaAlmacen: true,
        usaPeriodo: false,
    },
];
// --------------------------------------------------
// ESTADOS
// --------------------------------------------------

const cargando = reactive({});
const errores = reactive({});
const chartContainers = {};
const chartInstances = {};

graficos.forEach((grafico) => {
    cargando[grafico.id] = false;
    errores[grafico.id] = "";
});

// --------------------------------------------------
// ASIGNACIÓN DE CONTENEDORES
// --------------------------------------------------

function asignarContenedor(id, elemento) {
    if (elemento) {
        chartContainers[id] = elemento;
    }
}

// --------------------------------------------------
// COLORES SEGÚN EL NOMBRE DE LA SERIE
// --------------------------------------------------

function obtenerColorSerie(nombre) {
    const texto = String(nombre ?? "")
        .trim()
        .toLowerCase()
        .normalize("NFD")
        .replace(/[\u0300-\u036f]/g, "");

    if (texto.includes("ingreso")) return colores.ingresos;
    if (texto.includes("egreso")) return colores.egresos;

    if (texto.includes("contado")) return colores.contado;
    if (texto.includes("credito")) return colores.credito;

    if (texto === "qr" || texto.includes("pago qr")) {
        return colores.qr;
    }

    if (
        texto.includes("efectivo y qr") ||
        texto.includes("efectivo-qr") ||
        texto.includes("efectivo + qr")
    ) {
        return colores.efectivoQr;
    }

    if (texto.includes("efectivo")) return colores.efectivo;

    if (texto.includes("stock actual")) return colores.stockActual;
    if (texto.includes("stock minimo")) return colores.stockMinimo;

    return null;
}

// --------------------------------------------------
// PREPARAR LOS DATOS RECIBIDOS DEL BACKEND
// --------------------------------------------------

function prepararSeries(config, respuesta) {
    // INGRESOS Y EGRESOS
    if (config.id === "ingresos_egresos") {
        return (respuesta.series ?? []).map((serie) => ({
            name: serie.name,
            data: serie.data ?? [],
            color: obtenerColorSerie(serie.name),
        }));
    }

    // GRÁFICOS CIRCULARES
    if (config.tipo === "pie") {
        return (respuesta.series ?? []).map((serie) => ({
            ...serie,
            type: "pie",
            data: (serie.data ?? []).map((punto) => ({
                ...punto,
                color:
                    obtenerColorSerie(punto.name) ??
                    obtenerColorSerie(serie.name) ??
                    undefined,
            })),
        }));
    }

    // PRODUCTOS CON POCO STOCK
    if (config.id === "pocoStock") {
        const stockActual = respuesta.datos ?? [];
        const stockMinimo = respuesta.stock_minimo ?? [];

        return [
            {
                name: "Stock actual",
                data: stockActual,
                color: colores.stockActual,
            },
            {
                name: "Stock mínimo",
                data: Array.isArray(stockMinimo)
                    ? stockMinimo
                    : stockActual.map(() => Number(stockMinimo) || 0),
                color: colores.stockMinimo,
            },
        ];
    }

    // RESTO DE GRÁFICOS
    return [
        {
            name: config.titulo,
            data: respuesta.datos ?? [],
            color: config.color,
        },
    ];
}

// --------------------------------------------------
// OPCIONES COMUNES DE HIGHCHARTS
// --------------------------------------------------

function crearOpciones(config, respuesta) {
    const categorias = respuesta.categorias ?? [];
    const series = prepararSeries(config, respuesta);

    const opcionesBase = {
        chart: {
            backgroundColor: "transparent",
            animation: true,
            spacing: [15, 10, 10, 10],
            style: {
                fontFamily: "inherit",
            },
        },

        title: {
            text: null,
        },

        credits: {
            enabled: false,
        },

        exporting: {
            enabled: true,
        },

        accessibility: {
            enabled: false,
        },

        colors: [
            colores.ingresos,
            colores.egresos,
            colores.contado,
            colores.credito,
            colores.efectivo,
            colores.qr,
            colores.efectivoQr,
        ],

        legend: {
            enabled: true,
            itemStyle: {
                color: colores.texto,
                fontWeight: "500",
            },
        },

        tooltip: {
            shared: config.tipo !== "pie",
            borderRadius: 8,
            valueSuffix:
                config.unidad === "Bs"
                    ? " Bs"
                    : config.unidad
                      ? ` ${config.unidad}`
                      : "",
        },

        xAxis: {
            categories: categorias,
            lineColor: colores.grid,
            tickColor: colores.grid,
            labels: {
                style: {
                    color: colores.texto,
                },
            },
        },

        yAxis: {
            title: {
                text:
                    config.unidad === "Bs"
                        ? "Monto (Bs)"
                        : (config.unidad ?? null),
            },
            gridLineColor: colores.grid,
            min: 0,
            labels: {
                style: {
                    color: colores.texto,
                },
            },
        },

        plotOptions: {
            series: {
                animation: {
                    duration: 500,
                },
                states: {
                    inactive: {
                        opacity: 0.5,
                    },
                },
            },

            line: {
                lineWidth: 3,
                marker: {
                    enabled: true,
                    radius: 4,
                },
            },

            areaspline: {
                lineWidth: 3,
                fillOpacity: 0.16,
                marker: {
                    enabled: true,
                    radius: 3,
                },
            },

            column: {
                borderWidth: 0,
                borderRadius: 4,
                groupPadding: 0.12,
            },

            bar: {
                borderWidth: 0,
                borderRadius: 4,
                groupPadding: 0.12,
            },

            pie: {
                allowPointSelect: true,
                cursor: "pointer",
                borderWidth: 2,
                borderColor: "#FFFFFF",
                showInLegend: true,
                dataLabels: {
                    enabled: true,
                    format: "{point.name}: {point.y}",
                    style: {
                        fontWeight: "500",
                        textOutline: "none",
                    },
                },
            },
        },

        series,
    };

    // GRÁFICOS CIRCULARES
    if (config.tipo === "pie") {
        delete opcionesBase.xAxis;
        delete opcionesBase.yAxis;
    }

    // INGRESOS Y EGRESOS: ÁREA VERDE Y ROJA
    if (config.tipo === "areaspline") {
        opcionesBase.chart.type = "areaspline";

        opcionesBase.xAxis.labels = {
            ...opcionesBase.xAxis.labels,
            rotation: -25,
        };

        opcionesBase.tooltip.valueSuffix = " Bs";
    }

    // BARRAS
    if (config.tipo === "bar") {
        opcionesBase.chart.type = "bar";

        opcionesBase.xAxis = {
            categories: categorias,
            lineColor: colores.grid,
            labels: {
                style: {
                    color: colores.texto,
                },
            },
        };

        opcionesBase.yAxis = {
            min: 0,
            title: {
                text: config.unidad ?? null,
            },
            gridLineColor: colores.grid,
            labels: {
                style: {
                    color: colores.texto,
                },
            },
        };
    }

    // LÍNEAS
    if (config.tipo === "line") {
        opcionesBase.chart.type = "line";
    }

    return opcionesBase;
}

// --------------------------------------------------
// CREAR O ACTUALIZAR UN GRÁFICO
// --------------------------------------------------

function renderizarGrafico(config, respuesta) {
    const contenedor = chartContainers[config.id];

    if (!contenedor) return;

    if (chartInstances[config.id]) {
        chartInstances[config.id].destroy();
    }

    chartInstances[config.id] = Highcharts.chart(
        contenedor,
        crearOpciones(config, respuesta),
    );
}

// --------------------------------------------------
// CARGAR UN GRÁFICO DESDE LARAVEL
// --------------------------------------------------

async function cargarGrafico(config) {
    cargando[config.id] = true;
    errores[config.id] = "";

    try {
        const params = {};

        // Filtros de período y usuario
        if (config.id !== "pocoStock") {
            params.periodo = periodo.value;
            params.anio = anio.value;

            if (userId.value !== "") {
                params.user_id = userId.value;
            }
        }

        // Filtro de almacén
        if (
            config.usaAlmacen &&
            almacenId.value !== "" &&
            almacenId.value !== "todos"
        ) {
            params.almacen_id = almacenId.value;
        }

        const response = await axios.get(route(config.ruta), {
            params,
        });

        renderizarGrafico(config, response.data);
    } catch (error) {
        console.error(
            `Error al cargar ${config.id}:`,
            error.response?.data ?? error,
        );

        errores[config.id] =
            error.response?.data?.message ?? "No se pudo cargar este gráfico.";
    } finally {
        cargando[config.id] = false;
    }
}

// --------------------------------------------------
// CARGAR TODOS LOS GRÁFICOS
// --------------------------------------------------

async function cargarTodosLosGraficos() {
    await Promise.all(graficos.map((config) => cargarGrafico(config)));
}

// --------------------------------------------------
// FILTROS: RECARGAR CUANDO CAMBIEN
// --------------------------------------------------

watch([periodo, anio, userId, almacenId], () => {
    cargarTodosLosGraficos();
});

// --------------------------------------------------
// CICLO DE VIDA
// --------------------------------------------------

onMounted(() => {
    cargarTodosLosGraficos();
});

onBeforeUnmount(() => {
    Object.values(chartInstances).forEach((chart) => {
        if (chart) {
            chart.destroy();
        }
    });
});
</script>
<template>
    <Head title="Inicio" />

    <Content>
        <div class="dashboard-container">
            <!-- ENCABEZADO DEL DASHBOARD -->
            <div class="dashboard-heading mb-4">
                <div class="dashboard-heading-text">
                    <div class="dashboard-title-icon">
                        <i class="fa fa-chart-line"></i>
                    </div>

                    <div>
                        <h3 class="dashboard-main-title">Inicio</h3>
                        <p class="dashboard-main-subtitle">
                            Resumen y análisis de tu negocio
                        </p>
                    </div>
                </div>

                <button
                    type="button"
                    class="btn btn-primary dashboard-refresh-all"
                    :disabled="graficos.some((grafico) => cargando[grafico.id])"
                    @click="cargarTodosLosGraficos"
                >
                    <i
                        class="fa me-2"
                        :class="
                            graficos.some((grafico) => cargando[grafico.id])
                                ? 'fa-spinner fa-spin'
                                : 'fa-sync-alt'
                        "
                    ></i>
                    Actualizar todo
                </button>
            </div>

            <!-- FILTROS DEL DASHBOARD -->
            <div class="card dashboard-filter-card mb-4">
                <div class="card-body">
                    <div class="dashboard-filter-heading">
                        <div class="dashboard-filter-heading-icon">
                            <i class="fa fa-sliders-h"></i>
                        </div>

                        <div>
                            <h5 class="dashboard-filter-title">
                                Filtros del dashboard
                            </h5>
                            <p class="dashboard-filter-description">
                                Personaliza la información que deseas consultar
                            </p>
                        </div>

                        <button
                            type="button"
                            class="btn btn-sm btn-outline-secondary dashboard-reset-button"
                            @click="
                                periodo = '7dias';
                                anio = new Date().getFullYear();
                                userId = '';
                                almacenId = '';
                            "
                            title="Restablecer todos los filtros"
                        >
                            <i class="fa fa-undo me-1"></i>
                            Restablecer
                        </button>
                    </div>

                    <div class="dashboard-filter-divider"></div>

                    <div class="row g-3">
                        <!-- PERIODO -->
                        <div class="col-12 col-sm-6 col-xl-3">
                            <label class="dashboard-filter-label">
                                <i class="fa fa-calendar-alt"></i>
                                Periodo
                            </label>

                            <el-select
                                v-model="periodo"
                                class="w-100 dashboard-select"
                                placeholder="Seleccionar periodo"
                            >
                                <el-option
                                    label="Últimos 7 días"
                                    value="7dias"
                                />
                                <el-option label="Por mes" value="mes" />
                                <el-option label="Por año" value="anio" />
                            </el-select>
                        </div>

                        <!-- AÑO -->
                        <div class="col-12 col-sm-6 col-xl-3">
                            <label class="dashboard-filter-label">
                                <i class="fa fa-calendar-check"></i>
                                Año
                            </label>

                            <el-select
                                v-model="anio"
                                class="w-100 dashboard-select"
                                placeholder="Seleccionar año"
                            >
                                <el-option
                                    v-for="year in Array.from(
                                        { length: 6 },
                                        (_, index) =>
                                            new Date().getFullYear() - index,
                                    )"
                                    :key="year"
                                    :label="String(year)"
                                    :value="year"
                                />
                            </el-select>
                        </div>

                        <!-- USUARIO -->
                        <div class="col-12 col-sm-6 col-xl-3">
                            <label class="dashboard-filter-label">
                                <i class="fa fa-user"></i>
                                Usuario
                            </label>

                            <el-select
                                v-model="userId"
                                class="w-100 dashboard-select"
                                clearable
                                filterable
                                placeholder="Todos los usuarios"
                                no-data-text="Sin datos"
                                no-match-text="Sin resultados"
                            >
                                <el-option
                                    label="Todos los usuarios"
                                    value=""
                                />

                                <el-option
                                    v-for="usuario in usuarios"
                                    :key="usuario.id"
                                    :label="
                                        usuario.name ??
                                        usuario.nombre ??
                                        `Usuario ${usuario.id}`
                                    "
                                    :value="String(usuario.id)"
                                />
                            </el-select>
                        </div>

                        <!-- ALMACÉN -->
                        <div class="col-12 col-sm-6 col-xl-3">
                            <label class="dashboard-filter-label">
                                <i class="fa fa-warehouse"></i>
                                Almacén
                            </label>

                            <el-select
                                v-model="almacenId"
                                class="w-100 dashboard-select"
                                filterable
                                clearable
                                placeholder="Todos los almacenes"
                                no-data-text="Sin datos"
                                no-match-text="Sin resultados"
                            >
                                <el-option
                                    v-for="item in almacens"
                                    :key="item.id"
                                    :value="item.id"
                                    :label="`${item.nombre}${
                                        item.sucursal
                                            ? ' - ' + item.sucursal.nombre
                                            : ''
                                    }`"
                                />
                            </el-select>
                        </div>
                    </div>

                    <div class="dashboard-filter-footer">
                        <i class="fa fa-info-circle"></i>
                        Los cambios en los filtros actualizan automáticamente
                        los gráficos.
                    </div>
                </div>
            </div>

            <!-- GRÁFICOS -->
            <div class="row g-4">
                <div
                    v-for="config in graficos"
                    :key="config.id"
                    class="col-12 col-xl-6"
                >
                    <div class="card dashboard-chart-card h-100">
                        <div class="card-header chart-card-header">
                            <div class="chart-heading">
                                <h5 class="card-title">
                                    {{ config.titulo }}
                                </h5>

                                <small class="chart-subtitle">
                                    {{ config.subtitulo }}
                                </small>
                            </div>

                            <button
                                type="button"
                                class="btn btn-sm btn-outline-primary chart-refresh"
                                :disabled="cargando[config.id]"
                                @click="cargarGrafico(config)"
                                title="Actualizar este gráfico"
                            >
                                <i
                                    class="fa"
                                    :class="
                                        cargando[config.id]
                                            ? 'fa-spinner fa-spin'
                                            : 'fa-sync-alt'
                                    "
                                ></i>
                            </button>
                        </div>

                        <div class="card-body chart-card-body">
                            <div
                                v-if="errores[config.id]"
                                class="alert alert-danger py-2"
                                role="alert"
                            >
                                {{ errores[config.id] }}

                                <button
                                    type="button"
                                    class="btn btn-sm btn-link"
                                    @click="cargarGrafico(config)"
                                >
                                    Reintentar
                                </button>
                            </div>

                            <div
                                v-if="
                                    cargando[config.id] &&
                                    !chartInstances[config.id]
                                "
                                class="chart-loading"
                            >
                                <i class="fa fa-spinner fa-spin"></i>
                                <span>Cargando gráfico...</span>
                            </div>

                            <div
                                :ref="
                                    (elemento) =>
                                        asignarContenedor(config.id, elemento)
                                "
                                class="chart-container"
                                :class="{
                                    'chart-container-loading':
                                        cargando[config.id],
                                }"
                            ></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </Content>
</template>

<style scoped>
.dashboard-container {
    padding: 8px 0 24px;
}

.dashboard-title h3 {
    font-weight: 700;
    color: #1e293b;
}

.dashboard-filter-card,
.dashboard-chart-card {
    border: 1px solid #e8edf3;
    border-radius: 12px;
    box-shadow: 0 3px 12px rgb(15 23 42 / 4%);
    overflow: hidden;
}

.dashboard-filter-card .card-body {
    padding: 20px;
}

.dashboard-chart-card .chart-card-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 16px;
    width: 100%;
    min-height: 76px;
    padding: 14px 18px;
    background: #fff;
    border-bottom: 1px solid #eef2f7;
    box-sizing: border-box;
}

.dashboard-chart-card .chart-heading {
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    justify-content: center;
    flex: 1;
    min-width: 0;
}

.dashboard-chart-card .chart-heading .card-title {
    margin: 0;
    padding: 0;
    font-size: 1rem;
    font-weight: 600;
    line-height: 1.4;
    text-align: left;
    color: #1e293b;
}

.dashboard-chart-card .chart-subtitle {
    display: block;
    margin-top: 4px;
    color: #64748b;
    line-height: 1.4;
    text-align: left;
}

.dashboard-chart-card .chart-refresh {
    flex: 0 0 auto;
    margin-left: auto;
}

.dashboard-chart-card .chart-card-body {
    position: relative;
    min-height: 340px;
    padding: 16px;
}

.chart-container {
    width: 100%;
    min-height: 300px;
    transition: opacity 0.2s ease;
}

.chart-container-loading {
    opacity: 0.65;
}

.chart-loading {
    position: absolute;
    z-index: 2;
    inset: 0;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    color: #64748b;
    background: rgb(255 255 255 / 75%);
}

@media (max-width: 576px) {
    .dashboard-chart-card .chart-card-header {
        gap: 10px;
        padding: 12px;
    }

    .dashboard-chart-card .chart-card-body {
        padding: 10px;
    }

    .chart-container {
        min-height: 280px;
    }
}

/* ENCABEZADO */
.dashboard-heading {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 20px;
    flex-wrap: wrap;
}

.dashboard-heading-text {
    display: flex;
    align-items: center;
    gap: 14px;
}

.dashboard-title-icon {
    width: 48px;
    height: 48px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 13px;
    background: #eaf2ff;
    color: #2563eb;
    font-size: 21px;
    flex-shrink: 0;
}

.dashboard-main-title {
    margin: 0;
    color: #1e293b;
    font-size: 1.6rem;
    font-weight: 700;
    line-height: 1.35;
}

.dashboard-main-subtitle {
    margin: 4px 0 0;
    color: #64748b;
    font-size: 0.92rem;
}

.dashboard-refresh-all {
    border-radius: 8px;
    padding: 10px 16px;
    font-weight: 500;
    box-shadow: 0 3px 8px rgb(37 99 235 / 15%);
}

/* TARJETA DE FILTROS */
.dashboard-filter-card {
    border: 1px solid #e7edf5;
    border-radius: 14px;
    background: #fff;
    box-shadow: 0 4px 16px rgb(15 23 42 / 4%);
    overflow: visible;
}

.dashboard-filter-card .card-body {
    padding: 22px;
}

.dashboard-filter-heading {
    display: flex;
    align-items: center;
    gap: 12px;
    flex-wrap: wrap;
}

.dashboard-filter-heading-icon {
    width: 40px;
    height: 40px;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
    border-radius: 10px;
    background: #f1f5f9;
    color: #475569;
    font-size: 17px;
}

.dashboard-filter-title {
    margin: 0;
    color: #1e293b;
    font-size: 1rem;
    font-weight: 650;
}

.dashboard-filter-description {
    margin: 4px 0 0;
    color: #64748b;
    font-size: 0.84rem;
}

.dashboard-reset-button {
    margin-left: auto;
    border-radius: 7px;
}

.dashboard-filter-divider {
    height: 1px;
    margin: 20px 0;
    background: #edf1f6;
}

/* ETIQUETAS */
.dashboard-filter-label {
    display: flex;
    align-items: center;
    gap: 8px;
    margin-bottom: 8px;
    color: #334155;
    font-size: 0.88rem;
    font-weight: 600;
}

.dashboard-filter-label i {
    width: 15px;
    color: #64748b;
    text-align: center;
}

/* PIE DE FILTROS */
.dashboard-filter-footer {
    display: flex;
    align-items: center;
    gap: 8px;
    margin-top: 20px;
    padding-top: 14px;
    border-top: 1px solid #edf1f6;
    color: #64748b;
    font-size: 0.82rem;
}

.dashboard-filter-footer i {
    color: #3b82f6;
}

/* RESPONSIVE */
@media (max-width: 576px) {
    .dashboard-heading {
        align-items: stretch;
    }

    .dashboard-refresh-all {
        width: 100%;
    }

    .dashboard-filter-card .card-body {
        padding: 16px;
    }

    .dashboard-filter-heading {
        align-items: flex-start;
    }

    .dashboard-reset-button {
        margin-left: 0;
    }

    .dashboard-filter-description {
        line-height: 1.4;
    }
}
</style>
