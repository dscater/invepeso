-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 19-10-2026 a las 14:46:44
-- Versión del servidor: 8.0.30
-- Versión de PHP: 8.2.22

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `invepeso_db`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `almacens`
--

CREATE TABLE `almacens` (
  `id` bigint UNSIGNED NOT NULL,
  `sucursal_id` bigint UNSIGNED NOT NULL,
  `nombre` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(900) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_registro` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `almacens`
--

INSERT INTO `almacens` (`id`, `sucursal_id`, `nombre`, `descripcion`, `activo`, `fecha_registro`, `created_at`, `updated_at`) VALUES
(1, 1, 'ALMACEN CENTRAL', '', 1, '2026-08-28', '2026-08-28 15:44:12', '2026-08-28 15:44:12'),
(2, 2, 'ALMACEN 1', '', 1, '2026-09-04', '2026-09-04 14:35:38', '2026-09-04 14:35:38'),
(3, 3, 'ALMACEN 2', '', 1, '2026-09-04', '2026-09-04 14:35:49', '2026-09-04 14:35:49'),
(4, 1, 'ALMACEN 2 CENTRAL', '', 0, '2026-09-04', '2026-09-04 14:36:00', '2026-09-04 14:36:25');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--

CREATE TABLE `categorias` (
  `id` bigint UNSIGNED NOT NULL,
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `categorias`
--

INSERT INTO `categorias` (`id`, `nombre`, `created_at`, `updated_at`) VALUES
(1, 'CATEGORÍA 1', '2026-07-11 19:33:44', '2026-07-11 19:33:44'),
(2, 'CATEGORIA 2', '2026-07-11 19:59:39', '2026-07-11 19:59:39'),
(3, 'CATEGORIA NUEVA', '2026-09-11 16:17:24', '2026-09-11 16:17:24');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `id` bigint UNSIGNED NOT NULL,
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo_documento_id` bigint UNSIGNED NOT NULL,
  `nro_documento` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `complemento` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fono` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `correo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_registro` date DEFAULT NULL,
  `status` int NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`id`, `nombre`, `tipo_documento_id`, `nro_documento`, `complemento`, `fono`, `correo`, `fecha_registro`, `status`, `created_at`, `updated_at`) VALUES
(1, 'JUAN PERES', 1, '123456', 'CM', NULL, 'juan@gmail.com', '2026-07-11', 1, '2026-07-11 16:45:19', '2026-07-11 16:45:19'),
(2, 'MARIA MAMANI', 1, '123456', NULL, NULL, NULL, '2026-07-11', 1, '2026-07-11 16:46:44', '2026-07-11 16:46:44'),
(3, 'MARCOS', 2, '345345345', NULL, NULL, NULL, '2026-07-11', 1, '2026-07-11 16:47:13', '2026-07-11 16:47:13'),
(4, 'MARCOS', 1, '3433333', NULL, NULL, NULL, '2026-07-11', 1, '2026-07-11 16:48:20', '2026-07-11 16:48:20'),
(5, 'PEDRO GONZALES', 1, '43343434', NULL, NULL, NULL, '2026-09-09', 1, '2026-09-09 20:20:36', '2026-09-09 20:20:36'),
(6, 'CONDORI', 1, '32233', NULL, NULL, NULL, '2026-09-09', 1, '2026-09-09 20:23:27', '2026-09-09 20:23:27'),
(7, 'MAMANI', 1, '223332', NULL, NULL, NULL, '2026-09-09', 1, '2026-09-09 20:24:03', '2026-09-09 20:24:03'),
(8, 'CASTRO', 2, '43344343', NULL, NULL, NULL, '2026-09-09', 1, '2026-09-09 20:25:10', '2026-09-09 20:25:10'),
(9, 'SOLIZ', 1, '32323', NULL, NULL, NULL, '2026-09-09', 1, '2026-09-09 20:28:18', '2026-09-09 20:28:18'),
(10, 'JUAN PERES', 1, '1234566', '', '77777777', 'juan@gmail.com', '2026-09-12', 1, NULL, NULL),
(11, 'condori', 2, '8888888888', '', '', '', '2026-09-12', 1, NULL, NULL),
(12, 'mamani', 1, '34343443', '', '', '', '2026-09-12', 1, NULL, NULL),
(13, 'JAVIER CLEMENTE', 1, '56565656', NULL, NULL, NULL, '2026-09-15', 1, '2026-09-15 14:45:14', '2026-09-15 14:45:14');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cliente_productos`
--

CREATE TABLE `cliente_productos` (
  `id` bigint UNSIGNED NOT NULL,
  `cliente_id` bigint UNSIGNED NOT NULL,
  `producto_id` bigint UNSIGNED NOT NULL,
  `precio` decimal(24,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `cliente_productos`
--

INSERT INTO `cliente_productos` (`id`, `cliente_id`, `producto_id`, `precio`, `created_at`, `updated_at`) VALUES
(2, 13, 2, 255.00, '2026-09-21 14:53:16', '2026-09-21 14:53:16'),
(3, 13, 3, 360.00, '2026-09-21 14:56:10', '2026-09-21 14:56:10');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `configuracions`
--

CREATE TABLE `configuracions` (
  `id` bigint UNSIGNED NOT NULL,
  `nombre_sistema` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `alias` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `razon_social` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `nit` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dir` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fono` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `actividad` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `correo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `configuracions`
--

INSERT INTO `configuracions` (`id`, `nombre_sistema`, `alias`, `razon_social`, `nit`, `dir`, `fono`, `actividad`, `correo`, `logo`, `created_at`, `updated_at`) VALUES
(1, 'INVEPESO', 'INVEPESO', 'IMPORTADORA PESO', '11111111111', 'LOS PEDREGALES #223', '2323232 - 7776666', 'ACTIVIDAD EMPRESA', 'invepeso@gmail.com', '11783783341.jpg', '2026-05-12 14:41:08', '2026-08-21 14:19:06');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historial_accions`
--

CREATE TABLE `historial_accions` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `accion` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `datos_original` json DEFAULT NULL,
  `datos_nuevo` json DEFAULT NULL,
  `modulo` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha` date NOT NULL,
  `hora` time NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `historial_accions`
--

INSERT INTO `historial_accions` (`id`, `user_id`, `accion`, `descripcion`, `datos_original`, `datos_nuevo`, `modulo`, `fecha`, `hora`, `created_at`, `updated_at`) VALUES
(1, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN USUARIO', '{\"ci\": \"234567\", \"id\": 3, \"dir\": \"\", \"fono\": \"78787878\", \"tipo\": \"EMPLEADO\", \"acceso\": \"1\", \"ci_exp\": \"LP\", \"correo\": null, \"nombre\": \"JUAN\", \"materno\": \"\", \"paterno\": \"PERES\", \"role_id\": \"3\", \"usuario\": \"JPERES\", \"created_at\": \"2026-10-19T13:42:47.000000Z\", \"updated_at\": \"2026-10-19T13:42:47.000000Z\", \"sucursal_id\": \"2\", \"fecha_registro\": \"2026-10-19\", \"sucursal_todos\": 0}', NULL, 'USUARIOS', '2026-10-19', '09:42:47', '2026-10-19 13:42:47', '2026-10-19 13:42:47'),
(2, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA INGRESO DE PRODUCTO', '{\"id\": 1, \"saldo\": \"48600.00\", \"total\": \"48600.00\", \"codigo\": \"F001\", \"user_id\": 1, \"almacen_id\": 1, \"created_at\": \"2026-10-19T14:24:00.000000Z\", \"updated_at\": \"2026-10-19T14:24:00.000000Z\", \"descripcion\": \"\", \"sucursal_id\": 1, \"tipo_compra\": \"CRÉDITO\", \"cancelado_qr\": \"0\", \"proveedor_id\": \"1\", \"fecha_registro\": \"2026-10-19\", \"tipo_ingreso_id\": \"1\", \"total_cancelado\": 0, \"ingreso_detalles\": [{\"id\": 1, \"costo\": \"120.00\", \"cantidad\": 100, \"repuesto\": 0, \"subtotal\": \"12000.00\", \"faltantes\": null, \"created_at\": \"2026-10-19T14:24:00.000000Z\", \"updated_at\": \"2026-10-19T14:24:00.000000Z\", \"verificado\": null, \"observacion\": null, \"producto_id\": 1, \"cantidad_fisica\": null, \"tipo_ingreso_id\": 1, \"ingreso_producto_id\": 1}, {\"id\": 2, \"costo\": \"121.00\", \"cantidad\": 100, \"repuesto\": 0, \"subtotal\": \"12100.00\", \"faltantes\": null, \"created_at\": \"2026-10-19T14:24:00.000000Z\", \"updated_at\": \"2026-10-19T14:24:00.000000Z\", \"verificado\": null, \"observacion\": null, \"producto_id\": 2, \"cantidad_fisica\": null, \"tipo_ingreso_id\": 1, \"ingreso_producto_id\": 1}, {\"id\": 3, \"costo\": \"122.00\", \"cantidad\": 100, \"repuesto\": 0, \"subtotal\": \"12200.00\", \"faltantes\": null, \"created_at\": \"2026-10-19T14:24:00.000000Z\", \"updated_at\": \"2026-10-19T14:24:00.000000Z\", \"verificado\": null, \"observacion\": null, \"producto_id\": 3, \"cantidad_fisica\": null, \"tipo_ingreso_id\": 1, \"ingreso_producto_id\": 1}, {\"id\": 4, \"costo\": \"123.00\", \"cantidad\": 100, \"repuesto\": 0, \"subtotal\": \"12300.00\", \"faltantes\": null, \"created_at\": \"2026-10-19T14:24:00.000000Z\", \"updated_at\": \"2026-10-19T14:24:00.000000Z\", \"verificado\": null, \"observacion\": null, \"producto_id\": 4, \"cantidad_fisica\": null, \"tipo_ingreso_id\": 1, \"ingreso_producto_id\": 1}], \"cancelado_efectivo\": \"0\"}', NULL, 'INGRESO DE PRODUCTOS', '2026-10-19', '10:24:00', '2026-10-19 14:24:00', '2026-10-19 14:24:00'),
(3, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA VENTA', '{\"id\": 1, \"hora\": \"10:26:57\", \"fecha\": \"2026-10-19\", \"saldo\": \"1362.00\", \"total\": \"1362.00\", \"nit_ci\": \"56565656\", \"user_id\": 1, \"subtotal\": \"1362.00\", \"descuento\": \"0\", \"tipo_pago\": \"\", \"almacen_id\": 1, \"cliente_id\": 13, \"created_at\": \"2026-10-19T14:26:57.000000Z\", \"tipo_venta\": \"CRÉDITO\", \"updated_at\": \"2026-10-19T14:26:57.000000Z\", \"sucursal_id\": 1, \"cancelado_qr\": \"0\", \"codigo_venta\": \"V1\", \"fecha_registro\": \"2026-10-19\", \"venta_detalles\": [{\"id\": 1, \"total\": \"597.00\", \"precio\": \"199.00\", \"status\": 1, \"cantidad\": 3, \"venta_id\": 1, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"597.00\", \"created_at\": \"2026-10-19T14:26:57.000000Z\", \"updated_at\": \"2026-10-19T14:26:57.000000Z\", \"producto_id\": 1, \"precio_final\": \"199.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}, {\"id\": 2, \"total\": \"765.00\", \"precio\": \"255.00\", \"status\": 1, \"cantidad\": 3, \"venta_id\": 1, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"765.00\", \"created_at\": \"2026-10-19T14:26:57.000000Z\", \"updated_at\": \"2026-10-19T14:26:57.000000Z\", \"producto_id\": 2, \"precio_final\": \"255.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"total_cancelado\": 0, \"tipo_documento_id\": 1, \"cancelado_efectivo\": \"0\", \"porcentaje_descuento\": 0}', NULL, 'VENTAS', '2026-10-19', '10:26:57', '2026-10-19 14:26:57', '2026-10-19 14:26:57'),
(4, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN INGRESO DE BS. 199 EN LA SUCURSAL SUCURSAL 1; almacén ALMACEN 1', '{\"id\": 1, \"hora\": \"10:29:08\", \"tipo\": \"VENTA\", \"fecha\": \"2026-10-19\", \"modulo\": \"Venta\", \"user_id\": 1, \"monto_qr\": \"0\", \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 2, \"created_at\": \"2026-10-19T14:29:08.000000Z\", \"updated_at\": \"2026-10-19T14:29:08.000000Z\", \"descripcion\": \"INGRESO POR VENTA\", \"monto_total\": 199, \"registro_id\": 2, \"sucursal_id\": 2, \"monto_efectivo\": \"199\", \"tipo_movimiento\": \"INGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-10-19', '10:29:08', '2026-10-19 14:29:08', '2026-10-19 14:29:08'),
(5, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA VENTA', '{\"id\": 2, \"hora\": \"10:29:08\", \"fecha\": \"2026-10-19\", \"saldo\": \"0.00\", \"total\": \"199.00\", \"nit_ci\": \"123456-CM\", \"user_id\": 1, \"subtotal\": \"199.00\", \"descuento\": \"0\", \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 2, \"cliente_id\": 1, \"created_at\": \"2026-10-19T14:29:08.000000Z\", \"tipo_venta\": \"AL CONTADO\", \"updated_at\": \"2026-10-19T14:29:08.000000Z\", \"sucursal_id\": 2, \"cancelado_qr\": \"0\", \"codigo_venta\": \"V2\", \"fecha_registro\": \"2026-10-19\", \"venta_detalles\": [{\"id\": 3, \"total\": \"199.00\", \"precio\": \"199.00\", \"status\": 1, \"cantidad\": 1, \"venta_id\": 2, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"199.00\", \"created_at\": \"2026-10-19T14:29:08.000000Z\", \"updated_at\": \"2026-10-19T14:29:08.000000Z\", \"producto_id\": 1, \"precio_final\": \"199.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"total_cancelado\": 199, \"tipo_documento_id\": 1, \"cancelado_efectivo\": \"199\", \"porcentaje_descuento\": 0}', NULL, 'VENTAS', '2026-10-19', '10:29:08', '2026-10-19 14:29:08', '2026-10-19 14:29:08');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ingreso_detalles`
--

CREATE TABLE `ingreso_detalles` (
  `id` bigint UNSIGNED NOT NULL,
  `ingreso_producto_id` bigint UNSIGNED NOT NULL,
  `tipo_ingreso_id` bigint UNSIGNED NOT NULL,
  `producto_id` bigint UNSIGNED NOT NULL,
  `cantidad` double NOT NULL,
  `verificado` double(8,2) DEFAULT '0.00',
  `faltantes` int DEFAULT NULL,
  `repuesto` double(8,2) NOT NULL DEFAULT '0.00',
  `observacion` varchar(900) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cantidad_fisica` double(8,2) DEFAULT NULL,
  `costo` decimal(24,2) NOT NULL,
  `subtotal` decimal(24,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `ingreso_detalles`
--

INSERT INTO `ingreso_detalles` (`id`, `ingreso_producto_id`, `tipo_ingreso_id`, `producto_id`, `cantidad`, `verificado`, `faltantes`, `repuesto`, `observacion`, `cantidad_fisica`, `costo`, `subtotal`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 1, 100, 100.30, 0, 0.00, NULL, 100.30, 120.00, 12000.00, '2026-10-19 14:24:00', '2026-10-19 14:24:52'),
(2, 1, 1, 2, 100, 100.00, 0, 0.00, NULL, 100.00, 121.00, 12100.00, '2026-10-19 14:24:00', '2026-10-19 14:24:52'),
(3, 1, 1, 3, 100, 50.00, 50, 0.00, NULL, 50.00, 122.00, 12200.00, '2026-10-19 14:24:00', '2026-10-19 14:24:52'),
(4, 1, 1, 4, 100, 50.00, 50, 0.00, NULL, 50.00, 123.00, 12300.00, '2026-10-19 14:24:00', '2026-10-19 14:24:52');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ingreso_faltantes`
--

CREATE TABLE `ingreso_faltantes` (
  `id` bigint UNSIGNED NOT NULL,
  `ingreso_producto_id` bigint UNSIGNED NOT NULL,
  `ingreso_detalle_id` bigint UNSIGNED NOT NULL,
  `cantidad` double NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `fecha` date NOT NULL,
  `hora` time NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ingreso_pagos`
--

CREATE TABLE `ingreso_pagos` (
  `id` bigint UNSIGNED NOT NULL,
  `sucursal_id` bigint UNSIGNED NOT NULL,
  `almacen_id` bigint UNSIGNED NOT NULL,
  `ingreso_producto_id` bigint UNSIGNED NOT NULL,
  `proveedor_id` bigint UNSIGNED NOT NULL,
  `monto_efectivo` decimal(24,2) NOT NULL,
  `monto_qr` decimal(24,2) NOT NULL,
  `monto_total` decimal(24,2) NOT NULL,
  `fecha` date NOT NULL,
  `hora` time NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ingreso_productos`
--

CREATE TABLE `ingreso_productos` (
  `id` bigint UNSIGNED NOT NULL,
  `codigo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `sucursal_id` bigint UNSIGNED NOT NULL,
  `almacen_id` bigint UNSIGNED NOT NULL,
  `tipo_ingreso_id` bigint UNSIGNED NOT NULL,
  `proveedor_id` bigint UNSIGNED NOT NULL,
  `descripcion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `total` decimal(24,2) NOT NULL,
  `cancelado_efectivo` decimal(24,2) NOT NULL,
  `cancelado_qr` decimal(24,2) NOT NULL,
  `total_cancelado` decimal(24,2) NOT NULL,
  `saldo` decimal(24,2) NOT NULL,
  `tipo_compra` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_registro` date DEFAULT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `estado_ingreso` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDIENTE',
  `estado_faltantes` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` int NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `ingreso_productos`
--

INSERT INTO `ingreso_productos` (`id`, `codigo`, `sucursal_id`, `almacen_id`, `tipo_ingreso_id`, `proveedor_id`, `descripcion`, `total`, `cancelado_efectivo`, `cancelado_qr`, `total_cancelado`, `saldo`, `tipo_compra`, `fecha_registro`, `user_id`, `estado_ingreso`, `estado_faltantes`, `status`, `created_at`, `updated_at`) VALUES
(1, 'F001', 1, 1, 1, 1, '', 48600.00, 0.00, 0.00, 0.00, 48600.00, 'CRÉDITO', '2026-10-19', 1, 'VERIFICADO', 'PENDIENTE', 1, '2026-10-19 14:24:00', '2026-10-19 14:24:52');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ingreso_recepcions`
--

CREATE TABLE `ingreso_recepcions` (
  `id` bigint UNSIGNED NOT NULL,
  `ingreso_producto_id` bigint UNSIGNED NOT NULL,
  `ingreso_detalle_id` bigint UNSIGNED NOT NULL,
  `sucursal_id` bigint UNSIGNED NOT NULL,
  `almacen_id` bigint UNSIGNED NOT NULL,
  `producto_id` bigint UNSIGNED NOT NULL,
  `cantidad` double NOT NULL,
  `tipo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha` date DEFAULT NULL,
  `hora` time DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `ingreso_recepcions`
--

INSERT INTO `ingreso_recepcions` (`id`, `ingreso_producto_id`, `ingreso_detalle_id`, `sucursal_id`, `almacen_id`, `producto_id`, `cantidad`, `tipo`, `fecha`, `hora`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 1, 1, 1, 40, 'RECEPCION', '2026-10-19', '10:24:52', '2026-10-19 14:24:52', '2026-10-19 14:24:52'),
(2, 1, 1, 2, 2, 1, 30, 'RECEPCION', '2026-10-19', '10:24:52', '2026-10-19 14:24:52', '2026-10-19 14:24:52'),
(3, 1, 1, 3, 3, 1, 30.3, 'RECEPCION', '2026-10-19', '10:24:52', '2026-10-19 14:24:52', '2026-10-19 14:24:52'),
(4, 1, 2, 1, 1, 2, 50, 'RECEPCION', '2026-10-19', '10:24:52', '2026-10-19 14:24:52', '2026-10-19 14:24:52'),
(5, 1, 2, 2, 2, 2, 50, 'RECEPCION', '2026-10-19', '10:24:52', '2026-10-19 14:24:52', '2026-10-19 14:24:52'),
(6, 1, 3, 1, 1, 3, 50, 'RECEPCION', '2026-10-19', '10:24:52', '2026-10-19 14:24:52', '2026-10-19 14:24:52'),
(7, 1, 4, 1, 1, 4, 50, 'RECEPCION', '2026-10-19', '10:24:52', '2026-10-19 14:24:52', '2026-10-19 14:24:52');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `kardex_productos`
--

CREATE TABLE `kardex_productos` (
  `id` bigint UNSIGNED NOT NULL,
  `sucursal_id` bigint UNSIGNED NOT NULL,
  `almacen_id` bigint UNSIGNED NOT NULL,
  `ingreso_detalle_id` bigint UNSIGNED DEFAULT NULL,
  `tipo_registro` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `registro_id` bigint UNSIGNED DEFAULT NULL,
  `modulo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `producto_id` bigint UNSIGNED NOT NULL,
  `detalle` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `precio` decimal(24,2) DEFAULT NULL,
  `tipo_is` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `cantidad_ingreso` double(8,2) DEFAULT NULL,
  `cantidad_salida` double(8,2) DEFAULT NULL,
  `cantidad_saldo` double(8,2) NOT NULL,
  `cu` decimal(24,2) NOT NULL,
  `monto_ingreso` decimal(24,2) DEFAULT NULL,
  `monto_salida` decimal(24,2) DEFAULT NULL,
  `monto_saldo` decimal(24,2) NOT NULL,
  `fecha` date NOT NULL,
  `status` int NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `kardex_productos`
--

INSERT INTO `kardex_productos` (`id`, `sucursal_id`, `almacen_id`, `ingreso_detalle_id`, `tipo_registro`, `registro_id`, `modulo`, `producto_id`, `detalle`, `precio`, `tipo_is`, `cantidad_ingreso`, `cantidad_salida`, `cantidad_saldo`, `cu`, `monto_ingreso`, `monto_salida`, `monto_saldo`, `fecha`, `status`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 1, 'INGRESO DE PRODUCTO', 1, 'IngresoRecepcion', 1, 'POR COMPRAS', 120.00, 'INGRESO', 40.00, NULL, 40.00, 120.00, 4800.00, NULL, 4800.00, '2026-10-19', 1, '2026-10-19 14:24:52', '2026-10-19 14:24:52'),
(2, 2, 2, 1, 'INGRESO DE PRODUCTO', 2, 'IngresoRecepcion', 1, 'POR COMPRAS', 120.00, 'INGRESO', 30.00, NULL, 30.00, 120.00, 3600.00, NULL, 3600.00, '2026-10-19', 1, '2026-10-19 14:24:52', '2026-10-19 14:24:52'),
(3, 3, 3, 1, 'INGRESO DE PRODUCTO', 3, 'IngresoRecepcion', 1, 'POR COMPRAS', 120.00, 'INGRESO', 30.30, NULL, 30.30, 120.00, 3636.00, NULL, 3636.00, '2026-10-19', 1, '2026-10-19 14:24:52', '2026-10-19 14:24:52'),
(4, 1, 1, 2, 'INGRESO DE PRODUCTO', 4, 'IngresoRecepcion', 2, 'POR COMPRAS', 121.00, 'INGRESO', 50.00, NULL, 50.00, 121.00, 6050.00, NULL, 6050.00, '2026-10-19', 1, '2026-10-19 14:24:52', '2026-10-19 14:24:52'),
(5, 2, 2, 2, 'INGRESO DE PRODUCTO', 5, 'IngresoRecepcion', 2, 'POR COMPRAS', 121.00, 'INGRESO', 50.00, NULL, 50.00, 121.00, 6050.00, NULL, 6050.00, '2026-10-19', 1, '2026-10-19 14:24:52', '2026-10-19 14:24:52'),
(6, 1, 1, 3, 'INGRESO DE PRODUCTO', 6, 'IngresoRecepcion', 3, 'POR COMPRAS', 122.00, 'INGRESO', 50.00, NULL, 50.00, 122.00, 6100.00, NULL, 6100.00, '2026-10-19', 1, '2026-10-19 14:24:52', '2026-10-19 14:24:52'),
(7, 1, 1, 4, 'INGRESO DE PRODUCTO', 7, 'IngresoRecepcion', 4, 'POR COMPRAS', 123.00, 'INGRESO', 50.00, NULL, 50.00, 123.00, 6150.00, NULL, 6150.00, '2026-10-19', 1, '2026-10-19 14:24:52', '2026-10-19 14:24:52'),
(8, 1, 1, NULL, 'VENTA DE PRODUCTO', 1, 'VentaDetalle', 1, 'SALIDA POR VENTA', 199.00, 'EGRESO', NULL, 3.00, 37.00, 199.00, NULL, 597.00, 4203.00, '2026-10-19', 1, '2026-10-19 14:26:57', '2026-10-19 14:26:57'),
(9, 1, 1, NULL, 'VENTA DE PRODUCTO', 2, 'VentaDetalle', 2, 'SALIDA POR VENTA', 255.00, 'EGRESO', NULL, 3.00, 47.00, 255.00, NULL, 765.00, 5285.00, '2026-10-19', 1, '2026-10-19 14:26:57', '2026-10-19 14:26:57'),
(10, 2, 2, NULL, 'VENTA DE PRODUCTO', 3, 'VentaDetalle', 1, 'SALIDA POR VENTA', 199.00, 'EGRESO', NULL, 1.00, 29.00, 199.00, NULL, 199.00, 3401.00, '2026-10-19', 1, '2026-10-19 14:29:08', '2026-10-19 14:29:08');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `marcas`
--

CREATE TABLE `marcas` (
  `id` bigint UNSIGNED NOT NULL,
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `marcas`
--

INSERT INTO `marcas` (`id`, `nombre`, `created_at`, `updated_at`) VALUES
(1, 'MARCA 1', '2026-07-11 19:32:44', '2026-07-11 19:32:44'),
(2, 'MARCA 2', '2026-07-11 19:59:34', '2026-07-11 19:59:34'),
(3, 'NUEVA MARCA', '2026-09-11 16:17:24', '2026-09-11 16:17:24'),
(4, 'MARCA 4', '2026-09-13 20:05:01', '2026-09-13 20:05:01');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `migrations`
--

CREATE TABLE `migrations` (
  `id` int UNSIGNED NOT NULL,
  `migration` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2024_01_02_153316_create_sucursals_table', 1),
(2, '2024_01_31_165641_create_configuracions_table', 1),
(3, '2024_11_02_153309_create_roles_table', 1),
(4, '2024_11_02_153315_create_modulos_table', 1),
(5, '2024_11_02_153316_create_permisos_table', 1),
(6, '2024_11_02_153317_create_users_table', 1),
(7, '2024_11_02_153318_create_historial_accions_table', 1),
(8, '2026_04_02_203434_create_tipo_documentos_table', 1),
(9, '2026_04_02_203435_create_clientes_table', 1),
(10, '2026_07_11_124903_create_categorias_table', 2),
(11, '2026_07_11_124904_create_marcas_table', 2),
(12, '2026_07_11_124904_create_unidad_medidas_table', 2),
(13, '2026_07_11_124905_create_productos_table', 2),
(14, '2026_07_11_124928_create_tipo_ingresos_table', 2),
(15, '2026_07_11_124932_create_tipo_salidas_table', 2),
(16, '2026_07_11_124938_create_proveedors_table', 2),
(17, '2026_07_11_124939_create_ingreso_productos_table', 3),
(18, '2026_07_11_140254_create_ingreso_detalles_table', 3),
(19, '2026_07_11_140255_create_salida_productos_table', 3),
(21, '2026_07_11_140303_create_ventas_table', 3),
(22, '2026_07_11_140306_create_venta_detalles_table', 4),
(23, '2026_07_11_140640_create_venta_detalle_lotes_table', 4),
(24, '2026_07_11_140814_create_movimiento_cajas_table', 4),
(26, '2026_07_11_140855_create_kardex_productos_table', 4),
(27, '2026_07_11_141426_create_producto_sucursals_table', 4),
(28, '2026_07_11_124937_create_almacens_table', 5),
(29, '2026_08_30_111049_create_salida_detalles_table', 6),
(30, '2026_09_04_095816_create_traspasos_table', 7),
(31, '2026_09_04_095819_create_traspaso_detalles_table', 7),
(32, '2026_09_07_112006_create_ingreso_pagos_table', 8),
(33, '2026_09_09_093956_create_venta_cobros_table', 9),
(34, '2026_09_09_152725_create_proformas_table', 10),
(35, '2026_09_09_152745_create_proforma_detalles_table', 10),
(36, '2026_09_20_145902_create_ingreso_faltantes_table', 11),
(37, '2026_09_21_095110_create_cliente_productos_table', 12),
(38, '2026_10_17_103418_create_ingreso_recepcions_table', 13),
(39, '2026_10_17_103904_create_notificacions_table', 13),
(40, '2026_10_17_103913_create_notificacion_users_table', 13);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `modulos`
--

CREATE TABLE `modulos` (
  `id` bigint UNSIGNED NOT NULL,
  `modulo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `accion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `modulos`
--

INSERT INTO `modulos` (`id`, `modulo`, `nombre`, `accion`, `descripcion`, `created_at`, `updated_at`) VALUES
(1, 'Gestión de usuarios', 'usuarios.index', 'VER', 'VER LA LISTA DE USUARIOS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(2, 'Gestión de usuarios', 'usuarios.create', 'CREAR', 'CREAR USUARIOS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(3, 'Gestión de usuarios', 'usuarios.edit', 'EDITAR', 'EDITAR USUARIOS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(4, 'Gestión de usuarios', 'usuarios.destroy', 'ELIMINAR', 'ELIMINAR USUARIOS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(5, 'Roles y Permisos', 'roles.index', 'VER', 'VER LA LISTA DE ROLES Y PERMISOS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(6, 'Roles y Permisos', 'roles.create', 'CREAR', 'CREAR ROLES Y PERMISOS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(7, 'Roles y Permisos', 'roles.edit', 'EDITAR', 'EDITAR ROLES Y PERMISOS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(8, 'Roles y Permisos', 'roles.destroy', 'ELIMINAR', 'ELIMINAR ROLES Y PERMISOS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(9, 'Configuración del sistema', 'configuracions.index', 'VER', 'VER INFORMACIÓN DE LA CONFIGURACIÓN DEL SISTEMA', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(10, 'Configuración del sistema', 'configuracions.edit', 'EDITAR', 'EDITAR LA CONFIGURACIÓN DEL SISTEMA', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(11, 'Gestión de sucursales', 'sucursals.index', 'VER', 'VER LA LISTA DE SUCURSALES', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(12, 'Gestión de sucursales', 'sucursals.create', 'CREAR', 'CREAR SUCURSALES', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(13, 'Gestión de sucursales', 'sucursals.edit', 'EDITAR', 'EDITAR SUCURSALES', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(14, 'Gestión de sucursales', 'sucursals.destroy', 'ELIMINAR', 'ELIMINAR SUCURSALES', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(15, 'Gestión de almacenes', 'almacens.index', 'VER', 'VER LA LISTA DE ALMACENES', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(16, 'Gestión de almacenes', 'almacens.create', 'CREAR', 'CREAR ALMACENES', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(17, 'Gestión de almacenes', 'almacens.edit', 'EDITAR', 'EDITAR ALMACENES', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(18, 'Gestión de almacenes', 'almacens.destroy', 'ELIMINAR', 'ELIMINAR ALMACENES', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(19, 'Gestión de tipo de documentos', 'tipo_documentos.index', 'VER', 'VER LA LISTA DE TIPO DE DOCUMENTOS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(20, 'Gestión de tipo de documentos', 'tipo_documentos.create', 'CREAR', 'CREAR TIPO DE DOCUMENTOS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(21, 'Gestión de tipo de documentos', 'tipo_documentos.edit', 'EDITAR', 'EDITAR TIPO DE DOCUMENTOS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(22, 'Gestión de tipo de documentos', 'tipo_documentos.destroy', 'ELIMINAR', 'ELIMINAR TIPO DE DOCUMENTOS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(23, 'Gestión de categorias', 'categorias.index', 'VER', 'VER LA LISTA DE CATEGORÍAS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(24, 'Gestión de categorias', 'categorias.create', 'CREAR', 'CREAR CATEGORÍAS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(25, 'Gestión de categorias', 'categorias.edit', 'EDITAR', 'EDITAR CATEGORÍAS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(26, 'Gestión de categorias', 'categorias.destroy', 'ELIMINAR', 'ELIMINAR CATEGORÍAS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(27, 'Gestión de marcas', 'marcas.index', 'VER', 'VER LA LISTA DE MARCAS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(28, 'Gestión de marcas', 'marcas.create', 'CREAR', 'CREAR MARCAS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(29, 'Gestión de marcas', 'marcas.edit', 'EDITAR', 'EDITAR MARCAS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(30, 'Gestión de marcas', 'marcas.destroy', 'ELIMINAR', 'ELIMINAR MARCAS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(31, 'Gestión de unidades de medida', 'unidad_medidas.index', 'VER', 'VER LA LISTA DE UNIDADES DE MEDIDA', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(32, 'Gestión de unidades de medida', 'unidad_medidas.create', 'CREAR', 'CREAR UNIDADES DE MEDIDA', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(33, 'Gestión de unidades de medida', 'unidad_medidas.edit', 'EDITAR', 'EDITAR UNIDADES DE MEDIDA', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(34, 'Gestión de unidades de medida', 'unidad_medidas.destroy', 'ELIMINAR', 'ELIMINAR UNIDADES DE MEDIDA', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(35, 'Gestión de productos', 'productos.index', 'VER', 'VER LA LISTA DE PRODUCTOS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(36, 'Gestión de productos', 'productos.create', 'CREAR', 'CREAR PRODUCTOS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(37, 'Gestión de productos', 'productos.edit', 'EDITAR', 'EDITAR PRODUCTOS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(38, 'Gestión de productos', 'productos.destroy', 'ELIMINAR', 'ELIMINAR PRODUCTOS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(39, 'Gestión de clientes', 'clientes.index', 'VER', 'VER LA LISTA DE CLIENTES', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(40, 'Gestión de clientes', 'clientes.create', 'CREAR', 'CREAR CLIENTES', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(41, 'Gestión de clientes', 'clientes.edit', 'EDITAR', 'EDITAR CLIENTES', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(42, 'Gestión de clientes', 'clientes.destroy', 'ELIMINAR', 'ELIMINAR CLIENTES', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(43, 'Gestión de clientes', 'cliente_productos.index', 'VER', 'VER LA LISTA DE PRODUCTOS POR CLIENTE', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(44, 'Gestión de clientes', 'cliente_productos.create', 'CREAR', 'ASIGNAR PRODUCTOS POR CLIENTE', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(45, 'Gestión de clientes', 'cliente_productos.edit', 'EDITAR', 'EDITAR PRODUCTOS ASIGNADOS POR CLIENTE', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(46, 'Gestión de clientes', 'cliente_productos.destroy', 'ELIMINAR', 'ELIMINAR PRODUCTOS ASIGNADOS POR CLIENTE', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(47, 'Gestión de tipo de ingresos', 'tipo_ingresos.index', 'VER', 'VER LA LISTA DE TIPO DE INGRESOS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(48, 'Gestión de tipo de ingresos', 'tipo_ingresos.create', 'CREAR', 'CREAR TIPO DE INGRESOS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(49, 'Gestión de tipo de ingresos', 'tipo_ingresos.edit', 'EDITAR', 'EDITAR TIPO DE INGRESOS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(50, 'Gestión de tipo de ingresos', 'tipo_ingresos.destroy', 'ELIMINAR', 'ELIMINAR TIPO DE INGRESOS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(51, 'Gestión de tipo de salidas', 'tipo_salidas.index', 'VER', 'VER LA LISTA DE TIPO DE SALIDAS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(52, 'Gestión de tipo de salidas', 'tipo_salidas.create', 'CREAR', 'CREAR TIPO DE SALIDAS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(53, 'Gestión de tipo de salidas', 'tipo_salidas.edit', 'EDITAR', 'EDITAR TIPO DE SALIDAS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(54, 'Gestión de tipo de salidas', 'tipo_salidas.destroy', 'ELIMINAR', 'ELIMINAR TIPO DE SALIDAS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(55, 'Gestión de proveedores', 'proveedors.index', 'VER', 'VER LA LISTA DE PROVEEDORES', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(56, 'Gestión de proveedores', 'proveedors.create', 'CREAR', 'CREAR PROVEEDORES', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(57, 'Gestión de proveedores', 'proveedors.edit', 'EDITAR', 'EDITAR PROVEEDORES', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(58, 'Gestión de proveedores', 'proveedors.destroy', 'ELIMINAR', 'ELIMINAR PROVEEDORES', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(59, 'Gestión de Inventario de Productos', 'ingreso_productos.index', 'VER', 'VER EL HISTORIAL DE COMPRAS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(60, 'Gestión de Inventario de Productos', 'ingreso_productos.create', 'CREAR', 'CREAR ORDENES DE COMPRA', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(61, 'Gestión de Inventario de Productos', 'ingreso_productos.edit', 'EDITAR', 'EDITAR ORDENES DE COMPRA', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(62, 'Gestión de Inventario de Productos', 'ingreso_productos.destroy', 'ELIMINAR', 'ELIMINAR ORDENES DE COMPRA', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(63, 'Gestión de Inventario de Productos', 'ingreso_productos.verificacion_ingresos', 'VER', 'LISTA DE RECEPCIÓN DE COMPRAS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(64, 'Gestión de Inventario de Productos', 'ingreso_productos.verificacion_create', 'CREAR', 'REGISTRAR RECEPCIÓN DE COMPRAS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(65, 'Gestión de Inventario de Productos', 'ingreso_productos.faltantes_ingresos', 'VER', 'VER ORDENES DE COMPRA CON FALTANTES DE PRODUCTOS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(66, 'Gestión de Inventario de Productos', 'ingreso_productos.faltantes_create', 'CREAR', 'REGISTRAR FALTANTES DE PRODUCTOS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(67, 'Gestión de Inventario de Productos', 'ingreso_productos.pagos', 'VER', 'LISTA DE PAGOS PENDIENTES POR COMPRAS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(68, 'Gestión de Inventario de Productos', 'ingreso_productos.registrar_pago', 'CREAR', 'REGISTRAR PAGOS POR COMPRAS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(69, 'Gestión de Inventario de Productos', 'ingreso_productos.actualizar_pago', 'EDITAR', 'ACTUALIZAR PAGOS POR COMPRAS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(70, 'Gestión de Inventario de Productos', 'ingreso_productos.eliminar_pago', 'ELIMINAR', 'ELIMINAR PAGOS POR COMPRAS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(71, 'Gestión de Inventario de Productos', 'producto_sucursals.index', 'VER', 'VER LA LISTA DE PRODUCTOS POR ALMACÉN-SUCURSAL', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(72, 'Gestión de Inventario de Productos', 'producto_sucursals.create', 'CREAR', 'CARGAR PRODUCTOS POR ALMACÉN-SUCURSAL', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(73, 'Gestión de salida de productos', 'salida_productos.index', 'VER', 'VER LA LISTA DE SALIDA DE PRODUCTOS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(74, 'Gestión de salida de productos', 'salida_productos.create', 'CREAR', 'CREAR SALIDA DE PRODUCTOS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(75, 'Gestión de salida de productos', 'salida_productos.edit', 'EDITAR', 'EDITAR SALIDA DE PRODUCTOS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(76, 'Gestión de salida de productos', 'salida_productos.destroy', 'ELIMINAR', 'ELIMINAR SALIDA DE PRODUCTOS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(77, 'Gestión de movimientos de cajas', 'movimiento_cajas.index', 'VER', 'VER LA LISTA DE MOVIMIENTO DE CAJAS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(78, 'Gestión de movimientos de cajas', 'movimiento_cajas.create', 'CREAR', 'CREAR MOVIMIENTO DE CAJAS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(79, 'Gestión de movimientos de cajas', 'movimiento_cajas.edit', 'EDITAR', 'EDITAR MOVIMIENTO DE CAJAS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(80, 'Gestión de movimientos de cajas', 'movimiento_cajas.destroy', 'ELIMINAR', 'ELIMINAR MOVIMIENTO DE CAJAS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(81, 'Gestión de traspaso de productos', 'traspasos.index', 'VER', 'VER LA LISTA DE TRASPASO DE PRODUCTOS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(82, 'Gestión de traspaso de productos', 'traspasos.create', 'CREAR', 'CREAR TRASPASO DE PRODUCTOS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(83, 'Gestión de traspaso de productos', 'traspasos.edit', 'EDITAR', 'EDITAR TRASPASO DE PRODUCTOS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(84, 'Gestión de traspaso de productos', 'traspasos.destroy', 'ELIMINAR', 'ELIMINAR TRASPASO DE PRODUCTOS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(85, 'Gestión de ventas', 'ventas.index', 'VER', 'VER LA LISTA DE VENTAS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(86, 'Gestión de ventas', 'ventas.create', 'CREAR', 'CREAR VENTAS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(87, 'Gestión de ventas', 'ventas.edit', 'EDITAR', 'EDITAR VENTAS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(88, 'Gestión de ventas', 'ventas.destroy', 'ELIMINAR', 'ELIMINAR VENTAS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(89, 'Gestión de ventas', 'ventas.cobros', 'VER', 'VER LA LISTA DE COBROS PENDIENTES', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(90, 'Gestión de ventas', 'ventas.registrar_cobro', 'CREAR', 'REGISTRAR PAGOS DE COBROS PENDIENTES', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(91, 'Gestión de ventas', 'ventas.actualizar_cobro', 'EDITAR', 'ACTUALIZAR PAGOS DE COBROS PENDIENTES', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(92, 'Gestión de ventas', 'ventas.eliminar_cobro', 'ELIMINAR', 'ELIMINAR PAGOS DE COBROS PENDIENTES', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(93, 'Gestión de proformas', 'proformas.index', 'VER', 'VER LA LISTA DE PROFORMAS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(94, 'Gestión de proformas', 'proformas.create', 'CREAR', 'CREAR PROFORMAS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(95, 'Gestión de proformas', 'proformas.edit', 'EDITAR', 'EDITAR PROFORMAS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(96, 'Gestión de proformas', 'proformas.destroy', 'ELIMINAR', 'ELIMINAR PROFORMAS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(97, 'Gestión de notificaciones', 'notificacions.index', 'RECIBIR Y VER NOTIFICACIONES', 'RECIBIR Y VER NOTIFICACIONES', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(98, 'Reportes', 'reportes.usuarios', 'REPORTE LISTA DE USUARIOS', 'GENERAR REPORTES DE LISTA DE USUARIOS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(99, 'Reportes', 'reportes.clientes', 'REPORTE LISTA DE CLIENTES', 'GENERAR REPORTES DE LISTA DE CLIENTES', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(100, 'Reportes', 'reportes.productos', 'REPORTE LISTA DE PRODUCTOS', 'GENERAR REPORTES DE LISTA DE PRODUCTOS', '2026-10-19 13:33:22', '2026-10-19 13:33:22'),
(101, 'Reportes', 'reportes.stock_productos', 'REPORTE LISTA DE STOCK POR PRODUCTOS', 'GENERAR REPORTES DE LISTA DE STOCK PRODUCTOS', '2026-10-19 13:33:22', '2026-10-19 13:33:22');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `movimiento_cajas`
--

CREATE TABLE `movimiento_cajas` (
  `id` bigint UNSIGNED NOT NULL,
  `sucursal_id` bigint UNSIGNED DEFAULT NULL,
  `almacen_id` bigint UNSIGNED DEFAULT NULL,
  `tipo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `modulo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `registro_id` bigint UNSIGNED DEFAULT NULL,
  `monto_efectivo` decimal(24,2) NOT NULL,
  `monto_qr` decimal(24,2) NOT NULL,
  `monto_total` decimal(24,2) NOT NULL,
  `tipo_movimiento` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo_pago` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(900) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha` date NOT NULL,
  `hora` time NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `status` int NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `movimiento_cajas`
--

INSERT INTO `movimiento_cajas` (`id`, `sucursal_id`, `almacen_id`, `tipo`, `modulo`, `registro_id`, `monto_efectivo`, `monto_qr`, `monto_total`, `tipo_movimiento`, `tipo_pago`, `descripcion`, `fecha`, `hora`, `user_id`, `status`, `created_at`, `updated_at`) VALUES
(1, 2, 2, 'VENTA', 'Venta', 2, 199.00, 0.00, 199.00, 'INGRESO', 'EFECTIVO', 'INGRESO POR VENTA', '2026-10-19', '10:29:08', 1, 1, '2026-10-19 14:29:08', '2026-10-19 14:29:08');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notificacions`
--

CREATE TABLE `notificacions` (
  `id` bigint UNSIGNED NOT NULL,
  `modulo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `registro_id` bigint UNSIGNED DEFAULT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha` date NOT NULL,
  `hora` time NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notificacion_users`
--

CREATE TABLE `notificacion_users` (
  `id` bigint UNSIGNED NOT NULL,
  `notificacion_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `visto` int NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permisos`
--

CREATE TABLE `permisos` (
  `id` bigint UNSIGNED NOT NULL,
  `role_id` bigint UNSIGNED NOT NULL,
  `modulo_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `id` bigint UNSIGNED NOT NULL,
  `codigo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `categoria_id` bigint UNSIGNED NOT NULL,
  `marca_id` bigint UNSIGNED NOT NULL,
  `unidad_medida_id` bigint UNSIGNED NOT NULL,
  `caracteristicas` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `calidad` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `cobertura` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `formato` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `precio` decimal(24,2) NOT NULL,
  `precio2` decimal(24,2) DEFAULT NULL,
  `precio3` decimal(24,2) DEFAULT NULL,
  `precio4` decimal(24,2) DEFAULT NULL,
  `precio_compra` decimal(24,2) NOT NULL,
  `stock_min` double NOT NULL,
  `imagen` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_registro` date NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id`, `codigo`, `nombre`, `categoria_id`, `marca_id`, `unidad_medida_id`, `caracteristicas`, `calidad`, `cobertura`, `formato`, `precio`, `precio2`, `precio3`, `precio4`, `precio_compra`, `stock_min`, `imagen`, `activo`, `fecha_registro`, `created_at`, `updated_at`) VALUES
(1, 'P001', 'PRODUCTO 1', 1, 1, 2, '', 'COMERCIAL', '1.77', '42X42', 199.00, 200.00, NULL, NULL, 120.00, 4, NULL, 1, '2026-10-18', NULL, NULL),
(2, 'P002', 'PRODUCTO 2', 1, 1, 2, '', 'COMERCIAL', '1.78', '43X43', 200.00, 210.00, NULL, NULL, 121.00, 4, NULL, 1, '2026-10-18', NULL, NULL),
(3, 'P003', 'PRODUCTO 3', 1, 1, 2, '', 'COMERCIAL', '1.79', '42X43', 201.00, 220.00, NULL, NULL, 122.00, 4, NULL, 1, '2026-10-18', NULL, NULL),
(4, 'P004', 'PRODUCTO 4', 1, 1, 2, '', 'COMERCIAL', '1.80', '43X44', 202.00, 230.00, NULL, NULL, 123.00, 4, NULL, 1, '2026-10-18', NULL, NULL),
(5, 'P005', 'PRODUCTO 5', 1, 1, 2, '', 'COMERCIAL', '1.81', '42X44', 203.00, 240.00, NULL, NULL, 124.00, 4, NULL, 0, '2026-10-18', NULL, '2026-10-18 14:10:35');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto_sucursals`
--

CREATE TABLE `producto_sucursals` (
  `id` bigint UNSIGNED NOT NULL,
  `sucursal_id` bigint UNSIGNED NOT NULL,
  `almacen_id` bigint UNSIGNED NOT NULL,
  `producto_id` bigint UNSIGNED NOT NULL,
  `stock_actual` double(8,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `producto_sucursals`
--

INSERT INTO `producto_sucursals` (`id`, `sucursal_id`, `almacen_id`, `producto_id`, `stock_actual`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 1, 37.00, '2026-10-19 14:24:52', '2026-10-19 14:26:57'),
(2, 2, 2, 1, 29.00, '2026-10-19 14:24:52', '2026-10-19 14:29:08'),
(3, 3, 3, 1, 30.30, '2026-10-19 14:24:52', '2026-10-19 14:24:52'),
(4, 1, 1, 2, 47.00, '2026-10-19 14:24:52', '2026-10-19 14:26:57'),
(5, 2, 2, 2, 50.00, '2026-10-19 14:24:52', '2026-10-19 14:24:52'),
(6, 1, 1, 3, 50.00, '2026-10-19 14:24:52', '2026-10-19 14:24:52'),
(7, 1, 1, 4, 50.00, '2026-10-19 14:24:52', '2026-10-19 14:24:52');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proformas`
--

CREATE TABLE `proformas` (
  `id` bigint UNSIGNED NOT NULL,
  `codigo_proforma` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sucursal_id` bigint UNSIGNED NOT NULL,
  `almacen_id` bigint UNSIGNED NOT NULL,
  `cliente_id` bigint UNSIGNED NOT NULL,
  `tipo_documento_id` bigint UNSIGNED DEFAULT NULL,
  `nit_ci` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `subtotal` decimal(24,2) NOT NULL,
  `descuento` decimal(24,2) NOT NULL,
  `porcentaje_descuento` double NOT NULL,
  `total` decimal(24,2) NOT NULL,
  `cancelado` decimal(24,2) NOT NULL,
  `saldo` decimal(24,2) NOT NULL,
  `fecha` date NOT NULL,
  `hora` time NOT NULL,
  `fecha_registro` date DEFAULT NULL,
  `status` int NOT NULL DEFAULT '1',
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proforma_detalles`
--

CREATE TABLE `proforma_detalles` (
  `id` bigint UNSIGNED NOT NULL,
  `proforma_id` bigint UNSIGNED NOT NULL,
  `producto_id` bigint UNSIGNED NOT NULL,
  `cantidad` double NOT NULL,
  `precio` decimal(24,2) NOT NULL,
  `descuento_uni` decimal(24,2) NOT NULL,
  `porcen_du` double NOT NULL,
  `descuento_total` decimal(24,2) NOT NULL,
  `porcen_dt` double NOT NULL,
  `precio_final` decimal(24,2) NOT NULL,
  `total` decimal(24,2) NOT NULL,
  `total_uni` decimal(24,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedors`
--

CREATE TABLE `proveedors` (
  `id` bigint UNSIGNED NOT NULL,
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `contacto` varchar(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `proveedors`
--

INSERT INTO `proveedors` (`id`, `nombre`, `contacto`, `created_at`, `updated_at`) VALUES
(1, 'PROVEEDOR 1', '787878787 - proveedor@gmail.com', '2026-07-13 19:46:12', '2026-07-13 19:46:12'),
(2, 'PROVEEDOR 2', NULL, '2026-07-13 19:47:02', '2026-07-13 19:47:02'),
(3, 'PROVEEDOR 3', '', NULL, NULL),
(4, 'PROVEEDOR 4', '6666898', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `id` bigint UNSIGNED NOT NULL,
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `permisos` int NOT NULL DEFAULT '0',
  `usuarios` int NOT NULL DEFAULT '1',
  `status` int NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`id`, `nombre`, `permisos`, `usuarios`, `status`, `created_at`, `updated_at`) VALUES
(1, 'SUPER USUARIO', 1, 0, 1, '2026-05-12 14:41:08', '2026-05-12 14:41:08'),
(2, 'ADMINISTRADOR', 0, 1, 1, '2026-07-11 15:30:09', '2026-07-11 15:30:09'),
(3, 'VENDEDOR', 0, 1, 1, '2026-07-11 15:30:50', '2026-07-11 15:30:50');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `salida_detalles`
--

CREATE TABLE `salida_detalles` (
  `id` bigint UNSIGNED NOT NULL,
  `salida_producto_id` bigint UNSIGNED NOT NULL,
  `tipo_salida_id` bigint UNSIGNED NOT NULL,
  `producto_id` bigint UNSIGNED NOT NULL,
  `cantidad` double NOT NULL,
  `observacion` varchar(900) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `salida_productos`
--

CREATE TABLE `salida_productos` (
  `id` bigint UNSIGNED NOT NULL,
  `sucursal_id` bigint UNSIGNED NOT NULL,
  `almacen_id` bigint UNSIGNED NOT NULL,
  `tipo_salida_id` bigint UNSIGNED DEFAULT NULL,
  `cantidad` double(8,2) NOT NULL,
  `descripcion` varchar(800) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_registro` date NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sucursals`
--

CREATE TABLE `sucursals` (
  `id` bigint UNSIGNED NOT NULL,
  `nombre` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(900) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `ventas` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_registro` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `sucursals`
--

INSERT INTO `sucursals` (`id`, `nombre`, `descripcion`, `activo`, `ventas`, `fecha_registro`, `created_at`, `updated_at`) VALUES
(1, 'SUCURSAL CENTRAL', '', 1, 0, '2026-07-11', '2026-07-11 15:33:24', '2026-08-28 15:41:04'),
(2, 'SUCURSAL 1', '', 1, 1, '2026-07-11', '2026-07-11 15:33:34', '2026-07-11 15:33:34'),
(3, 'SUCURSAL 2', '', 1, 1, '2026-07-11', '2026-07-11 15:33:42', '2026-09-16 20:21:56');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_documentos`
--

CREATE TABLE `tipo_documentos` (
  `id` bigint UNSIGNED NOT NULL,
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `tipo_documentos`
--

INSERT INTO `tipo_documentos` (`id`, `nombre`, `descripcion`, `created_at`, `updated_at`) VALUES
(1, 'CI', NULL, '2026-07-11 16:22:45', '2026-07-11 16:22:45'),
(2, 'NIT', NULL, '2026-07-11 16:22:49', '2026-07-11 16:22:49'),
(3, 'PASS', 'Número de pasaporte', '2026-07-11 16:24:58', '2026-07-11 16:24:58');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_ingresos`
--

CREATE TABLE `tipo_ingresos` (
  `id` bigint UNSIGNED NOT NULL,
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `tipo_ingresos`
--

INSERT INTO `tipo_ingresos` (`id`, `nombre`, `descripcion`, `created_at`, `updated_at`) VALUES
(1, 'POR COMPRAS', 'DESC INGRESO 1', '2026-07-13 19:57:24', '2026-10-15 14:10:35');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_salidas`
--

CREATE TABLE `tipo_salidas` (
  `id` bigint UNSIGNED NOT NULL,
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `tipo_salidas`
--

INSERT INTO `tipo_salidas` (`id`, `nombre`, `descripcion`, `created_at`, `updated_at`) VALUES
(1, 'SALIDA 1', 'DESC SALIDA 1', '2026-07-13 20:01:39', '2026-07-13 20:01:39'),
(2, 'SALIDA 2', '', '2026-07-13 20:01:45', '2026-07-13 20:01:45');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `traspasos`
--

CREATE TABLE `traspasos` (
  `id` bigint UNSIGNED NOT NULL,
  `sucursal_origen_id` bigint UNSIGNED NOT NULL,
  `almacen_origen_id` bigint UNSIGNED NOT NULL,
  `sucursal_destino_id` bigint UNSIGNED NOT NULL,
  `almacen_destino_id` bigint UNSIGNED NOT NULL,
  `cantidad` double NOT NULL,
  `descripcion` varchar(900) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_registro` date NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `traspaso_detalles`
--

CREATE TABLE `traspaso_detalles` (
  `id` bigint UNSIGNED NOT NULL,
  `traspaso_id` bigint UNSIGNED NOT NULL,
  `producto_id` bigint UNSIGNED NOT NULL,
  `cantidad` double NOT NULL,
  `observacion` varchar(900) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `unidad_medidas`
--

CREATE TABLE `unidad_medidas` (
  `id` bigint UNSIGNED NOT NULL,
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `unidad_medidas`
--

INSERT INTO `unidad_medidas` (`id`, `nombre`, `created_at`, `updated_at`) VALUES
(1, 'PIEZA', '2026-07-11 19:53:50', '2026-07-11 19:53:50'),
(2, 'CAJAS', '2026-07-11 19:54:00', '2026-07-11 19:54:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `id` bigint UNSIGNED NOT NULL,
  `usuario` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `paterno` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `materno` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ci` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ci_exp` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `dir` varchar(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `correo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fono` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `foto` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tipo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `role_id` bigint UNSIGNED DEFAULT NULL,
  `acceso` int NOT NULL,
  `sucursal_id` bigint UNSIGNED DEFAULT NULL,
  `sucursal_todos` int NOT NULL DEFAULT '0',
  `fecha_registro` date NOT NULL,
  `status` int NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `usuario`, `nombre`, `paterno`, `materno`, `ci`, `ci_exp`, `dir`, `correo`, `fono`, `password`, `foto`, `tipo`, `role_id`, `acceso`, `sucursal_id`, `sucursal_todos`, `fecha_registro`, `status`, `created_at`, `updated_at`) VALUES
(1, 'admin', 'admin', 'admin', '', '0', '', '', '', '', '$2y$12$abNf2HNWmuVIzdYUy.OMr.5inMBqQIUvv4IhSbWvv8WwL1I2lm8BC', NULL, 'ADMINISTRACIÓN', 1, 1, NULL, 1, '2026-05-12', 1, '2026-05-12 14:41:08', '2026-05-12 14:41:08'),
(2, 'FMAMANI1', 'FERNANDO', 'MAMANI', 'MAMANI', '123456', 'LP', 'LOS PEDREGALES', 'fernando@gmail.com', '78787878', '$2y$12$FlgY4NRltp7YvoMwbd6V..zeg/e/dASkPw.I9WbSJt/Zco1OxE1Gm', '21783785963.jpg', 'ADMINISTRACIÓN', 2, 1, NULL, 1, '2026-07-11', 1, '2026-07-11 16:06:03', '2026-07-11 16:08:52'),
(3, 'JPERES', 'JUAN', 'PERES', '', '234567', 'LP', '', NULL, '78787878', '$2y$12$nkPvkYHNarR.uKoAL6dW3OcALr4Qy8sGWU7K2kp/ud890KqXKmRGW', NULL, 'EMPLEADO', 3, 1, 2, 0, '2026-10-19', 1, '2026-10-19 13:42:47', '2026-10-19 13:42:47');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas`
--

CREATE TABLE `ventas` (
  `id` bigint UNSIGNED NOT NULL,
  `codigo_venta` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sucursal_id` bigint UNSIGNED NOT NULL,
  `almacen_id` bigint UNSIGNED NOT NULL,
  `cliente_id` bigint UNSIGNED NOT NULL,
  `tipo_documento_id` bigint UNSIGNED DEFAULT NULL,
  `nit_ci` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tipo_venta` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo_pago` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `subtotal` decimal(24,2) NOT NULL,
  `descuento` decimal(24,2) NOT NULL,
  `porcentaje_descuento` double(8,2) NOT NULL,
  `total` decimal(24,2) NOT NULL,
  `cancelado_efectivo` decimal(24,2) NOT NULL,
  `cancelado_qr` decimal(24,2) NOT NULL,
  `total_cancelado` decimal(24,2) NOT NULL,
  `saldo` decimal(24,2) NOT NULL,
  `fecha` date NOT NULL,
  `hora` time NOT NULL,
  `fecha_registro` date DEFAULT NULL,
  `status` int NOT NULL DEFAULT '1',
  `user_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `ventas`
--

INSERT INTO `ventas` (`id`, `codigo_venta`, `sucursal_id`, `almacen_id`, `cliente_id`, `tipo_documento_id`, `nit_ci`, `tipo_venta`, `tipo_pago`, `subtotal`, `descuento`, `porcentaje_descuento`, `total`, `cancelado_efectivo`, `cancelado_qr`, `total_cancelado`, `saldo`, `fecha`, `hora`, `fecha_registro`, `status`, `user_id`, `created_at`, `updated_at`) VALUES
(1, 'V1', 1, 1, 13, 1, '56565656', 'CRÉDITO', '', 1362.00, 0.00, 0.00, 1362.00, 0.00, 0.00, 0.00, 1362.00, '2026-10-19', '10:26:57', '2026-10-19', 1, 1, '2026-10-19 14:26:57', '2026-10-19 14:26:57'),
(2, 'V2', 2, 2, 1, 1, '123456-CM', 'AL CONTADO', 'EFECTIVO', 199.00, 0.00, 0.00, 199.00, 199.00, 0.00, 199.00, 0.00, '2026-10-19', '10:29:08', '2026-10-19', 1, 1, '2026-10-19 14:29:08', '2026-10-19 14:29:08');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `venta_cobros`
--

CREATE TABLE `venta_cobros` (
  `id` bigint UNSIGNED NOT NULL,
  `sucursal_id` bigint UNSIGNED NOT NULL,
  `almacen_id` bigint UNSIGNED NOT NULL,
  `venta_id` bigint UNSIGNED NOT NULL,
  `cliente_id` bigint UNSIGNED NOT NULL,
  `tipo_pago` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `monto_efectivo` decimal(24,2) NOT NULL,
  `monto_qr` decimal(24,2) NOT NULL,
  `monto_total` decimal(24,2) NOT NULL,
  `saldo` decimal(24,2) NOT NULL,
  `fecha` date NOT NULL,
  `hora` time NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `venta_detalles`
--

CREATE TABLE `venta_detalles` (
  `id` bigint UNSIGNED NOT NULL,
  `venta_id` bigint UNSIGNED NOT NULL,
  `producto_id` bigint UNSIGNED NOT NULL,
  `cantidad` double NOT NULL,
  `precio` decimal(24,2) NOT NULL,
  `descuento_uni` decimal(24,2) NOT NULL,
  `porcen_du` double(8,2) NOT NULL,
  `descuento_total` decimal(24,2) NOT NULL,
  `porcen_dt` double(8,2) NOT NULL,
  `precio_final` decimal(24,2) NOT NULL,
  `total` decimal(24,2) NOT NULL,
  `total_uni` decimal(24,2) NOT NULL,
  `status` int NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `venta_detalles`
--

INSERT INTO `venta_detalles` (`id`, `venta_id`, `producto_id`, `cantidad`, `precio`, `descuento_uni`, `porcen_du`, `descuento_total`, `porcen_dt`, `precio_final`, `total`, `total_uni`, `status`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 3, 199.00, 0.00, 0.00, 0.00, 0.00, 199.00, 597.00, 597.00, 1, '2026-10-19 14:26:57', '2026-10-19 14:26:57'),
(2, 1, 2, 3, 255.00, 0.00, 0.00, 0.00, 0.00, 255.00, 765.00, 765.00, 1, '2026-10-19 14:26:57', '2026-10-19 14:26:57'),
(3, 2, 1, 1, 199.00, 0.00, 0.00, 0.00, 0.00, 199.00, 199.00, 199.00, 1, '2026-10-19 14:29:08', '2026-10-19 14:29:08');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `almacens`
--
ALTER TABLE `almacens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `almacens_nombre_unique` (`nombre`),
  ADD KEY `almacens_sucursal_id_foreign` (`sucursal_id`);

--
-- Indices de la tabla `categorias`
--
ALTER TABLE `categorias`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `categorias_nombre_unique` (`nombre`);

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `cliente_productos`
--
ALTER TABLE `cliente_productos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cliente_productos_cliente_id_foreign` (`cliente_id`),
  ADD KEY `cliente_productos_producto_id_foreign` (`producto_id`);

--
-- Indices de la tabla `configuracions`
--
ALTER TABLE `configuracions`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `historial_accions`
--
ALTER TABLE `historial_accions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `historial_accions_user_id_foreign` (`user_id`);

--
-- Indices de la tabla `ingreso_detalles`
--
ALTER TABLE `ingreso_detalles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ingreso_detalles_ingreso_producto_id_foreign` (`ingreso_producto_id`),
  ADD KEY `ingreso_detalles_producto_id_foreign` (`producto_id`),
  ADD KEY `ingreso_detalles_tipo_ingreso_id` (`tipo_ingreso_id`);

--
-- Indices de la tabla `ingreso_faltantes`
--
ALTER TABLE `ingreso_faltantes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ingreso_faltantes_ingreso_producto_id_foreign` (`ingreso_producto_id`),
  ADD KEY `ingreso_faltantes_ingreso_detalle_id_foreign` (`ingreso_detalle_id`),
  ADD KEY `ingreso_faltantes_user_id_foreign` (`user_id`);

--
-- Indices de la tabla `ingreso_pagos`
--
ALTER TABLE `ingreso_pagos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ingreso_pagos_sucursal_id_foreign` (`sucursal_id`),
  ADD KEY `ingreso_pagos_almacen_id_foreign` (`almacen_id`),
  ADD KEY `ingreso_pagos_ingreso_producto_id_foreign` (`ingreso_producto_id`),
  ADD KEY `ingreso_pagos_proveedor_id_foreign` (`proveedor_id`),
  ADD KEY `ingreso_pagos_user_id_foreign` (`user_id`);

--
-- Indices de la tabla `ingreso_productos`
--
ALTER TABLE `ingreso_productos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ingreso_productos_sucursal_id_foreign` (`sucursal_id`),
  ADD KEY `ingreso_productos_proveedor_id_foreign` (`proveedor_id`),
  ADD KEY `ingreso_productos_tipo_ingreso_id_foreign` (`tipo_ingreso_id`),
  ADD KEY `ingreso_productos_almacen_id` (`almacen_id`);

--
-- Indices de la tabla `ingreso_recepcions`
--
ALTER TABLE `ingreso_recepcions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ingreso_recepcions_ingreso_producto_id_foreign` (`ingreso_producto_id`),
  ADD KEY `ingreso_recepcions_ingreso_detalle_id_foreign` (`ingreso_detalle_id`),
  ADD KEY `ingreso_recepcions_sucursal_id_foreign` (`sucursal_id`),
  ADD KEY `ingreso_recepcions_almacen_id_foreign` (`almacen_id`),
  ADD KEY `ingreso_recepcions_producto_id_foreign` (`producto_id`);

--
-- Indices de la tabla `kardex_productos`
--
ALTER TABLE `kardex_productos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `kardex_productos_producto_id_foreign` (`producto_id`),
  ADD KEY `kardex_productos_sucursal_id_foreign` (`sucursal_id`),
  ADD KEY `kardex_productos_ingreso_detalle_id_foreign` (`ingreso_detalle_id`),
  ADD KEY `kardex_productos_almacen_id` (`almacen_id`);

--
-- Indices de la tabla `marcas`
--
ALTER TABLE `marcas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `marcas_nombre_unique` (`nombre`);

--
-- Indices de la tabla `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `modulos`
--
ALTER TABLE `modulos`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `movimiento_cajas`
--
ALTER TABLE `movimiento_cajas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `movimiento_cajas_sucursal_id_foreign` (`sucursal_id`),
  ADD KEY `movimiento_cajas_user_id_foreign` (`user_id`),
  ADD KEY `movimiento_cajas_almacen_id` (`almacen_id`);

--
-- Indices de la tabla `notificacions`
--
ALTER TABLE `notificacions`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `notificacion_users`
--
ALTER TABLE `notificacion_users`
  ADD PRIMARY KEY (`id`),
  ADD KEY `notificacion_users_notificacion_id_foreign` (`notificacion_id`),
  ADD KEY `notificacion_users_user_id_foreign` (`user_id`);

--
-- Indices de la tabla `permisos`
--
ALTER TABLE `permisos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `permisos_role_id_foreign` (`role_id`),
  ADD KEY `permisos_modulo_id_foreign` (`modulo_id`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `productos_nombre_unique` (`nombre`),
  ADD UNIQUE KEY `productos_codigo_unique` (`codigo`),
  ADD KEY `productos_categoria_id_foreign` (`categoria_id`),
  ADD KEY `productos_marca_id_foreign` (`marca_id`),
  ADD KEY `productos_unidad_medida_id_foreign` (`unidad_medida_id`);

--
-- Indices de la tabla `producto_sucursals`
--
ALTER TABLE `producto_sucursals`
  ADD PRIMARY KEY (`id`),
  ADD KEY `producto_sucursals_sucursal_id_foreign` (`sucursal_id`),
  ADD KEY `producto_sucursals_producto_id_foreign` (`producto_id`),
  ADD KEY `producto_sucursals_almacen_id` (`almacen_id`);

--
-- Indices de la tabla `proformas`
--
ALTER TABLE `proformas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `proformas_sucursal_id_foreign` (`sucursal_id`),
  ADD KEY `proformas_almacen_id_foreign` (`almacen_id`),
  ADD KEY `proformas_cliente_id_foreign` (`cliente_id`),
  ADD KEY `proformas_tipo_documento_id_foreign` (`tipo_documento_id`),
  ADD KEY `proformas_user_id_foreign` (`user_id`);

--
-- Indices de la tabla `proforma_detalles`
--
ALTER TABLE `proforma_detalles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `proforma_detalles_proforma_id_foreign` (`proforma_id`),
  ADD KEY `proforma_detalles_producto_id_foreign` (`producto_id`);

--
-- Indices de la tabla `proveedors`
--
ALTER TABLE `proveedors`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `salida_detalles`
--
ALTER TABLE `salida_detalles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `salida_detalles_salida_producto_id_foreign` (`salida_producto_id`),
  ADD KEY `salida_detalles_tipo_salida_id_foreign` (`tipo_salida_id`),
  ADD KEY `salida_detalles_producto_id_foreign` (`producto_id`);

--
-- Indices de la tabla `salida_productos`
--
ALTER TABLE `salida_productos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `salida_productos_sucursal_id_foreign` (`sucursal_id`),
  ADD KEY `salida_productos_user_id_foreign` (`user_id`),
  ADD KEY `salida_productos_tipo_salida_id` (`tipo_salida_id`),
  ADD KEY `salida_productos_almacen_id` (`almacen_id`);

--
-- Indices de la tabla `sucursals`
--
ALTER TABLE `sucursals`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `sucursals_nombre_unique` (`nombre`);

--
-- Indices de la tabla `tipo_documentos`
--
ALTER TABLE `tipo_documentos`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `tipo_ingresos`
--
ALTER TABLE `tipo_ingresos`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `tipo_salidas`
--
ALTER TABLE `tipo_salidas`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `traspasos`
--
ALTER TABLE `traspasos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `traspasos_sucursal_origen_id_foreign` (`sucursal_origen_id`),
  ADD KEY `traspasos_almacen_origen_id_foreign` (`almacen_origen_id`),
  ADD KEY `traspasos_sucursal_destino_id_foreign` (`sucursal_destino_id`),
  ADD KEY `traspasos_almacen_destino_id_foreign` (`almacen_destino_id`),
  ADD KEY `traspasos_user_id_foreign` (`user_id`);

--
-- Indices de la tabla `traspaso_detalles`
--
ALTER TABLE `traspaso_detalles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `traspaso_detalles_traspaso_id_foreign` (`traspaso_id`),
  ADD KEY `traspaso_detalles_producto_id_foreign` (`producto_id`);

--
-- Indices de la tabla `unidad_medidas`
--
ALTER TABLE `unidad_medidas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unidad_medidas_nombre_unique` (`nombre`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD KEY `users_role_id_foreign` (`role_id`),
  ADD KEY `users_sucursal_id_foreign` (`sucursal_id`);

--
-- Indices de la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ventas_almacen_id` (`almacen_id`),
  ADD KEY `ventas_user_id` (`user_id`),
  ADD KEY `ventas_sucursal_id` (`sucursal_id`),
  ADD KEY `ventas_cliente_id` (`cliente_id`),
  ADD KEY `ventas_tipo_documento_id` (`tipo_documento_id`);

--
-- Indices de la tabla `venta_cobros`
--
ALTER TABLE `venta_cobros`
  ADD PRIMARY KEY (`id`),
  ADD KEY `venta_cobros_sucursal_id_foreign` (`sucursal_id`),
  ADD KEY `venta_cobros_almacen_id_foreign` (`almacen_id`),
  ADD KEY `venta_cobros_venta_id_foreign` (`venta_id`),
  ADD KEY `venta_cobros_cliente_id_foreign` (`cliente_id`),
  ADD KEY `venta_cobros_user_id_foreign` (`user_id`);

--
-- Indices de la tabla `venta_detalles`
--
ALTER TABLE `venta_detalles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `venta_detalles_venta_id_foreign` (`venta_id`),
  ADD KEY `venta_detalles_producto_id_foreign` (`producto_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `almacens`
--
ALTER TABLE `almacens`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `categorias`
--
ALTER TABLE `categorias`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de la tabla `cliente_productos`
--
ALTER TABLE `cliente_productos`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `configuracions`
--
ALTER TABLE `configuracions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `historial_accions`
--
ALTER TABLE `historial_accions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `ingreso_detalles`
--
ALTER TABLE `ingreso_detalles`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `ingreso_faltantes`
--
ALTER TABLE `ingreso_faltantes`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `ingreso_pagos`
--
ALTER TABLE `ingreso_pagos`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `ingreso_productos`
--
ALTER TABLE `ingreso_productos`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `ingreso_recepcions`
--
ALTER TABLE `ingreso_recepcions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `kardex_productos`
--
ALTER TABLE `kardex_productos`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `marcas`
--
ALTER TABLE `marcas`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT de la tabla `modulos`
--
ALTER TABLE `modulos`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=102;

--
-- AUTO_INCREMENT de la tabla `movimiento_cajas`
--
ALTER TABLE `movimiento_cajas`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `notificacions`
--
ALTER TABLE `notificacions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `notificacion_users`
--
ALTER TABLE `notificacion_users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `permisos`
--
ALTER TABLE `permisos`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `producto_sucursals`
--
ALTER TABLE `producto_sucursals`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `proformas`
--
ALTER TABLE `proformas`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `proforma_detalles`
--
ALTER TABLE `proforma_detalles`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `proveedors`
--
ALTER TABLE `proveedors`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `salida_detalles`
--
ALTER TABLE `salida_detalles`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `salida_productos`
--
ALTER TABLE `salida_productos`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `sucursals`
--
ALTER TABLE `sucursals`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `tipo_documentos`
--
ALTER TABLE `tipo_documentos`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `tipo_ingresos`
--
ALTER TABLE `tipo_ingresos`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `tipo_salidas`
--
ALTER TABLE `tipo_salidas`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `traspasos`
--
ALTER TABLE `traspasos`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `traspaso_detalles`
--
ALTER TABLE `traspaso_detalles`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `unidad_medidas`
--
ALTER TABLE `unidad_medidas`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `ventas`
--
ALTER TABLE `ventas`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `venta_cobros`
--
ALTER TABLE `venta_cobros`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `venta_detalles`
--
ALTER TABLE `venta_detalles`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `almacens`
--
ALTER TABLE `almacens`
  ADD CONSTRAINT `almacens_sucursal_id_foreign` FOREIGN KEY (`sucursal_id`) REFERENCES `sucursals` (`id`);

--
-- Filtros para la tabla `cliente_productos`
--
ALTER TABLE `cliente_productos`
  ADD CONSTRAINT `cliente_productos_cliente_id_foreign` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`),
  ADD CONSTRAINT `cliente_productos_producto_id_foreign` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`);

--
-- Filtros para la tabla `historial_accions`
--
ALTER TABLE `historial_accions`
  ADD CONSTRAINT `historial_accions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `ingreso_detalles`
--
ALTER TABLE `ingreso_detalles`
  ADD CONSTRAINT `ingreso_detalles_ingreso_producto_id_foreign` FOREIGN KEY (`ingreso_producto_id`) REFERENCES `ingreso_productos` (`id`),
  ADD CONSTRAINT `ingreso_detalles_producto_id_foreign` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`),
  ADD CONSTRAINT `ingreso_detalles_tipo_ingreso_id` FOREIGN KEY (`tipo_ingreso_id`) REFERENCES `tipo_ingresos` (`id`);

--
-- Filtros para la tabla `ingreso_faltantes`
--
ALTER TABLE `ingreso_faltantes`
  ADD CONSTRAINT `ingreso_faltantes_ingreso_detalle_id_foreign` FOREIGN KEY (`ingreso_detalle_id`) REFERENCES `ingreso_detalles` (`id`),
  ADD CONSTRAINT `ingreso_faltantes_ingreso_producto_id_foreign` FOREIGN KEY (`ingreso_producto_id`) REFERENCES `ingreso_productos` (`id`),
  ADD CONSTRAINT `ingreso_faltantes_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `ingreso_pagos`
--
ALTER TABLE `ingreso_pagos`
  ADD CONSTRAINT `ingreso_pagos_almacen_id_foreign` FOREIGN KEY (`almacen_id`) REFERENCES `almacens` (`id`),
  ADD CONSTRAINT `ingreso_pagos_ingreso_producto_id_foreign` FOREIGN KEY (`ingreso_producto_id`) REFERENCES `ingreso_productos` (`id`),
  ADD CONSTRAINT `ingreso_pagos_proveedor_id_foreign` FOREIGN KEY (`proveedor_id`) REFERENCES `proveedors` (`id`),
  ADD CONSTRAINT `ingreso_pagos_sucursal_id_foreign` FOREIGN KEY (`sucursal_id`) REFERENCES `sucursals` (`id`),
  ADD CONSTRAINT `ingreso_pagos_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `ingreso_productos`
--
ALTER TABLE `ingreso_productos`
  ADD CONSTRAINT `ingreso_productos_almacen_id` FOREIGN KEY (`almacen_id`) REFERENCES `almacens` (`id`),
  ADD CONSTRAINT `ingreso_productos_proveedor_id_foreign` FOREIGN KEY (`proveedor_id`) REFERENCES `proveedors` (`id`),
  ADD CONSTRAINT `ingreso_productos_sucursal_id_foreign` FOREIGN KEY (`sucursal_id`) REFERENCES `sucursals` (`id`),
  ADD CONSTRAINT `ingreso_productos_tipo_ingreso_id_foreign` FOREIGN KEY (`tipo_ingreso_id`) REFERENCES `tipo_ingresos` (`id`);

--
-- Filtros para la tabla `ingreso_recepcions`
--
ALTER TABLE `ingreso_recepcions`
  ADD CONSTRAINT `ingreso_recepcions_almacen_id_foreign` FOREIGN KEY (`almacen_id`) REFERENCES `almacens` (`id`),
  ADD CONSTRAINT `ingreso_recepcions_ingreso_detalle_id_foreign` FOREIGN KEY (`ingreso_detalle_id`) REFERENCES `ingreso_detalles` (`id`),
  ADD CONSTRAINT `ingreso_recepcions_ingreso_producto_id_foreign` FOREIGN KEY (`ingreso_producto_id`) REFERENCES `ingreso_productos` (`id`),
  ADD CONSTRAINT `ingreso_recepcions_producto_id_foreign` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`),
  ADD CONSTRAINT `ingreso_recepcions_sucursal_id_foreign` FOREIGN KEY (`sucursal_id`) REFERENCES `sucursals` (`id`);

--
-- Filtros para la tabla `kardex_productos`
--
ALTER TABLE `kardex_productos`
  ADD CONSTRAINT `kardex_productos_almacen_id` FOREIGN KEY (`almacen_id`) REFERENCES `almacens` (`id`),
  ADD CONSTRAINT `kardex_productos_ingreso_detalle_id_foreign` FOREIGN KEY (`ingreso_detalle_id`) REFERENCES `ingreso_detalles` (`id`),
  ADD CONSTRAINT `kardex_productos_producto_id_foreign` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`),
  ADD CONSTRAINT `kardex_productos_sucursal_id_foreign` FOREIGN KEY (`sucursal_id`) REFERENCES `sucursals` (`id`);

--
-- Filtros para la tabla `movimiento_cajas`
--
ALTER TABLE `movimiento_cajas`
  ADD CONSTRAINT `movimiento_cajas_almacen_id` FOREIGN KEY (`almacen_id`) REFERENCES `almacens` (`id`),
  ADD CONSTRAINT `movimiento_cajas_sucursal_id_foreign` FOREIGN KEY (`sucursal_id`) REFERENCES `sucursals` (`id`),
  ADD CONSTRAINT `movimiento_cajas_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `notificacion_users`
--
ALTER TABLE `notificacion_users`
  ADD CONSTRAINT `notificacion_users_notificacion_id_foreign` FOREIGN KEY (`notificacion_id`) REFERENCES `notificacions` (`id`),
  ADD CONSTRAINT `notificacion_users_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `permisos`
--
ALTER TABLE `permisos`
  ADD CONSTRAINT `permisos_modulo_id_foreign` FOREIGN KEY (`modulo_id`) REFERENCES `modulos` (`id`),
  ADD CONSTRAINT `permisos_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);

--
-- Filtros para la tabla `productos`
--
ALTER TABLE `productos`
  ADD CONSTRAINT `productos_categoria_id_foreign` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`),
  ADD CONSTRAINT `productos_marca_id_foreign` FOREIGN KEY (`marca_id`) REFERENCES `marcas` (`id`),
  ADD CONSTRAINT `productos_unidad_medida_id_foreign` FOREIGN KEY (`unidad_medida_id`) REFERENCES `unidad_medidas` (`id`);

--
-- Filtros para la tabla `producto_sucursals`
--
ALTER TABLE `producto_sucursals`
  ADD CONSTRAINT `producto_sucursals_almacen_id` FOREIGN KEY (`almacen_id`) REFERENCES `almacens` (`id`),
  ADD CONSTRAINT `producto_sucursals_producto_id_foreign` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`),
  ADD CONSTRAINT `producto_sucursals_sucursal_id_foreign` FOREIGN KEY (`sucursal_id`) REFERENCES `sucursals` (`id`);

--
-- Filtros para la tabla `proformas`
--
ALTER TABLE `proformas`
  ADD CONSTRAINT `proformas_almacen_id_foreign` FOREIGN KEY (`almacen_id`) REFERENCES `almacens` (`id`),
  ADD CONSTRAINT `proformas_cliente_id_foreign` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`),
  ADD CONSTRAINT `proformas_sucursal_id_foreign` FOREIGN KEY (`sucursal_id`) REFERENCES `sucursals` (`id`),
  ADD CONSTRAINT `proformas_tipo_documento_id_foreign` FOREIGN KEY (`tipo_documento_id`) REFERENCES `tipo_documentos` (`id`),
  ADD CONSTRAINT `proformas_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `proforma_detalles`
--
ALTER TABLE `proforma_detalles`
  ADD CONSTRAINT `proforma_detalles_producto_id_foreign` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`),
  ADD CONSTRAINT `proforma_detalles_proforma_id_foreign` FOREIGN KEY (`proforma_id`) REFERENCES `proformas` (`id`);

--
-- Filtros para la tabla `salida_detalles`
--
ALTER TABLE `salida_detalles`
  ADD CONSTRAINT `salida_detalles_producto_id_foreign` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`),
  ADD CONSTRAINT `salida_detalles_salida_producto_id_foreign` FOREIGN KEY (`salida_producto_id`) REFERENCES `salida_productos` (`id`),
  ADD CONSTRAINT `salida_detalles_tipo_salida_id_foreign` FOREIGN KEY (`tipo_salida_id`) REFERENCES `tipo_salidas` (`id`);

--
-- Filtros para la tabla `salida_productos`
--
ALTER TABLE `salida_productos`
  ADD CONSTRAINT `salida_productos_almacen_id` FOREIGN KEY (`almacen_id`) REFERENCES `almacens` (`id`),
  ADD CONSTRAINT `salida_productos_sucursal_id_foreign` FOREIGN KEY (`sucursal_id`) REFERENCES `sucursals` (`id`),
  ADD CONSTRAINT `salida_productos_tipo_salida_id` FOREIGN KEY (`tipo_salida_id`) REFERENCES `tipo_salidas` (`id`),
  ADD CONSTRAINT `salida_productos_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `traspasos`
--
ALTER TABLE `traspasos`
  ADD CONSTRAINT `traspasos_almacen_destino_id_foreign` FOREIGN KEY (`almacen_destino_id`) REFERENCES `almacens` (`id`),
  ADD CONSTRAINT `traspasos_almacen_origen_id_foreign` FOREIGN KEY (`almacen_origen_id`) REFERENCES `almacens` (`id`),
  ADD CONSTRAINT `traspasos_sucursal_destino_id_foreign` FOREIGN KEY (`sucursal_destino_id`) REFERENCES `sucursals` (`id`),
  ADD CONSTRAINT `traspasos_sucursal_origen_id_foreign` FOREIGN KEY (`sucursal_origen_id`) REFERENCES `sucursals` (`id`),
  ADD CONSTRAINT `traspasos_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `traspaso_detalles`
--
ALTER TABLE `traspaso_detalles`
  ADD CONSTRAINT `traspaso_detalles_producto_id_foreign` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`),
  ADD CONSTRAINT `traspaso_detalles_traspaso_id_foreign` FOREIGN KEY (`traspaso_id`) REFERENCES `traspasos` (`id`);

--
-- Filtros para la tabla `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
  ADD CONSTRAINT `users_sucursal_id_foreign` FOREIGN KEY (`sucursal_id`) REFERENCES `sucursals` (`id`);

--
-- Filtros para la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD CONSTRAINT `ventas_almacen_id` FOREIGN KEY (`almacen_id`) REFERENCES `almacens` (`id`),
  ADD CONSTRAINT `ventas_cliente_id` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`),
  ADD CONSTRAINT `ventas_sucursal_id` FOREIGN KEY (`sucursal_id`) REFERENCES `sucursals` (`id`),
  ADD CONSTRAINT `ventas_tipo_documento_id` FOREIGN KEY (`tipo_documento_id`) REFERENCES `tipo_documentos` (`id`),
  ADD CONSTRAINT `ventas_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `venta_cobros`
--
ALTER TABLE `venta_cobros`
  ADD CONSTRAINT `venta_cobros_almacen_id_foreign` FOREIGN KEY (`almacen_id`) REFERENCES `almacens` (`id`),
  ADD CONSTRAINT `venta_cobros_cliente_id_foreign` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`),
  ADD CONSTRAINT `venta_cobros_sucursal_id_foreign` FOREIGN KEY (`sucursal_id`) REFERENCES `sucursals` (`id`),
  ADD CONSTRAINT `venta_cobros_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `venta_cobros_venta_id_foreign` FOREIGN KEY (`venta_id`) REFERENCES `ventas` (`id`);

--
-- Filtros para la tabla `venta_detalles`
--
ALTER TABLE `venta_detalles`
  ADD CONSTRAINT `venta_detalles_producto_id_foreign` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`),
  ADD CONSTRAINT `venta_detalles_venta_id_foreign` FOREIGN KEY (`venta_id`) REFERENCES `ventas` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
