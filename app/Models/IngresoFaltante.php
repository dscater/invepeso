<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class IngresoFaltante extends Model
{
    protected $fillable = [
        "ingreso_producto_id",
        "ingreso_detalle_id",
        "cantidad",
        "user_id",
        "fecha",
        "hora",
    ];

    protected $appends = ["fecha_t", "fecha_hora_t"];

    public function getFechaTAttribute()
    {
        return date("d/m/Y", strtotime($this->fecha));
    }

    public function getFechaHoraTAttribute()
    {
        return date("d/m/Y H:i:s", strtotime($this->fecha . ' ' . $this->hora));
    }

    public function ingreso_producto()
    {
        return $this->belongsTo(IngresoProducto::class, 'ingreso_producto_id');
    }
    public function ingreso_detalle()
    {
        return $this->belongsTo(IngresoDetalle::class, 'ingreso_detalle_id');
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }
}
