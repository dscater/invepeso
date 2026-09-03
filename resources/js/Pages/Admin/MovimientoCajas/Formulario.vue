<script setup>
// TOAST
import { toast } from "vue3-toastify";
import "vue3-toastify/dist/index.css";
import { watch, ref, computed, onMounted, nextTick } from "vue";
const props = defineProps({
    form: {
        type: Object,
    },
});

const enviando = ref(false);
const form = props.form;

const textBtn = computed(() => {
    if (enviando.value) {
        return `<i class="fa fa-spin fa-spinner"></i> Enviando...`;
    }
    if (form.id == 0) {
        return `<i class="fa fa-save"></i> Registrar Movimiento`;
    }
    return `<i class="fa fa-edit"></i> Actualizar Movimiento`;
});

const enviarFormulario = () => {
    enviando.value = true;
    let url =
        form.id == 0
            ? route("movimiento_cajas.store")
            : route("movimiento_cajas.update", form.id);

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

            cargarProductos();
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

const emits = defineEmits(["envio-formulario"]);

const listAlmacens = ref([]);
const listTipoPagos = ref([]);
const listTipoVentas = ref([]);
const almacen_id = ref("");

const cargarAlmacens = async () => {
    try {
        const res = await axios.get(route("almacens.listado"));
        listAlmacens.value = res.data.almacens;
    } catch (e) {
        console.log(e);
    } finally {
    }
};

const cargarTipoPagos = async () => {
    try {
        const res = await axios.get(route("tipo_pagos.listado"));
        listTipoPagos.value = res.data.tipo_pagos;
    } catch (e) {
        console.log(e);
    } finally {
    }
};

const cargarTipoVentas = async () => {
    try {
        const res = await axios.get(route("tipo_ventas.listado"));
        listTipoVentas.value = res.data.tipo_ventas;
    } catch (e) {
        console.log(e);
    } finally {
    }
};

const cargarListas = () => {
    cargarTipoPagos();
    cargarTipoVentas();
    cargarAlmacens();
};

onMounted(() => {
    cargarListas();
});
</script>

<template>
    <form @submit.prevent="enviarFormulario()">
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-4">
                                <label class="required"
                                    >Seleccionar Almacén</label
                                >
                                <el-select
                                    v-model="form.almacen_id"
                                    placeholder="Seleccionar Almacén"
                                    no-data-text="Sin datos"
                                    no-match-text="Sin resultados"
                                    filterable
                                >
                                    <el-option
                                        v-for="almacen in listAlmacens"
                                        :key="almacen.id"
                                        :label="`${almacen.nombre} - ${almacen.sucursal.nombre}`"
                                        :value="almacen.id"
                                    ></el-option>
                                </el-select>
                                <ul
                                    v-if="form.errors?.almacen_id"
                                    class="d-block text-danger list-unstyled"
                                >
                                    <li class="parsley-required">
                                        {{ form.errors?.almacen_id }}
                                    </li>
                                </ul>
                            </div>
                            <div class="col-md-4">
                                <label class="required">Monto Bs.</label>
                                <input
                                    type="number"
                                    min="0"
                                    v-model="form.monto"
                                    class="form-control"
                                    placeholder="Monto en Bolivianos"
                                />
                                <ul
                                    v-if="form.errors?.monto"
                                    class="d-block text-danger list-unstyled"
                                >
                                    <li class="parsley-required">
                                        {{ form.errors?.monto }}
                                    </li>
                                </ul>
                            </div>
                            <div class="col-md-4">
                                <label class="required"
                                    >Seleccionar Ingreso/Egreso</label
                                >
                                <br />
                                <el-switch
                                    size="large"
                                    active-text="INGRESO"
                                    inactive-text="EGRESO"
                                    v-model="form.tipo_movimiento"
                                    :active-value="'INGRESO'"
                                    :inactive-value="'EGRESO'"
                                    style="
                                        --el-switch-on-color: #13ce66;
                                        --el-switch-off-color: #ff4949;
                                    "
                                />
                                <ul
                                    v-if="form.errors?.tipo_movimiento"
                                    class="d-block text-danger list-unstyled"
                                >
                                    <li class="parsley-required">
                                        {{ form.errors?.tipo_movimiento }}
                                    </li>
                                </ul>
                            </div>
                            <div class="col-md-4">
                                <label class="required">Tipo de Pago</label>
                                <el-radio-group
                                    v-model="form.tipo_pago"
                                    size="large"
                                    fill="#409eff"
                                >
                                    <el-radio-button
                                        v-for="item in listTipoPagos"
                                        :value="item.value"
                                        ><i :class="item.icon"></i>
                                        {{ item.label }}</el-radio-button
                                    >
                                </el-radio-group>
                                <ul
                                    v-if="form.errors?.tipo_pago"
                                    class="d-block text-danger list-unstyled"
                                >
                                    <li class="parsley-required">
                                        {{ form.errors?.tipo_pago }}
                                    </li>
                                </ul>
                            </div>
                            <div class="col-md-4">
                                <label class="required">Descripción</label>
                                <el-input
                                    type="textarea"
                                    v-model="form.descripcion"
                                    placeholder="Descripción"
                                    autosize
                                >
                                </el-input>
                                <ul
                                    v-if="form.errors?.descripcion"
                                    class="d-block text-danger list-unstyled"
                                >
                                    <li class="parsley-required">
                                        {{ form.errors?.descripcion }}
                                    </li>
                                </ul>
                            </div>
                            <div class="col-md-4">
                                <label class="required">Fecha</label>
                                <input
                                    type="date"
                                    v-model="form.fecha"
                                    class="form-control"
                                    placeholder="Fecha"
                                />
                                <ul
                                    v-if="form.errors?.fecha"
                                    class="d-block text-danger list-unstyled"
                                >
                                    <li class="parsley-required">
                                        {{ form.errors?.fecha }}
                                    </li>
                                </ul>
                            </div>
                            <div class="col-md-4">
                                <label class="required">Hora</label>
                                <input
                                    type="time"
                                    v-model="form.hora"
                                    step="1"
                                    class="form-control"
                                    placeholder="Hora"
                                />
                                <ul
                                    v-if="form.errors?.hora"
                                    class="d-block text-danger list-unstyled"
                                >
                                    <li class="parsley-required">
                                        {{ form.errors?.hora }}
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <div class="row mt-2">
                            <div class="col-12">
                                <button
                                    class="btn btn-primary"
                                    v-html="textBtn"
                                    :disabled="enviando"
                                ></button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</template>
