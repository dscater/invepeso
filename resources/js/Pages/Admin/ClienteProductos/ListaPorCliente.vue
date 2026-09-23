:label="`${item.codigo} - ${item.nombre}`"
<script setup>
import MiModal from "@/Components/MiModal.vue";
import { useForm, usePage } from "@inertiajs/vue3";
import axios from "axios";
import { watch, ref, computed, onMounted, nextTick } from "vue";
const props = defineProps({
    muestra_formulario: {
        type: Boolean,
        default: false,
    },
    cliente_productos: {
        type: Array,
        required: true,
    },
});

const muestra_form = ref(props.muestra_formulario);

const tituloDialog = computed(() => {
    return `<i class="fa fa-boxes"></i> Productos asignados Cliente`;
});

const emits = defineEmits(["cerrar-formulario", "envio-formulario"]);

watch(muestra_form, (newVal) => {
    if (!newVal) {
        emits("cerrar-formulario");
    }
});

const cerrarFormulario = () => {
    muestra_form.value = false;
    document.getElementsByTagName("body")[0].classList.remove("modal-open");
};

const listClienteProductos = ref(props.cliente_productos);

onMounted(() => {});
</script>

<template>
    <MiModal
        :open_modal="muestra_form"
        @close="cerrarFormulario"
        :size="'modal-xl'"
        :header-class="'bg-principal'"
        :footer-class="'justify-content-end'"
    >
        <template #header>
            <h4 class="modal-title text-white" v-html="tituloDialog"></h4>
            <button
                type="button"
                class="btn-close btn-close-white"
                @click.prevent="cerrarFormulario()"
            ></button>
        </template>

        <template #body>
            <div class="row">
                <div
                    class="col-md-3 col-lg-2 col-sm-4 col-xs-6"
                    v-for="item in listClienteProductos"
                >
                    <div class="card mt-2">
                        <div class="card-header p-0">
                            <div class="imagen_producto">
                                <img :src="item.producto.url_imagen" alt="" />
                            </div>
                        </div>
                        <div class="card-body py-2">
                            <div class="row">
                                <div class="col-12 pb-1">
                                    <span class="fw-bold h6">
                                        {{ item.producto.nombre }}
                                    </span>
                                    <span class="text-muted text-xs d-block">{{
                                        item.producto.codigo
                                    }}</span>
                                </div>
                                <div class="col-12 border-top">
                                    <div class="row">
                                        <div class="col-12 py-1">
                                            <div class="fs-7 text-muted">
                                                <span class="">
                                                    Bs. {{ item.precio }}
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </template>
        <template #footer>
            <button
                type="button"
                class="btn btn-default"
                @click.prevent="cerrarFormulario()"
            >
                Cerrar
            </button>
        </template>
    </MiModal>
</template>
<style scoped>
.imagen_producto img {
    max-height: 170px !important;
    object-fit: contain;
}
</style>
