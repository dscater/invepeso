<script setup>
import MiModal from "@/Components/MiModal.vue";
import { useForm, usePage } from "@inertiajs/vue3";
import { watch, ref, computed, onMounted, nextTick } from "vue";
// TOAST
import { toast } from "vue3-toastify";
import "vue3-toastify/dist/index.css";
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
    return `<i class="fa fa-list"></i> Verificación de Productos`;
});

const textBtn = computed(() => {
    if (enviando.value) {
        return `<i class="fa fa-spin fa-spinner"></i> Enviando...`;
    }
    return `<i class="fa fa-edit"></i> Registrar verificación`;
});

const enviarFormulario = () => {
    enviando.value = true;
    let url = route("ingreso_productos.verificar", form.id);

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

const inputCheckRecibidos = ref(false);

const recepcionTodos = () => {
    if (inputCheckRecibidos.value === true) {
        form.ingreso_detalles.map((item) => (item.verificado = item.cantidad));
    } else {
        form.ingreso_detalles.map((item) => (item.verificado = 0));
    }
    calculaFaltantes();
};

const calculaFaltantes = () => {
    form.ingreso_detalles.forEach((item) => {
        if (item.verificado && parseFloat(item.verificado) > 0) {
            item.faltantes = item.cantidad - item.verificado;
        } else {
            item.faltantes = null;
        }
    });
};

const calculaFaltantesIndex = (index) => {
    const verificado = form.ingreso_detalles[index].verificado;
    const cantidad = form.ingreso_detalles[index].cantidad;

    let faltantes = null;
    if (verificado && parseFloat(verificado) > 0) {
        faltantes = cantidad - verificado;
    }

    form.ingreso_detalles[index].faltantes = faltantes;
};

const booleanInputs = computed(() => {
    return (
        form.ingreso_detalles.filter(
            (elem) => !elem.verificado || elem.verificado < 1,
        ).length > 0
    );
});

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
            <form @submit.prevent="enviarFormulario()">
                <div class="row">
                    <div class="col-12">
                        <span class="float-end text-sm">{{
                            form.fecha_registro_t
                        }}</span>
                    </div>
                    <div class="col-12">
                        <span class="float-end text-sm">{{
                            form.proveedor.nombre
                        }}</span>
                        <h4 class="text-primary fw-bold fs-5">
                            {{ form.codigo }}
                        </h4>
                    </div>
                    <div class="col-12">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th class="bg-principal text-white">N°</th>
                                    <th class="bg-principal text-white">
                                        Producto
                                    </th>
                                    <th class="bg-principal text-white">
                                        Cantidad
                                    </th>
                                    <th class="bg-principal text-white">
                                        Recibido
                                        <input
                                            type="checkbox"
                                            v-model="inputCheckRecibidos"
                                            style="height: 15px; width: 15px"
                                            @change="recepcionTodos"
                                        />
                                    </th>
                                    <th class="bg-principal text-white">
                                        Faltantes
                                    </th>
                                    <th class="bg-principal text-white">
                                        Observación
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr
                                    v-for="(
                                        item, index
                                    ) in form.ingreso_detalles"
                                    :key="item.id"
                                >
                                    <td>{{ index + 1 }}</td>
                                    <td>{{ item.producto.nombre }}</td>
                                    <td class="text-center">
                                        {{ item.cantidad }}
                                    </td>
                                    <td>
                                        <input
                                            type="number"
                                            step="1"
                                            class="form-control"
                                            v-model="item.verificado"
                                            @keyup="
                                                calculaFaltantesIndex(index)
                                            "
                                        />
                                    </td>
                                    <td class="text-center">
                                        {{ item.faltantes }}
                                    </td>
                                    <td>
                                        <el-input
                                            type="textarea"
                                            v-model="item.observacion"
                                            autosize
                                        ></el-input>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
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
                :disabled="enviando || booleanInputs"
                @click.prevent="enviarFormulario"
                v-html="textBtn"
            ></button>
        </template>
    </MiModal>
</template>
