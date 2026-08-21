import { useForm } from "@inertiajs/vue3";
import { onMounted, ref } from "vue";

export const useRoles = () => {
    const initialState = {
        id: "",
        nombre: "",
        permisos: [],
        usuarios: "",
        _method: "POST",
    };

    const form = useForm({ ...initialState });

    const setRole = (item = null) => {
        form.clearErrors();
        form.reset();
        Object.assign(form, item);
        form._method = "PUT";
    };

    const limpiarRole = () => {
        form.clearErrors();
        form.reset();
        form.defaults({ ...initialState });
    };

    onMounted(() => {});

    return {
        form,
        setRole,
        limpiarRole,
    };
};
