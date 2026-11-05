<script setup>
import { computed } from "vue";

const props = defineProps({
    rows: {
        type: Number,
        default: 8,
    },

    columns: {
        type: Number,
        default: 5,
    },

    showToolbar: {
        type: Boolean,
        default: true,
    },

    showPagination: {
        type: Boolean,
        default: true,
    },

    showAvatar: {
        type: Boolean,
        default: false,
    },

    showActions: {
        type: Boolean,
        default: true,
    },

    actionCount: {
        type: Number,
        default: 3,
    },

    compact: {
        type: Boolean,
        default: false,
    },

    /**
     * auto:
     *   Usa variables de Element Plus y respeta prefers-color-scheme.
     *
     * light:
     *   Para fondos blancos o claros.
     *
     * dark:
     *   Para fondos negros u oscuros.
     */
    theme: {
        type: String,
        default: "auto",
        validator: (value) => ["auto", "light", "dark"].includes(value),
    },

    /**
     * Si se define, sobrescribe los colores del tema.
     */
    baseColor: {
        type: String,
        default: "",
    },

    highlightColor: {
        type: String,
        default: "",
    },

    borderColor: {
        type: String,
        default: "",
    },

    surfaceColor: {
        type: String,
        default: "",
    },

    minWidth: {
        type: [String, Number],
        default: "650px",
    },
});

const skeletonColumns = computed(() => {
    return Math.max(1, Number(props.columns) || 1);
});

const skeletonRows = computed(() => {
    return Math.max(1, Number(props.rows) || 1);
});

const skeletonActions = computed(() => {
    return Math.max(1, Number(props.actionCount) || 1);
});

const styleVars = computed(() => {
    const styles = {};

    if (props.baseColor) {
        styles["--mi-skeleton-base"] = props.baseColor;
    }

    if (props.highlightColor) {
        styles["--mi-skeleton-highlight"] = props.highlightColor;
    }

    if (props.borderColor) {
        styles["--mi-skeleton-border"] = props.borderColor;
    }

    if (props.surfaceColor) {
        styles["--mi-skeleton-surface"] = props.surfaceColor;
    }

    styles["--mi-skeleton-min-width"] =
        typeof props.minWidth === "number"
            ? `${props.minWidth}px`
            : props.minWidth;

    return styles;
});
</script>

<template>
    <div
        class="mi-table-skeleton"
        :class="[
            `mi-table-skeleton--${theme}`,
            {
                'mi-table-skeleton--compact': compact,
            },
        ]"
        :style="styleVars"
        role="status"
        aria-label="Cargando tabla"
    >
        <!-- Toolbar -->
        <div v-if="showToolbar" class="mi-skeleton-toolbar">
            <div class="mi-skeleton-block mi-skeleton-title" />

            <div class="mi-skeleton-block mi-skeleton-button" />
        </div>

        <!-- Tabla -->
        <div class="mi-skeleton-table-wrapper">
            <table class="mi-skeleton-table">
                <thead>
                    <tr>
                        <th
                            v-for="column in skeletonColumns"
                            :key="`header-${column}`"
                        >
                            <div
                                class="mi-skeleton-block mi-skeleton-header"
                                :class="{
                                    'mi-skeleton-header-short': column === 1,
                                    'mi-skeleton-header-long':
                                        column === skeletonColumns,
                                }"
                            />
                        </th>
                    </tr>
                </thead>

                <tbody>
                    <tr v-for="row in skeletonRows" :key="`row-${row}`">
                        <td
                            v-for="column in skeletonColumns"
                            :key="`cell-${row}-${column}`"
                        >
                            <!-- Primera columna -->
                            <div
                                v-if="column === 1 && showAvatar"
                                class="mi-skeleton-cell-content"
                            >
                                <div
                                    class="mi-skeleton-block mi-skeleton-avatar"
                                />

                                <div
                                    class="mi-skeleton-block mi-skeleton-text mi-skeleton-text-medium"
                                />
                            </div>

                            <!-- Última columna -->
                            <div
                                v-else-if="
                                    column === skeletonColumns && showActions
                                "
                                class="mi-skeleton-actions"
                            >
                                <div
                                    v-for="action in skeletonActions"
                                    :key="`action-${row}-${action}`"
                                    class="mi-skeleton-block mi-skeleton-action"
                                />
                            </div>

                            <!-- Celdas normales -->
                            <div
                                v-else
                                class="mi-skeleton-block mi-skeleton-text"
                                :class="{
                                    'mi-skeleton-text-short': column % 3 === 0,
                                    'mi-skeleton-text-long': column % 3 === 1,
                                }"
                            />
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- Paginación -->
        <div v-if="showPagination" class="mi-skeleton-pagination">
            <div class="mi-skeleton-block mi-skeleton-page-info" />

            <div class="mi-skeleton-pagination-buttons">
                <div
                    v-for="page in 4"
                    :key="`page-${page}`"
                    class="mi-skeleton-block mi-skeleton-page"
                />
            </div>
        </div>

        <span class="sr-only"> Cargando registros... </span>
    </div>
</template>

<style scoped>
.mi-table-skeleton {
    --mi-skeleton-surface: #ffffff;
    --mi-skeleton-base: #e5e7eb;
    --mi-skeleton-highlight: #f8fafc;
    --mi-skeleton-border: #d1d5db;
    --mi-skeleton-text: #6b7280;

    width: 100%;
    min-width: 0;
    padding: 16px;
    overflow: hidden;

    color: var(--mi-skeleton-text);
    background: var(--mi-skeleton-surface);
    border: 1px solid var(--mi-skeleton-border);
    border-radius: 8px;
}

/*
|--------------------------------------------------------------------------
| Tema claro
|--------------------------------------------------------------------------
*/

.mi-table-skeleton--light {
    --mi-skeleton-surface: #ffffff;
    --mi-skeleton-base: #e5e7eb;
    --mi-skeleton-highlight: #ffffff;
    --mi-skeleton-border: #d1d5db;
    --mi-skeleton-text: #4b5563;
}

/*
|--------------------------------------------------------------------------
| Tema oscuro
|--------------------------------------------------------------------------
*/

.mi-table-skeleton--dark {
    --mi-skeleton-surface: #111827;
    --mi-skeleton-base: #374151;
    --mi-skeleton-highlight: #6b7280;
    --mi-skeleton-border: #4b5563;
    --mi-skeleton-text: #d1d5db;
}

/*
|--------------------------------------------------------------------------
| Tema automático
|--------------------------------------------------------------------------
*/

.mi-table-skeleton--auto {
    --mi-skeleton-surface: var(--el-bg-color, #ffffff);

    --mi-skeleton-base: var(--el-fill-color, #e5e7eb);

    --mi-skeleton-highlight: var(--el-fill-color-light, #f8fafc);

    --mi-skeleton-border: var(--el-border-color-lighter, #d1d5db);

    --mi-skeleton-text: var(--el-text-color-secondary, #6b7280);
}

@media (prefers-color-scheme: dark) {
    .mi-table-skeleton--auto {
        --mi-skeleton-surface: #111827;
        --mi-skeleton-base: #374151;
        --mi-skeleton-highlight: #6b7280;
        --mi-skeleton-border: #4b5563;
        --mi-skeleton-text: #d1d5db;
    }
}

/*
|--------------------------------------------------------------------------
| Bloques y animación
|--------------------------------------------------------------------------
*/

.mi-skeleton-block {
    position: relative;
    overflow: hidden;

    background: var(--mi-skeleton-base);
    border-radius: 5px;
}

.mi-skeleton-block::after {
    content: "";
    position: absolute;
    inset: 0;

    background: linear-gradient(
        105deg,
        transparent 0%,
        transparent 35%,
        var(--mi-skeleton-highlight) 50%,
        transparent 65%,
        transparent 100%
    );

    transform: translateX(-100%);
    animation: mi-skeleton-shimmer 1.35s cubic-bezier(0.4, 0, 0.2, 1) infinite;
}

@keyframes mi-skeleton-shimmer {
    100% {
        transform: translateX(100%);
    }
}

/*
|--------------------------------------------------------------------------
| Toolbar
|--------------------------------------------------------------------------
*/

.mi-skeleton-toolbar {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 15px;
    margin-bottom: 20px;
}

.mi-skeleton-title {
    width: 180px;
    height: 25px;
}

.mi-skeleton-button {
    width: 110px;
    height: 35px;
    border-radius: 6px;
}

/*
|--------------------------------------------------------------------------
| Tabla
|--------------------------------------------------------------------------
*/

.mi-skeleton-table-wrapper {
    width: 100%;
    overflow-x: auto;

    border: 1px solid var(--mi-skeleton-border);
    border-radius: 6px;
}

.mi-skeleton-table {
    width: 100%;
    min-width: var(--mi-skeleton-min-width);
    border-collapse: collapse;
}

.mi-skeleton-table th {
    padding: 15px 12px;
    background: color-mix(
        in srgb,
        var(--mi-skeleton-base) 35%,
        var(--mi-skeleton-surface)
    );

    border-bottom: 1px solid var(--mi-skeleton-border);
}

.mi-skeleton-table td {
    padding: 15px 12px;
    border-bottom: 1px solid var(--mi-skeleton-border);
}

.mi-skeleton-table tbody tr:last-child td {
    border-bottom: none;
}

.mi-skeleton-header {
    width: 75%;
    height: 15px;
}

.mi-skeleton-header-short {
    width: 45%;
}

.mi-skeleton-header-long {
    width: 90%;
}

.mi-skeleton-cell-content {
    display: flex;
    align-items: center;
    gap: 10px;
}

.mi-skeleton-avatar {
    width: 30px;
    min-width: 30px;
    height: 30px;
    border-radius: 50%;
}

.mi-skeleton-text {
    width: 75%;
    height: 14px;
}

.mi-skeleton-text-short {
    width: 45%;
}

.mi-skeleton-text-medium {
    width: 65%;
}

.mi-skeleton-text-long {
    width: 90%;
}

.mi-skeleton-actions {
    display: flex;
    align-items: center;
    gap: 7px;
}

.mi-skeleton-action {
    width: 23px;
    height: 23px;
    border-radius: 5px;
}

/*
|--------------------------------------------------------------------------
| Paginación
|--------------------------------------------------------------------------
*/

.mi-skeleton-pagination {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 15px;
    margin-top: 18px;
}

.mi-skeleton-page-info {
    width: 130px;
    height: 14px;
}

.mi-skeleton-pagination-buttons {
    display: flex;
    gap: 7px;
}

.mi-skeleton-page {
    width: 30px;
    height: 30px;
    border-radius: 5px;
}

/*
|--------------------------------------------------------------------------
| Modo compacto
|--------------------------------------------------------------------------
*/

.mi-table-skeleton--compact {
    padding: 10px;
}

.mi-table-skeleton--compact .mi-skeleton-table th,
.mi-table-skeleton--compact .mi-skeleton-table td {
    padding: 9px 10px;
}

.mi-table-skeleton--compact .mi-skeleton-avatar {
    width: 24px;
    min-width: 24px;
    height: 24px;
}

.mi-table-skeleton--compact .mi-skeleton-action {
    width: 20px;
    height: 20px;
}

/*
|--------------------------------------------------------------------------
| Accesibilidad y responsive
|--------------------------------------------------------------------------
*/

.sr-only {
    position: absolute;
    width: 1px;
    height: 1px;
    padding: 0;
    margin: -1px;
    overflow: hidden;
    clip: rect(0, 0, 0, 0);
    white-space: nowrap;
    border: 0;
}

@media (max-width: 576px) {
    .mi-table-skeleton {
        padding: 10px;
    }

    .mi-skeleton-toolbar {
        flex-wrap: wrap;
    }

    .mi-skeleton-title {
        width: 140px;
    }

    .mi-skeleton-pagination {
        flex-direction: column;
        align-items: flex-start;
    }
}
</style>
