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
    public function handle(
        Request $request,
        Closure $next
    ): Response {
        $prefijo = $request->route()?->getPrefix();
        $esAdmin = $prefijo === 'admin';

        // Las rutas que no son administrativas continúan normalmente.
        if (!$esAdmin) {
            return $next($request);
        }

        $user = $request->user();

        if (!$user) {
            if ($request->inertia()) {
                return $this->noCache(redirect('/'));
            }

            return $this->noCache(
                response('No autenticado', 401)
            );
        }

        $nom_ruta = $request->route()?->getName();

        $excepciones = [
            'inicio',
            'profile.edit',
            'profile.update',
            'profile.update_foto',
            'users.getUser',
        ];

        if (in_array($nom_ruta, $excepciones, true)) {
            return $this->noCache($next($request));
        }

        $permisoService = app(PermisoService::class);
        $permisos = $permisoService->getPermisosUser();

        if (is_array($permisos)) {
            $modulos = Cache::remember(
                'modulos_nombres',
                now()->addHours(8),
                fn() => Modulo::pluck('nombre')->toArray()
            );

            if (
                in_array($nom_ruta, $modulos, true) &&
                !in_array($nom_ruta, $permisos, true)
            ) {
                return $this->noCache(
                    response('Acceso denegado', 403)
                );
            }
        }

        return $this->noCache($next($request));
    }

    private function noCache(Response $response): Response
    {
        $response->headers->set(
            'Cache-Control',
            'no-store, private'
        );

        $response->headers->set('Pragma', 'no-cache');
        $response->headers->set('Expires', '0');

        return $response;
    }
}
