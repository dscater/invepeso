<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Producto extends Model
{
    protected $fillable = [
        "codigo",
        "nombre",
        "categoria_id",
        "marca_id",
        "unidad_medida_id",
        "precio",
        "precio2",
        "precio3",
        "precio4",
        "precio_compra",
        "stock_min",
        "imagen",
        "activo",
        "fecha_registro",
    ];

    protected $appends = ["fecha_registro_t", "url_imagen"];

    public function getUrlImagenAttribute()
    {
        if ($this->imagen) {
            return asset("imgs/productos/" . $this->imagen);
        }
        return asset("imgs/productos/default.png");
    }

    public function getFechaRegistroTAttribute()
    {
        if ($this->fecha_registro) return date("d/m/Y", strtotime($this->fecha_registro));

        return "";
    }

    public function categoria()
    {
        return $this->belongsTo(Categoria::class, 'categoria_id');
    }

    public function marca()
    {
        return $this->belongsTo(Marca::class, 'marca_id');
    }

    public function unidad_medida()
    {
        return $this->belongsTo(UnidadMedida::class, 'unidad_medida_id');
    }
}
