<?php

use App\Http\Controllers\AlmacenController;
use App\Http\Controllers\CajaController;
use App\Http\Controllers\CategoriaController;
use App\Http\Controllers\ClienteController;
use App\Http\Controllers\ConfiguracionController;
use App\Http\Controllers\IngresoPagoController;
use App\Http\Controllers\IngresoProductoController;
use App\Http\Controllers\InicioController;
use App\Http\Controllers\MarcaController;
use App\Http\Controllers\MovimientoCajaController;
use App\Http\Controllers\ProductoController;
use App\Http\Controllers\ProductoSucursalController;
use App\Http\Controllers\ProfileController;
use App\Http\Controllers\ProformaController;
use App\Http\Controllers\ProveedorController;
use App\Http\Controllers\ReporteController;
use App\Http\Controllers\RoleController;
use App\Http\Controllers\SalidaProductoController;
use App\Http\Controllers\SucursalController;
use App\Http\Controllers\TipoDocumentoController;
use App\Http\Controllers\TipoIngresoController;
use App\Http\Controllers\TipoPagoController;
use App\Http\Controllers\TipoSalidaController;
use App\Http\Controllers\TipoUsuarioController;
use App\Http\Controllers\TipoVentaController;
use App\Http\Controllers\TraspasoController;
use App\Http\Controllers\UnidadMedidaController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\UsuarioController;
use App\Http\Controllers\VentaCobroController;
use App\Http\Controllers\VentaController;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

Route::get('/', function () {
    if (Auth::check()) {
        return redirect()->route('inicio');
    }
    return Inertia::render('Auth/Login');
});

Route::get('/login', function () {
    if (Auth::check()) {
        return redirect()->route('inicio');
    }
    return Inertia::render('Auth/Login');
})->name("login");

Route::get("configuracions/getConfiguracion", [ConfiguracionController::class, 'getConfiguracion'])->name("configuracions.getConfiguracion");

Route::get('/clear-cache', function () {
    Artisan::call('config:cache');
    Artisan::call('config:clear');
    Artisan::call('optimize');
    return 'Cache eliminado <a href="/">Ir al inicio</a>';
})->name('clear.cache');

Route::get("sincronizarInicio", [CertificadoEmitidoController::class, 'sincronizarInicio']);

// ADMINISTRACION
Route::middleware(['auth', 'permisoUsuario'])->prefix("admin")->group(function () {
    // INICIO
    Route::get('/inicio', [InicioController::class, 'inicio'])->name('inicio');
    Route::get('/certificadosEmitidosLinea', [InicioController::class, 'certificadosEmitidosLinea'])->name('certificadosEmitidosLinea');
    Route::get('/cantidadTramitesNormal', [InicioController::class, 'cantidadTramitesNormal'])->name('cantidadTramitesNormal');

    // CONFIGURACION
    Route::resource("configuracions", ConfiguracionController::class)->only(
        ["index", "show", "update"]
    );

    // TIPO PAGOS
    Route::get("tipo_pagos/listado", [TipoPagoController::class, 'listado'])->name("tipo_pagos.listado");

    // TIPO VENTA
    Route::get("tipo_ventas/listado", [TipoVentaController::class, 'listado'])->name("tipo_ventas.listado");

    // USUARIO
    Route::get('profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::patch('profile/update_foto', [ProfileController::class, 'update_foto'])->name('profile.update_foto');
    Route::delete('profile', [ProfileController::class, 'destroy'])->name('profile.destroy');
    Route::get("getUser", [UserController::class, 'getUser'])->name('users.getUser');
    Route::get("permisosUsuario", [UserController::class, 'permisosUsuario']);

    // USUARIOS
    Route::put("usuarios/password/{user}", [UsuarioController::class, 'actualizaPassword'])->name("usuarios.password");
    Route::get("usuarios/paginado", [UsuarioController::class, 'paginado'])->name("usuarios.paginado");
    Route::get("usuarios/listado", [UsuarioController::class, 'listado'])->name("usuarios.listado");
    Route::get("usuarios/listado/byTipo", [UsuarioController::class, 'byTipo'])->name("usuarios.byTipo");
    Route::get("usuarios/show/{user}", [UsuarioController::class, 'show'])->name("usuarios.show");
    Route::put("usuarios/update/{user}", [UsuarioController::class, 'update'])->name("usuarios.update");
    Route::delete("usuarios/{user}", [UsuarioController::class, 'destroy'])->name("usuarios.destroy");
    Route::resource("usuarios", UsuarioController::class)->only(
        ["index", "store"]
    );

    // ROLES
    Route::get("roles/api", [RoleController::class, 'api'])->name("roles.api");
    Route::get("roles/paginado", [RoleController::class, 'paginado'])->name("roles.paginado");
    Route::get("roles/listado", [RoleController::class, 'listado'])->name("roles.listado");
    Route::post("roles/actualizaPermiso/{role}", [RoleController::class, 'actualizaPermiso'])->name("roles.actualizaPermiso");
    Route::resource("roles", RoleController::class)->only(
        ["index", "store", "edit", "show", "update", "destroy"]
    );

    // TIPO USUARIOS
    Route::get("tipo_usuarios/listado", [TipoUsuarioController::class, 'listado'])->name("tipo_usuarios.listado");

    // SUCURSALES
    Route::get("sucursals/paginado", [SucursalController::class, 'paginado'])->name("sucursals.paginado");
    Route::get("sucursals/listado", [SucursalController::class, 'listado'])->name("sucursals.listado");
    Route::resource("sucursals", SucursalController::class)->only(
        ["index", "store", "edit", "show", "update", "destroy"]
    );

    // ALMACENES
    Route::get("almacens/paginado", [AlmacenController::class, 'paginado'])->name("almacens.paginado");
    Route::get("almacens/listado", [AlmacenController::class, 'listado'])->name("almacens.listado");
    Route::resource("almacens", AlmacenController::class)->only(
        ["index", "store", "edit", "show", "update", "destroy"]
    );

    // TIPO DOCUMENTOS
    Route::get("tipo_documentos/paginado", [TipoDocumentoController::class, 'paginado'])->name("tipo_documentos.paginado");
    Route::get("tipo_documentos/listado", [TipoDocumentoController::class, 'listado'])->name("tipo_documentos.listado");
    Route::resource("tipo_documentos", TipoDocumentoController::class)->only(
        ["index", "store", "edit", "show", "update", "destroy"]
    );

    // CLIENTES
    Route::post("clientes/nuevo", [ClienteController::class, 'nuevo'])->name("clientes.nuevo");
    Route::get("clientes/paginado", [ClienteController::class, 'paginado'])->name("clientes.paginado");
    Route::get("clientes/listado", [ClienteController::class, 'listado'])->name("clientes.listado");
    Route::get("clientes/byCi", [ClienteController::class, 'byCi'])->name("clientes.byCi");
    Route::get("clientes/formato", [ClienteController::class, 'formato'])->name("clientes.formato");
    Route::post("clientes/cargaClientes", [ClienteController::class, 'cargaClientes'])->name("clientes.cargaClientes");
    Route::resource("clientes", ClienteController::class)->only(
        ["index", "store", "edit", "show", "update", "destroy"]
    );

    // CATEGORIAS
    Route::get("categorias/paginado", [CategoriaController::class, 'paginado'])->name("categorias.paginado");
    Route::get("categorias/listado", [CategoriaController::class, 'listado'])->name("categorias.listado");
    Route::resource("categorias", CategoriaController::class)->only(
        ["index", "store", "edit", "show", "update", "destroy"]
    );

    // MARCAS
    Route::get("marcas/paginado", [MarcaController::class, 'paginado'])->name("marcas.paginado");
    Route::get("marcas/listado", [MarcaController::class, 'listado'])->name("marcas.listado");
    Route::resource("marcas", MarcaController::class)->only(
        ["index", "store", "edit", "show", "update", "destroy"]
    );

    // UNIDAD MEDIDAS
    Route::get("unidad_medidas/paginado", [UnidadMedidaController::class, 'paginado'])->name("unidad_medidas.paginado");
    Route::get("unidad_medidas/listado", [UnidadMedidaController::class, 'listado'])->name("unidad_medidas.listado");
    Route::resource("unidad_medidas", UnidadMedidaController::class)->only(
        ["index", "store", "edit", "show", "update", "destroy"]
    );

    // PRODUCTOS
    Route::get("productos/paginado", [ProductoController::class, 'paginado'])->name("productos.paginado");
    Route::get("productos/listado", [ProductoController::class, 'listado'])->name("productos.listado");
    Route::get("productos/formato", [ProductoController::class, 'formato'])->name("productos.formato");
    Route::post("productos/cargaProductos", [ProductoController::class, 'cargaProductos'])->name("productos.cargaProductos");
    Route::resource("productos", ProductoController::class)->only(
        ["index", "store", "edit", "show", "update", "destroy"]
    );

    // TIPO DE INGRESOS
    Route::get("tipo_ingresos/paginado", [TipoIngresoController::class, 'paginado'])->name("tipo_ingresos.paginado");
    Route::get("tipo_ingresos/listado", [TipoIngresoController::class, 'listado'])->name("tipo_ingresos.listado");
    Route::resource("tipo_ingresos", TipoIngresoController::class)->only(
        ["index", "store", "edit", "show", "update", "destroy"]
    );

    // TIPO DE SALIDAS
    Route::get("tipo_salidas/paginado", [TipoSalidaController::class, 'paginado'])->name("tipo_salidas.paginado");
    Route::get("tipo_salidas/listado", [TipoSalidaController::class, 'listado'])->name("tipo_salidas.listado");
    Route::resource("tipo_salidas", TipoSalidaController::class)->only(
        ["index", "store", "edit", "show", "update", "destroy"]
    );

    // PROVEEDORES
    Route::get("proveedors/paginado", [ProveedorController::class, 'paginado'])->name("proveedors.paginado");
    Route::get("proveedors/listado", [ProveedorController::class, 'listado'])->name("proveedors.listado");
    Route::get("proveedors/formato", [ProveedorController::class, 'formato'])->name("proveedors.formato");
    Route::post("proveedors/cargaProveedors", [ProveedorController::class, 'cargaProveedors'])->name("proveedors.cargaProveedors");
    Route::resource("proveedors", ProveedorController::class)->only(
        ["index", "store", "edit", "show", "update", "destroy"]
    );

    // INGRESOS
    Route::get("ingreso_productos/paginado", [IngresoProductoController::class, 'paginado'])->name("ingreso_productos.paginado");
    Route::get("ingreso_productos/listado", [IngresoProductoController::class, 'listado'])->name("ingreso_productos.listado");
    Route::get("ingreso_productos/lista_sin_verificar", [IngresoProductoController::class, 'lista_sin_verificar'])->name("ingreso_productos.lista_sin_verificar");
    Route::get("ingreso_productos/lista_faltantes", [IngresoProductoController::class, 'lista_faltantes'])->name("ingreso_productos.lista_faltantes");
    Route::get("ingreso_productos/lista_para_reponer", [IngresoProductoController::class, 'lista_para_reponer'])->name("ingreso_productos.lista_para_reponer");
    Route::get("ingreso_productos/verificacion_ingresos", [IngresoProductoController::class, 'verificacion_ingresos'])->name("ingreso_productos.verificacion_ingresos");
    Route::put("ingreso_productos/verificar/{ingreso_producto}", [IngresoProductoController::class, 'verificar'])->name("ingreso_productos.verificar");
    Route::get("ingreso_productos/faltantes_ingresos", [IngresoProductoController::class, 'faltantes_ingresos'])->name("ingreso_productos.faltantes_ingresos");
    Route::put("ingreso_productos/faltante/{ingreso_producto}", [IngresoProductoController::class, 'faltante'])->name("ingreso_productos.faltante");
    Route::get("ingreso_productos/pagos", [IngresoProductoController::class, 'pagos'])->name("ingreso_productos.pagos");
    Route::get("ingreso_productos/pagos/lista_pagos_pendientes", [IngresoProductoController::class, 'lista_pagos_pendientes'])->name("ingreso_productos.lista_pagos_pendientes");
    Route::post("ingreso_productos/registrar_pago/{ingreso_producto}", [IngresoProductoController::class, 'registrar_pago'])->name("ingreso_productos.registrar_pago");
    Route::put("ingreso_productos/actualizar_pago/{ingreso_pago}", [IngresoProductoController::class, 'actualizar_pago'])->name("ingreso_productos.actualizar_pago");
    Route::delete("ingreso_productos/eliminar_pago/{ingreso_pago}", [IngresoProductoController::class, 'eliminar_pago'])->name("ingreso_productos.eliminar_pago");
    Route::get("ingreso_productos/pdf/{ingreso_producto}", [IngresoProductoController::class, 'pdf'])->name("ingreso_productos.pdf");
    Route::get("ingreso_productos/verificar_pdf/{ingreso_producto}", [IngresoProductoController::class, 'verificar_pdf'])->name("ingreso_productos.verificar_pdf");
    Route::resource("ingreso_productos", IngresoProductoController::class)->only(
        ["index", "create", "store", "edit", "show", "update", "destroy"]
    );

    // INGRESO PAGOS
    Route::get("ingreso_pagos/listaByIngreso/{ingreso_producto}", [IngresoPagoController::class, 'listaByIngreso'])->name("ingreso_pagos.listaByIngreso");

    // SALIDAS
    Route::get("salida_productos/paginado", [SalidaProductoController::class, 'paginado'])->name("salida_productos.paginado");
    Route::get("salida_productos/listado", [SalidaProductoController::class, 'listado'])->name("salida_productos.listado");
    Route::resource("salida_productos", SalidaProductoController::class)->only(
        ["index", "create", "store", "edit", "show", "update", "destroy"]
    );

    // MOVIMIENTO CAJAS
    Route::get("movimiento_cajas/paginado", [MovimientoCajaController::class, 'paginado'])->name("movimiento_cajas.paginado");
    Route::get("movimiento_cajas/listado", [MovimientoCajaController::class, 'listado'])->name("movimiento_cajas.listado");
    Route::resource("movimiento_cajas", MovimientoCajaController::class)->only(
        ["index", "create", "store", "edit", "show", "update", "destroy"]
    );

    // TRASPASOS
    Route::get("traspasos/paginado", [TraspasoController::class, 'paginado'])->name("traspasos.paginado");
    Route::get("traspasos/listado", [TraspasoController::class, 'listado'])->name("traspasos.listado");
    Route::resource("traspasos", TraspasoController::class)->only(
        ["index", "create", "store", "edit", "show", "update", "destroy"]
    );

    // VENTAS
    Route::get("ventas/paginado", [VentaController::class, 'paginado'])->name("ventas.paginado");
    Route::get("ventas/eliminados", [VentaController::class, 'eliminados'])->name("ventas.eliminados");
    Route::get("ventas/paginado_eliminados", [VentaController::class, 'paginado_eliminados'])->name("ventas.paginado_eliminados");
    Route::post("ventas/restaurar/{venta}", [VentaController::class, 'restaurar'])->name("ventas.restaurar");
    Route::delete("ventas/eliminar_permanente/{venta}", [VentaController::class, 'eliminar_permanente'])->name("ventas.eliminar_permanente");
    Route::get("ventas/listado", [VentaController::class, 'listado'])->name("ventas.listado");
    Route::get("ventas/cobros", [VentaController::class, 'cobros'])->name("ventas.cobros");
    Route::get("ventas/cobros/lista_cobros_pendientes", [VentaController::class, 'lista_cobros_pendientes'])->name("ventas.lista_cobros_pendientes");
    Route::post("ventas/registrar_cobro/{venta}", [VentaController::class, 'registrar_cobro'])->name("ventas.registrar_cobro");
    Route::put("ventas/actualizar_cobro/{venta_cobro}", [VentaController::class, 'actualizar_cobro'])->name("ventas.actualizar_cobro");
    Route::delete("ventas/eliminar_cobro/{venta_cobro}", [VentaController::class, 'eliminar_cobro'])->name("ventas.eliminar_cobro");
    Route::resource("ventas", VentaController::class)->only(
        ["index", "create", "store", "edit", "show", "update", "destroy"]
    );

    // VENTA COBROS
    Route::get("venta_cobros/listaByVenta/{venta}", [VentaCobroController::class, 'listaByVenta'])->name("venta_cobros.listaByVenta");

    // PROFORMAS
    Route::get("proformas/paginado", [ProformaController::class, 'paginado'])->name("proformas.paginado");
    Route::get("proformas/listado", [ProformaController::class, 'listado'])->name("proformas.listado");
    Route::resource("proformas", ProformaController::class)->only(
        ["index", "create", "store", "edit", "show", "update", "destroy"]
    );

    // PRODUCTOS SUCURSAL
    Route::get("producto_sucursals/paginado", [ProductoSucursalController::class, 'paginado'])->name("producto_sucursals.paginado");
    Route::get("producto_sucursals/listado", [ProductoSucursalController::class, 'listado'])->name("producto_sucursals.listado");
    Route::get("producto_sucursals/formato", [ProductoSucursalController::class, 'formato'])->name("producto_sucursals.formato");
    Route::post("producto_sucursals/cargaProductoSucursals", [ProductoSucursalController::class, 'cargaProductoSucursals'])->name("producto_sucursals.cargaProductoSucursals");
    Route::resource("producto_sucursals", ProductoSucursalController::class)->only(
        ["index", "store", "edit", "show", "update", "destroy"]
    );

    // REPORTES
    Route::get('reportes/usuarios', [ReporteController::class, 'usuarios'])->name("reportes.usuarios");
    Route::get('reportes/r_usuarios', [ReporteController::class, 'r_usuarios'])->name("reportes.r_usuarios");
});
require __DIR__ . '/auth.php';
