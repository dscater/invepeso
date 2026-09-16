<?php

namespace App\Http\Requests;

use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;

class VentaCobroStoreRequest extends FormRequest
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
            "tipo_pago" => "required",
            "monto_efectivo" => "required|decimal:0,2|min:0",
            "monto_qr" => "required|decimal:0,2|min:0",
        ];
    }

    public function messages()
    {
        return [
            "almacen_id.required" => "Debes seleccionar un almacén",
            "monto_efectivo.required" => "Debes completar el campo de monto efectivo.",
            "monto_efectivo.decimal" => "Debes ingresar un valor númerico de hasta 2 decimales",
            "monto_efectivo.min" => "Debes ingresar un valor númerico no puede ser menor :min",
            "monto_qr.required" => "Debes completar el campo de monto qr.",
            "monto_qr.decimal" => "Debes ingresar un valor númerico de hasta 2 decimales",
            "monto_qr.min" => "Debes ingresar un valor númerico no puede ser menor :min",
        ];
    }
}
