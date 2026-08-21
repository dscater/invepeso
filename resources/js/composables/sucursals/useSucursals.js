import { useForm } from "@inertiajs/vue3";

export const useSucursals = () => {
    const initialState = {
        id: 0,
        nombre: "",
        descripcion: "",
        activo: 1,
        ventas: 1,
        _method: "POST",
    };

    const form = useForm({ ...initialState });

    const setSucursal = (item) => {
        form.clearErrors();
        form.reset();
        Object.assign(form, item);
        form._method = "PUT";
    };

    const limpiarSucursal = () => {
        form.clearErrors();
        form.reset();
        form.defaults({ ...initialState });
    };

    return {
        form,
        setSucursal,
        limpiarSucursal,
    };
};
