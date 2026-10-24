<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SalidaDetalle extends Model
{
    protected $fillable = [
        "salida_producto_id",
        "tipo_salida_id",
        "producto_id",
        "cantidad",
        "observacion",
    ];

    public function salida_producto()
    {
        return $this->belongsTo(SalidaProducto::class, 'salida_producto_id');
    }

    public function tipo_salida()
    {
        return $this->belongsTo(TipoSalida::class, 'tipo_salida_id');
    }

    public function producto()
    {
        return $this->belongsTo(Producto::class, 'producto_id');
    }
}
