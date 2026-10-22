-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 22-10-2026 a las 00:21:29
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
(5, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA VENTA', '{\"id\": 2, \"hora\": \"10:29:08\", \"fecha\": \"2026-10-19\", \"saldo\": \"0.00\", \"total\": \"199.00\", \"nit_ci\": \"123456-CM\", \"user_id\": 1, \"subtotal\": \"199.00\", \"descuento\": \"0\", \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 2, \"cliente_id\": 1, \"created_at\": \"2026-10-19T14:29:08.000000Z\", \"tipo_venta\": \"AL CONTADO\", \"updated_at\": \"2026-10-19T14:29:08.000000Z\", \"sucursal_id\": 2, \"cancelado_qr\": \"0\", \"codigo_venta\": \"V2\", \"fecha_registro\": \"2026-10-19\", \"venta_detalles\": [{\"id\": 3, \"total\": \"199.00\", \"precio\": \"199.00\", \"status\": 1, \"cantidad\": 1, \"venta_id\": 2, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"199.00\", \"created_at\": \"2026-10-19T14:29:08.000000Z\", \"updated_at\": \"2026-10-19T14:29:08.000000Z\", \"producto_id\": 1, \"precio_final\": \"199.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"total_cancelado\": 199, \"tipo_documento_id\": 1, \"cancelado_efectivo\": \"199\", \"porcentaje_descuento\": 0}', NULL, 'VENTAS', '2026-10-19', '10:29:08', '2026-10-19 14:29:08', '2026-10-19 14:29:08'),
(6, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA VENTA', '{\"id\": 3, \"hora\": \"22:53:59\", \"fecha\": \"2026-10-19\", \"saldo\": \"199.00\", \"total\": \"199.00\", \"nit_ci\": \"123456-CM\", \"user_id\": 1, \"subtotal\": \"199.00\", \"descuento\": \"0\", \"tipo_pago\": \"\", \"almacen_id\": 1, \"cliente_id\": 1, \"created_at\": \"2026-10-20T02:53:59.000000Z\", \"tipo_venta\": \"CRÉDITO\", \"updated_at\": \"2026-10-20T02:53:59.000000Z\", \"sucursal_id\": 1, \"cancelado_qr\": \"0\", \"codigo_venta\": \"V3\", \"fecha_registro\": \"2026-10-19\", \"venta_detalles\": [{\"id\": 4, \"total\": \"199.00\", \"precio\": \"199.00\", \"status\": 1, \"cantidad\": 1, \"venta_id\": 3, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"199.00\", \"created_at\": \"2026-10-20T02:53:59.000000Z\", \"updated_at\": \"2026-10-20T02:53:59.000000Z\", \"producto_id\": 1, \"precio_final\": \"199.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"total_cancelado\": 0, \"tipo_documento_id\": 1, \"cancelado_efectivo\": \"0\", \"porcentaje_descuento\": 0}', NULL, 'VENTAS', '2026-10-19', '22:53:59', '2026-10-20 02:54:00', '2026-10-20 02:54:00');

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
(10, 2, 2, NULL, 'VENTA DE PRODUCTO', 3, 'VentaDetalle', 1, 'SALIDA POR VENTA', 199.00, 'EGRESO', NULL, 1.00, 29.00, 199.00, NULL, 199.00, 3401.00, '2026-10-19', 1, '2026-10-19 14:29:08', '2026-10-19 14:29:08'),
(11, 1, 1, NULL, 'VENTA DE PRODUCTO', 4, 'VentaDetalle', 1, 'SALIDA POR VENTA', 199.00, 'EGRESO', NULL, 1.00, 36.00, 199.00, NULL, 199.00, 4004.00, '2026-10-19', 1, '2026-10-20 02:53:59', '2026-10-20 02:53:59');

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
(40, '2026_10_17_103913_create_notificacion_users_table', 13),
(41, '2026_10_21_201740_create_telescope_entries_table', 14);

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

--
-- Volcado de datos para la tabla `permisos`
--

INSERT INTO `permisos` (`id`, `role_id`, `modulo_id`, `created_at`, `updated_at`) VALUES
(1, 2, 1, '2026-10-19 15:14:11', '2026-10-19 15:14:11'),
(2, 2, 2, '2026-10-19 15:14:12', '2026-10-19 15:14:12'),
(3, 2, 3, '2026-10-19 15:14:12', '2026-10-19 15:14:12'),
(4, 2, 4, '2026-10-19 15:14:15', '2026-10-19 15:14:15'),
(5, 2, 5, '2026-10-19 15:14:16', '2026-10-19 15:14:16'),
(6, 2, 6, '2026-10-19 15:14:17', '2026-10-19 15:14:17'),
(9, 2, 7, '2026-10-19 15:14:58', '2026-10-19 15:14:58');

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
(1, 1, 1, 1, 36.00, '2026-10-19 14:24:52', '2026-10-20 02:53:59'),
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
-- Estructura de tabla para la tabla `telescope_entries`
--

CREATE TABLE `telescope_entries` (
  `sequence` bigint UNSIGNED NOT NULL,
  `uuid` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `family_hash` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `should_display_on_index` tinyint(1) NOT NULL DEFAULT '1',
  `type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `telescope_entries`
--

INSERT INTO `telescope_entries` (`sequence`, `uuid`, `batch_id`, `family_hash`, `should_display_on_index`, `type`, `content`, `created_at`) VALUES
(1, 'a309e116-2157-4882-a07b-35cd1dc05895', 'a309e116-6815-405c-b44c-43d50f2f9949', NULL, 1, 'query', '{\"connection\":\"mysql\",\"driver\":\"mysql\",\"bindings\":[],\"sql\":\"select exists (select 1 from information_schema.tables where table_schema = schema() and table_name = \'migrations\' and table_type in (\'BASE TABLE\', \'SYSTEM VERSIONED\')) as `exists`\",\"time\":\"7.53\",\"slow\":false,\"file\":\"C:\\\\laragon\\\\www\\\\invepeso\\\\artisan\",\"line\":16,\"hash\":\"472343cbf78736393ab995dc1735b75f\",\"hostname\":\"DESKTOP-M0TID9S\"}', '2026-10-21 20:17:43'),
(2, 'a309e116-252e-4122-b77a-21b5e30f34cb', 'a309e116-6815-405c-b44c-43d50f2f9949', NULL, 1, 'query', '{\"connection\":\"mysql\",\"driver\":\"mysql\",\"bindings\":[],\"sql\":\"select exists (select 1 from information_schema.tables where table_schema = schema() and table_name = \'migrations\' and table_type in (\'BASE TABLE\', \'SYSTEM VERSIONED\')) as `exists`\",\"time\":\"1.53\",\"slow\":false,\"file\":\"C:\\\\laragon\\\\www\\\\invepeso\\\\artisan\",\"line\":16,\"hash\":\"472343cbf78736393ab995dc1735b75f\",\"hostname\":\"DESKTOP-M0TID9S\"}', '2026-10-21 20:17:43'),
(3, 'a309e116-2851-48ca-99fa-91dea2b99773', 'a309e116-6815-405c-b44c-43d50f2f9949', NULL, 1, 'query', '{\"connection\":\"mysql\",\"driver\":\"mysql\",\"bindings\":[],\"sql\":\"select `migration` from `migrations` order by `batch` asc, `migration` asc\",\"time\":\"3.49\",\"slow\":false,\"file\":\"C:\\\\laragon\\\\www\\\\invepeso\\\\artisan\",\"line\":16,\"hash\":\"ed08a59c7f0b8851f0fd2291ca94d5c7\",\"hostname\":\"DESKTOP-M0TID9S\"}', '2026-10-21 20:17:43'),
(4, 'a309e116-2976-44aa-b8f9-1a22c044119d', 'a309e116-6815-405c-b44c-43d50f2f9949', NULL, 1, 'query', '{\"connection\":\"mysql\",\"driver\":\"mysql\",\"bindings\":[],\"sql\":\"select `migration` from `migrations` order by `batch` asc, `migration` asc\",\"time\":\"0.41\",\"slow\":false,\"file\":\"C:\\\\laragon\\\\www\\\\invepeso\\\\artisan\",\"line\":16,\"hash\":\"ed08a59c7f0b8851f0fd2291ca94d5c7\",\"hostname\":\"DESKTOP-M0TID9S\"}', '2026-10-21 20:17:43'),
(5, 'a309e116-29f7-42ce-94ef-1ee3d7592802', 'a309e116-6815-405c-b44c-43d50f2f9949', NULL, 1, 'query', '{\"connection\":\"mysql\",\"driver\":\"mysql\",\"bindings\":[],\"sql\":\"select max(`batch`) as aggregate from `migrations`\",\"time\":\"0.26\",\"slow\":false,\"file\":\"C:\\\\laragon\\\\www\\\\invepeso\\\\artisan\",\"line\":16,\"hash\":\"06e60d7b3d1a0c2de504de4e6f27735e\",\"hostname\":\"DESKTOP-M0TID9S\"}', '2026-10-21 20:17:43'),
(6, 'a309e116-346b-48c1-a34b-c1fc49ea283a', 'a309e116-6815-405c-b44c-43d50f2f9949', NULL, 1, 'query', '{\"connection\":\"mysql\",\"driver\":\"mysql\",\"bindings\":[],\"sql\":\"create table `telescope_entries` (`sequence` bigint unsigned not null auto_increment primary key, `uuid` char(36) not null, `batch_id` char(36) not null, `family_hash` varchar(255) null, `should_display_on_index` tinyint(1) not null default \'1\', `type` varchar(20) not null, `content` longtext not null, `created_at` datetime null) default character set utf8mb4 collate \'utf8mb4_unicode_ci\'\",\"time\":\"11.69\",\"slow\":false,\"file\":\"C:\\\\laragon\\\\www\\\\invepeso\\\\database\\\\migrations\\\\2026_10_21_201740_create_telescope_entries_table.php\",\"line\":24,\"hash\":\"d9429550f8856c1af1c89f24a6440cb5\",\"hostname\":\"DESKTOP-M0TID9S\"}', '2026-10-21 20:17:43'),
(7, 'a309e116-3a9d-42e8-844f-475ce70de70c', 'a309e116-6815-405c-b44c-43d50f2f9949', NULL, 1, 'query', '{\"connection\":\"mysql\",\"driver\":\"mysql\",\"bindings\":[],\"sql\":\"alter table `telescope_entries` add unique `telescope_entries_uuid_unique`(`uuid`)\",\"time\":\"15.07\",\"slow\":false,\"file\":\"C:\\\\laragon\\\\www\\\\invepeso\\\\database\\\\migrations\\\\2026_10_21_201740_create_telescope_entries_table.php\",\"line\":24,\"hash\":\"9fb859ae1faff74c6b9e0b70dfd8eea9\",\"hostname\":\"DESKTOP-M0TID9S\"}', '2026-10-21 20:17:43'),
(8, 'a309e116-3e4c-40e1-b9a4-38dcdb15eb23', 'a309e116-6815-405c-b44c-43d50f2f9949', NULL, 1, 'query', '{\"connection\":\"mysql\",\"driver\":\"mysql\",\"bindings\":[],\"sql\":\"alter table `telescope_entries` add index `telescope_entries_batch_id_index`(`batch_id`)\",\"time\":\"8.72\",\"slow\":false,\"file\":\"C:\\\\laragon\\\\www\\\\invepeso\\\\database\\\\migrations\\\\2026_10_21_201740_create_telescope_entries_table.php\",\"line\":24,\"hash\":\"2b075509a9242d6e3f622536c5ccca07\",\"hostname\":\"DESKTOP-M0TID9S\"}', '2026-10-21 20:17:43'),
(9, 'a309e116-4199-40f1-b74e-95ab7fb7676d', 'a309e116-6815-405c-b44c-43d50f2f9949', NULL, 1, 'query', '{\"connection\":\"mysql\",\"driver\":\"mysql\",\"bindings\":[],\"sql\":\"alter table `telescope_entries` add index `telescope_entries_family_hash_index`(`family_hash`)\",\"time\":\"7.88\",\"slow\":false,\"file\":\"C:\\\\laragon\\\\www\\\\invepeso\\\\database\\\\migrations\\\\2026_10_21_201740_create_telescope_entries_table.php\",\"line\":24,\"hash\":\"3d25a2a244bd2028dfa0326d3dbf7f4c\",\"hostname\":\"DESKTOP-M0TID9S\"}', '2026-10-21 20:17:43'),
(10, 'a309e116-44d0-4c55-a595-5d7c799bb897', 'a309e116-6815-405c-b44c-43d50f2f9949', NULL, 1, 'query', '{\"connection\":\"mysql\",\"driver\":\"mysql\",\"bindings\":[],\"sql\":\"alter table `telescope_entries` add index `telescope_entries_created_at_index`(`created_at`)\",\"time\":\"7.55\",\"slow\":false,\"file\":\"C:\\\\laragon\\\\www\\\\invepeso\\\\database\\\\migrations\\\\2026_10_21_201740_create_telescope_entries_table.php\",\"line\":24,\"hash\":\"7352e7f84460fb7ffc450e7ea4de9dc7\",\"hostname\":\"DESKTOP-M0TID9S\"}', '2026-10-21 20:17:43'),
(11, 'a309e116-4833-42bf-bd3a-5b14f578ce09', 'a309e116-6815-405c-b44c-43d50f2f9949', NULL, 1, 'query', '{\"connection\":\"mysql\",\"driver\":\"mysql\",\"bindings\":[],\"sql\":\"alter table `telescope_entries` add index `telescope_entries_type_should_display_on_index_index`(`type`, `should_display_on_index`)\",\"time\":\"7.96\",\"slow\":false,\"file\":\"C:\\\\laragon\\\\www\\\\invepeso\\\\database\\\\migrations\\\\2026_10_21_201740_create_telescope_entries_table.php\",\"line\":24,\"hash\":\"7317a4cad2dfa1a5167548a6acd0b6a5\",\"hostname\":\"DESKTOP-M0TID9S\"}', '2026-10-21 20:17:43'),
(12, 'a309e116-4c07-4a74-8e75-44cc0fa34832', 'a309e116-6815-405c-b44c-43d50f2f9949', NULL, 1, 'query', '{\"connection\":\"mysql\",\"driver\":\"mysql\",\"bindings\":[],\"sql\":\"create table `telescope_entries_tags` (`entry_uuid` char(36) not null, `tag` varchar(255) not null, primary key (`entry_uuid`, `tag`)) default character set utf8mb4 collate \'utf8mb4_unicode_ci\'\",\"time\":\"8.58\",\"slow\":false,\"file\":\"C:\\\\laragon\\\\www\\\\invepeso\\\\database\\\\migrations\\\\2026_10_21_201740_create_telescope_entries_table.php\",\"line\":41,\"hash\":\"f8c7e1e3c3d557b70e7a918609f839f2\",\"hostname\":\"DESKTOP-M0TID9S\"}', '2026-10-21 20:17:43'),
(13, 'a309e116-524f-45d2-b2d1-18bdbc78b208', 'a309e116-6815-405c-b44c-43d50f2f9949', NULL, 1, 'query', '{\"connection\":\"mysql\",\"driver\":\"mysql\",\"bindings\":[],\"sql\":\"alter table `telescope_entries_tags` add index `telescope_entries_tags_tag_index`(`tag`)\",\"time\":\"15.51\",\"slow\":false,\"file\":\"C:\\\\laragon\\\\www\\\\invepeso\\\\database\\\\migrations\\\\2026_10_21_201740_create_telescope_entries_table.php\",\"line\":41,\"hash\":\"0bdb35d17e876d6225a7774a2c17647d\",\"hostname\":\"DESKTOP-M0TID9S\"}', '2026-10-21 20:17:43'),
(14, 'a309e116-5fcd-4456-bfa1-8f80af45e7aa', 'a309e116-6815-405c-b44c-43d50f2f9949', NULL, 1, 'query', '{\"connection\":\"mysql\",\"driver\":\"mysql\",\"bindings\":[],\"sql\":\"alter table `telescope_entries_tags` add constraint `telescope_entries_tags_entry_uuid_foreign` foreign key (`entry_uuid`) references `telescope_entries` (`uuid`) on delete cascade\",\"time\":\"33.96\",\"slow\":false,\"file\":\"C:\\\\laragon\\\\www\\\\invepeso\\\\database\\\\migrations\\\\2026_10_21_201740_create_telescope_entries_table.php\",\"line\":41,\"hash\":\"662a818f80a3a9ba2570081fd7a6af2f\",\"hostname\":\"DESKTOP-M0TID9S\"}', '2026-10-21 20:17:43'),
(15, 'a309e116-637b-4179-a5f8-4497854d2e0f', 'a309e116-6815-405c-b44c-43d50f2f9949', NULL, 1, 'query', '{\"connection\":\"mysql\",\"driver\":\"mysql\",\"bindings\":[],\"sql\":\"create table `telescope_monitoring` (`tag` varchar(255) not null, primary key (`tag`)) default character set utf8mb4 collate \'utf8mb4_unicode_ci\'\",\"time\":\"8.76\",\"slow\":false,\"file\":\"C:\\\\laragon\\\\www\\\\invepeso\\\\database\\\\migrations\\\\2026_10_21_201740_create_telescope_entries_table.php\",\"line\":54,\"hash\":\"18d1fa09eade84a80848982d91caec5c\",\"hostname\":\"DESKTOP-M0TID9S\"}', '2026-10-21 20:17:43'),
(16, 'a309e116-6669-40ad-94e8-ae947b50cb4b', 'a309e116-6815-405c-b44c-43d50f2f9949', NULL, 1, 'query', '{\"connection\":\"mysql\",\"driver\":\"mysql\",\"bindings\":[],\"sql\":\"insert into `migrations` (`migration`, `batch`) values (\'2026_10_21_201740_create_telescope_entries_table\', 14)\",\"time\":\"2.16\",\"slow\":false,\"file\":\"C:\\\\laragon\\\\www\\\\invepeso\\\\artisan\",\"line\":16,\"hash\":\"f2b8e8e4266db16aec6db940c643eb68\",\"hostname\":\"DESKTOP-M0TID9S\"}', '2026-10-21 20:17:43'),
(17, 'a309e116-6726-4d14-ba54-e76a2d2a7ee6', 'a309e116-6815-405c-b44c-43d50f2f9949', NULL, 1, 'command', '{\"command\":\"migrate\",\"exit_code\":0,\"arguments\":{\"command\":\"migrate\"},\"options\":{\"database\":null,\"force\":false,\"path\":[],\"realpath\":false,\"schema-path\":null,\"pretend\":false,\"seed\":false,\"seeder\":null,\"step\":false,\"graceful\":false,\"isolated\":false,\"help\":false,\"silent\":false,\"quiet\":false,\"verbose\":false,\"version\":false,\"ansi\":null,\"no-interaction\":false,\"env\":null},\"hostname\":\"DESKTOP-M0TID9S\"}', '2026-10-21 20:17:43'),
(18, 'a309e20a-adf5-42e6-a7a3-5b5b1f47bf4f', 'a309e20a-b8d5-49a3-9c25-d532132c4205', NULL, 1, 'query', '{\"connection\":\"mysql\",\"driver\":\"mysql\",\"bindings\":[],\"sql\":\"select * from `users` where `id` = 1 limit 1\",\"time\":\"2.76\",\"slow\":false,\"file\":\"C:\\\\laragon\\\\www\\\\invepeso\\\\app\\\\Http\\\\Middleware\\\\HandleInertiaRequests.php\",\"line\":35,\"hash\":\"082e27d9c4fc4a40315cae2c646c0509\",\"hostname\":\"DESKTOP-M0TID9S\"}', '2026-10-21 20:20:23'),
(19, 'a309e20a-b13a-4fa0-9c96-f2d4e4d7a6b1', 'a309e20a-b8d5-49a3-9c25-d532132c4205', NULL, 1, 'model', '{\"action\":\"retrieved\",\"model\":\"App\\\\Models\\\\User\",\"count\":1,\"hostname\":\"DESKTOP-M0TID9S\"}', '2026-10-21 20:20:23'),
(20, 'a309e20a-b388-4f6f-92dc-578a5eeaa02b', 'a309e20a-b8d5-49a3-9c25-d532132c4205', NULL, 1, 'query', '{\"connection\":\"mysql\",\"driver\":\"mysql\",\"bindings\":[],\"sql\":\"select * from `roles` where `roles`.`id` in (1)\",\"time\":\"0.79\",\"slow\":false,\"file\":\"C:\\\\laragon\\\\www\\\\invepeso\\\\app\\\\Http\\\\Middleware\\\\HandleInertiaRequests.php\",\"line\":35,\"hash\":\"b3f8b4044886bea1e3a43637c51979c9\",\"hostname\":\"DESKTOP-M0TID9S\",\"user\":{\"id\":1,\"name\":null,\"email\":null}}', '2026-10-21 20:20:23'),
(21, 'a309e20a-b3bf-4821-9bce-c463ab497395', 'a309e20a-b8d5-49a3-9c25-d532132c4205', NULL, 1, 'model', '{\"action\":\"retrieved\",\"model\":\"App\\\\Models\\\\Role\",\"count\":1,\"hostname\":\"DESKTOP-M0TID9S\",\"user\":{\"id\":1,\"name\":null,\"email\":null}}', '2026-10-21 20:20:23'),
(22, 'a309e20a-b78f-4737-b046-891d92a3f803', 'a309e20a-b8d5-49a3-9c25-d532132c4205', NULL, 1, 'request', '{\"ip_address\":\"127.0.0.1\",\"uri\":\"\\/\",\"method\":\"GET\",\"controller_action\":\"Closure\",\"middleware\":[\"web\"],\"headers\":{\"cookie\":\"XSRF-TOKEN=eyJpdiI6IitySUVTbjRiMVlaeWx1dEJ4SVJpMEE9PSIsInZhbHVlIjoia29GdkhBMTN0SWVXbVdMenQ4R3ZNWmRiZXhwV1Z3N0ROalN4ZWkrcGFYYWdWOGIyRHU1dk4zWHlQVTZjU1grNDA1dENrQm9VUmpSZ0pqdXZqM2NSVnRaNFpMNEpwOGxISnpNckdyZ0tNOHpuWlZRUG1sbmdMNGJzblBBbTlHMUIiLCJtYWMiOiIzNTAwNTMxMWJlYWE4MTNkN2YwMWIxMzJjYjA1Y2U3MzAwZmE2ZjU0YzliZjA4NDAzZTJiNmYyODY3MWNiNThlIiwidGFnIjoiIn0%3D; invepeso-session=eyJpdiI6IjlqZDZJbUZTVGF4aVY1b3lHY3NVNWc9PSIsInZhbHVlIjoiZDZncWFPVHF3Si9EbHVoYmtXTEdHTXRJNE55RThRWUVpckcxQlRzQ0NwSUhscW9qNmNlL09HeGF0YlBjV01HbHVXZlphS1NLa1NGc2IxREhCVExoN2FUVHhCNHpUTHEzQVE5YUtJbFAvVUQvQUJyTzQ3MmlxejIvaUF3Vml0SE8iLCJtYWMiOiJmZDNkNDA5MDMyZDZiOWVhYzQ2ZDFjZDkxYzk0MzUxMTJmZGNhZGNkNzc0MTExZmJiZTVjOWEyZjY3ZDk3YjYxIiwidGFnIjoiIn0%3D\",\"accept-language\":\"es-419,es-US;q=0.9,es;q=0.8,en-US;q=0.7,en;q=0.6,gl;q=0.5,es-MX;q=0.4,ru;q=0.3\",\"accept-encoding\":\"gzip, deflate\",\"accept\":\"text\\/html,application\\/xhtml+xml,application\\/xml;q=0.9,image\\/jxl,image\\/avif,image\\/webp,image\\/apng,*\\/*;q=0.8,application\\/signed-exchange;v=b3;q=0.7\",\"sec-purpose\":\"prefetch;prerender\",\"user-agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/155.0.0.0 Safari\\/537.36\",\"upgrade-insecure-requests\":\"1\",\"connection\":\"close\",\"host\":\"invepeso.test\"},\"payload\":[],\"session\":{\"_token\":\"2ANsA2CrdvKueXme9XRmhictWKVj1tXhLpTAvsJm\",\"_previous\":{\"url\":\"http:\\/\\/invepeso.test\",\"route\":\"generated::IBMzkZUqbkto0b1S\"},\"_flash\":{\"old\":[],\"new\":[]},\"login_web_59ba36addc2b2f9401580f014c7f58ea4e30989d\":1},\"response_headers\":{\"cache-control\":\"no-cache, private\",\"date\":\"Thu, 22 Oct 2026 00:20:23 GMT\",\"location\":\"http:\\/\\/invepeso.test\\/admin\\/inicio\",\"content-type\":\"text\\/html; charset=utf-8\",\"vary\":\"X-Inertia\",\"set-cookie\":\"XSRF-TOKEN=eyJpdiI6Iks1S1hacUV3WmRBbDBQbUIwWU1oZ0E9PSIsInZhbHVlIjoiNVZla242V29HQkUyTnRFbWQ3aUVUWWxscGp1bUFmTHlOVWpKV3BzdTNZdUk4cUdQcVRseU91SVE1V0xWdlhWWFNaMURLVzBXMEFJNGdEeEtCKzZPQ1dBU0RoTE1zelltR2x0b29yQVZlYWhidnlxMFR5SWx6QTZjRmdQVXBOcS8iLCJtYWMiOiJhNDA5ZjY4OWE0YWZkOTdjMDQ4MzExOWU4MDViMGRjYjlmNWUzYmFmYThlYzM4MTljYzRkNzdiYzUwODdhMDA4IiwidGFnIjoiIn0%3D; expires=Thu, 22 Oct 2026 02:20:23 GMT; Max-Age=7200; path=\\/; samesite=lax, invepeso-session=eyJpdiI6IjNPTWdWbkpIWnVIVksxbHFJSFc4cEE9PSIsInZhbHVlIjoiZ0Q3emxXUUxRbkowZ0ZYdkF2dDdtOUZBWTFLR2NMRSt5UThvbHhlT1VibkwzYmpGK2FWVFVZYUZsWmV1ZWEycmlZM09sOEkvSk9RZlR2alJYYW1XSG9tN3QxYTBpUklCcnZDTGxGSk1FK2YvTTNtYVIzMDdPNG9jcXBMT1VacEQiLCJtYWMiOiIxNzVhNDYwYjNlNjI0YzM2NGU4MWZmNzQxZGZmZGVlNDE1Yzc1NDJlNWQ5MmQ3OWQyNmJlZjM3OTc0NjZmZGUyIiwidGFnIjoiIn0%3D; expires=Thu, 22 Oct 2026 02:20:23 GMT; Max-Age=7200; path=\\/; httponly; samesite=lax\"},\"response_status\":302,\"response\":\"Redirected to http:\\/\\/invepeso.test\\/admin\\/inicio\",\"duration\":362,\"memory\":28,\"hostname\":\"DESKTOP-M0TID9S\",\"user\":{\"id\":1,\"name\":null,\"email\":null}}', '2026-10-21 20:20:23'),
(23, 'a309e20b-1828-4ef6-be0b-9ade86aaa18b', 'a309e20b-3d58-498a-a254-a86f12c930fa', NULL, 1, 'query', '{\"connection\":\"mysql\",\"driver\":\"mysql\",\"bindings\":[],\"sql\":\"select * from `users` where `id` = 1 limit 1\",\"time\":\"3.32\",\"slow\":false,\"file\":\"C:\\\\laragon\\\\www\\\\invepeso\\\\public\\\\index.php\",\"line\":20,\"hash\":\"082e27d9c4fc4a40315cae2c646c0509\",\"hostname\":\"DESKTOP-M0TID9S\"}', '2026-10-21 20:20:24'),
(24, 'a309e20b-19ff-48bc-a0d8-42fd17da0865', 'a309e20b-3d58-498a-a254-a86f12c930fa', NULL, 1, 'model', '{\"action\":\"retrieved\",\"model\":\"App\\\\Models\\\\User\",\"count\":1,\"hostname\":\"DESKTOP-M0TID9S\"}', '2026-10-21 20:20:24'),
(25, 'a309e20b-1ced-4bb2-80af-1a06097a224f', 'a309e20b-3d58-498a-a254-a86f12c930fa', NULL, 1, 'query', '{\"connection\":\"mysql\",\"driver\":\"mysql\",\"bindings\":[],\"sql\":\"select * from `roles` where `roles`.`id` in (1)\",\"time\":\"0.80\",\"slow\":false,\"file\":\"C:\\\\laragon\\\\www\\\\invepeso\\\\app\\\\Http\\\\Middleware\\\\HandleInertiaRequests.php\",\"line\":35,\"hash\":\"b3f8b4044886bea1e3a43637c51979c9\",\"hostname\":\"DESKTOP-M0TID9S\",\"user\":{\"id\":1,\"name\":null,\"email\":null}}', '2026-10-21 20:20:24'),
(26, 'a309e20b-1d17-46d7-9802-2e226eadd882', 'a309e20b-3d58-498a-a254-a86f12c930fa', NULL, 1, 'model', '{\"action\":\"retrieved\",\"model\":\"App\\\\Models\\\\Role\",\"count\":4,\"hostname\":\"DESKTOP-M0TID9S\",\"user\":{\"id\":1,\"name\":null,\"email\":null}}', '2026-10-21 20:20:24'),
(27, 'a309e20b-1e8e-4cd6-86c7-9f9bf1d8f4c9', 'a309e20b-3d58-498a-a254-a86f12c930fa', NULL, 1, 'query', '{\"connection\":\"mysql\",\"driver\":\"mysql\",\"bindings\":[],\"sql\":\"select * from `roles` where `roles`.`id` = 1 limit 1\",\"time\":\"0.47\",\"slow\":false,\"file\":\"C:\\\\laragon\\\\www\\\\invepeso\\\\app\\\\Services\\\\PermisoService.php\",\"line\":31,\"hash\":\"e82548a4d7797eb2fee09ff1d76cb50f\",\"hostname\":\"DESKTOP-M0TID9S\",\"user\":{\"id\":1,\"name\":null,\"email\":null}}', '2026-10-21 20:20:24'),
(28, 'a309e20b-1f58-4443-ae11-460e13e90736', 'a309e20b-3d58-498a-a254-a86f12c930fa', NULL, 1, 'query', '{\"connection\":\"mysql\",\"driver\":\"mysql\",\"bindings\":[],\"sql\":\"select * from `roles` where `roles`.`id` = 1 limit 1\",\"time\":\"0.39\",\"slow\":false,\"file\":\"C:\\\\laragon\\\\www\\\\invepeso\\\\app\\\\Services\\\\PermisoService.php\",\"line\":31,\"hash\":\"e82548a4d7797eb2fee09ff1d76cb50f\",\"hostname\":\"DESKTOP-M0TID9S\",\"user\":{\"id\":1,\"name\":null,\"email\":null}}', '2026-10-21 20:20:24'),
(29, 'a309e20b-2014-40d3-857e-acc60f6ae528', 'a309e20b-3d58-498a-a254-a86f12c930fa', NULL, 1, 'query', '{\"connection\":\"mysql\",\"driver\":\"mysql\",\"bindings\":[],\"sql\":\"select count(*) as aggregate from `users` where `id` != 1\",\"time\":\"0.65\",\"slow\":false,\"file\":\"C:\\\\laragon\\\\www\\\\invepeso\\\\app\\\\Http\\\\Controllers\\\\UserController.php\",\"line\":47,\"hash\":\"34050ad612855260ccc4f0cd6474481b\",\"hostname\":\"DESKTOP-M0TID9S\",\"user\":{\"id\":1,\"name\":null,\"email\":null}}', '2026-10-21 20:20:24'),
(30, 'a309e20b-20ac-4afc-a90b-61cf0b3a939d', 'a309e20b-3d58-498a-a254-a86f12c930fa', NULL, 1, 'query', '{\"connection\":\"mysql\",\"driver\":\"mysql\",\"bindings\":[],\"sql\":\"select count(*) as aggregate from `clientes` where `status` = 1\",\"time\":\"0.45\",\"slow\":false,\"file\":\"C:\\\\laragon\\\\www\\\\invepeso\\\\app\\\\Http\\\\Controllers\\\\UserController.php\",\"line\":56,\"hash\":\"867e6ebac7a292e7511cfe08cb5d9bcc\",\"hostname\":\"DESKTOP-M0TID9S\",\"user\":{\"id\":1,\"name\":null,\"email\":null}}', '2026-10-21 20:20:24'),
(31, 'a309e20b-2365-4bf0-8f9f-d5b52708327d', 'a309e20b-3d58-498a-a254-a86f12c930fa', NULL, 1, 'query', '{\"connection\":\"mysql\",\"driver\":\"mysql\",\"bindings\":[],\"sql\":\"select * from `roles` where `roles`.`id` = 1 limit 1\",\"time\":\"0.65\",\"slow\":false,\"file\":\"C:\\\\laragon\\\\www\\\\invepeso\\\\app\\\\Services\\\\PermisoService.php\",\"line\":31,\"hash\":\"e82548a4d7797eb2fee09ff1d76cb50f\",\"hostname\":\"DESKTOP-M0TID9S\",\"user\":{\"id\":1,\"name\":null,\"email\":null}}', '2026-10-21 20:20:24'),
(32, 'a309e20b-2847-404b-8cee-d3faf4e63282', 'a309e20b-3d58-498a-a254-a86f12c930fa', NULL, 1, 'view', '{\"name\":\"app\",\"path\":\"\\\\resources\\\\views\\/app.blade.php\",\"data\":[\"page\"],\"hostname\":\"DESKTOP-M0TID9S\",\"user\":{\"id\":1,\"name\":null,\"email\":null}}', '2026-10-21 20:20:24'),
(33, 'a309e20b-3be5-419d-868f-d4fd9d773f62', 'a309e20b-3d58-498a-a254-a86f12c930fa', NULL, 1, 'request', '{\"ip_address\":\"127.0.0.1\",\"uri\":\"\\/admin\\/inicio\",\"method\":\"GET\",\"controller_action\":\"App\\\\Http\\\\Controllers\\\\InicioController@inicio\",\"middleware\":[\"web\",\"auth\",\"permisoUsuario\"],\"headers\":{\"cookie\":\"XSRF-TOKEN=eyJpdiI6Iks1S1hacUV3WmRBbDBQbUIwWU1oZ0E9PSIsInZhbHVlIjoiNVZla242V29HQkUyTnRFbWQ3aUVUWWxscGp1bUFmTHlOVWpKV3BzdTNZdUk4cUdQcVRseU91SVE1V0xWdlhWWFNaMURLVzBXMEFJNGdEeEtCKzZPQ1dBU0RoTE1zelltR2x0b29yQVZlYWhidnlxMFR5SWx6QTZjRmdQVXBOcS8iLCJtYWMiOiJhNDA5ZjY4OWE0YWZkOTdjMDQ4MzExOWU4MDViMGRjYjlmNWUzYmFmYThlYzM4MTljYzRkNzdiYzUwODdhMDA4IiwidGFnIjoiIn0%3D; invepeso-session=eyJpdiI6IjNPTWdWbkpIWnVIVksxbHFJSFc4cEE9PSIsInZhbHVlIjoiZ0Q3emxXUUxRbkowZ0ZYdkF2dDdtOUZBWTFLR2NMRSt5UThvbHhlT1VibkwzYmpGK2FWVFVZYUZsWmV1ZWEycmlZM09sOEkvSk9RZlR2alJYYW1XSG9tN3QxYTBpUklCcnZDTGxGSk1FK2YvTTNtYVIzMDdPNG9jcXBMT1VacEQiLCJtYWMiOiIxNzVhNDYwYjNlNjI0YzM2NGU4MWZmNzQxZGZmZGVlNDE1Yzc1NDJlNWQ5MmQ3OWQyNmJlZjM3OTc0NjZmZGUyIiwidGFnIjoiIn0%3D\",\"accept-language\":\"es-419,es-US;q=0.9,es;q=0.8,en-US;q=0.7,en;q=0.6,gl;q=0.5,es-MX;q=0.4,ru;q=0.3\",\"accept-encoding\":\"gzip, deflate\",\"accept\":\"text\\/html,application\\/xhtml+xml,application\\/xml;q=0.9,image\\/jxl,image\\/avif,image\\/webp,image\\/apng,*\\/*;q=0.8,application\\/signed-exchange;v=b3;q=0.7\",\"sec-purpose\":\"prefetch;prerender\",\"user-agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/155.0.0.0 Safari\\/537.36\",\"upgrade-insecure-requests\":\"1\",\"connection\":\"close\",\"host\":\"invepeso.test\"},\"payload\":[],\"session\":{\"_token\":\"2ANsA2CrdvKueXme9XRmhictWKVj1tXhLpTAvsJm\",\"_previous\":{\"url\":\"http:\\/\\/invepeso.test\\/admin\\/inicio\",\"route\":\"inicio\"},\"_flash\":{\"old\":[],\"new\":[]},\"login_web_59ba36addc2b2f9401580f014c7f58ea4e30989d\":1},\"response_headers\":{\"cache-control\":\"no-cache, private\",\"date\":\"Thu, 22 Oct 2026 00:20:24 GMT\",\"content-type\":\"text\\/html; charset=utf-8\",\"vary\":\"X-Inertia\",\"set-cookie\":\"XSRF-TOKEN=eyJpdiI6IkJ0NkJMVkFjUlR2a09DUWZNTUM2NWc9PSIsInZhbHVlIjoicmhHUlYweVdCOUZDK2pPUEN6dzB1TTdtUk1DSWZLOXlXSnN6YTZYY3pTM2N2eU51cGg0YW5xVVJLWGV5cEJ1TDg0UytSMHBIV3NrL2JGaFRqMHU5RmpsUEdHaXM3VEtjd1VDckZSUXpaYklQK3U3OWluT1YvSlZycGFuMnVDM0kiLCJtYWMiOiIyMjA3OTFjNjNhYmNjY2I0ZWMyNzMwNzBmYTZmMWVkM2JkZjk3MGE3MTNjZGIwOWI4YTZiYTU4ZDI3YTc0Yjg0IiwidGFnIjoiIn0%3D; expires=Thu, 22 Oct 2026 02:20:24 GMT; Max-Age=7200; path=\\/; samesite=lax, invepeso-session=eyJpdiI6IisrOWVuNzJDTkcwTkpRdXcyZVZEOGc9PSIsInZhbHVlIjoiQTlVeEovbWNBSWVLNk9kQWV6MTVXczhXYk9QcmhmSWljOXRtY3ZiSVUvRmJzMkkyb2FzNi9DTlp3T1VBS1ZSbjdXaWZXMHVkOC9WMG5FZ1RiVHJJUGhFZEpkN09xTTdZbUVwN08xVkRicldZcmNJckFaTHVhT2d4NHhxclkxN28iLCJtYWMiOiJkNmQzMGE3ZWYyZWJjNDY0OWY5NmNlOTE2ZjJlMDQ4MDEzYTRiMDMxZDI3NDA4MjlmYWNiZjI1MjJjNmI4NDFmIiwidGFnIjoiIn0%3D; expires=Thu, 22 Oct 2026 02:20:24 GMT; Max-Age=7200; path=\\/; httponly; samesite=lax\"},\"response_status\":200,\"response\":{\"view\":\"C:\\\\laragon\\\\www\\\\invepeso\\\\resources\\\\views\\/app.blade.php\",\"data\":{\"page\":{\"component\":\"Admin\\/Home\",\"props\":{\"errors\":[],\"auth\":{\"user\":{\"id\":1,\"usuario\":\"admin\",\"nombre\":\"admin\",\"paterno\":\"admin\",\"materno\":\"\",\"ci\":\"0\",\"ci_exp\":\"\",\"dir\":\"\",\"correo\":\"\",\"fono\":\"\",\"foto\":null,\"tipo\":\"ADMINISTRACI\\u00d3N\",\"role_id\":1,\"acceso\":1,\"sucursal_id\":null,\"sucursal_todos\":1,\"fecha_registro\":\"2026-05-12\",\"status\":1,\"created_at\":\"2026-05-12T14:41:08.000000Z\",\"updated_at\":\"2026-05-12T14:41:08.000000Z\",\"permisos\":\"*\",\"url_foto\":\"http:\\/\\/invepeso.test\\/imgs\\/users\\/default.png\",\"foto_b64\":\"data:image\\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAgAAAAIAAgMAAACJFjxpAAAADFBMVEXFxcX\\/\\/\\/\\/p6enW1tbAmiBwAAAFiElEQVR4AezAgQAAAACAoP2pF6kAAAAAAAAAAAAAAIDbu2MkvY0jiuMWWQoUmI50BB+BgRTpCAz4G6C8CJDrC3AEXGKPoMTlYA\\/gAJfwETawI8cuBs5Nk2KtvfiLW+gLfK9m+r3X82G653+JP\\/zjF8afP1S\\/\\/y+An4\\/i51\\/\\/AsB4aH+\\/QPD6EQAY\\/zwZwN8BAP50bh786KP4+VT+3fs4\\/noigEc+jnHeJrzxX+NWMDDh4g8+EXcnLcC9T8U5S\\/CdT8bcUeBEIrwBOiI8ki7Ba5+NrePgWUy89\\/nYyxQ8Iw3f+pWY4h1gb3eAW7sDTPEOsLc7wK1TIeDuDB+I\\/OA1QOUHv\\/dFsZQkhKkh4QlEfOULYz2nGj2\\/Nn1LmwR\\/86VxlCoAW6kCsHRGANx1RgCMo5Qh2EsZgrXNQZZShp5Liv7Il8eIc5C91EHY2hxk6bwYmNscZIReDBwtCdhbErC1JGBpScBcOgFMLQsZMQs5Whayd+UQsLYsZGlZyNyykKllISNmIUfAwifw8NXvTojAjGFrdYi11SGWVoeYWx1i6lmQCiEjFkKOVgjZ+xxIhZCtFULWHkCqxCw9gNQKmP9vNHzipdEPrRcxtVbAeDkAvve0iM2QozVD9hfjhp4YP\\/UrkJYDbD2AtBxgfSkAvvHEeNcDSAsilgtAWxIy91J8AXgZAJ5e33+4tuACcAG4AFwALgBXRXQB6AFcB5MXAuA6nl9\\/0Vx\\/011\\/1V5\\/1\\/dfTPJvRtdnu\\/zL6beeFO\\/7r+fXBYbrEkt\\/j+i6ytXfpuvvE\\/ZXOnsA\\/a3a\\/l5xf7O6v1t+Xe\\/vOyz6HpO8yyboM8o7rfJes77bru83THk48p7TvOs27zvOO6\\/73vO++z7l4cgnMPQzKPopHC0N9noSSz6LJp\\/Gk88jyicy5TOp6qlc+VyyfDJbPpuuns6XzyfMJzTmMyrrKZ35nNJ8Ums+q7af1tvPK+4nNodEnPKp3fnc8npyez67\\/qVP7+\\/fL8hfcMjfsOhf8cjfMclfcnn9+BkOnLECP8Q58OYeyJ40eoyF6Ee\\/En\\/JHlP6mIlRVXprF4BxtAvArV0AxtEuALd2ARhHuwDc2gVgHPX\\/hFv9fMBddjIGeKg\\/WCxlCsI46u+Ga5mCcJd+sIG9UkGAW32ZbApFAHhod4Bb3eo04h3god0BbiUHYApVCNjbHeBW+QDAXT4a7qg7r7e214057vg0QhkEHkoSwq0kIdydXw4\\/Q3H8hjYJ3vL0WConBJhCHQaOToeBrU0BljYFmEoVgHGUKgAPnREAt84IgLuqFgAYSUEOAHszDwuAtSkHAZhLGYIpdCLgKGUIHtocZG1zkLmUIRhxDnJU1RDA1uYga5uDzKUOwhTnIEfnxcDe5iBrcyQAYGlzkKkUYhhxDrKXQgxbSwLWUohhbknA1JKAEZOAvSUBW0sC1pYEzC0JmFoSMMJyCDhaFrK3JGDtyiFgaVnI3LKQqWUhI2YhR8tC9paFrC0LWVoWMrcsZGpZyIhZyNGykL2rSIGtlQHWVgZYWhlgbmWAqZUBRiwDHK0MsLcywNbKAGsOoNUhllaHmFsdYmp1iBHrEEerQ+w5gFYI2VodYm11iKXVIeYcQCuETK0QMmIh5MgBtELI3gohWyuErDmAVolZWiFkzgG0SszUKjGjfj6gVmKOVonZcwCtFbB9HQC+ozWDbz1bvGu9iKW1AuYcQOtFTLEX1GbIaFegN0OOHEBrhuw5gNYM2XIArRuz5gDacoB3bTnAEktxXQ4wfw0AvveM8b4tiJjSJOwLIsbXsAKeNeKCiOO3D+AVbUl0AfjGs8ZPbUnIdgFoa1LWC0BblfMuB9AeC1j6gqQE0J9LmC8AOYD2ZMb7i4bt2ZTpWoHfPoB7Tj2fXzT8N1X41vkq\\/QHOAAAAAElFTkSuQmCC\",\"full_name\":\"admin admin\",\"full_ci\":\"0 \",\"fecha_registro_t\":\"12\\/05\\/2026\",\"usuario_abrev\":\"admin\",\"sucursal\":null,\"role\":{\"id\":1,\"nombre\":\"SUPER USUARIO\",\"permisos\":1,\"usuarios\":0,\"status\":1,\"created_at\":\"2026-05-12T14:41:08.000000Z\",\"updated_at\":\"2026-05-12T14:41:08.000000Z\"}}},\"flash\":{\"bien\":null,\"error\":null},\"url_app\":\"http:\\/\\/invepeso.test\",\"url_blank\":null,\"array_infos\":[{\"label\":\"USUARIOS\",\"cantidad\":2,\"color\":\"bgWhite\",\"icon\":\"fa-users\",\"url\":\"usuarios.index\"},{\"label\":\"CLIENTES\",\"cantidad\":13,\"color\":\"bgWhite\",\"icon\":\"fa-user-friends\",\"url\":\"clientes.index\"}]},\"url\":\"\\/admin\\/inicio\",\"version\":\"b55fb785720c9276ba699daf226c51da\",\"clearHistory\":false,\"encryptHistory\":false}}},\"duration\":323,\"memory\":32,\"hostname\":\"DESKTOP-M0TID9S\",\"user\":{\"id\":1,\"name\":null,\"email\":null}}', '2026-10-21 20:20:24'),
(34, 'a309e20e-9273-4ebf-8040-17e4d62da562', 'a309e20e-9aa9-4ccd-903b-f08d2b74516b', NULL, 1, 'query', '{\"connection\":\"mysql\",\"driver\":\"mysql\",\"bindings\":[],\"sql\":\"select * from `users` where `id` = 1 limit 1\",\"time\":\"3.22\",\"slow\":false,\"file\":\"C:\\\\laragon\\\\www\\\\invepeso\\\\app\\\\Http\\\\Middleware\\\\HandleInertiaRequests.php\",\"line\":35,\"hash\":\"082e27d9c4fc4a40315cae2c646c0509\",\"hostname\":\"DESKTOP-M0TID9S\"}', '2026-10-21 20:20:26'),
(35, 'a309e20e-93fe-4dbc-8eb0-a1c36d0b8e19', 'a309e20e-9aa9-4ccd-903b-f08d2b74516b', NULL, 1, 'model', '{\"action\":\"retrieved\",\"model\":\"App\\\\Models\\\\User\",\"count\":1,\"hostname\":\"DESKTOP-M0TID9S\"}', '2026-10-21 20:20:26'),
(36, 'a309e20e-958a-4703-9e31-272565fb042c', 'a309e20e-9aa9-4ccd-903b-f08d2b74516b', NULL, 1, 'query', '{\"connection\":\"mysql\",\"driver\":\"mysql\",\"bindings\":[],\"sql\":\"select * from `roles` where `roles`.`id` in (1)\",\"time\":\"0.46\",\"slow\":false,\"file\":\"C:\\\\laragon\\\\www\\\\invepeso\\\\app\\\\Http\\\\Middleware\\\\HandleInertiaRequests.php\",\"line\":35,\"hash\":\"b3f8b4044886bea1e3a43637c51979c9\",\"hostname\":\"DESKTOP-M0TID9S\",\"user\":{\"id\":1,\"name\":null,\"email\":null}}', '2026-10-21 20:20:26'),
(37, 'a309e20e-95a8-41fa-883a-a85d8b9d63dc', 'a309e20e-9aa9-4ccd-903b-f08d2b74516b', NULL, 1, 'model', '{\"action\":\"retrieved\",\"model\":\"App\\\\Models\\\\Role\",\"count\":1,\"hostname\":\"DESKTOP-M0TID9S\",\"user\":{\"id\":1,\"name\":null,\"email\":null}}', '2026-10-21 20:20:26'),
(38, 'a309e20e-970c-4221-a9bf-d2ee037cd537', 'a309e20e-9aa9-4ccd-903b-f08d2b74516b', NULL, 1, 'query', '{\"connection\":\"mysql\",\"driver\":\"mysql\",\"bindings\":[],\"sql\":\"select * from `configuracions` limit 1\",\"time\":\"1.08\",\"slow\":false,\"file\":\"C:\\\\laragon\\\\www\\\\invepeso\\\\app\\\\Http\\\\Controllers\\\\ConfiguracionController.php\",\"line\":25,\"hash\":\"0d0916704818083d6135a46d41f14da1\",\"hostname\":\"DESKTOP-M0TID9S\",\"user\":{\"id\":1,\"name\":null,\"email\":null}}', '2026-10-21 20:20:26'),
(39, 'a309e20e-972b-4b69-9264-5e26aa61bad1', 'a309e20e-9aa9-4ccd-903b-f08d2b74516b', NULL, 1, 'model', '{\"action\":\"retrieved\",\"model\":\"App\\\\Models\\\\Configuracion\",\"count\":1,\"hostname\":\"DESKTOP-M0TID9S\",\"user\":{\"id\":1,\"name\":null,\"email\":null}}', '2026-10-21 20:20:26'),
(40, 'a309e20e-99c5-48a2-b648-4214a0cd166a', 'a309e20e-9aa9-4ccd-903b-f08d2b74516b', NULL, 1, 'request', '{\"ip_address\":\"127.0.0.1\",\"uri\":\"\\/configuracions\\/getConfiguracion\",\"method\":\"GET\",\"controller_action\":\"App\\\\Http\\\\Controllers\\\\ConfiguracionController@getConfiguracion\",\"middleware\":[\"web\"],\"headers\":{\"cookie\":\"XSRF-TOKEN=eyJpdiI6IkJ0NkJMVkFjUlR2a09DUWZNTUM2NWc9PSIsInZhbHVlIjoicmhHUlYweVdCOUZDK2pPUEN6dzB1TTdtUk1DSWZLOXlXSnN6YTZYY3pTM2N2eU51cGg0YW5xVVJLWGV5cEJ1TDg0UytSMHBIV3NrL2JGaFRqMHU5RmpsUEdHaXM3VEtjd1VDckZSUXpaYklQK3U3OWluT1YvSlZycGFuMnVDM0kiLCJtYWMiOiIyMjA3OTFjNjNhYmNjY2I0ZWMyNzMwNzBmYTZmMWVkM2JkZjk3MGE3MTNjZGIwOWI4YTZiYTU4ZDI3YTc0Yjg0IiwidGFnIjoiIn0%3D; invepeso-session=eyJpdiI6IisrOWVuNzJDTkcwTkpRdXcyZVZEOGc9PSIsInZhbHVlIjoiQTlVeEovbWNBSWVLNk9kQWV6MTVXczhXYk9QcmhmSWljOXRtY3ZiSVUvRmJzMkkyb2FzNi9DTlp3T1VBS1ZSbjdXaWZXMHVkOC9WMG5FZ1RiVHJJUGhFZEpkN09xTTdZbUVwN08xVkRicldZcmNJckFaTHVhT2d4NHhxclkxN28iLCJtYWMiOiJkNmQzMGE3ZWYyZWJjNDY0OWY5NmNlOTE2ZjJlMDQ4MDEzYTRiMDMxZDI3NDA4MjlmYWNiZjI1MjJjNmI4NDFmIiwidGFnIjoiIn0%3D\",\"accept-language\":\"es-419,es-US;q=0.9,es;q=0.8,en-US;q=0.7,en;q=0.6,gl;q=0.5,es-MX;q=0.4,ru;q=0.3\",\"accept-encoding\":\"gzip, deflate\",\"referer\":\"http:\\/\\/invepeso.test\\/admin\\/inicio\",\"sec-purpose\":\"prefetch;prerender\",\"accept\":\"application\\/json, text\\/plain, *\\/*\",\"user-agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/155.0.0.0 Safari\\/537.36\",\"x-requested-with\":\"XMLHttpRequest\",\"connection\":\"close\",\"host\":\"invepeso.test\",\"x-xsrf-token\":\"eyJpdiI6IkJ0NkJMVkFjUlR2a09DUWZNTUM2NWc9PSIsInZhbHVlIjoicmhHUlYweVdCOUZDK2pPUEN6dzB1TTdtUk1DSWZLOXlXSnN6YTZYY3pTM2N2eU51cGg0YW5xVVJLWGV5cEJ1TDg0UytSMHBIV3NrL2JGaFRqMHU5RmpsUEdHaXM3VEtjd1VDckZSUXpaYklQK3U3OWluT1YvSlZycGFuMnVDM0kiLCJtYWMiOiIyMjA3OTFjNjNhYmNjY2I0ZWMyNzMwNzBmYTZmMWVkM2JkZjk3MGE3MTNjZGIwOWI4YTZiYTU4ZDI3YTc0Yjg0IiwidGFnIjoiIn0=\"},\"payload\":[],\"session\":{\"_token\":\"2ANsA2CrdvKueXme9XRmhictWKVj1tXhLpTAvsJm\",\"_previous\":{\"url\":\"http:\\/\\/invepeso.test\\/admin\\/inicio\",\"route\":\"inicio\"},\"_flash\":{\"old\":[],\"new\":[]},\"login_web_59ba36addc2b2f9401580f014c7f58ea4e30989d\":1},\"response_headers\":{\"cache-control\":\"no-cache, private\",\"date\":\"Thu, 22 Oct 2026 00:20:26 GMT\",\"content-type\":\"application\\/json\",\"vary\":\"X-Inertia\",\"set-cookie\":\"XSRF-TOKEN=eyJpdiI6IjF3QW5aY3ZvV1o3QSswYmxVVGR1K2c9PSIsInZhbHVlIjoibC9IV0hoTkdlbmJpNEZGOUh3Vm5vZTZjUjRrcktreU1qWHJ2MFNHc3Z2TDBxV2pwWWpaYXl3bjAreXBOU1lsOVh0ZWVyZnBaQzZnTngvamtKS1VjSUo2RnQ4M2pjOWFZTE5wallPdGVEVWVaWkFOOEI3aTZEbmdOeFFNZlA3bjMiLCJtYWMiOiI4NzE0MmUxMGRkNWNmZWEyMDhiZmRiMzdjODA2ODIwYmViMWU3ZTE3MzRiYzUzYzU5Mzk1OGNiMWFjNDMwNjgwIiwidGFnIjoiIn0%3D; expires=Thu, 22 Oct 2026 02:20:26 GMT; Max-Age=7200; path=\\/; samesite=lax, invepeso-session=eyJpdiI6ImFTZ0N2VnBXbG12ZHZHRTN5RVk2aUE9PSIsInZhbHVlIjoiVFBwYThCK1pCZkVxcElBandFczlWVEo3QmVHZktLRkdiL0VRK3V5cEd1L3E5NkdwWkp1U2V3Sjkyd2Fhd2w0OGdPU0JPeFRDMG9BWEdDNHFqZ2Y4aEhaZ2tUajRkdXNqd2h1YzlPWllTNUF4T3VWWUR2ekhDb3NHTS9uSkNDaTkiLCJtYWMiOiIyZGYyODM2NTMxZDMyMzBiNDM2ZmI1MzU4ODYxNjBhNzYyOWNjMDAxNWM1ZmE2MDUxMWI2MTk4NTNlMzRmNmIyIiwidGFnIjoiIn0%3D; expires=Thu, 22 Oct 2026 02:20:26 GMT; Max-Age=7200; path=\\/; httponly; samesite=lax\"},\"response_status\":200,\"response\":{\"configuracion\":{\"id\":1,\"nombre_sistema\":\"INVEPESO\",\"alias\":\"INVEPESO\",\"razon_social\":\"IMPORTADORA PESO\",\"nit\":\"11111111111\",\"dir\":\"LOS PEDREGALES #223\",\"fono\":\"2323232 - 7776666\",\"actividad\":\"ACTIVIDAD EMPRESA\",\"correo\":\"invepeso@gmail.com\",\"logo\":\"11783783341.jpg\",\"created_at\":\"2026-05-12T14:41:08.000000Z\",\"updated_at\":\"2026-08-21T14:19:06.000000Z\",\"url_logo\":\"http:\\/\\/invepeso.test\\/imgs\\/11783783341.jpg\"}},\"duration\":218,\"memory\":28,\"hostname\":\"DESKTOP-M0TID9S\",\"user\":{\"id\":1,\"name\":null,\"email\":null}}', '2026-10-21 20:20:26'),
(41, 'a309e214-b0cb-47c1-8a13-31f50231ec72', 'a309e214-b52f-46d4-9d13-d0fb970210ba', NULL, 1, 'command', '{\"command\":\"optimize\",\"exit_code\":0,\"arguments\":{\"command\":\"optimize\"},\"options\":{\"except\":null,\"help\":false,\"silent\":false,\"quiet\":false,\"verbose\":false,\"version\":false,\"ansi\":null,\"no-interaction\":false,\"env\":null},\"hostname\":\"DESKTOP-M0TID9S\"}', '2026-10-21 20:20:30');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `telescope_entries_tags`
--

CREATE TABLE `telescope_entries_tags` (
  `entry_uuid` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tag` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `telescope_entries_tags`
--

INSERT INTO `telescope_entries_tags` (`entry_uuid`, `tag`) VALUES
('a309e20e-972b-4b69-9264-5e26aa61bad1', 'App\\Models\\Configuracion'),
('a309e20a-b3bf-4821-9bce-c463ab497395', 'App\\Models\\Role'),
('a309e20b-1d17-46d7-9802-2e226eadd882', 'App\\Models\\Role'),
('a309e20e-95a8-41fa-883a-a85d8b9d63dc', 'App\\Models\\Role'),
('a309e20a-b13a-4fa0-9c96-f2d4e4d7a6b1', 'App\\Models\\User'),
('a309e20b-19ff-48bc-a0d8-42fd17da0865', 'App\\Models\\User'),
('a309e20e-93fe-4dbc-8eb0-a1c36d0b8e19', 'App\\Models\\User'),
('a309e20a-b388-4f6f-92dc-578a5eeaa02b', 'Auth:1'),
('a309e20a-b3bf-4821-9bce-c463ab497395', 'Auth:1'),
('a309e20a-b78f-4737-b046-891d92a3f803', 'Auth:1'),
('a309e20b-1ced-4bb2-80af-1a06097a224f', 'Auth:1'),
('a309e20b-1d17-46d7-9802-2e226eadd882', 'Auth:1'),
('a309e20b-1e8e-4cd6-86c7-9f9bf1d8f4c9', 'Auth:1'),
('a309e20b-1f58-4443-ae11-460e13e90736', 'Auth:1'),
('a309e20b-2014-40d3-857e-acc60f6ae528', 'Auth:1'),
('a309e20b-20ac-4afc-a90b-61cf0b3a939d', 'Auth:1'),
('a309e20b-2365-4bf0-8f9f-d5b52708327d', 'Auth:1'),
('a309e20b-2847-404b-8cee-d3faf4e63282', 'Auth:1'),
('a309e20b-3be5-419d-868f-d4fd9d773f62', 'Auth:1'),
('a309e20e-958a-4703-9e31-272565fb042c', 'Auth:1'),
('a309e20e-95a8-41fa-883a-a85d8b9d63dc', 'Auth:1'),
('a309e20e-970c-4221-a9bf-d2ee037cd537', 'Auth:1'),
('a309e20e-972b-4b69-9264-5e26aa61bad1', 'Auth:1'),
('a309e20e-99c5-48a2-b648-4214a0cd166a', 'Auth:1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `telescope_monitoring`
--

CREATE TABLE `telescope_monitoring` (
  `tag` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
(2, 'V2', 2, 2, 1, 1, '123456-CM', 'AL CONTADO', 'EFECTIVO', 199.00, 0.00, 0.00, 199.00, 199.00, 0.00, 199.00, 0.00, '2026-10-19', '10:29:08', '2026-10-19', 1, 1, '2026-10-19 14:29:08', '2026-10-19 14:29:08'),
(3, 'V3', 1, 1, 1, 1, '123456-CM', 'CRÉDITO', '', 199.00, 0.00, 0.00, 199.00, 0.00, 0.00, 0.00, 199.00, '2026-10-19', '22:53:59', '2026-10-19', 1, 1, '2026-10-20 02:53:59', '2026-10-20 02:53:59');

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
(3, 2, 1, 1, 199.00, 0.00, 0.00, 0.00, 0.00, 199.00, 199.00, 199.00, 1, '2026-10-19 14:29:08', '2026-10-19 14:29:08'),
(4, 3, 1, 1, 199.00, 0.00, 0.00, 0.00, 0.00, 199.00, 199.00, 199.00, 1, '2026-10-20 02:53:59', '2026-10-20 02:53:59');

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
-- Indices de la tabla `telescope_entries`
--
ALTER TABLE `telescope_entries`
  ADD PRIMARY KEY (`sequence`),
  ADD UNIQUE KEY `telescope_entries_uuid_unique` (`uuid`),
  ADD KEY `telescope_entries_batch_id_index` (`batch_id`),
  ADD KEY `telescope_entries_family_hash_index` (`family_hash`),
  ADD KEY `telescope_entries_created_at_index` (`created_at`),
  ADD KEY `telescope_entries_type_should_display_on_index_index` (`type`,`should_display_on_index`);

--
-- Indices de la tabla `telescope_entries_tags`
--
ALTER TABLE `telescope_entries_tags`
  ADD PRIMARY KEY (`entry_uuid`,`tag`),
  ADD KEY `telescope_entries_tags_tag_index` (`tag`);

--
-- Indices de la tabla `telescope_monitoring`
--
ALTER TABLE `telescope_monitoring`
  ADD PRIMARY KEY (`tag`);

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
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

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
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `marcas`
--
ALTER TABLE `marcas`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

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
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

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
-- AUTO_INCREMENT de la tabla `telescope_entries`
--
ALTER TABLE `telescope_entries`
  MODIFY `sequence` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

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
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `venta_cobros`
--
ALTER TABLE `venta_cobros`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `venta_detalles`
--
ALTER TABLE `venta_detalles`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

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
-- Filtros para la tabla `telescope_entries_tags`
--
ALTER TABLE `telescope_entries_tags`
  ADD CONSTRAINT `telescope_entries_tags_entry_uuid_foreign` FOREIGN KEY (`entry_uuid`) REFERENCES `telescope_entries` (`uuid`) ON DELETE CASCADE;

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
