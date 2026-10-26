import { defineStore } from "pinia";
import { onBeforeUnmount, onMounted, ref } from "vue";
import { router } from "@inertiajs/vue3";
import Swal from "sweetalert2";

export const useAuthStore = defineStore("auth", () => {
    const cerrandoSesion = ref(false);

    const salir = async ({ confirmar = true } = {}) => {
        if (cerrandoSesion.value) return;

        if (confirmar) {
            const result = await Swal.fire({
                icon: "question",
                title: "Cerrar sesión",
                text: "¿Está seguro(a) de cerrar sesión?",
                showCancelButton: true,
                confirmButtonText: "Sí, salir",
                cancelButtonText: "Cancelar",
            });

            if (!result.isConfirmed) return;
        }

        cerrandoSesion.value = true;

        try {
            await axios.post(route("logout"));

            if (typeof router.clearHistory === "function") {
                router.clearHistory();
            }

            window.location.replace("/");
        } catch (error) {
            cerrandoSesion.value = false;

            await Swal.fire({
                icon: "error",
                title: "No se pudo cerrar la sesión",
                text: "Verifique su conexión e inténtelo nuevamente.",
            });
        }
    };
    const handlePageShow = (event) => {
        if (event.persisted) {
            window.location.reload();
        }
    };

    onMounted(() => {
        window.addEventListener("pageshow", handlePageShow);
    });

    onBeforeUnmount(() => {
        window.removeEventListener("pageshow", handlePageShow);
    });

    return {
        cerrandoSesion,
        salir,
    };
});
