<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class NotificacionUser extends Model
{
    protected $fillable = [
        "user_id",
        "notificacion_id",
        "visto",
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function notificacion()
    {
        return $this->belongsTo(Notificacion::class);
    }
}
