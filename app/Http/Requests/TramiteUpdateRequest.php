<?php

namespace App\Http\Requests;

use App\Rules\TramiteClienteRule;
use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;

class TramiteUpdateRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            "tramitador_id" => "required",
            "sucursal_id" => "required",
            "tramite_clientes" => ["required", "array", "min:1", new TramiteClienteRule()],
            "eliminados" => "nullable",
        ];
    }

    public function messages(): array
    {
        return [
            "tramitador_id.required" => "Debes seleccionar al tramitador",
            "sucursal_id.required" => "Debes completar este campo",
            "tramite_clientes.required" => "Debes completar este campo",
        ];
    }
}
