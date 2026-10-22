<?php

namespace App\Services;

use App\Models\Permiso;
use App\Models\Role;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Cache;

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

        $roleId = $user->role_id;

        if (!$roleId) {
            return [];
        }

        // Versión para invalidar todos los permisos sin recorrer
        // todas las claves de caché.
        $version = Cache::get('permisos_cache_version', 1);

        $cacheKey = "permisos_role_v{$version}_{$roleId}";

        return Cache::remember(
            $cacheKey,
            now()->addHours(8),
            function () use ($roleId) {
                $role = Role::find($roleId);

                if (!$role) {
                    return [];
                }

                // El rol tiene acceso a todos los módulos
                if ($role->permisos == 1) {
                    return '*';
                }

                return Permiso::join(
                    'modulos',
                    'modulos.id',
                    '=',
                    'permisos.modulo_id'
                )
                    ->where('permisos.role_id', $roleId)
                    ->pluck('modulos.nombre')
                    ->toArray();
            }
        );
    }

    public function limpiarCachePermisos(): void
    {
        $version = (int) Cache::get('permisos_cache_version', 1);

        // Invalida las claves de permisos de todos los roles.
        Cache::forever('permisos_cache_version', $version + 1);

        // Invalida la lista de módulos.
        Cache::forget('modulos_nombres');
    }
}
