<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Traspaso extends Model
{
    protected $fillable = [
        "sucursal_origen_id",
        "almacen_origen_id",
        "sucursal_destino_id",
        "almacen_destino_id",
        "cantidad",
        "descripcion",
        "fecha_registro",
        "user_id",
    ];

    protected $appends = ["fecha_registro_t"];

    public function getFechaRegistroTAttribute()
    {
        return date("d/m/Y", strtotime($this->fecha_registro));
    }

    public function sucursal_origen()
    {
        return $this->belongsTo(Sucursal::class, 'sucursal_origen_id');
    }

    public function almacen_origen()
    {
        return $this->belongsTo(Almacen::class, 'almacen_origen_id');
    }

    public function sucursal_destino()
    {
        return $this->belongsTo(Sucursal::class, 'sucursal_destino_id');
    }

    public function almacen_destino()
    {
        return $this->belongsTo(Almacen::class, 'almacen_destino_id');
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function traspaso_detalles()
    {
        return $this->hasMany(TraspasoDetalle::class, 'traspaso_id');
    }
}
