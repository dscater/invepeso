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

const listUsers = ref([]);
const cargarUsers = async () => {
    try {
        const res = await axios.get(route("usuarios.listado"));
        listUsers.value = res.data.usuarios;
    } catch (e) {
        console.log(e);
    } finally {
    }
};
const resumen = ref({
    ingresos: 0,
    egresos: 0,
    total_caja: 0,
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
    cargarAlmacens();
    cargarUsers();
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

const multiSearch = ref({
    search: "",
    almacen_id: "",
    fecha_ini: "",
    fecha_fin: "",
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
                                            placeholder="Seleccionar Usuario"
                                            filterable
                                            clearable
                                            @change="actualizarResumen"
                                        >
                                            <el-option
                                                v-for="item in listUsers"
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
                                            placeholder="Seleccionar Almacén"
                                            filterable
                                            clearable
                                            @change="actualizarResumen"
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
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12">
                        <div class="row">
                            <div class="col-md-4 mb-2">
                                <div class="card">
                                    <div class="card-header bgActivo">
                                        <h4
                                            class="card-title fs-7 fw-bold text-white"
                                        >
                                            Ingresos
                                        </h4>
                                    </div>
                                    <div class="card-body">
                                        <h4
                                            class="fw-bold fs-6 w-100 text-center text-success"
                                        >
                                            Bs. {{ resumen.ingresos }}
                                        </h4>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4 mb-2">
                                <div class="card card-danger">
                                    <div class="card-header">
                                        <h4
                                            class="card-title fs-7 fw-bold text-white"
                                        >
                                            Egresos
                                        </h4>
                                    </div>
                                    <div class="card-body">
                                        <h4
                                            class="fw-bold fs-6 w-100 text-center text-danger"
                                        >
                                            Bs. {{ resumen.egresos }}
                                        </h4>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4 mb-2">
                                <div class="card card-primary">
                                    <div class="card-header">
                                        <h4
                                            class="card-title fs-7 fw-bold text-white"
                                        >
                                            Total Caja
                                        </h4>
                                    </div>
                                    <div class="card-body">
                                        <h4
                                            class="fw-bold fs-6 w-100 text-center text-primary"
                                        >
                                            Bs. {{ resumen.total_caja }}
                                        </h4>
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
