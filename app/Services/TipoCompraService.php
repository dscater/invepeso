<?php

namespace App\Services;

class TipoCompraService
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
