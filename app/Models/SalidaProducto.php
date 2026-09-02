<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SalidaProducto extends Model
{
    protected $fillable = [
        "sucursal_id",
        "almacen_id",
        "tipo_salida_id",
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

    public function sucursal()
    {
        return $this->belongsTo(Sucursal::class, 'sucursal_id');
    }

    public function almacen()
    {
        return $this->belongsTo(Almacen::class, 'almacen_id');
    }

    public function tipo_salida()
    {
        return $this->belongsTo(TipoSalida::class, 'tipo_salida_id');
    }

    public function salida_detalles()
    {
        return $this->hasMany(SalidaDetalle::class, 'salida_producto_id');
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }
}
