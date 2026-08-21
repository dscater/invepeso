<?php

namespace App\Http\Requests;

use App\Rules\CertificadoDetalleRule;
use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;

class CertificadoClienteRequest extends FormRequest
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
        $rule = [];

        $rule["con_certificado"] = ["required"];
        $rule["tipo_pago"] = ["required"];
        $rule["tipo"] = ["required"];
        $rule["tramitador_id"] = ["nullable"];
        if ($this->tipo != 'NORMAL') {
            $rule["tramitador_id"] = ["required"];
        }
        $rule["certificado_detalles"] = ["required", "array", "min:1", new CertificadoDetalleRule(false, false)];
        $rule["total"] = ["required"];
        $rule["cancelado"] = ["required"];
        $rule["saldo"] = ["required"];

        return $rule;
    }

    public function messages(): array
    {
        return [
            "tramitador_id.required" => "Debes seleccionar una opción",
            "total.required" => "Debes ingresar el costo",
            "total.numeric" => "Debes ingresar un valor númerico",
            "total.decimal" => "Debes ingresar un número con hasta 2 decimales",
            "total.min" => "Debes ingresar un monto minimo de :min",
            "cancelado.required" => "Debes ingresar el monto cancelado",
            "cancelado.numeric" => "Debes ingresar un valor númerico",
            "cancelado.decimal" => "Debes ingresar un número con hasta 2 decimales",
            "cancelado.min" => "Debes ingresar un monto minimo de :min",
            "saldo.required" => "No se obtuvo el saldo",
            "saldo.numeric" => "Debes ingresar un valor númerico",
            "saldo.decimal" => "Debes ingresar un número con hasta 2 decimales",
            "saldo.min" => "Debes ingresar un monto minimo de :min",
            "tipo_pago.required" => "Debes completar este campo",
        ];
    }
}
