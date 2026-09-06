import { useForm } from "@inertiajs/vue3";
import { onMounted, ref } from "vue";

export const useVentas = () => {
    const initialState = {
        id: 0,
        codigo_venta: "",
        sucursal_id: "",
        almacen_id: "",
        cliente_id: "",
        tipo_documento_id: "",
        nit_ci: "",
        tipo_venta: "CRÉDITO",
        tipo_pago: "",
        subtotal: 0,
        descuento: 0,
        porcentaje_descuento: "",
        total: "",
        cancelado: 0,
        saldo: "",
        fecha: "",
        hora: "",
        fecha_registro: "",
        status: "",
        user_id: "",
        venta_detalles: [],
        eliminados: [],
        _method: "POST",
    };

    const form = useForm({ ...initialState });

    const setVenta = (item = null) => {
        form.clearErrors();
        form.reset();
        Object.assign(form, item);
        form._method = "PUT";
    };

    const limpiarVenta = () => {
        form.clearErrors();
        form.reset();
        form.defaults({ ...initialState });
    };

    onMounted(() => {});

    return {
        form,
        setVenta,
        limpiarVenta,
    };
};
