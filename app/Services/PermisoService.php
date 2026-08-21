<?php

namespace App\Services;

use App\Models\Permiso;
use App\Models\Role;
use Illuminate\Support\Facades\Auth;

class PermisoService
{
    public function getTiposUsuarios()
    {
        return [];
    }

    /**
     * Obtener permisos de usuario logeado
     *
     * @return array
     */
    public function getPermisosUser(): array|string
    {
        if (!Auth::check()) {
            return [];
        }
        $tipo = Auth::user()->tipo;
        if ($tipo == 'POSTULANTE') {
            return $this->arrayPermisos[$tipo];
        }
        $role_id = Auth::user()->role_id;
        $role = Role::find($role_id);
        if ($role->permisos == 1) {
            // todos los permisos
            return "*";
        }
        $permisos = Permiso::join("modulos", "modulos.id", "=", "permisos.modulo_id")
            ->where("permisos.role_id", $role->id)
            ->pluck("modulos.nombre")
            ->toArray();
        return $permisos;
    }
}
