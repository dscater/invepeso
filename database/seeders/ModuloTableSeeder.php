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
            "modulo" => "Configuración del sistema",
            "nombre" => "configuracions.index",
            "accion" => "VER",
            "descripcion" => "VER INFORMACIÓN DE LA CONFIGURACIÓN DEL SISTEMA"
        ]);

        Modulo::create([
            "modulo" => "Configuración del sistema",
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

        // ALMACENES
        Modulo::create([
            "modulo" => "Gestión de almacenes",
            "nombre" => "almacens.index",
            "accion" => "VER",
            "descripcion" => "VER LA LISTA DE ALMACENES"
        ]);

        Modulo::create([
            "modulo" => "Gestión de almacenes",
            "nombre" => "almacens.create",
            "accion" => "CREAR",
            "descripcion" => "CREAR ALMACENES"
        ]);

        Modulo::create([
            "modulo" => "Gestión de almacenes",
            "nombre" => "almacens.edit",
            "accion" => "EDITAR",
            "descripcion" => "EDITAR ALMACENES"
        ]);

        Modulo::create([
            "modulo" => "Gestión de almacenes",
            "nombre" => "almacens.destroy",
            "accion" => "ELIMINAR",
            "descripcion" => "ELIMINAR ALMACENES"
        ]);

        // TIPO DE DOCUMENTOS
        Modulo::create([
            "modulo" => "Gestión de tipo de documentos",
            "nombre" => "tipo_documentos.index",
            "accion" => "VER",
            "descripcion" => "VER LA LISTA DE TIPO DE DOCUMENTOS"
        ]);

        Modulo::create([
            "modulo" => "Gestión de tipo de documentos",
            "nombre" => "tipo_documentos.create",
            "accion" => "CREAR",
            "descripcion" => "CREAR TIPO DE DOCUMENTOS"
        ]);

        Modulo::create([
            "modulo" => "Gestión de tipo de documentos",
            "nombre" => "tipo_documentos.edit",
            "accion" => "EDITAR",
            "descripcion" => "EDITAR TIPO DE DOCUMENTOS"
        ]);

        Modulo::create([
            "modulo" => "Gestión de tipo de documentos",
            "nombre" => "tipo_documentos.destroy",
            "accion" => "ELIMINAR",
            "descripcion" => "ELIMINAR TIPO DE DOCUMENTOS"
        ]);

        // CATEGORÍAS
        Modulo::create([
            "modulo" => "Gestión de categorias",
            "nombre" => "categorias.index",
            "accion" => "VER",
            "descripcion" => "VER LA LISTA DE CATEGORÍAS"
        ]);

        Modulo::create([
            "modulo" => "Gestión de categorias",
            "nombre" => "categorias.create",
            "accion" => "CREAR",
            "descripcion" => "CREAR CATEGORÍAS"
        ]);

        Modulo::create([
            "modulo" => "Gestión de categorias",
            "nombre" => "categorias.edit",
            "accion" => "EDITAR",
            "descripcion" => "EDITAR CATEGORÍAS"
        ]);

        Modulo::create([
            "modulo" => "Gestión de categorias",
            "nombre" => "categorias.destroy",
            "accion" => "ELIMINAR",
            "descripcion" => "ELIMINAR CATEGORÍAS"
        ]);

        // MARCAS
        Modulo::create([
            "modulo" => "Gestión de marcas",
            "nombre" => "marcas.index",
            "accion" => "VER",
            "descripcion" => "VER LA LISTA DE MARCAS"
        ]);

        Modulo::create([
            "modulo" => "Gestión de marcas",
            "nombre" => "marcas.create",
            "accion" => "CREAR",
            "descripcion" => "CREAR MARCAS"
        ]);

        Modulo::create([
            "modulo" => "Gestión de marcas",
            "nombre" => "marcas.edit",
            "accion" => "EDITAR",
            "descripcion" => "EDITAR MARCAS"
        ]);

        Modulo::create([
            "modulo" => "Gestión de marcas",
            "nombre" => "marcas.destroy",
            "accion" => "ELIMINAR",
            "descripcion" => "ELIMINAR MARCAS"
        ]);

        // UNIDADES DE MEDIDA
        Modulo::create([
            "modulo" => "Gestión de unidades de medida",
            "nombre" => "unidad_medidas.index",
            "accion" => "VER",
            "descripcion" => "VER LA LISTA DE UNIDADES DE MEDIDA"
        ]);

        Modulo::create([
            "modulo" => "Gestión de unidades de medida",
            "nombre" => "unidad_medidas.create",
            "accion" => "CREAR",
            "descripcion" => "CREAR UNIDADES DE MEDIDA"
        ]);

        Modulo::create([
            "modulo" => "Gestión de unidades de medida",
            "nombre" => "unidad_medidas.edit",
            "accion" => "EDITAR",
            "descripcion" => "EDITAR UNIDADES DE MEDIDA"
        ]);

        Modulo::create([
            "modulo" => "Gestión de unidades de medida",
            "nombre" => "unidad_medidas.destroy",
            "accion" => "ELIMINAR",
            "descripcion" => "ELIMINAR UNIDADES DE MEDIDA"
        ]);

        // PRODUCTOS
        Modulo::create([
            "modulo" => "Gestión de productos",
            "nombre" => "productos.index",
            "accion" => "VER",
            "descripcion" => "VER LA LISTA DE PRODUCTOS"
        ]);

        Modulo::create([
            "modulo" => "Gestión de productos",
            "nombre" => "productos.create",
            "accion" => "CREAR",
            "descripcion" => "CREAR PRODUCTOS"
        ]);

        Modulo::create([
            "modulo" => "Gestión de productos",
            "nombre" => "productos.edit",
            "accion" => "EDITAR",
            "descripcion" => "EDITAR PRODUCTOS"
        ]);

        Modulo::create([
            "modulo" => "Gestión de productos",
            "nombre" => "productos.destroy",
            "accion" => "ELIMINAR",
            "descripcion" => "ELIMINAR PRODUCTOS"
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

        // CLIENTES PRODUCTOS
        Modulo::create([
            "modulo" => "Gestión de clientes",
            "nombre" => "cliente_productos.index",
            "accion" => "VER",
            "descripcion" => "VER LA LISTA DE PRODUCTOS POR CLIENTE"
        ]);

        Modulo::create([
            "modulo" => "Gestión de clientes",
            "nombre" => "cliente_productos.create",
            "accion" => "CREAR",
            "descripcion" => "ASIGNAR PRODUCTOS POR CLIENTE"
        ]);

        Modulo::create([
            "modulo" => "Gestión de clientes",
            "nombre" => "cliente_productos.edit",
            "accion" => "EDITAR",
            "descripcion" => "EDITAR PRODUCTOS ASIGNADOS POR CLIENTE"
        ]);

        Modulo::create([
            "modulo" => "Gestión de clientes",
            "nombre" => "cliente_productos.destroy",
            "accion" => "ELIMINAR",
            "descripcion" => "ELIMINAR PRODUCTOS ASIGNADOS POR CLIENTE"
        ]);

        // TIPO DE INGRESOS
        Modulo::create([
            "modulo" => "Gestión de tipo de ingresos",
            "nombre" => "tipo_ingresos.index",
            "accion" => "VER",
            "descripcion" => "VER LA LISTA DE TIPO DE INGRESOS"
        ]);

        Modulo::create([
            "modulo" => "Gestión de tipo de ingresos",
            "nombre" => "tipo_ingresos.create",
            "accion" => "CREAR",
            "descripcion" => "CREAR TIPO DE INGRESOS"
        ]);

        Modulo::create([
            "modulo" => "Gestión de tipo de ingresos",
            "nombre" => "tipo_ingresos.edit",
            "accion" => "EDITAR",
            "descripcion" => "EDITAR TIPO DE INGRESOS"
        ]);

        Modulo::create([
            "modulo" => "Gestión de tipo de ingresos",
            "nombre" => "tipo_ingresos.destroy",
            "accion" => "ELIMINAR",
            "descripcion" => "ELIMINAR TIPO DE INGRESOS"
        ]);

        // TIPO DE SALIDAS
        Modulo::create([
            "modulo" => "Gestión de tipo de salidas",
            "nombre" => "tipo_salidas.index",
            "accion" => "VER",
            "descripcion" => "VER LA LISTA DE TIPO DE SALIDAS"
        ]);

        Modulo::create([
            "modulo" => "Gestión de tipo de salidas",
            "nombre" => "tipo_salidas.create",
            "accion" => "CREAR",
            "descripcion" => "CREAR TIPO DE SALIDAS"
        ]);

        Modulo::create([
            "modulo" => "Gestión de tipo de salidas",
            "nombre" => "tipo_salidas.edit",
            "accion" => "EDITAR",
            "descripcion" => "EDITAR TIPO DE SALIDAS"
        ]);

        Modulo::create([
            "modulo" => "Gestión de tipo de salidas",
            "nombre" => "tipo_salidas.destroy",
            "accion" => "ELIMINAR",
            "descripcion" => "ELIMINAR TIPO DE SALIDAS"
        ]);

        // PROVEEDORES
        Modulo::create([
            "modulo" => "Gestión de proveedores",
            "nombre" => "proveedors.index",
            "accion" => "VER",
            "descripcion" => "VER LA LISTA DE PROVEEDORES"
        ]);

        Modulo::create([
            "modulo" => "Gestión de proveedores",
            "nombre" => "proveedors.create",
            "accion" => "CREAR",
            "descripcion" => "CREAR PROVEEDORES"
        ]);

        Modulo::create([
            "modulo" => "Gestión de proveedores",
            "nombre" => "proveedors.edit",
            "accion" => "EDITAR",
            "descripcion" => "EDITAR PROVEEDORES"
        ]);

        Modulo::create([
            "modulo" => "Gestión de proveedores",
            "nombre" => "proveedors.destroy",
            "accion" => "ELIMINAR",
            "descripcion" => "ELIMINAR PROVEEDORES"
        ]);

        // INGRESO DE PRODUCTOS
        Modulo::create([
            "modulo" => "Gestión de Inventario de Productos",
            "nombre" => "ingreso_productos.index",
            "accion" => "VER",
            "descripcion" => "VER EL HISTORIAL DE COMPRAS"
        ]);

        Modulo::create([
            "modulo" => "Gestión de Inventario de Productos",
            "nombre" => "ingreso_productos.create",
            "accion" => "CREAR",
            "descripcion" => "CREAR ORDENES DE COMPRA"
        ]);

        Modulo::create([
            "modulo" => "Gestión de Inventario de Productos",
            "nombre" => "ingreso_productos.edit",
            "accion" => "EDITAR",
            "descripcion" => "EDITAR ORDENES DE COMPRA"
        ]);

        Modulo::create([
            "modulo" => "Gestión de Inventario de Productos",
            "nombre" => "ingreso_productos.destroy",
            "accion" => "ELIMINAR",
            "descripcion" => "ELIMINAR ORDENES DE COMPRA"
        ]);

        // recepcion
        Modulo::create([
            "modulo" => "Gestión de Inventario de Productos",
            "nombre" => "ingreso_productos.verificacion_ingresos",
            "accion" => "VER",
            "descripcion" => "LISTA DE RECEPCIÓN DE COMPRAS"
        ]);

        Modulo::create([
            "modulo" => "Gestión de Inventario de Productos",
            "nombre" => "ingreso_productos.verificacion_create",
            "accion" => "CREAR",
            "descripcion" => "REGISTRAR RECEPCIÓN DE COMPRAS"
        ]);

        // faltantes
        Modulo::create([
            "modulo" => "Gestión de Inventario de Productos",
            "nombre" => "ingreso_productos.faltantes_ingresos",
            "accion" => "VER",
            "descripcion" => "VER ORDENES DE COMPRA CON FALTANTES DE PRODUCTOS"
        ]);

        Modulo::create([
            "modulo" => "Gestión de Inventario de Productos",
            "nombre" => "ingreso_productos.faltantes_create",
            "accion" => "CREAR",
            "descripcion" => "REGISTRAR FALTANTES DE PRODUCTOS"
        ]);

        // pagos
        Modulo::create([
            "modulo" => "Gestión de Inventario de Productos",
            "nombre" => "ingreso_productos.pagos",
            "accion" => "VER",
            "descripcion" => "LISTA DE PAGOS PENDIENTES POR COMPRAS"
        ]);

        Modulo::create([
            "modulo" => "Gestión de Inventario de Productos",
            "nombre" => "ingreso_productos.registrar_pago",
            "accion" => "CREAR",
            "descripcion" => "REGISTRAR PAGOS POR COMPRAS"
        ]);

        Modulo::create([
            "modulo" => "Gestión de Inventario de Productos",
            "nombre" => "ingreso_productos.actualizar_pago",
            "accion" => "EDITAR",
            "descripcion" => "ACTUALIZAR PAGOS POR COMPRAS"
        ]);

        Modulo::create([
            "modulo" => "Gestión de Inventario de Productos",
            "nombre" => "ingreso_productos.eliminar_pago",
            "accion" => "ELIMINAR",
            "descripcion" => "ELIMINAR PAGOS POR COMPRAS"
        ]);

        // PRODUCTOS POR ALMACÉN-SUCURSAL
        Modulo::create([
            "modulo" => "Gestión de Inventario de Productos",
            "nombre" => "producto_sucursals.index",
            "accion" => "VER",
            "descripcion" => "VER LA LISTA DE PRODUCTOS POR ALMACÉN-SUCURSAL"
        ]);

        Modulo::create([
            "modulo" => "Gestión de Inventario de Productos",
            "nombre" => "producto_sucursals.create",
            "accion" => "CREAR",
            "descripcion" => "CARGAR PRODUCTOS POR ALMACÉN-SUCURSAL"
        ]);

        // SALIDA DE PRODUCTOS
        Modulo::create([
            "modulo" => "Gestión de salida de productos",
            "nombre" => "salida_productos.index",
            "accion" => "VER",
            "descripcion" => "VER LA LISTA DE SALIDA DE PRODUCTOS"
        ]);

        Modulo::create([
            "modulo" => "Gestión de salida de productos",
            "nombre" => "salida_productos.create",
            "accion" => "CREAR",
            "descripcion" => "CREAR SALIDA DE PRODUCTOS"
        ]);

        Modulo::create([
            "modulo" => "Gestión de salida de productos",
            "nombre" => "salida_productos.edit",
            "accion" => "EDITAR",
            "descripcion" => "EDITAR SALIDA DE PRODUCTOS"
        ]);

        Modulo::create([
            "modulo" => "Gestión de salida de productos",
            "nombre" => "salida_productos.destroy",
            "accion" => "ELIMINAR",
            "descripcion" => "ELIMINAR SALIDA DE PRODUCTOS"
        ]);

        // MOVIMIENTO DE CAJAS
        Modulo::create([
            "modulo" => "Gestión de movimientos de cajas",
            "nombre" => "movimiento_cajas.index",
            "accion" => "VER",
            "descripcion" => "VER LA LISTA DE MOVIMIENTO DE CAJAS"
        ]);

        Modulo::create([
            "modulo" => "Gestión de movimientos de cajas",
            "nombre" => "movimiento_cajas.create",
            "accion" => "CREAR",
            "descripcion" => "CREAR MOVIMIENTO DE CAJAS"
        ]);

        Modulo::create([
            "modulo" => "Gestión de movimientos de cajas",
            "nombre" => "movimiento_cajas.edit",
            "accion" => "EDITAR",
            "descripcion" => "EDITAR MOVIMIENTO DE CAJAS"
        ]);

        Modulo::create([
            "modulo" => "Gestión de movimientos de cajas",
            "nombre" => "movimiento_cajas.destroy",
            "accion" => "ELIMINAR",
            "descripcion" => "ELIMINAR MOVIMIENTO DE CAJAS"
        ]);

        // TRASPASO DE PRODUCTOS
        Modulo::create([
            "modulo" => "Gestión de traspaso de productos",
            "nombre" => "traspasos.index",
            "accion" => "VER",
            "descripcion" => "VER LA LISTA DE TRASPASO DE PRODUCTOS"
        ]);

        Modulo::create([
            "modulo" => "Gestión de traspaso de productos",
            "nombre" => "traspasos.create",
            "accion" => "CREAR",
            "descripcion" => "CREAR TRASPASO DE PRODUCTOS"
        ]);

        Modulo::create([
            "modulo" => "Gestión de traspaso de productos",
            "nombre" => "traspasos.edit",
            "accion" => "EDITAR",
            "descripcion" => "EDITAR TRASPASO DE PRODUCTOS"
        ]);

        Modulo::create([
            "modulo" => "Gestión de traspaso de productos",
            "nombre" => "traspasos.destroy",
            "accion" => "ELIMINAR",
            "descripcion" => "ELIMINAR TRASPASO DE PRODUCTOS"
        ]);

        // VENTAS
        Modulo::create([
            "modulo" => "Gestión de ventas",
            "nombre" => "ventas.index",
            "accion" => "VER",
            "descripcion" => "VER LA LISTA DE VENTAS"
        ]);

        Modulo::create([
            "modulo" => "Gestión de ventas",
            "nombre" => "ventas.create",
            "accion" => "CREAR",
            "descripcion" => "CREAR VENTAS"
        ]);

        Modulo::create([
            "modulo" => "Gestión de ventas",
            "nombre" => "ventas.edit",
            "accion" => "EDITAR",
            "descripcion" => "EDITAR VENTAS"
        ]);

        Modulo::create([
            "modulo" => "Gestión de ventas",
            "nombre" => "ventas.destroy",
            "accion" => "ELIMINAR",
            "descripcion" => "ELIMINAR VENTAS"
        ]);

        // cobros
        Modulo::create([
            "modulo" => "Gestión de ventas",
            "nombre" => "ventas.cobros",
            "accion" => "VER",
            "descripcion" => "VER LA LISTA DE COBROS PENDIENTES"
        ]);

        Modulo::create([
            "modulo" => "Gestión de ventas",
            "nombre" => "ventas.registrar_cobro",
            "accion" => "CREAR",
            "descripcion" => "REGISTRAR PAGOS DE COBROS PENDIENTES"
        ]);

        Modulo::create([
            "modulo" => "Gestión de ventas",
            "nombre" => "ventas.actualizar_cobro",
            "accion" => "EDITAR",
            "descripcion" => "ACTUALIZAR PAGOS DE COBROS PENDIENTES"
        ]);

        Modulo::create([
            "modulo" => "Gestión de ventas",
            "nombre" => "ventas.eliminar_cobro",
            "accion" => "ELIMINAR",
            "descripcion" => "ELIMINAR PAGOS DE COBROS PENDIENTES"
        ]);

        // PROFORMAS
        Modulo::create([
            "modulo" => "Gestión de proformas",
            "nombre" => "proformas.index",
            "accion" => "VER",
            "descripcion" => "VER LA LISTA DE PROFORMAS"
        ]);

        Modulo::create([
            "modulo" => "Gestión de proformas",
            "nombre" => "proformas.create",
            "accion" => "CREAR",
            "descripcion" => "CREAR PROFORMAS"
        ]);

        Modulo::create([
            "modulo" => "Gestión de proformas",
            "nombre" => "proformas.edit",
            "accion" => "EDITAR",
            "descripcion" => "EDITAR PROFORMAS"
        ]);

        Modulo::create([
            "modulo" => "Gestión de proformas",
            "nombre" => "proformas.destroy",
            "accion" => "ELIMINAR",
            "descripcion" => "ELIMINAR PROFORMAS"
        ]);

        // NOTIFICACIONES
        Modulo::create([
            "modulo" => "Gestión de notificaciones",
            "nombre" => "notificacion_users.index",
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

        Modulo::create([
            "modulo" => "Reportes",
            "nombre" => "reportes.productos",
            "accion" => "REPORTE LISTA DE PRODUCTOS",
            "descripcion" => "GENERAR REPORTES DE LISTA DE PRODUCTOS"
        ]);

        Modulo::create([
            "modulo" => "Reportes",
            "nombre" => "reportes.proveedors",
            "accion" => "REPORTE LISTA DE PROVEEDORES",
            "descripcion" => "GENERAR REPORTES DE LISTA DE PROVEEDORES"
        ]);

        Modulo::create([
            "modulo" => "Reportes",
            "nombre" => "reportes.stock_productos",
            "accion" => "REPORTE LISTA DE STOCK POR PRODUCTOS",
            "descripcion" => "GENERAR REPORTES DE LISTA DE STOCK PRODUCTOS"
        ]);

        Modulo::create([
            "modulo" => "Reportes",
            "nombre" => "reportes.orden_compras",
            "accion" => "REPORTE LISTA DE ORDENES DE COMPRA",
            "descripcion" => "GENERAR LISTADO DE ORDENES DE COMPRA"
        ]);

        Modulo::create([
            "modulo" => "Reportes",
            "nombre" => "reportes.salida_productos",
            "accion" => "REPORTE LISTA DE SALIDAS DE PRODUCTOS",
            "descripcion" => "GENERAR LISTADO DE SALIDAS DE PRODUCTOS"
        ]);

        Modulo::create([
            "modulo" => "Reportes",
            "nombre" => "reportes.ventas",
            "accion" => "REPORTE LISTA DE VENTAS",
            "descripcion" => "GENERAR LISTADO DE VENTAS"
        ]);

        Modulo::create([
            "modulo" => "Reportes",
            "nombre" => "reportes.venta_detalles",
            "accion" => "REPORTE LISTA DE VENTAS",
            "descripcion" => "GENERAR VENTAS CON DETALLES"
        ]);

        Modulo::create([
            "modulo" => "Reportes",
            "nombre" => "reportes.proformas",
            "accion" => "REPORTE LISTA DE PROFORMAS",
            "descripcion" => "GENERAR LISTADO DE PROFORMAS"
        ]);

        Modulo::create([
            "modulo" => "Reportes",
            "nombre" => "reportes.recepcions",
            "accion" => "REPORTE DE RECEPCIÓN DE PRODUCTOS",
            "descripcion" => "GENERAR REPORTE DE LA RECEPCIÓN DE PRODUCTOS POR COMPRAS"
        ]);

        Modulo::create([
            "modulo" => "Reportes",
            "nombre" => "reportes.faltantes",
            "accion" => "REPORTE DE RECEPCIÓN DE FALTANTES",
            "descripcion" => "GENERAR REPORTE DE RECEPCIÓN DE FALTANTES POR COMPRAS"
        ]);

        Modulo::create([
            "modulo" => "Reportes",
            "nombre" => "reportes.pago_compras",
            "accion" => "REPORTE DE PAGOS REALIZADOS POR COMPRAS",
            "descripcion" => "GENERAR REPORTE DE LOS PAGOS REALIZADOS POR COMPRAS"
        ]);

        Modulo::create([
            "modulo" => "Reportes",
            "nombre" => "reportes.compras_credito",
            "accion" => "REPORTE DE COMPRAS A CRÉDITO",
            "descripcion" => "GENERAR REPORTE DE COMPRAS A CRÉDITO"
        ]);

        Modulo::create([
            "modulo" => "Reportes",
            "nombre" => "reportes.cobro_creditos",
            "accion" => "REPORTE DE COBROS REALIZADOS POR VENTAS A CRÉDITO",
            "descripcion" => "GENERAR REPORTE DE COBROS REALIZADOS POR VENTAS A CRÉDITO"
        ]);

        Modulo::create([
            "modulo" => "Reportes",
            "nombre" => "reportes.ventas_creditos",
            "accion" => "REPORTE DE VENTAS A CRÉDITO",
            "descripcion" => "GENERAR REPORTE DE VENTAS A CRÉDITO"
        ]);

        Modulo::create([
            "modulo" => "Reportes",
            "nombre" => "reportes.movimiento_cajas",
            "accion" => "REPORTE DE MOVIMIENTOS DE CAJA",
            "descripcion" => "GENERAR REPORTE DE LOS MOVIMIENTOS DE CAJA"
        ]);
    }
}
