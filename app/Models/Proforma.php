<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Proforma extends Model
{
    protected $fillable = [
        "codigo_proforma",
        "sucursal_id",
        "almacen_id",
        "cliente_id",
        "tipo_documento_id",
        "nit_ci",
        "subtotal",
        "descuento",
        "porcentaje_descuento",
        "total",
        "cancelado",
        "saldo",
        "fecha",
        "hora",
        "fecha_registro",
        "status",
        "user_id",
    ];

    protected $appends = ["fecha_registro_t", "fecha_hora_t"];

    public function getFechaHoraTAttribute()
    {
        return date("d/m/Y H:i:s", strtotime($this->fecha . ' ' . $this->hora));
    }

    public function getFechaRegistroTAttribute()
    {
        return date("d/m/Y", strtotime($this->fecha_registro));
    }

    public function sucursal()
    {
        return $this->belongsTo(Sucursal::class, "sucursal_id");
    }

    public function almacen()
    {
        return $this->belongsTo(Almacen::class, "almacen_id");
    }

    public function cliente()
    {
        return $this->belongsTo(Cliente::class, "cliente_id");
    }

    public function user()
    {
        return $this->belongsTo(User::class, "user_id");
    }

    public function proforma_detalles()
    {
        return $this->hasMany(ProformaDetalle::class, "proforma_id");
    }
}
