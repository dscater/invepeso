<script setup>
import Content from "@/Components/Content.vue";
import { Head, Link, router, usePage } from "@inertiajs/vue3";
import { useIngresoProductos } from "@/composables/ingreso_productos/useIngresoProductos";
import { ref, onMounted, onBeforeMount } from "vue";
import { useAppStore } from "@/stores/aplicacion/appStore";
import FormularioVerificar from "./FormularioVerificar.vue";
const props = defineProps({
    ingreso_producto: {
        type: Object,
        required: true,
    },
});
const { props: props_page } = usePage();
const appStore = useAppStore();
onBeforeMount(() => {
    appStore.startLoading();
});

const { setIngresoProducto, limpiarIngresoProducto, form } =
    useIngresoProductos();
onMounted(() => {
    setIngresoProducto(props.ingreso_producto);

    appStore.stopLoading();
});
</script>
<template>
    <Head title="Registrar Recepción de Productos"></Head>
    <Content>
        <template #header>
            <div class="row">
                <div class="col-sm-6">
                    <h3 class="m-0">
                        <i class="fa fa-boxes"></i> Registrar Recepción de
                        Productos
                    </h3>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-end">
                        <li class="breadcrumb-item">
                            <Link :href="route('inicio')">Inicio</Link>
                        </li>
                        <li class="breadcrumb-item">
                            <Link
                                :href="
                                    route(
                                        'ingreso_productos.verificacion_ingresos',
                                    )
                                "
                                >Recepción de Compras</Link
                            >
                        </li>
                        <li class="breadcrumb-item active">
                            Registrar Recepción de Productos
                        </li>
                    </ol>
                </div>
                <!-- /.col -->
            </div>
            <!-- /.row -->
        </template>
        <div class="row">
            <div class="col-md-12">
                <FormularioVerificar
                    :form="form"
                    @envio-formulario="limpiarIngresoProducto"
                ></FormularioVerificar>
            </div>
        </div>
    </Content>
</template>
