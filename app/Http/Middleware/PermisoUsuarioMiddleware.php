<?php

namespace App\Http\Middleware;

use App\Models\Modulo;
use App\Services\PermisoService;
use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;
use Symfony\Component\HttpFoundation\Response;

class PermisoUsuarioMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        $user = $request->user();

        if (!$user) {
            if ($request->inertia()) {
                return redirect('/');
            }

            abort(403);
        }

        $prefijo = $request->route()?->getPrefix();
        $nom_ruta = $request->route()?->getName();

        $excepciones = [
            'inicio',
            'profile.edit',
            'profile.update',
            'profile.update_foto',
            'users.getUser',
        ];

        // Las rutas que no son de administración continúan normalmente.
        if ($prefijo !== 'admin') {
            return $next($request);
        }

        // Las rutas exceptuadas no necesitan comprobar permisos.
        if (in_array($nom_ruta, $excepciones, true)) {
            return $next($request);
        }

        $permisoService = app(PermisoService::class);
        $permisos = $permisoService->getPermisosUser();

        if (is_array($permisos)) {
            // $modulos = Modulo::pluck('nombre')->toArray();
            $modulos = Cache::remember(
                'modulos_nombres',
                now()->addHours(8),
                fn() => Modulo::pluck('nombre')->toArray()
            );

            // Log::debug($modulos);
            if (
                in_array($nom_ruta, $modulos, true) &&
                !in_array($nom_ruta, $permisos, true)
            ) {
                abort(401, 'Acceso denegado');
            }
        }

        return $next($request);
    }
}
