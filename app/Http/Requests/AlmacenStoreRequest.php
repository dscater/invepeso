<?php

namespace App\Http\Requests;

use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;

class AlmacenStoreRequest extends FormRequest
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
            "sucursal_id" => "required",
            "nombre" => "required|string|unique:almacens,nombre",
            "activo" => "required",
            "descripcion" => "nullable|string"
        ];
    }

    /**
     * Mensajes de validacion
     *
     * @return array
     */
    public function messages(): array
    {
        return [
            "sucursal_id.required" => "Debes completar este campo",
            "nombre.required" => "Debes completar este campo",
            "nombre.string" => "Debes ingresar un texto valido",
            "nombre.unique" => "Este nombre ya fue registrado",
            "descripcion.string" => "Debes ingresar un texto valido"
        ];
    }
}
