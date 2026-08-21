<?php

namespace Database\Seeders;

use App\Models\Modulo;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class ModuloTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // GESTIÓN DE USUARIOS
        Modulo::create([
            "modulo" => "Gestión de usuarios",
            "nombre" => "usuarios.index",
            "accion" => "VER",
            "descripcion" => "VER LA LISTA DE USUARIOS"
        ]);

        Modulo::create([
            "modulo" => "Gestión de usuarios",
            "nombre" => "usuarios.create",
            "accion" => "CREAR",
            "descripcion" => "CREAR USUARIOS"
        ]);

        Modulo::create([
            "modulo" => "Gestión de usuarios",
            "nombre" => "usuarios.edit",
            "accion" => "EDITAR",
            "descripcion" => "EDITAR USUARIOS"
        ]);

        Modulo::create([
            "modulo" => "Gestión de usuarios",
            "nombre" => "usuarios.destroy",
            "accion" => "ELIMINAR",
            "descripcion" => "ELIMINAR USUARIOS"
        ]);

        // ROLES Y PERMISOS
        Modulo::create([
            "modulo" => "Roles y Permisos",
            "nombre" => "roles.index",
            "accion" => "VER",
            "descripcion" => "VER LA LISTA DE ROLES Y PERMISOS"
        ]);

        Modulo::create([
            "modulo" => "Roles y Permisos",
            "nombre" => "roles.create",
            "accion" => "CREAR",
            "descripcion" => "CREAR ROLES Y PERMISOS"
        ]);

        Modulo::create([
            "modulo" => "Roles y Permisos",
            "nombre" => "roles.edit",
            "accion" => "EDITAR",
            "descripcion" => "EDITAR ROLES Y PERMISOS"
        ]);

        Modulo::create([
            "modulo" => "Roles y Permisos",
            "nombre" => "roles.destroy",
            "accion" => "ELIMINAR",
            "descripcion" => "ELIMINAR ROLES Y PERMISOS"
        ]);

        // CONFIGURACIÓN DEL SISTEMA
        Modulo::create([
            "modulo" => "Configuración",
            "nombre" => "configuracions.index",
            "accion" => "VER",
            "descripcion" => "VER INFORMACIÓN DE LA CONFIGURACIÓN DEL SISTEMA"
        ]);

        Modulo::create([
            "modulo" => "Configuración",
            "nombre" => "configuracions.edit",
            "accion" => "EDITAR",
            "descripcion" => "EDITAR LA CONFIGURACIÓN DEL SISTEMA"
        ]);

        // SUCURSALES
        Modulo::create([
            "modulo" => "Gestión de sucursales",
            "nombre" => "sucursals.index",
            "accion" => "VER",
            "descripcion" => "VER LA LISTA DE SUCURSALES"
        ]);

        Modulo::create([
            "modulo" => "Gestión de sucursales",
            "nombre" => "sucursals.create",
            "accion" => "CREAR",
            "descripcion" => "CREAR SUCURSALES"
        ]);

        Modulo::create([
            "modulo" => "Gestión de sucursales",
            "nombre" => "sucursals.edit",
            "accion" => "EDITAR",
            "descripcion" => "EDITAR SUCURSALES"
        ]);

        Modulo::create([
            "modulo" => "Gestión de sucursales",
            "nombre" => "sucursals.destroy",
            "accion" => "ELIMINAR",
            "descripcion" => "ELIMINAR SUCURSALES"
        ]);

        // CLIENTES
        Modulo::create([
            "modulo" => "Gestión de clientes",
            "nombre" => "clientes.index",
            "accion" => "VER",
            "descripcion" => "VER LA LISTA DE CLIENTES"
        ]);

        Modulo::create([
            "modulo" => "Gestión de clientes",
            "nombre" => "clientes.create",
            "accion" => "CREAR",
            "descripcion" => "CREAR CLIENTES"
        ]);

        Modulo::create([
            "modulo" => "Gestión de clientes",
            "nombre" => "clientes.edit",
            "accion" => "EDITAR",
            "descripcion" => "EDITAR CLIENTES"
        ]);

        Modulo::create([
            "modulo" => "Gestión de clientes",
            "nombre" => "clientes.destroy",
            "accion" => "ELIMINAR",
            "descripcion" => "ELIMINAR CLIENTES"
        ]);

        // NOTIFICACIONES
        Modulo::create([
            "modulo" => "Gestión de notificaciones",
            "nombre" => "notificacions.index",
            "accion" => "RECIBIR Y VER NOTIFICACIONES",
            "descripcion" => "RECIBIR Y VER NOTIFICACIONES"
        ]);

        // REPORTES
        Modulo::create([
            "modulo" => "Reportes",
            "nombre" => "reportes.usuarios",
            "accion" => "REPORTE LISTA DE USUARIOS",
            "descripcion" => "GENERAR REPORTES DE LISTA DE USUARIOS"
        ]);

        Modulo::create([
            "modulo" => "Reportes",
            "nombre" => "reportes.clientes",
            "accion" => "REPORTE LISTA DE CLIENTES",
            "descripcion" => "GENERAR REPORTES DE LISTA DE CLIENTES"
        ]);
    }
}
