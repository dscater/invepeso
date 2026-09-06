<script setup>
// TOAST
import { toast } from "vue3-toastify";
import "vue3-toastify/dist/index.css";
import { watch, ref, computed, onMounted, nextTick } from "vue";
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
    if (form.id == 0) {
        return `<i class="fa fa-save"></i> Registrar Traspaso`;
    }
    return `<i class="fa fa-edit"></i> Actualizar`;
});

const enviarFormulario = () => {
    enviando.value = true;
    form.almacen_origen_id = almacen_origen_id.value;
    form.almacen_destino_id = almacen_destino_id.value;
    let url =
        form.id == 0
            ? route("traspasos.store")
            : route("traspasos.update", form.id);

    form.post(url, {
        preserveScroll: true,
        forceFormData: true,
        onSuccess: (response) => {
            console.log("correcto");
            const success =
                response.props.flash.success ?? "Proceso realizado con éxito";
            Swal.fire({
                icon: "success",
                title: "Correcto",
                html: `<strong>${success}</strong>`,
                confirmButtonText: `Aceptar`,
                customClass: {
                    confirmButton: "btn-alert-success",
                },
            });

            cargarProductos();
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
        },
        onFinish: () => {
            enviando.value = false;
        },
    });
};

const emits = defineEmits(["envio-formulario"]);

const listAlmacens = ref([]);
const listAlmacensDestino = computed(() => {
    almacen_destino_id.value = "";
    return listAlmacens.value.filter(
        (item) => item.id != almacen_origen_id.value,
    );
});
const listTipoTraspasos = ref([]);
const tipo_traspaso_id_default = ref("");
const listProveedors = ref([]);
const listCategorias = ref([]);
const listMarcas = ref([]);
const listProductoAlmacens = ref([]);
const loadingLista = ref(true);
const almacen_origen_id = ref("");
const almacen_destino_id = ref("");
const categoria_id = ref("todos");
const marca_id = ref("todos");
const nombreProducto = ref("");
const cargarProductos = async () => {
    loadingLista.value = true;
    try {
        const res = await axios.get(route("producto_sucursals.listado"), {
            params: {
                almacen_id: almacen_origen_id.value,
                categoria_id: categoria_id.value,
                marca_id: marca_id.value,
                nombreProducto: nombreProducto.value,
            },
        });
        listProductoAlmacens.value = res.data.producto_sucursals.map(
            (item) => ({
                ...item,
                cantidad: 1,
                costo: item.precio_compra,
                stock_aux: item.stock_total,
                tipo_traspaso_id: tipo_traspaso_id_default,
            }),
        );
    } catch (e) {
        console.log(e);
    } finally {
        loadingLista.value = false;
    }
};
const intervalNombre = ref(null);
const filtrarNombres = () => {
    clearInterval(intervalNombre.value);
    intervalNombre.value = setTimeout(() => {
        cargarProductos();
    }, 370);
};

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

const cargarProveedors = () => {
    axios.get(route("proveedors.listado")).then((response) => {
        listProveedors.value = response.data.proveedors;
    });
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

const cargarTipoTraspasos = async () => {
    try {
        const res = await axios.get(route("tipo_traspasos.listado"));
        listTipoTraspasos.value = res.data.tipo_traspasos;
        // tipo_traspaso_id_default.value = listTipoTraspasos.value[0]
        //     ? listTipoTraspasos.value[0].id
        //     : "";
    } catch (e) {
        console.log(e);
    } finally {
    }
};

const cargarListas = () => {
    cargarTipoTraspasos();
    cargarProductos();
    cargarAlmacens();
    cargarProveedors();
    cargarCategorias();
    cargarMarcas();
};

const agregarProductoTraspaso = async (item) => {
    const stock_total = Number(item.stock_total);
    const cantidad = Number(item.cantidad);
    if (!stock_total || stock_total < cantidad) {
        toast.error("Stock insuficiente para agregar el producto");
        return;
    }

    if (!cantidad || cantidad <= 0) {
        toast.error("Debe ingresar una cantidad valido");
        return;
    }

    try {
        const resp = await axios.get(route("productos.show", item.id));
        const producto = resp.data;

        const indexExiste = form.traspaso_detalles.findIndex(
            (elem) => elem.producto_id == producto.id,
        );
        // console.log(indexExiste);
        if (indexExiste < 0) {
            // no existe
            form.traspaso_detalles.push({
                id: 0,
                traspaso_id: "",
                producto: producto,
                producto_id: producto.id,
                cantidad: cantidad,
            });
        } else {
            // existe
            const cantidadFila = form.traspaso_detalles[indexExiste].cantidad;
            const nuevaCantidad =
                parseFloat(cantidad) + parseFloat(cantidadFila);

            form.traspaso_detalles[indexExiste].cantidad = nuevaCantidad;
        }
        // console.log(item);
        item.cantidad = 1;
        toast.success("Producto Agregado!!!");

        item.stock_total = stock_total - cantidad;
    } catch (e) {
        console.log(e);
        toast.error(
            "Ocurrió un error al intentar agregar el producto; intente nuevamente",
        );
    }
};

const detectarCambioFila = (item, index) => {
    const cant = Number(item.cantidad);
    const costo = Number(item.costo);
    if (!cant || !costo) {
        return;
    }

    recalcularStockActualCambioDetalle(item.producto_id, cant, index);
    // const subtotal = cant * costo;
    // form.traspaso_detalles[index].subtotal = subtotal.toFixed(2);
};

const quitarFila = (item, index) => {
    const id = item.id;
    if (id != 0) {
        form.eliminados.push(id);
    }

    sumarDetalleEliminado(
        item.producto_id,
        Number(form.traspaso_detalles[index].cantidad),
    );

    form.traspaso_detalles.splice(index, 1);
    toast.success("Se quitó el producto!!!");
};

const sumarDetalleEliminado = (producto_id, cantidad) => {
    const item_almacen_origen = listProductoAlmacens.value.find(
        (elem) => elem.id == producto_id,
    );
    item_almacen_origen.stock_total =
        Number(item_almacen_origen.stock_total) + Number(cantidad);
};

const recalcularStockActualCambioDetalle = (
    producto_id,
    cantidad,
    index = null,
) => {
    const item_almacen_origen = listProductoAlmacens.value.find(
        (elem) => elem.id == producto_id,
    );

    if (index !== null) {
        if (cantidad > item_almacen_origen.stock_aux) {
            toast.error("Stock insuficiente para la cantidad ingresada");
            form.traspaso_detalles[index].cantidad =
                item_almacen_origen.stock_aux;
            return;
        }
    }
    item_almacen_origen.stock_total =
        Number(item_almacen_origen.stock_aux) - Number(cantidad);
};

const totalTraspaso = computed(() => {
    if (!form?.traspaso_detalles) return 0;
    return form.traspaso_detalles.reduce((acc, item) => {
        return acc + parseFloat(item.cantidad || 0);
    }, 0);
});

watch([totalTraspaso], () => {
    form.cantidad = totalTraspaso.value;
});

onMounted(() => {
    cargarListas();
});
</script>

<template>
    <form @submit.prevent="enviarFormulario()">
        <div class="row">
            <div class="col-md-7">
                <div class="card">
                    <div class="card-header shadow-bottom">
                        <div class="row">
                            <div class="col-12 mt-2">
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="fa fa-warehouse"></i>
                                    </span>
                                    <div class="form-control border-0 p-0">
                                        <el-select
                                            v-model="almacen_origen_id"
                                            class="el-select-input-group-right"
                                            no-data-text="Sin datos"
                                            no-match-text="Sin resultados"
                                            placeholder="Seleccionar Almacén"
                                            filterable
                                            @change="cargarProductos"
                                        >
                                            <el-option
                                                v-for="item in listAlmacens"
                                                :key="item.id"
                                                :value="item.id"
                                                :label="`${item.nombre} - ${item.sucursal.nombre}`"
                                            ></el-option>
                                        </el-select>
                                    </div>
                                </div>
                                <ul
                                    v-if="form.errors?.almacen_origen_id"
                                    class="d-block text-danger list-unstyled"
                                >
                                    <li class="parsley-required">
                                        {{ form.errors?.almacen_origen_id }}
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-4 col-md-4 col-sm-6 mt-2">
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
                            <div class="col-lg-4 col-md-4 col-sm-6 mt-2">
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
                            <div class="col-lg-4 col-md-4 col-sm-6 mt-2">
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
                    <div class="card-header">
                        <div class="col-12">
                            <h4 class="card-title text-center w-100">
                                <i class="fa fa-truck-loading"></i> Agregar
                                Productos
                            </h4>
                        </div>
                    </div>
                    <div
                        class="card-body bgGrayLight"
                        style="max-height: 63vh; overflow: auto"
                    >
                        <div class="row" v-if="almacen_origen_id">
                            <div class="col-12">
                                <div class="vacio_info" v-if="loadingLista">
                                    <i
                                        class="fa fa-spin fa-spinner fs-1 text-primary"
                                    ></i>
                                </div>
                                <div class="row" v-if="!loadingLista">
                                    <div
                                        class="col-md-6 col-sm-12 producto-item-listado"
                                        v-for="item in listProductoAlmacens"
                                        :key="item.id"
                                    >
                                        <div class="card mt-2">
                                            <div class="card-body py-2">
                                                <div class="row">
                                                    <div class="col-12 pb-1">
                                                        <span
                                                            class="fw-bold h6"
                                                        >
                                                            {{ item.nombre }}
                                                        </span>
                                                        <span
                                                            class="float-end text-sm"
                                                        >
                                                            Stock:
                                                            <span
                                                                class="badge fw-bold text-xs"
                                                                :class="{
                                                                    'bg-danger':
                                                                        item.stock_total <
                                                                        item.stock_min,
                                                                    'bg-warning':
                                                                        item.stock_total ==
                                                                        item.stock_min,
                                                                    'bg-success':
                                                                        item.stock_total >
                                                                        item.stock_min,
                                                                }"
                                                            >
                                                                {{
                                                                    item.stock_total
                                                                }}
                                                            </span>
                                                        </span>
                                                    </div>
                                                    <div
                                                        class="col-12 border-top"
                                                    >
                                                        <div class="row">
                                                            <div
                                                                class="col-6 py-1"
                                                            >
                                                                <div
                                                                    class="text-center text-xxs text-muted"
                                                                >
                                                                    <div>
                                                                        {{
                                                                            item
                                                                                .categoria
                                                                                .nombre
                                                                        }}
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div
                                                                class="col-6 py-1"
                                                            >
                                                                <div
                                                                    class="text-center text-xxs text-muted"
                                                                >
                                                                    <div>
                                                                        {{
                                                                            item
                                                                                .marca
                                                                                .nombre
                                                                        }}
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div
                                                        class="col-12 border-top"
                                                    >
                                                        <div class="row">
                                                            <div class="col-12">
                                                                <label
                                                                    class="mb-0"
                                                                    >Cant.</label
                                                                >
                                                                <input
                                                                    type="number"
                                                                    class="p-1 form-control text-center"
                                                                    v-model="
                                                                        item.cantidad
                                                                    "
                                                                    :min="1"
                                                                />
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-12 mt-2">
                                                        <button
                                                            type="button"
                                                            class="btn btn-warning btn-sm fs-8 w-100"
                                                            title="Agregar"
                                                            @click.prevent="
                                                                agregarProductoTraspaso(
                                                                    item,
                                                                )
                                                            "
                                                        >
                                                            <i
                                                                class="fa fa-plus"
                                                            ></i>
                                                            Agregar
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="vacio_info text-muted py-5" v-else>
                            <i class="fa fa-warehouse fs-1"></i>
                            <div>Selecciona una almacén</div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-5">
                <div class="card">
                    <div class="card-header bg-info">
                        <div class="row">
                            <div class="col-12">
                                <h4 class="card-title pt-1">
                                    <i class="fa fa-clipboard-check"></i> Datos
                                    del traspaso
                                </h4>
                                <div
                                    class="float-end badge bg-primary rounded-circle fs-6"
                                >
                                    {{ form.traspaso_detalles.length }}
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-12 mt-2">
                                <label class="required">Almacén Destino</label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="fa fa-warehouse"></i>
                                    </span>
                                    <div class="form-control border-0 p-0">
                                        <el-select
                                            v-model="almacen_destino_id"
                                            class="el-select-input-group-right"
                                            no-data-text="Sin datos"
                                            no-match-text="Sin resultados"
                                            placeholder="Seleccionar Almacén Destino"
                                            filterable
                                        >
                                            <el-option
                                                v-for="item in listAlmacensDestino"
                                                :key="item.id"
                                                :value="item.id"
                                                :label="`${item.nombre} - ${item.sucursal.nombre}`"
                                            ></el-option>
                                        </el-select>
                                    </div>
                                </div>
                                <ul
                                    v-if="form.errors?.almacen_origen_id"
                                    class="d-block text-danger list-unstyled"
                                >
                                    <li class="parsley-required">
                                        {{ form.errors?.almacen_origen_id }}
                                    </li>
                                </ul>
                            </div>
                            <div class="col-12 mt-2">
                                <label class="required">Descripción</label>
                                <el-input
                                    type="textarea"
                                    :class="{
                                        'parsley-error':
                                            form.errors?.descripcion,
                                    }"
                                    v-model="form.descripcion"
                                    autosize
                                ></el-input>
                                <ul
                                    v-if="form.errors?.descripcion"
                                    class="d-block text-danger list-unstyled"
                                >
                                    <li class="parsley-required">
                                        {{ form.errors?.descripcion }}
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div
                        class="card-body p-0 bgGrayLight"
                        style="max-height: 53vh; overflow: auto"
                    >
                        <div
                            class="content-listado-productos bgGrayLight"
                            v-if="form.traspaso_detalles.length > 0"
                        >
                            <div
                                class="item-producto"
                                v-for="(item, index) in form.traspaso_detalles"
                            >
                                <h4 class="fw-bold fs-7">
                                    {{ item.producto.nombre }}

                                    <a
                                        href="#"
                                        class="float-end text-sm text-danger text-decoration-none"
                                        @click.prevent="quitarFila(item, index)"
                                    >
                                        <i class="fa fa-trash-alt"></i> Quitar
                                    </a>
                                </h4>
                                <div class="container-fluid">
                                    <div class="row">
                                        <div class="col-4 offset-8">
                                            <input
                                                type="number"
                                                class="p-1 py-0 form-control text-xs text-center"
                                                v-model="item.cantidad"
                                                @change="
                                                    detectarCambioFila(
                                                        item,
                                                        index,
                                                    )
                                                "
                                                @keyup="
                                                    detectarCambioFila(
                                                        item,
                                                        index,
                                                    )
                                                "
                                            />
                                            <div class="text-xxs">Cant.</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="vacio_info text-muted py-5" v-else>
                            <i class="fa fa-box-open fs-2"></i>
                            <div>No hay productos</div>
                        </div>
                    </div>
                    <div class="card-body bg6">
                        <div class="row">
                            <div class="col-12 fw-bolder text-primary fs-5">
                                Total Productos
                                <div class="float-end fw-bold fs-4">
                                    {{ totalTraspaso }}
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="card-footer">
                        <div class="row">
                            <div class="col-12">
                                <button
                                    type="button"
                                    class="btn btn-primary btn-sm w-100"
                                    :disabled="enviando"
                                    @click.prevent="enviarFormulario"
                                    v-html="textBtn"
                                ></button>
                                <button
                                    type="button"
                                    class="btn btn-default btn-sm w-100 mt-2 border"
                                >
                                    <i class="fa fa-times"></i> Cancelar
                                    Traspaso
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</template>
