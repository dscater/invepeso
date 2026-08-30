<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class KardexProducto extends Model
{
    protected $fillable = [
        "sucursal_id",
        "almacen_id",
        "ingreso_detalle_id",
        "tipo_registro",
        "registro_id",
        "modulo",
        "producto_id",
        "detalle",
        "precio",
        "tipo_is",
        "cantidad_ingreso",
        "cantidad_salida",
        "cantidad_saldo",
        "cu",
        "monto_ingreso",
        "monto_salida",
        "monto_saldo",
        "fecha",
        "status",
    ];
}
