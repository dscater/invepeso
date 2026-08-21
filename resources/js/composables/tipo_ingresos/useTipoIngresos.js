import { useForm } from "@inertiajs/vue3";
import { onMounted, ref } from "vue";

export const useTipoIngresos = () => {
    const initialState = {
        id: 0,
        nombre: "",
        descripcion: "",
        _method: "POST",
    };

    const form = useForm({ ...initialState });

    const setTipoIngreso = (item = null) => {
        form.clearErrors();
        form.reset();
        Object.assign(form, item);
        form._method = "PUT";
    };

    const limpiarTipoIngreso = () => {
        form.clearErrors();
        form.reset();
        form.defaults({ ...initialState });
    };

    onMounted(() => {});

    return {
        form,
        setTipoIngreso,
        limpiarTipoIngreso,
    };
};
