<script setup>
import Content from "@/Components/Content.vue";
import MiTable from "@/Components/MiTable.vue";
import { Head, Link, router, usePage } from "@inertiajs/vue3";
import { useAxios } from "@/composables/axios/useAxios";
import { ref, onMounted, onBeforeMount } from "vue";
import { useAppStore } from "@/stores/aplicacion/appStore";
const { props: props_page } = usePage();
const appStore = useAppStore();
onBeforeMount(() => {
    appStore.startLoading();
});

onMounted(() => {
    appStore.stopLoading();
});

const { axiosDelete } = useAxios();

const miTable = ref(null);
const headers = [
    {
        label: "COD.",
        key: "notificacion_id",
        sortable: true,
        width: "4%",
    },
    {
        label: "DESCRIPCIÓN",
        key: "notificacion.descripcion",
        sortable: true,
    },
    {
        label: "TIPO",
        key: "notificacion.tipo",
        sortable: true,
    },
    {
        label: "VISTO",
        key: "visto",
        sortable: true,
    },
    {
        label: "FECHA",
        key: "fecha",
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

const accion_formulario = ref(0);
const muestra_formulario = ref(false);
</script>
<template>
    <Head title="Notificaciones"></Head>
    <Content>
        <template #header>
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h4 class="m-0">
                        <i class="fa fa-bell"></i> Notificaciones
                    </h4>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-end">
                        <li class="breadcrumb-item">
                            <Link :href="route('inicio')">Inicio</Link>
                        </li>
                        <li class="breadcrumb-item active">Notificaciones</li>
                    </ol>
                </div>
                <!-- /.col -->
            </div>
            <!-- /.row -->
        </template>
        <div class="row">
            <div class="col-md-12">
                <div class="row">
                    <div class="col-md-4"></div>
                    <div class="col-md-8 my-1">
                        <div class="row justify-content-end">
                            <div class="col-md-5">
                                <div
                                    class="input-group"
                                    style="align-items: end"
                                >
                                    <input
                                        v-model="multiSearch.search"
                                        placeholder="Buscar"
                                        class="form-control border-1 border-right-0"
                                    />
                                    <div class="input-append">
                                        <button
                                            class="btn btn-default rounded-0 border-left-0"
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
                            :url="route('notificacion_users.paginado')"
                            :numPages="5"
                            :multiSearch="multiSearch"
                            :syncOrderBy="'id'"
                            :syncOrderAsc="'DESC'"
                            table-responsive
                            :header-class="'bg__primary'"
                            fixed-header
                        >
                            <template #fecha="{ item }">
                                <span
                                    >{{ item.notificacion.fecha_t }}
                                    {{ item.notificacion.hora }}
                                </span>
                            </template>
                            <template #visto="{ item }">
                                <span
                                    class="text-md"
                                    :class="
                                        item.visto == 1
                                            ? 'badge bg-success'
                                            : 'badge bg-danger'
                                    "
                                >
                                    {{ item.visto == 1 ? "VISTO" : "SIN VER" }}
                                </span>
                            </template>
                            <template #accion="{ item }">
                                <template
                                    v-if="
                                        props_page.auth?.user.permisos == '*' ||
                                        props_page.auth?.user.permisos.includes(
                                            'notificacion_users.index',
                                        )
                                    "
                                >
                                    <el-tooltip
                                        class="box-item"
                                        effect="dark"
                                        content="Ver"
                                        placement="left-start"
                                    >
                                        <Link
                                            class="btn btn-primary"
                                            :href="
                                                item.notificacion.url +
                                                '?notificacion_user_id=' +
                                                item.id
                                            "
                                        >
                                            <i class="fa fa-eye"></i></Link
                                    ></el-tooltip>
                                </template>
                            </template>
                        </MiTable>
                    </div>
                </div>
            </div>
        </div>
    </Content>
</template>
