<?php

namespace App\Services;

class TipoVentaService
{
    public function listado()
    {
        return [
            [
                "value" => "AL CONTADO",
                "label" => "AL CONTADO",
                "icon" => "fa fa-money-bill",
            ],
            [
                "value" => "CRÉDITO",
                "label" => "CRÉDITO",
                "icon" => "fa fa-credit-card",
            ],
        ];
    }
}
