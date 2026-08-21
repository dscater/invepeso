import { useForm } from "@inertiajs/vue3";

export const useTipoDocumentos = () => {
    const initialState = {
        id: 0,
        nombre: "",
        descripcion: "",
        _method: "POST",
    };

    const form = useForm({ ...initialState });

    const setTipoDocumento = (item) => {
        form.clearErrors();
        form.reset();
        Object.assign(form, item);
        form._method = "PUT";
    };

    const limpiarTipoDocumento = () => {
        form.clearErrors();
        form.reset();
        form.defaults({ ...initialState });
    };

    return {
        form,
        setTipoDocumento,
        limpiarTipoDocumento,
    };
};
