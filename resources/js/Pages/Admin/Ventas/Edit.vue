<script setup>
import Content from "@/Components/Content.vue";
import { Head, Link, router, usePage } from "@inertiajs/vue3";
import { useVentas } from "@/composables/ventas/useVentas";
import { ref, onMounted, onBeforeMount } from "vue";
import { useAppStore } from "@/stores/aplicacion/appStore";
import Formulario from "./Formulario.vue";
const props = defineProps({
    venta: {
        type: Object,
        required: true,
    },
});
const { props: props_page } = usePage();
const appStore = useAppStore();
const { setVenta, limpiarVenta, form } = useVentas();
onBeforeMount(() => {
    setVenta(props.venta);
    appStore.startLoading();
});

onMounted(() => {
    appStore.stopLoading();
});
</script>
<template>
    <Head title="Editar Venta"></Head>
    <Content>
        <template #header>
            <div class="row">
                <div class="col-sm-6">
                    <h3 class="m-0">
                        <i class="fa fa-money-check-alt"></i> Editar Venta
                    </h3>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-end">
                        <li class="breadcrumb-item">
                            <Link :href="route('inicio')">Inicio</Link>
                        </li>
                        <li class="breadcrumb-item active">Editar Venta</li>
                    </ol>
                </div>
                <!-- /.col -->
            </div>
            <!-- /.row -->
        </template>
        <div class="row">
            <div class="col-md-12">
                <Formulario
                    :form="form"
                    @envio-formulario="limpiarVenta"
                ></Formulario>
            </div>
        </div>
    </Content>
</template>
