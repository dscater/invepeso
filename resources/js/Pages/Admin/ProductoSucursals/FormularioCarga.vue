<script setup>
import MiModal from "@/Components/MiModal.vue";
import { useForm, usePage } from "@inertiajs/vue3";
import { watch, ref, computed, onMounted, nextTick } from "vue";
const props = defineProps({
    muestra_formulario: {
        type: Boolean,
        default: false,
    },
    almacens: {
        type: Array,
        default: [],
        required: true,
    },
});

const muestra_form = ref(props.muestra_formulario);
const enviando = ref(false);
const listAlmacens = ref(props.almacens.filter((el) => el.id != "todos"));

const form = useForm({
    archivo: null,
    almacen_id: "",
    _method: "POST",
});
const archivo = ref(null);
function cargaArchivo(e, key) {
    form[key] = null;
    form[key] = e.target.files[0];
}

const tituloDialog = computed(() => {
    return `<i class="fa fa-upload"></i> Carga Masiva de Stock de Productos`;
});

const textBtn = computed(() => {
    if (enviando.value) {
        return `<i class="fa fa-spin fa-spinner"></i> Enviando...`;
    }
    return `<i class="fa fa-upload"></i> Enviar Archivo`;
});

const enviarFormulario = () => {
    enviando.value = true;
    let url = route("producto_sucursals.cargaProductoSucursals");
    form.post(url, {
        preserveScroll: true,
        forceFormData: true,
        onSuccess: (response) => {
            console.log("correcto");
            const success =
                response.props.flash.success ?? "Proceso realizado con éxito";
            Swal.fire({
                icon: "success",
                title: "Correcto",
                html: `<strong>${success}</strong>`,
                confirmButtonText: `Aceptar`,
                customClass: {
                    confirmButton: "btn-alert-success",
                },
            });

            document
                .getElementsByTagName("body")[0]
                .classList.remove("modal-open");
            emits("envio-formulario");
        },
        onError: (err, code) => {
            console.log(code ?? "");
            if (Object.keys(form.errors).length > 0) {
                const errores = Object.values(form.errors)
                    .map((error) => `<li>${error}</li>`)
                    .join("");

                Swal.fire({
                    icon: "error",
                    title: "Errores de validación",
                    html: `
                <p>Existen errores en el formulario:</p>
                <ul style="text-align:left;">
                    ${errores}
                </ul>
            `,
                    confirmButtonText: "Aceptar",
                    customClass: {
                        confirmButton: "btn-error",
                    },
                });
            } else {
                Swal.fire({
                    icon: "error",
                    title: "Error",
                    text: "Ocurrió un error inesperado, contacte con el administrador.",
                    confirmButtonText: "Aceptar",
                    customClass: {
                        confirmButton: "btn-error",
                    },
                });
            }
        },
        onFinish: () => {
            enviando.value = false;
        },
    });
};

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

onMounted(() => {
    archivo.value.value = null;
});
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
            <form @submit.prevent="enviarFormulario()">
                <div class="row">
                    <div class="col-12">
                        <p class="text-muted text-xs mb-0 text-center">
                            Todos los campos con
                            <span class="text-danger">(*)</span> son
                            obligatorios.
                        </p>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12">
                        <div class="alert alert-success text-center">
                            <a
                                :href="route('producto_sucursals.formato')"
                                target="_blank"
                                ><i class="fa fa-download"></i> Descargar el
                                formato .xlsx</a
                            >
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12">
                        <div class="alert alert-warning pb-0">
                            <ul class="pb-0">
                                <li>
                                    El <b>STOCK*</b> ingresado incrementará el
                                    stock actual de cada producto en el almacén
                                    que seleccione.
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-6">
                        <label>Seleccionar Almacén</label>
                        <el-select
                            v-model="form.almacen_id"
                            placeholder="Almacén"
                            no-data-text="Sin Datos"
                            no-match-text="Sin Resultados"
                            filterable
                        >
                            <el-option
                                v-for="item in listAlmacens"
                                :key="item.id"
                                :value="item.id"
                                :label="`${item.nombre} ${item.sucursal ? ' - ' + item.sucursal.nombre : ''}`"
                            ></el-option>
                        </el-select>
                    </div>
                    <div class="col-6">
                        <input
                            type="file"
                            ref="archivo"
                            @change="cargaArchivo($event, 'archivo')"
                        />
                        <ul
                            v-if="form.errors?.archivo"
                            class="d-block text-danger list-unstyled"
                        >
                            <li class="parsley-required">
                                {{ form.errors?.archivo }}
                            </li>
                        </ul>
                    </div>
                </div>
            </form>
        </template>
        <template #footer>
            <button
                type="button"
                class="btn btn-default"
                @click.prevent="cerrarFormulario()"
            >
                Cerrar
            </button>
            <button
                type="button"
                class="btn btn-primary"
                :disabled="enviando"
                @click.prevent="enviarFormulario"
                v-html="textBtn"
            ></button>
        </template>
    </MiModal>
</template>
