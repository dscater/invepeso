import { useForm } from "@inertiajs/vue3";
import { onMounted, ref } from "vue";

export const useProductos = () => {
    const initialState = {
        id: 0,
        codigo: "",
        nombre: "",
        categoria_id: "",
        marca_id: "",
        unidad_medida_id: "",
        precio: 0,
        precio2: null,
        precio3: null,
        precio4: null,
        precio_compra: 0,
        stock_min: "",
        imagen: "",
        fecha_registro: "",
        activo: 1,
        _method: "POST",
    };

    const form = useForm({ ...initialState });

    const setProducto = (item = null) => {
        form.clearErrors();
        form.reset();
        Object.assign(form, item);
        form._method = "PUT";
    };

    const limpiarProducto = () => {
        form.clearErrors();
        form.reset();
        form.defaults({ ...initialState });
    };

    onMounted(() => {});

    return {
        form,
        setProducto,
        limpiarProducto,
    };
};
