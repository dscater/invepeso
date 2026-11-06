<script setup>
import Content from "@/Components/Content.vue";
import MiTableSkeleton from "@/Components/MiTableSkeleton.vue";
import MiTable from "@/Components/MiTable.vue";
import { Head, Link, router, usePage } from "@inertiajs/vue3";
import { useProveedors } from "@/composables/proveedors/useProveedors";
import { useAxios } from "@/composables/axios/useAxios";
import { ref } from "vue";
import Formulario from "./Formulario.vue";
import FormularioCarga from "./FormularioCarga.vue";
const { props: props_page } = usePage();

const { setProveedor, limpiarProveedor, form } = useProveedors();
const { axiosDelete } = useAxios();

const miTable = ref(null);
const headers = [
    {
        label: "NRO.",
        key: "id",
        sortable: true,
        width: "4%",
    },
    {
        label: "NOMBRE",
        key: "nombre",
        sortable: true,
    },
    {
        label: "CONTACTO",
        key: "contacto",
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
    limpiarProveedor();
    muestra_formulario.value = true;
};

const updateDatatable = async () => {
    if (miTable.value) {
        await miTable.value.cargarDatos();
        limpiarProveedor();
        muestra_formulario.value = false;
        muestra_formulario_carga.value = false;
    }
};

const eliminarProveedor = (item) => {
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
                route("proveedors.destroy", item.id),
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
    <Head title="Proveedores"></Head>
    <Content>
        <template #header>
            <div class="row">
                <div class="col-sm-6">
                    <h3 class="m-0"><i class="fa fa-truck"></i> Proveedores</h3>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-end">
                        <li class="breadcrumb-item">
                            <Link :href="route('inicio')">Inicio</Link>
                        </li>
                        <li class="breadcrumb-item active">Proveedores</li>
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
                                    'proveedors.create',
                                )
                            "
                            type="button"
                            class="btn btn-primary text-sm"
                            @click="agregarRegistro"
                        >
                            <i class="fa fa-plus"></i> Nuevo Proveedor
                        </button>
                        <button
                            v-if="
                                props_page.auth?.user.permisos == '*' ||
                                props_page.auth?.user.permisos.includes(
                                    'clientes.cargarProveedors',
                                )
                            "
                            type="button"
                            class="btn btn-success text-sm ms-1"
                            @click="muestra_formulario_carga = true"
                        >
                            <i class="fa fa-upload"></i> Cargar Proveedores
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
                            :url="route('proveedors.paginado')"
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
                            <template #ventas="{ item }">
                                <span
                                    class="badge text-xs"
                                    :class="[
                                        item.ventas == 1
                                            ? 'bgActivo'
                                            : 'bgPrecargado',
                                    ]"
                                    >{{
                                        item.ventas == 1 ? "VENTAS" : "ALMACÉN"
                                    }}</span
                                >
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
                            <template #accion="{ item }">
                                <template
                                    v-if="
                                        props_page.auth?.user.permisos == '*' ||
                                        props_page.auth?.user.permisos.includes(
                                            'proveedors.edit',
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
                                                setProveedor(item);
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
                                            'proveedors.destroy',
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
                                            @click="eliminarProveedor(item)"
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
