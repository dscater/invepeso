<?php

namespace App\Http\Requests;

use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;

class ProductoStoreRequest extends FormRequest
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
            "codigo" => "required|unique:productos,codigo",
            "nombre" => "required|unique:productos,nombre",
            "categoria_id" => "required",
            "marca_id" => "required",
            "unidad_medida_id" => "required",
            "precio" => "required|decimal:0,2|gt:0",
            "precio2" => "nullable|decimal:0,2|gt:0",
            "precio3" => "nullable|decimal:0,2|gt:0",
            "precio4" => "nullable|decimal:0,2|gt:0",
            "precio_compra" => "required|decimal:0,2|gt:0",
            "stock_min" => "required",
            "imagen" => "nullable|image|mimes:jpeg,png,jpg,gif,svg|max:4096",
            "activo" => "required",
        ];
    }

    public function messages()
    {
        return [
            "codigo.required" => "Debes completar este campo",
            "codigo.unique" => "Este código no esta disponible",
            "nombre.required" => "Debes completar este campo",
            "nombre.unique" => "Este nombre no esta disponible",
            "categoria_id.required" => "Debes completar este campo",
            "marca_id.required" => "Debes completar este campo",
            "unidad_medida_id.required" => "Debes completar este campo",
            "precio.required" => "Debes completar este campo",
            "precio.decimal" => "Debes ingresar un valor númerido de hasta 2 decimales",
            "precio.gt" => "Debes ingresar un valor númerido no puede ser menor o igual a 0",
            "precio2.decimal" => "Debes ingresar un valor númerido de hasta 2 decimales",
            "precio2.gt" => "Debes ingresar un valor númerido no puede ser menor o igual a 0",
            "precio3.decimal" => "Debes ingresar un valor númerido de hasta 2 decimales",
            "precio3.gt" => "Debes ingresar un valor númerido no puede ser menor o igual a 0",
            "precio4.decimal" => "Debes ingresar un valor númerido de hasta 2 decimales",
            "precio4.gt" => "Debes ingresar un valor númerido no puede ser menor o igual a 0",
            "precio_compra.required" => "Debes completar este campo",
            "precio_compra.decimal" => "Debes ingresar un valor númerido de hasta 2 decimales",
            "precio_compra.gt" => "Debes ingresar un valor númerido no puede ser menor o igual a 0",
            "stock_min.required" => "Debes completar este campo",
            "imagen.required" => "Debes completar este campo",
            "imagen.mimes" => "La imagen debe ser jpeg,jpg,png,gif,svg",
            "imagen.max" => "La imagen no puede pesar mas de 4MB",
            "activo.required" => "Debes completar este campo",
        ];
    }
}
