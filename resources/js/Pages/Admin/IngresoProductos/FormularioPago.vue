<script setup>
import MiModal from "@/Components/MiModal.vue";
import { useForm, usePage } from "@inertiajs/vue3";
import { useAxios } from "@/composables/axios/useAxios";
import { watch, ref, computed, onMounted, nextTick } from "vue";
const { axiosDelete } = useAxios();
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
    return `<i class="fa fa-list"></i> Registro de Pagos por Compra`;
});

const textBtn = computed(() => {
    if (enviando.value) {
        return `<i class="fa fa-spin fa-spinner"></i> Enviando...`;
    }

    if (formPago.id != 0) {
        return `<i class="fa fa-edit"></i> Modificar Pago`;
    }

    return `<i class="fa fa-save"></i> Registrar Pago`;
});

const enviarFormulario = async () => {
    enviando.value = true;

    const url =
        formPago.id == 0
            ? route("ingreso_productos.registrar_pago", form.id)
            : route("ingreso_productos.actualizar_pago", formPago.id);

    try {
        const response = await axios.post(url, formPago);

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

            await actualizarListaPagos();

            if (formPago.id == 0) {
                form.saldo =
                    parseFloat(form.saldo) - parseFloat(formPago.monto);
                form.saldo = form.saldo.toFixed(2);
            } else {
                form.saldo = response.data.ingreso_producto.saldo;
                form.saldo = parseFloat(form.saldo).toFixed(2);
            }

            emits("envio-formulario");
            cancelarRegistro();
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

const actualizarListaPagos = () => {
    axios
        .get(route("ingreso_pagos.listaByIngreso", form.id))
        .then((response) => {
            form.ingreso_pagos = response.data.ingreso_pagos;
        });
};

const listAlmacens = ref([]);
const cargarAlmacens = async () => {
    try {
        const res = await axios.get(route("almacens.listado"), {
            params: {
                activo: 1,
            },
        });
        listAlmacens.value = res.data.almacens;
    } catch (e) {
        console.log(e);
    } finally {
    }
};

const initialState = {
    id: 0,
    sucursal_id: "",
    almacen_id: "",
    ingreso_producto_id: "",
    proveedor_id: "",
    monto: 0,
    fecha: "",
    hora: "",
    user_id: "",
    _method: "POST",
};
const mostrarFormulario = ref(false);

const nuevoPago = () => {
    cancelarRegistro();
    toggleFormulario(true);
};

const toggleFormulario = (sw = true) => {
    mostrarFormulario.value = sw;
    if (sw) {
        formPago.ingreso_producto_id = form.id;
        formPago.proveedor_id = form.proveedor_id;
        formPago.sucursal_id = form.sucursal_id;
        formPago.almacen_id = form.almacen_id;
    }
};

const cancelarRegistro = () => {
    formPago.clearErrors();
    formPago.reset();
    formPago.defaults({ ...initialState });
    toggleFormulario(false);
};

const formPago = useForm({ ...initialState });

const setIngresoPago = (item = null) => {
    formPago.clearErrors();
    formPago.reset();
    Object.assign(formPago, item);
    formPago._method = "PUT";
};
const editarPago = (item) => {
    setIngresoPago(item);
    toggleFormulario(true);
};

const eliminarPago = (item) => {
    Swal.fire({
        // icon: "question",
        title: "¿Quierés eliminar este registro?",
        html: `<strong>${item.fecha_hora_t}</strong><br/><b>Monto: </b>${item.monto}<br/>`,
        showCancelButton: true,
        confirmButtonText: "Si, eliminar",
        cancelButtonText: "No, cancelar",
        denyButtonText: `No, cancelar`,
        customClass: {
            confirmButton: "btn-danger",
        },
    }).then(async (result) => {
        /* Read more about isConfirmed, isDenied below */
        if (result.isConfirmed) {
            let respuesta = await axiosDelete(
                route("ingreso_productos.eliminar_pago", item.id),
            );
            if (respuesta && respuesta.sw) {
                await actualizarListaPagos();
                form.saldo = respuesta.ingreso_producto.saldo;
                form.saldo = parseFloat(form.saldo).toFixed(2);
                emits("envio-formulario");
            }
        }
    });
};

const totalCancelado = computed(() => {
    return form.ingreso_pagos.reduce((acc, item) => {
        return acc + parseFloat(item.monto || 0);
    }, 0);
});

onMounted(() => {
    cargarAlmacens();
    formPago.sucursal_id = form.sucursal_id;
    formPago.almacen_id = form.almacen_id;
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
            <div class="row">
                <div class="col-12">
                    <span class="float-end text-sm"
                        ><i class="fa fa-calendar-alt"></i>
                        {{ form.fecha_registro_t }}</span
                    >
                </div>
                <div class="col-12">
                    <span class="float-end text-sm"
                        ><i class="fa fa-truck"></i>
                        {{ form.proveedor.nombre }}</span
                    >
                    <h4 class="text-primary fw-bold fs-5">
                        <i class="fa fa-barcode"></i>
                        {{ form.codigo }}
                    </h4>
                    <h4 class="float-end fw-bold fs-5 text-danger">
                        Saldo Bs.: {{ form.saldo }}
                    </h4>
                    <h4 class="float-end fw-bold fs-5 text-bgDarkGrayP me-3">
                        Adelanto Bs.: {{ form.cancelado }}
                    </h4>
                    <h4 class="fw-bold fs-5 text-success">
                        Total Bs.: {{ form.total }}
                    </h4>
                </div>
                <div class="col-12">
                    <h5 class="fs-5 w-100 text-center">Pagos realizados</h5>
                    <div class="row">
                        <div class="col-12">
                            <button
                                class="btn btn-sm btn-primary fs-7"
                                @click="nuevoPago"
                                v-if="!mostrarFormulario"
                            >
                                <i class="fa fa-plus"></i> Nuevo Pago
                            </button>
                            <button
                                class="btn btn-sm btn-light border fs-7"
                                @click="cancelarRegistro"
                                v-if="mostrarFormulario"
                            >
                                <i class="fa fa-times"></i> Cancelar
                            </button>
                        </div>
                        <div class="col-12 my-1" v-if="mostrarFormulario">
                            <form @submit.prevent="enviarFormulario()">
                                <div class="row">
                                    <div class="col-12">
                                        <h5 class="fs-7">
                                            {{
                                                formPago.id == 0
                                                    ? "Nuevo"
                                                    : "Editar"
                                            }}
                                            Pago
                                        </h5>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-5">
                                        <label>Almacén</label>
                                        <div class="input-group">
                                            <span class="input-group-text">
                                                <i class="fa fa-warehouse"></i>
                                            </span>
                                            <div
                                                class="form-control border-0 p-0"
                                            >
                                                <el-select
                                                    v-model="
                                                        formPago.almacen_id
                                                    "
                                                    class="el-select-input-group-right"
                                                    no-data-text="Sin datos"
                                                    no-match-text="Sin resultados"
                                                    placeholder="Seleccionar Almacén"
                                                    filterable
                                                >
                                                    <el-option
                                                        v-for="item in listAlmacens"
                                                        :key="item.id"
                                                        :value="item.id"
                                                        :label="`${item.nombre} - ${item.sucursal.nombre}`"
                                                    ></el-option>
                                                </el-select>
                                            </div>
                                        </div>
                                        <ul
                                            v-if="formPago.errors?.almacen_id"
                                            class="d-block text-danger list-unstyled"
                                        >
                                            <li class="parsley-required">
                                                {{
                                                    formPago.errors?.almacen_id
                                                }}
                                            </li>
                                        </ul>
                                    </div>
                                    <div class="col-md-4">
                                        <label>Monto</label>
                                        <div class="input-group">
                                            <span class="input-group-text">
                                                <i class="fa fa-money-bill"></i>
                                            </span>
                                            <div
                                                class="form-control border-0 p-0"
                                            >
                                                <input
                                                    v-model="formPago.monto"
                                                    class="form-control"
                                                />
                                            </div>
                                        </div>
                                        <ul
                                            v-if="formPago.errors?.monto"
                                            class="d-block text-danger list-unstyled"
                                        >
                                            <li class="parsley-required">
                                                {{ formPago.errors?.monto }}
                                            </li>
                                        </ul>
                                    </div>
                                    <div
                                        class="col-md-3 d-flex align-items-end"
                                    >
                                        <button
                                            :disabled="enviando"
                                            @click="enviarFormulario"
                                            class="btn btn-success w-100"
                                            v-html="textBtn"
                                        ></button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th class="bg-principal text-white">Fecha</th>
                                <th class="bg-principal text-white">
                                    Almacén - Sucursal
                                </th>
                                <th class="bg-principal text-white">Monto</th>
                                <th class="bg-principal text-white">
                                    Responsable
                                </th>
                                <th class="bg-principal text-white">Acción</th>
                            </tr>
                        </thead>
                        <tbody>
                            <template v-if="form.ingreso_pagos.length > 0">
                                <tr
                                    class="fs-7"
                                    v-for="(item, index) in form.ingreso_pagos"
                                    :key="item.id"
                                >
                                    <td>{{ item.fecha_hora_t }}</td>
                                    <td class="">
                                        {{ item.almacen?.nombre }} -
                                        {{ item.sucursal?.nombre }}
                                    </td>
                                    <td>{{ item.monto }}</td>
                                    <td class="text-center">
                                        {{ item.user?.nombre }}
                                        {{ item.user?.paterno }}
                                        {{ item.user?.materno }}
                                    </td>
                                    <td>
                                        <button
                                            type="button"
                                            class="btn btn-warning btn-sm fs-7"
                                            @click.prevent="editarPago(item)"
                                        >
                                            <i class="fa fa-edit"></i>
                                        </button>
                                        <button
                                            type="button"
                                            class="btn btn-danger btn-sm fs-7"
                                            @click.prevent="eliminarPago(item)"
                                        >
                                            <i class="fa fa-trash"></i>
                                        </button>
                                    </td>
                                </tr>
                                <tr>
                                    <td
                                        class="bg-principal fw-bold"
                                        colspan="2"
                                    >
                                        TOTAL
                                    </td>
                                    <td class="bg-principal fw-bold">
                                        {{ totalCancelado.toFixed(2) }}
                                    </td>
                                    <td
                                        class="bg-principal fw-bold"
                                        colspan="3"
                                    ></td>
                                </tr>
                            </template>
                            <template v-else>
                                <tr>
                                    <td
                                        colspan="5"
                                        class="text-center text-muted fs-6"
                                    >
                                        SIN REGISTROS
                                    </td>
                                </tr>
                            </template>
                        </tbody>
                    </table>
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
