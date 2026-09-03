<script setup>
import Content from "@/Components/Content.vue";
import { Head, Link, router, usePage } from "@inertiajs/vue3";
import { useMovimientoCajas } from "@/composables/movimiento_cajas/useMovimientoCajas";
import { ref, onMounted, onBeforeMount } from "vue";
import { useAppStore } from "@/stores/aplicacion/appStore";
import Formulario from "./Formulario.vue";
const props = defineProps({
    movimiento_caja: Object,
});
const { props: props_page } = usePage();
const appStore = useAppStore();
const { setMovimientoCaja, limpiarMovimientoCaja, form } = useMovimientoCajas();
onBeforeMount(() => {
    setMovimientoCaja(props.movimiento_caja);
    appStore.startLoading();
});

onMounted(() => {
    appStore.stopLoading();
});
</script>
<template>
    <Head title="Editar Movimiento de Caja"></Head>
    <Content>
        <template #header>
            <div class="row">
                <div class="col-sm-6">
                    <h3 class="m-0">
                        <i class="fa fa-cash-register"></i> Editar Movimiento de
                        Caja
                    </h3>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-end">
                        <li class="breadcrumb-item">
                            <Link :href="route('inicio')">Inicio</Link>
                        </li>
                        <li class="breadcrumb-item active">
                            Editar Movimiento de Caja
                        </li>
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
                    @envio-formulario="limpiarMovimientoCaja"
                ></Formulario>
            </div>
        </div>
    </Content>
</template>
