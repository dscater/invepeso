<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class VentaDetalle extends Model
{
    protected $fillable = [
        "venta_id",
        "producto_id",
        "cantidad",
        "precio",
        "precio_descuento",
        "descuento",
        "porcentaje_descuento",
        "subtotal",
        "total",
    ];
}
