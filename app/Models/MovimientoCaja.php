<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class MovimientoCaja extends Model
{
    protected $fillable = [
        "sucursal_id",
        "caja_id",
        "modulo",
        "registro_id",
        "tipo_pago",
        "descripcion",
        "fecha",
        "hora",
        "user_id",
    ];
}
