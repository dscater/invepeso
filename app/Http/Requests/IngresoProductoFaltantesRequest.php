<?php

namespace App\Http\Requests;

use App\Rules\IngresoDetalleFaltantesRule;
use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;

class IngresoProductoFaltantesRequest extends FormRequest
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
            "almacen_id" => "required",
            "descripcion" => "nullable",
            "total" => "required",
            "cancelado" => "required",
            "saldo" => "required",
            "ingreso_detalles" => ["required", new IngresoDetalleFaltantesRule()],
        ];
    }

    public function messages()
    {
        return [
            "almacen_id.required" => "Debes indicar la sucursal",
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
