<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class VentaCobro extends Model
{
    protected $fillable = [
        "sucursal_id",
        "almacen_id",
        "venta_id",
        "cliente_id",
        "tipo_pago",
        "monto",
        "saldo",
        "fecha",
        "hora",
        "user_id",
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

    public function venta()
    {
        return $this->belongsTo(Venta::class, 'venta_id');
    }

    public function cliente()
    {
        return $this->belongsTo(Cliente::class, 'cliente_id');
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }
}
