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
onBeforeMount(() => {
    appStore.startLoading();
});

onMounted(() => {
    appStore.stopLoading();
});

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
        key: "monto",
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
        html: `<strong class="text-primary">Bs. ${item.monto}</strong><br/>Fecha: <strong>${item.fecha_hora_t}</strong><br/>Tipo de Movimiento: <strong>${item.tipo}</strong><br/>Tipo de Pago: <strong>${item.tipo_pago}</strong><br/>Ingreso/Egreso: <strong>${item.tipo_movimiento}</strong>`,
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
                    <div class="col-md-4">
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
                    <div class="col-md-8 my-1">
                        <div class="row justify-content-end">
                            <div class="col-md-5">
                                <div class="input-group">
                                    <input
                                        type="search"
                                        v-model="multiSearch.search"
                                        placeholder="Buscar"
                                        class="form-control border-1 border-right-0"
                                    />
                                    <div class="input-append">
                                        <button
                                            class="btn btn-default bg-white rounded-0"
                                            @click="updateDatos"
                                        >
                                            <i class="fa fa-search"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12">
                        <MiTable
                            :tableClass="'bg-white mitabla'"
                            ref="miTable"
                            :cols="headers"
                            :api="true"
                            :url="route('movimiento_cajas.paginado')"
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
                            <template #monto="{ item }">
                                <span
                                    class="badge text-sm"
                                    :class="{
                                        'bg-danger':
                                            item.tipo_movimiento == 'EGRESO',
                                        'bg-success':
                                            item.tipo_movimiento == 'INGRESO',
                                    }"
                                    >Bs. {{ item.monto }}</span
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
