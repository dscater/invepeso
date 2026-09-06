<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Log;

class Cliente extends Model
{
    protected $fillable = [
        "nombre",
        "tipo_documento_id",
        "nro_documento",
        "complemento",
        "fono",
        "correo",
        "fecha_registro",
        "status",
    ];

    protected $appends = ["fecha_registro_t", "full_ci", "fecha_nac_t", "full_name"];

    public function getFullNameAttribute()
    {
        return $this->nombre . ' ' . $this->paterno . ($this->materno ? ' ' . $this->materno : '');
    }
    public function getFechaNacTAttribute()
    {
        if ($this->fecha_nac) {
            return date("d/m/Y", strtotime($this->fecha_nac));
        }
        return "";
    }
    public function getFullCiAttribute()
    {
        return $this->nro_documento . ($this->complemento ? '-' . $this->complemento : '');
    }

    public function getFechaRegistroTAttribute()
    {
        return date("d/m/Y", strtotime($this->fecha_registro));
    }

    public function scopeBuscarNombre($query, $texto)
    {
        if (!$texto) return $query;

        $palabras = explode(' ', $texto);

        foreach ($palabras as $palabra) {
            $query->where(function ($q) use ($palabra) {
                $q->where('nombre', 'like', "%$palabra%")
                    ->orWhere('nro_documento', 'like', "%$palabra%");
            });
        }

        return $query;
    }

    public function tipo_documento()
    {
        return $this->belongsTo(TipoDocumento::class, 'tipo_documento_id');
    }
}
