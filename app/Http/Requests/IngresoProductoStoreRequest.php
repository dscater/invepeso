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
            "codigo" => "required|unique:ingreso_productos,codigo",
            "almacen_id" => "required",
            "tipo_ingreso_id" => "required",
            "proveedor_id" => "required",
            "descripcion" => "nullable",
            "total" => "required",
            "cancelado_efectivo" => "required|decimal:0,2|min:0",
            "cancelado_qr" => "required|decimal:0,2|min:0",
            "saldo" => "required",
            "ingreso_detalles" => ["required", new IngresoDetalleRule()],
        ];
    }

    public function messages()
    {
        return [
            "codigo.required" => "Debes ingresar el código de ingreso",
            "codigo.unique" => "Este código de ingreso ya fue registrado",
            "almacen_id.required" => "Debes indicar el almacén",
            "tipo_ingreso_id.required" => "Debes seleccionar el tipo de ingreso",
            "proveedor_id.required" => "Debes seleccionar un proveedor",
            "descripcion.required" => "Debes completar este campo",
            "total.required" => "No se encontró el total de la compra",
            "cancelado_efectivo.required" => "Debes completar el campo de cancelado en efectivo.",
            "cancelado_efectivo.decimal" => "Debes ingresar un valor númerico de hasta 2 decimales",
            "cancelado_efectivo.min" => "Debes ingresar un valor númerico no puede ser menor :min",
            "cancelado_qr.required" => "Debes completar el campo de cancelado en qr.",
            "cancelado_qr.decimal" => "Debes ingresar un valor númerico de hasta 2 decimales",
            "cancelado_qr.min" => "Debes ingresar un valor númerico no puede ser menor :min",
            "saldo.required" => "No se encontró el saldo de la compra",
        ];
    }
}
