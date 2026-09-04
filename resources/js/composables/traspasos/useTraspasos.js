import { useForm } from "@inertiajs/vue3";
import { onMounted, ref } from "vue";

export const useTraspasos = () => {
    const initialState = {
        id: 0,
        sucursal_origen_id: "",
        almacen_origen_id: "",
        sucursal_destino_id: "",
        almacen_destino_id: "",
        cantidad: "",
        descripcion: "",
        fecha_registro: "",
        user_id: "",
        traspaso_detalles: [],
        eliminados: [],
        _method: "POST",
    };

    const form = useForm({ ...initialState });

    const setTraspaso = (item = null) => {
        form.clearErrors();
        form.reset();
        Object.assign(form, item);
        form._method = "PUT";
    };

    const limpiarTraspaso = () => {
        form.clearErrors();
        form.reset();
        form.defaults({ ...initialState });
    };

    onMounted(() => {});

    return {
        form,
        setTraspaso,
        limpiarTraspaso,
    };
};
