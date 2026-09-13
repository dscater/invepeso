<script setup>
import Content from "@/Components/Content.vue";
import { Head, Link, usePage } from "@inertiajs/vue3";
import { useAxios } from "@/composables/axios/useAxios";
import { ref, onMounted, onBeforeMount, onBeforeUnmount } from "vue";
import { useAppStore } from "@/stores/aplicacion/appStore";
import FormularioCarga from "./FormularioCarga.vue";

// import { useMenu } from "@/composables/useMenu";
const { props: props_page } = usePage();
const appStore = useAppStore();

const muestra_formulario_carga = ref(false);
const listAlmacens = ref([]);
const listCategorias = ref([]);
const listMarcas = ref([]);
const listProductoSucursals = ref([]);
const loadingLista = ref(false);
const almacen_id = ref("todos");
const categoria_id = ref("todos");
const marca_id = ref("todos");
const nombreProducto = ref("");
const cargarProductos = async () => {
    loadingLista.value = true;
    try {
        const res = await axios.get(route("producto_sucursals.listado"), {
            params: {
                almacen_id: almacen_id.value,
                categoria_id: categoria_id.value,
                marca_id: marca_id.value,
                nombreProducto: nombreProducto.value,
            },
        });
        listProductoSucursals.value = res.data.producto_sucursals;
    } catch (e) {
        console.log(e);
    } finally {
        loadingLista.value = false;
        muestra_formulario_carga.value = false;
    }
};

const intervalNombre = ref(null);
const filtrarNombres = () => {
    intervalNombre.value ?? clearTimeout(intervalNombre.value);
    intervalNombre.value = setTimeout(() => {
        cargarProductos();
    }, 370);
};

const cargarSucursals = async () => {
    try {
        const res = await axios.get(route("almacens.listado"));
        listAlmacens.value = res.data.almacens;
        listAlmacens.value.unshift({
            id: "todos",
            nombre: "Todos los almacenes",
        });
    } catch (e) {
        console.log(e);
    } finally {
    }
};

const cargarCategorias = async () => {
    try {
        const res = await axios.get(route("categorias.listado"));
        listCategorias.value = res.data.categorias;
        listCategorias.value.unshift({
            id: "todos",
            nombre: "Todas las Categorías",
        });
    } catch (e) {
        console.log(e);
    } finally {
    }
};

const cargarMarcas = async () => {
    try {
        const res = await axios.get(route("marcas.listado"));
        listMarcas.value = res.data.marcas;
        listMarcas.value.unshift({
            id: "todos",
            nombre: "Todas las Marcas",
        });
    } catch (e) {
        console.log(e);
    } finally {
    }
};

onBeforeMount(async () => {
    appStore.startLoading();

    try {
        await Promise.all([
            cargarProductos(),
            cargarSucursals(),
            cargarCategorias(),
            cargarMarcas(),
        ]);
    } finally {
        appStore.stopLoading();
    }
});

onBeforeUnmount(() => {
    intervalNombre.value ?? clearTimeout(intervalNombre.value);
});

onMounted(() => {
    // appStore.stopLoading();
});
const { axiosDelete } = useAxios();
</script>
<template>
    <Head title="Stock de Inventario"></Head>
    <Content>
        <template #header>
            <div class="row">
                <div class="col-sm-6">
                    <h3 class="m-0">
                        <i class="fa fa-boxes"></i> Stock de Inventario
                    </h3>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-end">
                        <li class="breadcrumb-item">
                            <Link :href="route('inicio')">Inicio</Link>
                        </li>
                        <li class="breadcrumb-item active">
                            Stock de Inventario
                        </li>
                    </ol>
                </div>
                <!-- /.col -->
            </div>
            <!-- /.row -->
        </template>
        <div class="row">
            <div class="col-12">
                <div class="row">
                    <div class="col-12">
                        <button
                            v-if="
                                props_page.auth?.user.permisos == '*' ||
                                props_page.auth?.user.permisos.includes(
                                    'producto_sucursals.cargaProductoSucursals',
                                )
                            "
                            type="button"
                            class="btn btn-success text-sm ms-1e"
                            @click="muestra_formulario_carga = true"
                        >
                            <i class="fa fa-upload"></i> Cargar Stock de
                            Productos
                        </button>
                    </div>
                    <div class="col-12 fs-7">Filtrar por:</div>
                    <div class="col-12">
                        <div class="row">
                            <div class="col-lg-3 col-md-4 col-sm-6 mt-1">
                                <el-select
                                    v-model="almacen_id"
                                    placeholder="Almacén"
                                    no-data-text="Sin Datos"
                                    no-match-text="Sin Resultados"
                                    filterable
                                    @change="cargarProductos"
                                >
                                    <el-option
                                        v-for="item in listAlmacens"
                                        :key="item.id"
                                        :value="item.id"
                                        :label="`${item.nombre} ${item.sucursal ? ' - ' + item.sucursal.nombre : ''}`"
                                    ></el-option>
                                </el-select>
                            </div>
                            <div class="col-lg-2 col-md-4 col-sm-6 mt-1">
                                <el-select
                                    v-model="categoria_id"
                                    no-data-text="Sin Datos"
                                    no-match-text="Sin Resultados"
                                    filterable
                                    @change="cargarProductos"
                                >
                                    <el-option
                                        v-for="item in listCategorias"
                                        :key="item.id"
                                        :value="item.id"
                                        :label="item.nombre"
                                    ></el-option>
                                </el-select>
                            </div>
                            <div class="col-lg-2 col-md-4 col-sm-6 mt-1">
                                <el-select
                                    v-model="marca_id"
                                    no-data-text="Sin Datos"
                                    no-match-text="Sin Resultados"
                                    filterable
                                    @change="cargarProductos"
                                >
                                    <el-option
                                        v-for="item in listMarcas"
                                        :key="item.id"
                                        :value="item.id"
                                        :label="item.nombre"
                                    ></el-option>
                                </el-select>
                            </div>
                            <div class="col-lg-2 col-md-4 col-sm-6 mt-1">
                                <input
                                    type="text"
                                    class="form-control"
                                    placeholder="Producto"
                                    v-model="nombreProducto"
                                    @keyup="filtrarNombres"
                                />
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12 text-center" v-if="loadingLista">
                        <div class="text-muted fw-bold fs-3">Cargando...</div>
                    </div>
                    <div
                        class="col-md-3 col-lg-2 col-sm-6"
                        v-for="item in listProductoSucursals"
                        :key="item.id"
                    >
                        <div class="card mt-2">
                            <div class="card-header p-0">
                                <div class="imagen_producto">
                                    <img
                                        :src="
                                            props_page.url_app +
                                            '/imgs/productos/' +
                                            (item.imagen ?? 'default.png')
                                        "
                                        alt=""
                                    />
                                </div>
                            </div>
                            <div class="card-body py-2">
                                <div class="row">
                                    <div class="col-12">
                                        <span class="fw-bold h6">
                                            {{ item.nombre }}
                                        </span>
                                    </div>
                                    <div class="col-12 border-top">
                                        <div class="row">
                                            <div class="col-6 py-1">
                                                <div
                                                    class="text-center text-xxs text-muted"
                                                >
                                                    <div>
                                                        {{
                                                            item.categoria
                                                                .nombre
                                                        }}
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-6 py-1">
                                                <div
                                                    class="text-center text-xxs text-muted"
                                                >
                                                    <div>
                                                        {{ item.marca.nombre }}
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-12 border-top">
                                        <div class="row">
                                            <div class="col-8 text-center py-2">
                                                <div class="fw-bold fs-4">
                                                    {{ item.stock_total }}
                                                </div>
                                                <div class="fs-7 fw-bold">
                                                    DISPONIBLES
                                                </div>
                                            </div>
                                            <div
                                                class="col-4 border-start py-3 text-xs text-center"
                                            >
                                                <div>Mín.</div>
                                                <div>
                                                    {{ item.stock_min }}
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <FormularioCarga
            v-if="muestra_formulario_carga"
            :muestra_formulario="muestra_formulario_carga"
            :almacens="listAlmacens"
            @envio-formulario="cargarProductos"
            @cerrar-formulario="muestra_formulario_carga = false"
        ></FormularioCarga>
    </Content>
</template>
<style scoped></style>
