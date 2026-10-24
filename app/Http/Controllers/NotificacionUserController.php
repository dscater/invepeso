<?php

namespace App\Http\Controllers;

use App\Models\Notificacion;
use App\Models\NotificacionUser;
use App\Services\AlertaEpidemiologicaService;
use App\Services\NotificacionUserService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Inertia\Inertia;

class NotificacionUserController extends Controller
{
    public function __construct(private NotificacionUserService $notificacion_user_service) {}

    public function index()
    {
        return Inertia::render("Admin/Notificacions/Index");
    }

    public function show(Notificacion $notificacion)
    {
        $notificacion_user = NotificacionUser::where("user_id", Auth::user()->id)
            ->where("notificacion_id", $notificacion->id)
            ->get()->first();
        if ($notificacion_user) {
            $notificacion_user->visto = 1;
            $notificacion_user->save();
        }

        return Inertia::render("Admin/Notificacions/Show", compact("notificacion"));
    }

    public function paginado(Request $request)
    {
        $perPage = $request->perPage;
        $page = (int)($request->input("page", 1));
        $search = (string)$request->input("search", "");
        $orderBy = $request->orderBy;
        $orderAsc = $request->orderAsc;

        $columnsSerachLike = [
            "codigo",
            "modelo",
            "marca",
            "talla",
            "nombre"
        ];
        $columnsFilter = [];
        $columnsBetweenFilter = [];
        $arrayOrderBy = [];
        if ($orderBy && $orderAsc) {
            $arrayOrderBy = [
                [$orderBy, $orderAsc]
            ];
        }

        $notificacion_users = $this->notificacion_user_service->listadoPaginado($perPage, $page, $search, $columnsSerachLike, $columnsFilter, $columnsBetweenFilter, $arrayOrderBy);
        return response()->JSON([
            "data" => $notificacion_users->items(),
            "total" => $notificacion_users->total(),
            "lastPage" => $notificacion_users->lastPage()
        ]);
    }


    public function getNotificacions(Request $request)
    {
        $notificacion_users = NotificacionUser::with(["notificacion"])
            ->where("user_id", Auth::user()->id)->where("visto", 0)
            ->orderBy("created_at", "desc")->get();

        return response()->JSON([
            "notificacion_users" => $notificacion_users,
        ]);
    }
}
