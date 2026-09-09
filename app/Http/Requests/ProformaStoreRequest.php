<?php

namespace App\Http\Requests;

use App\Rules\ProformaDetalleRule;
use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;

class ProformaStoreRequest extends FormRequest
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
            "tipo_documento_id" => "nullable",
            "descripcion" => "nullable",
            "descuento" => "nullable|numeric|min:0",
            "porcentaje_descuento" => "nullable|numeric|min:0",
            "subtotal" => "required|numeric|min:0",
            "total" => "required|numeric|min:0",
            "saldo" => "nullable|numeric|min:0",
            "cancelado" => "nullable|numeric|min:0",
            "proforma_detalles" => ["required", new ProformaDetalleRule()],
        ];

        return $rules;
    }

    public function messages()
    {
        return [
            "almacen_id.required" => "Debes indicar el almacén",
            "cliente_id.required" => "Debes seleccionar el cliente",
            "tipo_documento_id.required" => "Debes seleccionar el tipo de documento",
            "descripcion.required" => "Debes completar este campo",
            "cantidad.required" => "No se encontró el total de la compra",
            "tipo_pago.required" => "Debes seleccionar el tipo de pago",
            "total.required" => "El total de la proforma es obligatorio",
            "saldo.required" => "El saldo de la proforma es obligatorio",
            "saldo.numeric" => "El saldo debe ser un valor númerico",
            "descuento.numeric" => "El descuento debe ser un valor númerico",
            "cancelado.required" => "El total de la proforma es obligatorio",
            "cancelado.numeric" => "Cancelado debe ser un valor númerico",
        ];
    }
}
