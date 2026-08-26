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
import axios from "axios";
// const { mobile, identificaDispositivo } = useMenu();

const { props: props_page } = usePage();

const appStore = useAppStore();

const { setIngresoProducto, limpiarIngresoProducto, form } =
    useIngresoProductos();

const ingreso_productos = ref([]);

const cargarIngresosSinVerificar = () => {
    axios
        .get(route("ingreso_productos.lista_sin_verificar"))
        .then((response) => {
            ingreso_productos.value = response.data;
        });
};

onBeforeMount(() => {
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
    cargarIngresosSinVerificar();
};

const muestra_formulario = ref(false);
</script>
<template>
    <Head title="Verificar Compras"></Head>
    <Content>
        <template #header>
            <div class="row">
                <div class="col-sm-6">
                    <h3 class="m-0">
                        <i class="fa fa-boxes"></i> Verificar Compras
                    </h3>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-end">
                        <li class="breadcrumb-item">
                            <Link :href="route('inicio')">Inicio</Link>
                        </li>
                        <li class="breadcrumb-item active">
                            Verificar Compras
                        </li>
                    </ol>
                </div>
                <!-- /.col -->
            </div>
            <!-- /.row -->
        </template>
        <div class="row" v-if="ingreso_productos.length > 0">
            <div
                class="col-md-6 col-lg-4"
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
                            <div class="col-4 text-end">
                                <div class="row">
                                    <div class="col-12 text-sm text-center">
                                        {{ item.proveedor.nombre }}
                                    </div>
                                    <div
                                        class="col-12 text-xs text-muted text-center"
                                    >
                                        Proveedor
                                    </div>
                                </div>
                            </div>
                            <div class="col-4 text-end">
                                <div class="row">
                                    <div class="col-12 text-sm text-center">
                                        {{ item.tipo_ingreso.nombre }}
                                    </div>
                                    <div
                                        class="col-12 text-xs text-muted text-center"
                                    >
                                        Tipo Ingreso
                                    </div>
                                </div>
                            </div>
                            <div class="col-4 text-end">
                                <div class="row">
                                    <div class="col-12 text-sm text-center">
                                        {{ item.sucursal.nombre }}
                                    </div>
                                    <div
                                        class="col-12 text-xs text-muted text-center"
                                    >
                                        Sucursal
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
                    verificar
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
