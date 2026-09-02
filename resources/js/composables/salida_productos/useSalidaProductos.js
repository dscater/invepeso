import { useForm } from "@inertiajs/vue3";
import { onMounted, ref } from "vue";

export const useSalidaProductos = () => {
    const initialState = {
        id: 0,
        sucursal_id: "",
        almacen_id: "",
        tipo_salida_id: "",
        cantidad: "",
        descripcion: "",
        fecha_registro: "",
        user_id: "",
        salida_detalles: [],
        eliminados: [],
        _method: "POST",
    };

    const form = useForm({ ...initialState });

    const setSalidaProducto = (item = null) => {
        form.clearErrors();
        form.reset();
        Object.assign(form, item);
        form._method = "PUT";
    };

    const limpiarSalidaProducto = () => {
        form.clearErrors();
        form.reset();
        form.defaults({ ...initialState });
    };

    onMounted(() => {});

    return {
        form,
        setSalidaProducto,
        limpiarSalidaProducto,
    };
};
