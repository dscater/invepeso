<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Almacen extends Model
{
    protected $fillable = [
        "sucursal_id",
        "nombre",
        "descripcion",
        "activo",
        "fecha_registro",
    ];

    public function sucursal()
    {
        return $this->belongsTo(Sucursal::class, 'sucursal_id');
    }
}
