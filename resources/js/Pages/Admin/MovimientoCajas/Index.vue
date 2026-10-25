<script setup>
import Content from "@/Components/Content.vue";
import MiTable from "@/Components/MiTable.vue";
import { Head, Link, router, usePage } from "@inertiajs/vue3";
import { useMovimientoCajas } from "@/composables/movimiento_cajas/useMovimientoCajas";
import { useAxios } from "@/composables/axios/useAxios";
import { ref, onMounted, onBeforeMount } from "vue";
import { useAppStore } from "@/stores/aplicacion/appStore";
// import { useMenu } from "@/composables/useMenu";
import Formulario from "./Formulario.vue";
import { buttonProps } from "element-plus";
// const { mobile, identificaDispositivo } = useMenu();
const { props: props_page } = usePage();
const appStore = useAppStore();

const props = defineProps({
    almacens: {
        type: Array,
        default: () => [],
    },
    usuarios: {
        type: Array,
        default: () => [],
    },
});

const resumen = ref({
    ingresos: 0,
    ingresos_qr: 0,
    ingresos_efectivo: 0,
    egresos: 0,
    egresos_qr: 0,
    egresos_efectivo: 0,
    total_caja: 0,
    total_caja_qr: 0,
    total_caja_efectivo: 0,
});

const cargarResumen = async () => {
    try {
        const res = await axios.get(route("movimiento_cajas.resumen"), {
            params: multiSearch.value,
        });
        resumen.value = res.data.resumen;
    } catch (e) {
        console.log(e);
    } finally {
    }
};

onBeforeMount(() => {
    cargarResumen();
    appStore.startLoading();
});
onMounted(() => {
    appStore.stopLoading();
});

const actualizarResumen = () => {
    cargarResumen();
};

const { setMovimientoCaja, limpiarMovimientoCaja, form } = useMovimientoCajas();
const { axiosDelete } = useAxios();

const miTable = ref(null);
const headers = [
    {
        label: "Nro.",
        key: "id",
        sortable: true,
        width: "4%",
    },
    {
        label: "ALMACÉN-SUCURSAL",
        key: "ubicacion",
        sortable: true,
    },
    {
        label: "MOVIMIENTO POR",
        key: "tipo",
        sortable: true,
    },
    {
        label: "MONTO",
        key: "monto_total",
        sortable: true,
    },
    {
        label: "TIPO DE PAGO",
        key: "tipo_pago",
        sortable: true,
    },
    {
        label: "DESCRIPCIÓN",
        key: "descripcion",
        sortable: true,
    },
    {
        label: "FECHA",
        key: "fecha_hora_t",
        sortable: true,
    },
    {
        label: "RESPONSABLE",
        key: "user",
        sortable: true,
    },
    {
        label: "ACCIÓN",
        key: "accion",
        fixed: "right",
        width: "4%",
    },
];
const getFechaAtual = () => {
    const today = new Date();
    const year = today.getFullYear();
    const month = String(today.getMonth() + 1).padStart(2, "0");
    const day = String(today.getDate()).padStart(2, "0");
    return `${year}-${month}-${day}`;
};
const multiSearch = ref({
    search: "",
    almacen_id: "",
    fecha_ini: getFechaAtual(),
    fecha_fin: getFechaAtual(),
    user_id: "",
    filtro: [],
});

const muestra_formulario = ref(false);

const agregarRegistro = () => {
    limpiarMovimientoCaja();
    muestra_formulario.value = true;
};

const updateDatatable = async () => {
    if (miTable.value) {
        await miTable.value.cargarDatos();
        limpiarMovimientoCaja();
        muestra_formulario.value = false;
    }
};

const eliminarMovimientoCaja = (item) => {
    Swal.fire({
        title: "¿Quierés eliminar este registro?",
        html: `<strong class="text-primary">Bs. ${item.monto_total}</strong><br/>Fecha: <strong>${item.fecha_hora_t}</strong><br/>Tipo de Movimiento: <strong>${item.tipo}</strong><br/>Tipo de Pago: <strong>${item.tipo_pago}</strong><br/>Ingreso/Egreso: <strong>${item.tipo_movimiento}</strong>`,
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
                route("movimiento_cajas.destroy", item.id),
            );
            if (respuesta && respuesta.sw) {
                updateDatatable();
            }
        }
    });
};
</script>
<template>
    <Head title="Lista de Movimientos"></Head>
    <Content>
        <template #header>
            <div class="row">
                <div class="col-sm-6">
                    <h3 class="m-0">
                        <i class="fa fa-cash-register"></i> Lista de Movimientos
                    </h3>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-end">
                        <li class="breadcrumb-item">
                            <Link :href="route('inicio')">Inicio</Link>
                        </li>
                        <li class="breadcrumb-item active">
                            Lista de Movimientos
                        </li>
                    </ol>
                </div>
                <!-- /.col -->
            </div>
            <!-- /.row -->
        </template>
        <div class="row">
            <div class="col-md-12">
                <div class="row">
                    <div class="col-md-12">
                        <Link
                            v-if="
                                props_page.auth?.user.permisos == '*' ||
                                props_page.auth?.user.permisos.includes(
                                    'movimiento_cajas.create',
                                )
                            "
                            :href="route('movimiento_cajas.create')"
                            class="btn btn-primary text-sm"
                        >
                            <i class="fa fa-plus"></i> Nuevo Movimiento
                        </Link>
                    </div>
                    <div class="col-md-12 my-1">
                        <div class="row justify-content-end">
                            <div class="col-md-4">
                                <div class="row">
                                    <div class="col-6">
                                        <span class="text-muted text-xs"
                                            >Desde</span
                                        >
                                        <input
                                            type="date"
                                            class="form-control"
                                            v-model="multiSearch.fecha_ini"
                                            @keyup="actualizarResumen"
                                            @change="actualizarResumen"
                                        />
                                    </div>
                                    <div class="col-6">
                                        <span class="text-muted text-xs"
                                            >Hasta</span
                                        >
                                        <input
                                            type="date"
                                            class="form-control"
                                            v-model="multiSearch.fecha_fin"
                                            @keyup="actualizarResumen"
                                            @change="actualizarResumen"
                                        />
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <span class="text-muted text-xs">Usuario</span>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="fa fa-users"></i>
                                    </span>
                                    <div class="form-control border-0 p-0">
                                        <el-select
                                            v-model="multiSearch.user_id"
                                            class="el-select-input-group-right"
                                            no-data-text="Sin datos"
                                            no-match-text="Sin resultados"
                                            placeholder="Todos los usuarios"
                                            filterable
                                            clearable
                                            @change="actualizarResumen"
                                        >
                                            <el-option
                                                value=""
                                                label="Todos los usuarios"
                                            />
                                            <el-option
                                                v-for="item in usuarios"
                                                :key="item.id"
                                                :value="item.id"
                                                :label="`${item.full_name}`"
                                            ></el-option>
                                        </el-select>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <span class="text-muted text-xs">Almacén</span>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="fa fa-warehouse"></i>
                                    </span>
                                    <div class="form-control border-0 p-0">
                                        <el-select
                                            v-model="multiSearch.almacen_id"
                                            class="el-select-input-group-right"
                                            no-data-text="Sin datos"
                                            no-match-text="Sin resultados"
                                            placeholder="Todos los almacenes"
                                            filterable
                                            clearable
                                            @change="actualizarResumen"
                                        >
                                            <el-option
                                                value=""
                                                label="Todos los almacenes"
                                            />
                                            <el-option
                                                v-for="item in almacens"
                                                :key="item.id"
                                                :value="item.id"
                                                :label="`${item.nombre} - ${item.sucursal.nombre}`"
                                            ></el-option>
                                        </el-select>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12">
                        <div class="row">
                            <div class="col-md-4 mb-2">
                                <div class="card">
                                    <div
                                        class="card-header bgActivo2 text-success"
                                    >
                                        <div class="row">
                                            <div class="col-6 fw-bold">
                                                Ingresos
                                            </div>
                                            <div
                                                class="col-6 text-end fw-bold fs-5"
                                            >
                                                {{ resumen.ingresos }}
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card-body text-success">
                                        <div class="row">
                                            <div class="col-6 text-center">
                                                {{ resumen.ingresos_qr }}<br />
                                                <i class="fa fa-qrcode"></i>
                                            </div>
                                            <div class="col-6 text-center">
                                                {{ resumen.ingresos_efectivo
                                                }}<br />
                                                <i class="fa fa-money-bill"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4 mb-2">
                                <div class="card">
                                    <div
                                        class="card-header bgInactivo2 text-danger"
                                    >
                                        <div class="row">
                                            <div class="col-6 fw-bold">
                                                Egresos
                                            </div>
                                            <div
                                                class="col-6 text-end fw-bold fs-5"
                                            >
                                                {{ resumen.egresos }}
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card-body text-danger">
                                        <div class="row">
                                            <div class="col-6 text-center">
                                                {{ resumen.egresos_qr }}<br />
                                                <i class="fa fa-qrcode"></i>
                                            </div>
                                            <div class="col-6 text-center">
                                                {{ resumen.egresos_efectivo
                                                }}<br />
                                                <i class="fa fa-money-bill"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4 mb-2">
                                <div class="card">
                                    <div
                                        class="card-header bgPrimary2 text-primary"
                                    >
                                        <div class="row">
                                            <div class="col-6 fw-bold">
                                                Total Caja
                                            </div>
                                            <div
                                                class="col-6 text-end fw-bold fs-5"
                                            >
                                                {{ resumen.total_caja }}
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card-body text-primary">
                                        <div class="row">
                                            <div class="col-6 text-center">
                                                {{ resumen.total_caja_qr
                                                }}<br />
                                                <i class="fa fa-qrcode"></i>
                                            </div>
                                            <div class="col-6 text-center">
                                                {{ resumen.total_caja_efectivo
                                                }}<br />
                                                <i class="fa fa-money-bill"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-12">
                        <MiTable
                            :tableClass="'bg-white mitabla'"
                            ref="miTable"
                            :cols="headers"
                            :api="true"
                            :url="route('movimiento_cajas.paginado')"
                            :per-page="10"
                            :numPages="5"
                            :multiSearch="multiSearch"
                            :syncOrderBy="'id'"
                            :syncOrderAsc="'DESC'"
                            table-responsive
                            :header-class="'bg__primary'"
                            fixed-header
                        >
                            <template #ubicacion="{ item }">
                                <span class="text-dark text-sm">{{
                                    item.almacen?.nombre
                                }}</span>
                                -
                                <span class="text-dark text-sm">{{
                                    item.sucursal?.nombre
                                }}</span>
                            </template>
                            <template #monto_total="{ item }">
                                <span
                                    class="badge text-sm"
                                    :class="{
                                        'bg-danger':
                                            item.tipo_movimiento == 'EGRESO',
                                        'bg-success':
                                            item.tipo_movimiento == 'INGRESO',
                                    }"
                                    >Bs. {{ item.monto_total }}</span
                                >
                            </template>
                            <template #user="{ item }">
                                <span class="text-dark text-sm"
                                    >{{ item.user?.nombre }}
                                    {{ item.user?.paterno }}
                                    {{ item.user?.materno }}</span
                                >
                            </template>
                            <template #accion="{ item }">
                                <template
                                    v-if="
                                        item.tipo == 'MOVIMIENTO DE CAJA' &&
                                        (props_page.auth?.user.permisos ==
                                            '*' ||
                                            props_page.auth?.user.permisos.includes(
                                                'movimiento_cajas.edit',
                                            ))
                                    "
                                >
                                    <el-tooltip
                                        class="box-item"
                                        effect="dark"
                                        content="Editar"
                                        placement="left-start"
                                    >
                                        <Link
                                            class="btn btn-warning"
                                            :href="
                                                route(
                                                    'movimiento_cajas.edit',
                                                    item.id,
                                                )
                                            "
                                        >
                                            <i class="fa fa-pen"></i></Link
                                    ></el-tooltip>
                                </template>

                                <template
                                    v-if="
                                        item.tipo == 'MOVIMIENTO DE CAJA' &&
                                        (props_page.auth?.user.permisos ==
                                            '*' ||
                                            props_page.auth?.user.permisos.includes(
                                                'movimiento_cajas.destroy',
                                            ))
                                    "
                                >
                                    <el-tooltip
                                        class="box-item"
                                        effect="dark"
                                        content="Eliminar"
                                        placement="left-start"
                                    >
                                        <button
                                            class="btn btn-danger"
                                            @click="
                                                eliminarMovimientoCaja(item)
                                            "
                                        >
                                            <i
                                                class="fa fa-trash-alt"
                                            ></i></button
                                    ></el-tooltip>
                                </template>
                            </template>
                        </MiTable>
                    </div>
                </div>
            </div>
        </div>
        <Formulario
            v-if="muestra_formulario"
            :muestra_formulario="muestra_formulario"
            :form="form"
            @envio-formulario="updateDatatable"
            @cerrar-formulario="muestra_formulario = false"
        ></Formulario>
    </Content>
</template>
