<?php

namespace App\Http\Controllers;

use App\Services\TipoPagoService;
use Illuminate\Http\Request;

class TipoPagoController extends Controller
{
    public function __construct(private TipoPagoService $tipoPagoService) {}

    public function listado()
    {
        return response()->JSON([
            "tipo_pagos" => $this->tipoPagoService->listado()
        ]);
    }
}
