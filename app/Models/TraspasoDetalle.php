<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class TraspasoDetalle extends Model
{
    protected $fillable = [
        "traspaso_id",
        "producto_id",
        "cantidad",
        "observacion",
    ];

    public function traspaso()
    {
        return $this->belongsTo(Traspaso::class, 'traspaso_id');
    }

    public function producto()
    {
        return $this->belongsTo(Producto::class, 'producto_id');
    }
}
