<script setup>
import Content from "@/Components/Content.vue";
import MiTable from "@/Components/MiTable.vue";
import { Head, Link, router, usePage } from "@inertiajs/vue3";
import { useProductos } from "@/composables/productos/useProductos";
import { useAxios } from "@/composables/axios/useAxios";
import { ref, onMounted, onBeforeMount } from "vue";
import { useAppStore } from "@/stores/aplicacion/appStore";
// import { useMenu } from "@/composables/useMenu";
import Formulario from "./Formulario.vue";
import FormularioCarga from "./FormularioCarga.vue";
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

const { setProducto, limpiarProducto, form } = useProductos();
const { axiosDelete } = useAxios();

const miTable = ref(null);
const headers = [
    {
        label: "CÓDIGO",
        key: "codigo",
        sortable: true,
    },
    {
        label: "NOMBRE",
        key: "nombre",
        sortable: true,
    },
    {
        label: "CATEGORÍA",
        key: "categoria.nombre",
        sortable: true,
    },
    {
        label: "MARCA",
        key: "marca.nombre",
        sortable: true,
    },
    {
        label: "UNIDAD MEDIDA",
        key: "unidad_medida.nombre",
        sortable: true,
    },
    {
        label: "PRECIO VENTA BS.",
        key: "precio",
        sortable: true,
    },
    {
        label: "PRECIO COMPRA BS.",
        key: "precio_compra",
        sortable: true,
    },
    {
        label: "STOCK MÍNIMO",
        key: "stock_min",
        sortable: true,
    },
    {
        label: "IMAGEN",
        key: "imagen",
        sortable: true,
    },
    {
        label: "ACTIVO",
        key: "activo",
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
const muestra_formulario_carga = ref(false);

const agregarRegistro = () => {
    limpiarProducto();
    muestra_formulario.value = true;
};

const updateDatatable = async () => {
    if (miTable.value) {
        await miTable.value.cargarDatos();
        limpiarProducto();
        muestra_formulario.value = false;
        muestra_formulario_carga.value = false;
    }
};

const eliminarProducto = (item) => {
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
                route("productos.destroy", item.id),
            );
            if (respuesta && respuesta.sw) {
                updateDatatable();
            }
        }
    });
};
</script>
<template>
    <Head title="Lista de Productos"></Head>
    <Content>
        <template #header>
            <div class="row">
                <div class="col-sm-6">
                    <h3 class="m-0">
                        <i class="fa fa-clipboard-list"></i> Lista de Productos
                    </h3>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-end">
                        <li class="breadcrumb-item">
                            <Link :href="route('inicio')">Inicio</Link>
                        </li>
                        <li class="breadcrumb-item active">
                            Lista de Productos
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
                        <button
                            v-if="
                                props_page.auth?.user.permisos == '*' ||
                                props_page.auth?.user.permisos.includes(
                                    'productos.create',
                                )
                            "
                            type="button"
                            class="btn btn-primary text-sm"
                            @click="agregarRegistro"
                        >
                            <i class="fa fa-plus"></i> Nuevo Producto
                        </button>
                        <button
                            v-if="
                                props_page.auth?.user.permisos == '*' ||
                                props_page.auth?.user.permisos.includes(
                                    'productos.cargarProductos',
                                )
                            "
                            type="button"
                            class="btn btn-success text-sm ms-1"
                            @click="muestra_formulario_carga = true"
                        >
                            <i class="fa fa-upload"></i> Cargar Productos
                        </button>
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
                            :url="route('productos.paginado')"
                            :numPages="5"
                            :multiSearch="multiSearch"
                            :syncOrderBy="'id'"
                            :syncOrderAsc="'DESC'"
                            table-responsive
                            :header-class="'bg__primary'"
                            fixed-header
                        >
                            <template #precio="{ item }">
                                <div class="fw-bold">Bs. {{ item.precio }}</div>
                                <div class="fw-bolder" v-if="item.precio2">
                                    Bs. {{ item.precio2 }}
                                </div>
                                <div class="fw-bolder" v-if="item.precio3">
                                    Bs. {{ item.precio3 }}
                                </div>
                                <div class="fw-bolder" v-if="item.precio4">
                                    Bs. {{ item.precio4 }}
                                </div>
                            </template>
                            <template #activo="{ item }">
                                <span
                                    class="badge text-xs"
                                    :class="[
                                        item.activo == 1
                                            ? 'bgActivo'
                                            : 'bgInactivo',
                                    ]"
                                    >{{
                                        item.activo == 1 ? "ACTIVO" : "INACTIVO"
                                    }}</span
                                >
                            </template>
                            <template #imagen="{ item }">
                                <img
                                    class=""
                                    height="50px"
                                    :src="item.url_imagen"
                                    alt="Imagen"
                                />
                            </template>
                            <template #accion="{ item }">
                                <template
                                    v-if="
                                        props_page.auth?.user.permisos == '*' ||
                                        props_page.auth?.user.permisos.includes(
                                            'productos.edit',
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
                                                setProducto(item);
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
                                            'productos.destroy',
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
                                            @click="eliminarProducto(item)"
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
        <FormularioCarga
            v-if="muestra_formulario_carga"
            :muestra_formulario="muestra_formulario_carga"
            @envio-formulario="updateDatatable"
            @cerrar-formulario="muestra_formulario_carga = false"
        ></FormularioCarga>
    </Content>
</template>
