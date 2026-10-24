<?php

namespace App\Services;

use App\Services\HistorialAccionService;
use App\Models\Notificacion;
use App\Models\NotificacionUser;
use App\Models\Sucursal;
use App\Models\User;
use Exception;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;
use Illuminate\Validation\ValidationException;

class NotificacionService
{

    public function listado(): Collection
    {
        $notificacions = Notificacion::select("notificacions.*");
        $notificacions = $notificacions->get();
        return $notificacions;
    }

    public function listadoByUser($user_id): Collection
    {
        $notificacions = Notificacion::select("notificacions.*")
            ->join("notificacion_users", "notificacion_users.notificacion_id", "=", "notificacions.id");
        $notificacions->where("notificacion_users.user_id", $user_id);
        $notificacions = $notificacions->get();
        return $notificacions;
    }

    public function listadoByUserNoVisto($user_id): Collection
    {
        $notificacions = Notificacion::select("notificacions.*")
            ->join("notificacion_users", "notificacion_users.notificacion_id", "=", "notificacions.id");
        $notificacions->where("notificacion_users.user_id", $user_id);
        $notificacions->where("notificacion_users.visto", 0);
        $notificacions = $notificacions->orderBy("created_at", "desc")->get();
        return $notificacions;
    }
    /**
     * Lista de notificacions paginado con filtros
     *
     * @param integer $length
     * @param integer $page
     * @param string $search
     * @param array $columnsSerachLike
     * @param array $columnsFilter
     * @return LengthAwarePaginator
     */
    public function listadoPaginado(int $length, int $page, string $search, array $columnsSerachLike = [], array $columnsFilter = [], array $columnsBetweenFilter = [], array $orderBy = []): LengthAwarePaginator
    {
        $user_id = Auth::user()->id;
        $notificacions = Notificacion::select("notificacions.*")
            ->join("notificacion_users", "notificacion_users.notificacion_id", "=", "notificacions.id");
        $notificacions->where("notificacion_users.user_id", $user_id);
        // Filtros exactos
        foreach ($columnsFilter as $key => $value) {
            if (!is_null($value)) {
                $notificacions->where("notificacions.$key", $value);
            }
        }

        // Filtros por rango
        foreach ($columnsBetweenFilter as $key => $value) {
            if (isset($value[0], $value[1])) {
                $notificacions->whereBetween("notificacions.$key", $value);
            }
        }

        // Búsqueda en múltiples columnas con LIKE
        if (!empty($search) && !empty($columnsSerachLike)) {
            $notificacions->where(function ($query) use ($search, $columnsSerachLike) {
                foreach ($columnsSerachLike as $col) {
                    $query->orWhere("$col", "LIKE", "%$search%");
                }
            });
        }

        // Ordenamiento
        foreach ($orderBy as $value) {
            if (isset($value[0], $value[1])) {
                $notificacions->orderBy($value[0], $value[1]);
            }
        }


        $notificacions = $notificacions->paginate($length, ['*'], 'page', $page);
        return $notificacions;
    }

    /**
     * Crear notificacion
     *
     * @param array $datos
     * @return Notificacion
     */
    public function crear(array $datos): Notificacion
    {
        $notificacion = Notificacion::create([
            "descripcion" => $datos["descripcion"],
            "modulo" => $datos["modulo"],
            "registro_id" => $datos["registro_id"],
            "tipo" => $datos["tipo"],
            "fecha" => date("Y-m-d"),
            "hora" => date("H:i"),
        ]);

        $this->asignarNotificacionesUsuarios($notificacion);

        return $notificacion;
    }

    public function asignarNotificacionesUsuarios($notificacion)
    {
        $users = User::where(function ($query) {
            $query->where('role_id', 1)
                ->orWhereHas('role.o_permisos.modulo', function ($q) {
                    $q->where('modulo', 'Gestión de notificaciones');
                });
        })->get();

        foreach ($users as $user) {
            $permisos = $user->permisos;
            if (
                $user->role_id == 1 ||
                $permisos == '*' ||
                (is_array($permisos) && in_array('notificacion_users.index', $permisos))
            ) {
                $user->notificacion_users()->firstOrCreate([
                    'notificacion_id' => $notificacion->id,
                ]);
            }
        }
    }

    /**
     * Actualizar notificacion_user
     *
     * @param array $datos
     * @param NotificacionUser $notificacion_user
     * @return NotificacionUser
     */
    public function marcarVisto(NotificacionUser $notificacion_user): NotificacionUser
    {
        $notificacion_user->visto = 1;
        $notificacion_user->save();
        return $notificacion_user;
    }
}
