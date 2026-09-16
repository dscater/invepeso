<?php

namespace App\Http\Requests;

use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;

class MovimientoCajaStoreRequest extends FormRequest
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
        $rules =  [
            "almacen_id" => "required",
            "monto_efectivo" => "required|decimal:0,2|min:0",
            "monto_qr" => "required|decimal:0,2|min:0",
            "tipo_movimiento" => "required",
            "tipo_pago" => "required",
            "descripcion" => "required",
            "fecha" => "required",
            "hora" => "required",
        ];

        return $rules;
    }

    public function messages(): array
    {
        return [
            "almacen_id.required" => "El campo Almacén es obligatorio.",
            "monto_efectivo.required" => "Debes completar el campo de monto efectivo.",
            "monto_efectivo.decimal" => "Debes ingresar un valor númerico de hasta 2 decimales",
            "monto_efectivo.min" => "Debes ingresar un valor númerico no puede ser menor :min",
            "monto_qr.required" => "Debes completar el campo de monto qr.",
            "monto_qr.decimal" => "Debes ingresar un valor númerico de hasta 2 decimales",
            "monto_qr.min" => "Debes ingresar un valor númerico no puede ser menor :min",
            "tipo_movimiento.required" => "El campo Tipo de Movimiento es obligatorio.",
            "tipo_pago.required" => "El campo Tipo de Pago es obligatorio.",
            "descripcion.required" => "El campo Descripción es obligatorio.",
            "fecha.required" => "El campo Fecha es obligatorio.",
            "hora.required" => "El campo Hora es obligatorio.",
        ];
    }
}
