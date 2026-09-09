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
    form: {
        type: Object,
    },
});

const muestra_form = ref(props.muestra_formulario);
const enviando = ref(false);
const form = props.form;

const tituloDialog = computed(() => {
    return form.id == 0
        ? `<i class="fa fa-plus"></i> Nuevo Cliente`
        : `<i class="fa fa-edit"></i> Editar Cliente`;
});

const textBtn = computed(() => {
    if (enviando.value) {
        return `<i class="fa fa-spin fa-spinner"></i> Enviando...`;
    }
    if (form.id == 0) {
        return `<i class="fa fa-save"></i> Guardar`;
    }
    return `<i class="fa fa-edit"></i> Actualizar`;
});

const enviarFormulario = async () => {
    enviando.value = true;

    const url =
        form.id == 0
            ? route("clientes.store")
            : route("clientes.update", form.id);

    try {
        form.tipo_envio = "ajax";
        const response = await axios.post(url, form);

        // Respuesta correcta del controlador
        if (response.data.sw) {
            Swal.fire({
                icon: "success",
                title: "Correcto",
                html: `<strong>${
                    response.data.message ?? "Proceso realizado con éxito"
                }</strong>`,
                confirmButtonText: "Aceptar",
                customClass: {
                    confirmButton: "btn-alert-success",
                },
            });
            document
                .getElementsByTagName("body")[0]
                .classList.remove("modal-open");

            emits("envio-formulario", response.data.cliente);
        }
    } catch (error) {
        console.log(error);

        /**
         * Errores de validación Laravel
         * Ejemplo:
         * {
         *   message: "...",
         *   errors: {
         *      monto: ["El campo monto es obligatorio"]
         *   }
         * }
         */
        if (error.response?.status === 422) {
            const errors = error.response.data.errors ?? {};

            const errores = Object.values(errors)
                .flat()
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
            const mensaje =
                error.response?.data?.message ??
                "Ocurrió un error inesperado, contacte con el administrador.";

            Swal.fire({
                icon: "error",
                title: "Error",
                text: mensaje,
                confirmButtonText: "Aceptar",
                customClass: {
                    confirmButton: "btn-error",
                },
            });
        }
    } finally {
        // Equivalente a onFinish de Inertia
        enviando.value = false;
    }
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

const listTipoDocumentos = ref([]);
const cargarTipoDocumentos = () => {
    axios.get(route("tipo_documentos.listado")).then((response) => {
        listTipoDocumentos.value = response.data.tipo_documentos;
    });
};

const cargarListas = () => {
    cargarTipoDocumentos();
};

onMounted(() => {
    cargarListas();
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
                <p class="text-muted text-xs mb-0">
                    Todos los campos con
                    <span class="text-danger">(*)</span> son obligatorios.
                </p>
                <div class="row">
                    <div class="col-md-4 mt-2">
                        <label class="required">Nombre de Cliente</label>
                        <el-input
                            type="text"
                            :class="{
                                'parsley-error': form.errors?.nombre,
                            }"
                            v-model="form.nombre"
                            autosize
                        ></el-input>
                        <ul
                            v-if="form.errors?.nombre"
                            class="d-block text-danger list-unstyled"
                        >
                            <li class="parsley-required">
                                {{ form.errors?.nombre }}
                            </li>
                        </ul>
                    </div>
                    <div class="col-md-4 mt-2">
                        <label class="required">Tipo Documento</label>
                        <el-select
                            v-model="form.tipo_documento_id"
                            filterable
                            no-data-text="Sin Datos"
                            no-match-text="Sin Resultados"
                            placeholder="- Seleccione-"
                        >
                            <el-option
                                v-for="item in listTipoDocumentos"
                                :key="item.id"
                                :value="item.id"
                                :label="item.nombre"
                            ></el-option>
                        </el-select>
                        <ul
                            v-if="form.errors?.tipo_documento_id"
                            class="d-block text-danger list-unstyled"
                        >
                            <li class="parsley-required">
                                {{ form.errors?.tipo_documento_id }}
                            </li>
                        </ul>
                    </div>
                    <div class="col-md-4 mt-2">
                        <label class="required">Nro. de Documento</label>
                        <el-input
                            type="text"
                            :class="{
                                'parsley-error': form.errors?.nro_documento,
                            }"
                            v-model="form.nro_documento"
                            autosize
                        ></el-input>
                        <ul
                            v-if="form.errors?.nro_documento"
                            class="d-block text-danger list-unstyled"
                        >
                            <li class="parsley-required">
                                {{ form.errors?.nro_documento }}
                            </li>
                        </ul>
                    </div>
                    <div
                        class="col-md-4 mt-2"
                        v-if="form.tipo_documento_id == 1"
                    >
                        <label class="">Complemento</label>
                        <el-input
                            type="text"
                            :class="{
                                'parsley-error': form.errors?.complemento,
                            }"
                            v-model="form.complemento"
                            autosize
                        ></el-input>
                        <ul
                            v-if="form.errors?.complemento"
                            class="d-block text-danger list-unstyled"
                        >
                            <li class="parsley-required">
                                {{ form.errors?.complemento }}
                            </li>
                        </ul>
                    </div>
                    <div class="col-md-4 mt-2">
                        <label class="">Contacto</label>
                        <br /><small class="text-muted text-xs"
                            >Ej: Teléfono, celular</small
                        >
                        <el-input
                            type="text"
                            :class="{
                                'parsley-error': form.errors?.contacto,
                            }"
                            v-model="form.contacto"
                            autosize
                        ></el-input>
                        <ul
                            v-if="form.errors?.contacto"
                            class="d-block text-danger list-unstyled"
                        >
                            <li class="parsley-required">
                                {{ form.errors?.contacto }}
                            </li>
                        </ul>
                    </div>
                    <div class="col-md-4 mt-2">
                        <label class="">Correo</label>
                        <el-input
                            type="text"
                            :class="{
                                'parsley-error': form.errors?.correo,
                            }"
                            v-model="form.correo"
                            autosize
                        ></el-input>
                        <ul
                            v-if="form.errors?.correo"
                            class="d-block text-danger list-unstyled"
                        >
                            <li class="parsley-required">
                                {{ form.errors?.correo }}
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
