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
        $user = Auth::user();

        if (!$user) {
            return [];
        }

        $tipo = $user->tipo;

        if ($tipo === 'TIPO_USUARIO') {
            // declarar un array dentro dela clase
            // para permisos especificos por tipo de usuario
            return $this->arrayPermisos[$tipo] ?? [];
        }

        $role = $user->role;

        if (!$role) {
            return [];
        }

        if ($role->permisos == 1) {
            return '*';
        }

        return Permiso::join(
            'modulos',
            'modulos.id',
            '=',
            'permisos.modulo_id'
        )
            ->where('permisos.role_id', $role->id)
            ->pluck('modulos.nombre')
            ->toArray();
    }
}
