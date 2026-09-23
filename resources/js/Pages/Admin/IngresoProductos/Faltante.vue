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
    return `<i class="fa fa-list"></i> Recepción de Productos Faltantes`;
});

const textBtn = computed(() => {
    if (enviando.value) {
        return `<i class="fa fa-spin fa-spinner"></i> Enviando...`;
    }
    return `<i class="fa fa-edit"></i> Registrar faltantes`;
});

const enviarFormulario = () => {
    enviando.value = true;
    let url = route("ingreso_productos.faltante", form.id);

    form.post(url, {
        preserveScroll: true,
        forceFormData: true,
        onSuccess: (response) => {
            console.log("correcto");
            const success =
                response.props.flash.success ?? "Proceso realizado con éxito";
            const url_blank = response.props.url_blank ?? null;
            Swal.fire({
                icon: "success",
                title: "Correcto",
                html: `<strong>${success}</strong>`,
                confirmButtonText: `Aceptar`,
                customClass: {
                    confirmButton: "btn-alert-success",
                },
            });

            if (url_blank) {
                window.open(url_blank, "_blank");
            }
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

const inputCheckRecibidos = ref(false);

const recepcionTodos = () => {
    if (inputCheckRecibidos.value === true) {
        form.ingreso_detalles.map((item) => (item.repuesto = item.faltantes));
    } else {
        form.ingreso_detalles.map((item) => (item.repuesto = 0));
    }
};

const calculaFaltantesIndex = (e, index) => {
    const check = e.target.checked;
    form.ingreso_detalles[index].repuesto = 0;
    if (check) {
        form.ingreso_detalles[index].repuesto =
            form.ingreso_detalles[index].faltantes;
    }
};

const booleanInputs = computed(() => {
    return (
        form.ingreso_detalles.filter(
            (elem) => !elem.verificado || elem.verificado < 1,
        ).length > 0
    );
});

const openInputRepuesto = (item) => {
    item.muestra_input = true;
    item.repuesto_actual =
        parseFloat(item.cantidad) - parseFloat(item.cantidad_fisica);
    item.faltantes =
        parseFloat(item.cantidad) -
        parseFloat(item.cantidad_fisica) -
        item.repuesto_actual;

    item.repuesto =
        parseFloat(item.repuesto_aux) + parseFloat(item.repuesto_actual);
};

const cambioFaltante = (item) => {
    if (item.repuesto_actual > item.faltantes_aux || item.repuesto_actual < 1) {
        toast.error(
            "El total repuesto no puede ser menor a 1 o mayor al faltante actual de " +
                item.faltantes_aux,
        );

        item.repuesto_actual =
            parseFloat(item.cantidad) - parseFloat(item.cantidad_fisica);
        item.faltantes =
            parseFloat(item.cantidad) -
            parseFloat(item.cantidad_fisica) -
            item.repuesto_actual;
        item.repuesto =
            parseFloat(item.repuesto_aux) + parseFloat(item.repuesto_actual);
        return;
    }

    item.faltantes =
        parseFloat(item.cantidad) -
        parseFloat(item.cantidad_fisica) -
        item.repuesto_actual;

    item.repuesto =
        parseFloat(item.repuesto_aux) + parseFloat(item.repuesto_actual);
};

const cancelarInputRepuesto = (item) => {
    item.muestra_input = false;
    item.repuesto_actual = 0;
    item.repuesto = item.repuesto_aux;
    item.faltantes = item.faltantes_aux;
};

onMounted(() => {
    form.ingreso_detalles = form.ingreso_detalles.map((item) => ({
        ...item,
        muestra_input: false,
        faltantes_aux: item.faltantes,
        repuesto_aux: item.repuesto,
        repuesto_actual: 0,
    }));
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
                        <span class="float-end text-sm"
                            ><i class="fa fa-calendar-alt"></i>
                            {{ form.fecha_registro_t }}</span
                        >
                        <h4 class="text-primary fw-bold fs-5">
                            <i class="fa fa-barcode"></i>
                            {{ form.codigo }}
                        </h4>
                    </div>
                    <div class="col-12">
                        <span class="float-end text-sm"
                            ><i class="fa fa-truck"></i>
                            {{ form.proveedor.nombre }}</span
                        >
                        <span class="float-start text-sm"
                            ><i class="fa fa-warehouse"></i>
                            {{ form.almacen.nombre }} -
                            {{ form.sucursal.nombre }}</span
                        >
                    </div>
                    <div class="col-12"></div>
                    <div class="col-12">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th class="bg-principal text-white">N°</th>
                                    <th class="bg-principal text-white">
                                        Producto
                                    </th>
                                    <th
                                        class="bg-principal text-white text-center"
                                    >
                                        Cantidad
                                    </th>
                                    <th
                                        class="bg-principal text-white text-center"
                                    >
                                        Recibido
                                    </th>
                                    <th
                                        class="bg-principal text-white text-center"
                                    >
                                        Faltantes
                                    </th>
                                    <th
                                        class="bg-principal text-white text-center"
                                    >
                                        Repuesto
                                        <!-- <input
                                            type="checkbox"
                                            v-model="inputCheckRecibidos"
                                            style="height: 15px; width: 15px"
                                            @change="recepcionTodos"
                                        /> -->
                                    </th>
                                    <th class="bg-principal text-white">
                                        Observación
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <template
                                    v-for="(
                                        item, index
                                    ) in form.ingreso_detalles"
                                    :key="item.id"
                                >
                                    <template v-if="!item.muestra_input">
                                        <tr>
                                            <td>{{ index + 1 }}</td>
                                            <td>{{ item.producto.nombre }}</td>
                                            <td class="text-center">
                                                {{ item.cantidad }}
                                            </td>
                                            <td class="text-center">
                                                {{ item.verificado }}
                                            </td>
                                            <td class="text-center">
                                                <span class="d-block">
                                                    {{ item.faltantes }}
                                                </span>
                                                <span
                                                    class="text-xs text-muted text-center badge bg-warning"
                                                    v-if="item.muestra_input"
                                                    >{{
                                                        item.faltantes_aux
                                                    }}</span
                                                >
                                            </td>
                                            <td class="text-center">
                                                <div
                                                    class="input-group"
                                                    v-if="item.muestra_input"
                                                    style="min-width: 100px"
                                                >
                                                    <input
                                                        type="number"
                                                        class="form-control text-center"
                                                        v-model="
                                                            item.repuesto_actual
                                                        "
                                                        @change="
                                                            cambioFaltante(item)
                                                        "
                                                        @keyup="
                                                            cambioFaltante(item)
                                                        "
                                                    />
                                                    <button
                                                        @click.prevent="
                                                            cancelarInputRepuesto(
                                                                item,
                                                            )
                                                        "
                                                        title="Cancelar"
                                                        class="btn btn-default bg-white border p-1 px-2 text-xs"
                                                    >
                                                        <i
                                                            class="fa fa-sync"
                                                        ></i>
                                                    </button>
                                                </div>
                                                <div class="d-block">
                                                    <span
                                                        class=""
                                                        :class="{
                                                            'text-xs text-muted text-center badge bg-warning':
                                                                item.muestra_input,
                                                        }"
                                                    >
                                                        {{ item.repuesto }}
                                                    </span>
                                                    <button
                                                        v-if="
                                                            !item.muestra_input
                                                        "
                                                        type="button"
                                                        class="btn btn-primary btn-sm ms-1 fs-8 p-1"
                                                        title="Registrar faltante"
                                                        @click.prevent="
                                                            openInputRepuesto(
                                                                item,
                                                            )
                                                        "
                                                    >
                                                        <i
                                                            class="fa fa-plus"
                                                        ></i>
                                                    </button>
                                                </div>
                                            </td>
                                            <td>
                                                <el-input
                                                    type="textarea"
                                                    v-model="item.observacion"
                                                    autosize
                                                ></el-input>
                                            </td></tr
                                    ></template>
                                    <template v-else>
                                        <tr v-if="item.muestra_input">
                                            <td rowspan="2">{{ index + 1 }}</td>
                                            <td rowspan="2">
                                                {{ item.producto.nombre }}
                                            </td>
                                            <td rowspan="2" class="text-center">
                                                {{ item.cantidad }}
                                            </td>
                                            <td rowspan="2" class="text-center">
                                                {{ item.verificado }}
                                            </td>
                                            <td class="text-center">
                                                <span class="d-block">
                                                    <i
                                                        class="fa fa-clock text-success me-2"
                                                    ></i>
                                                    {{ item.faltantes }}
                                                </span>
                                            </td>
                                            <td class="text-center">
                                                <div
                                                    class="input-group"
                                                    v-if="item.muestra_input"
                                                    style="min-width: 110px"
                                                >
                                                    <span
                                                        class="input-group-text d-flex justify-content-center align-items-center px-1"
                                                    >
                                                        <i
                                                            class="fa fa-clock text-success"
                                                        ></i>
                                                    </span>
                                                    <input
                                                        type="number"
                                                        class="form-control text-center"
                                                        v-model="
                                                            item.repuesto_actual
                                                        "
                                                        @change="
                                                            cambioFaltante(item)
                                                        "
                                                        @keyup="
                                                            cambioFaltante(item)
                                                        "
                                                    />
                                                    <button
                                                        @click.prevent="
                                                            cancelarInputRepuesto(
                                                                item,
                                                            )
                                                        "
                                                        title="Cancelar"
                                                        class="btn btn-default bg-white border p-1 px-2 text-xs"
                                                    >
                                                        <i
                                                            class="fa fa-sync"
                                                        ></i>
                                                    </button>
                                                </div>
                                            </td>
                                            <td rowspan="2">
                                                <el-input
                                                    type="textarea"
                                                    v-model="item.observacion"
                                                    autosize
                                                ></el-input>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="text-center">
                                                <span
                                                    class="text-xs text-muted text-center badge bg-warning"
                                                    v-if="item.muestra_input"
                                                >
                                                    <i
                                                        class="fa fa-history text-gray me-2"
                                                    ></i>
                                                    {{
                                                        item.faltantes_aux
                                                    }}</span
                                                >
                                            </td>
                                            <td class="text-center">
                                                <div class="d-block">
                                                    <span
                                                        class=""
                                                        :class="{
                                                            'text-xs text-muted text-center badge bg-warning':
                                                                item.muestra_input,
                                                        }"
                                                    >
                                                        <i
                                                            class="fa fa-history text-gray me-2"
                                                        ></i>
                                                        {{ item.repuesto }}
                                                    </span>
                                                    <button
                                                        v-if="
                                                            !item.muestra_input
                                                        "
                                                        type="button"
                                                        class="btn btn-primary btn-sm ms-1 fs-8 p-1"
                                                        title="Registrar faltante"
                                                        @click.prevent="
                                                            openInputRepuesto(
                                                                item,
                                                            )
                                                        "
                                                    >
                                                        <i
                                                            class="fa fa-plus"
                                                        ></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </template>
                                </template>
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
