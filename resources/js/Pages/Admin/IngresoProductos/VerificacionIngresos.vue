<script setup>
import Content from "@/Components/Content.vue";
import { Head, Link, router, usePage } from "@inertiajs/vue3";
import { useIngresoProductos } from "@/composables/ingreso_productos/useIngresoProductos";
import { useAxios } from "@/composables/axios/useAxios";
import { ref, onMounted, onBeforeMount } from "vue";
import { useAppStore } from "@/stores/aplicacion/appStore";
// import { useMenu } from "@/composables/useMenu";
import { buttonProps } from "element-plus";
import { useDate } from "@/composables/useDate.js";
import axios from "axios";
// const { mobile, identificaDispositivo } = useMenu();

const { getFechaActual } = useDate();
const { props: props_page } = usePage();
const appStore = useAppStore();

const props = defineProps({
    almacens: {
        type: Array,
        default: () => [],
    },
});

const { setIngresoProducto, limpiarIngresoProducto, form } =
    useIngresoProductos();

// const listAlmacens = ref([]);
const almacen_id = ref("todos");
const codigo = ref("");
const fecha_ini = ref("");
const fecha_fin = ref("");
const ingreso_productos = ref([]);

// const cargarAlmacens = async () => {
//     try {
//         const res = await axios.get(route("almacens.listado"));
//         listAlmacens.value = res.data.almacens;
//         listAlmacens.value.unshift({
//             id: "todos",
//             nombre: "Todos los almacenes",
//         });
//     } catch (e) {
//         console.log(e);
//     } finally {
//     }
// };

const cargarIngresosSinVerificar = () => {
    axios
        .get(route("ingreso_productos.lista_sin_verificar"), {
            params: {
                almacen_id: almacen_id.value,
                codigo: codigo.value,
                fecha_ini: fecha_ini.value,
                fecha_fin: fecha_fin.value,
            },
        })
        .then((response) => {
            ingreso_productos.value = response.data;
        });
};

const intervalTimeOutListado = ref(null);
const cargaListado = () => {
    intervalTimeOutListado.value ?? clearInterval(intervalTimeOutListado.value);
    setTimeout(() => {
        cargarIngresosSinVerificar();
    }, 700);
};

onBeforeMount(() => {
    // cargarAlmacens();
    cargarIngresosSinVerificar();
    appStore.startLoading();
});

onMounted(() => {
    appStore.stopLoading();
});
</script>
<template>
    <Head title="Recepción de Compras"></Head>
    <Content>
        <template #header>
            <div class="row">
                <div class="col-sm-6">
                    <h3 class="m-0">
                        <i class="fa fa-boxes"></i> Recepción de Compras
                    </h3>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-end">
                        <li class="breadcrumb-item">
                            <Link :href="route('inicio')">Inicio</Link>
                        </li>
                        <li class="breadcrumb-item active">
                            Recepción de Compras
                        </li>
                    </ol>
                </div>
                <!-- /.col -->
            </div>
            <!-- /.row -->
        </template>
        <div class="row mb-2">
            <div class="col-md-3 col-sm-12">
                <span class="text-muted text-sm">Almacén</span>
                <el-select
                    v-model="almacen_id"
                    class="el-select-input-group-right"
                    no-data-text="Sin datos"
                    no-match-text="Sin resultados"
                    placeholder="Seleccionar Almacén"
                    filterable
                    @change="cargarIngresosSinVerificar"
                >
                    <el-option value="todos" label="Todos los almacenes" />
                    <el-option
                        v-for="item in almacens"
                        :key="item.id"
                        :value="item.id"
                        :label="`${item.nombre} ${item.sucursal ? ' - ' + item.sucursal.nombre : ''}`"
                    ></el-option>
                </el-select>
            </div>
            <div class="col-md-3 col-sm-6">
                <span class="text-muted text-sm">Código</span>
                <el-input
                    type="text"
                    v-model="codigo"
                    placeholder="Código de Compra"
                    @keyup="cargaListado"
                    @change="cargarIngresosSinVerificar"
                    @clear="cargarIngresosSinVerificar"
                    clearable
                ></el-input>
            </div>
            <div class="col-md-3 col-sm-6">
                <span class="text-muted text-sm">Desde</span>
                <el-input
                    type="date"
                    v-model="fecha_ini"
                    @keyup="cargaListado"
                    @change="cargarIngresosSinVerificar"
                    @clear="cargarIngresosSinVerificar"
                    clearable
                ></el-input>
            </div>
            <div class="col-md-3 col-sm-6">
                <span class="text-muted text-sm">Hasta</span
                ><el-input
                    type="date"
                    v-model="fecha_fin"
                    @keyup="cargaListado"
                    @change="cargarIngresosSinVerificar"
                    @clear="cargarIngresosSinVerificar"
                    clearable
                ></el-input>
            </div>
        </div>
        <div class="row">
            <div class="col-12 text-md">
                Total registros: {{ ingreso_productos.length }}
            </div>
        </div>
        <div class="row" v-if="ingreso_productos.length > 0">
            <div
                class="col-md-6 col-lg-4 mt-2"
                v-for="item in ingreso_productos"
                :key="item.id"
            >
                <div class="card">
                    <div class="card-header py-2">
                        <span class="text-sm fw-bold text-muted float-end">
                            {{ item.fecha_registro_t }}
                        </span>
                        <h4 class="text-primary fw-bold fs-6 mb-0">
                            {{ item.codigo }}
                        </h4>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-6 text-end border-end">
                                <div class="row">
                                    <div class="col-12 text-sm text-center">
                                        {{ item.proveedor.nombre }}
                                    </div>
                                    <div
                                        class="col-12 text-xs text-muted text-center"
                                    >
                                        <i
                                            class="fa fa-truck"
                                            title="Proveedor"
                                        ></i>
                                    </div>
                                </div>
                            </div>
                            <div class="col-6 text-end">
                                <div class="row">
                                    <div class="col-12 text-sm text-center">
                                        {{ item.tipo_ingreso.nombre }}
                                    </div>
                                    <div
                                        class="col-12 text-xs text-muted text-center"
                                    >
                                        <i
                                            class="fa fa-clipboard-list"
                                            title="Tipo"
                                        ></i>
                                    </div>
                                </div>
                            </div>
                            <div
                                class="col-6 text-center border-top pt-2 border-end"
                            >
                                <div class="row">
                                    <div class="col-12 text-sm text-center">
                                        {{ item.sucursal?.nombre }}
                                    </div>
                                    <div
                                        class="col-12 text-xs text-muted text-center"
                                    >
                                        <i
                                            class="fa fa-building"
                                            title="Sucursal"
                                        ></i>
                                    </div>
                                </div>
                            </div>
                            <div class="col-6 text-center border-top pt-2">
                                <div class="row">
                                    <div class="col-12 text-sm text-center">
                                        {{ item.almacen?.nombre }}
                                    </div>
                                    <div
                                        class="col-12 text-xs text-muted text-center"
                                    >
                                        <i
                                            class="fa fa-warehouse"
                                            title="Almacén"
                                        ></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row border-top mt-1">
                            <div class="col-6 pt-1 border-end">
                                <div class="row">
                                    <div class="col-12 text-md text-center">
                                        {{ item.ingreso_detalles.length }}
                                    </div>
                                    <div
                                        class="col-12 text-xs text-muted text-center"
                                    >
                                        <i class="fa fa-boxes"></i> Productos
                                    </div>
                                </div>
                            </div>
                            <div class="col-6 pt-1">
                                <div class="row">
                                    <div class="col-12 text-md text-center">
                                        {{ item.total }}
                                    </div>
                                    <div
                                        class="col-12 text-xs text-muted text-center"
                                    >
                                        Total Bs.
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="card-footer">
                        <div class="row">
                            <div class="col-12">
                                <Link
                                    class="btn btn-sm btn-primary float-end"
                                    :href="
                                        route(
                                            'ingreso_productos.verificacion_create',
                                            item.id,
                                        )
                                    "
                                >
                                    <i class="fa fa-clipboard-check"></i>
                                    Registrar Recepción
                                </Link>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row" v-else>
            <div class="col-12">
                <h4 class="text-center text-muted fs-3">
                    <i class="fa fa-info-circle"></i> No hay compras para
                    verificar/recepcionar
                </h4>
            </div>
        </div>
    </Content>
</template>
