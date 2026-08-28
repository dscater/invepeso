import { useForm } from "@inertiajs/vue3";

export const useAlmacens = () => {
    const initialState = {
        id: 0,
        sucursal_id: null,
        nombre: "",
        descripcion: "",
        activo: 1,
        _method: "POST",
    };

    const form = useForm({ ...initialState });

    const setAlmacen = (item) => {
        form.clearErrors();
        form.reset();
        Object.assign(form, item);
        form._method = "PUT";
    };

    const limpiarAlmacen = () => {
        form.clearErrors();
        form.reset();
        form.defaults({ ...initialState });
    };

    return {
        form,
        setAlmacen,
        limpiarAlmacen,
    };
};
