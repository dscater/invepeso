<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ClienteProducto extends Model
{
    protected $fillable = [
        "cliente_id",
        "producto_id",
        "precio",
    ];

    public function cliente()
    {
        return $this->belongsTo(Cliente::class, 'cliente_id');
    }

    public function producto()
    {
        return $this->belongsTo(Producto::class, 'producto_id');
    }
}
