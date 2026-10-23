<script setup>
import Content from "@/Components/Content.vue";
import { computed, onBeforeMount, onMounted, ref } from "vue";
import { Head, usePage, Link } from "@inertiajs/vue3";
import { useAppStore } from "@/stores/aplicacion/appStore";
const appStore = useAppStore();

onBeforeMount(() => {
    appStore.startLoading();
});

const cargarListas = () => {
    cargarTipos();
    cargarRoles();
    cargarSucursals();
};

const listRoles = ref([]);
const listSucursals = ref([]);

onMounted(() => {
    cargarListas();
    appStore.stopLoading();
});

const listFormatos = ref([
    {
        icon: "fa fa-file-pdf",
        value: "pdf",
        label: "PDF",
    },
    {
        icon: "fa fa-file-excel",
        value: "excel",
        label: "EXCEL",
    },
]);

const form = ref({
    tipo: "todos",
    role_id: "todos",
    sucursal_id: "todos",
    formato: "pdf",
});

const generando = ref(false);
const txtBtn = computed(() => {
    if (generando.value) {
        return "Generando Reporte...";
    }
    return "Generar Reporte";
});

const listTipos = ref([]);

const generarReporte = () => {
    generando.value = true;
    const url = route("reportes.r_usuarios", form.value);
    window.open(url, "_blank");
    setTimeout(() => {
        generando.value = false;
    }, 500);
};
const cargarRoles = () => {
    axios.get(route("roles.listado")).then((response) => {
        listRoles.value = response.data.roles;
        listRoles.value.unshift({
            id: "todos",
            nombre: "TODOS",
        });
    });
};
const cargarSucursals = () => {
    axios
        .get(route("sucursals.listado"), {
            params: { activo: 1 },
        })
        .then((response) => {
            listSucursals.value = response.data.sucursals;
            listSucursals.value.unshift({
                id: "todos",
                nombre: "TODOS",
            });
        });
};

const cargarTipos = () => {
    axios.get(route("tipo_usuarios.listado")).then((response) => {
        listTipos.value = response.data;
        listTipos.value.unshift({
            value: "todos",
            label: "TODOS",
        });
    });
};
</script>
<template>
    <Head title="Reporte Usuarios"></Head>
    <Content>
        <template #header>
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h4 class="m-0">
                        <i class="fa fa-file-pdf"></i> Lista de Usuarios
                    </h4>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-end">
                        <li class="breadcrumb-item">
                            <Link :href="route('inicio')">Inicio</Link>
                        </li>
                        <li class="breadcrumb-item active">
                            Reportes - Usuarios
                        </li>
                    </ol>
                </div>
                <!-- /.col -->
            </div>
            <!-- /.row -->
        </template>
        <div class="row">
            <div class="col-md-6 mx-auto">
                <div class="card">
                    <div class="card-body">
                        <form @submit.prevent="generarReporte">
                            <div class="row">
                                <div class="col-md-12">
                                    <label>Seleccionar Role*</label>
                                    <el-select
                                        v-model="form.role_id"
                                        no-data-text="Sin datos"
                                        no-match-text="Sin resultados"
                                        filterable
                                    >
                                        <el-option
                                            v-for="item in listRoles"
                                            :value="item.id"
                                            :label="item.nombre"
                                        >
                                        </el-option>
                                    </el-select>
                                </div>
                                <div class="col-md-12">
                                    <label>Seleccionar Tipo de Usuario*</label>
                                    <select
                                        v-model="form.tipo"
                                        class="form-control"
                                    >
                                        <option
                                            v-for="item in listTipos"
                                            :value="item.value"
                                        >
                                            {{ item.label }}
                                        </option>
                                    </select>
                                </div>
                                <div class="col-md-12">
                                    <label>Seleccionar Sucursal*</label>
                                    <el-select
                                        v-model="form.sucursal_id"
                                        no-data-text="Sin datos"
                                        no-match-text="Sin resultados"
                                        filterable
                                    >
                                        <el-option
                                            v-for="item in listSucursals"
                                            :value="item.id"
                                            :label="item.nombre"
                                        ></el-option>
                                    </el-select>
                                </div>
                                <div class="col-md-12 text-center mt-2">
                                    <el-radio-group v-model="form.formato">
                                        <el-radio
                                            v-for="item in listFormatos"
                                            :value="item.value"
                                            size="large"
                                            ><i :class="item.icon"></i>
                                            {{ item.label }}</el-radio
                                        >
                                    </el-radio-group>
                                </div>
                                <div class="col-md-12 text-center mt-3">
                                    <button
                                        class="btn btn-primary"
                                        block
                                        @click="generarReporte"
                                        :disabled="generando"
                                        v-text="txtBtn"
                                    ></button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </Content>
</template>
