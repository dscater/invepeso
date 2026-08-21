import { useForm } from "@inertiajs/vue3";

export const useTramitadors = () => {
    const initialState = {
        id: 0,
        nombre: "",
        ci: "",
        ci_exp: "",
        cel: "",
        _method: "POST",
    };

    const form = useForm({ ...initialState });

    const setTramitador = (item) => {
        form.clearErrors();
        form.reset();
        Object.assign(form, item);
        form._method = "PUT";
    };

    const limpiarTramitador = () => {
        form.clearErrors();
        form.reset();
        form.defaults({ ...initialState });
    };

    return {
        form,
        setTramitador,
        limpiarTramitador,
    };
};
