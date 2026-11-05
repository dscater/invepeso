<script setup>
import axios from "axios";
import MiPaginacion from "@/Components/MiPaginacion.vue";
import { ref, computed, onMounted, onUnmounted, watch, nextTick } from "vue";

const props = defineProps({
    cols: {
        type: Array,
        default: () => [],
    },

    data: {
        type: Array,
        default: () => [],
    },

    conPaginacion: {
        type: Boolean,
        default: true,
    },

    api: {
        type: Boolean,
        default: false,
    },

    url: {
        type: String,
        default: "",
    },

    sinRegistros: {
        type: String,
        default: "No se encontraron registros",
    },

    tableResponsive: {
        type: Boolean,
        default: false,
    },

    tableHeight: {
        type: [String, Number],
        default: null,
    },

    tableWidth: {
        type: [String, Number],
        default: null,
    },

    fixedHeader: {
        type: Boolean,
        default: false,
    },

    tableClass: {
        type: String,
        default: "",
    },

    headerClass: {
        type: String,
        default: "",
    },

    bodyClass: {
        type: String,
        default: "",
    },

    footerClass: {
        type: String,
        default: "",
    },

    paginationClass: {
        type: String,
        default: "",
    },

    perPage: {
        type: Number,
        default: 5,
    },

    filterPage: {
        type: Array,
        default: () => [5, 10, 20, 30, 50, 100],
    },

    syncOrderBy: {
        type: [String, Number],
        default: null,
    },

    syncOrderAsc: {
        type: String,
        default: null,
    },

    search: {
        type: String,
        default: "",
    },

    multiSearch: {
        type: Object,
        default: null,
    },

    numPages: {
        type: Number,
        default: 7,
    },

    loading: {
        type: Boolean,
        default: false,
    },

    textCargando: {
        type: String,
        default: "Cargando...",
    },

    delaySearch: {
        type: Number,
        default: 300,
    },

    card: {
        type: Boolean,
        default: false,
    },
});

/*
|--------------------------------------------------------------------------
| Estado principal
|--------------------------------------------------------------------------
*/

const listItems = ref([]);
const pLoading = ref(props.loading);
const error = ref(false);
const textSinRegistros = ref(props.sinRegistros);

const per_page = ref(props.perPage);
const currentPage = ref(1);

const orderBy = ref(props.syncOrderBy);
const orderAsc = ref(normalizarOrden(props.syncOrderAsc));

const tSearch = ref(props.search);
const oMultiSearch = ref(props.multiSearch);

const total = ref(0);
const totalPages = ref(0);

const cDeRegistros = ref(0);
const cARegistros = ref(0);

let requestController = null;
let requestSequence = 0;
let searchTimer = null;
let layoutFrame = null;

/*
|--------------------------------------------------------------------------
| Computed
|--------------------------------------------------------------------------
*/

const listCols = computed(() => props.cols ?? []);

const filter_page = computed(() => props.filterPage ?? []);

const dataLocal = computed(() => props.data ?? []);

const searchableColumns = computed(() => {
    return listCols.value.filter((column) => column.searchable !== false);
});

const fixedColumnMeta = computed(() => {
    const leftOffsets = {};
    const rightOffsets = {};

    let left = 0;
    let right = 0;
    let leftCount = 0;
    let rightCount = 0;

    listCols.value.forEach((column, index) => {
        if (column.fixed === true) {
            leftOffsets[index] = left;
            left += Number(listAnchoColumnas.value[index] ?? 0);
            leftCount++;
        }
    });

    for (let index = listCols.value.length - 1; index >= 0; index--) {
        if (listCols.value[index]?.fixed === "right") {
            rightOffsets[index] = right;
            right += Number(listAnchoColumnas.value[index] ?? 0);
            rightCount++;
        }
    }

    return {
        leftOffsets,
        rightOffsets,
        leftCount,
        rightCount,
    };
});

/*
|--------------------------------------------------------------------------
| Referencias DOM
|--------------------------------------------------------------------------
*/

const miTable = ref(null);
const miTableRef = ref(null);
const miTableHeaderRef = ref(null);
const miTableFooterRef = ref(null);

const miContentHeaderRef = ref(null);
const miContentTableRef = ref(null);
const miContentScrollRef = ref(null);

const scrollX = ref(null);
const scrollY = ref(null);

const widthMiTable = ref(0);
const widthParamContent = ref(0);
const listAnchoColumnas = ref([]);

const resizeObserver = ref(null);

/*
|--------------------------------------------------------------------------
| Watchers
|--------------------------------------------------------------------------
*/

watch(
    () => props.loading,
    (value) => {
        pLoading.value = value;
    },
);

watch(
    () => props.sinRegistros,
    (value) => {
        textSinRegistros.value = value;
    },
);

watch(
    () => props.perPage,
    (value) => {
        if (Number(value) !== Number(per_page.value)) {
            per_page.value = Number(value);
        }
    },
);

watch(
    () => props.search,
    (value) => {
        tSearch.value = value ?? "";
        programarBusqueda();
    },
);

watch(
    () => props.multiSearch,
    (value) => {
        oMultiSearch.value = value ?? null;
        programarBusqueda();
    },
    { deep: true },
);

watch(
    [() => props.syncOrderBy, () => props.syncOrderAsc],
    ([newOrderBy, newOrderAsc]) => {
        orderBy.value = newOrderBy;
        orderAsc.value = normalizarOrden(newOrderAsc);

        if (props.api) {
            cargarDatos();
        } else {
            cargarDatosLocal();
        }
    },
);

watch(
    () => props.data,
    () => {
        if (!props.api) {
            cargarDatosLocal();
        }
    },
    { deep: true },
);

watch(
    () => props.cols,
    async () => {
        await nextTick();
        programarLayout();
    },
    { deep: true },
);

watch(per_page, () => {
    currentPage.value = 1;
    cargarDatos();
});

/*
|--------------------------------------------------------------------------
| Carga de datos
|--------------------------------------------------------------------------
*/

async function cargarDatos() {
    if (props.api) {
        await cargarDatosApi();
        return;
    }

    cargarDatosLocal();
}

async function cargarDatosApi() {
    const currentRequest = ++requestSequence;

    if (!props.url) {
        error.value = true;
        console.error(
            "MiTable: la propiedad url es obligatoria cuando api=true.",
        );
        return;
    }

    requestController?.abort();
    requestController = new AbortController();

    setLoading(true);
    error.value = false;

    try {
        const response = await axios.get(props.url, {
            signal: requestController.signal,
            params: {
                page: currentPage.value,
                currentPage: currentPage.value,
                perPage: per_page.value,
                search: tSearch.value,
                orderBy: orderBy.value,
                orderAsc: orderAsc.value,
                ...(oMultiSearch.value ?? {}),
            },
        });

        if (currentRequest !== requestSequence) {
            return;
        }

        const responseData = response.data ?? {};

        listItems.value = Array.isArray(responseData.data)
            ? responseData.data
            : [];

        total.value = Number(responseData.total ?? 0);

        totalPages.value = Number(
            responseData.lastPage ??
                responseData.last_page ??
                calcularTotalPaginas(),
        );

        actualizarRangoRegistros();

        await actualizarLayout();

        emit("loaded", {
            data: listItems.value,
            total: total.value,
            page: currentPage.value,
        });

        if (!primeraCargaCompletada.value) {
            primeraCargaCompletada.value = true;
            emit("ready");
        }
    } catch (exception) {
        if (
            exception?.name === "CanceledError" ||
            exception?.name === "AbortError" ||
            exception?.code === "ERR_CANCELED"
        ) {
            return;
        }

        error.value = true;
        listItems.value = [];

        emit("load-error", exception);

        console.error("Error al cargar datos de MiTable:", exception);
    } finally {
        if (currentRequest === requestSequence) {
            setLoading(false);
        }
    }
}

async function cargarDatosLocal() {
    if (props.api) {
        return;
    }

    setLoading(true);
    error.value = false;

    const result = generarDatosPorLista();

    listItems.value = result.data;
    total.value = result.total;
    totalPages.value = result.lastPage;

    actualizarRangoRegistros();

    await nextTick();
    await actualizarLayout();

    if (!primeraCargaCompletada.value) {
        primeraCargaCompletada.value = true;
        emit("ready");
    }

    emit("loaded", {
        data: listItems.value,
        total: total.value,
        page: currentPage.value,
    });

    setLoading(false);
}

function programarBusqueda() {
    clearTimeout(searchTimer);

    setLoading(true);

    searchTimer = setTimeout(
        () => {
            currentPage.value = 1;
            cargarDatos();
        },
        Math.max(0, Number(props.delaySearch) || 0),
    );
}

function setLoading(value) {
    const newValue = Boolean(value);

    if (props.loading) {
        pLoading.value = props.loading;
        emit("loading", pLoading.value);
        return;
    }

    pLoading.value = newValue;
    emit("loading", pLoading.value);
}

/*
|--------------------------------------------------------------------------
| Procesamiento local
|--------------------------------------------------------------------------
*/

function generarDatosPorLista() {
    const search = normalizarTexto(tSearch.value);

    let filtered = [...dataLocal.value];

    if (search) {
        filtered = filtered.filter((item) => {
            return searchableColumns.value.some((column) => {
                const value = getColumnValue(item, column.key);
                return normalizarTexto(value).includes(search);
            });
        });
    }

    if (orderBy.value && orderAsc.value) {
        const column = listCols.value.find(
            (item) => item.key === orderBy.value,
        );

        if (column) {
            filtered.sort((a, b) => compararValores(a, b, column));
        }
    }

    const resultTotal = filtered.length;
    const pageSize = Math.max(1, Number(per_page.value) || 1);

    const lastPage = props.conPaginacion
        ? Math.max(1, Math.ceil(resultTotal / pageSize))
        : 1;

    if (currentPage.value > lastPage) {
        currentPage.value = lastPage;
    }

    const startIndex = props.conPaginacion
        ? (currentPage.value - 1) * pageSize
        : 0;

    const data = props.conPaginacion
        ? filtered.slice(startIndex, startIndex + pageSize)
        : filtered;

    return {
        data,
        total: resultTotal,
        lastPage,
    };
}

function compararValores(a, b, column) {
    const direction = orderAsc.value === "desc" ? -1 : 1;

    let valueA = getColumnValue(a, column.key);
    let valueB = getColumnValue(b, column.key);

    const type = String(column.type ?? "").toLowerCase();

    if (type === "number") {
        valueA = Number.parseFloat(valueA) || 0;
        valueB = Number.parseFloat(valueB) || 0;
    } else if (type === "date") {
        valueA = convertirFecha(valueA);
        valueB = convertirFecha(valueB);
    } else {
        valueA = normalizarTexto(valueA);
        valueB = normalizarTexto(valueB);
    }

    if (valueA < valueB) return -1 * direction;
    if (valueA > valueB) return 1 * direction;

    return 0;
}

function normalizarTexto(value) {
    if (value === null || value === undefined) {
        return "";
    }

    if (typeof value === "object") {
        return JSON.stringify(value).toLocaleLowerCase();
    }

    return String(value).trim().toLocaleLowerCase();
}

function convertirFecha(value) {
    if (!value) {
        return 0;
    }

    const text = String(value);

    if (/^\d{2}\/\d{2}\/\d{4}$/.test(text)) {
        const [day, month, year] = text.split("/");
        return new Date(`${year}-${month}-${day}`).getTime() || 0;
    }

    return new Date(text).getTime() || 0;
}

/*
|--------------------------------------------------------------------------
| Paginación y ordenación
|--------------------------------------------------------------------------
*/

function changeOrderBy(columnKey) {
    if (orderBy.value !== columnKey) {
        orderBy.value = columnKey;
        orderAsc.value = "asc";
    } else if (orderAsc.value === "asc") {
        orderAsc.value = "desc";
    } else if (orderAsc.value === "desc") {
        orderBy.value = null;
        orderAsc.value = null;
    } else {
        orderAsc.value = "asc";
    }

    currentPage.value = 1;
    cargarDatos();
}

function cambioDePagina(page) {
    const nextPage = Number(page) || 1;

    if (nextPage === currentPage.value) {
        return;
    }

    currentPage.value = nextPage;
    cargarDatos();
}

function cambiaPerPage() {
    currentPage.value = 1;
    cargarDatos();
}

function calcularTotalPaginas() {
    const pageSize = Math.max(1, Number(per_page.value) || 1);

    return props.conPaginacion
        ? Math.max(1, Math.ceil(total.value / pageSize))
        : 1;
}

function actualizarRangoRegistros() {
    if (!listItems.value.length || !total.value) {
        cDeRegistros.value = 0;
        cARegistros.value = 0;
        return;
    }

    const pageSize = Math.max(1, Number(per_page.value) || 1);
    const startIndex = (currentPage.value - 1) * pageSize;

    cDeRegistros.value = startIndex + 1;
    cARegistros.value = Math.min(
        startIndex + listItems.value.length,
        total.value,
    );
}

/*
|--------------------------------------------------------------------------
| Utilidades de columnas
|--------------------------------------------------------------------------
*/

function getColumnValue(object, key) {
    if (!key) {
        return undefined;
    }

    return String(key)
        .split(".")
        .reduce((current, part) => {
            return current == null ? undefined : current[part];
        }, object);
}

function getRowClass(item) {
    return listCols.value
        .map((column) => {
            return typeof column.classRow === "function"
                ? column.classRow(item)
                : "";
        })
        .filter(Boolean)
        .join(" ");
}

function getClassActiveSort(column) {
    const sortableKey = props.api
        ? column.keySortable || column.key
        : column.key;

    return orderBy.value === sortableKey;
}

function getSortableKey(column) {
    return props.api ? column.keySortable || column.key : column.key;
}

function getClassShadow(column, index) {
    if (!column?.fixed || !miContentTableRef.value || !miTableRef.value) {
        return "";
    }

    if (miTableRef.value.offsetWidth <= miContentTableRef.value.offsetWidth) {
        return "";
    }

    const meta = fixedColumnMeta.value;

    if (
        column.fixed === "right" &&
        index === listCols.value.length - meta.rightCount
    ) {
        return "fixed-shadow-right";
    }

    if (column.fixed === true && index === meta.leftCount - 1) {
        return "fixed-shadow-left";
    }

    return "";
}

function getStyleColRenderizado(index) {
    const column = listCols.value[index];

    if (!column?.fixed) {
        return {};
    }

    if (props.tableResponsive && window.innerWidth <= 790) {
        return {};
    }

    if (column.fixed === "right") {
        return {
            right: `${fixedColumnMeta.value.rightOffsets[index] ?? 0}px`,
        };
    }

    return {
        left: `${fixedColumnMeta.value.leftOffsets[index] ?? 0}px`,
    };
}

/*
|--------------------------------------------------------------------------
| Layout y columnas fijas
|--------------------------------------------------------------------------
*/

function programarLayout() {
    cancelAnimationFrame(layoutFrame);

    layoutFrame = requestAnimationFrame(() => {
        actualizarLayout();
    });
}

async function actualizarLayout() {
    await nextTick();

    if (!miTable.value) {
        return;
    }

    widthMiTable.value = miTable.value.offsetWidth || 0;

    ajustarAnchoColumnas();
    establecerAltoContenedor();
    updateScrollbars();
}

function ajustarAnchoColumnas() {
    if (!miTable.value || !listCols.value.length) {
        return;
    }

    const tableWidth = miTable.value.offsetWidth || 0;

    const headerColumns =
        miContentHeaderRef.value?.querySelectorAll("col") ?? [];

    const bodyColumns = miContentTableRef.value?.querySelectorAll("col") ?? [];

    const footerColumns = miTableFooterRef.value?.querySelectorAll("col") ?? [];

    const widths = listCols.value.map((column, index) => {
        const minWidth = obtenerAnchoMinimoColumna(column, index);

        if (column.width) {
            const explicitWidth = convertirAnchoColumna(
                column.width,
                tableWidth,
            );

            return Math.max(explicitWidth, minWidth);
        }

        if (column.fitContent) {
            return minWidth;
        }

        if (column.grow) {
            return 0;
        }

        return minWidth;
    });

    const growIndexes = listCols.value
        .map((column, index) => (column.grow ? index : null))
        .filter((index) => index !== null);

    const widthUsed = widths.reduce((total, width) => total + width, 0);

    const remainingWidth = Math.max(0, tableWidth - widthUsed);

    if (growIndexes.length && remainingWidth > 0) {
        const widthPerGrowColumn = remainingWidth / growIndexes.length;

        growIndexes.forEach((index) => {
            widths[index] += widthPerGrowColumn;
        });
    }

    listAnchoColumnas.value = widths;

    aplicarAnchosColumnas(headerColumns, widths);
    aplicarAnchosColumnas(bodyColumns, widths);
    aplicarAnchosColumnas(footerColumns, widths);

    establecerColumnasFixedFooter();
}

function obtenerAnchoMinimoColumna(column, index) {
    const header = miContentHeaderRef.value?.querySelectorAll("th")[index];

    const label = header?.querySelector(".label");

    const labelWidth = label?.scrollWidth ?? label?.offsetWidth ?? 0;

    const padding = Number(column.padding ?? 32);

    const titleWidth = labelWidth + padding;

    const configuredMinWidth = column.minWidth
        ? convertirAnchoColumna(column.minWidth, widthMiTable.value)
        : 0;

    return Math.max(titleWidth, configuredMinWidth);
}

function convertirAnchoColumna(value, tableWidth) {
    if (value === null || value === undefined) {
        return 0;
    }

    if (typeof value === "number") {
        return value;
    }

    const text = String(value).trim();

    if (text.endsWith("%")) {
        const percentage = Number.parseFloat(text);

        return Number.isFinite(percentage)
            ? (tableWidth * percentage) / 100
            : 0;
    }

    if (text.endsWith("px")) {
        return Number.parseFloat(text) || 0;
    }

    return Number.parseFloat(text) || 0;
}

function aplicarAnchosColumnas(columns, widths) {
    columns.forEach((column, index) => {
        const width = widths[index];

        if (!column || !width) {
            return;
        }

        column.style.width = `${width}px`;
        column.style.minWidth = `${width}px`;
        column.style.maxWidth = `${width}px`;
    });
}

function getCalculoAnchoPVW(width) {
    const { unit, value } = obtenerUnidadValor(width);

    if (!unit || unit === "px") {
        return Number.parseInt(value, 10) || 0;
    }

    return Math.round(
        ((Number.parseFloat(value) || 0) * widthMiTable.value) / 100,
    );
}

function obtenerUnidadValor(value) {
    const text = String(value ?? "");
    const match = text.match(/^(\d+(?:\.\d+)?)(px|%)$/);

    if (!match) {
        return {
            unit: null,
            value: text,
        };
    }

    return {
        unit: match[2],
        value: match[1],
    };
}

function establecerAltoContenedor() {
    if (!miContentTableRef.value) {
        return;
    }

    if (props.tableHeight) {
        miContentTableRef.value.style.height = `${props.tableHeight}`;
        miContentTableRef.value.style.minHeight = `${props.tableHeight}`;
    } else {
        miContentTableRef.value.style.height = "";
        miContentTableRef.value.style.minHeight = `${
            Math.max(listItems.value.length, 1) * 53
        }px`;
    }
}

function establecerColumnasFixedFooter() {
    const footer = miTableFooterRef.value;

    if (!footer) {
        return;
    }

    footer.querySelectorAll("tr").forEach((row) => {
        const leftColumns = [...row.querySelectorAll(".fixed-column-ext")];

        const rightColumns = [
            ...row.querySelectorAll(".fixed-column-ext-right"),
        ].reverse();

        let left = 0;

        leftColumns.forEach((element) => {
            element.style.position = "sticky";
            element.style.left = `${left}px`;

            if (element.classList.contains("footer-fixed")) {
                element.style.bottom = "1px";
            }

            left += element.offsetWidth;
        });

        let right = 0;

        rightColumns.forEach((element) => {
            element.style.position = "sticky";
            element.style.right = `${right}px`;

            if (element.classList.contains("footer-fixed")) {
                element.style.bottom = "1px";
            }

            right += element.offsetWidth;
        });
    });
}

/*
|--------------------------------------------------------------------------
| Scroll personalizado
|--------------------------------------------------------------------------
*/

const isDragging = ref(false);
const dragAxis = ref(null);
const startPos = ref(0);
const startScroll = ref(0);
const originalScrollYpx = ref(-1);

function updateScrollbars() {
    const container = miContentTableRef.value;

    if (!container) {
        return;
    }

    const hasHorizontalScroll = container.scrollWidth > container.clientWidth;

    const hasVerticalScroll = container.scrollHeight > container.clientHeight;

    const xTrack = scrollX.value?.parentElement;
    const yTrack = scrollY.value?.parentElement;

    if (xTrack) {
        xTrack.style.display = hasHorizontalScroll ? "block" : "none";
    }

    if (yTrack) {
        yTrack.style.display = hasVerticalScroll ? "block" : "none";
    }

    if (hasHorizontalScroll && scrollX.value) {
        const width = (container.clientWidth / container.scrollWidth) * 100;

        scrollX.value.style.width = `${width}%`;
    }

    if (hasVerticalScroll && scrollY.value) {
        const height = (container.clientHeight / container.scrollHeight) * 100;

        scrollY.value.style.height = `${Math.max(height, 4)}%`;
        originalScrollYpx.value = scrollY.value.offsetHeight;
    }
}

function syncScrollBodyHeader() {
    if (!miContentTableRef.value || !miContentHeaderRef.value) {
        return;
    }

    miContentHeaderRef.value.scrollLeft = miContentTableRef.value.scrollLeft;
}

function scrollContentAHeader(event) {
    const target = event.currentTarget;

    if (miContentHeaderRef.value) {
        miContentHeaderRef.value.scrollLeft = target.scrollLeft;
    }

    if (scrollX.value && target.scrollWidth > target.clientWidth) {
        const progress =
            target.scrollLeft /
            Math.max(1, target.scrollWidth - target.clientWidth);

        const maxTrack = target.clientWidth - scrollX.value.offsetWidth;

        scrollX.value.style.left = `${progress * maxTrack}px`;
    }

    if (scrollY.value && target.scrollHeight > target.clientHeight) {
        const progress =
            target.scrollTop /
            Math.max(1, target.scrollHeight - target.clientHeight);

        const maxTrack = target.clientHeight - scrollY.value.offsetHeight;

        scrollY.value.style.top = `${progress * maxTrack}px`;
    }
}

function scrollHeaderAContent(event) {
    if (miContentTableRef.value) {
        miContentTableRef.value.scrollLeft = event.currentTarget.scrollLeft;
    }
}

function startDrag(axis, event) {
    if (!miContentTableRef.value) {
        return;
    }

    isDragging.value = true;
    dragAxis.value = axis;

    startPos.value = axis === "x" ? event.pageX : event.pageY;

    startScroll.value =
        axis === "x"
            ? miContentTableRef.value.scrollLeft
            : miContentTableRef.value.scrollTop;

    document.body.classList.add("no-select");

    document.addEventListener("mousemove", handleMouseMove);
    document.addEventListener("mouseup", stopDrag);
}

function handleMouseMove(event) {
    if (!isDragging.value || !miContentTableRef.value) {
        return;
    }

    const container = miContentTableRef.value;

    const currentPosition = dragAxis.value === "x" ? event.pageX : event.pageY;

    const difference = currentPosition - startPos.value;

    if (dragAxis.value === "x") {
        const ratio = container.scrollWidth / container.clientWidth;

        container.scrollLeft = startScroll.value + difference * ratio;
    } else {
        const ratio = container.scrollHeight / container.clientHeight;

        container.scrollTop = startScroll.value + difference * ratio;
    }

    scrollContentAHeader({
        currentTarget: container,
    });
}

function stopDrag() {
    isDragging.value = false;
    dragAxis.value = null;

    document.body.classList.remove("no-select");

    document.removeEventListener("mousemove", handleMouseMove);
    document.removeEventListener("mouseup", stopDrag);
}

/*
|--------------------------------------------------------------------------
| ResizeObserver
|--------------------------------------------------------------------------
*/

function iniciarResizeObserver() {
    if (typeof ResizeObserver === "undefined" || !miTable.value) {
        return;
    }

    resizeObserver.value = new ResizeObserver(() => {
        programarLayout();
    });

    resizeObserver.value.observe(miTable.value);
}

/*
|--------------------------------------------------------------------------
| Lifecycle
|--------------------------------------------------------------------------
*/

onMounted(async () => {
    await cargarDatos();

    await nextTick();

    if (!miTable.value) {
        return;
    }

    widthMiTable.value = miTable.value.offsetWidth || 0;

    miContentTableRef.value?.addEventListener("scroll", scrollContentAHeader, {
        passive: true,
    });

    miContentHeaderRef.value?.addEventListener("scroll", scrollHeaderAContent, {
        passive: true,
    });

    iniciarResizeObserver();
    programarLayout();
});

onUnmounted(() => {
    clearTimeout(searchTimer);
    cancelAnimationFrame(layoutFrame);

    requestController?.abort();

    resizeObserver.value?.disconnect();

    miContentTableRef.value?.removeEventListener(
        "scroll",
        scrollContentAHeader,
    );

    miContentHeaderRef.value?.removeEventListener(
        "scroll",
        scrollHeaderAContent,
    );

    stopDrag();
    document.body.classList.remove("no-select");
});

defineExpose({
    cargarDatos,
    setLoading,
});

// EMITS
const emit = defineEmits(["ready", "loaded", "load-error", "loading"]);

const primeraCargaCompletada = ref(false);

/*
|--------------------------------------------------------------------------
| Helpers
|--------------------------------------------------------------------------
*/

function normalizarOrden(value) {
    if (!value) {
        return null;
    }

    const normalized = String(value).toLowerCase();

    return ["asc", "desc"].includes(normalized) ? normalized : null;
}
</script>

<template>
    <div
        ref="miTable"
        class="mi-table"
        :class="[$attrs.class, fixedHeader ? 'tablaFixeada' : '']"
    >
        <div class="content-data">
            <!-- HEADER -->
            <div ref="miContentHeaderRef" class="mi-content-header">
                <table
                    ref="miTableHeaderRef"
                    class="table table-bordered"
                    :class="[
                        tableResponsive ? 'table-resposive' : '',
                        fixedHeader ? 'tablaFixeada' : '',
                    ]"
                >
                    <colgroup>
                        <col
                            v-for="(column, index) in listCols"
                            :key="column.key ?? column.label ?? index"
                        />
                    </colgroup>

                    <thead :class="headerClass">
                        <template v-if="$slots.tableHeader">
                            <slot name="tableHeader" />
                        </template>

                        <template v-else>
                            <tr>
                                <th
                                    v-for="(column, index) in listCols"
                                    :key="column.key ?? column.label ?? index"
                                    :colspan="column.colspan ?? 1"
                                    :class="[
                                        column.fixed === true
                                            ? 'fixed-column'
                                            : '',
                                        column.fixed === 'right'
                                            ? 'fixed-column-right'
                                            : '',
                                        fixedHeader ? 'fixed-header' : '',
                                        getClassShadow(column, index),
                                    ]"
                                    :style="getStyleColRenderizado(index)"
                                >
                                    <div
                                        v-if="column.sortable"
                                        class="iheader sortable"
                                        @click="
                                            changeOrderBy(
                                                getSortableKey(column),
                                            )
                                        "
                                    >
                                        <div class="label">
                                            {{ column.label }}
                                        </div>

                                        <div
                                            class="accion"
                                            :class="{
                                                active: getClassActiveSort(
                                                    column,
                                                ),
                                            }"
                                        >
                                            <i
                                                class="fa"
                                                :class="{
                                                    'fa-sort-amount-up-alt':
                                                        orderAsc === 'asc' &&
                                                        orderBy ===
                                                            getSortableKey(
                                                                column,
                                                            ),

                                                    'fa-sort-amount-down':
                                                        orderAsc === 'desc' &&
                                                        orderBy ===
                                                            getSortableKey(
                                                                column,
                                                            ),

                                                    'fa-sort':
                                                        !orderAsc ||
                                                        orderBy !==
                                                            getSortableKey(
                                                                column,
                                                            ),
                                                }"
                                            />
                                        </div>
                                    </div>

                                    <div v-else class="iheader">
                                        <div class="label">
                                            {{ column.label }}
                                        </div>
                                    </div>
                                </th>
                            </tr>
                        </template>
                    </thead>
                </table>
            </div>

            <!-- BODY -->
            <div ref="miContentScrollRef" class="mi-content-scroll">
                <div
                    ref="miContentTableRef"
                    class="content-table"
                    :style="{
                        maxHeight: tableHeight ? `${tableHeight}` : '',
                        width: tableWidth ? `${tableWidth}` : '',
                    }"
                >
                    <div v-show="pLoading" class="mi-loading-table">
                        <div>
                            <slot v-if="$slots.loading" name="loading" />

                            <template v-else>
                                {{ textCargando }}
                            </template>
                        </div>
                    </div>

                    <table
                        ref="miTableRef"
                        class="table table-bordered mb-0"
                        :class="[
                            tableClass,
                            tableResponsive ? 'table-resposive' : '',
                        ]"
                    >
                        <colgroup>
                            <col
                                v-for="(column, index) in listCols"
                                :key="column.key ?? column.label ?? index"
                            />
                        </colgroup>

                        <tbody
                            class="table-body"
                            :class="[
                                bodyClass,
                                pLoading ? 'loading_active' : '',
                            ]"
                        >
                            <template v-if="listItems.length">
                                <tr
                                    v-for="(item, rowIndex) in listItems"
                                    :key="item.id ?? item.uuid ?? rowIndex"
                                    :class="getRowClass(item)"
                                >
                                    <td
                                        v-for="(
                                            column, columnIndex
                                        ) in listCols"
                                        :key="
                                            column.key ??
                                            column.label ??
                                            columnIndex
                                        "
                                        :colspan="item.colspan ?? 1"
                                        :class="[
                                            column.fixed === true
                                                ? 'fixed-column'
                                                : '',
                                            column.fixed === 'right'
                                                ? 'fixed-column-right'
                                                : '',
                                            getClassShadow(column, columnIndex),
                                        ]"
                                        :style="
                                            getStyleColRenderizado(columnIndex)
                                        "
                                    >
                                        <div
                                            class="label-responsive"
                                            v-text="`${column.label}:`"
                                        />

                                        <div
                                            class="mi-celda"
                                            :class="
                                                typeof column.classTd ===
                                                'function'
                                                    ? column.classTd(item)
                                                    : ''
                                            "
                                        >
                                            <slot
                                                v-if="
                                                    column.key &&
                                                    $slots[column.key]
                                                "
                                                :name="column.key"
                                                :item="item"
                                                v-bind="$attrs"
                                            />

                                            <template v-else>
                                                {{
                                                    column.isIndex
                                                        ? rowIndex + 1
                                                        : typeof column.render ===
                                                            "function"
                                                          ? column.render(
                                                                item,
                                                                rowIndex,
                                                            )
                                                          : column.key
                                                            ? getColumnValue(
                                                                  item,
                                                                  column.key,
                                                              )
                                                            : ""
                                                }}
                                            </template>
                                        </div>
                                    </td>
                                </tr>
                            </template>

                            <template v-else>
                                <tr>
                                    <td
                                        :colspan="listCols.length"
                                        class="text-center py-2"
                                    >
                                        {{ textSinRegistros }}
                                    </td>
                                </tr>
                            </template>
                        </tbody>
                    </table>
                </div>

                <!-- SCROLL HORIZONTAL -->
                <div class="content-scroll-x">
                    <div
                        ref="scrollX"
                        class="mi-custom-scroll-x"
                        @mousedown="startDrag('x', $event)"
                    />
                </div>

                <!-- SCROLL VERTICAL -->
                <div class="content-scroll-y">
                    <div
                        ref="scrollY"
                        class="mi-custom-scroll-y"
                        @mousedown="startDrag('y', $event)"
                    />
                </div>
            </div>

            <!-- FOOTER -->
            <div
                v-if="$slots.tableFooter"
                ref="miContentFooter"
                class="mi-content-footer"
            >
                <table ref="miTableFooterRef" class="table table-bordered">
                    <colgroup>
                        <col
                            v-for="(column, index) in listCols"
                            :key="column.key ?? column.label ?? index"
                        />
                    </colgroup>

                    <tbody :class="footerClass">
                        <slot name="tableFooter" />
                    </tbody>
                </table>
            </div>
        </div>

        <!-- PAGINATION -->
        <div v-if="conPaginacion" class="content-foot">
            <div class="row mt-1">
                <div class="my-1 col-md-3">
                    <select v-model="per_page" class="form-control rounded-0">
                        <option
                            v-for="item in filter_page"
                            :key="item"
                            :value="item"
                        >
                            Mostrar {{ item }} registros
                        </option>
                    </select>
                </div>

                <div
                    class="my-1 col-md-6 d-flex justify-content-center"
                    :class="paginationClass"
                >
                    <MiPaginacion
                        :current-page="currentPage"
                        :total-data="total"
                        :per-page="per_page"
                        :num-pages="numPages"
                        @updatePage="cambioDePagina"
                    />
                </div>

                <div class="my-1 col-md-3 text-right">
                    Mostrando {{ cDeRegistros }} a {{ cARegistros }} registros.
                    Total {{ total }} registros.
                </div>
            </div>

            <div v-if="error" class="alert alert-danger">
                Ocurrió un error al intentar obtener los registros.
            </div>
        </div>
    </div>
</template>

<style scoped>
.mi-content-scroll {
    position: relative;
}

.content-scroll-x,
.content-scroll-y {
    opacity: 0.7;
    position: absolute;
    background-color: transparent;
    z-index: 3;
}

.mi-table .mi-content-scroll:hover .content-scroll-x,
.mi-table .mi-content-scroll:hover .content-scroll-y {
    opacity: 1;
}

.content-scroll-x {
    height: 10px;
    width: 100%;
    bottom: 0;
}

.content-scroll-y {
    height: 100%;
    width: 10px;
    top: 0;
    right: 0;
}

.mi-custom-scroll-y,
.mi-custom-scroll-x {
    position: absolute;
    background: #cacaca;
    cursor: pointer;
    border-radius: 10px;
}

.mi-custom-scroll-y {
    margin-left: 2px;
    width: 8px;
    top: 0;
    right: 0;
}

.mi-custom-scroll-x {
    margin-top: 2px;
    height: 8px;
    left: 0;
}

.mi-content-header table,
.content-table table,
.mi-content-footer table {
    table-layout: fixed;
    width: max-content;
    min-width: 100%;
}

.mi-content-header th,
.content-table td,
.content-table th,
.mi-content-footer td,
.mi-content-footer th {
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}
</style>
