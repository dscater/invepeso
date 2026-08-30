<?php

namespace App\Rules;

use App\Models\IngresoDetalle;
use Closure;
use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Translation\PotentiallyTranslatedString;

class IngresoDetalleFaltantesRule implements ValidationRule
{
    /**
     * Run the validation rule.
     *
     * @param  Closure(string, ?string=): PotentiallyTranslatedString  $fail
     */
    public function validate(string $attribute, mixed $value, Closure $fail): void
    {
        if (!is_array($value)) {
            $fail('Debes ingresar al menos 1 producto');
            return;
        }

        foreach ($value as $index => $detalle) {
            $item = IngresoDetalle::findOrFail($detalle["id"]);
            if ($item->faltantes <= 0) {
                continue;
            }
            // precio
            if ($detalle['repuesto'] != "" && (float)$detalle["repuesto"] > (float) $detalle['faltantes']) {
                $fail("La cantidad repuesta del producto " . ($index + 1) . " no puede ser superior a los faltantes.");
            }

            // if ($detalle['repuesto'] === "" || $detalle['repuesto'] === null) {
            //     $fail("La cantidad repuesta del producto " . ($index + 1) . " es obligatorio.");
            // }

            // if (!is_numeric($detalle['repuesto']) || $detalle['repuesto'] < 1) {
            //     $fail("La cantidad repuesta del producto " . ($index + 1) . " debe ser mayor a 0.");
            // }
        }
    }
}
