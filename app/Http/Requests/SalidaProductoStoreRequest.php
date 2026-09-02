<?php

namespace App\Http\Requests;

use App\Rules\SalidaDetalleRule;
use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;

class SalidaProductoStoreRequest extends FormRequest
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
            "almacen_id" => "required",
            "tipo_salida_id" => "nullable",
            "descripcion" => "nullable",
            "cantidad" => "required",
            "salida_detalles" => ["required", new SalidaDetalleRule()],
        ];
    }

    public function messages()
    {
        return [
            "almacen_id.required" => "Debes indicar el almacén",
            "tipo_salida_id.required" => "Debes seleccionar el tipo de salida",
            "descripcion.required" => "Debes completar este campo",
            "cantidad.required" => "No se encontró el total de la compra",
        ];
    }
}
