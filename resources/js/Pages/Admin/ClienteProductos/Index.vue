<script setup>
import Content from "@/Components/Content.vue";
import MiTableSkeleton from "@/Components/MiTableSkeleton.vue";
import MiTable from "@/Components/MiTable.vue";
import { Head, Link, router, usePage } from "@inertiajs/vue3";
import { useClienteProductos } from "@/composables/cliente_productos/useClienteProductos";
import { useAxios } from "@/composables/axios/useAxios";
import { ref } from "vue";
import Formulario from "./Formulario.vue";
const props = defineProps({
    cliente: {
        type: Object,
        required: true,
    },
});
const { props: props_page } = usePage();

const { setClienteProducto, limpiarClienteProducto, form } =
    useClienteProductos();
const { axiosDelete } = useAxios();

const miTable = ref(null);
const headers = [
    {
        label: "COD.",
        key: "id",
        sortable: true,
        width: "4%",
    },
    {
        label: "PRODUCTO",
        key: "producto",
        sortable: true,
    },
    {
        label: "PRECIO ASIGNADO",
        key: "precio",
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
    limpiarClienteProducto();
    form.cliente_id = props.cliente.id;
    form.cliente = props.cliente;
    muestra_formulario.value = true;
};

const updateDatatable = async () => {
    if (miTable.value) {
        await miTable.value.cargarDatos();
        limpiarClienteProducto();
        muestra_formulario.value = false;
    }
};

const eliminarClienteProducto = (item) => {
    Swal.fire({
        title: "¿Quierés eliminar este registro?",
        html: `<strong>${item.producto.codigo} - ${item.producto.nombre}</strong>`,
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
                route("cliente_productos.destroy", item.id),
            );
            if (respuesta && respuesta.sw) {
                updateDatatable();
            }
        }
    });
};
const tablaLista = ref(false);
const tablaError = ref(false);

function tablaPreparada() {
    tablaLista.value = true;
    tablaError.value = false;
}

function tablaConError() {
    tablaError.value = true;
}
</script>
<template>
    <Head title="Precio Productos por Cliente"></Head>
    <Content>
        <template #header>
            <div class="row">
                <div class="col-sm-6">
                    <h3 class="m-0">
                        <i class="fa fa-boxes"></i> Precio Productos por Cliente
                    </h3>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-end">
                        <li class="breadcrumb-item">
                            <Link :href="route('inicio')">Inicio</Link>
                        </li>
                        <li class="breadcrumb-item">
                            <Link :href="route('clientes.index')"
                                >Clientes</Link
                            >
                        </li>
                        <li class="breadcrumb-item active">
                            Precio Productos por Cliente
                        </li>
                    </ol>
                </div>
                <!-- /.col -->
            </div>
            <!-- /.row -->
        </template>
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-4 text-end">
                                <strong>Nombre:</strong>
                            </div>
                            <div class="col-8">{{ cliente.nombre }}</div>
                        </div>
                        <div class="row">
                            <div class="col-4 text-end">
                                <strong
                                    >{{
                                        cliente.tipo_documento.nombre
                                    }}:</strong
                                >
                            </div>
                            <div class="col-8">{{ cliente.nro_documento }}</div>
                        </div>
                        <div class="row">
                            <div class="col-4 text-end">
                                <strong>Contacto:</strong>
                            </div>
                            <div class="col-8">{{ cliente.fono }}</div>
                        </div>
                        <div class="row">
                            <div class="col-4 text-end">
                                <strong>Correo:</strong>
                            </div>
                            <div class="col-8">{{ cliente.correo }}</div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-12 mt-2">
                <div class="row">
                    <div class="col-md-4">
                        <button
                            v-if="
                                props_page.auth?.user.permisos == '*' ||
                                props_page.auth?.user.permisos.includes(
                                    'cliente_productos.create',
                                )
                            "
                            type="button"
                            class="btn btn-primary text-sm"
                            @click="agregarRegistro"
                        >
                            <i class="fa fa-plus"></i> Agregar Nuevo Precio de
                            Producto
                        </button>
                    </div>
                    <div class="col-md-8 my-1">
                        <div class="row justify-content-end">
                            <div class="col-md-5">
                                <div class="input-group">
                                    <input
                                        v-model="multiSearch.search"
                                        placeholder="Buscar"
                                        class="form-control border-1 border-right-0"
                                    />
                                    <div class="input-append">
                                        <button
                                            class="btn btn-default bg-white rounded-0 border-left-0"
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
                        <div
                            v-if="!tablaLista && !tablaError"
                            class="table-loading-overlay"
                        >
                            <MiTableSkeleton
                                theme="light"
                                responsive
                                responsive-breakpoint="900px"
                                :rows="8"
                                :columns="headers.length || 5"
                                :show-toolbar="true"
                                :show-pagination="true"
                            />
                        </div>

                        <div v-if="tablaError" class="table-error-message">
                            No se pudieron cargar los registros.
                        </div>
                        <MiTable
                            v-show="tablaLista"
                            :tableClass="'bg-white mitabla'"
                            ref="miTable"
                            :cols="headers"
                            :api="true"
                            :url="
                                route('cliente_productos.paginado') +
                                '?cliente_id=' +
                                cliente.id
                            "
                            :numPages="5"
                            :multiSearch="multiSearch"
                            :syncOrderBy="'id'"
                            :syncOrderAsc="'DESC'"
                            table-responsive
                            :header-class="'bg__primary'"
                            fixed-header
                            @ready="tablaPreparada"
                            @load-error="tablaConError"
                        >
                            <template #producto="{ item }">
                                <div>
                                    {{ item.producto.codigo }} -
                                    {{ item.producto.nombre }}
                                </div>
                            </template>

                            <template #accion="{ item }">
                                <template
                                    v-if="
                                        props_page.auth?.user.permisos == '*' ||
                                        props_page.auth?.user.permisos.includes(
                                            'cliente_productos.edit',
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
                                                setClienteProducto(item);
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
                                            'cliente_productos.destroy',
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
                                                eliminarClienteProducto(item)
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
            :form="form"
            :muestra_formulario="muestra_formulario"
            @envio-formulario="updateDatatable"
            @cerrar-formulario="muestra_formulario = false"
        ></Formulario>
    </Content>
</template>
