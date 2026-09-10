<script setup>
import Content from "@/Components/Content.vue";
import MiTable from "@/Components/MiTable.vue";
import { Head, Link, router, usePage } from "@inertiajs/vue3";
import { useProformas } from "@/composables/proformas/useProformas";
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

const { setProforma, limpiarProforma, form } = useProformas();
const { axiosDelete } = useAxios();

const miTable = ref(null);
const headers = [
    {
        label: "Código",
        key: "codigo_proforma",
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
    limpiarProforma();
    muestra_formulario.value = true;
};

const updateDatatable = async () => {
    if (miTable.value) {
        await miTable.value.cargarDatos();
        limpiarProforma();
        muestra_formulario.value = false;
    }
};

const eliminarProforma = (item) => {
    Swal.fire({
        title: "¿Quierés eliminar este registro?",
        html: `<strong>${item.codigo_proforma}</strong>`,
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
                route("proformas.destroy", item.id),
            );
            if (respuesta && respuesta.sw) {
                updateDatatable();
            }
        }
    });
};
</script>
<template>
    <Head title="Proformas"></Head>
    <Content>
        <template #header>
            <div class="row">
                <div class="col-sm-6">
                    <h3 class="m-0">
                        <i class="fa fa-clipboard-list"></i> Proformas
                    </h3>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-end">
                        <li class="breadcrumb-item">
                            <Link :href="route('inicio')">Inicio</Link>
                        </li>
                        <li class="breadcrumb-item active">Proformas</li>
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
                                    'proformas.create',
                                )
                            "
                            :href="route('proformas.create')"
                            class="btn btn-primary text-sm"
                        >
                            <i class="fa fa-plus"></i> Nueva Proforma
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
                            :url="route('proformas.paginado')"
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
                                            'proformas.edit',
                                        )
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
                                                route('proformas.edit', item.id)
                                            "
                                        >
                                            <i class="fa fa-pen"></i></Link
                                    ></el-tooltip>
                                </template>

                                <template
                                    v-if="
                                        props_page.auth?.user.permisos == '*' ||
                                        props_page.auth?.user.permisos.includes(
                                            'proformas.destroy',
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
                                            @click="eliminarProforma(item)"
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
