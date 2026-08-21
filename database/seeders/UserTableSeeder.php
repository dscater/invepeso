<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class UserTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        User::create([
            "usuario" => "admin",
            "nombre" => "admin",
            "paterno" => "admin",
            "materno" => "",
            "ci" => "0",
            "ci_exp" => "",
            "dir" => "",
            "correo" => "",
            "fono" => "",
            "password" => "admin",
            "acceso" => 1,
            "sucursal_id" => NULL,
            "role_id" => 1,
            "sucursal_todos" => 1,
            "fecha_registro" => date("Y-m-d"),
            "status" => 1,
        ]);
    }
}
