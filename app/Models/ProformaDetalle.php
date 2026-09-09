<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ProformaDetalle extends Model
{
    protected $fillable = [
        "proforma_id",
        "producto_id",
        "cantidad",
        "precio", // precio original(ingresado)
        "descuento_uni", // descuento unitario
        "porcen_du", // porcentaje descuento unitario
        "descuento_total", // descuento obtenido desde el descuento TOTAL de la proforma
        "porcen_dt", // porcentaje descuento total
        "precio_final",  // precio final obtenido despues de los descuentos
        "total", // total registrado = cantidad * precio_final | para calcular ingreso bruto
        "total_uni", // total por fila sin tomar en cuenta descuento del total para mostrar = cantidad * (precio - descuento_uni)

    ];

    public function proforma()
    {
        return $this->belongsTo(Proforma::class, 'proforma_id');
    }

    public function producto()
    {
        return $this->belongsTo(Producto::class, 'producto_id');
    }
}
