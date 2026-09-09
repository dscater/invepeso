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
            "monto" => "required|decimal:0,2|min:1",
        ];
    }

    public function messages()
    {
        return [
            "almacen_id.required" => "Debes seleccionar un almacén",
            "monto.tipo_pago" => "Debes ingresar un tipo de pago",
            "monto.required" => "Debes ingresar un monto",
            "monto.decimal" => "Debes ingresar un valor númerico",
            "monto.min" => "Debes ingresar un valor mínimo de 1",
        ];
    }
}
