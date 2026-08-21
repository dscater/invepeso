<?php

namespace App\Http\Requests;

use App\Rules\IngresoDetalleRule;
use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;

class IngresoProductoStoreRequest extends FormRequest
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
            "tipo_ingreso_id" => "required",
            "proveedor_id" => "required",
            "descripcion" => "nullable",
            "total" => "required",
            "cancelado" => "required",
            "saldo" => "required",
            "ingreso_detalles" => ["required", new IngresoDetalleRule()],
        ];
    }

    public function messages()
    {
        return [
            "sucursal_id.required" => "Debes indicar la sucursal",
            "tipo_ingreso_id.required" => "Debes seleccionar el tipo de ingreso",
            "proveedor_id.required" => "Debes seleccionar un proveedor",
            "descripcion.required" => "Debes completar este campo",
            "total.required" => "No se encontró el total de la compra",
            "cancelado.required" => "Debes ingresar el valor cancelado",
            "saldo.required" => "No se encontró el saldo de la compra",
        ];
    }
}
