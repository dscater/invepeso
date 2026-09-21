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
const productoSeleccionado = ref(null);

const tituloDialog = computed(() => {
    return form.id == 0
        ? `<i class="fa fa-plus"></i> Nuevo Precio de Producto Cliente`
        : `<i class="fa fa-edit"></i> Editar Precio de Producto Cliente`;
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

const enviarFormulario = () => {
    enviando.value = true;
    let url =
        form.id == 0
            ? route("cliente_productos.store")
            : route("cliente_productos.update", form.id);

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
            console.log(form.errors);
            if (form.errors) {
                const error =
                    "Existen errores en el formulario, por favor verifique";
                Swal.fire({
                    icon: "info",
                    title: "Error",
                    html: `<strong>${error}</strong>`,
                    confirmButtonText: `Aceptar`,
                    customClass: {
                        confirmButton: "btn-error",
                    },
                });
            } else {
                const error =
                    "Ocurrió un error inesperado contactese con el Administrador";
                Swal.fire({
                    icon: "info",
                    title: "Error",
                    html: `<strong>${error}</strong>`,
                    confirmButtonText: `Aceptar`,
                    customClass: {
                        confirmButton: "btn-error",
                    },
                });
            }
            console.log("error: " + err.error);
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

const listProductos = ref([]);
const cargarProductos = () => {
    axios
        .get(route("productos.listado"), {
            params: {
                activo: 1,
            },
        })
        .then((response) => {
            listProductos.value = response.data.productos;
            if (form.id != 0) {
                detectarProducto();
            }
        });
};

const cargarListas = () => {
    cargarProductos();
};

const detectarProducto = () => {
    productoSeleccionado.value = null;
    if (form.producto_id) {
        productoSeleccionado.value = listProductos.value.filter(
            (item) => item.id === form.producto_id,
        )[0];
    }
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
                    <div class="col-md-6 mt-2">
                        <label class="required">Seleccionar Producto</label>
                        <el-select
                            v-model="form.producto_id"
                            filterable
                            no-data-text="Sin Datos"
                            no-match-text="Sin Resultados"
                            placeholder="- Seleccione -"
                            @change="detectarProducto"
                        >
                            <el-option
                                v-for="item in listProductos"
                                :key="item.id"
                                :value="item.id"
                                :label="`${item.codigo} - ${item.nombre}`"
                            ></el-option>
                        </el-select>
                        <ul
                            v-if="form.errors?.cliente_id"
                            class="d-block text-danger list-unstyled"
                        >
                            <li class="parsley-required">
                                {{ form.errors?.cliente_id }}
                            </li>
                        </ul>
                        <ul
                            v-if="form.errors?.producto_id"
                            class="d-block text-danger list-unstyled"
                        >
                            <li class="parsley-required">
                                {{ form.errors?.producto_id }}
                            </li>
                        </ul>
                    </div>
                    <div class="col-md-6 mt-2">
                        <label class="required"
                            >Indique el Precio del Producto</label
                        >
                        <input
                            type="number"
                            class="form-control"
                            :class="{
                                'parsley-error': form.errors?.precio,
                            }"
                            v-model="form.precio"
                            autosize
                        />
                        <ul
                            v-if="form.errors?.precio"
                            class="d-block text-danger list-unstyled"
                        >
                            <li class="parsley-required">
                                {{ form.errors?.precio }}
                            </li>
                        </ul>
                    </div>
                    <div class="col-12">
                        <div
                            class="sin_seleccionar text-center mt-2"
                            v-if="!productoSeleccionado"
                        >
                            <i class="fa fa-box-open fa-2x"></i>
                            <div class="text-muted">Selecciona un producto</div>
                        </div>
                        <div class="row mt-2" v-if="productoSeleccionado">
                            <div class="col-12">
                                <div class="card">
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-12">
                                                <h4 class="text-primary fs-6">
                                                    <i class="fa fa-box"></i>
                                                    {{
                                                        productoSeleccionado.codigo
                                                    }}
                                                    -
                                                    {{
                                                        productoSeleccionado.nombre
                                                    }}
                                                </h4>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-3">
                                                <div class="text-center">
                                                    {{
                                                        productoSeleccionado.precio ??
                                                        "-"
                                                    }}
                                                </div>
                                                <div
                                                    class="text-center text-muted fs-8"
                                                >
                                                    Precio 1
                                                </div>
                                            </div>
                                            <div class="col-3">
                                                <div class="text-center">
                                                    {{
                                                        productoSeleccionado.precio2 ??
                                                        "-"
                                                    }}
                                                </div>
                                                <div
                                                    class="text-center text-muted fs-8"
                                                >
                                                    Precio 2
                                                </div>
                                            </div>
                                            <div class="col-3">
                                                <div class="text-center">
                                                    {{
                                                        productoSeleccionado.precio3 ??
                                                        "-"
                                                    }}
                                                </div>
                                                <div
                                                    class="text-center text-muted fs-8"
                                                >
                                                    Precio 3
                                                </div>
                                            </div>
                                            <div class="col-3">
                                                <div class="text-center">
                                                    {{
                                                        productoSeleccionado.precio4 ??
                                                        "-"
                                                    }}
                                                </div>
                                                <div
                                                    class="text-center text-muted fs-8"
                                                >
                                                    Precio 4
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
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
<style scoped>
.sin_seleccionar {
    min-height: 100px;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    background-color: var(--bgGrayLight);
}
</style>
