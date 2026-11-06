<script setup>
import { onBeforeMount, onBeforeUnmount, onMounted } from "vue";
import { useAppStore } from "@/stores/aplicacion/appStore";
import { useConfiguracionStore } from "@/stores/configuracion/configuracionStore";
const configuracionStore = useConfiguracionStore();
const appStore = useAppStore();

onMounted(() => {
    document.getElementsByTagName("body")[0].classList.add("login");
    appStore.stopLoading();
});

onBeforeMount(async () => {
    appStore.setLoading(true);
    configuracionStore.initConfiguracion();
});

onBeforeUnmount(() => {
    document.getElementsByTagName("body")[0].classList.remove("login");
});
</script>
<template>
    <div class="loading" :class="[appStore.getLoading == true ? 'show' : '']">
        <!-- <div class="loading show"> -->
        <template v-if="$slots.loading">
            <slot name="loading"></slot>
        </template>
        <template v-else>
            <i class="fa fa-spin fa-spinner fa-4x text1"></i>
            <br />
            <span class="font-weight-bold text1 h4">
                {{ configuracionStore.oConfiguracion.nombre_sistema }}
            </span>
        </template>
    </div>
    <div class="container-fluid content-principal-login">
        <div class="capa"></div>
        <div
            class="content-login container w-100 h-100 d-flex items-center align-items-center justify-content-center"
        >
            <slot />
        </div>
    </div>
</template>
<style scoped>
.content-principal-login {
    position: relative;
    /* background-image: url("/imgs/fondo.jpg"); */
    /* background-size: cover; */
    /* background-repeat: none; */
}

.capa {
    /* background-color: rgba(0, 0, 0, 0.507);
    position: absolute;
    top: 0;
    left: 0;
    z-index: 1;
    height: 100%;
    width: 100%; */
}

.content-login {
    position: relative;
    z-index: 2;
    min-height: 100vh;
}
</style>
