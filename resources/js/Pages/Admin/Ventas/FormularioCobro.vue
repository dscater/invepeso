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
    return `<i class="fa fa-list"></i> Registro de Cobros por Venta a Crédito`;
});

const textBtn = computed(() => {
    if (enviando.value) {
        return `<i class="fa fa-spin fa-spinner"></i> Enviando...`;
    }

    if (formCobro.id != 0) {
        return `<i class="fa fa-edit"></i> Modificar Cobro`;
    }

    return `<i class="fa fa-save"></i> Registrar Cobro`;
});

const enviarFormulario = async () => {
    enviando.value = true;

    const url =
        formCobro.id == 0
            ? route("ventas.registrar_cobro", form.id)
            : route("ventas.actualizar_cobro", formCobro.id);

    try {
        const response = await axios.post(url, formCobro);

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

            await actualizarListaCobros();

            if (formCobro.id == 0) {
                form.saldo =
                    parseFloat(form.saldo) - parseFloat(formCobro.monto);
                form.saldo = form.saldo.toFixed(2);
            } else {
                form.saldo = response.data.venta.saldo;
                form.saldo = parseFloat(form.saldo).toFixed(2);
            }

            if (response.data.url_blank) {
                window.open(response.data.url_blank, "_blank");
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

const actualizarListaCobros = () => {
    axios.get(route("venta_cobros.listaByVenta", form.id)).then((response) => {
        form.venta_cobros = response.data.venta_cobros;
    });
};

const listTipoPagos = ref([]);
const cargarTipoPagos = async () => {
    try {
        const res = await axios.get(route("tipo_pagos.listado"));
        listTipoPagos.value = res.data.tipo_pagos;
    } catch (e) {
        console.log(e);
    } finally {
    }
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
    venta_id: "",
    cliente_id: "",
    tipo_pago: "EFECTIVO",
    monto: 0,
    fecha: "",
    hora: "",
    user_id: "",
    _method: "POST",
};
const mostrarFormulario = ref(false);

const nuevoCobro = () => {
    cancelarRegistro();
    toggleFormulario(true);
};

const toggleFormulario = (sw = true) => {
    mostrarFormulario.value = sw;
    if (sw) {
        formCobro.venta_id = form.id;
        formCobro.cliente_id = form.cliente_id;
        formCobro.sucursal_id = form.sucursal_id;
        formCobro.almacen_id = form.almacen_id;
    }
};

const cancelarRegistro = () => {
    formCobro.clearErrors();
    formCobro.reset();
    formCobro.defaults({ ...initialState });
    toggleFormulario(false);
};

const formCobro = useForm({ ...initialState });

const setVentaCobro = (item = null) => {
    formCobro.clearErrors();
    formCobro.reset();
    Object.assign(formCobro, item);
    formCobro._method = "PUT";
};

const editarCobro = (item) => {
    setVentaCobro(item);
    toggleFormulario(true);
};

const eliminarCobro = (item) => {
    Swal.fire({
        // icon: "question",
        title: "¿Quierés eliminar este registro?",
        html: `<strong>${item.fecha_hora_t}</strong><br/><b>Monto: </b>${item.monto}<br/><b>Tipo Pago: </b>${item.tipo_pago}`,
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
                route("ventas.eliminar_cobro", item.id),
            );
            if (respuesta && respuesta.sw) {
                await actualizarListaCobros();
                form.saldo = respuesta.venta.saldo;
                form.saldo = parseFloat(form.saldo).toFixed(2);
                emits("envio-formulario");
            }
        }
    });
};

const totalCancelado = computed(() => {
    return form.venta_cobros.reduce((acc, item) => {
        return acc + parseFloat(item.monto || 0);
    }, 0);
});

onMounted(() => {
    cargarTipoPagos();
    cargarAlmacens();
    formCobro.sucursal_id = form.sucursal_id;
    formCobro.almacen_id = form.almacen_id;
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
                    <span class="float-end text-sm ms-2"
                        ><i class="fa fa-id-card"></i>
                        {{ form.tipo_documento?.nombre }}:
                        {{ form.nit_ci }}</span
                    >
                    <span class="float-end text-sm"
                        ><i class="fa fa-user-tag"></i>
                        {{ form.cliente.nombre }}</span
                    >
                    <h4 class="text-primary fw-bold fs-5">
                        <i class="fa fa-barcode"></i>
                        {{ form.codigo_venta }}
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
                <div class="col-12 border-top pt-2">
                    <h5 class="fs-5 w-100 text-center">Pagos realizados</h5>
                    <div class="row">
                        <div class="col-12">
                            <button
                                class="btn btn-sm btn-primary fs-7"
                                @click="nuevoCobro"
                                v-if="!mostrarFormulario"
                            >
                                <i class="fa fa-plus"></i> Nuevo Cobro
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
                                                formCobro.id == 0
                                                    ? "Nuevo"
                                                    : "Editar"
                                            }}
                                            Cobro
                                        </h5>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-4">
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
                                                        formCobro.almacen_id
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
                                            v-if="formCobro.errors?.almacen_id"
                                            class="d-block text-danger list-unstyled"
                                        >
                                            <li class="parsley-required">
                                                {{
                                                    formCobro.errors?.almacen_id
                                                }}
                                            </li>
                                        </ul>
                                    </div>
                                    <div class="col-md-3">
                                        <label>Monto</label>
                                        <div class="input-group">
                                            <span class="input-group-text">
                                                <i class="fa fa-money-bill"></i>
                                            </span>
                                            <div
                                                class="form-control border-0 p-0"
                                            >
                                                <input
                                                    v-model="formCobro.monto"
                                                    class="form-control"
                                                />
                                            </div>
                                        </div>
                                        <ul
                                            v-if="formCobro.errors?.monto"
                                            class="d-block text-danger list-unstyled"
                                        >
                                            <li class="parsley-required">
                                                {{ formCobro.errors?.monto }}
                                            </li>
                                        </ul>
                                    </div>
                                    <div class="col-md-3">
                                        <label>Tipo de Pago</label>
                                        <el-radio-group
                                            v-model="formCobro.tipo_pago"
                                            ><el-radio-button
                                                v-for="item in listTipoPagos"
                                                :key="item.value"
                                                :value="item.value"
                                            >
                                                <i :class="item.icon"></i>
                                                {{
                                                    item.label
                                                }}</el-radio-button
                                            >
                                        </el-radio-group>
                                        <ul
                                            v-if="formCobro.errors?.monto"
                                            class="d-block text-danger list-unstyled"
                                        >
                                            <li class="parsley-required">
                                                {{ formCobro.errors?.monto }}
                                            </li>
                                        </ul>
                                    </div>
                                    <div
                                        class="col-md-2 d-flex align-items-end"
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
                                    Tipo Pago
                                </th>
                                <th class="bg-principal text-white">
                                    Responsable
                                </th>
                                <th class="bg-principal text-white">Acción</th>
                            </tr>
                        </thead>
                        <tbody>
                            <template v-if="form.venta_cobros.length > 0">
                                <tr
                                    class="fs-7"
                                    v-for="(item, index) in form.venta_cobros"
                                    :key="item.id"
                                >
                                    <td>{{ item.fecha_hora_t }}</td>
                                    <td class="">
                                        {{ item.almacen?.nombre }} -
                                        {{ item.sucursal?.nombre }}
                                    </td>
                                    <td>{{ item.monto }}</td>
                                    <td>{{ item.tipo_pago }}</td>
                                    <td class="text-center">
                                        {{ item.user?.nombre }}
                                        {{ item.user?.paterno }}
                                        {{ item.user?.materno }}
                                    </td>
                                    <td>
                                        <button
                                            type="button"
                                            class="btn btn-warning btn-sm fs-7"
                                            @click.prevent="editarCobro(item)"
                                            title="Editar Cobro"
                                        >
                                            <i class="fa fa-edit"></i>
                                        </button>
                                        <button
                                            type="button"
                                            class="btn btn-danger btn-sm fs-7"
                                            title="Eliminar Cobro"
                                            @click.prevent="eliminarCobro(item)"
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
