<script setup>
import Content from "@/Components/Content.vue";
import { Head, Link, router, usePage } from "@inertiajs/vue3";
import { useIngresoProductos } from "@/composables/ingreso_productos/useIngresoProductos";
import { useAxios } from "@/composables/axios/useAxios";
import { ref, onMounted, onBeforeMount } from "vue";
import { useAppStore } from "@/stores/aplicacion/appStore";
// import { useMenu } from "@/composables/useMenu";
import Verificar from "./Verificar.vue";
import { buttonProps } from "element-plus";
import { useDate } from "@/composables/useDate.js";
import axios from "axios";
// const { mobile, identificaDispositivo } = useMenu();

const { getFechaActual } = useDate();
const { props: props_page } = usePage();

const appStore = useAppStore();

const { setIngresoProducto, limpiarIngresoProducto, form } =
    useIngresoProductos();

const listAlmacens = ref([]);
const almacen_id = ref("todos");
const fecha_ini = ref(getFechaActual());
const fecha_fin = ref(getFechaActual());
const ingreso_productos = ref([]);

const cargarAlmacens = async () => {
    try {
        const res = await axios.get(route("almacens.listado"));
        listAlmacens.value = res.data.almacens;
        listAlmacens.value.unshift({
            id: "todos",
            nombre: "Todos los almacenes",
        });
    } catch (e) {
        console.log(e);
    } finally {
    }
};

const cargarIngresosSinVerificar = () => {
    axios
        .get(route("ingreso_productos.lista_sin_verificar"), {
            params: {
                fecha_ini: fecha_ini.value,
                fecha_fin: fecha_fin.value,
                almacen_id: almacen_id.value,
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
    cargarAlmacens();
    cargarIngresosSinVerificar();
    appStore.startLoading();
});

onMounted(() => {
    appStore.stopLoading();
});

const verificar = (item) => {
    setIngresoProducto(item);
    muestra_formulario.value = true;
};

const updateIngresos = () => {
    muestra_formulario.value = false;
    limpiarIngresoProducto();
    cargarIngresosSinVerificar();
};

const muestra_formulario = ref(false);
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
            <div class="col-md-4 col-sm-12">
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
                    <el-option
                        v-for="item in listAlmacens"
                        :key="item.id"
                        :value="item.id"
                        :label="`${item.nombre} ${item.sucursal ? ' - ' + item.sucursal.nombre : ''}`"
                    ></el-option>
                </el-select>
            </div>
            <div class="col-md-4 col-sm-6">
                <span class="text-muted text-sm">Desde</span>
                <input
                    type="date"
                    v-model="fecha_ini"
                    class="form-control"
                    @keyup="cargaListado"
                    @change="cargarIngresosSinVerificar"
                />
            </div>
            <div class="col-md-4 col-sm-6">
                <span class="text-muted text-sm">Hasta</span>
                <input
                    type="date"
                    v-model="fecha_fin"
                    class="form-control"
                    @keyup="cargaListado"
                    @change="cargarIngresosSinVerificar"
                />
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
                                <button
                                    class="btn btn-sm btn-primary float-end"
                                    @click="verificar(item)"
                                >
                                    <i class="fa fa-external-link-alt"></i>
                                    Verificar
                                </button>
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
        <Verificar
            v-if="muestra_formulario"
            :muestra_formulario="muestra_formulario"
            :form="form"
            @envio-formulario="updateIngresos"
            @cerrar-formulario="muestra_formulario = false"
        ></Verificar>
    </Content>
</template>
