<script setup>
import { computed } from "vue";
import { usePage, router, Link } from "@inertiajs/vue3";

const props = defineProps({
    label: {
        type: String,
        default: "Label",
    },
    icon: {
        type: String,
        default: "mdi-home-outline",
    },
    ruta: {
        type: String,
        default: "/",
    },
    method: {
        type: String,
        default: "GET",
    },
    arrayRutaClassActive: {
        type: Array,
        default: () => [],
    },
});

const emits = defineEmits(["onClick"]);

const page = usePage();

// Se actualiza cuando Inertia cambia de página.
const route_current = computed(() => {
    page.url;
    return route().current() || "";
});

const classActive = computed(() => {
    const rutas = props.arrayRutaClassActive;

    if (rutas.length > 0) {
        return rutas.includes(route_current.value) ? "active" : "";
    }

    return route_current.value === props.ruta ? "active" : "";
});

const ejecutaPost = () => {
    emits("onClick");
    router.post(route(props.ruta));
};

const ejecutaClick = () => {
    emits("onClick");
};
</script>

<template>
    <li
        class="nav-item"
        v-if="method.toLowerCase() === 'get'"
        :class="[$attrs.class]"
    >
        <Link
            v-if="ruta !== route_current"
            :href="ruta ? route(ruta) : '/'"
            class="nav-link"
            :class="classActive"
            @click="ejecutaClick"
        >
            <i class="nav-icon" :class="icon || 'fa-th'"></i>

            <p>{{ label }}</p>
        </Link>

        <div v-else class="nav-link" :class="classActive">
            <i class="nav-icon" :class="icon || 'fa-th'"></i>

            <p>{{ label }}</p>
        </div>
    </li>

    <li class="nav-item" v-else>
        <a href="#" class="nav-link" @click.prevent="ejecutaPost">
            <i class="nav-icon" :class="icon || 'fa-th'"></i>

            <p>{{ label }}</p>
        </a>
    </li>
</template>
