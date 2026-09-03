<?php

namespace App\Http\Controllers;

use App\Services\TipoVentaService;
use Illuminate\Http\Request;

class TipoVentaController extends Controller
{

    public function __construct(private TipoVentaService $tipoVentaService) {}
    public function listado()
    {
        return response()->JSON([
            "tipo_ventas" => $this->tipoVentaService->listado()
        ]);
    }
}
