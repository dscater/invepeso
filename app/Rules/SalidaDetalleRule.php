<?php

namespace App\Rules;

use Closure;
use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Translation\PotentiallyTranslatedString;

class SalidaDetalleRule implements ValidationRule
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
            // tipo_salida
            if ($detalle['tipo_salida_id'] === "" || $detalle['tipo_salida_id'] === null) {
                $fail("El tipo de salida del producto " . ($index + 1) . " es obligatorio.");
            }

            // cantidad
            if ($detalle['cantidad'] === "" || $detalle['cantidad'] === null) {
                $fail("La cantidad del producto " . ($index + 1) . " es obligatorio.");
            }

            if (!is_numeric($detalle['cantidad']) || $detalle['cantidad'] < 0) {
                $fail("La cantidad del producto " . ($index + 1) . " debe ser mayor a 0.");
            }
        }
    }
}
