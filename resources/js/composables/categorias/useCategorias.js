import { useForm } from "@inertiajs/vue3";
import { onMounted, ref } from "vue";

export const useCategorias = () => {
    const initialState = {
        id: 0,
        nombre: "",
        _method: "POST",
    };

    const form = useForm({ ...initialState });

    const setCategoria = (item = null) => {
        form.clearErrors();
        form.reset();
        Object.assign(form, item);
        form._method = "PUT";
    };

    const limpiarCategoria = () => {
        form.clearErrors();
        form.reset();
        form.defaults({ ...initialState });
    };

    onMounted(() => {});

    return {
        form,
        setCategoria,
        limpiarCategoria,
    };
};
