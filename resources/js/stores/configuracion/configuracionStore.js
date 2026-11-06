import axios from "axios";
import { defineStore } from "pinia";

export const useConfiguracionStore = defineStore("configuracion", {
    state: () => ({
        oConfiguracion: {
            sistema: "SVT",
            alias: "SVT",
            url_logo: "",
        },
        configuracionCargada: false,
        configuracionCargando: false,
    }),

    actions: {
        async initConfiguracion(forzar = false) {
            if (this.configuracionCargada && !forzar) {
                return;
            }

            if (this.configuracionCargando) {
                return;
            }

            this.configuracionCargando = true;

            try {
                const response = await axios.get(
                    route("configuracions.getConfiguracion"),
                    { timeout: 10000 },
                );

                this.setConfiguracion(response.data.configuracion);

                this.configuracionCargada = true;
                console.log("Configuración cargada");
            } catch (error) {
                console.error("Error al cargar la configuración:", error);
            } finally {
                this.configuracionCargando = false;
            }
        },

        setConfiguracion(value) {
            this.oConfiguracion = { ...value };
        },
    },

    getters: {
        getConfiguracion: (state) => state.oConfiguracion,
    },
});
