<?php

namespace App\Http\Requests;

use App\Rules\CobroCertificadoDetalleRule;
use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;

class CobroRequest extends FormRequest
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
            "certificado_detalles" => ["required", new CobroCertificadoDetalleRule()],
            "tipo_pago" => "required",
        ];
    }

    public function messages(): array
    {
        return [
            "certificado_detalles.required" => "Debes completar este campo",
            "certificado_detalles.numeric" => "Debes ingresar un valor númerico",
            "certificado_detalles.decimal" => "Debes ingresar un valor con hasta 2 decimales",
            "certificado_detalles.min" => "Debes ingresar al menos :min",
            "tipo_pago.required" => "Debes seleccionar una opción"
        ];
    }
}
