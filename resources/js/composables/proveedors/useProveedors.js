import { useForm } from "@inertiajs/vue3";
import { onMounted, ref } from "vue";

export const useProveedors = () => {
    const initialState = {
        id: 0,
        nombre: "",
        contacto: "",
        _method: "POST",
    };

    const form = useForm({ ...initialState });

    const setProveedor = (item = null) => {
        form.clearErrors();
        form.reset();
        Object.assign(form, item);
        form._method = "PUT";
    };

    const limpiarProveedor = () => {
        form.clearErrors();
        form.reset();
        form.defaults({ ...initialState });
    };

    onMounted(() => {});

    return {
        form,
        setProveedor,
        limpiarProveedor,
    };
};
