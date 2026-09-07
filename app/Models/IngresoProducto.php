<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class IngresoProducto extends Model
{
    protected $fillable = [
        "codigo",
        "sucursal_id",
        "almacen_id",
        "tipo_ingreso_id",
        "proveedor_id",
        "descripcion",
        "total",
        "cancelado",
        "saldo",
        "tipo_compra", //CONTADO, CRÉDITO
        "fecha_registro",
        "user_id",
        "estado_ingreso", //PENDIENTE, VERIFICADO
        "estado_faltantes", //NULL, SIN FALTANTES, PENDIENTE, COMPLETO 
        "status",
    ];

    protected $appends = ["fecha_registro_t"];

    public function getFechaRegistroTAttribute()
    {
        return date("d/m/Y", strtotime($this->fecha_registro));
    }

    public function sucursal()
    {
        return $this->belongsTo(Sucursal::class, 'sucursal_id');
    }

    public function almacen()
    {
        return $this->belongsTo(Almacen::class, 'almacen_id');
    }

    public function tipo_ingreso()
    {
        return $this->belongsTo(TipoIngreso::class, 'tipo_ingreso_id');
    }

    public function proveedor()
    {
        return $this->belongsTo(Proveedor::class, 'proveedor_id');
    }

    public function ingreso_detalles()
    {
        return $this->hasMany(IngresoDetalle::class, 'ingreso_producto_id');
    }

    public function ingreso_pagos()
    {
        return $this->hasMany(IngresoPago::class, 'ingreso_producto_id');
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }
}
