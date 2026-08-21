<?php

namespace Database\Seeders;

use App\Models\Role;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class RoleTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Role::create([
            "nombre" => "SUPER USUARIO",
            "permisos" => 1,
            "usuarios" => 0,
            "status" => 1,
        ]);
    }
}
