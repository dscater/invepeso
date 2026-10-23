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
    cargarSucursals();
    cargarCategorias();
    cargarMarcas();
    cargarUnidadMedidas();
};

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
    almacen_id: "todos",
    categoria_id: "todos",
    marca_id: "todos",
    unidad_medida_id: "todos",
    formato: "pdf",
});

const listAlmacens = ref([]);
const listCategorias = ref([]);
const listMarcas = ref([]);
const listUnidadMedidas = ref([]);

const generando = ref(false);
const txtBtn = computed(() => {
    if (generando.value) {
        return "Generando Reporte...";
    }
    return "Generar Reporte";
});

const generarReporte = () => {
    generando.value = true;
    const url = route("reportes.r_stock_productos", form.value);
    window.open(url, "_blank");
    setTimeout(() => {
        generando.value = false;
    }, 500);
};

const cargarSucursals = async () => {
    try {
        const res = await axios.get(route("almacens.listado"));
        listAlmacens.value = res.data.almacens;
        listAlmacens.value.unshift({
            id: "todos",
            nombre: "TODOS",
        });
    } catch (e) {
        console.log(e);
    } finally {
    }
};

const cargarCategorias = () => {
    axios.get(route("categorias.listado")).then((response) => {
        listCategorias.value = response.data.categorias;
        listCategorias.value.unshift({
            id: "todos",
            nombre: "TODOS",
        });
    });
};

const cargarMarcas = () => {
    axios.get(route("marcas.listado")).then((response) => {
        listMarcas.value = response.data.marcas;
        listMarcas.value.unshift({
            id: "todos",
            nombre: "TODOS",
        });
    });
};

const cargarUnidadMedidas = () => {
    axios.get(route("unidad_medidas.listado")).then((response) => {
        listUnidadMedidas.value = response.data.unidad_medidas;
        listUnidadMedidas.value.unshift({
            id: "todos",
            nombre: "TODOS",
        });
    });
};
</script>
<template>
    <Head title="Reporte Stock de Productos"></Head>
    <Content>
        <template #header>
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h4 class="m-0">
                        <i class="fa fa-file-pdf"></i> Stock de Productos
                    </h4>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-end">
                        <li class="breadcrumb-item">
                            <Link :href="route('inicio')">Inicio</Link>
                        </li>
                        <li class="breadcrumb-item active">
                            Reportes - Stock de Productos
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
                                    <label>Seleccionar Almacén*</label>
                                    <el-select
                                        v-model="form.almacen_id"
                                        no-data-text="Sin datos"
                                        no-match-text="Sin resultados"
                                        filterable
                                    >
                                        <el-option
                                            v-for="item in listAlmacens"
                                            :value="item.id"
                                            :label="`${item.nombre} ${item.sucursal ? ' - ' + item.sucursal.nombre : ''}`"
                                        >
                                        </el-option>
                                    </el-select>
                                </div>
                                <div class="col-md-12">
                                    <label>Seleccionar Categoría*</label>
                                    <el-select
                                        v-model="form.categoria_id"
                                        no-data-text="Sin datos"
                                        no-match-text="Sin resultados"
                                        filterable
                                    >
                                        <el-option
                                            v-for="item in listCategorias"
                                            :value="item.id"
                                            :label="item.nombre"
                                        >
                                        </el-option>
                                    </el-select>
                                </div>
                                <div class="col-md-12">
                                    <label>Seleccionar Marca*</label>
                                    <el-select
                                        v-model="form.marca_id"
                                        no-data-text="Sin datos"
                                        no-match-text="Sin resultados"
                                        filterable
                                    >
                                        <el-option
                                            v-for="item in listMarcas"
                                            :value="item.id"
                                            :label="item.nombre"
                                        >
                                        </el-option>
                                    </el-select>
                                </div>
                                <div class="col-md-12">
                                    <label>Seleccionar Unidad de Medida*</label>
                                    <el-select
                                        v-model="form.unidad_medida_id"
                                        no-data-text="Sin datos"
                                        no-match-text="Sin resultados"
                                        filterable
                                    >
                                        <el-option
                                            v-for="item in listUnidadMedidas"
                                            :value="item.id"
                                            :label="item.nombre"
                                        >
                                        </el-option>
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
