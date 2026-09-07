import { useForm } from "@inertiajs/vue3";
import { onMounted, ref } from "vue";

export const useIngresoProductos = () => {
    const initialState = {
        id: 0,
        codigo: "",
        sucursal_id: "",
        almacen_id: "",
        tipo_ingreso_id: "",
        proveedor_id: "",
        descripcion: "",
        total: "",
        cancelado: 0,
        saldo: "",
        tipo_compra: "",
        fecha_registro: "",
        user_id: "",
        status: "",
        ingreso_detalles: [],
        eliminados: [],
        _method: "POST",
    };

    const form = useForm({ ...initialState });

    const setIngresoProducto = (item = null) => {
        form.clearErrors();
        form.reset();
        Object.assign(form, item);
        form._method = "PUT";
    };

    const limpiarIngresoProducto = () => {
        form.clearErrors();
        form.reset();
        form.defaults({ ...initialState });
    };

    onMounted(() => {});

    return {
        form,
        setIngresoProducto,
        limpiarIngresoProducto,
    };
};
