<?php

namespace App\Http\Requests;

use App\Rules\TraspasoDetalleRule;
use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;

class TraspasoStoreRequest extends FormRequest
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
            "almacen_origen_id" => "required",
            "almacen_destino_id" => "required",
            "cantidad" => "required",
            "descripcion" => "required",
            "traspaso_detalles" => ["required", new TraspasoDetalleRule()],
        ];
    }

    public function messages()
    {
        return [
            "almacen_origen_id.required" => "Debes indicar el almacén de origen",
            "almacen_destino_id.required" => "Debes indicar el almacén de destino",
            "tipo_traspaso_id.required" => "Debes seleccionar el tipo de traspaso",
            "descripcion.required" => "Debes completar la descripción del traspaso",
            "cantidad.required" => "No se encontró el total de la compra",
        ];
    }
}
