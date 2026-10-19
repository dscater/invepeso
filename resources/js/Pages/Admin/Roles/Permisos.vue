<script setup>
import Content from "@/Components/Content.vue";
import { useAppStore } from "@/stores/aplicacion/appStore";
import { Head, Link } from "@inertiajs/vue3";
import { ref, onMounted, onBeforeMount, computed } from "vue";
// TOAST
import { toast } from "vue3-toastify";
import "vue3-toastify/dist/index.css";
const appStore = useAppStore();
onBeforeMount(() => {
    appStore.startLoading();
});
const props = defineProps({
    role: {
        type: Object,
        default: {
            nombre: "",
            permisos: 0,
            usuarios: 0,
        },
    },
    modulos_group: {
        type: Array,
        default: [],
    },
    array_modulos: {
        type: Object,
        default: null,
    },
    array_permisos: {
        type: Object,
        default: null,
    },
});

const listPermisos = ref(props.array_permisos);

const verificaDisabled = (modulo, accion) => {
    let disabled = false;
    if (props.role.id == 1) {
        disabled = true;
    }
    // if (props.role.id != 2) {
    //     if (modulo == "Solicitud de productos") {
    //         if (accion == "CREAR") {
    //             disabled = true;
    //         }
    //     }
    //     if (modulo == "Orden de venta") {
    //         if (accion == "CREAR") {
    //             disabled = true;
    //         }
    //     }
    // }
    return disabled;
};

const verificaPermiso = (modulo, modulo_id) => {
    let existe = listPermisos.value[modulo].filter(
        (elem) => elem.modulo_id == modulo_id,
    );

    if (existe.length > 0) {
        // console.log(modulo, accion, "existe");
        return true;
    }
    // console.log(modulo, accion, "no existe");
    return false;
};

const actualizaPermiso = (e, modulo, modulo_id) => {
    const checked = e.target.checked ? 1 : 0;
    let listPermisosBK = listPermisos.value;
    axios
        .post(route("roles.actualizaPermiso", props.role.id), {
            sw_cambio: checked,
            modulo: modulo,
            modulo_id: modulo_id,
        })
        .then((response) => {
            toast.success("Operación completada correctamente!", {
                autoClose: 200,
            });
            listPermisos.value[modulo] = response.data.array_permisos;
        })
        .catch((error) => {
            listPermisos.value[modulo] = listPermisosBK;
            toast.error(
                "No se pudo actualizar la información debido a un error, intenté mas tarde",
            );
            console.log(error);
        });
};

const filtroModulo = ref("");

const listModulosGroup = computed(() => {
    const filtro = (filtroModulo.value ?? "").toLowerCase().trim();

    if (filtro == "") return props.modulos_group;

    return props.modulos_group.filter(
        (elem) => elem.toLowerCase().trim() == filtro,
    );
});

const listModulosRole = computed(() => {
    const filtro = (filtroModulo.value ?? "").toLowerCase().trim();

    return Object.fromEntries(
        Object.entries(props.array_modulos).filter(
            ([nombreModulo, elementos]) => {
                // Buscar por el nombre del grupo
                const coincideGrupo = nombreModulo
                    .toLowerCase()
                    .includes(filtro);

                // Buscar también por nombre o acción de los elementos
                const coincideElemento = elementos.some(
                    (elem) =>
                        (elem.nombre ?? "").toLowerCase().includes(filtro) ||
                        (elem.accion ?? "").toLowerCase().includes(filtro),
                );

                return coincideGrupo || coincideElemento;
            },
        ),
    );
});
onMounted(() => {
    appStore.stopLoading();
});
</script>
<template>
    <Head title="Roles-Permisos"></Head>
    <Content>
        <template #header>
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h4 class="m-0">
                        <i class="fa fa-list"></i> Roles y Permisos
                    </h4>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-end">
                        <li class="breadcrumb-item">
                            <Link :href="route('inicio')">Inicio</Link>
                        </li>
                        <li class="breadcrumb-item">
                            <Link :href="route('roles.index')">Roles</Link>
                        </li>
                        <li class="breadcrumb-item active">Permisos</li>
                    </ol>
                </div>
                <!-- /.col -->
            </div>
            <!-- /.row -->
        </template>
        <div class="row">
            <div class="col-md-3 mb-2">
                <Link :href="route('roles.index')" class="btn btn-light">
                    <i class="fa fa-arrow-left"></i> Volver
                </Link>
            </div>
            <div class="col-12">
                <!-- BEGIN card -->
                <div class="card">
                    <!-- BEGIN card-body -->
                    <div class="card-header bg1">
                        <div class="row">
                            <div class="col-8">
                                <h3 class="text-white">
                                    <span class="fw-normal fs-5"
                                        >PERMISOS DE </span
                                    ><span class="fw-bold fs-5">{{
                                        props.role.nombre
                                    }}</span>
                                </h3>
                            </div>
                            <div class="col-4">
                                <el-select
                                    v-model="filtroModulo"
                                    placeholder="Filtrar Módulo"
                                    no-data-text="Sin datos"
                                    no-match-text="Sin resultados"
                                    filterable
                                    clearable
                                >
                                    <el-option
                                        v-for="item in modulos_group"
                                        :key="item"
                                        :value="item"
                                        :label="item"
                                    ></el-option>
                                </el-select>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div
                                class="col-md-4 mt-2"
                                v-for="item in listModulosGroup"
                            >
                                <div class="card">
                                    <div class="card-header bg-dark">
                                        <div class="row">
                                            <div class="col-12">
                                                <h4
                                                    class="text-white fs-7 text-uppercase"
                                                >
                                                    {{ item }}
                                                </h4>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card-body p-1">
                                        <div class="row">
                                            <div
                                                class="col-12"
                                                v-for="item_modulo in listModulosRole[
                                                    item
                                                ]"
                                            >
                                                <div class="list-group">
                                                    <label
                                                        class="list-group-item fs-8"
                                                        :class="{
                                                            checked:
                                                                verificaPermiso(
                                                                    item,
                                                                    item_modulo.id,
                                                                ),
                                                        }"
                                                    >
                                                        <input
                                                            type="checkbox"
                                                            class="form-check-input me-1"
                                                            :checked="
                                                                verificaPermiso(
                                                                    item,
                                                                    item_modulo.id,
                                                                )
                                                            "
                                                            @change="
                                                                actualizaPermiso(
                                                                    $event,
                                                                    item,
                                                                    item_modulo.id,
                                                                )
                                                            "
                                                            :disabled="
                                                                verificaDisabled(
                                                                    item,
                                                                    item_modulo.accion,
                                                                )
                                                            "
                                                        />
                                                        {{
                                                            item_modulo.descripcion
                                                        }}
                                                    </label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- END card-body -->
                </div>
                <!-- END card -->
            </div>
        </div>
    </Content>
</template>
<style>
input:disabled {
    cursor: not-allowed;
}

.list-group-item:hover {
    background-color: var(--bgActivo2);
}

.list-group-item.checked,
.list-group-item.checked:hover {
    background-color: var(--bgActivo2);
}

.list-group-item {
    cursor: pointer;
    border-radius: 0 !important;
}
</style>
