import { useForm } from "@inertiajs/vue3";
import { onMounted, ref } from "vue";

export const useSalidaProductos = () => {
    const initialState = {
        id: 0,
        nombre: "",
        tipo_documento_id: "",
        nro_documento: "",
        complemento: "",
        fono: "",
        correo: "",
        fecha_registro: "",
        status: "",
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
