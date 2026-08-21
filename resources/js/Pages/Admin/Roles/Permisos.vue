<script setup>
import Content from "@/Components/Content.vue";
import { useAppStore } from "@/stores/aplicacion/appStore";
import { Head, Link } from "@inertiajs/vue3";
import { ref, onMounted, onBeforeMount } from "vue";
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
    if (props.role.id != 2) {
        if (modulo == "Solicitud de productos") {
            if (accion == "CREAR") {
                disabled = true;
            }
        }
        if (modulo == "Orden de venta") {
            if (accion == "CREAR") {
                disabled = true;
            }
        }
    }
    return disabled;
};

const verificaPermiso = (modulo, accion) => {
    let existe = listPermisos.value[modulo].filter(
        (elem) => elem.accion == accion,
    );

    if (existe.length > 0) {
        // console.log(modulo, accion, "existe");
        return true;
    }
    // console.log(modulo, accion, "no existe");
    return false;
};

const actualizaPermiso = (e, modulo, accion) => {
    const checked = e.target.checked ? 1 : 0;
    let listPermisosBK = listPermisos.value;
    axios
        .post(route("roles.actualizaPermiso", props.role.id), {
            sw_cambio: checked,
            modulo: modulo,
            accion: accion,
        })
        .then((response) => {
            toast.success("Operación completada correctamente!");
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
                    <h1 class="m-0">
                        <i class="fa fa-list"></i> Roles y Permisos
                    </h1>
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
                    <div class="card-body">
                        <div class="row">
                            <div class="col-12">
                                <h3 class="text-dark">
                                    <span class="fw-normal"
                                        >Permisos asignados a </span
                                    >{{ props.role.nombre }}
                                </h3>
                            </div>
                            <div
                                class="col-12 fila_seccion p-0"
                                v-for="item in modulos_group"
                            >
                                <p
                                    class="font-weight-bold mb-2 nomModulo bg-principal"
                                >
                                    {{ item }}
                                </p>
                                <div class="row mb-3 px-3">
                                    <div
                                        class="col-md-3"
                                        v-for="item_permiso in props
                                            .array_modulos[item]"
                                    >
                                        <label class="check_permiso">
                                            {{ item_permiso.accion }}
                                            <input
                                                type="checkbox"
                                                :checked="
                                                    verificaPermiso(
                                                        item,
                                                        item_permiso.accion,
                                                    )
                                                "
                                                @change="
                                                    actualizaPermiso(
                                                        $event,
                                                        item,
                                                        item_permiso.accion,
                                                    )
                                                "
                                                :disabled="
                                                    verificaDisabled(
                                                        item,
                                                        item_permiso.accion,
                                                    )
                                                "
                                                verificaPermiso
                                            />
                                        </label>
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
.nomModulo {
    font-size: 1.1em;
    background-color: var(--bg6);
    color: white !important;
    padding-left: 10px;
}
.nomModulo.bg-principal {
    background-color: var(--bg3);
}
.fila_seccion {
    margin-bottom: 15px;
    box-shadow:
        0px 2px 3px black,
        2px 0px 3px black;
}

.check_permiso {
    display: flex;
    justify-content: start;
    align-items: center;
    gap: 4px;
    padding: 5px;
    cursor: pointer;
    font-size: 0.8em;
    padding: 10px;
}

.check_permiso:hover {
    background-color: beige;
}
.check_permiso input {
    cursor: pointer;
    font-size: 20px;
    height: 18px;
    width: 18px;
    margin-bottom: 3px;
}

input:disabled {
    cursor: not-allowed;
}
</style>
