<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class TipoSalida extends Model
{
    protected $fillable = [
        "nombre",
        "descripcion",
    ];
}
