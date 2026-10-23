<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class IngresoRecepcion extends Model
{
    protected $fillable = [
        "ingreso_producto_id",
        "ingreso_detalle_id",
        "sucursal_id",
        "almacen_id",
        "producto_id",
        "cantidad",
        "tipo", // RECEPCION: lo que se recibio y distribuyo a los almacenes, FALTANTE: lo que se recibio segun faltantes de RECEPCION
        "fecha",
        "hora",
        "user_id",
    ];

    public function ingreso_producto()
    {
        return $this->belongsTo(IngresoProducto::class, 'ingreso_producto_id');
    }

    public function ingreso_detalle()
    {
        return $this->belongsTo(IngresoDetalle::class, 'ingreso_detalle_id');
    }

    public function sucursal()
    {
        return $this->belongsTo(Sucursal::class, 'sucursal_id');
    }

    public function almacen()
    {
        return $this->belongsTo(Almacen::class, 'almacen_id');
    }

    public function producto()
    {
        return $this->belongsTo(Producto::class, 'producto_id');
    }

    public function user()
    {
        return $this->belongsTo(Producto::class, 'user_id');
    }
}
