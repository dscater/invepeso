<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class VentaDetalleLote extends Model
{
    protected $fillable = [
        "venta_id",
        "venta_detalle_id",
        "ingreso_detalle_id",
        "producto_id",
        "cantidad",
        "precio_lote",
        "precio_venta",
        "precio_venta_final",
        "ganancia",
    ];
}
