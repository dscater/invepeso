<script setup>
import { useForm, usePage } from "@inertiajs/vue3";
import { watch, ref, computed, onMounted, nextTick } from "vue";
// TOAST
import { toast } from "vue3-toastify";
import "vue3-toastify/dist/index.css";
const props = defineProps({
    form: {
        type: Object,
    },
});

const enviando = ref(false);
const form = props.form;
const textBtn = computed(() => {
    if (enviando.value) {
        return `<i class="fa fa-spin fa-spinner"></i> Enviando...`;
    }
    return `<i class="fa fa-edit"></i> Registrar verificación`;
});

const enviarFormulario = () => {
    enviando.value = true;
    let url = route("ingreso_productos.verificar", form.id);

    form.post(url, {
        preserveScroll: true,
        forceFormData: true,
        onSuccess: (response) => {
            console.log("correcto");
            const success =
                response.props.flash.success ?? "Proceso realizado con éxito";
            const url_blank = response.props.url_blank ?? null;
            Swal.fire({
                icon: "success",
                title: "Correcto",
                html: `<strong>${success}</strong>`,
                confirmButtonText: `Aceptar`,
                customClass: {
                    confirmButton: "btn-alert-success",
                },
            });

            if (url_blank) {
                window.open(url_blank, "_blank");
            }

            document
                .getElementsByTagName("body")[0]
                .classList.remove("modal-open");
            emits("envio-formulario");
        },
        onError: (err, code) => {
            console.log(code ?? "");
            if (Object.keys(form.errors).length > 0) {
                const errores = Object.values(form.errors)
                    .map((error) => `<li>${error}</li>`)
                    .join("");

                Swal.fire({
                    icon: "error",
                    title: "Errores de validación",
                    html: `
                <p>Existen errores en el formulario:</p>
                <ul style="text-align:left;">
                    ${errores}
                </ul>
            `,
                    confirmButtonText: "Aceptar",
                    customClass: {
                        confirmButton: "btn-error",
                    },
                });
            } else {
                Swal.fire({
                    icon: "error",
                    title: "Error",
                    text: "Ocurrió un error inesperado, contacte con el administrador.",
                    confirmButtonText: "Aceptar",
                    customClass: {
                        confirmButton: "btn-error",
                    },
                });
            }
            console.log("error: " + err.error);
        },
        onFinish: () => {
            enviando.value = false;
        },
    });
};

const emits = defineEmits(["envio-formulario"]);

const agregarAlmacen = (detalle) => {
    console.log(detalle);
    if (!detalle.ingreso_recepcions) detalle.ingreso_recepcions = [];

    detalle.ingreso_recepcions.push({
        id: 0,
        ingreso_producto_id: form.id,
        ingreso_detalle_id: detalle.id,
        sucursal_id: "",
        almacen_id: "",
        producto_id: detalle.producto_id,
        cantidad: 0,
    });
};

const totalesDetalles = computed(() => {
    const totales = {};
    form.ingreso_detalles.forEach((detalle, index) => {
        const verificado = getTotalRecibidoDetalle(detalle);
        totales[index] = {
            solicitado: detalle.cantidad,
            verificado: verificado,
            faltantes: getFaltantesDetalle(detalle, verificado),
        };
    });
    return totales;
});

const getTotalRecibidoDetalle = (detalle) => {
    return detalle.ingreso_recepcions.reduce((acc, item) => {
        return acc + Number(item.cantidad ?? 0);
    }, 0);
};

const getFaltantesDetalle = (detalle, verificado) => {
    return parseFloat(
        Number(detalle.cantidad) - Number(verificado ?? 0),
    ).toFixed(2);
};

const quitarAlmacen = (detalle, index_recepcion) => {
    if (detalle.ingreso_recepcions[index_recepcion].id != 0) {
        form.eliminados_recepcions.push(
            detalle.ingreso_recepcions[index_recepcion].id,
        );
    }
    detalle.ingreso_recepcions.splice(index_recepcion, 1);
};

const listAlmacens = ref([]);

const cargarAlmacens = async () => {
    try {
        const res = await axios.get(route("almacens.listado"), {
            params: {
                activo: 1,
            },
        });
        listAlmacens.value = res.data.almacens;
    } catch (e) {
        console.log(e);
    } finally {
    }
};
onMounted(() => {
    cargarAlmacens();
});
</script>

<template>
    <form @submit.prevent="enviarFormulario()">
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-body bg-dark text-white">
                        <div class="row">
                            <div class="col-12">
                                <span class="float-end text-sm"
                                    ><i class="fa fa-calendar-alt"></i>
                                    {{ form.fecha_registro_t }}</span
                                >
                                <h4 class="text-primary fw-bold fs-5">
                                    <i class="fa fa-barcode"></i>
                                    {{ form.codigo }}
                                </h4>
                            </div>
                            <div class="col-12">
                                <span class="float-end text-sm"
                                    ><i class="fa fa-truck"></i>
                                    {{ form.proveedor?.nombre }}</span
                                >
                                <h4 class="fw-bold fs-5">
                                    <span class="txtActivo"
                                        >Bs. {{ form.total }}</span
                                    >
                                    <span class="text-white fw-normal"> |</span>
                                    <span class="txtInactivo">
                                        Saldo Bs.
                                        {{ form.saldo }}
                                    </span>
                                </h4>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-12">
                <div
                    class="card mt-2"
                    v-for="(detalle, index_detalle) in form.ingreso_detalles"
                >
                    <div class="card-header bg2">
                        <div class="row">
                            <div class="col-3">
                                <h4
                                    class="fs-7 fw-bold text-white d-flex h-100 align-items-center"
                                >
                                    <i class="fa fa-box me-1"></i>
                                    {{ detalle.producto.nombre }} <br />
                                    {{ detalle.producto.codigo }}
                                </h4>
                            </div>
                            <div class="col-3">
                                <div class="input-group">
                                    <span
                                        class="input-group-text fw-bold bgPrimary2 text-primary text-xs"
                                    >
                                        Solicitado:
                                    </span>
                                    <div
                                        class="form-control bgPrimary2 text-primary fw-bold"
                                        v-text="
                                            totalesDetalles[index_detalle]
                                                .solicitado
                                        "
                                    ></div>
                                </div>
                            </div>
                            <div class="col-3">
                                <div class="input-group">
                                    <span
                                        class="input-group-text fw-bold bgActivo2 text-success text-xs"
                                    >
                                        Recibido:
                                    </span>
                                    <div
                                        class="form-control bgActivo2 text-success fw-bold"
                                        v-text="
                                            totalesDetalles[index_detalle]
                                                .verificado
                                        "
                                    ></div>
                                </div>
                            </div>
                            <div class="col-3">
                                <div class="input-group">
                                    <span
                                        class="input-group-text fw-bold text-xs bgInactivo2 text-danger"
                                    >
                                        Faltantes:
                                    </span>
                                    <div
                                        class="form-control bgInactivo2 text-danger fw-bold"
                                        v-text="
                                            totalesDetalles[index_detalle]
                                                .faltantes
                                        "
                                    ></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <template
                                v-if="detalle.ingreso_recepcions.length > 0"
                            >
                                <div
                                    class="col-sm-6 col-md-6 col-lg-3"
                                    v-for="(
                                        recepcion, index_recepcion
                                    ) in detalle.ingreso_recepcions"
                                >
                                    <div class="card">
                                        <div class="card-body p-2 pt-0">
                                            <div class="row">
                                                <div class="col-12 text-end">
                                                    <button
                                                        type="button"
                                                        class="text-danger btn fs-8 border-0 p-0"
                                                        @click="
                                                            quitarAlmacen(
                                                                detalle,
                                                                index_recepcion,
                                                            )
                                                        "
                                                    >
                                                        Quitar
                                                        <i
                                                            class="fa fa-times"
                                                        ></i>
                                                    </button>
                                                </div>
                                                <div class="col-7">
                                                    <span
                                                        class="fs-8 text-muted"
                                                        >Almacén</span
                                                    >
                                                    <el-select
                                                        v-model="
                                                            recepcion.almacen_id
                                                        "
                                                        class="w-100"
                                                        no-data-text="Sin datos"
                                                        no-match-text="Sin resultados"
                                                        placeholder="Almacén"
                                                        filterable
                                                    >
                                                        <el-option
                                                            v-for="almacen in listAlmacens"
                                                            :key="almacen.id"
                                                            :value="almacen.id"
                                                            :label="`${almacen.nombre} - ${almacen.sucursal.nombre}`"
                                                        ></el-option
                                                    ></el-select>
                                                </div>
                                                <div class="col-5">
                                                    <span
                                                        class="fs-8 text-muted"
                                                        >Cantidad</span
                                                    >
                                                    <input
                                                        type="number"
                                                        v-model="
                                                            recepcion.cantidad
                                                        "
                                                        class="form-control"
                                                    />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </template>
                            <template v-else>
                                <div
                                    class="col-sm-6 col-md-3 col-lg-3 d-flex align-items-center justify-content-center border-dashed"
                                >
                                    <h4 class="text-muted fs-7 text-center p-2">
                                        <i class="fa fa-warehouse"></i><br />
                                        No se agregó ningún almacén
                                    </h4>
                                </div>
                            </template>
                            <div class="col-sm-6 col-md-3 col-lg-3 mt-2">
                                <button
                                    type="button"
                                    class="agregar btn btn-light border h-100"
                                    @click.prevent="agregarAlmacen(detalle)"
                                >
                                    <i class="fa fa-plus"></i><br />
                                    Agregar Almacén
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-12 mt-2 text-center">
                <button
                    type="button"
                    class="btn btn-primary btn-lg"
                    :disabled="enviando"
                    @click.prevent="enviarFormulario"
                    v-html="textBtn"
                ></button>
            </div>
        </div>
    </form>
</template>
