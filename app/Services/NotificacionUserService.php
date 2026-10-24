<?php

namespace App\Services;

use App\Models\NotificacionUser;
use App\Models\User;
use Exception;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\ValidationException;

class NotificacionUserService
{
    /**
     * Lista de notificacion_users paginado con filtros
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
        $notificacion_users = NotificacionUser::select("notificacion_users.*")
            ->with(["notificacion"]);

        $notificacion_users->where("user_id", Auth::user()->id);

        // Filtros exactos
        foreach ($columnsFilter as $key => $value) {
            if (!is_null($value)) {
                $notificacion_users->where("notificacion_users.$key", $value);
            }
        }

        // Filtros por rango
        foreach ($columnsBetweenFilter as $key => $value) {
            if (isset($value[0], $value[1])) {
                $notificacion_users->whereBetween("notificacion_users.$key", $value);
            }
        }

        // Búsqueda en múltiples columnas con LIKE
        if (!empty($search) && !empty($columnsSerachLike)) {
            $notificacion_users->where(function ($query) use ($search, $columnsSerachLike) {
                foreach ($columnsSerachLike as $col) {
                    $query->orWhere("$col", "LIKE", "%$search%");
                }
            });
        }

        // Ordenamiento
        foreach ($orderBy as $value) {
            if (isset($value[0], $value[1])) {
                $notificacion_users->orderBy($value[0], $value[1]);
            }
        }


        $notificacion_users = $notificacion_users->paginate($length, ['*'], 'page', $page);
        return $notificacion_users;
    }

    public function crearNotificacionUsers($notificacion_id, $tipos)
    {
        $users = User::whereIn("tipo", $tipos)->get();

        foreach ($users as $user) {
            NotificacionUser::create([
                "notificacion_id" => $notificacion_id,
                "user_id" => $user->id,
            ]);
        }
    }
}
