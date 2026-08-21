<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class IngresoDetalle extends Model
{
    protected $fillable = [
        "ingreso_producto_id",
        "tipo_ingreso_id",
        "producto_id",
        "cantidad",
        "verificado",
        "faltantes",
        "repuesto",
        "observacion",
        "cantidad_fisica",
        "costo",
        "subtotal",
    ];

    public function ingreso_producto()
    {
        return $this->belongsTo(IngresoProducto::class, 'ingreso_producto_id');
    }

    public function tipo_ingreso()
    {
        return $this->belongsTo(TipoIngreso::class, 'tipo_ingreso_id');
    }

    public function producto()
    {
        return $this->belongsTo(Producto::class, 'producto_id');
    }
}
