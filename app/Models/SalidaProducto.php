<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SalidaProducto extends Model
{
    protected $fillable = [
        "sucursal_id",
        "ingreso_detalle_id",
        "tipo_salida_id",
        "producto_id",
        "cantidad",
        "descripcion",
        "fecha_registro",
        "user_id",
    ];
}
