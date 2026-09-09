<?php

namespace App\Http\Controllers;

use App\Models\Venta;
use App\Services\VentaCobroService;
use Illuminate\Http\Request;

class VentaCobroController extends Controller
{
    public function __construct(private VentaCobroService $venta_cobro_service) {}

    public function listaByVenta(Venta $venta)
    {
        return response()->JSON([
            "venta_cobros" => $this->venta_cobro_service->listado($venta->id)
        ]);
    }
}
