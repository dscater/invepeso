<?php

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

class Notificacion extends Model
{
    protected $fillable = [
        "tipo",
        "modulo",
        "registro_id",
        "descripcion",
        "fecha",
        "hora",
    ];

    protected $appends = ["hace", "fecha_t", "fecha_c", "icon", "url"];

    public function getUrlAttribute()
    {
        // if ($this->tipo == 'STOCK') {
        //     return route('producto_sucursals.index');
        // }

        return route('notificacion_users.show', $this->id);
    }

    public function getIconAttribute()
    {
        if (strpos($this->tipo, "STOCK") !== false)
            return 'fa fa-box-open text-danger';

        return 'fa fa-envelope';
    }

    public function getFechaCAttribute()
    {
        return date("d/m/Y H:i", strtotime($this->fecha . ' ' . $this->hora));
    }

    public function getFechaTAttribute()
    {
        return date("d/m/Y", strtotime($this->fecha));
    }
    public function getHaceAttribute()
    {
        Carbon::setLocale('es');
        return $this->created_at->diffForHumans();
    }

    public function notificacion_users()
    {
        return $this->hasMany(NotificacionUser::class, 'notificacion_id');
    }
}
