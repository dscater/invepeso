<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class CajaUser extends Model
{
    protected $fillable = [
        "sucursal_id",
        "caja_id",
        "user_id",
        "fecha",
        "hora",
        "fecha_ultimo",
        "hora_ultimo",
    ];
}
