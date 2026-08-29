<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ProductoSucursal extends Model
{
    protected $fillable = [
        "sucursal_id",
        "almacen_id",
        "producto_id",
        "stock_actual",
    ];

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
}
