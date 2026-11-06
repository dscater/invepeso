<script setup>
import Content from "@/Components/Content.vue";
import { Head, Link, router, usePage } from "@inertiajs/vue3";
const { props: props_page } = usePage();
const props = defineProps({
    notificacion: Object,
});
</script>
<template>
    <Head title="Notificaciones"></Head>
    <Content>
        <template #header>
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h4 class="m-0">
                        <i class="fa fa-bell"></i> Notificaciones
                    </h4>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-end">
                        <li class="breadcrumb-item">
                            <Link :href="route('inicio')">Inicio</Link>
                        </li>
                        <li class="breadcrumb-item">
                            <Link :href="route('notificacion_users.index')"
                                >Notificaciones</Link
                            >
                        </li>
                        <li class="breadcrumb-item active">Ver</li>
                    </ol>
                </div>
                <!-- /.col -->
            </div>
            <!-- /.row -->
        </template>
        <div class="row">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-body">
                        <p><strong>Tipo: </strong> {{ notificacion.tipo }}</p>
                        <p>
                            <strong>Descripción: </strong>
                            {{ notificacion.descripcion }}
                        </p>
                        <p>
                            <strong>Fecha: </strong> {{ notificacion.fecha_c }}
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </Content>
</template>
