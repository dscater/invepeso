<?php

namespace App\Rules;

use App\Models\Almacen;
use App\Models\Producto;
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
            $producto = Producto::find($detalle["producto_id"]);

            $count_recepcions = count($detalle["ingreso_recepcions"]);
            if ($count_recepcions < 1) {
                $fail("Debes agregar al menos 1 almacén en el producto {$producto->nombre}.");
            }

            foreach ($detalle["ingreso_recepcions"] as $key_recepcion => $recepcion) {
                // almacen_id
                if ($recepcion['almacen_id'] === "" || $recepcion['almacen_id'] === null) {
                    $fail("El almacén del producto {$producto->nombre} es obligatorio.");
                }
                $almacen = Almacen::find($recepcion["almacen_id"]);
                // cantidad
                if (!is_numeric($recepcion['cantidad']) || $recepcion['cantidad'] <= 0) {
                    $fail("La cantidad del producto {$producto->nombre}, en el almacén {$almacen->nombre} es obligatorio.");
                }
            }
        }
    }
}
