<script setup>
import Content from "@/Components/Content.vue";
import MiTable from "@/Components/MiTable.vue";
import { Head, Link, router, usePage } from "@inertiajs/vue3";
import { useIngresoProductos } from "@/composables/ingreso_productos/useIngresoProductos";
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

const { setIngresoProducto, limpiarIngresoProducto, form } =
    useIngresoProductos();
const { axiosDelete } = useAxios();

const miTable = ref(null);
const headers = [
    {
        label: "CÓDIGO",
        key: "codigo",
        sortable: true,
        width: "4%",
    },
    {
        label: "ALMACÉN-SUCURSAL",
        key: "ubicacion",
        sortable: true,
    },
    {
        label: "PROVEEDOR",
        key: "proveedor.nombre",
        sortable: true,
    },
    {
        label: "TIPO DE INGRESO",
        key: "tipo_ingreso.nombre",
        sortable: true,
    },
    {
        label: "TOTAL BS.",
        key: "total",
        sortable: true,
    },
    {
        label: "SALDO BS.",
        key: "saldo",
        sortable: true,
    },
    {
        label: "ESTADO",
        key: "estado",
        sortable: true,
    },
    {
        label: "FECHA REGISTRO",
        key: "fecha_registro",
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
    limpiarIngresoProducto();
    muestra_formulario.value = true;
};

const updateDatatable = async () => {
    if (miTable.value) {
        await miTable.value.cargarDatos();
        limpiarIngresoProducto();
        muestra_formulario.value = false;
    }
};

const eliminarIngresoProducto = (item) => {
    Swal.fire({
        title: "¿Quierés eliminar este registro?",
        html: `<strong>${item.nombre}</strong>`,
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
                route("ingreso_productos.destroy", item.id),
            );
            if (respuesta && respuesta.sw) {
                updateDatatable();
            }
        }
    });
};
</script>
<template>
    <Head title="Historial de Compras"></Head>
    <Content>
        <template #header>
            <div class="row">
                <div class="col-sm-6">
                    <h3 class="m-0">
                        <i class="fa fa-boxes"></i> Historial de Compras
                    </h3>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-end">
                        <li class="breadcrumb-item">
                            <Link :href="route('inicio')">Inicio</Link>
                        </li>
                        <li class="breadcrumb-item active">
                            Historial de Compras
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
                                    'ingreso_productos.create',
                                )
                            "
                            :href="route('ingreso_productos.create')"
                            class="btn btn-primary text-sm"
                        >
                            <i class="fa fa-plus"></i> Nueva Compra
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
                            :url="route('ingreso_productos.paginado')"
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
                            <template #total="{ item }">
                                <span class="badge text-sm bg-success">{{
                                    item.total
                                }}</span>
                            </template>
                            <template #saldo="{ item }">
                                <span class="badge text-sm bg-danger">{{
                                    item.saldo
                                }}</span>
                            </template>
                            <template #estado="{ item }">
                                <span class="text-sm">{{
                                    item.estado_ingreso
                                }}</span>
                            </template>
                            <template #accion="{ item }">
                                <template
                                    v-if="
                                        item.estado_ingreso == 'VERIFICADO' &&
                                        (props_page.auth?.user.permisos ==
                                            '*' ||
                                            props_page.auth?.user.permisos.includes(
                                                'ingreso_productos.index',
                                            ))
                                    "
                                >
                                    <el-tooltip
                                        class="box-item"
                                        effect="dark"
                                        content="Recepción de Productos"
                                        placement="left-start"
                                    >
                                        <a
                                            class="btn btn-info"
                                            :href="
                                                route(
                                                    'ingreso_productos.verificar_pdf',
                                                    item.id,
                                                )
                                            "
                                            target="_blank"
                                        >
                                            <i class="fa fa-file-pdf"></i></a
                                    ></el-tooltip>
                                </template>
                                <template
                                    v-if="
                                        props_page.auth?.user.permisos == '*' ||
                                        props_page.auth?.user.permisos.includes(
                                            'ingreso_productos.index',
                                        )
                                    "
                                >
                                    <el-tooltip
                                        class="box-item"
                                        effect="dark"
                                        content="Orden de Pdf"
                                        placement="left-start"
                                    >
                                        <a
                                            class="btn btn-primary"
                                            :href="
                                                route(
                                                    'ingreso_productos.pdf',
                                                    item.id,
                                                )
                                            "
                                            target="_blank"
                                        >
                                            <i class="fa fa-file-pdf"></i></a
                                    ></el-tooltip>
                                </template>
                                <template
                                    v-if="
                                        props_page.auth?.user.permisos == '*' ||
                                        props_page.auth?.user.permisos.includes(
                                            'ingreso_productos.edit',
                                        )
                                    "
                                >
                                    <el-tooltip
                                        class="box-item"
                                        effect="dark"
                                        content="Editar"
                                        placement="left-start"
                                    >
                                        <button
                                            class="btn btn-warning"
                                            @click="
                                                setIngresoProducto(item);
                                                muestra_formulario = true;
                                            "
                                        >
                                            <i class="fa fa-pen"></i></button
                                    ></el-tooltip>
                                </template>

                                <template
                                    v-if="
                                        props_page.auth?.user.permisos == '*' ||
                                        props_page.auth?.user.permisos.includes(
                                            'ingreso_productos.destroy',
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
                                            @click="
                                                eliminarIngresoProducto(item)
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
