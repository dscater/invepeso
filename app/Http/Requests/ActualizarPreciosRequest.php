<?php

namespace App\Http\Requests;

use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;
use Override;

class ActualizarPreciosRequest extends FormRequest
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
            "porcentajeMonto" => "required",
            "filtro" => "required",
            "producto_ids" => "nullable|array|min:0",
            "valor" => "required|numeric"
        ];


        if ($this->filtro != 'todos') {
            $rules["producto_ids"] = "required|array|min:1";
        }

        return $rules;
    }
    public function attributes()
    {
        return [
            "porcentajeMonto" => "Porcentaje/Monto",
            "filtro" => "Filtro",
            "producto_ids" => "Productos Filtrados",
            "valor" => "Valor",
        ];
    }
}
