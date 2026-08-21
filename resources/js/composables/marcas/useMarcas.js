import { useForm } from "@inertiajs/vue3";
import { onMounted, ref } from "vue";

export const useMarcas = () => {
    const initialState = {
        id: 0,
        nombre: "",
        _method: "POST",
    };

    const form = useForm({ ...initialState });

    const setMarca = (item = null) => {
        form.clearErrors();
        form.reset();
        Object.assign(form, item);
        form._method = "PUT";
    };

    const limpiarMarca = () => {
        form.clearErrors();
        form.reset();
        form.defaults({ ...initialState });
    };

    onMounted(() => {});

    return {
        form,
        setMarca,
        limpiarMarca,
    };
};
