<?php

namespace App\Http\Controllers;

use App\Services\TipoUsuarioService;
use Illuminate\Http\Request;

class TipoUsuarioController extends Controller
{
    public function __construct(private TipoUsuarioService $tipo_usuario_service) {}

    public function listado()
    {
        return response()->JSON($this->tipo_usuario_service->listado());
    }
}
