<?php

namespace App\Services;

class TipoUsuarioService
{
    public function listado()
    {
        return [
            [
                "value" => "ADMINISTRACIÓN",
                "label" => "ADMINISTRACIÓN",
                "descripcion" => "Administración tiene acceso a todas las sucursales del sistema para ventas, compras, inventario y reportes",
            ],
            [
                "value" => "EMPLEADO",
                "label" => "EMPLEADO",
                "descripcion" => "Empleado debe tener asignado una sucursal especifica para poder realizar ventas, compras, inventario y reportes",
            ],
        ];
    }
}
