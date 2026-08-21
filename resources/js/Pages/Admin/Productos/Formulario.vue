<script setup>
import MiModal from "@/Components/MiModal.vue";
import { useForm, usePage } from "@inertiajs/vue3";
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
const imagen = ref(null);
function cargaArchivo(e, key) {
    form[key] = null;
    form[key] = e.target.files[0];
}

const tituloDialog = computed(() => {
    return form.id == 0
        ? `<i class="fa fa-plus"></i> Nuevo Producto`
        : `<i class="fa fa-edit"></i> Editar Producto`;
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
            ? route("productos.store")
            : route("productos.update", form.id);

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

const listCategorias = ref([]);
const listMarcas = ref([]);
const listUnidadMedidas = ref([]);
const cargarCategorias = () => {
    axios.get(route("categorias.listado")).then((response) => {
        listCategorias.value = response.data.categorias;
    });
};
const cargarMarcas = () => {
    axios.get(route("marcas.listado")).then((response) => {
        listMarcas.value = response.data.marcas;
    });
};
const cargarUnidadMedidas = () => {
    axios.get(route("unidad_medidas.listado")).then((response) => {
        listUnidadMedidas.value = response.data.unidad_medidas;
    });
};
const cargarListas = () => {
    cargarCategorias();
    cargarMarcas();
    cargarUnidadMedidas();
};

onMounted(() => {
    cargarListas();
    imagen.value.value = null;
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
                        <label class="required">Código de Producto</label>
                        <el-input
                            type="text"
                            :class="{
                                'parsley-error': form.errors?.codigo,
                            }"
                            v-model="form.codigo"
                            autosize
                        ></el-input>
                        <ul
                            v-if="form.errors?.codigo"
                            class="d-block text-danger list-unstyled"
                        >
                            <li class="parsley-required">
                                {{ form.errors?.codigo }}
                            </li>
                        </ul>
                    </div>
                    <div class="col-md-4 mt-2">
                        <label class="required">Nombre de Producto</label>
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
                        <label class="required">Categoría</label>
                        <el-select
                            v-model="form.categoria_id"
                            filterable
                            no-data-text="Sin datos"
                            no-match-text="Sin datos"
                            placeholder="- Seleccione -"
                        >
                            <el-option
                                v-for="item in listCategorias"
                                :key="item.id"
                                :value="item.id"
                                :label="item.nombre"
                            ></el-option>
                        </el-select>
                        <ul
                            v-if="form.errors?.categoria_id"
                            class="d-block text-danger list-unstyled"
                        >
                            <li class="parsley-required">
                                {{ form.errors?.categoria_id }}
                            </li>
                        </ul>
                    </div>
                    <div class="col-md-4 mt-2">
                        <label class="required">Marca</label>
                        <el-select
                            v-model="form.marca_id"
                            filterable
                            no-data-text="Sin datos"
                            no-match-text="Sin datos"
                            placeholder="- Seleccione -"
                        >
                            <el-option
                                v-for="item in listMarcas"
                                :key="item.id"
                                :value="item.id"
                                :label="item.nombre"
                            ></el-option>
                        </el-select>
                        <ul
                            v-if="form.errors?.marca_id"
                            class="d-block text-danger list-unstyled"
                        >
                            <li class="parsley-required">
                                {{ form.errors?.marca_id }}
                            </li>
                        </ul>
                    </div>
                    <div class="col-md-4 mt-2">
                        <label class="required">Unidad de Medida</label>
                        <el-select
                            v-model="form.unidad_medida_id"
                            filterable
                            no-data-text="Sin datos"
                            no-match-text="Sin datos"
                            placeholder="- Seleccione -"
                        >
                            <el-option
                                v-for="item in listUnidadMedidas"
                                :key="item.id"
                                :value="item.id"
                                :label="item.nombre"
                            ></el-option>
                        </el-select>
                        <ul
                            v-if="form.errors?.unidad_medida_id"
                            class="d-block text-danger list-unstyled"
                        >
                            <li class="parsley-required">
                                {{ form.errors?.unidad_medida_id }}
                            </li>
                        </ul>
                    </div>
                    <div class="col-md-4 mt-2">
                        <label class="required">Precio de Venta Bs.</label>
                        <input
                            type="number"
                            min="0"
                            class="form-control"
                            v-model="form.precio"
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
                    <div class="col-md-4 mt-2">
                        <label class="required">Precio de Compra Bs.</label>
                        <input
                            type="number"
                            min="0"
                            class="form-control"
                            v-model="form.precio_compra"
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
                    <div class="col-md-4 mt-2">
                        <label class="required">Stock Mínimo</label>
                        <input
                            type="number"
                            min="0"
                            class="form-control"
                            v-model="form.stock_min"
                        />
                        <ul
                            v-if="form.errors?.stock_min"
                            class="d-block text-danger list-unstyled"
                        >
                            <li class="parsley-required">
                                {{ form.errors?.stock_min }}
                            </li>
                        </ul>
                    </div>

                    <div class="col-md-4 mt-2">
                        <label class="">Imagen</label>
                        <input
                            type="file"
                            class="form-control"
                            :class="{
                                'parsley-error': form.errors?.imagen,
                            }"
                            @change="cargaArchivo($event, 'imagen')"
                            ref="imagen"
                        />
                        <ul
                            v-if="form.errors?.imagen"
                            class="list-unstyled text-danger"
                        >
                            <li class="parsley-required">
                                {{ form.errors?.imagen }}
                            </li>
                        </ul>
                    </div>
                    <div class="col-md-4 mt-2">
                        <label class="required">Estado</label>
                        <br />
                        <small class="text-muted text-xs"
                            >(Si está activo, se podrá realizar ventas y
                            movimientos en estaproducto)</small
                        >
                        <br />
                        <el-switch
                            size="large"
                            active-text="ACTIVO"
                            inactive-text="INACTIVO"
                            v-model="form.activo"
                            :active-value="1"
                            :inactive-value="0"
                            style="
                                --el-switch-on-color: #13ce66;
                                --el-switch-off-color: #ff4949;
                            "
                        />
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
