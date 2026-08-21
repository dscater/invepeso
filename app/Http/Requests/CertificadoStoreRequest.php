<?php

namespace App\Http\Requests;

use App\Rules\CertificadoDetalleRule;
use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;

class CertificadoStoreRequest extends FormRequest
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
            "cliente_id" => "required",
            "total" => "required|numeric|decimal:0,2|min:0",
            "tipo_pago" => "required",
            "certificado_detalles" => ["required", "array", "min:1", new CertificadoDetalleRule()],
            "tipo" => "nullable",
            "tramitador_id" => "nullable",
            "fecha_inicio" => "date",
            "hora_inicio" => "required",
            "estado" => "nullable"
        ];

        if ($this->tipo == 'TRAMITE') {
            $rules["tramitador_id"] = "required";
        }

        $rules["cancelado"] = "required|numeric|decimal:0,2|min:0";
        $rules["saldo"] = "required|numeric|decimal:0,2|min:0";

        return $rules;
    }

    public function messages(): array
    {
        return [
            "cliente_id.required" => "No se seleccionó ningún cliente",
            "tramitador_id.required" => "No se seleccionó ningún tramitador",
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
            "certificado_detalles.required" => "Debes agregar al menos 1 certificado",
            "certificado_detalles.array" => "Debes enviar una lista de certificados",
            "certificado_detalles.min" => "Debes agregar al menos :min certificado",
        ];
    }
}
