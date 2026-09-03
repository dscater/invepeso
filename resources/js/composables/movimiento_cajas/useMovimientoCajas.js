import { useForm } from "@inertiajs/vue3";
import { useDate } from "../useDate";
import { onMounted, ref } from "vue";

export const useMovimientoCajas = () => {
    const { getFechaActual, getHoraActual } = useDate();
    const initialState = {
        id: 0,
        sucursal_id: "",
        almacen_id: "",
        modulo: "",
        registro_id: "",
        monto: "",
        tipo_movimiento: "INGRESO",
        tipo_pago: "EFECTIVO",
        descripcion: "",
        fecha: getFechaActual(),
        fecha_t: "",
        hora: getHoraActual(),
        user_id: "",
        _method: "POST",
    };

    const form = useForm({ ...initialState });

    const setMovimientoCaja = (item = null) => {
        form.clearErrors();
        form.reset();
        Object.assign(form, item);
        form._method = "PUT";
    };

    const limpiarMovimientoCaja = () => {
        form.clearErrors();
        form.reset();
        form.defaults({ ...initialState });
    };

    onMounted(() => {});

    return {
        form,
        setMovimientoCaja,
        limpiarMovimientoCaja,
    };
};
