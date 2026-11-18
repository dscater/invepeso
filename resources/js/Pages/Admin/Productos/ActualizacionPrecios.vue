<script setup>
import Content from "@/Components/Content.vue";
import { Head, Link, router, usePage } from "@inertiajs/vue3";
import { computed, ref } from "vue";
import Productos from "../Reportes/Productos.vue";
import { useAxios } from "@/composables/axios/useAxios";

const { axiosDelete, axiosPost } = useAxios();

const { props: props_page } = usePage();

const porcentajeMonto = ref("porcentaje");
const valor = ref(0);
const filtro = ref("todos");

const actualizaFiltro = (valor) => {
    producto_ids.value = [];
    Productos.value = [];
    filtro.value = valor;
};

const mensajeInfo = computed(() => {
    let mensaje = "";
    if (filtro.value == "todos") {
        mensaje = `Todos los productos activos en el sistema seran afectados.`;
    }

    if (filtro.value == "solo") {
        mensaje = `Solo los productos agregados en la lista seran afectados.`;
    }

    if (filtro.value == "excepto") {
        mensaje = `Todos los productos activos en el sistema seran afectados excepto aquellos que usted agregué en la lista.`;
    }

    return `<i class="fa fa-info-circle"></i> ` + mensaje;
});

const labelFiltro = computed(() => {
    if (porcentajeMonto.value == "porcentaje") {
        return `<i class="fa fa-percent"></i> Por porcentaje`;
    }

    return `<i class="fa fa-money-bill"></i> Por monto`;
});

const classFiltro = computed(() => {
    let classes = "";
    if (filtro.value == "solo") {
        classes = "bgInfo2 border-info";
    }

    if (filtro.value == "excepto") {
        classes = "bgWarning2 border-warnig";
    }

    return classes;
});

const producto_ids = ref([]);
const listProductos = ref([]);
const cargandoProductos = ref(false);
let temporizadorClientes = null;
let ultimaBusqueda = 0;

const buscarProductos = (texto) => {
    clearTimeout(temporizadorClientes);

    const busqueda = texto?.trim() ?? "";
    const peticion = ++ultimaBusqueda;

    if (busqueda.length < 2) {
        listProductos.value = [];
        cargandoProductos.value = false;
        return;
    }

    temporizadorClientes = setTimeout(async () => {
        cargandoProductos.value = true;

        try {
            const response = await axios.get(route("productos.buscar"), {
                params: { q: busqueda },
            });

            // Ignorar respuestas de búsquedas anteriores.
            if (peticion === ultimaBusqueda) {
                listProductos.value = response.data;
            }
        } catch (error) {
            if (peticion === ultimaBusqueda) {
                listProductos.value = [];
                console.error("Error al buscar productos:", error);
            }
        } finally {
            if (peticion === ultimaBusqueda) {
                cargandoProductos.value = false;
            }
        }
    }, 300);
};

const enviarFormulario = (item) => {
    Swal.fire({
        // icon: "question",
        title: "¿Quierés actualizar los precios?",
        html:
            mensajeInfo.value +
            `<br/>Por favor, verifica que los valores envíados sean correctos`,
        showCancelButton: true,
        confirmButtonText: "Si, actualizar",
        cancelButtonText: "No, cancelar",
        denyButtonText: `No, cancelar`,
        customClass: {
            confirmButton: "bgPrimary",
        },
    }).then(async (result) => {
        /* Read more about isConfirmed, isDenied below */
        if (result.isConfirmed) {
            let respuesta = await axiosPost(
                route("productos.actualizarPrecios"),
                {
                    porcentajeMonto: porcentajeMonto.value,
                    filtro: filtro.value,
                    producto_ids: producto_ids.value,
                    valor: valor.value,
                },
            );
            if (respuesta && respuesta.sw) {
                router.reload();
            }
        }
    });
};
</script>
<template>
    <Head title="Actualización de Precios"></Head>
    <Content>
        <template #header>
            <div class="row">
                <div class="col-sm-6">
                    <h3 class="m-0">
                        <i class="fa fa-sync"></i> Actualización de Precios
                    </h3>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-end">
                        <li class="breadcrumb-item">
                            <Link :href="route('inicio')">Inicio</Link>
                        </li>
                        <li class="breadcrumb-item active">
                            Actualización de Precios
                        </li>
                    </ol>
                </div>
                <!-- /.col -->
            </div>
            <!-- /.row -->
        </template>
        <div class="row">
            <div class="col-4 px-0">
                <button
                    class="btn rounded-0 w-100"
                    :class="{
                        'btn-primary': filtro == 'todos',
                        'btn-light': filtro != 'todos',
                    }"
                    @click="actualizaFiltro('todos')"
                >
                    <i class="fa fa-check-double"></i> Todos los productos
                </button>
            </div>
            <div class="col-4 px-0">
                <button
                    class="btn rounded-0 w-100"
                    :class="{
                        'btn-info': filtro == 'solo',
                        'btn-light': filtro != 'solo',
                    }"
                    @click="actualizaFiltro('solo')"
                >
                    <i class="fa fa-filter"></i> Solo estos productos
                </button>
            </div>
            <div class="col-4 px-0">
                <button
                    class="btn rounded-0 w-100"
                    :class="{
                        'btn-warning': filtro == 'excepto',
                        'btn-light': filtro != 'excepto',
                    }"
                    @click="actualizaFiltro('excepto')"
                >
                    <i class="fa fa-ban"></i> Exepto estos productos
                </button>
            </div>
            <div class="card mt-2">
                <div class="card-body">
                    <div class="row">
                        <div class="col-12">
                            <div class="input-group">
                                <input
                                    type="number"
                                    step="0.01"
                                    v-model="valor"
                                    class="form-control text-center"
                                />
                                <div class="form-control border-0 p-0">
                                    <el-select
                                        v-model="porcentajeMonto"
                                        size="large"
                                        class="el-select-input-group-right"
                                    >
                                        <template #label="{ label, value }">
                                            <span
                                                style="font-weight: bold"
                                                v-html="labelFiltro"
                                            ></span>
                                        </template>

                                        <el-option
                                            key="porcentaje"
                                            value="porcentaje"
                                        >
                                            <i class="fa fa-percent"></i>
                                            Por Porcentaje
                                        </el-option>
                                        <el-option key="monto" value="monto">
                                            <i class="fa fa-money-bill"></i>
                                            Por Monto
                                        </el-option>
                                    </el-select>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="card mt-2" :class="[classFiltro]">
                <div class="card-header p-0">
                    <div class="row mb-0">
                        <div
                            class="col-12 text-center py-2"
                            :class="{
                                'bgPrimary2 border-primary text-primary':
                                    filtro == 'todos',
                                'bgInfo2 border-info text-dark':
                                    filtro == 'solo',
                                'bgWarning2 border-warning text-dark':
                                    filtro == 'excepto',
                            }"
                            v-html="mensajeInfo"
                        ></div>
                    </div>
                </div>
                <div class="card-body" v-if="filtro != 'todos'">
                    <div class="row">
                        <div class="col-12">
                            <label class="text-md text-muted"
                                >Agregué los productos aquí</label
                            >
                            <el-select
                                v-model="producto_ids"
                                multiple
                                size="large"
                                no-data-text="Sin datos"
                                no-match-text="Sin resultados"
                                loading-text="Buscando..."
                                placeholder="Nombre o Código del Producto"
                                filterable
                                remote
                                :remote-method="buscarProductos"
                                :loading="cargandoProductos"
                                :reserve-keyword="false"
                                :class="[classFiltro]"
                            >
                                <el-option
                                    v-for="item in listProductos"
                                    :key="item.id"
                                    :value="item.id"
                                    :label="`${item.codigo} - ${item.nombre}`"
                                />
                            </el-select>
                            <label class="text-sm text-muted w-100 text-center">
                                {{ producto_ids.length }} Producto(s)
                                filtrado(s)</label
                            >
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-12 text-center mt-2">
                <button class="btn btn-primary" @click="enviarFormulario">
                    <i class="fa fa-sync"></i> Actualizar precios
                </button>
            </div>
        </div>
    </Content>
</template>
<style scoped>
.radio-group-full {
    display: flex;
    width: 100%;
}

.radio-group-full .el-radio-button {
    flex: 1;
}

.radio-group-full .el-radio-button :deep(.el-radio-button__inner) {
    width: 100%;
}

:deep(.el-select__selection .el-tag) {
    font-size: 0.86em;
    border-radius: 999px;
    font-weight: 600;
}
</style>
