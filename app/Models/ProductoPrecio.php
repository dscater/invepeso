<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ProductoPrecio extends Model
{
    protected $fillable = [
        "user_id",
        "fecha",
        "hora",
        "total_productos",
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }
}
