<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class MovimientoCaja extends Model
{
    protected $fillable = [
        "sucursal_id",
        "almacen_id",
        "tipo",
        "modulo",
        "registro_id",
        "monto_efectivo",
        "monto_qr",
        "monto_total",
        "tipo_movimiento", //INGRESO-EGRESO
        "tipo_pago", //EFECTIVO-QR | EFECTIVO | QR
        "descripcion",
        "fecha",
        "hora",
        "user_id",
        "status" // 1: activo, 0: eliminado
    ];

    protected $appends = ["fecha_t", "fecha_hora_t"];

    public function getFechaHoraTAttribute()
    {
        return date("d/m/Y H:i:s", strtotime($this->fecha . " " . $this->hora));
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

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }
}
