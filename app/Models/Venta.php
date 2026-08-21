<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Venta extends Model
{
    protected $fillable = [
        "codigo_venta",
        "sucursal_id",
        "caja_id",
        "cliente_id",
        "tipo_documento_id",
        "nit_ci",
        "tipo_pago",
        "subtotal",
        "descuento",
        "porcentaje_descuento",
        "total",
        "cancelado",
        "saldo",
        "fecha_registro",
        "status",
    ];
}
