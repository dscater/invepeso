<?php

namespace App\Http\Controllers;

use App\Models\IngresoProducto;
use App\Services\IngresoPagoService;
use Illuminate\Http\Request;

class IngresoPagoController extends Controller
{
    public function __construct(private IngresoPagoService $ingreso_pago_service) {}

    public function listaByIngreso(IngresoProducto $ingresoProducto)
    {
        return response()->JSON([
            "ingreso_pagos" => $this->ingreso_pago_service->listado($ingresoProducto->id)
        ]);
    }
}
