<?php

namespace App\Http\Requests;

use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class ClienteProductoStoreRequest extends FormRequest
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
            "cliente_id" => [
                "required",
                Rule::unique("cliente_productos")
                    ->where(
                        fn($query) =>
                        $query->where("producto_id", $this->producto_id)
                    )
                    ->ignore($this->id),
            ],

            "producto_id" => "required",
            "precio" => "required|decimal:0,2|min:0",
        ];
    }

    public function messages()
    {
        return [
            "cliente_id.required" => "Debes seleccionar el cliente",
            "cliente_id.unique" => "Ya éxiste un registro del producto seleccionado",
            "producto_id.required" => "Debes seleccionar el producto",
            "precio.required" => "Debes completar el campo de precio.",
            "precio.decimal" => "Debes ingresar un valor númerico de hasta 2 decimales",
            "precio.min" => "Debes ingresar un valor númerico no puede ser menor :min",
        ];
    }
}
