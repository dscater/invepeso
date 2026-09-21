import { useForm } from "@inertiajs/vue3";
import { onMounted, ref } from "vue";

export const useClienteProductos = () => {
    const initialState = {
        id: 0,
        cliente_id: "",
        producto_id: "",
        precio: 0,
        _method: "POST",
    };

    const form = useForm({ ...initialState });

    const setClienteProducto = (item = null) => {
        form.clearErrors();
        form.reset();
        Object.assign(form, item);
        form._method = "PUT";
    };

    const limpiarClienteProducto = () => {
        form.clearErrors();
        form.reset();
        form.defaults({ ...initialState });
    };

    onMounted(() => {});

    return {
        form,
        setClienteProducto,
        limpiarClienteProducto,
    };
};
