<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class MovimientoCaja extends Model
{
    protected $fillable = [
        "sucursal_id",
        "modulo",
        "registro_id",
        "monto",
        "tipo_movimiento",
        "tipo_pago",
        "descripcion",
        "fecha",
        "hora",
        "user_id",
    ];

    public function sucursal()
    {
        return $this->belongsTo(Sucursal::class, 'sucursal_id');
    }
}
