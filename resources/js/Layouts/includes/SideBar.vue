<script setup>
import { onMounted, onUnmounted, ref, nextTick, reactive } from "vue";
import { router, usePage, Link } from "@inertiajs/vue3";
import ItemMenu from "@/Components/ItemMenu.vue";
import { useSideBar } from "@/composables/useSidebar.js";
import { useAppStore } from "@/stores/aplicacion/appStore";
import { useConfiguracionStore } from "@/stores/configuracion/configuracionStore";
const { closeSidebar, toggleSubMenuELem } = useSideBar();
const { auth } = usePage().props;
const configuracionStore = useConfiguracionStore();
const appStore = useAppStore();
const usuario = ref(null);
const permisos = ref([]);
const route_current = ref("");

const toggleSubMenu = (menu) => {
    openMenus[menu] = !openMenus[menu];
};

const sincronizarMenus = () => {
    Object.keys(openMenus).forEach((key) => {
        openMenus[key] = false;
    });

    if (
        route_current.value == "usuarios.index" ||
        route_current.value == "roles.index"
    ) {
        openMenus.usuarios = true;
    }

    if (
        route_current.value == "productos.index" ||
        route_current.value == "categorias.index" ||
        route_current.value == "marcas.index" ||
        route_current.value == "unidad_medidas.index"
    ) {
        openMenus.productos = true;
    }

    if (
        route_current.value == "producto_sucursals.index" ||
        route_current.value == "ingreso_productos.index" ||
        route_current.value == "salida_productos.index" ||
        route_current.value == "ingreso_productos.create" ||
        route_current.value == "ingreso_productos.edit" ||
        route_current.value == "salida_productos.create" ||
        route_current.value == "salida_productos.edit"
    ) {
        openMenus.producto_sucursals = true;
    }

    if (
        route_current.value == "reportes.usuarios" ||
        route_current.value == "reportes.casos_epidemiologicos" ||
        route_current.value == "reportes.alerta_epidemiologicas" ||
        route_current.value == "reportes.seguimientos"
    ) {
        openMenus.reportes = true;
    }
};

const openMenus = reactive({
    usuarios: false,
    enfermedads: false,
    reportes: false,
});

router.on("navigate", (event) => {
    route_current.value = route().current();
    sincronizarMenus();
    closeSidebar();
});

onMounted(() => {
    usuario.value = appStore.getUsuario;
    permisos.value = auth.user.permisos;
    route_current.value = route().current();
    sincronizarMenus();
});

const salir = () => {
    Swal.fire({
        icon: "question",
        title: "Cerrar sesión",
        html: `¿Esta seguro(a) de cerrar sesión?`,
        showCancelButton: true,
        confirmButtonText: "Si, salir",
        cancelButtonText: "Cancelar",
        denyButtonText: `Cancelar`,
        customClass: {
            confirmButton: "btn-success",
        },
    }).then(async (result) => {
        /* Read more about isConfirmed, isDenied below */
        if (result.isConfirmed) {
            axios
                .post(route("logout"))
                .then((response) => {})
                .finally(() => {
                    window.location.href = "/";
                });
        }
    });
};

onUnmounted(() => {});
</script>
<template>
    <!-- Main Sidebar Container -->
    <aside class="app-sidebar shadow bgWhite">
        <!-- Brand Logo -->
        <div class="sidebar-brand bg1">
            <a
                :href="route('inicio')"
                class="brand-link d-flex justify-content-center align-items-center py-0"
            >
                <img
                    :src="configuracionStore.oConfiguracion.url_logo"
                    alt="Logo"
                    class="rounded-circle"
                    style="max-height: 51px"
                />
                <span class="brand-text font-weight-600 ml-1 text-white">{{
                    configuracionStore.oConfiguracion.nombre_sistema
                }}</span>
            </a>
        </div>
        <!-- Sidebar -->
        <div class="sidebar-wrapper">
            <!-- Sidebar user panel (optional) -->
            <div class="user-panel mt-3 pb-2 d-flex border-bottom">
                <div class="image">
                    <img
                        :src="usuario?.url_foto"
                        class="rounded-circle elevation-2 user-image"
                        alt="User Image"
                    />
                </div>
                <div class="info">
                    <Link
                        :href="route('profile.edit')"
                        class="d-block text-decoration-none"
                    >
                        <div class="nombre">
                            {{ usuario?.nombre }} {{ usuario?.paterno }}
                            {{ usuario?.materno }}
                        </div>
                        <div class="tipo">{{ usuario?.role.nombre }}</div>
                    </Link>
                </div>
            </div>

            <!-- Sidebar Menu -->
            <nav class="mt-2">
                <ul
                    class="nav sidebar-menu flex-column"
                    data-lte-toggle="treeview"
                    role="navigation"
                    aria-label="Main navigation"
                    data-accordion="false"
                    id="navigation"
                >
                    <ItemMenu
                        :label="'Inicio'"
                        :ruta="'inicio'"
                        :icon="'fa fa-home'"
                    ></ItemMenu>
                    <li
                        class="nav-header font-weight-bold"
                        v-if="
                            permisos == '*' ||
                            permisos.includes('ventas.index') ||
                            permisos.includes('ventas.create') ||
                            permisos.includes('producto_sucursals.index') ||
                            permisos.includes('ingreso_productos.index') ||
                            permisos.includes('ingreso_productos.create') ||
                            permisos.includes('salida_productos.index') ||
                            permisos.includes('salida_productos.create')
                        "
                    >
                        OPERACIONES
                    </li>
                    <ItemMenu
                        v-if="
                            permisos == '*' ||
                            permisos.includes('ventas.create')
                        "
                        :label="'Nueva Venta'"
                        :ruta="'ventas.create'"
                        :icon="'fa fa-cash-register'"
                    ></ItemMenu>
                    <ItemMenu
                        v-if="
                            permisos == '*' || permisos.includes('ventas.index')
                        "
                        :label="'Ventas'"
                        :ruta="'ventas.index'"
                        :icon="'fa fa-list-alt'"
                    ></ItemMenu>
                    <li
                        class="nav-item"
                        v-if="
                            permisos == '*' ||
                            permisos.includes('producto_sucursals.index') ||
                            permisos.includes('ingreso_productos.index') ||
                            permisos.includes('ingreso_productos.create') ||
                            permisos.includes('salida_productos.index') ||
                            permisos.includes('salida_productos.create')
                        "
                        :class="{ 'menu-open': openMenus.producto_sucursals }"
                    >
                        <a
                            href="#"
                            class="nav-link"
                            :class="[
                                route_current == 'producto_sucursals.index' ||
                                route_current == 'ingreso_productos.index' ||
                                route_current == 'ingreso_productos.create' ||
                                route_current == 'salida_productos.index' ||
                                route_current == 'salida_productos.create'
                                    ? 'active menu-is-opening menu-open'
                                    : '',
                            ]"
                            @click.prevent="toggleSubMenu('producto_sucursals')"
                        >
                            <i class="nav-icon fa fa-boxes"></i>
                            <p>
                                Inventario de Productos
                                <i class="nav-arrow fa fa-chevron-right"></i>
                            </p>
                        </a>
                        <ul
                            class="nav nav-treeview"
                            role="navigation"
                            aria-label="Navigation 4"
                            :style="{
                                maxHeight: openMenus.producto_sucursals
                                    ? '500px'
                                    : '0px',
                            }"
                        >
                            <ItemMenu
                                v-if="
                                    permisos == '*' ||
                                    permisos.includes(
                                        'producto_sucursals.index',
                                    )
                                "
                                :label="'Stock de Inventario'"
                                :ruta="'producto_sucursals.index'"
                                :icon="'fa fa-angle-right'"
                            ></ItemMenu>
                            <ItemMenu
                                v-if="
                                    permisos == '*' ||
                                    permisos.includes('ingresos.create')
                                "
                                :label="'Compra de Productos'"
                                :ruta="'ingreso_productos.create'"
                                :icon="'fa fa-angle-right'"
                            ></ItemMenu>
                            <ItemMenu
                                v-if="
                                    permisos == '*' ||
                                    permisos.includes('salida_productos.create')
                                "
                                :label="'Salida de Productos'"
                                :ruta="'salida_productos.create'"
                                :icon="'fa fa-angle-right'"
                            ></ItemMenu>
                            <ItemMenu
                                v-if="
                                    permisos == '*' ||
                                    permisos.includes('ingreso_productos.index')
                                "
                                :label="'Historial de Compras'"
                                :ruta="'ingreso_productos.index'"
                                :icon="'fa fa-angle-right'"
                            ></ItemMenu>
                            <ItemMenu
                                v-if="
                                    permisos == '*' ||
                                    permisos.includes('ingreso_productos.index')
                                "
                                :label="'Historial de Salidas'"
                                :ruta="'ingreso_productos.index'"
                                :icon="'fa fa-angle-right'"
                            ></ItemMenu>
                        </ul>
                    </li>
                    <li
                        class="nav-header font-weight-bold"
                        v-if="
                            permisos == '*' ||
                            permisos.includes('usuarios.index') ||
                            permisos.includes('clientes.index') ||
                            permisos.includes('sucursals.index') ||
                            permisos.includes('productos.index') ||
                            permisos.includes('categorias.index') ||
                            permisos.includes('marcas.index') ||
                            permisos.includes('unidad_medidas.index') ||
                            permisos.includes('proveedors.index')
                        "
                    >
                        ADMINISTRACIÓN
                    </li>
                    <ItemMenu
                        v-if="
                            permisos == '*' ||
                            permisos.includes('clientes.index')
                        "
                        :label="'Clientes'"
                        :ruta="'clientes.index'"
                        :icon="'fa fa-user-friends'"
                    ></ItemMenu>
                    <ItemMenu
                        v-if="
                            permisos == '*' ||
                            permisos.includes('proveedors.index')
                        "
                        :label="'Proveedores'"
                        :ruta="'proveedors.index'"
                        :icon="'fa fa-truck'"
                    ></ItemMenu>
                    <ItemMenu
                        v-if="
                            permisos == '*' ||
                            permisos.includes('sucursals.index')
                        "
                        :label="'Sucursales'"
                        :ruta="'sucursals.index'"
                        :icon="'fa fa-building'"
                    ></ItemMenu>
                    <li
                        class="nav-item"
                        v-if="
                            permisos == '*' ||
                            permisos.includes('productos.index') ||
                            permisos.includes('categorias.index') ||
                            permisos.includes('marcas.index') ||
                            permisos.includes('unidad_medidas.index')
                        "
                        :class="{ 'menu-open': openMenus.productos }"
                    >
                        <a
                            href="#"
                            class="nav-link"
                            :class="[
                                route_current == 'productos.index' ||
                                route_current == 'categorias.index' ||
                                route_current == 'marcas.index' ||
                                route_current == 'unidad_medidas.index'
                                    ? 'active menu-is-opening menu-open'
                                    : '',
                            ]"
                            @click.prevent="toggleSubMenu('productos')"
                        >
                            <i class="nav-icon fa fa-clipboard-list"></i>
                            <p>
                                Productos
                                <i class="nav-arrow fa fa-chevron-right"></i>
                            </p>
                        </a>
                        <ul
                            class="nav nav-treeview"
                            role="navigation"
                            aria-label="Navigation 4"
                            :style="{
                                maxHeight: openMenus.productos
                                    ? '500px'
                                    : '0px',
                            }"
                        >
                            <ItemMenu
                                v-if="
                                    permisos == '*' ||
                                    permisos.includes('productos.index')
                                "
                                :label="'Lista de Productos'"
                                :ruta="'productos.index'"
                                :icon="'fa fa-angle-right'"
                            ></ItemMenu>
                            <ItemMenu
                                v-if="
                                    permisos == '*' ||
                                    permisos.includes('categorias.index')
                                "
                                :label="'Categorías'"
                                :ruta="'categorias.index'"
                                :icon="'fa fa-angle-right'"
                            ></ItemMenu>
                            <ItemMenu
                                v-if="
                                    permisos == '*' ||
                                    permisos.includes('marcas.index')
                                "
                                :label="'Marcas'"
                                :ruta="'marcas.index'"
                                :icon="'fa fa-angle-right'"
                            ></ItemMenu>
                            <ItemMenu
                                v-if="
                                    permisos == '*' ||
                                    permisos.includes('unidad_medidas.index')
                                "
                                :label="'Unidades de Medida'"
                                :ruta="'unidad_medidas.index'"
                                :icon="'fa fa-angle-right'"
                            ></ItemMenu>
                        </ul>
                    </li>
                    <li
                        class="nav-item"
                        v-if="
                            permisos == '*' ||
                            permisos.includes('usuarios.index') ||
                            permisos.includes('roles.index')
                        "
                        :class="{ 'menu-open': openMenus.usuarios }"
                    >
                        <a
                            href="#"
                            class="nav-link"
                            :class="[
                                route_current == 'usuarios.index' ||
                                route_current == 'roles.index'
                                    ? 'active menu-is-opening menu-open'
                                    : '',
                            ]"
                            @click.prevent="toggleSubMenu('usuarios')"
                        >
                            <i class="nav-icon fa fa-users"></i>
                            <p>
                                Usuarios
                                <i class="nav-arrow fa fa-chevron-right"></i>
                            </p>
                        </a>
                        <ul
                            class="nav nav-treeview"
                            role="navigation"
                            aria-label="Navigation 4"
                            :style="{
                                maxHeight: openMenus.usuarios ? '500px' : '0px',
                            }"
                        >
                            <ItemMenu
                                v-if="
                                    permisos == '*' ||
                                    permisos.includes('usuarios.index')
                                "
                                :label="'Lista de Usuarios'"
                                :ruta="'usuarios.index'"
                                :icon="'fa fa-angle-right'"
                            ></ItemMenu>
                            <ItemMenu
                                v-if="
                                    permisos == '*' ||
                                    permisos.includes('roles.index')
                                "
                                :label="'Roles y Permisos'"
                                :ruta="'roles.index'"
                                :icon="'fa fa-angle-right'"
                            ></ItemMenu>
                        </ul>
                    </li>
                    <li
                        class="nav-header font-weight-bold"
                        v-if="
                            permisos == '*' ||
                            permisos.includes('reportes.usuarios') ||
                            permisos.includes('reportes.clientes') ||
                            permisos.includes('reportes.certificados') ||
                            permisos.includes(
                                'reportes.certificados_interno',
                            ) ||
                            permisos.includes('reportes.historial_accions') ||
                            permisos.includes('reportes.gcemitidos') ||
                            permisos.includes('reportes.gmemitidos')
                        "
                    >
                        REPORTES
                    </li>
                    <ItemMenu
                        v-if="
                            permisos == '*' ||
                            permisos.includes('reportes.usuarios')
                        "
                        :label="'Lista de Usuarios'"
                        :ruta="'reportes.usuarios'"
                        :icon="'fa fa-file-pdf'"
                    ></ItemMenu>
                    <li class="nav-header font-weight-bold">OTROS</li>
                    <ItemMenu
                        v-if="
                            permisos == '*' ||
                            permisos.includes('tipo_ingresos.index')
                        "
                        :label="'Tipos de Ingresos'"
                        :ruta="'tipo_ingresos.index'"
                        :icon="'fa fa-list'"
                    ></ItemMenu>
                    <ItemMenu
                        v-if="
                            permisos == '*' ||
                            permisos.includes('tipo_salidas.index')
                        "
                        :label="'Tipos de Salidas'"
                        :ruta="'tipo_salidas.index'"
                        :icon="'fa fa-list'"
                    ></ItemMenu>
                    <ItemMenu
                        v-if="
                            permisos == '*' ||
                            permisos.includes('tipo_documentos.index')
                        "
                        :label="'Tipos de Documentos'"
                        :ruta="'tipo_documentos.index'"
                        :icon="'fa fa-list'"
                    ></ItemMenu>
                    <ItemMenu
                        v-if="
                            permisos == '*' ||
                            permisos.includes('configuracions.index')
                        "
                        :label="'Configuración Sistema'"
                        :ruta="'configuracions.index'"
                        :icon="'fa fa-cog'"
                    ></ItemMenu>
                    <!-- <ItemMenu
                        :label="'Perfil'"
                        :ruta="'profile.edit'"
                        :icon="'fa fa-id-card'"
                    ></ItemMenu> -->
                    <li class="nav-item">
                        <a
                            href="#"
                            class="nav-link"
                            @click.prevent="salir()"
                            ref="link"
                        >
                            <i class="nav-icon fa fa-power-off"></i>
                            <p>Salir</p>
                        </a>
                    </li>
                </ul>
            </nav>
            <!-- /.sidebar-menu -->
        </div>
        <!-- /.sidebar -->
    </aside>
</template>
<style scoped></style>
