<?php

namespace App\Rules;

use Closure;
use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Translation\PotentiallyTranslatedString;

class IngresoDetalleVerificarRule implements ValidationRule
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
            // precio
            if ($detalle['verificado'] === "" || $detalle['verificado'] === null) {
                $fail("La cantidad recibida del producto " . ($index + 1) . " es obligatorio.");
            }

            if (!is_numeric($detalle['verificado']) || $detalle['verificado'] < 1) {
                $fail("La cantidad recibida del producto " . ($index + 1) . " debe ser mayor a 0.");
            }
            // faltantes
            if ($detalle['faltantes'] === "" || $detalle['faltantes'] === null) {
                $fail("El valor de faltantes del producto " . ($index + 1) . " es obligatorio.");
            }
        }
    }
}
