<?php

namespace App\Rules;

use Closure;
use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Translation\PotentiallyTranslatedString;

class ClienteCiComplementoRule implements ValidationRule
{

    protected $tipo_documento_id;
    protected $complemento;
    protected $ignoreId;

    public function __construct($tipo_documento_id, $complemento, $ignoreId = null)
    {
        $this->tipo_documento_id = $tipo_documento_id;
        $this->complemento = $complemento;
        $this->ignoreId = $ignoreId;
    }

    /**
     * Run the validation rule.
     *
     * @param  Closure(string, ?string=): PotentiallyTranslatedString  $fail
     */
    public function validate(string $attribute, mixed $value, Closure $fail): void
    {
        $query = DB::table('clientes')
            ->where('nro_documento', $value);

        // SOLO PARA CI
        if ($this->tipo_documento_id == 1) {
            // Manejo correcto de null o vacío
            if (($this->complemento === null || $this->complemento === '')) {
                $query->where(function ($q) {
                    $q->whereNull('complemento')
                        ->orWhere('complemento', '');
                });
            } else {
                $query->where('complemento', $this->complemento);
            }

            if ($this->ignoreId) {
                $query->where('id', '!=', $this->ignoreId);
            }

            if ($query->exists()) {
                if ($this->complemento === null || $this->complemento === '') {
                    $fail('El nro. de C.I. ya fue registrado.');
                } else {
                    $fail('El nro. de C.I. con complemento ya existe.');
                }
            }
        } else {
            if ($this->ignoreId) {
                $query->where('id', '!=', $this->ignoreId);
            }
            if ($query->exists()) {
                $fail('Este nro. de documento ya fue registrado.');
            }
        }
    }
}
