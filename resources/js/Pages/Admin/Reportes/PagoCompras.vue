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
    cargarProveedors();
    cargarUsers();
    cargarTipoVentas();
    cargarTipoCompras();
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
    ingreso_producto_id: "",
    proveedor_id: "todos",
    user_id:
        props_page.auth.user.tipo == "EMPLEADO"
            ? props_page.auth.user.id
            : "todos",
    tipo_venta: "todos",
    tipo_pago: "todos",
    fecha_ini: getFechaAtual(),
    fecha_fin: getFechaAtual(),
    formato: "pdf",
});

const listAlmacens = ref([]);
const listProveedors = ref([]);
const listUsuarios = ref([]);
const listTipoVentas = ref([]);
const listTipoCompras = ref([]);

const generando = ref(false);
const txtBtn = computed(() => {
    if (generando.value) {
        return "Generando Reporte...";
    }
    return "Generar Reporte";
});

const generarReporte = () => {
    generando.value = true;
    const url = route("reportes.r_pago_compras", form.value);
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

const listIngresoProductos = ref([]);
const cargandoIngresoProductos = ref(false);

let temporizadorIngresoProductos = null;
let ultimaBusquedaIngresoProducto = 0;

const buscarIngresoProductos = (texto) => {
    clearTimeout(temporizadorIngresoProductos);

    const busqueda = texto?.trim() ?? "";
    const peticion = ++ultimaBusquedaIngresoProducto;

    if (busqueda.length < 2) {
        listIngresoProductos.value = [];
        cargandoIngresoProductos.value = false;
        return;
    }

    temporizadorIngresoProductos = setTimeout(async () => {
        cargandoIngresoProductos.value = true;

        try {
            const response = await axios.get(
                "/admin/ingreso_productos/buscar",
                {
                    params: { q: busqueda },
                },
            );

            // Ignorar respuestas de búsquedas anteriores.
            if (peticion === ultimaBusquedaIngresoProducto) {
                listIngresoProductos.value = response.data;
            }
        } catch (error) {
            if (peticion === ultimaBusquedaIngresoProducto) {
                listIngresoProductos.value = [];
                console.error("Error al buscar compras:", error);
            }
        } finally {
            if (peticion === ultimaBusquedaIngresoProducto) {
                cargandoIngresoProductos.value = false;
            }
        }
    }, 300);
};
const cargarProveedors = () => {
    axios.get(route("proveedors.listado")).then((response) => {
        listProveedors.value = response.data.proveedors;
        listProveedors.value.unshift({
            id: "todos",
            nombre: "TODOS",
            full_name: "TODOS",
        });
    });
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

const cargarTipoVentas = async () => {
    try {
        const res = await axios.get(route("tipo_ventas.listado"));
        listTipoVentas.value = res.data.tipo_ventas;
        listTipoVentas.value.unshift({
            value: "todos",
            label: "TODOS",
        });
    } catch (e) {
        console.log(e);
    } finally {
    }
};

const cargarTipoCompras = async () => {
    try {
        const res = await axios.get(route("tipo_compras.listado"));
        listTipoCompras.value = res.data.tipo_compras;
        listTipoCompras.value.unshift({
            value: "todos",
            label: "TODOS",
        });
    } catch (e) {
        console.log(e);
    } finally {
    }
};
</script>
<template>
    <Head title="Reporte Lista Pago de Compras"></Head>
    <Content>
        <template #header>
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h4 class="m-0">
                        <i class="fa fa-file-pdf"></i> Lista Pago de Compras
                    </h4>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-end">
                        <li class="breadcrumb-item">
                            <Link :href="route('inicio')">Inicio</Link>
                        </li>
                        <li class="breadcrumb-item active">
                            Reportes - Lista Pago de Compras
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
                                    <label>Código de Compra</label>
                                    <el-select
                                        v-model="form.ingreso_producto_id"
                                        class="el-select-input-group-left"
                                        no-data-text="Sin datos"
                                        no-match-text="Sin resultados"
                                        loading-text="Buscando..."
                                        placeholder="Escribe el código de compra"
                                        size="large"
                                        filterable
                                        remote
                                        clearable
                                        :remote-method="buscarIngresoProductos"
                                        :loading="cargandoIngresoProductos"
                                        :reserve-keyword="true"
                                    >
                                        <el-option
                                            v-for="item in listIngresoProductos"
                                            :key="item.id"
                                            :value="item.id"
                                            :label="`${item.codigo}`"
                                        />
                                    </el-select>
                                    <div
                                        class="text-xs text-muted w-100 text-center"
                                    >
                                        Para listar todos los registros dejar
                                        vacío
                                    </div>
                                </div>
                                <div class="col-md-12">
                                    <label>Seleccionar Proveedor*</label>
                                    <el-select
                                        v-model="form.proveedor_id"
                                        no-data-text="Sin datos"
                                        no-match-text="Sin resultados"
                                        filterable
                                    >
                                        <el-option
                                            v-for="item in listProveedors"
                                            :value="item.id"
                                            :label="item.nombre"
                                        >
                                        </el-option>
                                    </el-select>
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
                                <!-- <div class="col-md-12">
                                    <label>Seleccionar Tipo de Compra*</label>
                                    <el-select
                                        v-model="form.tipo_pago"
                                        no-data-text="Sin datos"
                                        no-match-text="Sin resultados"
                                        filterable
                                    >
                                        <el-option
                                            v-for="item in listTipoCompras"
                                            :value="item.value"
                                            :label="item.label"
                                        >
                                        </el-option>
                                    </el-select>
                                </div> -->
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
