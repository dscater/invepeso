<?php

namespace App\Http\Controllers;

use App\Services\TipoCompraService;
use Illuminate\Http\Request;

class TipoCompraController extends Controller
{
    public function __construct(private TipoCompraService $tipo_compra_service) {}
    public function listado()
    {
        return response()->JSON([
            "tipo_compras" => $this->tipo_compra_service->listado()
        ]);
    }
}
