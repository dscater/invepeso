<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class IngresoPago extends Model
{
    protected $fillable = [
        "sucursal_id",
        "almacen_id",
        "ingreso_producto_id",
        "proveedor_id",
        "monto",
        "fecha",
        "hora",
        "user_id"
    ];

    protected $appends = ["fecha_t", "fecha_hora_t"];

    public function getFechaHoraTAttribute()
    {
        return date("d/m/Y H:i:s", strtotime($this->fecha . ' ' . $this->hora));
    }

    public function getFechaTAttribute()
    {
        return date("d/m/Y", strtotime($this->fecha));
    }

    public function sucursal()
    {
        return $this->belongsTo(Sucursal::class, 'sucursal_id');
    }

    public function almacen()
    {
        return $this->belongsTo(Almacen::class, 'almacen_id');
    }

    public function ingreso_producto()
    {
        return $this->belongsTo(IngresoProducto::class, 'ingreso_producto_id');
    }

    public function proveedor()
    {
        return $this->belongsTo(Proveedor::class, 'proveedor_id');
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }
}
