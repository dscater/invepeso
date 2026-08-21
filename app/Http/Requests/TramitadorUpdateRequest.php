<?php

namespace App\Http\Requests;

use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;

class TramitadorUpdateRequest extends FormRequest
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
            "nombre" => "required",
            "ci" => "required|unique:tramitadors,ci," . $this->tramitador->id,
            "ci_exp" => "required",
            "cel" => "required",
        ];
    }

    public function messages()
    {
        return [
            "nombre.required" => "Debes completar este campo",
            "ci.required" => "Debes completar este campo",
            "ci.unique" => "Este C.I. ya fue registrado",
            "ci_exp.required" => "Debes completar este campo",
            "cel.required" => "Debes completar este campo",
        ];
    }
}
