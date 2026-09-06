<?php

namespace App\Http\Requests;

use App\Rules\VentaDetalleRule;
use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;

class VentaStoreRequest extends FormRequest
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
        $rules = [
            "almacen_id" => "required",
            "cliente_id" => "required",
            "tipo_venta" => "required",
            "tipo_documento_id" => "nullable",
            "descripcion" => "nullable",
            "descuento" => "nullable|numeric|min:0",
            "porcentaje_descuento" => "nullable|numeric|min:0",
            "subtotal" => "required|numeric|min:0",
            "total" => "required|numeric|min:0",
            "saldo" => "required|numeric|min:0",
            "cancelado" => "required|numeric|min:0",
            "venta_detalles" => ["required", new VentaDetalleRule()],
        ];

        if ($this->cancelado > 0) {
            $rules["tipo_pago"] = "required";
        }

        return $rules;
    }

    public function messages()
    {
        return [
            "almacen_id.required" => "Debes indicar el almacén",
            "cliente_id.required" => "Debes seleccionar el cliente",
            "tipo_venta.required" => "Debes seleccionar el tipo de venta",
            "tipo_documento_id.required" => "Debes seleccionar el tipo de documento",
            "descripcion.required" => "Debes completar este campo",
            "cantidad.required" => "No se encontró el total de la compra",
            "tipo_pago.required" => "Debes seleccionar el tipo de pago",
            "total.required" => "El total de la venta es obligatorio",
            "saldo.required" => "El total de la venta es obligatorio",
            "saldo.numeric" => "El saldo debe ser un valor númerico",
            "descuento.numeric" => "El descuento debe ser un valor númerico",
            "cancelado.required" => "El total de la venta es obligatorio",
            "cancelado.numeric" => "Cancelado debe ser un valor númerico",
        ];
    }
}
