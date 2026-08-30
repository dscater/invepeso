<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SalidaDetalle extends Model
{
    protected $fillable = [
        "salida_producto_id",
        "tipo_salida_id",
        "producto_id",
        "cantidad",
        "observacion",
    ];
}
