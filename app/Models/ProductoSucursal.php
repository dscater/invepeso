<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ProductoSucursal extends Model
{
    protected $fillable = [
        "sucursal_id",
        "producto_id",
        "stock_actual",
    ];
}
