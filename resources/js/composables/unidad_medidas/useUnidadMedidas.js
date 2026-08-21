import { useForm } from "@inertiajs/vue3";
import { onMounted, ref } from "vue";

export const useUnidadMedidas = () => {
    const initialState = {
        id: 0,
        nombre: "",
        _method: "POST",
    };

    const form = useForm({ ...initialState });

    const setUnidadMedida = (item = null) => {
        form.clearErrors();
        form.reset();
        Object.assign(form, item);
        form._method = "PUT";
    };

    const limpiarUnidadMedida = () => {
        form.clearErrors();
        form.reset();
        form.defaults({ ...initialState });
    };

    onMounted(() => {});

    return {
        form,
        setUnidadMedida,
        limpiarUnidadMedida,
    };
};
