<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class IngresoProducto extends Model
{
    protected $fillable = [
        "codigo",
        "sucursal_id",
        "tipo_ingreso_id",
        "proveedor_id",
        "descripcion",
        "total",
        "cancelado",
        "saldo",
        "fecha_registro",
        "user_id",
        "status",
    ];

    public function ingreso_detalles()
    {
        return $this->hasMany(IngresoDetalle::class, 'ingreso_producto_id');
    }
}
