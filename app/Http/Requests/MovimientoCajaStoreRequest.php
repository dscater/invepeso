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
        return [
            "almacen_id" => "required",
            "monto" => "required|decimal:0,2|gt:0",
            "tipo_movimiento" => "required",
            "tipo_pago" => "required",
            "descripcion" => "required",
            "fecha" => "required",
            "hora" => "required",
        ];
    }

    public function messages(): array
    {
        return [
            "almacen_id.required" => "El campo Almacén es obligatorio.",
            "monto.required" => "Debes completar el campo de monto.",
            "monto.decimal" => "Debes ingresar un valor númerido de hasta 2 decimales",
            "monto.gt" => "Debes ingresar un valor númerido no puede ser menor o igual a 0",
            "tipo_movimiento.required" => "El campo Tipo de Movimiento es obligatorio.",
            "tipo_pago.required" => "El campo Tipo de Pago es obligatorio.",
            "descripcion.required" => "El campo Descripción es obligatorio.",
            "fecha.required" => "El campo Fecha es obligatorio.",
            "hora.required" => "El campo Hora es obligatorio.",
        ];
    }
}
