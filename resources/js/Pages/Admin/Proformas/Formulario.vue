<script setup>
// TOAST
import { toast } from "vue3-toastify";
import "vue3-toastify/dist/index.css";
import { watch, ref, computed, onMounted, nextTick } from "vue";
import FormularioCliente from "../Clientes/FormularioCliente.vue";
import { useClientes } from "@/composables/clientes/useClientes";

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
        return `<i class="fa fa-save"></i> Registrar Proforma`;
    }
    return `<i class="fa fa-edit"></i> Actualizar Proforma`;
});

const enviarFormulario = () => {
    enviando.value = true;
    form.almacen_id = almacen_id.value;
    let url =
        form.id == 0
            ? route("proformas.store")
            : route("proformas.update", form.id);

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
const listTipoProformas = ref([]);
const listTipoPagos = ref([]);
const tipo_proforma_id_default = ref("");
const listClientes = ref([]);
const listCategorias = ref([]);
const listMarcas = ref([]);
const listProductoAlmacens = ref([]);
const loadingLista = ref(true);
const almacen_id = ref("");
const categoria_id = ref("todos");
const marca_id = ref("todos");
const nombreProducto = ref("");
const cargarProductos = async () => {
    loadingLista.value = true;
    try {
        const res = await axios.get(route("producto_sucursals.listado"), {
            params: {
                almacen_id: almacen_id.value,
                categoria_id: categoria_id.value,
                marca_id: marca_id.value,
                nombreProducto: nombreProducto.value,
            },
        });
        listProductoAlmacens.value = res.data.producto_sucursals.map(
            (item) => ({
                ...item,
                cantidad: 1,
                precio_proforma: item.precio,
                stock_aux: item.stock_total,
                tipo_proforma_id: tipo_proforma_id_default,
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

const cargarClientes = () => {
    axios.get(route("clientes.listado")).then((response) => {
        listClientes.value = response.data.clientes;
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

// const cargarTipoProformas = async () => {
//     try {
//         const res = await axios.get(route("tipo_proformas.listado"));
//         listTipoProformas.value = res.data.tipo_proformas;
//         // tipo_proforma_id_default.value = listTipoProformas.value[0]
//         //     ? listTipoProformas.value[0].id
//         //     : "";
//     } catch (e) {
//         console.log(e);
//     } finally {
//     }
// };

const cargarTipoPagos = async () => {
    try {
        const res = await axios.get(route("tipo_pagos.listado"));
        listTipoPagos.value = res.data.tipo_pagos;
    } catch (e) {
        console.log(e);
    } finally {
    }
};

const cargarListas = () => {
    // cargarTipoProformas();
    cargarTipoPagos();
    cargarProductos();
    cargarAlmacens();
    cargarClientes();
    cargarCategorias();
    cargarMarcas();
};

const agregarProductoProforma = async (item) => {
    const stock_total = Number(item.stock_total);
    const precio = Number(item.precio_proforma);
    const cantidad = Number(item.cantidad);

    // if (!stock_total || stock_total < cantidad) {
    //     toast.error("Stock insuficiente para agregar el producto");
    //     return;
    // }
    if (!precio || precio <= 0) {
        toast.error("Debe ingresar un precio valido");
        return;
    }

    if (!cantidad || cantidad <= 0) {
        toast.error("Debe ingresar una cantidad valido");
        return;
    }

    // if (!tipo_proforma_id || tipo_proforma_id == "") {
    //     toast.error("Debe seleccionar un tipo de proforma");
    //     return;
    // }

    try {
        const resp = await axios.get(route("productos.show", item.id));
        const producto = resp.data;
        const subtotal = cantidad * precio;

        const indexExiste = form.proforma_detalles.findIndex(
            (elem) => elem.producto_id == producto.id,
        );
        // console.log(indexExiste);
        if (indexExiste < 0) {
            // no existe
            form.proforma_detalles.push({
                id: 0,
                proforma_id: "",
                producto: producto,
                producto_id: producto.id,
                cantidad: cantidad,
                precio: precio,
                descuento_uni: 0,
                porcen_du: 0,
                descuento_total: 0,
                porcen_dt: 0,
                precio_final: precio,
                total: subtotal.toFixed(2),
                total_uni: subtotal.toFixed(2),
            });
        } else {
            // existe
            const cantidadFila = form.proforma_detalles[indexExiste].cantidad;
            const nuevaCantidad =
                parseFloat(cantidad) + parseFloat(cantidadFila);
            const total_uni =
                nuevaCantidad *
                (precio -
                    parseFloat(
                        form.proforma_detalles[indexExiste].descuento_uni,
                    ));
            const total =
                nuevaCantidad *
                (precio -
                    (parseFloat(
                        form.proforma_detalles[indexExiste].descuento_uni,
                    ) +
                        parseFloat(
                            form.proforma_detalles[indexExiste].descuento_total,
                        )));

            form.proforma_detalles[indexExiste].cantidad = nuevaCantidad;
            form.proforma_detalles[indexExiste].total = total.toFixed(2);
            form.proforma_detalles[indexExiste].total_uni =
                total_uni.toFixed(2);
        }
        // console.log(item);
        item.cantidad = 1;
        toast.success("Producto Agregado!!!");
        // item.stock_total = stock_total - cantidad;
    } catch (e) {
        console.log(e);
        toast.error(
            "Ocurrió un error al intentar agregar el producto; intente nuevamente",
        );
    }
};

const aplicarDescuentosTotal = () => {
    const descuento = Number(form.descuento ?? 0);
    form.proforma_detalles.map((elem) => {
        elem.descuento_total = 0;
        elem.porcen_dt = 0;
    });
    if (descuento > 0) {
        let porcentaje = (form.total * 100) / form.subtotal;
        porcentaje = 100 - porcentaje;
        porcentaje = porcentaje.toFixed(2);
        porcentaje = parseFloat(porcentaje);
        form.porcentaje_descuento = porcentaje;
        form.proforma_detalles.map((elem) => {
            const con_descuento = elem.precio - elem.descuento_uni;
            elem.porcen_dt = porcentaje;
            elem.descuento_total = con_descuento * (porcentaje / 100);
            elem.total_uni = elem.cantidad * con_descuento;
            elem.total_uni = parseFloat(elem.total_uni).toFixed(2);

            // TOTAL PARA CALCULAR GANANCIA BRUTA
            elem.precio_final = con_descuento - elem.descuento_total;
            console.log(elem.precio_final);
            elem.total = elem.cantidad * elem.precio_final;
        });
    }
};

const detectarCambioFila = (item, index) => {
    const cant = Number(item.cantidad);
    const precio = Number(item.precio);
    const descuento_uni = Number(item.descuento_uni ?? 0);
    const descuento_total = Number(item.descuento_total ?? 0);
    if (!cant || !precio) {
        return;
    }
    const total_uni = cant * (precio - parseFloat(descuento_uni));
    const total =
        cant *
        (precio - (parseFloat(descuento_uni) + parseFloat(descuento_total)));
    form.proforma_detalles[index].total_uni = total_uni.toFixed(2);
    form.proforma_detalles[index].total = total.toFixed(2);
    recalcularStockActualCambioDetalle(item.producto_id, cant, index);
};

const quitarFila = (item, index) => {
    const id = item.id;
    if (id != 0) {
        form.eliminados.push(id);
    }

    sumarDetalleEliminado(
        item.producto_id,
        Number(form.proforma_detalles[index].cantidad),
    );
    form.proforma_detalles.splice(index, 1);
    toast.success("Se quitó el producto!!!");
};

const sumarDetalleEliminado = (producto_id, cantidad) => {
    const item_almacen_origen = listProductoAlmacens.value.find(
        (elem) => elem.id == producto_id,
    );
    // item_almacen_origen.stock_total =
    //     Number(item_almacen_origen.stock_total) + Number(cantidad);
};

const recalcularStockActualCambioDetalle = (
    producto_id,
    cantidad,
    index = null,
) => {
    const item_almacen_origen = listProductoAlmacens.value.find(
        (elem) => elem.id == producto_id,
    );

    // if (index !== null) {
    //     if (cantidad > item_almacen_origen.stock_aux) {
    //         toast.error("Stock insuficiente para la cantidad ingresada");
    //         form.proforma_detalles[index].cantidad =
    //             item_almacen_origen.stock_aux;
    //         return;
    //     }
    // }
    // item_almacen_origen.stock_total =
    //     Number(item_almacen_origen.stock_aux) - Number(cantidad);
};

const subTotalProforma = computed(() => {
    if (!form?.proforma_detalles) return 0;
    return form.proforma_detalles.reduce((acc, item) => {
        return acc + parseFloat(item.total_uni || 0);
    }, 0);
});

const totalProforma = computed(() => {
    if (!form?.proforma_detalles) return 0;
    const subtotal = form.proforma_detalles.reduce((acc, item) => {
        return acc + parseFloat(item.total_uni || 0);
    }, 0);

    const descuento = parseFloat(form.descuento) || 0;
    return subtotal - descuento;
});
const saldoProforma = computed(() => {
    return (parseFloat(form.total) || 0) - (parseFloat(form.cancelado) || 0);
});

watch([subTotalProforma, totalProforma, saldoProforma], () => {
    form.tipo_pago = "";
    if (form.cancelado > 0) {
        form.tipo_pago = "EFECTIVO";
    }
    form.subtotal = subTotalProforma.value.toFixed(2);
    form.total = totalProforma.value.toFixed(2);
    form.saldo = saldoProforma.value.toFixed(2);
});

const cambiarTipoProforma = () => {
    form.cancelado = form.total;
    if (form.tipo_proforma == "CRÉDITO") {
        form.cancelado = 0;
    }
};

// CLIENTE
const muestra_form_cliente = ref(false);
const { setCliente, limpiarCliente, form: formCliente } = useClientes();
const cerrarFormCliente = () => {
    limpiarCliente();
    muestra_form_cliente.value = false;
};

const actualizarClientes = (cliente) => {
    listClientes.value.push(cliente);
    form.cliente_id = cliente.id;
    muestra_form_cliente.value = false;
    limpiarCliente();
};

const nuevoCliente = () => {
    limpiarCliente();
    muestra_form_cliente.value = true;
};

onMounted(() => {
    // edit
    if (form.id != 0) {
        almacen_id.value = form.almacen_id;
    }
    cargarListas();
});
</script>

<template>
    <form @submit.prevent="enviarFormulario()">
        <FormularioCliente
            v-if="muestra_form_cliente"
            :form="formCliente"
            :muestra_formulario="muestra_form_cliente"
            @envio-formulario="actualizarClientes"
            @cerrar-formulario="cerrarFormCliente"
        ></FormularioCliente>
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
                                            v-model="almacen_id"
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
                                    v-if="form.errors?.almacen_id"
                                    class="d-block text-danger list-unstyled"
                                >
                                    <li class="parsley-required">
                                        {{ form.errors?.almacen_id }}
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
                        <div class="row" v-if="almacen_id">
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
                                                            <div
                                                                class="col-lg-5"
                                                            >
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
                                                            <div
                                                                class="col-lg-7 mt-1"
                                                            >
                                                                <label
                                                                    class="mb-0"
                                                                    >C/U
                                                                    Bs.</label
                                                                >
                                                                <div
                                                                    class="input-group"
                                                                >
                                                                    <span
                                                                        class="input-group-text text-xs"
                                                                    >
                                                                        Bs.</span
                                                                    >
                                                                    <select
                                                                        class="p-1 form-select fs-7"
                                                                        v-model="
                                                                            item.precio_proforma
                                                                        "
                                                                    >
                                                                        <option
                                                                            v-if="
                                                                                parseFloat(
                                                                                    item.precio,
                                                                                ) >
                                                                                0
                                                                            "
                                                                            :key="
                                                                                item.precio
                                                                            "
                                                                            :value="
                                                                                item.precio
                                                                            "
                                                                            selected
                                                                        >
                                                                            {{
                                                                                item.precio
                                                                            }}
                                                                        </option>
                                                                        <option
                                                                            v-if="
                                                                                parseFloat(
                                                                                    item.precio2,
                                                                                ) >
                                                                                0
                                                                            "
                                                                            :key="
                                                                                item.precio2
                                                                            "
                                                                            :value="
                                                                                item.precio2
                                                                            "
                                                                        >
                                                                            {{
                                                                                item.precio2
                                                                            }}
                                                                        </option>
                                                                        <option
                                                                            v-if="
                                                                                parseFloat(
                                                                                    item.precio3,
                                                                                ) >
                                                                                0
                                                                            "
                                                                            :key="
                                                                                item.precio3
                                                                            "
                                                                            :value="
                                                                                item.precio3
                                                                            "
                                                                        >
                                                                            {{
                                                                                item.precio3
                                                                            }}
                                                                        </option>
                                                                        <option
                                                                            v-if="
                                                                                parseFloat(
                                                                                    item.precio4,
                                                                                ) >
                                                                                0
                                                                            "
                                                                            :key="
                                                                                item.precio4
                                                                            "
                                                                            :value="
                                                                                item.precio4
                                                                            "
                                                                        >
                                                                            {{
                                                                                item.precio4
                                                                            }}
                                                                        </option>
                                                                    </select>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-12 mt-2">
                                                        <button
                                                            type="button"
                                                            class="btn btn-primary btn-sm fs-8 w-100"
                                                            title="Agregar"
                                                            @click.prevent="
                                                                agregarProductoProforma(
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
                    <div class="card-header bg-dark-gray text-white">
                        <div class="row">
                            <div class="col-12">
                                <h4 class="card-title text-white pt-1">
                                    <i class="fa fa-clipboard-check"></i> Datos
                                    de la Proforma
                                </h4>
                                <div
                                    class="float-end badge bgActivo rounded-circle fs-6"
                                >
                                    {{ form.proforma_detalles.length }}
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-12 mt-2">
                                <label class="required">Cliente</label>
                                <div class="input-group">
                                    <div class="form-control border-0 p-0">
                                        <el-select
                                            v-model="form.cliente_id"
                                            class="el-select-input-group-left"
                                            no-data-text="Sin datos"
                                            no-match-text="Sin resultados"
                                            placeholder="Cliente"
                                            size="large"
                                            filterable
                                        >
                                            <el-option
                                                v-for="item in listClientes"
                                                :key="item.id"
                                                :value="item.id"
                                                :label="`${item.nombre} - ${item.tipo_documento.nombre}: ${item.nro_documento}`"
                                            ></el-option>
                                        </el-select>
                                    </div>
                                    <span class="input-button">
                                        <button
                                            type="button"
                                            class="btn btn-primary rounded-0 h-100"
                                            title="Nuevo Cliente"
                                            @click.prevent="nuevoCliente"
                                        >
                                            <i class="fa fa-plus"></i>
                                        </button>
                                    </span>
                                </div>
                                <ul
                                    v-if="form.errors?.cliente_id"
                                    class="d-block text-danger list-unstyled"
                                >
                                    <li class="parsley-required">
                                        {{ form.errors?.cliente_id }}
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
                            v-if="form.proforma_detalles.length > 0"
                        >
                            <div
                                class="item-producto"
                                v-for="(item, index) in form.proforma_detalles"
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
                                        <div class="col-md-4 text-center">
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
                                        <div class="col-md-4 text-end">
                                            <input
                                                type="number"
                                                class="p-1 py-0 form-control text-xs text-end"
                                                v-model="item.precio"
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
                                            <div class="text-xxs">C/U Bs.</div>
                                        </div>
                                        <div class="col-md-4 text-end">
                                            <div
                                                class="p-1 py-0 fw-bold form-control text-xs text-sm text-end"
                                            >
                                                {{ item.total_uni }}
                                            </div>
                                            <div class="text-xxs">
                                                Subtotal Bs.
                                            </div>
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
                            <div class="col-12 fw-bolder text-nuevo fs-5">
                                Subtotal Bs.
                                <div class="float-end">
                                    {{ subTotalProforma.toFixed(2) }}
                                </div>
                            </div>
                            <div class="col-12">
                                <div class="row fw-bolder text-precargado fs-5">
                                    <div class="col-6 h-100">Descuento Bs.</div>
                                    <div class="col-6">
                                        <input
                                            type="number"
                                            class="form-control text-end fs-6"
                                            v-model="form.descuento"
                                            @keyup="aplicarDescuentosTotal"
                                        />
                                    </div>
                                </div>
                                <div class="row border-top pt-2 mt-2">
                                    <div
                                        class="col-12 fw-bolder text-success fs-5"
                                    >
                                        Total Bs.
                                        <div class="float-end">
                                            {{ totalProforma.toFixed(2) }}
                                        </div>
                                    </div>
                                </div>
                                <!-- <div class="row fw-bolder fs-5">
                                    <div class="col-6 h-100">Cancelado Bs.</div>
                                    <div class="col-6">
                                        <input
                                            type="number"
                                            class="form-control text-end fs-6"
                                            v-model="form.cancelado"
                                        />
                                    </div>
                                </div>
                                <div class="col-12 fw-bolder text-danger fs-5">
                                    Saldo Bs.
                                    <div class="float-end">
                                        {{ saldoProforma.toFixed(2) }}
                                    </div>
                                </div> -->
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
                                    Proforma
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</template>
