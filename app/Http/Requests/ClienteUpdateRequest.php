<?php

namespace App\Http\Requests;

use App\Rules\ClienteCiComplementoRule;
use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;

class ClienteUpdateRequest extends FormRequest
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
        $rule = [
            "nombre" => "required|string",
            "tipo_documento_id" => "required",
            "nro_documento" => [
                "required",
                new ClienteCiComplementoRule($this->tipo_documento_id, $this->complemento, $this->cliente->id)
            ],
            "complemento" => "nullable",
            "fono" => "nullable",
            "correo" => "nullable",
        ];
        return $rule;
    }
    public function messages(): array
    {
        return [
            "nombre.required" => "Debes completar este campo",
            "nombre.string" => "Debes ingresar un texto valido",
            "tipo_documento_id.string" => "Debes ingresar un texto valido",
            "nro_documento.required" => "Debes completar este campo",
        ];
    }
}
