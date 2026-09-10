<script setup>
import Content from "@/Components/Content.vue";
import MiTable from "@/Components/MiTable.vue";
import { Head, Link, router, usePage } from "@inertiajs/vue3";
import { useVentas } from "@/composables/ventas/useVentas";
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

const { setVenta, limpiarVenta, form } = useVentas();
const { axiosDelete, axiosPost } = useAxios();

const miTable = ref(null);
const headers = [
    {
        label: "Código",
        key: "codigo_venta",
        sortable: true,
        width: "4%",
    },
    {
        label: "ALMACÉN-SUCURSAL",
        key: "ubicacion",
        sortable: true,
    },
    {
        label: "CLIENTE",
        key: "cliente",
        sortable: true,
    },
    {
        label: "TOTAL BS.",
        key: "total",
        sortable: true,
    },
    {
        label: "TIPO DE VENTA",
        key: "tipo_venta",
        sortable: true,
    },
    {
        label: "TIPO DE PAGO",
        key: "tipo_pago",
        sortable: true,
    },
    {
        label: "SALDO BS.",
        key: "saldo",
        sortable: true,
    },
    {
        label: "FECHA REGISTRO",
        key: "fecha_registro",
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
    limpiarVenta();
    muestra_formulario.value = true;
};

const updateDatatable = async () => {
    if (miTable.value) {
        await miTable.value.cargarDatos();
        limpiarVenta();
        muestra_formulario.value = false;
    }
};

const restaurarVenta = (item) => {
    Swal.fire({
        title: "¿Quierés restaurar este registro?",
        html: `<strong>${item.codigo_venta}</strong>`,
        showCancelButton: true,
        confirmButtonText: "Si, restaurar",
        cancelButtonText: "No, cancelar",
        denyButtonText: `No, cancelar`,
        customClass: {
            confirmButton: "btn-alert-success",
        },
    }).then(async (result) => {
        /* Read more about isConfirmed, isDenied below */
        if (result.isConfirmed) {
            let respuesta = await axiosPost(route("ventas.restaurar", item.id));
            if (respuesta && respuesta.sw) {
                updateDatatable();
            }
        }
    });
};

const eliminarVenta = (item) => {
    Swal.fire({
        title: "¿Quierés eliminar este registro de forma PERMANENTE?",
        html: `<h4>Esta acción no se podrá deshacer</h4><strong>${item.codigo_venta}</strong>`,
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
                route("ventas.eliminar_permanente", item.id),
            );
            if (respuesta && respuesta.sw) {
                updateDatatable();
            }
        }
    });
};
</script>
<template>
    <Head title="Ventas Eliminadas/Anuladas"></Head>
    <Content>
        <template #header>
            <div class="row">
                <div class="col-sm-6">
                    <h3 class="m-0">
                        <i class="fa fa-list-alt"></i> Ventas
                        Eliminadas/Anuladas
                    </h3>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-end">
                        <li class="breadcrumb-item">
                            <Link :href="route('inicio')">Inicio</Link>
                        </li>
                        <li class="breadcrumb-item active">
                            Ventas Eliminadas/Anuladas
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
                                    'ventas.index',
                                )
                            "
                            :href="route('ventas.index')"
                            class="btn btn-white border text-sm"
                        >
                            <i class="fa fa-arrow-left"></i> Volver
                        </Link>
                        <Link
                            v-if="
                                props_page.auth?.user.permisos == '*' ||
                                props_page.auth?.user.permisos.includes(
                                    'ventas.create',
                                )
                            "
                            :href="route('ventas.create')"
                            class="btn btn-primary text-sm ms-1"
                        >
                            <i class="fa fa-plus"></i> Nueva Venta
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
                            :url="route('ventas.paginado_eliminados')"
                            :numPages="5"
                            :multiSearch="multiSearch"
                            :syncOrderBy="'id'"
                            :syncOrderAsc="'DESC'"
                            table-responsive
                            :header-class="'bg__danger'"
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

                            <template #cliente="{ item }">
                                <span class="text-dark text-sm">{{
                                    item.cliente?.nombre
                                }}</span
                                ><br />
                                <span class="text-dark text-sm"
                                    >{{ item.cliente?.tipo_documento?.nombre }}
                                    {{ item.nit_ci }}</span
                                >
                            </template>
                            <template #total="{ item }">
                                <span class="fw-bold fs-6 badge bg-success">{{
                                    item.total
                                }}</span>
                            </template>
                            <template #user="{ item }">
                                <span class=""
                                    >{{ item.user?.nombre }}
                                    {{ item.user?.paterno }}
                                    {{ item.user?.materno }}</span
                                >
                            </template>
                            <template #accion="{ item }">
                                <template
                                    v-if="
                                        props_page.auth?.user.permisos == '*' ||
                                        props_page.auth?.user.permisos.includes(
                                            'ventas.edit',
                                        )
                                    "
                                >
                                    <el-tooltip
                                        class="box-item"
                                        effect="dark"
                                        content="Restaurar"
                                        placement="left-start"
                                    >
                                        <button
                                            class="btn btn-success"
                                            @click="restaurarVenta(item)"
                                        >
                                            <i class="fa fa-sync"></i></button
                                    ></el-tooltip>
                                </template>

                                <template
                                    v-if="
                                        props_page.auth?.user.permisos == '*' ||
                                        props_page.auth?.user.permisos.includes(
                                            'ventas.destroy',
                                        )
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
                                            @click="eliminarVenta(item)"
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
