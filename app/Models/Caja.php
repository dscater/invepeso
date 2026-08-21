<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Caja extends Model
{
    protected $fillable = [
        "sucursal_id",
        "nombre",
        "activo",
    ];
}
