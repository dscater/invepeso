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

    public function venta()
    {
        return $this->belongsTo(Venta::class, 'venta_id');
    }

    public function producto()
    {
        return $this->belongsTo(Venta::class, 'producto_id');
    }
}
