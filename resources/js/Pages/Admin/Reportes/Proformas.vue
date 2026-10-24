<script setup>
import Content from "@/Components/Content.vue";
import { computed, onBeforeMount, onMounted, ref } from "vue";
import { Head, usePage, Link } from "@inertiajs/vue3";
import { useAppStore } from "@/stores/aplicacion/appStore";
const appStore = useAppStore();
const { props: props_page } = usePage();
onBeforeMount(() => {
    appStore.startLoading();
});

const cargarListas = () => {
    cargarSucursals();
    cargarUsers();
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

const getFechaAtual = () => {
    const today = new Date();
    const year = today.getFullYear();
    const month = String(today.getMonth() + 1).padStart(2, "0");
    const day = String(today.getDate()).padStart(2, "0");
    return `${year}-${month}-${day}`;
};

const form = ref({
    almacen_id: "todos",
    cliente_id: "",
    user_id:
        props_page.auth.user.tipo == "EMPLEADO"
            ? props_page.auth.user.id
            : "todos",
    fecha_ini: getFechaAtual(),
    fecha_fin: getFechaAtual(),
    formato: "pdf",
});

const listAlmacens = ref([]);
const listUsuarios = ref([]);
const listTipoProformas = ref([]);
const listTipoPagos = ref([]);

const generando = ref(false);
const txtBtn = computed(() => {
    if (generando.value) {
        return "Generando Reporte...";
    }
    return "Generar Reporte";
});

const generarReporte = () => {
    generando.value = true;
    const url = route("reportes.r_proformas", form.value);
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

const listClientes = ref([]);
const cargandoClientes = ref(false);

let temporizadorClientes = null;
let ultimaBusqueda = 0;

const buscarClientes = (texto) => {
    clearTimeout(temporizadorClientes);

    const busqueda = texto?.trim() ?? "";
    const peticion = ++ultimaBusqueda;

    if (busqueda.length < 2) {
        listClientes.value = [];
        cargandoClientes.value = false;
        return;
    }

    temporizadorClientes = setTimeout(async () => {
        cargandoClientes.value = true;

        try {
            const response = await axios.get("/admin/clientes/buscar", {
                params: { q: busqueda },
            });

            // Ignorar respuestas de búsquedas anteriores.
            if (peticion === ultimaBusqueda) {
                listClientes.value = response.data;
            }
        } catch (error) {
            if (peticion === ultimaBusqueda) {
                listClientes.value = [];
                console.error("Error al buscar clientes:", error);
            }
        } finally {
            if (peticion === ultimaBusqueda) {
                cargandoClientes.value = false;
            }
        }
    }, 300);
};
const cargarUsers = () => {
    axios.get(route("usuarios.listado")).then((response) => {
        listUsuarios.value = response.data.usuarios;
        listUsuarios.value.unshift({
            id: "todos",
            nombre: "TODOS",
            full_name: "TODOS",
        });
    });
};
</script>
<template>
    <Head title="Reporte Lista de Proformas"></Head>
    <Content>
        <template #header>
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h4 class="m-0">
                        <i class="fa fa-file-pdf"></i> Lista de Proformas
                    </h4>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-end">
                        <li class="breadcrumb-item">
                            <Link :href="route('inicio')">Inicio</Link>
                        </li>
                        <li class="breadcrumb-item active">
                            Reportes - Lista de Proformas
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
                                    <label>Cliente</label>
                                    <el-select
                                        v-model="form.cliente_id"
                                        class="el-select-input-group-left"
                                        no-data-text="Sin datos"
                                        no-match-text="Sin resultados"
                                        loading-text="Buscando..."
                                        placeholder="Escribe el nombre o documento del cliente"
                                        size="large"
                                        filterable
                                        remote
                                        clearable
                                        :remote-method="buscarClientes"
                                        :loading="cargandoClientes"
                                        :reserve-keyword="true"
                                        @change="buscarClienteProductos()"
                                    >
                                        <el-option
                                            v-for="item in listClientes"
                                            :key="item.id"
                                            :value="item.id"
                                            :label="`${item.nombre} - ${item.tipo_documento?.nombre ?? ''}: ${item.nro_documento}`"
                                        />
                                    </el-select>
                                    <div
                                        class="text-xs text-muted w-100 text-center"
                                    >
                                        Para listar todos los registros dejar
                                        vacío
                                    </div>
                                </div>
                                <div
                                    class="col-md-12"
                                    v-if="
                                        props_page.auth.user.tipo != 'EMPLEADO'
                                    "
                                >
                                    <label>Seleccionar Usuario*</label>
                                    <el-select
                                        v-model="form.user_id"
                                        no-data-text="Sin datos"
                                        no-match-text="Sin resultados"
                                        filterable
                                    >
                                        <el-option
                                            v-for="item in listUsuarios"
                                            :value="item.id"
                                            :label="item.full_name"
                                        >
                                        </el-option>
                                    </el-select>
                                </div>
                                <div class="col-md-12">
                                    <label>Rango de fechas</label>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <input
                                                type="date"
                                                v-model="form.fecha_ini"
                                                class="form-control"
                                            />
                                        </div>
                                        <div class="col-md-6">
                                            <input
                                                type="date"
                                                v-model="form.fecha_fin"
                                                class="form-control"
                                            />
                                        </div>
                                    </div>
                                    <div
                                        class="text-xs text-muted w-100 text-center"
                                    >
                                        Para listar todos los registros dejar
                                        vacío
                                    </div>
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
