<script setup>
import { computed, onMounted, onUnmounted, ref } from "vue";

const props = defineProps({
    rows: {
        type: Number,
        default: 8,
    },

    columns: {
        type: Number,
        default: 5,
    },

    responsive: {
        type: Boolean,
        default: false,
    },

    responsiveBreakpoint: {
        type: [Number, String],
        default: 768,
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

    theme: {
        type: String,
        default: "auto",
        validator(value) {
            return ["auto", "light", "dark"].includes(value);
        },
    },

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
});

const isResponsiveViewport = ref(false);

let mediaQuery = null;

const rowsList = computed(() => {
    const total = Math.max(1, Number(props.rows) || 1);

    return Array.from({ length: total }, (_, index) => index + 1);
});

const columnsList = computed(() => {
    const total = Math.max(1, Number(props.columns) || 1);

    return Array.from({ length: total }, (_, index) => index + 1);
});

const actionsList = computed(() => {
    const total = Math.max(1, Number(props.actionCount) || 1);

    return Array.from({ length: total }, (_, index) => index + 1);
});

const breakpoint = computed(() => {
    const value = String(props.responsiveBreakpoint);

    return value.endsWith("px") ? value : `${value}px`;
});

const showResponsiveCards = computed(() => {
    return props.responsive && isResponsiveViewport.value;
});

const styleVars = computed(() => {
    const styles = {};

    if (props.baseColor) {
        styles["--skeleton-base"] = props.baseColor;
    }

    if (props.highlightColor) {
        styles["--skeleton-highlight"] = props.highlightColor;
    }

    if (props.borderColor) {
        styles["--skeleton-border"] = props.borderColor;
    }

    if (props.surfaceColor) {
        styles["--skeleton-surface"] = props.surfaceColor;
    }

    return styles;
});

const skeletonClasses = computed(() => [
    `mi-table-skeleton--${props.theme}`,
    {
        "mi-table-skeleton--compact": props.compact,
    },
]);

function updateResponsiveState() {
    if (mediaQuery) {
        isResponsiveViewport.value = mediaQuery.matches;
    }
}

onMounted(() => {
    if (!props.responsive) {
        return;
    }

    mediaQuery = window.matchMedia(`(max-width: ${breakpoint.value})`);

    updateResponsiveState();

    if (mediaQuery.addEventListener) {
        mediaQuery.addEventListener("change", updateResponsiveState);
    } else {
        mediaQuery.addListener(updateResponsiveState);
    }
});

onUnmounted(() => {
    if (!mediaQuery) {
        return;
    }

    if (mediaQuery.removeEventListener) {
        mediaQuery.removeEventListener("change", updateResponsiveState);
    } else {
        mediaQuery.removeListener(updateResponsiveState);
    }

    mediaQuery = null;
});
</script>

<template>
    <div
        class="mi-table-skeleton"
        :class="skeletonClasses"
        :style="styleVars"
        role="status"
        aria-label="Cargando registros"
    >
        <div v-if="props.showToolbar" class="mi-skeleton-toolbar">
            <div class="mi-skeleton-block mi-skeleton-title" />

            <div class="mi-skeleton-block mi-skeleton-button" />
        </div>

        <div v-if="!showResponsiveCards" class="mi-skeleton-table-wrapper">
            <table class="mi-skeleton-table">
                <thead>
                    <tr>
                        <th v-for="column in columnsList" :key="column">
                            <div
                                class="mi-skeleton-block mi-skeleton-header"
                                :class="{
                                    'mi-skeleton-header-short': column === 1,

                                    'mi-skeleton-header-long':
                                        column === columnsList.length,
                                }"
                            />
                        </th>
                    </tr>
                </thead>

                <tbody>
                    <tr v-for="row in rowsList" :key="row">
                        <td v-for="column in columnsList" :key="column">
                            <div
                                v-if="column === 1 && props.showAvatar"
                                class="mi-skeleton-cell-content"
                            >
                                <div
                                    class="mi-skeleton-block mi-skeleton-avatar"
                                />

                                <div
                                    class="mi-skeleton-block mi-skeleton-text mi-skeleton-text-medium"
                                />
                            </div>

                            <div
                                v-else-if="
                                    column === columnsList.length &&
                                    props.showActions
                                "
                                class="mi-skeleton-actions"
                            >
                                <div
                                    v-for="action in actionsList"
                                    :key="action"
                                    class="mi-skeleton-block mi-skeleton-action"
                                />
                            </div>

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

        <div v-else class="mi-skeleton-cards-wrapper">
            <article
                v-for="row in rowsList"
                :key="row"
                class="mi-skeleton-card"
            >
                <div
                    v-for="column in columnsList"
                    :key="column"
                    class="mi-skeleton-card-row"
                >
                    <div class="mi-skeleton-block mi-skeleton-card-label" />

                    <div
                        v-if="column === 1 && props.showAvatar"
                        class="mi-skeleton-card-value-content"
                    >
                        <div class="mi-skeleton-block mi-skeleton-avatar" />

                        <div
                            class="mi-skeleton-block mi-skeleton-text mi-skeleton-text-medium"
                        />
                    </div>

                    <div
                        v-else-if="
                            column === columnsList.length && props.showActions
                        "
                        class="mi-skeleton-actions"
                    >
                        <div
                            v-for="action in actionsList"
                            :key="action"
                            class="mi-skeleton-block mi-skeleton-action"
                        />
                    </div>

                    <div
                        v-else
                        class="mi-skeleton-block mi-skeleton-card-value"
                    />
                </div>
            </article>
        </div>

        <div v-if="props.showPagination" class="mi-skeleton-pagination">
            <div class="mi-skeleton-block mi-skeleton-page-info" />

            <div class="mi-skeleton-pagination-buttons">
                <div
                    v-for="page in 4"
                    :key="page"
                    class="mi-skeleton-block mi-skeleton-page"
                />
            </div>
        </div>
    </div>
</template>
<style scoped>
.mi-table-skeleton {
    --skeleton-surface: #ffffff;
    --skeleton-base: #e5e7eb;
    --skeleton-highlight: #ffffff;
    --skeleton-border: #d1d5db;
    --skeleton-text: #6b7280;

    width: 100%;
    padding: 16px;
    overflow: hidden;

    color: var(--skeleton-text);
    background: var(--skeleton-surface);
    border: 1px solid var(--skeleton-border);
    border-radius: 8px;
}

/*
|--------------------------------------------------------------------------
| Temas
|--------------------------------------------------------------------------
*/

.mi-table-skeleton--light {
    --skeleton-surface: #ffffff;
    --skeleton-base: #e5e7eb;
    --skeleton-highlight: #ffffff;
    --skeleton-border: #d1d5db;
    --skeleton-text: #4b5563;
}

.mi-table-skeleton--dark {
    --skeleton-surface: #111827;
    --skeleton-base: #374151;
    --skeleton-highlight: #6b7280;
    --skeleton-border: #4b5563;
    --skeleton-text: #d1d5db;
}

.mi-table-skeleton--auto {
    --skeleton-surface: var(--el-bg-color, #ffffff);

    --skeleton-base: var(--el-fill-color, #e5e7eb);

    --skeleton-highlight: var(--el-fill-color-light, #ffffff);

    --skeleton-border: var(--el-border-color-lighter, #d1d5db);

    --skeleton-text: var(--el-text-color-secondary, #6b7280);
}

@media (prefers-color-scheme: dark) {
    .mi-table-skeleton--auto {
        --skeleton-surface: #111827;
        --skeleton-base: #374151;
        --skeleton-highlight: #6b7280;
        --skeleton-border: #4b5563;
        --skeleton-text: #d1d5db;
    }
}

/*
|--------------------------------------------------------------------------
| Bloques animados
|--------------------------------------------------------------------------
*/

.mi-skeleton-block {
    position: relative;
    overflow: hidden;

    background: var(--skeleton-base);
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
        var(--skeleton-highlight) 50%,
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
    margin-bottom: 18px;
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

    border: 1px solid var(--skeleton-border);
    border-radius: 6px;
}

.mi-skeleton-table {
    width: 100%;
    min-width: 600px;
    border-collapse: collapse;
}

.mi-skeleton-table th {
    padding: 15px 12px;

    background: var(--skeleton-base);
    border-bottom: 1px solid var(--skeleton-border);
}

.mi-skeleton-table td {
    padding: 15px 12px;
    border-bottom: 1px solid var(--skeleton-border);
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
| Cards responsive
|--------------------------------------------------------------------------
*/

.mi-skeleton-cards-wrapper {
    display: flex;
    flex-direction: column;
    gap: 12px;
}

.mi-skeleton-card {
    padding: 15px;

    background: var(--skeleton-surface);
    border: 1px solid var(--skeleton-border);
    border-radius: 8px;
}

.mi-skeleton-card-row {
    display: grid;
    grid-template-columns: minmax(85px, 35%) 1fr;
    align-items: center;
    gap: 14px;

    min-height: 42px;
    padding: 8px 0;

    border-bottom: 1px solid var(--skeleton-border);
}

.mi-skeleton-card-row:last-child {
    border-bottom: none;
}

.mi-skeleton-card-label {
    width: 70%;
    height: 13px;
}

.mi-skeleton-card-value {
    width: 85%;
    height: 15px;
}

.mi-skeleton-card-value-content {
    display: flex;
    align-items: center;
    gap: 10px;
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
| Compacto
|--------------------------------------------------------------------------
*/

.mi-table-skeleton--compact {
    padding: 10px;
}

.mi-table-skeleton--compact .mi-skeleton-table th,
.mi-table-skeleton--compact .mi-skeleton-table td {
    padding: 9px 10px;
}

.mi-table-skeleton--compact .mi-skeleton-card-row {
    min-height: 34px;
    padding: 6px 0;
}

.mi-table-skeleton--compact .mi-skeleton-avatar {
    width: 24px;
    min-width: 24px;
    height: 24px;
}

/*
|--------------------------------------------------------------------------
| Responsive real del skeleton
|--------------------------------------------------------------------------
*/

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

    .mi-skeleton-card-row {
        grid-template-columns: 1fr;
        align-items: flex-start;
        gap: 7px;
    }

    .mi-skeleton-card-label {
        width: 35%;
    }

    .mi-skeleton-card-value {
        width: 75%;
    }

    .mi-skeleton-pagination {
        flex-direction: column;
        align-items: flex-start;
    }
}

/*
|--------------------------------------------------------------------------
| Accesibilidad
|--------------------------------------------------------------------------
*/

@media (prefers-reduced-motion: reduce) {
    .mi-skeleton-block::after {
        animation: none;
    }
}

.mi-skeleton-sr-only {
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
</style>
