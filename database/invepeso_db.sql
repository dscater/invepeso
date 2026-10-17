-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 17-10-2026 a las 14:40:11
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
(1, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA INGRESO DE PRODUCTO', '{\"id\": 3, \"saldo\": \"1080.00\", \"total\": \"1080.00\", \"codigo\": \"L-00003\", \"user_id\": 1, \"cancelado\": \"0\", \"created_at\": \"2026-08-25T01:33:33.000000Z\", \"updated_at\": \"2026-08-25T01:33:33.000000Z\", \"descripcion\": \"\", \"sucursal_id\": \"1\", \"proveedor_id\": \"1\", \"fecha_registro\": \"2026-08-24\", \"tipo_ingreso_id\": \"1\"}', NULL, 'INGRESO DE PRODUCTOS', '2026-08-24', '21:33:33', '2026-08-25 01:33:33', '2026-08-25 01:33:33'),
(2, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN EGRESO DE BS. 300 EN LA SUCURSAL ALMACÉN', '{\"id\": 1, \"hora\": \"21:35:28\", \"fecha\": \"2026-08-24\", \"monto\": \"300\", \"modulo\": \"IngresoProducto\", \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"created_at\": \"2026-08-25T01:35:28.000000Z\", \"updated_at\": \"2026-08-25T01:35:28.000000Z\", \"descripcion\": \"COMPRA DE PRODUCTOS\", \"registro_id\": 4, \"sucursal_id\": \"1\", \"tipo_movimiento\": \"EGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-08-24', '21:35:28', '2026-08-25 01:35:28', '2026-08-25 01:35:28'),
(3, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA INGRESO DE PRODUCTO', '{\"id\": 4, \"saldo\": \"0.00\", \"total\": \"300.00\", \"codigo\": \"L-00004\", \"user_id\": 1, \"cancelado\": \"300\", \"created_at\": \"2026-08-25T01:35:28.000000Z\", \"updated_at\": \"2026-08-25T01:35:28.000000Z\", \"descripcion\": \"\", \"sucursal_id\": \"1\", \"proveedor_id\": \"1\", \"fecha_registro\": \"2026-08-24\", \"tipo_ingreso_id\": \"1\"}', NULL, 'INGRESO DE PRODUCTOS', '2026-08-24', '21:35:28', '2026-08-25 01:35:28', '2026-08-25 01:35:28'),
(4, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UNA SUCURSAL', '{\"id\": 3, \"activo\": 1, \"nombre\": \"SUCURSAL 2\", \"ventas\": 1, \"created_at\": \"2026-07-11T15:33:42.000000Z\", \"updated_at\": \"2026-07-11T15:56:58.000000Z\", \"descripcion\": \"\", \"fecha_registro\": \"2026-07-11\"}', '{\"id\": 3, \"activo\": \"0\", \"nombre\": \"SUCURSAL 2\", \"ventas\": 1, \"created_at\": \"2026-07-11T15:33:42.000000Z\", \"updated_at\": \"2026-08-28T15:40:51.000000Z\", \"descripcion\": \"\", \"fecha_registro\": \"2026-07-11\"}', 'SUCURSALES', '2026-08-28', '11:40:51', '2026-08-28 15:40:51', '2026-08-28 15:40:51'),
(5, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UNA SUCURSAL', '{\"id\": 1, \"activo\": 1, \"nombre\": \"ALMACÉN\", \"ventas\": 0, \"created_at\": \"2026-07-11T15:33:24.000000Z\", \"updated_at\": \"2026-07-11T15:56:22.000000Z\", \"descripcion\": \"\", \"fecha_registro\": \"2026-07-11\"}', '{\"id\": 1, \"activo\": \"1\", \"nombre\": \"SUCURSAL CENTRAL\", \"ventas\": 0, \"created_at\": \"2026-07-11T15:33:24.000000Z\", \"updated_at\": \"2026-08-28T15:41:04.000000Z\", \"descripcion\": \"\", \"fecha_registro\": \"2026-07-11\"}', 'SUCURSALES', '2026-08-28', '11:41:04', '2026-08-28 15:41:04', '2026-08-28 15:41:04'),
(6, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN ALMACÉN', '{\"id\": 1, \"activo\": \"1\", \"nombre\": \"ALMACEN CENTRAL\", \"created_at\": \"2026-08-28T15:44:12.000000Z\", \"updated_at\": \"2026-08-28T15:44:12.000000Z\", \"descripcion\": \"\", \"sucursal_id\": \"1\", \"fecha_registro\": \"2026-08-28\"}', NULL, 'ALMACENES', '2026-08-28', '11:44:12', '2026-08-28 15:44:12', '2026-08-28 15:44:12'),
(7, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA INGRESO DE PRODUCTO', '{\"id\": 5, \"saldo\": \"1500.00\", \"total\": \"1500.00\", \"codigo\": \"L-00005\", \"user_id\": 1, \"cancelado\": \"0\", \"almacen_id\": 1, \"created_at\": \"2026-08-29T15:44:23.000000Z\", \"updated_at\": \"2026-08-29T15:44:23.000000Z\", \"descripcion\": \"DESC\", \"sucursal_id\": 1, \"proveedor_id\": \"1\", \"fecha_registro\": \"2026-08-29\", \"tipo_ingreso_id\": \"1\"}', NULL, 'INGRESO DE PRODUCTOS', '2026-08-29', '11:44:23', '2026-08-29 15:44:23', '2026-08-29 15:44:23'),
(8, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA INGRESO DE PRODUCTO', '{\"id\": 6, \"saldo\": \"3000.00\", \"total\": \"3000.00\", \"codigo\": \"L-00006\", \"user_id\": 1, \"cancelado\": \"0\", \"almacen_id\": 1, \"created_at\": \"2026-08-30T16:01:02.000000Z\", \"updated_at\": \"2026-08-30T16:01:02.000000Z\", \"descripcion\": \"\", \"sucursal_id\": 1, \"proveedor_id\": \"2\", \"fecha_registro\": \"2026-08-30\", \"tipo_ingreso_id\": \"2\"}', NULL, 'INGRESO DE PRODUCTOS', '2026-08-30', '12:01:02', '2026-08-30 16:01:02', '2026-08-30 16:01:02'),
(9, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA INGRESO DE PRODUCTO', '{\"id\": 7, \"saldo\": \"1200.00\", \"total\": \"1200.00\", \"codigo\": \"L-00007\", \"user_id\": 1, \"cancelado\": \"0\", \"almacen_id\": 1, \"created_at\": \"2026-08-30T16:05:07.000000Z\", \"updated_at\": \"2026-08-30T16:05:07.000000Z\", \"descripcion\": \"\", \"sucursal_id\": 1, \"proveedor_id\": \"1\", \"fecha_registro\": \"2026-08-30\", \"tipo_ingreso_id\": \"1\"}', NULL, 'INGRESO DE PRODUCTOS', '2026-08-30', '12:05:07', '2026-08-30 16:05:07', '2026-08-30 16:05:07'),
(10, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA INGRESO DE PRODUCTO', '{\"id\": 8, \"saldo\": \"480.00\", \"total\": \"480.00\", \"codigo\": \"L-00008\", \"user_id\": 1, \"cancelado\": \"0\", \"almacen_id\": 1, \"created_at\": \"2026-08-30T16:13:09.000000Z\", \"updated_at\": \"2026-08-30T16:13:09.000000Z\", \"descripcion\": \"\", \"sucursal_id\": 1, \"proveedor_id\": \"1\", \"fecha_registro\": \"2026-08-30\", \"tipo_ingreso_id\": \"1\"}', NULL, 'INGRESO DE PRODUCTOS', '2026-08-30', '12:13:09', '2026-08-30 16:13:09', '2026-08-30 16:13:09'),
(11, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA SALIDA DE PRODUCTOS', '{\"id\": 6, \"user_id\": 1, \"cantidad\": \"2\", \"almacen_id\": 1, \"created_at\": \"2026-09-02T14:23:39.000000Z\", \"updated_at\": \"2026-09-02T14:23:39.000000Z\", \"descripcion\": \"\", \"sucursal_id\": 1, \"fecha_registro\": \"2026-09-02\", \"tipo_salida_id\": null, \"salida_detalles\": [{\"id\": 7, \"cantidad\": 1, \"created_at\": \"2026-09-02T14:23:39.000000Z\", \"updated_at\": \"2026-09-02T14:23:39.000000Z\", \"observacion\": null, \"producto_id\": 2, \"tipo_salida_id\": 1, \"salida_producto_id\": 6}, {\"id\": 8, \"cantidad\": 1, \"created_at\": \"2026-09-02T14:23:39.000000Z\", \"updated_at\": \"2026-09-02T14:23:39.000000Z\", \"observacion\": null, \"producto_id\": 3, \"tipo_salida_id\": 2, \"salida_producto_id\": 6}]}', NULL, 'SALIDA DE PRODUCTOS', '2026-09-02', '10:23:39', '2026-09-02 14:23:39', '2026-09-02 14:23:39'),
(12, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN INGRESO DE BS. 1000 EN LA SUCURSAL SUCURSAL CENTRAL; almacén ALMACEN CENTRAL', '{\"id\": 2, \"hora\": \"11:16:34\", \"tipo\": \"MOVIMIENTO DE CAJA\", \"fecha\": \"2026-09-03\", \"monto\": \"1000\", \"modulo\": \"MovimientoCaja\", \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-03T15:18:33.000000Z\", \"updated_at\": \"2026-09-03T15:18:33.000000Z\", \"descripcion\": \"ingreso de efectivo\", \"registro_id\": 2, \"sucursal_id\": 1, \"tipo_movimiento\": \"INGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-03', '11:18:33', '2026-09-03 15:18:33', '2026-09-03 15:18:33'),
(13, 1, 'ELIMINACIÓN', 'EL USUARIO admin ELIMINÓ UN MOVIMIENTO DE CAJA', '{\"id\": 2, \"hora\": \"11:16:34\", \"tipo\": \"MOVIMIENTO DE CAJA\", \"fecha\": \"2026-09-03\", \"monto\": \"2000.00\", \"modulo\": \"MovimientoCaja\", \"status\": 1, \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-03T15:18:33.000000Z\", \"updated_at\": \"2026-09-03T15:29:39.000000Z\", \"descripcion\": \"ingreso de efectivo\", \"registro_id\": 2, \"sucursal_id\": 1, \"tipo_movimiento\": \"INGRESO\"}', '{\"id\": 2, \"hora\": \"11:16:34\", \"tipo\": \"MOVIMIENTO DE CAJA\", \"fecha\": \"2026-09-03\", \"monto\": \"2000.00\", \"modulo\": \"MovimientoCaja\", \"status\": 0, \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-03T15:18:33.000000Z\", \"updated_at\": \"2026-09-03T15:31:35.000000Z\", \"descripcion\": \"ingreso de efectivo\", \"registro_id\": 2, \"sucursal_id\": 1, \"tipo_movimiento\": \"INGRESO\"}', 'MOVIMIENTO DE CAJAS', '2026-09-03', '11:31:35', '2026-09-03 15:31:35', '2026-09-03 15:31:35'),
(14, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN ALMACÉN', '{\"id\": 2, \"activo\": \"1\", \"nombre\": \"ALMACEN 1\", \"created_at\": \"2026-09-04T14:35:38.000000Z\", \"updated_at\": \"2026-09-04T14:35:38.000000Z\", \"descripcion\": \"\", \"sucursal_id\": \"2\", \"fecha_registro\": \"2026-09-04\"}', NULL, 'ALMACENES', '2026-09-04', '10:35:38', '2026-09-04 14:35:38', '2026-09-04 14:35:38'),
(15, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN ALMACÉN', '{\"id\": 3, \"activo\": \"1\", \"nombre\": \"ALMACEN 2\", \"created_at\": \"2026-09-04T14:35:49.000000Z\", \"updated_at\": \"2026-09-04T14:35:49.000000Z\", \"descripcion\": \"\", \"sucursal_id\": \"3\", \"fecha_registro\": \"2026-09-04\"}', NULL, 'ALMACENES', '2026-09-04', '10:35:49', '2026-09-04 14:35:49', '2026-09-04 14:35:49'),
(16, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN ALMACÉN', '{\"id\": 4, \"activo\": \"1\", \"nombre\": \"ALMACEN 2 CENTRAL\", \"created_at\": \"2026-09-04T14:36:00.000000Z\", \"updated_at\": \"2026-09-04T14:36:00.000000Z\", \"descripcion\": \"\", \"sucursal_id\": \"1\", \"fecha_registro\": \"2026-09-04\"}', NULL, 'ALMACENES', '2026-09-04', '10:36:00', '2026-09-04 14:36:00', '2026-09-04 14:36:00'),
(17, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UN ALMACÉN', '{\"id\": 4, \"activo\": 1, \"nombre\": \"ALMACEN 2 CENTRAL\", \"created_at\": \"2026-09-04T14:36:00.000000Z\", \"updated_at\": \"2026-09-04T14:36:00.000000Z\", \"descripcion\": \"\", \"sucursal_id\": 1, \"fecha_registro\": \"2026-09-04\"}', '{\"id\": 4, \"activo\": \"0\", \"nombre\": \"ALMACEN 2 CENTRAL\", \"created_at\": \"2026-09-04T14:36:00.000000Z\", \"updated_at\": \"2026-09-04T14:36:25.000000Z\", \"descripcion\": \"\", \"sucursal_id\": \"1\", \"fecha_registro\": \"2026-09-04\"}', 'ALMACENES', '2026-09-04', '10:36:25', '2026-09-04 14:36:25', '2026-09-04 14:36:25'),
(18, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN TRASPASO DE PRODUCTOS DE ALMACEN CENTRAL A ALMACEN 1', '{\"id\": 3, \"user_id\": 1, \"cantidad\": \"3\", \"created_at\": \"2026-09-04T15:07:52.000000Z\", \"updated_at\": \"2026-09-04T15:07:52.000000Z\", \"descripcion\": \"TRASPASO DE ALMACEN CENTRAL A ALMACEN 1\", \"fecha_registro\": \"2026-09-04\", \"almacen_origen_id\": 1, \"traspaso_detalles\": [{\"id\": 2, \"cantidad\": 3, \"created_at\": \"2026-09-04T15:07:52.000000Z\", \"updated_at\": \"2026-09-04T15:07:52.000000Z\", \"observacion\": null, \"producto_id\": 2, \"traspaso_id\": 3}], \"almacen_destino_id\": 2, \"sucursal_origen_id\": 1, \"sucursal_destino_id\": 2}', NULL, 'TRASPASOS DE PRODUCTOS', '2026-09-04', '11:07:52', '2026-09-04 15:07:52', '2026-09-04 15:07:52'),
(19, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UNA PRODUCTO', '{\"id\": 2, \"activo\": 1, \"codigo\": \"P001\", \"imagen\": \"21783799752.jpeg\", \"nombre\": \"PRODUCTO 1\", \"precio\": \"200.00\", \"precio2\": null, \"precio3\": null, \"precio4\": null, \"marca_id\": 1, \"stock_min\": 3, \"created_at\": \"2026-07-11T19:55:52.000000Z\", \"updated_at\": \"2026-07-15T20:03:36.000000Z\", \"categoria_id\": 1, \"precio_compra\": \"120.00\", \"fecha_registro\": \"2026-07-11\", \"unidad_medida_id\": 1}', '{\"id\": 2, \"activo\": \"1\", \"codigo\": \"P001\", \"imagen\": \"21783799752.jpeg\", \"nombre\": \"PRODUCTO 1\", \"precio\": \"200.00\", \"precio2\": \"290\", \"precio3\": \"300\", \"precio4\": null, \"marca_id\": \"1\", \"stock_min\": \"3\", \"created_at\": \"2026-07-11T19:55:52.000000Z\", \"updated_at\": \"2026-09-06T21:17:59.000000Z\", \"categoria_id\": \"1\", \"precio_compra\": \"120.00\", \"fecha_registro\": \"2026-07-11\", \"unidad_medida_id\": \"1\"}', 'PRODUCTOS', '2026-09-06', '17:17:59', '2026-09-06 21:17:59', '2026-09-06 21:17:59'),
(20, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UNA PRODUCTO', '{\"id\": 3, \"activo\": 1, \"codigo\": \"P002\", \"imagen\": null, \"nombre\": \"PRODUCTO 2\", \"precio\": \"350.00\", \"precio2\": null, \"precio3\": null, \"precio4\": null, \"marca_id\": 1, \"stock_min\": 3, \"created_at\": \"2026-07-11T20:00:05.000000Z\", \"updated_at\": \"2026-07-15T20:03:30.000000Z\", \"categoria_id\": 1, \"precio_compra\": \"300.00\", \"fecha_registro\": \"2026-07-11\", \"unidad_medida_id\": 1}', '{\"id\": 3, \"activo\": \"1\", \"codigo\": \"P002\", \"imagen\": null, \"nombre\": \"PRODUCTO 2\", \"precio\": \"350.00\", \"precio2\": \"400\", \"precio3\": \"420\", \"precio4\": \"450\", \"marca_id\": \"1\", \"stock_min\": \"3\", \"created_at\": \"2026-07-11T20:00:05.000000Z\", \"updated_at\": \"2026-09-06T21:18:15.000000Z\", \"categoria_id\": \"1\", \"precio_compra\": \"300.00\", \"fecha_registro\": \"2026-07-11\", \"unidad_medida_id\": \"1\"}', 'PRODUCTOS', '2026-09-06', '17:18:15', '2026-09-06 21:18:15', '2026-09-06 21:18:15'),
(21, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA VENTA', '{\"id\": 8, \"hora\": \"18:24:22\", \"fecha\": \"2026-09-06\", \"saldo\": \"0.00\", \"total\": \"400.00\", \"nit_ci\": \"123456-CM\", \"user_id\": 1, \"subtotal\": \"400.00\", \"cancelado\": \"400\", \"descuento\": \"0\", \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 1, \"created_at\": \"2026-09-06T22:24:22.000000Z\", \"tipo_venta\": \"AL CONTADO\", \"updated_at\": \"2026-09-06T22:24:22.000000Z\", \"sucursal_id\": 1, \"fecha_registro\": \"2026-09-06\", \"venta_detalles\": [{\"id\": 8, \"total\": \"400.00\", \"precio\": \"200.00\", \"cantidad\": 2, \"subtotal\": \"400.00\", \"venta_id\": 8, \"descuento\": \"0.00\", \"created_at\": \"2026-09-06T22:24:22.000000Z\", \"updated_at\": \"2026-09-06T22:24:22.000000Z\", \"producto_id\": 2, \"precio_descuento\": \"200.00\", \"porcentaje_descuento\": 0}], \"tipo_documento_id\": 1, \"porcentaje_descuento\": 0}', NULL, 'VENTAS', '2026-09-06', '18:24:22', '2026-09-06 22:24:22', '2026-09-06 22:24:22'),
(22, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN INGRESO DE BS. 350.00 EN LA SUCURSAL SUCURSAL CENTRAL; almacén ALMACEN CENTRAL', '{\"id\": 3, \"hora\": \"10:32:13\", \"tipo\": \"VENTA\", \"fecha\": \"2026-09-07\", \"monto\": \"350.00\", \"modulo\": \"Venta\", \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-07T14:32:14.000000Z\", \"updated_at\": \"2026-09-07T14:32:14.000000Z\", \"descripcion\": \"INGRES POR VENTA\", \"registro_id\": 9, \"sucursal_id\": 1, \"tipo_movimiento\": \"INGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-07', '10:32:14', '2026-09-07 14:32:14', '2026-09-07 14:32:14'),
(23, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA VENTA', '{\"id\": 9, \"hora\": \"10:32:13\", \"fecha\": \"2026-09-07\", \"saldo\": \"0.00\", \"total\": \"350.00\", \"nit_ci\": \"123456-CM\", \"user_id\": 1, \"subtotal\": \"350.00\", \"cancelado\": \"350.00\", \"descuento\": \"0\", \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 1, \"created_at\": \"2026-09-07T14:32:13.000000Z\", \"tipo_venta\": \"AL CONTADO\", \"updated_at\": \"2026-09-07T14:32:13.000000Z\", \"sucursal_id\": 1, \"codigo_venta\": \"V9\", \"fecha_registro\": \"2026-09-07\", \"venta_detalles\": [{\"id\": 9, \"total\": \"350.00\", \"precio\": \"350.00\", \"cantidad\": 1, \"subtotal\": \"350.00\", \"venta_id\": 9, \"descuento\": \"0.00\", \"created_at\": \"2026-09-07T14:32:13.000000Z\", \"updated_at\": \"2026-09-07T14:32:13.000000Z\", \"producto_id\": 3, \"precio_descuento\": \"350.00\", \"porcentaje_descuento\": 0}], \"tipo_documento_id\": 1, \"porcentaje_descuento\": 0}', NULL, 'VENTAS', '2026-09-07', '10:32:14', '2026-09-07 14:32:14', '2026-09-07 14:32:14'),
(24, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA VENTA', '{\"id\": 10, \"hora\": \"10:35:45\", \"fecha\": \"2026-09-07\", \"saldo\": \"1050.00\", \"total\": \"1050.00\", \"nit_ci\": \"345345345\", \"user_id\": 1, \"subtotal\": \"1050.00\", \"cancelado\": \"0\", \"descuento\": \"0\", \"tipo_pago\": null, \"almacen_id\": 1, \"cliente_id\": 3, \"created_at\": \"2026-09-07T14:35:45.000000Z\", \"tipo_venta\": \"CRÉDITO\", \"updated_at\": \"2026-09-07T14:35:45.000000Z\", \"sucursal_id\": 1, \"codigo_venta\": \"V10\", \"fecha_registro\": \"2026-09-07\", \"venta_detalles\": [{\"id\": 10, \"total\": \"1050.00\", \"precio\": \"350.00\", \"cantidad\": 3, \"subtotal\": \"1050.00\", \"venta_id\": 10, \"descuento\": \"0.00\", \"created_at\": \"2026-09-07T14:35:45.000000Z\", \"updated_at\": \"2026-09-07T14:35:45.000000Z\", \"producto_id\": 3, \"precio_descuento\": \"350.00\", \"porcentaje_descuento\": 0}], \"tipo_documento_id\": 2, \"porcentaje_descuento\": 0}', NULL, 'VENTAS', '2026-09-07', '10:35:45', '2026-09-07 14:35:45', '2026-09-07 14:35:45'),
(25, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN EGRESO DE BS. 500 EN LA SUCURSAL SUCURSAL CENTRAL; almacén ALMACEN CENTRAL', '{\"id\": 4, \"hora\": \"12:30:17\", \"tipo\": \"PAGO POR COMPRA DE PRODUCTOS\", \"fecha\": \"2026-09-07\", \"monto\": \"500\", \"modulo\": \"IngresoPago\", \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-07T16:30:17.000000Z\", \"updated_at\": \"2026-09-07T16:30:17.000000Z\", \"descripcion\": \"PAGO POR COMPRA DE PRODUCTOS\", \"registro_id\": 3, \"sucursal_id\": 1, \"tipo_movimiento\": \"EGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-07', '12:30:17', '2026-09-07 16:30:17', '2026-09-07 16:30:17'),
(26, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 3, \"hora\": \"12:30:17\", \"fecha\": \"2026-09-07\", \"monto\": \"500\", \"user_id\": 1, \"almacen_id\": 1, \"created_at\": \"2026-09-07T16:30:17.000000Z\", \"updated_at\": \"2026-09-07T16:30:17.000000Z\", \"sucursal_id\": 1, \"proveedor_id\": 1, \"ingreso_producto_id\": 3}', NULL, 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-07', '12:30:17', '2026-09-07 16:30:17', '2026-09-07 16:30:17'),
(27, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA VENTA', '{\"id\": 11, \"hora\": \"10:55:31\", \"fecha\": \"2026-09-08\", \"saldo\": \"680.00\", \"total\": \"680.00\", \"nit_ci\": \"123456\", \"user_id\": 1, \"subtotal\": \"700.00\", \"cancelado\": \"0\", \"descuento\": \"20\", \"tipo_pago\": null, \"almacen_id\": 1, \"cliente_id\": 2, \"created_at\": \"2026-09-08T14:55:31.000000Z\", \"tipo_venta\": \"CRÉDITO\", \"updated_at\": \"2026-09-08T14:55:31.000000Z\", \"sucursal_id\": 1, \"codigo_venta\": \"V11\", \"fecha_registro\": \"2026-09-08\", \"venta_detalles\": [{\"id\": 11, \"total\": \"700.00\", \"precio\": \"350.00\", \"cantidad\": 2, \"venta_id\": 11, \"porcen_dt\": 2.86, \"porcen_du\": 0, \"total_uni\": \"700.00\", \"created_at\": \"2026-09-08T14:55:31.000000Z\", \"updated_at\": \"2026-09-08T14:55:31.000000Z\", \"producto_id\": 3, \"precio_final\": \"339.99\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"10.01\"}], \"tipo_documento_id\": 1, \"porcentaje_descuento\": \"2.86\"}', NULL, 'VENTAS', '2026-09-08', '10:55:31', '2026-09-08 14:55:31', '2026-09-08 14:55:31'),
(28, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN INGRESO DE BS. 100 EN LA SUCURSAL SUCURSAL CENTRAL; almacén ALMACEN CENTRAL', '{\"id\": 5, \"hora\": \"11:01:10\", \"tipo\": \"VENTA\", \"fecha\": \"2026-09-08\", \"monto\": \"100\", \"modulo\": \"Venta\", \"user_id\": 1, \"tipo_pago\": \"QR\", \"almacen_id\": 1, \"created_at\": \"2026-09-08T15:01:11.000000Z\", \"updated_at\": \"2026-09-08T15:01:11.000000Z\", \"descripcion\": \"INGRESO POR VENTA\", \"registro_id\": 12, \"sucursal_id\": 1, \"tipo_movimiento\": \"INGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-08', '11:01:11', '2026-09-08 15:01:11', '2026-09-08 15:01:11'),
(29, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA VENTA', '{\"id\": 12, \"hora\": \"11:01:10\", \"fecha\": \"2026-09-08\", \"saldo\": \"650.00\", \"total\": \"750.00\", \"nit_ci\": \"345345345\", \"user_id\": 1, \"subtotal\": \"780.00\", \"cancelado\": \"100\", \"descuento\": \"30\", \"tipo_pago\": \"QR\", \"almacen_id\": 1, \"cliente_id\": 3, \"created_at\": \"2026-09-08T15:01:10.000000Z\", \"tipo_venta\": \"CRÉDITO\", \"updated_at\": \"2026-09-08T15:01:10.000000Z\", \"sucursal_id\": 1, \"codigo_venta\": \"V12\", \"fecha_registro\": \"2026-09-08\", \"venta_detalles\": [{\"id\": 12, \"total\": \"749.97\", \"precio\": \"390.00\", \"cantidad\": 2, \"venta_id\": 12, \"porcen_dt\": 3.85, \"porcen_du\": 0, \"total_uni\": \"780.00\", \"created_at\": \"2026-09-08T15:01:10.000000Z\", \"updated_at\": \"2026-09-08T15:01:10.000000Z\", \"producto_id\": 4, \"precio_final\": \"374.99\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"15.02\"}], \"tipo_documento_id\": 2, \"porcentaje_descuento\": \"3.85\"}', NULL, 'VENTAS', '2026-09-08', '11:01:11', '2026-09-08 15:01:11', '2026-09-08 15:01:11'),
(30, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN INGRESO DE BS. 700 EN LA SUCURSAL SUCURSAL CENTRAL; almacén ALMACEN CENTRAL', '{\"id\": 6, \"hora\": \"10:25:07\", \"tipo\": \"COBRO POR VENTA DE PRODUCTOS\", \"fecha\": \"2026-09-09\", \"monto\": \"700\", \"modulo\": \"VentaCobro\", \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-09T14:25:07.000000Z\", \"updated_at\": \"2026-09-09T14:25:07.000000Z\", \"descripcion\": \"COBRO POR VENTA DE PRODUCTOS\", \"registro_id\": 2, \"sucursal_id\": 1, \"tipo_movimiento\": \"INGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-09', '10:25:07', '2026-09-09 14:25:07', '2026-09-09 14:25:07'),
(31, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 2, \"hora\": \"10:25:07\", \"fecha\": \"2026-09-09\", \"monto\": \"700\", \"saldo\": 0, \"user_id\": 1, \"venta_id\": 10, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 3, \"created_at\": \"2026-09-09T14:25:07.000000Z\", \"updated_at\": \"2026-09-09T14:25:07.000000Z\", \"sucursal_id\": 1}', NULL, 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-09', '10:25:07', '2026-09-09 14:25:07', '2026-09-09 14:25:07'),
(32, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN INGRESO DE BS. 50 EN LA SUCURSAL SUCURSAL CENTRAL; almacén ALMACEN CENTRAL', '{\"id\": 7, \"hora\": \"10:26:40\", \"tipo\": \"COBRO POR VENTA DE PRODUCTOS\", \"fecha\": \"2026-09-09\", \"monto\": \"50\", \"modulo\": \"VentaCobro\", \"user_id\": 1, \"tipo_pago\": \"QR\", \"almacen_id\": 1, \"created_at\": \"2026-09-09T14:26:40.000000Z\", \"updated_at\": \"2026-09-09T14:26:40.000000Z\", \"descripcion\": \"COBRO POR VENTA DE PRODUCTOS\", \"registro_id\": 3, \"sucursal_id\": 1, \"tipo_movimiento\": \"INGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-09', '10:26:40', '2026-09-09 14:26:40', '2026-09-09 14:26:40'),
(33, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 3, \"hora\": \"10:26:40\", \"fecha\": \"2026-09-09\", \"monto\": \"50\", \"saldo\": 0, \"user_id\": 1, \"venta_id\": 10, \"tipo_pago\": \"QR\", \"almacen_id\": 1, \"cliente_id\": 3, \"created_at\": \"2026-09-09T14:26:40.000000Z\", \"updated_at\": \"2026-09-09T14:26:40.000000Z\", \"sucursal_id\": 1}', NULL, 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-09', '10:26:40', '2026-09-09 14:26:40', '2026-09-09 14:26:40'),
(34, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN INGRESO DE BS. 50 EN LA SUCURSAL SUCURSAL CENTRAL; almacén ALMACEN CENTRAL', '{\"id\": 8, \"hora\": \"10:29:45\", \"tipo\": \"COBRO POR VENTA DE PRODUCTOS\", \"fecha\": \"2026-09-09\", \"monto\": \"50\", \"modulo\": \"VentaCobro\", \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-09T14:29:45.000000Z\", \"updated_at\": \"2026-09-09T14:29:45.000000Z\", \"descripcion\": \"COBRO POR VENTA DE PRODUCTOS\", \"registro_id\": 4, \"sucursal_id\": 1, \"tipo_movimiento\": \"INGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-09', '10:29:45', '2026-09-09 14:29:45', '2026-09-09 14:29:45'),
(35, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 4, \"hora\": \"10:29:45\", \"fecha\": \"2026-09-09\", \"monto\": \"50\", \"saldo\": 0, \"user_id\": 1, \"venta_id\": 10, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 3, \"created_at\": \"2026-09-09T14:29:45.000000Z\", \"updated_at\": \"2026-09-09T14:29:45.000000Z\", \"sucursal_id\": 1}', NULL, 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-09', '10:29:45', '2026-09-09 14:29:45', '2026-09-09 14:29:45'),
(36, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA PROFORMA', '{\"id\": 1, \"hora\": \"15:50:36\", \"fecha\": \"2026-09-09\", \"saldo\": \"18800.00\", \"total\": \"18800.00\", \"nit_ci\": \"123456\", \"user_id\": 1, \"subtotal\": \"18800.00\", \"cancelado\": \"0\", \"descuento\": \"0\", \"almacen_id\": 1, \"cliente_id\": 2, \"created_at\": \"2026-09-09T19:50:36.000000Z\", \"updated_at\": \"2026-09-09T19:50:36.000000Z\", \"sucursal_id\": 1, \"fecha_registro\": \"2026-09-09\", \"codigo_proforma\": \"P1\", \"proforma_detalles\": [{\"id\": 1, \"total\": \"4000.00\", \"precio\": \"200.00\", \"cantidad\": 20, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"4000.00\", \"created_at\": \"2026-09-09T19:50:36.000000Z\", \"updated_at\": \"2026-09-09T19:50:36.000000Z\", \"producto_id\": 2, \"proforma_id\": 1, \"precio_final\": \"200.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}, {\"id\": 2, \"total\": \"7000.00\", \"precio\": \"350.00\", \"cantidad\": 20, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"7000.00\", \"created_at\": \"2026-09-09T19:50:36.000000Z\", \"updated_at\": \"2026-09-09T19:50:36.000000Z\", \"producto_id\": 3, \"proforma_id\": 1, \"precio_final\": \"350.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}, {\"id\": 3, \"total\": \"7800.00\", \"precio\": \"390.00\", \"cantidad\": 20, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"7800.00\", \"created_at\": \"2026-09-09T19:50:36.000000Z\", \"updated_at\": \"2026-09-09T19:50:36.000000Z\", \"producto_id\": 4, \"proforma_id\": 1, \"precio_final\": \"390.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"tipo_documento_id\": 1, \"porcentaje_descuento\": 0}', NULL, 'PROFORMAS', '2026-09-09', '15:50:36', '2026-09-09 19:50:36', '2026-09-09 19:50:36'),
(37, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN CLIENTE', '{\"id\": 5, \"fono\": null, \"correo\": null, \"nombre\": \"PEDRO GONZALES\", \"created_at\": \"2026-09-09T20:20:36.000000Z\", \"updated_at\": \"2026-09-09T20:20:36.000000Z\", \"complemento\": null, \"nro_documento\": \"43343434\", \"fecha_registro\": \"2026-09-09\", \"tipo_documento_id\": 1}', NULL, 'CLIENTES', '2026-09-09', '16:20:36', '2026-09-09 20:20:36', '2026-09-09 20:20:36'),
(38, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN CLIENTE', '{\"id\": 6, \"fono\": null, \"correo\": null, \"nombre\": \"CONDORI\", \"created_at\": \"2026-09-09T20:23:27.000000Z\", \"updated_at\": \"2026-09-09T20:23:27.000000Z\", \"complemento\": null, \"nro_documento\": \"32233\", \"fecha_registro\": \"2026-09-09\", \"tipo_documento_id\": 1}', NULL, 'CLIENTES', '2026-09-09', '16:23:27', '2026-09-09 20:23:27', '2026-09-09 20:23:27'),
(39, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN CLIENTE', '{\"id\": 7, \"fono\": null, \"correo\": null, \"nombre\": \"MAMANI\", \"created_at\": \"2026-09-09T20:24:03.000000Z\", \"updated_at\": \"2026-09-09T20:24:03.000000Z\", \"complemento\": null, \"nro_documento\": \"223332\", \"fecha_registro\": \"2026-09-09\", \"tipo_documento_id\": 1}', NULL, 'CLIENTES', '2026-09-09', '16:24:03', '2026-09-09 20:24:03', '2026-09-09 20:24:03'),
(40, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN CLIENTE', '{\"id\": 8, \"fono\": null, \"correo\": null, \"nombre\": \"CASTRO\", \"created_at\": \"2026-09-09T20:25:10.000000Z\", \"updated_at\": \"2026-09-09T20:25:10.000000Z\", \"complemento\": null, \"nro_documento\": \"43344343\", \"fecha_registro\": \"2026-09-09\", \"tipo_documento_id\": 2}', NULL, 'CLIENTES', '2026-09-09', '16:25:10', '2026-09-09 20:25:10', '2026-09-09 20:25:10'),
(41, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA VENTA', '{\"id\": 13, \"hora\": \"16:25:25\", \"fecha\": \"2026-09-09\", \"saldo\": \"350.00\", \"total\": \"350.00\", \"nit_ci\": \"43344343\", \"user_id\": 1, \"subtotal\": \"350.00\", \"cancelado\": \"0\", \"descuento\": \"0\", \"tipo_pago\": null, \"almacen_id\": 1, \"cliente_id\": 8, \"created_at\": \"2026-09-09T20:25:25.000000Z\", \"tipo_venta\": \"CRÉDITO\", \"updated_at\": \"2026-09-09T20:25:25.000000Z\", \"sucursal_id\": 1, \"codigo_venta\": \"V13\", \"fecha_registro\": \"2026-09-09\", \"venta_detalles\": [{\"id\": 13, \"total\": \"350.00\", \"precio\": \"350.00\", \"cantidad\": 1, \"venta_id\": 13, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"350.00\", \"created_at\": \"2026-09-09T20:25:25.000000Z\", \"updated_at\": \"2026-09-09T20:25:25.000000Z\", \"producto_id\": 3, \"precio_final\": \"350.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"tipo_documento_id\": 2, \"porcentaje_descuento\": 0}', NULL, 'VENTAS', '2026-09-09', '16:25:26', '2026-09-09 20:25:26', '2026-09-09 20:25:26'),
(42, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN CLIENTE', '{\"id\": 9, \"fono\": null, \"correo\": null, \"nombre\": \"SOLIZ\", \"created_at\": \"2026-09-09T20:28:18.000000Z\", \"updated_at\": \"2026-09-09T20:28:18.000000Z\", \"complemento\": null, \"nro_documento\": \"32323\", \"fecha_registro\": \"2026-09-09\", \"tipo_documento_id\": 1}', NULL, 'CLIENTES', '2026-09-09', '16:28:18', '2026-09-09 20:28:18', '2026-09-09 20:28:18'),
(43, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA PROFORMA', '{\"id\": 2, \"hora\": \"16:28:35\", \"fecha\": \"2026-09-09\", \"saldo\": 0, \"total\": \"2100.00\", \"nit_ci\": \"32323\", \"user_id\": 1, \"subtotal\": \"2100.00\", \"cancelado\": \"2100.00\", \"descuento\": \"0\", \"almacen_id\": 1, \"cliente_id\": 9, \"created_at\": \"2026-09-09T20:28:35.000000Z\", \"updated_at\": \"2026-09-09T20:28:35.000000Z\", \"sucursal_id\": 1, \"fecha_registro\": \"2026-09-09\", \"codigo_proforma\": \"P2\", \"proforma_detalles\": [{\"id\": 4, \"total\": \"2100.00\", \"precio\": \"350.00\", \"cantidad\": 6, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"2100.00\", \"created_at\": \"2026-09-09T20:28:35.000000Z\", \"updated_at\": \"2026-09-09T20:28:35.000000Z\", \"producto_id\": 3, \"proforma_id\": 2, \"precio_final\": \"350.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"tipo_documento_id\": 1, \"porcentaje_descuento\": 0}', NULL, 'PROFORMAS', '2026-09-09', '16:28:35', '2026-09-09 20:28:35', '2026-09-09 20:28:35'),
(44, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UNA VENTA', '{\"id\": 13, \"hora\": \"16:25:25\", \"fecha\": \"2026-09-09\", \"saldo\": \"350.00\", \"total\": \"350.00\", \"nit_ci\": \"43344343\", \"status\": 1, \"user_id\": 1, \"subtotal\": \"350.00\", \"cancelado\": \"0.00\", \"descuento\": \"0.00\", \"tipo_pago\": null, \"almacen_id\": 1, \"cliente_id\": 8, \"created_at\": \"2026-09-09T20:25:25.000000Z\", \"tipo_venta\": \"CRÉDITO\", \"updated_at\": \"2026-09-09T20:25:25.000000Z\", \"sucursal_id\": 1, \"codigo_venta\": \"V13\", \"fecha_registro\": \"2026-09-09\", \"venta_detalles\": [{\"id\": 13, \"total\": \"350.00\", \"precio\": \"350.00\", \"cantidad\": 1, \"venta_id\": 13, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"350.00\", \"created_at\": \"2026-09-09T20:25:25.000000Z\", \"updated_at\": \"2026-09-09T20:25:25.000000Z\", \"producto_id\": 3, \"precio_final\": \"350.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"tipo_documento_id\": 2, \"porcentaje_descuento\": 0}', '{\"id\": 13, \"hora\": \"16:25:25\", \"fecha\": \"2026-09-09\", \"saldo\": \"700.00\", \"total\": \"700.00\", \"nit_ci\": \"43344343\", \"status\": 1, \"user_id\": 1, \"subtotal\": \"700.00\", \"cancelado\": \"0.00\", \"descuento\": \"0.00\", \"tipo_pago\": null, \"almacen_id\": 1, \"cliente_id\": 8, \"created_at\": \"2026-09-09T20:25:25.000000Z\", \"tipo_venta\": \"CRÉDITO\", \"updated_at\": \"2026-09-09T20:57:39.000000Z\", \"sucursal_id\": 1, \"codigo_venta\": \"V13\", \"fecha_registro\": \"2026-09-09\", \"venta_detalles\": [{\"id\": 13, \"total\": \"700.00\", \"precio\": \"350.00\", \"cantidad\": 2, \"venta_id\": 13, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"700.00\", \"created_at\": \"2026-09-09T20:25:25.000000Z\", \"updated_at\": \"2026-09-09T20:57:39.000000Z\", \"producto_id\": 3, \"precio_final\": \"350.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"tipo_documento_id\": 2, \"porcentaje_descuento\": \"0\"}', 'VENTAS', '2026-09-09', '16:57:39', '2026-09-09 20:57:39', '2026-09-09 20:57:39'),
(45, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN INGRESO DE BS. 700.00 EN LA SUCURSAL SUCURSAL CENTRAL; almacén ALMACEN CENTRAL', '{\"id\": 9, \"hora\": \"16:25:25\", \"tipo\": \"VENTA\", \"fecha\": \"2026-09-09\", \"monto\": \"700.00\", \"modulo\": \"Venta\", \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-09T20:57:51.000000Z\", \"updated_at\": \"2026-09-09T20:57:51.000000Z\", \"descripcion\": \"INGRESO POR VENTA\", \"registro_id\": 13, \"sucursal_id\": 1, \"tipo_movimiento\": \"INGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-09', '16:57:51', '2026-09-09 20:57:51', '2026-09-09 20:57:51'),
(46, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UNA VENTA', '{\"id\": 13, \"hora\": \"16:25:25\", \"fecha\": \"2026-09-09\", \"saldo\": \"700.00\", \"total\": \"700.00\", \"nit_ci\": \"43344343\", \"status\": 1, \"user_id\": 1, \"subtotal\": \"700.00\", \"cancelado\": \"0.00\", \"descuento\": \"0.00\", \"tipo_pago\": null, \"almacen_id\": 1, \"cliente_id\": 8, \"created_at\": \"2026-09-09T20:25:25.000000Z\", \"tipo_venta\": \"CRÉDITO\", \"updated_at\": \"2026-09-09T20:57:39.000000Z\", \"sucursal_id\": 1, \"codigo_venta\": \"V13\", \"fecha_registro\": \"2026-09-09\", \"venta_detalles\": [{\"id\": 13, \"total\": \"700.00\", \"precio\": \"350.00\", \"cantidad\": 2, \"venta_id\": 13, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"700.00\", \"created_at\": \"2026-09-09T20:25:25.000000Z\", \"updated_at\": \"2026-09-09T20:57:39.000000Z\", \"producto_id\": 3, \"precio_final\": \"350.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"tipo_documento_id\": 2, \"porcentaje_descuento\": 0}', '{\"id\": 13, \"hora\": \"16:25:25\", \"fecha\": \"2026-09-09\", \"saldo\": \"0.00\", \"total\": \"700.00\", \"nit_ci\": \"43344343\", \"status\": 1, \"user_id\": 1, \"subtotal\": \"700.00\", \"cancelado\": \"700.00\", \"descuento\": \"0.00\", \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 8, \"created_at\": \"2026-09-09T20:25:25.000000Z\", \"tipo_venta\": \"AL CONTADO\", \"updated_at\": \"2026-09-09T20:57:51.000000Z\", \"sucursal_id\": 1, \"codigo_venta\": \"V13\", \"fecha_registro\": \"2026-09-09\", \"venta_detalles\": [{\"id\": 13, \"total\": \"700.00\", \"precio\": \"350.00\", \"cantidad\": 2, \"venta_id\": 13, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"700.00\", \"created_at\": \"2026-09-09T20:25:25.000000Z\", \"updated_at\": \"2026-09-09T20:57:39.000000Z\", \"producto_id\": 3, \"precio_final\": \"350.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"tipo_documento_id\": 2, \"porcentaje_descuento\": \"0\"}', 'VENTAS', '2026-09-09', '16:57:51', '2026-09-09 20:57:51', '2026-09-09 20:57:51'),
(47, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UNA VENTA', '{\"id\": 13, \"hora\": \"16:25:25\", \"fecha\": \"2026-09-09\", \"saldo\": \"0.00\", \"total\": \"700.00\", \"nit_ci\": \"43344343\", \"status\": 1, \"user_id\": 1, \"subtotal\": \"700.00\", \"cancelado\": \"700.00\", \"descuento\": \"0.00\", \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 8, \"created_at\": \"2026-09-09T20:25:25.000000Z\", \"tipo_venta\": \"AL CONTADO\", \"updated_at\": \"2026-09-09T20:57:51.000000Z\", \"sucursal_id\": 1, \"codigo_venta\": \"V13\", \"fecha_registro\": \"2026-09-09\", \"venta_detalles\": [{\"id\": 13, \"total\": \"700.00\", \"precio\": \"350.00\", \"cantidad\": 2, \"venta_id\": 13, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"700.00\", \"created_at\": \"2026-09-09T20:25:25.000000Z\", \"updated_at\": \"2026-09-09T20:57:39.000000Z\", \"producto_id\": 3, \"precio_final\": \"350.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"tipo_documento_id\": 2, \"porcentaje_descuento\": 0}', '{\"id\": 13, \"hora\": \"16:25:25\", \"fecha\": \"2026-09-09\", \"saldo\": \"700.00\", \"total\": \"700.00\", \"nit_ci\": \"43344343\", \"status\": 1, \"user_id\": 1, \"subtotal\": \"700.00\", \"cancelado\": \"0\", \"descuento\": \"0.00\", \"tipo_pago\": null, \"almacen_id\": 1, \"cliente_id\": 8, \"created_at\": \"2026-09-09T20:25:25.000000Z\", \"tipo_venta\": \"CRÉDITO\", \"updated_at\": \"2026-09-09T20:58:04.000000Z\", \"sucursal_id\": 1, \"codigo_venta\": \"V13\", \"fecha_registro\": \"2026-09-09\", \"venta_detalles\": [{\"id\": 13, \"total\": \"700.00\", \"precio\": \"350.00\", \"cantidad\": 2, \"venta_id\": 13, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"700.00\", \"created_at\": \"2026-09-09T20:25:25.000000Z\", \"updated_at\": \"2026-09-09T20:57:39.000000Z\", \"producto_id\": 3, \"precio_final\": \"350.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"tipo_documento_id\": 2, \"porcentaje_descuento\": \"0\"}', 'VENTAS', '2026-09-09', '16:58:04', '2026-09-09 20:58:04', '2026-09-09 20:58:04'),
(48, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN INGRESO DE BS. 1090 EN LA SUCURSAL SUCURSAL CENTRAL; almacén ALMACEN CENTRAL', '{\"id\": 10, \"hora\": \"16:25:25\", \"tipo\": \"VENTA\", \"fecha\": \"2026-09-09\", \"monto\": \"1090\", \"modulo\": \"Venta\", \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-09T20:58:31.000000Z\", \"updated_at\": \"2026-09-09T20:58:31.000000Z\", \"descripcion\": \"INGRESO POR VENTA\", \"registro_id\": 13, \"sucursal_id\": 1, \"tipo_movimiento\": \"INGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-09', '16:58:31', '2026-09-09 20:58:31', '2026-09-09 20:58:31'),
(49, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UNA VENTA', '{\"id\": 13, \"hora\": \"16:25:25\", \"fecha\": \"2026-09-09\", \"saldo\": \"700.00\", \"total\": \"700.00\", \"nit_ci\": \"43344343\", \"status\": 1, \"user_id\": 1, \"subtotal\": \"700.00\", \"cancelado\": \"0.00\", \"descuento\": \"0.00\", \"tipo_pago\": null, \"almacen_id\": 1, \"cliente_id\": 8, \"created_at\": \"2026-09-09T20:25:25.000000Z\", \"tipo_venta\": \"CRÉDITO\", \"updated_at\": \"2026-09-09T20:58:04.000000Z\", \"sucursal_id\": 1, \"codigo_venta\": \"V13\", \"fecha_registro\": \"2026-09-09\", \"venta_detalles\": [{\"id\": 13, \"total\": \"700.00\", \"precio\": \"350.00\", \"cantidad\": 2, \"venta_id\": 13, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"700.00\", \"created_at\": \"2026-09-09T20:25:25.000000Z\", \"updated_at\": \"2026-09-09T20:57:39.000000Z\", \"producto_id\": 3, \"precio_final\": \"350.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"tipo_documento_id\": 2, \"porcentaje_descuento\": 0}', '{\"id\": 13, \"hora\": \"16:25:25\", \"fecha\": \"2026-09-09\", \"saldo\": \"0.00\", \"total\": \"1090.00\", \"nit_ci\": \"43344343\", \"status\": 1, \"user_id\": 1, \"subtotal\": \"1090.00\", \"cancelado\": \"1090\", \"descuento\": \"0.00\", \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 8, \"created_at\": \"2026-09-09T20:25:25.000000Z\", \"tipo_venta\": \"AL CONTADO\", \"updated_at\": \"2026-09-09T20:58:31.000000Z\", \"sucursal_id\": 1, \"codigo_venta\": \"V13\", \"fecha_registro\": \"2026-09-09\", \"venta_detalles\": [{\"id\": 13, \"total\": \"700.00\", \"precio\": \"350.00\", \"cantidad\": 2, \"venta_id\": 13, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"700.00\", \"created_at\": \"2026-09-09T20:25:25.000000Z\", \"updated_at\": \"2026-09-09T20:57:39.000000Z\", \"producto_id\": 3, \"precio_final\": \"350.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}, {\"id\": 14, \"total\": \"390.00\", \"precio\": \"390.00\", \"cantidad\": 1, \"venta_id\": 13, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"390.00\", \"created_at\": \"2026-09-09T20:58:31.000000Z\", \"updated_at\": \"2026-09-09T20:58:31.000000Z\", \"producto_id\": 4, \"precio_final\": \"390.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"tipo_documento_id\": 2, \"porcentaje_descuento\": \"0\"}', 'VENTAS', '2026-09-09', '16:58:31', '2026-09-09 20:58:31', '2026-09-09 20:58:31'),
(50, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UNA PROFORMA', '{\"id\": 2, \"hora\": \"16:28:35\", \"fecha\": \"2026-09-09\", \"saldo\": \"0.00\", \"total\": \"2100.00\", \"nit_ci\": \"32323\", \"status\": 1, \"user_id\": 1, \"subtotal\": \"2100.00\", \"cancelado\": \"2100.00\", \"descuento\": \"0.00\", \"almacen_id\": 1, \"cliente_id\": 9, \"created_at\": \"2026-09-09T20:28:35.000000Z\", \"updated_at\": \"2026-09-09T20:28:35.000000Z\", \"sucursal_id\": 1, \"fecha_registro\": \"2026-09-09\", \"codigo_proforma\": \"P2\", \"proforma_detalles\": [{\"id\": 4, \"total\": \"2100.00\", \"precio\": \"350.00\", \"cantidad\": 6, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"2100.00\", \"created_at\": \"2026-09-09T20:28:35.000000Z\", \"updated_at\": \"2026-09-09T20:28:35.000000Z\", \"producto_id\": 3, \"proforma_id\": 2, \"precio_final\": \"350.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"tipo_documento_id\": 1, \"porcentaje_descuento\": 0}', '{\"id\": 2, \"hora\": \"16:28:35\", \"fecha\": \"2026-09-09\", \"saldo\": \"940.00\", \"total\": \"3040.00\", \"nit_ci\": \"32323\", \"status\": 1, \"user_id\": 1, \"subtotal\": \"3040.00\", \"cancelado\": \"2100.00\", \"descuento\": \"0.00\", \"almacen_id\": 3, \"cliente_id\": 9, \"created_at\": \"2026-09-09T20:28:35.000000Z\", \"updated_at\": \"2026-09-09T21:05:53.000000Z\", \"sucursal_id\": 3, \"fecha_registro\": \"2026-09-09\", \"codigo_proforma\": \"P2\", \"proforma_detalles\": [{\"id\": 4, \"total\": \"2450.00\", \"precio\": \"350.00\", \"cantidad\": 7, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"2450.00\", \"created_at\": \"2026-09-09T20:28:35.000000Z\", \"updated_at\": \"2026-09-09T21:05:53.000000Z\", \"producto_id\": 3, \"proforma_id\": 2, \"precio_final\": \"350.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}, {\"id\": 5, \"total\": \"200.00\", \"precio\": \"200.00\", \"cantidad\": 1, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"200.00\", \"created_at\": \"2026-09-09T21:05:53.000000Z\", \"updated_at\": \"2026-09-09T21:05:53.000000Z\", \"producto_id\": 2, \"proforma_id\": 2, \"precio_final\": \"200.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}, {\"id\": 6, \"total\": \"390.00\", \"precio\": \"390.00\", \"cantidad\": 1, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"390.00\", \"created_at\": \"2026-09-09T21:05:53.000000Z\", \"updated_at\": \"2026-09-09T21:05:53.000000Z\", \"producto_id\": 4, \"proforma_id\": 2, \"precio_final\": \"390.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"tipo_documento_id\": 1, \"porcentaje_descuento\": \"0\"}', 'PROFORMAS', '2026-09-09', '17:05:53', '2026-09-09 21:05:53', '2026-09-09 21:05:53'),
(51, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UNA PROFORMA', '{\"id\": 2, \"hora\": \"16:28:35\", \"fecha\": \"2026-09-09\", \"saldo\": \"940.00\", \"total\": \"3040.00\", \"nit_ci\": \"32323\", \"status\": 1, \"user_id\": 1, \"subtotal\": \"3040.00\", \"cancelado\": \"2100.00\", \"descuento\": \"0.00\", \"almacen_id\": 3, \"cliente_id\": 9, \"created_at\": \"2026-09-09T20:28:35.000000Z\", \"updated_at\": \"2026-09-09T21:05:53.000000Z\", \"sucursal_id\": 3, \"fecha_registro\": \"2026-09-09\", \"codigo_proforma\": \"P2\", \"proforma_detalles\": [{\"id\": 4, \"total\": \"2450.00\", \"precio\": \"350.00\", \"cantidad\": 7, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"2450.00\", \"created_at\": \"2026-09-09T20:28:35.000000Z\", \"updated_at\": \"2026-09-09T21:05:53.000000Z\", \"producto_id\": 3, \"proforma_id\": 2, \"precio_final\": \"350.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}, {\"id\": 5, \"total\": \"200.00\", \"precio\": \"200.00\", \"cantidad\": 1, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"200.00\", \"created_at\": \"2026-09-09T21:05:53.000000Z\", \"updated_at\": \"2026-09-09T21:05:53.000000Z\", \"producto_id\": 2, \"proforma_id\": 2, \"precio_final\": \"200.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}, {\"id\": 6, \"total\": \"390.00\", \"precio\": \"390.00\", \"cantidad\": 1, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"390.00\", \"created_at\": \"2026-09-09T21:05:53.000000Z\", \"updated_at\": \"2026-09-09T21:05:53.000000Z\", \"producto_id\": 4, \"proforma_id\": 2, \"precio_final\": \"390.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"tipo_documento_id\": 1, \"porcentaje_descuento\": 0}', '{\"id\": 2, \"hora\": \"16:28:35\", \"fecha\": \"2026-09-09\", \"saldo\": \"550.00\", \"total\": \"2650.00\", \"nit_ci\": \"32323\", \"status\": 1, \"user_id\": 1, \"subtotal\": \"2650.00\", \"cancelado\": \"2100.00\", \"descuento\": \"0.00\", \"almacen_id\": 3, \"cliente_id\": 9, \"created_at\": \"2026-09-09T20:28:35.000000Z\", \"updated_at\": \"2026-09-09T21:06:05.000000Z\", \"sucursal_id\": 3, \"fecha_registro\": \"2026-09-09\", \"codigo_proforma\": \"P2\", \"proforma_detalles\": [{\"id\": 4, \"total\": \"2450.00\", \"precio\": \"350.00\", \"cantidad\": 7, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"2450.00\", \"created_at\": \"2026-09-09T20:28:35.000000Z\", \"updated_at\": \"2026-09-09T21:05:53.000000Z\", \"producto_id\": 3, \"proforma_id\": 2, \"precio_final\": \"350.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}, {\"id\": 5, \"total\": \"200.00\", \"precio\": \"200.00\", \"cantidad\": 1, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"200.00\", \"created_at\": \"2026-09-09T21:05:53.000000Z\", \"updated_at\": \"2026-09-09T21:05:53.000000Z\", \"producto_id\": 2, \"proforma_id\": 2, \"precio_final\": \"200.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"tipo_documento_id\": 1, \"porcentaje_descuento\": \"0\"}', 'PROFORMAS', '2026-09-09', '17:06:05', '2026-09-09 21:06:05', '2026-09-09 21:06:05'),
(52, 1, 'ELIMINACIÓN', 'EL USUARIO admin ELIMINÓ UNA VENTA', '{\"id\": 13, \"hora\": \"16:25:25\", \"fecha\": \"2026-09-09\", \"saldo\": \"0.00\", \"total\": \"1090.00\", \"nit_ci\": \"43344343\", \"status\": 1, \"user_id\": 1, \"subtotal\": \"1090.00\", \"cancelado\": \"1090.00\", \"descuento\": \"0.00\", \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 8, \"created_at\": \"2026-09-09T20:25:25.000000Z\", \"tipo_venta\": \"AL CONTADO\", \"updated_at\": \"2026-09-09T20:58:31.000000Z\", \"sucursal_id\": 1, \"codigo_venta\": \"V13\", \"fecha_registro\": \"2026-09-09\", \"venta_detalles\": [], \"tipo_documento_id\": 2, \"porcentaje_descuento\": 0}', '{\"id\": 13, \"hora\": \"16:25:25\", \"fecha\": \"2026-09-09\", \"saldo\": \"0.00\", \"total\": \"1090.00\", \"nit_ci\": \"43344343\", \"status\": 0, \"user_id\": 1, \"subtotal\": \"1090.00\", \"cancelado\": \"1090.00\", \"descuento\": \"0.00\", \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 8, \"created_at\": \"2026-09-09T20:25:25.000000Z\", \"tipo_venta\": \"AL CONTADO\", \"updated_at\": \"2026-09-10T14:48:00.000000Z\", \"sucursal_id\": 1, \"codigo_venta\": \"V13\", \"fecha_registro\": \"2026-09-09\", \"venta_detalles\": [{\"id\": 13, \"total\": \"700.00\", \"precio\": \"350.00\", \"status\": 1, \"cantidad\": 2, \"venta_id\": 13, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"700.00\", \"created_at\": \"2026-09-09T20:25:25.000000Z\", \"updated_at\": \"2026-09-09T20:57:39.000000Z\", \"producto_id\": 3, \"precio_final\": \"350.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}, {\"id\": 14, \"total\": \"390.00\", \"precio\": \"390.00\", \"status\": 1, \"cantidad\": 1, \"venta_id\": 13, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"390.00\", \"created_at\": \"2026-09-09T20:58:31.000000Z\", \"updated_at\": \"2026-09-09T20:58:31.000000Z\", \"producto_id\": 4, \"precio_final\": \"390.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"tipo_documento_id\": 2, \"porcentaje_descuento\": 0}', 'VENTAS', '2026-09-10', '10:48:00', '2026-09-10 14:48:00', '2026-09-10 14:48:00');
INSERT INTO `historial_accions` (`id`, `user_id`, `accion`, `descripcion`, `datos_original`, `datos_nuevo`, `modulo`, `fecha`, `hora`, `created_at`, `updated_at`) VALUES
(53, 1, 'ELIMINACIÓN', 'EL USUARIO admin ELIMINÓ UNA PROFORMA', '{\"id\": 1, \"hora\": \"15:50:36\", \"fecha\": \"2026-09-09\", \"saldo\": \"0.00\", \"total\": \"18800.00\", \"nit_ci\": \"123456\", \"status\": 1, \"user_id\": 1, \"subtotal\": \"18800.00\", \"cancelado\": \"18800.00\", \"descuento\": \"0.00\", \"almacen_id\": 1, \"cliente_id\": 2, \"created_at\": \"2026-09-09T19:50:36.000000Z\", \"updated_at\": \"2026-09-09T19:50:36.000000Z\", \"sucursal_id\": 1, \"fecha_registro\": \"2026-09-09\", \"codigo_proforma\": \"P1\", \"proforma_detalles\": [], \"tipo_documento_id\": 1, \"porcentaje_descuento\": 0}', '{\"id\": 1, \"hora\": \"15:50:36\", \"fecha\": \"2026-09-09\", \"saldo\": \"0.00\", \"total\": \"18800.00\", \"nit_ci\": \"123456\", \"status\": 1, \"user_id\": 1, \"subtotal\": \"18800.00\", \"cancelado\": \"18800.00\", \"descuento\": \"0.00\", \"almacen_id\": 1, \"cliente_id\": 2, \"created_at\": \"2026-09-09T19:50:36.000000Z\", \"updated_at\": \"2026-09-09T19:50:36.000000Z\", \"sucursal_id\": 1, \"fecha_registro\": \"2026-09-09\", \"codigo_proforma\": \"P1\", \"proforma_detalles\": [{\"id\": 1, \"total\": \"4000.00\", \"precio\": \"200.00\", \"cantidad\": 20, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"4000.00\", \"created_at\": \"2026-09-09T19:50:36.000000Z\", \"updated_at\": \"2026-09-09T19:50:36.000000Z\", \"producto_id\": 2, \"proforma_id\": 1, \"precio_final\": \"200.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}, {\"id\": 2, \"total\": \"7000.00\", \"precio\": \"350.00\", \"cantidad\": 20, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"7000.00\", \"created_at\": \"2026-09-09T19:50:36.000000Z\", \"updated_at\": \"2026-09-09T19:50:36.000000Z\", \"producto_id\": 3, \"proforma_id\": 1, \"precio_final\": \"350.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}, {\"id\": 3, \"total\": \"7800.00\", \"precio\": \"390.00\", \"cantidad\": 20, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"7800.00\", \"created_at\": \"2026-09-09T19:50:36.000000Z\", \"updated_at\": \"2026-09-09T19:50:36.000000Z\", \"producto_id\": 4, \"proforma_id\": 1, \"precio_final\": \"390.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"tipo_documento_id\": 1, \"porcentaje_descuento\": 0}', 'PROFORMAS', '2026-09-10', '10:50:45', '2026-09-10 14:50:45', '2026-09-10 14:50:45'),
(54, 1, 'ELIMINACIÓN', 'EL USUARIO admin RESTAURÓ UNA VENTA', '{\"id\": 13, \"hora\": \"16:25:25\", \"fecha\": \"2026-09-09\", \"saldo\": \"0.00\", \"total\": \"1090.00\", \"nit_ci\": \"43344343\", \"status\": 0, \"user_id\": 1, \"subtotal\": \"1090.00\", \"cancelado\": \"1090.00\", \"descuento\": \"0.00\", \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 8, \"created_at\": \"2026-09-09T20:25:25.000000Z\", \"tipo_venta\": \"AL CONTADO\", \"updated_at\": \"2026-09-10T14:48:00.000000Z\", \"sucursal_id\": 1, \"codigo_venta\": \"V13\", \"fecha_registro\": \"2026-09-09\", \"venta_detalles\": [], \"tipo_documento_id\": 2, \"porcentaje_descuento\": 0}', '{\"id\": 13, \"hora\": \"16:25:25\", \"fecha\": \"2026-09-09\", \"saldo\": \"0.00\", \"total\": \"1090.00\", \"nit_ci\": \"43344343\", \"status\": 1, \"user_id\": 1, \"subtotal\": \"1090.00\", \"cancelado\": \"1090.00\", \"descuento\": \"0.00\", \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 8, \"created_at\": \"2026-09-09T20:25:25.000000Z\", \"tipo_venta\": \"AL CONTADO\", \"updated_at\": \"2026-09-10T15:09:11.000000Z\", \"sucursal_id\": 1, \"codigo_venta\": \"V13\", \"fecha_registro\": \"2026-09-09\", \"venta_detalles\": [], \"tipo_documento_id\": 2, \"porcentaje_descuento\": 0}', 'VENTAS', '2026-09-10', '11:09:11', '2026-09-10 15:09:11', '2026-09-10 15:09:11'),
(55, 1, 'ELIMINACIÓN', 'EL USUARIO admin ELIMINÓ UNA VENTA', '{\"id\": 13, \"hora\": \"16:25:25\", \"fecha\": \"2026-09-09\", \"saldo\": \"0.00\", \"total\": \"1090.00\", \"nit_ci\": \"43344343\", \"status\": 1, \"user_id\": 1, \"subtotal\": \"1090.00\", \"cancelado\": \"1090.00\", \"descuento\": \"0.00\", \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 8, \"created_at\": \"2026-09-09T20:25:25.000000Z\", \"tipo_venta\": \"AL CONTADO\", \"updated_at\": \"2026-09-10T15:09:11.000000Z\", \"sucursal_id\": 1, \"codigo_venta\": \"V13\", \"fecha_registro\": \"2026-09-09\", \"venta_detalles\": [], \"tipo_documento_id\": 2, \"porcentaje_descuento\": 0}', '{\"id\": 13, \"hora\": \"16:25:25\", \"fecha\": \"2026-09-09\", \"saldo\": \"0.00\", \"total\": \"1090.00\", \"nit_ci\": \"43344343\", \"status\": 0, \"user_id\": 1, \"subtotal\": \"1090.00\", \"cancelado\": \"1090.00\", \"descuento\": \"0.00\", \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 8, \"created_at\": \"2026-09-09T20:25:25.000000Z\", \"tipo_venta\": \"AL CONTADO\", \"updated_at\": \"2026-09-10T15:09:32.000000Z\", \"sucursal_id\": 1, \"codigo_venta\": \"V13\", \"fecha_registro\": \"2026-09-09\", \"venta_detalles\": [], \"tipo_documento_id\": 2, \"porcentaje_descuento\": 0}', 'VENTAS', '2026-09-10', '11:09:32', '2026-09-10 15:09:32', '2026-09-10 15:09:32'),
(56, 1, 'ELIMINACIÓN', 'EL USUARIO admin ELIMINÓ PERMANENTEMENTE UNA VENTA', '{\"id\": 13, \"hora\": \"16:25:25\", \"fecha\": \"2026-09-09\", \"saldo\": \"0.00\", \"total\": \"1090.00\", \"nit_ci\": \"43344343\", \"status\": 0, \"user_id\": 1, \"subtotal\": \"1090.00\", \"cancelado\": \"1090.00\", \"descuento\": \"0.00\", \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 8, \"created_at\": \"2026-09-09T20:25:25.000000Z\", \"tipo_venta\": \"AL CONTADO\", \"updated_at\": \"2026-09-10T15:09:32.000000Z\", \"sucursal_id\": 1, \"codigo_venta\": \"V13\", \"fecha_registro\": \"2026-09-09\", \"venta_detalles\": [], \"tipo_documento_id\": 2, \"porcentaje_descuento\": 0}', NULL, 'VENTAS', '2026-09-10', '11:14:42', '2026-09-10 15:14:42', '2026-09-10 15:14:42'),
(57, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 2, \"hora\": \"10:25:07\", \"fecha\": \"2026-09-09\", \"monto\": \"700.00\", \"saldo\": \"0.00\", \"user_id\": 1, \"venta_id\": 10, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 3, \"created_at\": \"2026-09-09T14:25:07.000000Z\", \"updated_at\": \"2026-09-09T14:25:07.000000Z\", \"sucursal_id\": 1}', '{\"id\": 2, \"hora\": \"11:36:42\", \"fecha\": \"2026-09-10\", \"monto\": \"600.00\", \"saldo\": 0, \"user_id\": 1, \"venta_id\": 10, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 3, \"created_at\": \"2026-09-09T14:25:07.000000Z\", \"updated_at\": \"2026-09-10T15:36:42.000000Z\", \"sucursal_id\": 1}', 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-10', '11:36:42', '2026-09-10 15:36:42', '2026-09-10 15:36:42'),
(58, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 2, \"hora\": \"11:36:42\", \"fecha\": \"2026-09-10\", \"monto\": \"600.00\", \"saldo\": \"0.00\", \"user_id\": 1, \"venta_id\": 10, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 3, \"created_at\": \"2026-09-09T14:25:07.000000Z\", \"updated_at\": \"2026-09-10T15:36:42.000000Z\", \"sucursal_id\": 1}', '{\"id\": 2, \"hora\": \"11:37:01\", \"fecha\": \"2026-09-10\", \"monto\": \"600.00\", \"saldo\": 0, \"user_id\": 1, \"venta_id\": 10, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 3, \"created_at\": \"2026-09-09T14:25:07.000000Z\", \"updated_at\": \"2026-09-10T15:37:01.000000Z\", \"sucursal_id\": 1}', 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-10', '11:37:01', '2026-09-10 15:37:01', '2026-09-10 15:37:01'),
(59, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 2, \"hora\": \"11:37:01\", \"fecha\": \"2026-09-10\", \"monto\": \"600.00\", \"saldo\": \"0.00\", \"user_id\": 1, \"venta_id\": 10, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 3, \"created_at\": \"2026-09-09T14:25:07.000000Z\", \"updated_at\": \"2026-09-10T15:37:01.000000Z\", \"sucursal_id\": 1}', '{\"id\": 2, \"hora\": \"11:39:28\", \"fecha\": \"2026-09-10\", \"monto\": \"600.00\", \"saldo\": 0, \"user_id\": 1, \"venta_id\": 10, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 3, \"created_at\": \"2026-09-09T14:25:07.000000Z\", \"updated_at\": \"2026-09-10T15:39:28.000000Z\", \"sucursal_id\": 1}', 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-10', '11:39:28', '2026-09-10 15:39:28', '2026-09-10 15:39:28'),
(60, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 2, \"hora\": \"11:39:28\", \"fecha\": \"2026-09-10\", \"monto\": \"600.00\", \"saldo\": \"0.00\", \"user_id\": 1, \"venta_id\": 10, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 3, \"created_at\": \"2026-09-09T14:25:07.000000Z\", \"updated_at\": \"2026-09-10T15:39:28.000000Z\", \"sucursal_id\": 1}', '{\"id\": 2, \"hora\": \"11:42:53\", \"fecha\": \"2026-09-10\", \"monto\": \"600.00\", \"saldo\": 0, \"user_id\": 1, \"venta_id\": 10, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 3, \"created_at\": \"2026-09-09T14:25:07.000000Z\", \"updated_at\": \"2026-09-10T15:42:53.000000Z\", \"sucursal_id\": 1}', 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-10', '11:42:53', '2026-09-10 15:42:53', '2026-09-10 15:42:53'),
(61, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 2, \"hora\": \"11:42:53\", \"fecha\": \"2026-09-10\", \"monto\": \"600.00\", \"saldo\": \"0.00\", \"user_id\": 1, \"venta_id\": 10, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 3, \"created_at\": \"2026-09-09T14:25:07.000000Z\", \"updated_at\": \"2026-09-10T15:42:53.000000Z\", \"sucursal_id\": 1}', '{\"id\": 2, \"hora\": \"11:43:34\", \"fecha\": \"2026-09-10\", \"monto\": \"600.00\", \"saldo\": 0, \"user_id\": 1, \"venta_id\": 10, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 3, \"created_at\": \"2026-09-09T14:25:07.000000Z\", \"updated_at\": \"2026-09-10T15:43:34.000000Z\", \"sucursal_id\": 1}', 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-10', '11:43:34', '2026-09-10 15:43:34', '2026-09-10 15:43:34'),
(62, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 2, \"hora\": \"11:43:34\", \"fecha\": \"2026-09-10\", \"monto\": \"600.00\", \"saldo\": \"0.00\", \"user_id\": 1, \"venta_id\": 10, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 3, \"created_at\": \"2026-09-09T14:25:07.000000Z\", \"updated_at\": \"2026-09-10T15:43:34.000000Z\", \"sucursal_id\": 1}', '{\"id\": 2, \"hora\": \"11:44:22\", \"fecha\": \"2026-09-10\", \"monto\": \"600.00\", \"saldo\": 0, \"user_id\": 1, \"venta_id\": 10, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 3, \"created_at\": \"2026-09-09T14:25:07.000000Z\", \"updated_at\": \"2026-09-10T15:44:22.000000Z\", \"sucursal_id\": 1}', 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-10', '11:44:22', '2026-09-10 15:44:22', '2026-09-10 15:44:22'),
(63, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 2, \"hora\": \"11:44:22\", \"fecha\": \"2026-09-10\", \"monto\": \"600.00\", \"saldo\": \"0.00\", \"user_id\": 1, \"venta_id\": 10, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 3, \"created_at\": \"2026-09-09T14:25:07.000000Z\", \"updated_at\": \"2026-09-10T15:44:22.000000Z\", \"sucursal_id\": 1}', '{\"id\": 2, \"hora\": \"11:44:59\", \"fecha\": \"2026-09-10\", \"monto\": \"600.00\", \"saldo\": 0, \"user_id\": 1, \"venta_id\": 10, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 3, \"created_at\": \"2026-09-09T14:25:07.000000Z\", \"updated_at\": \"2026-09-10T15:44:59.000000Z\", \"sucursal_id\": 1}', 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-10', '11:44:59', '2026-09-10 15:44:59', '2026-09-10 15:44:59'),
(64, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 2, \"hora\": \"11:44:59\", \"fecha\": \"2026-09-10\", \"monto\": \"600.00\", \"saldo\": \"0.00\", \"user_id\": 1, \"venta_id\": 10, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 3, \"created_at\": \"2026-09-09T14:25:07.000000Z\", \"updated_at\": \"2026-09-10T15:44:59.000000Z\", \"sucursal_id\": 1}', '{\"id\": 2, \"hora\": \"11:45:09\", \"fecha\": \"2026-09-10\", \"monto\": \"700.00\", \"saldo\": 0, \"user_id\": 1, \"venta_id\": 10, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 3, \"created_at\": \"2026-09-09T14:25:07.000000Z\", \"updated_at\": \"2026-09-10T15:45:09.000000Z\", \"sucursal_id\": 1}', 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-10', '11:45:09', '2026-09-10 15:45:09', '2026-09-10 15:45:09'),
(65, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 2, \"hora\": \"11:45:09\", \"fecha\": \"2026-09-10\", \"monto\": \"700.00\", \"saldo\": \"0.00\", \"user_id\": 1, \"venta_id\": 10, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 3, \"created_at\": \"2026-09-09T14:25:07.000000Z\", \"updated_at\": \"2026-09-10T15:45:09.000000Z\", \"sucursal_id\": 1}', '{\"id\": 2, \"hora\": \"11:45:32\", \"fecha\": \"2026-09-10\", \"monto\": \"700.00\", \"saldo\": 0, \"user_id\": 1, \"venta_id\": 10, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 3, \"created_at\": \"2026-09-09T14:25:07.000000Z\", \"updated_at\": \"2026-09-10T15:45:32.000000Z\", \"sucursal_id\": 1}', 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-10', '11:45:32', '2026-09-10 15:45:32', '2026-09-10 15:45:32'),
(66, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 3, \"hora\": \"12:30:17\", \"fecha\": \"2026-09-07\", \"monto\": \"500.00\", \"user_id\": 1, \"almacen_id\": 1, \"created_at\": \"2026-09-07T16:30:17.000000Z\", \"updated_at\": \"2026-09-07T16:30:17.000000Z\", \"sucursal_id\": 1, \"proveedor_id\": 1, \"ingreso_producto_id\": 3}', '{\"id\": 3, \"hora\": \"12:30:17\", \"fecha\": \"2026-09-07\", \"monto\": \"580.00\", \"user_id\": 1, \"almacen_id\": 1, \"created_at\": \"2026-09-07T16:30:17.000000Z\", \"updated_at\": \"2026-09-10T16:03:37.000000Z\", \"sucursal_id\": 1, \"proveedor_id\": 1, \"ingreso_producto_id\": 3}', 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-10', '12:03:37', '2026-09-10 16:03:37', '2026-09-10 16:03:37'),
(67, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 3, \"hora\": \"12:30:17\", \"fecha\": \"2026-09-07\", \"monto\": \"580.00\", \"user_id\": 1, \"almacen_id\": 1, \"created_at\": \"2026-09-07T16:30:17.000000Z\", \"updated_at\": \"2026-09-10T16:03:37.000000Z\", \"sucursal_id\": 1, \"proveedor_id\": 1, \"ingreso_producto_id\": 3}', '{\"id\": 3, \"hora\": \"12:30:17\", \"fecha\": \"2026-09-07\", \"monto\": \"380.00\", \"user_id\": 1, \"almacen_id\": 1, \"created_at\": \"2026-09-07T16:30:17.000000Z\", \"updated_at\": \"2026-09-10T16:04:24.000000Z\", \"sucursal_id\": 1, \"proveedor_id\": 1, \"ingreso_producto_id\": 3}', 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-10', '12:04:24', '2026-09-10 16:04:24', '2026-09-10 16:04:24'),
(68, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 3, \"hora\": \"12:30:17\", \"fecha\": \"2026-09-07\", \"monto\": \"380.00\", \"user_id\": 1, \"almacen_id\": 1, \"created_at\": \"2026-09-07T16:30:17.000000Z\", \"updated_at\": \"2026-09-10T16:04:24.000000Z\", \"sucursal_id\": 1, \"proveedor_id\": 1, \"ingreso_producto_id\": 3}', '{\"id\": 3, \"hora\": \"12:30:17\", \"fecha\": \"2026-09-07\", \"monto\": \"480.00\", \"user_id\": 1, \"almacen_id\": 1, \"created_at\": \"2026-09-07T16:30:17.000000Z\", \"updated_at\": \"2026-09-10T16:05:55.000000Z\", \"sucursal_id\": 1, \"proveedor_id\": 1, \"ingreso_producto_id\": 3}', 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-10', '12:05:55', '2026-09-10 16:05:55', '2026-09-10 16:05:55'),
(69, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 3, \"hora\": \"12:30:17\", \"fecha\": \"2026-09-07\", \"monto\": \"480.00\", \"user_id\": 1, \"almacen_id\": 1, \"created_at\": \"2026-09-07T16:30:17.000000Z\", \"updated_at\": \"2026-09-10T16:05:55.000000Z\", \"sucursal_id\": 1, \"proveedor_id\": 1, \"ingreso_producto_id\": 3}', '{\"id\": 3, \"hora\": \"12:30:17\", \"fecha\": \"2026-09-07\", \"monto\": \"380.00\", \"user_id\": 1, \"almacen_id\": 1, \"created_at\": \"2026-09-07T16:30:17.000000Z\", \"updated_at\": \"2026-09-10T16:06:58.000000Z\", \"sucursal_id\": 1, \"proveedor_id\": 1, \"ingreso_producto_id\": 3}', 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-10', '12:06:58', '2026-09-10 16:06:58', '2026-09-10 16:06:58'),
(70, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN EGRESO DE BS. 200 EN LA SUCURSAL SUCURSAL CENTRAL; almacén ALMACEN CENTRAL', '{\"id\": 11, \"hora\": \"12:07:07\", \"tipo\": \"PAGO POR COMPRA DE PRODUCTOS\", \"fecha\": \"2026-09-10\", \"monto\": \"200\", \"modulo\": \"IngresoPago\", \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-10T16:07:07.000000Z\", \"updated_at\": \"2026-09-10T16:07:07.000000Z\", \"descripcion\": \"PAGO POR COMPRA DE PRODUCTOS\", \"registro_id\": 4, \"sucursal_id\": 1, \"tipo_movimiento\": \"EGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-10', '12:07:07', '2026-09-10 16:07:07', '2026-09-10 16:07:07'),
(71, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 4, \"hora\": \"12:07:07\", \"fecha\": \"2026-09-10\", \"monto\": \"200\", \"user_id\": 1, \"almacen_id\": 1, \"created_at\": \"2026-09-10T16:07:07.000000Z\", \"updated_at\": \"2026-09-10T16:07:07.000000Z\", \"sucursal_id\": 1, \"proveedor_id\": 1, \"ingreso_producto_id\": 3}', NULL, 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-10', '12:07:07', '2026-09-10 16:07:07', '2026-09-10 16:07:07'),
(72, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 4, \"hora\": \"12:07:07\", \"fecha\": \"2026-09-10\", \"monto\": \"200.00\", \"user_id\": 1, \"almacen_id\": 1, \"created_at\": \"2026-09-10T16:07:07.000000Z\", \"updated_at\": \"2026-09-10T16:07:07.000000Z\", \"sucursal_id\": 1, \"proveedor_id\": 1, \"ingreso_producto_id\": 3}', '{\"id\": 4, \"hora\": \"12:07:07\", \"fecha\": \"2026-09-10\", \"monto\": \"100.00\", \"user_id\": 1, \"almacen_id\": 1, \"created_at\": \"2026-09-10T16:07:07.000000Z\", \"updated_at\": \"2026-09-10T16:09:00.000000Z\", \"sucursal_id\": 1, \"proveedor_id\": 1, \"ingreso_producto_id\": 3}', 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-10', '12:09:01', '2026-09-10 16:09:01', '2026-09-10 16:09:01'),
(73, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN EGRESO DE BS. 10 EN LA SUCURSAL SUCURSAL CENTRAL; almacén ALMACEN CENTRAL', '{\"id\": 12, \"hora\": \"12:09:08\", \"tipo\": \"PAGO POR COMPRA DE PRODUCTOS\", \"fecha\": \"2026-09-10\", \"monto\": \"10\", \"modulo\": \"IngresoPago\", \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-10T16:09:08.000000Z\", \"updated_at\": \"2026-09-10T16:09:08.000000Z\", \"descripcion\": \"PAGO POR COMPRA DE PRODUCTOS\", \"registro_id\": 5, \"sucursal_id\": 1, \"tipo_movimiento\": \"EGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-10', '12:09:08', '2026-09-10 16:09:08', '2026-09-10 16:09:08'),
(74, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 5, \"hora\": \"12:09:08\", \"fecha\": \"2026-09-10\", \"monto\": \"10\", \"user_id\": 1, \"almacen_id\": 1, \"created_at\": \"2026-09-10T16:09:08.000000Z\", \"updated_at\": \"2026-09-10T16:09:08.000000Z\", \"sucursal_id\": 1, \"proveedor_id\": 1, \"ingreso_producto_id\": 3}', NULL, 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-10', '12:09:08', '2026-09-10 16:09:08', '2026-09-10 16:09:08'),
(75, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 5, \"hora\": \"12:09:08\", \"fecha\": \"2026-09-10\", \"monto\": \"10.00\", \"user_id\": 1, \"almacen_id\": 1, \"created_at\": \"2026-09-10T16:09:08.000000Z\", \"updated_at\": \"2026-09-10T16:09:08.000000Z\", \"sucursal_id\": 1, \"proveedor_id\": 1, \"ingreso_producto_id\": 3}', '{\"id\": 5, \"hora\": \"12:09:08\", \"fecha\": \"2026-09-10\", \"monto\": \"100.00\", \"user_id\": 1, \"almacen_id\": 1, \"created_at\": \"2026-09-10T16:09:08.000000Z\", \"updated_at\": \"2026-09-10T16:10:57.000000Z\", \"sucursal_id\": 1, \"proveedor_id\": 1, \"ingreso_producto_id\": 3}', 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-10', '12:10:57', '2026-09-10 16:10:57', '2026-09-10 16:10:57'),
(76, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN EGRESO DE BS. 10 EN LA SUCURSAL SUCURSAL CENTRAL; almacén ALMACEN CENTRAL', '{\"id\": 13, \"hora\": \"12:11:06\", \"tipo\": \"PAGO POR COMPRA DE PRODUCTOS\", \"fecha\": \"2026-09-10\", \"monto\": \"10\", \"modulo\": \"IngresoPago\", \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-10T16:11:06.000000Z\", \"updated_at\": \"2026-09-10T16:11:06.000000Z\", \"descripcion\": \"PAGO POR COMPRA DE PRODUCTOS\", \"registro_id\": 6, \"sucursal_id\": 1, \"tipo_movimiento\": \"EGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-10', '12:11:06', '2026-09-10 16:11:06', '2026-09-10 16:11:06'),
(77, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 6, \"hora\": \"12:11:06\", \"fecha\": \"2026-09-10\", \"monto\": \"10\", \"user_id\": 1, \"almacen_id\": 1, \"created_at\": \"2026-09-10T16:11:06.000000Z\", \"updated_at\": \"2026-09-10T16:11:06.000000Z\", \"sucursal_id\": 1, \"proveedor_id\": 1, \"ingreso_producto_id\": 3}', NULL, 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-10', '12:11:06', '2026-09-10 16:11:06', '2026-09-10 16:11:06'),
(78, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN EGRESO DE BS. 10 EN LA SUCURSAL SUCURSAL CENTRAL; almacén ALMACEN CENTRAL', '{\"id\": 14, \"hora\": \"12:11:13\", \"tipo\": \"PAGO POR COMPRA DE PRODUCTOS\", \"fecha\": \"2026-09-10\", \"monto\": \"10\", \"modulo\": \"IngresoPago\", \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-10T16:11:13.000000Z\", \"updated_at\": \"2026-09-10T16:11:13.000000Z\", \"descripcion\": \"PAGO POR COMPRA DE PRODUCTOS\", \"registro_id\": 7, \"sucursal_id\": 1, \"tipo_movimiento\": \"EGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-10', '12:11:13', '2026-09-10 16:11:13', '2026-09-10 16:11:13'),
(79, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 7, \"hora\": \"12:11:13\", \"fecha\": \"2026-09-10\", \"monto\": \"10\", \"user_id\": 1, \"almacen_id\": 1, \"created_at\": \"2026-09-10T16:11:13.000000Z\", \"updated_at\": \"2026-09-10T16:11:13.000000Z\", \"sucursal_id\": 1, \"proveedor_id\": 1, \"ingreso_producto_id\": 3}', NULL, 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-10', '12:11:13', '2026-09-10 16:11:13', '2026-09-10 16:11:13'),
(80, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN EGRESO DE BS. 10 EN LA SUCURSAL SUCURSAL CENTRAL; almacén ALMACEN CENTRAL', '{\"id\": 15, \"hora\": \"12:11:43\", \"tipo\": \"PAGO POR COMPRA DE PRODUCTOS\", \"fecha\": \"2026-09-10\", \"monto\": \"10\", \"modulo\": \"IngresoPago\", \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-10T16:11:43.000000Z\", \"updated_at\": \"2026-09-10T16:11:43.000000Z\", \"descripcion\": \"PAGO POR COMPRA DE PRODUCTOS\", \"registro_id\": 8, \"sucursal_id\": 1, \"tipo_movimiento\": \"EGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-10', '12:11:43', '2026-09-10 16:11:43', '2026-09-10 16:11:43'),
(81, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 8, \"hora\": \"12:11:43\", \"fecha\": \"2026-09-10\", \"monto\": \"10\", \"user_id\": 1, \"almacen_id\": 1, \"created_at\": \"2026-09-10T16:11:43.000000Z\", \"updated_at\": \"2026-09-10T16:11:43.000000Z\", \"sucursal_id\": 1, \"proveedor_id\": 1, \"ingreso_producto_id\": 3}', NULL, 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-10', '12:11:43', '2026-09-10 16:11:43', '2026-09-10 16:11:43'),
(82, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 8, \"hora\": \"12:11:43\", \"fecha\": \"2026-09-10\", \"monto\": \"10.00\", \"user_id\": 1, \"almacen_id\": 1, \"created_at\": \"2026-09-10T16:11:43.000000Z\", \"updated_at\": \"2026-09-10T16:11:43.000000Z\", \"sucursal_id\": 1, \"proveedor_id\": 1, \"ingreso_producto_id\": 3}', '{\"id\": 8, \"hora\": \"12:11:43\", \"fecha\": \"2026-09-10\", \"monto\": \"100.00\", \"user_id\": 1, \"almacen_id\": 1, \"created_at\": \"2026-09-10T16:11:43.000000Z\", \"updated_at\": \"2026-09-10T16:12:52.000000Z\", \"sucursal_id\": 1, \"proveedor_id\": 1, \"ingreso_producto_id\": 3}', 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-10', '12:12:52', '2026-09-10 16:12:52', '2026-09-10 16:12:52'),
(83, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN EGRESO DE BS. 10 EN LA SUCURSAL SUCURSAL CENTRAL; almacén ALMACEN CENTRAL', '{\"id\": 16, \"hora\": \"12:13:03\", \"tipo\": \"PAGO POR COMPRA DE PRODUCTOS\", \"fecha\": \"2026-09-10\", \"monto\": \"10\", \"modulo\": \"IngresoPago\", \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-10T16:13:03.000000Z\", \"updated_at\": \"2026-09-10T16:13:03.000000Z\", \"descripcion\": \"PAGO POR COMPRA DE PRODUCTOS\", \"registro_id\": 9, \"sucursal_id\": 1, \"tipo_movimiento\": \"EGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-10', '12:13:03', '2026-09-10 16:13:03', '2026-09-10 16:13:03'),
(84, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 9, \"hora\": \"12:13:03\", \"fecha\": \"2026-09-10\", \"monto\": \"10\", \"user_id\": 1, \"almacen_id\": 1, \"created_at\": \"2026-09-10T16:13:03.000000Z\", \"updated_at\": \"2026-09-10T16:13:03.000000Z\", \"sucursal_id\": 1, \"proveedor_id\": 1, \"ingreso_producto_id\": 3}', NULL, 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-10', '12:13:03', '2026-09-10 16:13:03', '2026-09-10 16:13:03'),
(85, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN EGRESO DE BS. 10 EN LA SUCURSAL SUCURSAL CENTRAL; almacén ALMACEN CENTRAL', '{\"id\": 17, \"hora\": \"12:14:02\", \"tipo\": \"PAGO POR COMPRA DE PRODUCTOS\", \"fecha\": \"2026-09-10\", \"monto\": \"10\", \"modulo\": \"IngresoPago\", \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-10T16:14:02.000000Z\", \"updated_at\": \"2026-09-10T16:14:02.000000Z\", \"descripcion\": \"PAGO POR COMPRA DE PRODUCTOS\", \"registro_id\": 10, \"sucursal_id\": 1, \"tipo_movimiento\": \"EGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-10', '12:14:02', '2026-09-10 16:14:02', '2026-09-10 16:14:02'),
(86, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 10, \"hora\": \"12:14:02\", \"fecha\": \"2026-09-10\", \"monto\": \"10\", \"user_id\": 1, \"almacen_id\": 1, \"created_at\": \"2026-09-10T16:14:02.000000Z\", \"updated_at\": \"2026-09-10T16:14:02.000000Z\", \"sucursal_id\": 1, \"proveedor_id\": 1, \"ingreso_producto_id\": 3}', NULL, 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-10', '12:14:02', '2026-09-10 16:14:02', '2026-09-10 16:14:02'),
(87, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 10, \"hora\": \"12:14:02\", \"fecha\": \"2026-09-10\", \"monto\": \"10.00\", \"user_id\": 1, \"almacen_id\": 1, \"created_at\": \"2026-09-10T16:14:02.000000Z\", \"updated_at\": \"2026-09-10T16:14:02.000000Z\", \"sucursal_id\": 1, \"proveedor_id\": 1, \"ingreso_producto_id\": 3}', '{\"id\": 10, \"hora\": \"12:14:02\", \"fecha\": \"2026-09-10\", \"monto\": \"20.00\", \"user_id\": 1, \"almacen_id\": 1, \"created_at\": \"2026-09-10T16:14:02.000000Z\", \"updated_at\": \"2026-09-10T16:14:32.000000Z\", \"sucursal_id\": 1, \"proveedor_id\": 1, \"ingreso_producto_id\": 3}', 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-10', '12:14:32', '2026-09-10 16:14:32', '2026-09-10 16:14:32'),
(88, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 3, \"hora\": \"10:26:40\", \"fecha\": \"2026-09-09\", \"monto\": \"50.00\", \"saldo\": \"0.00\", \"user_id\": 1, \"venta_id\": 10, \"tipo_pago\": \"QR\", \"almacen_id\": 1, \"cliente_id\": 3, \"created_at\": \"2026-09-09T14:26:40.000000Z\", \"updated_at\": \"2026-09-09T14:26:40.000000Z\", \"sucursal_id\": 1}', '{\"id\": 3, \"hora\": \"12:15:59\", \"fecha\": \"2026-09-10\", \"monto\": \"70.00\", \"saldo\": 0, \"user_id\": 1, \"venta_id\": 10, \"tipo_pago\": \"QR\", \"almacen_id\": 1, \"cliente_id\": 3, \"created_at\": \"2026-09-09T14:26:40.000000Z\", \"updated_at\": \"2026-09-10T16:15:59.000000Z\", \"sucursal_id\": 1}', 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-10', '12:15:59', '2026-09-10 16:15:59', '2026-09-10 16:15:59'),
(89, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN INGRESO DE BS. 10 EN LA SUCURSAL SUCURSAL CENTRAL; almacén ALMACEN CENTRAL', '{\"id\": 18, \"hora\": \"12:16:07\", \"tipo\": \"COBRO POR VENTA DE PRODUCTOS\", \"fecha\": \"2026-09-10\", \"monto\": \"10\", \"modulo\": \"VentaCobro\", \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-10T16:16:07.000000Z\", \"updated_at\": \"2026-09-10T16:16:07.000000Z\", \"descripcion\": \"COBRO POR VENTA DE PRODUCTOS\", \"registro_id\": 5, \"sucursal_id\": 1, \"tipo_movimiento\": \"INGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-10', '12:16:07', '2026-09-10 16:16:07', '2026-09-10 16:16:07'),
(90, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 5, \"hora\": \"12:16:07\", \"fecha\": \"2026-09-10\", \"monto\": \"10\", \"saldo\": 0, \"user_id\": 1, \"venta_id\": 10, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 3, \"created_at\": \"2026-09-10T16:16:07.000000Z\", \"updated_at\": \"2026-09-10T16:16:07.000000Z\", \"sucursal_id\": 1}', NULL, 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-10', '12:16:07', '2026-09-10 16:16:07', '2026-09-10 16:16:07'),
(91, 1, 'ELIMINACIÓN', 'EL USUARIO admin ELIMINÓ UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 5, \"hora\": \"12:16:07\", \"fecha\": \"2026-09-10\", \"monto\": \"10.00\", \"saldo\": \"0.00\", \"user_id\": 1, \"venta_id\": 10, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 3, \"created_at\": \"2026-09-10T16:16:07.000000Z\", \"updated_at\": \"2026-09-10T16:16:07.000000Z\", \"sucursal_id\": 1}', NULL, 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-11', '11:09:02', '2026-09-11 15:09:02', '2026-09-11 15:09:02'),
(92, 1, 'ELIMINACIÓN', 'EL USUARIO admin ELIMINÓ UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 4, \"hora\": \"10:29:45\", \"fecha\": \"2026-09-09\", \"monto\": \"50.00\", \"saldo\": \"0.00\", \"venta\": {\"id\": 10, \"hora\": \"10:35:45\", \"fecha\": \"2026-09-07\", \"saldo\": 280, \"total\": \"1050.00\", \"nit_ci\": \"345345345\", \"status\": 1, \"user_id\": 1, \"subtotal\": \"1050.00\", \"cancelado\": \"0.00\", \"descuento\": \"0.00\", \"tipo_pago\": null, \"almacen_id\": 1, \"cliente_id\": 3, \"created_at\": \"2026-09-07T14:35:45.000000Z\", \"tipo_venta\": \"CRÉDITO\", \"updated_at\": \"2026-09-11T15:10:22.000000Z\", \"sucursal_id\": 1, \"codigo_venta\": \"V10\", \"fecha_hora_t\": \"07/09/2026 10:35:45\", \"fecha_registro\": \"2026-09-07\", \"fecha_registro_t\": \"07/09/2026\", \"tipo_documento_id\": 2, \"porcentaje_descuento\": 0}, \"user_id\": 1, \"venta_id\": 10, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 3, \"created_at\": \"2026-09-09T14:29:45.000000Z\", \"updated_at\": \"2026-09-09T14:29:45.000000Z\", \"sucursal_id\": 1}', NULL, 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-11', '11:10:22', '2026-09-11 15:10:22', '2026-09-11 15:10:22'),
(93, 1, 'ELIMINACIÓN', 'EL USUARIO admin ELIMINÓ UN MOVIMIENTO DE CAJA', '{\"id\": 7, \"hora\": \"10:26:40\", \"tipo\": \"COBRO POR VENTA DE PRODUCTOS\", \"fecha\": \"2026-09-09\", \"monto\": \"70.00\", \"modulo\": \"VentaCobro\", \"status\": 1, \"user_id\": 1, \"tipo_pago\": \"QR\", \"almacen_id\": 1, \"created_at\": \"2026-09-09T14:26:40.000000Z\", \"updated_at\": \"2026-09-10T16:15:59.000000Z\", \"descripcion\": \"COBRO POR VENTA DE PRODUCTOS\", \"registro_id\": 3, \"sucursal_id\": 1, \"tipo_movimiento\": \"INGRESO\"}', '{\"id\": 7, \"hora\": \"10:26:40\", \"tipo\": \"COBRO POR VENTA DE PRODUCTOS\", \"fecha\": \"2026-09-09\", \"monto\": \"70.00\", \"modulo\": \"VentaCobro\", \"status\": 0, \"user_id\": 1, \"tipo_pago\": \"QR\", \"almacen_id\": 1, \"created_at\": \"2026-09-09T14:26:40.000000Z\", \"updated_at\": \"2026-09-11T15:12:45.000000Z\", \"descripcion\": \"COBRO POR VENTA DE PRODUCTOS\", \"registro_id\": 3, \"sucursal_id\": 1, \"tipo_movimiento\": \"INGRESO\"}', 'MOVIMIENTO DE CAJAS', '2026-09-11', '11:12:45', '2026-09-11 15:12:45', '2026-09-11 15:12:45'),
(94, 1, 'ELIMINACIÓN', 'EL USUARIO admin ELIMINÓ UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 3, \"hora\": \"12:15:59\", \"fecha\": \"2026-09-10\", \"monto\": \"70.00\", \"saldo\": \"0.00\", \"venta\": {\"id\": 10, \"hora\": \"10:35:45\", \"fecha\": \"2026-09-07\", \"saldo\": 350, \"total\": \"1050.00\", \"nit_ci\": \"345345345\", \"status\": 1, \"user_id\": 1, \"subtotal\": \"1050.00\", \"cancelado\": \"0.00\", \"descuento\": \"0.00\", \"tipo_pago\": null, \"almacen_id\": 1, \"cliente_id\": 3, \"created_at\": \"2026-09-07T14:35:45.000000Z\", \"tipo_venta\": \"CRÉDITO\", \"updated_at\": \"2026-09-11T15:12:45.000000Z\", \"sucursal_id\": 1, \"codigo_venta\": \"V10\", \"fecha_hora_t\": \"07/09/2026 10:35:45\", \"fecha_registro\": \"2026-09-07\", \"fecha_registro_t\": \"07/09/2026\", \"tipo_documento_id\": 2, \"porcentaje_descuento\": 0}, \"user_id\": 1, \"venta_id\": 10, \"tipo_pago\": \"QR\", \"almacen_id\": 1, \"cliente_id\": 3, \"created_at\": \"2026-09-09T14:26:40.000000Z\", \"updated_at\": \"2026-09-10T16:15:59.000000Z\", \"sucursal_id\": 1}', NULL, 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-11', '11:12:45', '2026-09-11 15:12:45', '2026-09-11 15:12:45'),
(95, 1, 'ELIMINACIÓN', 'EL USUARIO admin ELIMINÓ UN MOVIMIENTO DE CAJA', '{\"id\": 6, \"hora\": \"10:25:07\", \"tipo\": \"COBRO POR VENTA DE PRODUCTOS\", \"fecha\": \"2026-09-09\", \"monto\": \"700.00\", \"modulo\": \"VentaCobro\", \"status\": 1, \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-09T14:25:07.000000Z\", \"updated_at\": \"2026-09-10T15:45:09.000000Z\", \"descripcion\": \"COBRO POR VENTA DE PRODUCTOS\", \"registro_id\": 2, \"sucursal_id\": 1, \"tipo_movimiento\": \"INGRESO\"}', '{\"id\": 6, \"hora\": \"10:25:07\", \"tipo\": \"COBRO POR VENTA DE PRODUCTOS\", \"fecha\": \"2026-09-09\", \"monto\": \"700.00\", \"modulo\": \"VentaCobro\", \"status\": 0, \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-09T14:25:07.000000Z\", \"updated_at\": \"2026-09-11T15:13:14.000000Z\", \"descripcion\": \"COBRO POR VENTA DE PRODUCTOS\", \"registro_id\": 2, \"sucursal_id\": 1, \"tipo_movimiento\": \"INGRESO\"}', 'MOVIMIENTO DE CAJAS', '2026-09-11', '11:13:14', '2026-09-11 15:13:14', '2026-09-11 15:13:14'),
(96, 1, 'ELIMINACIÓN', 'EL USUARIO admin ELIMINÓ UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 2, \"hora\": \"11:45:32\", \"fecha\": \"2026-09-10\", \"monto\": \"700.00\", \"saldo\": \"0.00\", \"venta\": {\"id\": 10, \"hora\": \"10:35:45\", \"fecha\": \"2026-09-07\", \"saldo\": 1050, \"total\": \"1050.00\", \"nit_ci\": \"345345345\", \"status\": 1, \"user_id\": 1, \"subtotal\": \"1050.00\", \"cancelado\": \"0.00\", \"descuento\": \"0.00\", \"tipo_pago\": null, \"almacen_id\": 1, \"cliente_id\": 3, \"created_at\": \"2026-09-07T14:35:45.000000Z\", \"tipo_venta\": \"CRÉDITO\", \"updated_at\": \"2026-09-11T15:13:14.000000Z\", \"sucursal_id\": 1, \"codigo_venta\": \"V10\", \"fecha_hora_t\": \"07/09/2026 10:35:45\", \"fecha_registro\": \"2026-09-07\", \"fecha_registro_t\": \"07/09/2026\", \"tipo_documento_id\": 2, \"porcentaje_descuento\": 0}, \"user_id\": 1, \"venta_id\": 10, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 3, \"created_at\": \"2026-09-09T14:25:07.000000Z\", \"updated_at\": \"2026-09-10T15:45:32.000000Z\", \"sucursal_id\": 1}', NULL, 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-11', '11:13:14', '2026-09-11 15:13:14', '2026-09-11 15:13:14'),
(97, 1, 'ELIMINACIÓN', 'EL USUARIO admin ELIMINÓ UN MOVIMIENTO DE CAJA', '{\"id\": 17, \"hora\": \"12:14:02\", \"tipo\": \"PAGO POR COMPRA DE PRODUCTOS\", \"fecha\": \"2026-09-10\", \"monto\": \"20.00\", \"modulo\": \"IngresoPago\", \"status\": 1, \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-10T16:14:02.000000Z\", \"updated_at\": \"2026-09-10T16:14:32.000000Z\", \"descripcion\": \"PAGO POR COMPRA DE PRODUCTOS\", \"registro_id\": 10, \"sucursal_id\": 1, \"tipo_movimiento\": \"EGRESO\"}', '{\"id\": 17, \"hora\": \"12:14:02\", \"tipo\": \"PAGO POR COMPRA DE PRODUCTOS\", \"fecha\": \"2026-09-10\", \"monto\": \"20.00\", \"modulo\": \"IngresoPago\", \"status\": 0, \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-10T16:14:02.000000Z\", \"updated_at\": \"2026-09-11T15:25:17.000000Z\", \"descripcion\": \"PAGO POR COMPRA DE PRODUCTOS\", \"registro_id\": 10, \"sucursal_id\": 1, \"tipo_movimiento\": \"EGRESO\"}', 'MOVIMIENTO DE CAJAS', '2026-09-11', '11:25:17', '2026-09-11 15:25:17', '2026-09-11 15:25:17'),
(98, 1, 'ELIMINACIÓN', 'EL USUARIO admin ELIMINÓ UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 10, \"hora\": \"12:14:02\", \"fecha\": \"2026-09-10\", \"monto\": \"20.00\", \"user_id\": 1, \"almacen_id\": 1, \"created_at\": \"2026-09-10T16:14:02.000000Z\", \"updated_at\": \"2026-09-10T16:14:32.000000Z\", \"sucursal_id\": 1, \"proveedor_id\": 1, \"ingreso_producto\": {\"id\": 3, \"saldo\": 370, \"total\": \"1080.00\", \"codigo\": \"L-00003\", \"status\": 1, \"user_id\": 1, \"cancelado\": \"0.00\", \"almacen_id\": 1, \"created_at\": \"2026-08-25T01:33:33.000000Z\", \"updated_at\": \"2026-09-11T15:25:17.000000Z\", \"descripcion\": \"\", \"sucursal_id\": 1, \"tipo_compra\": \"CRÉDITO\", \"proveedor_id\": 1, \"estado_ingreso\": \"VERIFICADO\", \"fecha_registro\": \"2026-08-24\", \"tipo_ingreso_id\": 1, \"estado_faltantes\": null, \"fecha_registro_t\": \"24/08/2026\"}, \"ingreso_producto_id\": 3}', NULL, 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-11', '11:25:17', '2026-09-11 15:25:17', '2026-09-11 15:25:17'),
(99, 1, 'ELIMINACIÓN', 'EL USUARIO admin ELIMINÓ UN MOVIMIENTO DE CAJA', '{\"id\": 16, \"hora\": \"12:13:03\", \"tipo\": \"PAGO POR COMPRA DE PRODUCTOS\", \"fecha\": \"2026-09-10\", \"monto\": \"10.00\", \"modulo\": \"IngresoPago\", \"status\": 1, \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-10T16:13:03.000000Z\", \"updated_at\": \"2026-09-10T16:13:03.000000Z\", \"descripcion\": \"PAGO POR COMPRA DE PRODUCTOS\", \"registro_id\": 9, \"sucursal_id\": 1, \"tipo_movimiento\": \"EGRESO\"}', '{\"id\": 16, \"hora\": \"12:13:03\", \"tipo\": \"PAGO POR COMPRA DE PRODUCTOS\", \"fecha\": \"2026-09-10\", \"monto\": \"10.00\", \"modulo\": \"IngresoPago\", \"status\": 0, \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-10T16:13:03.000000Z\", \"updated_at\": \"2026-09-11T15:25:26.000000Z\", \"descripcion\": \"PAGO POR COMPRA DE PRODUCTOS\", \"registro_id\": 9, \"sucursal_id\": 1, \"tipo_movimiento\": \"EGRESO\"}', 'MOVIMIENTO DE CAJAS', '2026-09-11', '11:25:26', '2026-09-11 15:25:26', '2026-09-11 15:25:26'),
(100, 1, 'ELIMINACIÓN', 'EL USUARIO admin ELIMINÓ UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 9, \"hora\": \"12:13:03\", \"fecha\": \"2026-09-10\", \"monto\": \"10.00\", \"user_id\": 1, \"almacen_id\": 1, \"created_at\": \"2026-09-10T16:13:03.000000Z\", \"updated_at\": \"2026-09-10T16:13:03.000000Z\", \"sucursal_id\": 1, \"proveedor_id\": 1, \"ingreso_producto\": {\"id\": 3, \"saldo\": 380, \"total\": \"1080.00\", \"codigo\": \"L-00003\", \"status\": 1, \"user_id\": 1, \"cancelado\": \"0.00\", \"almacen_id\": 1, \"created_at\": \"2026-08-25T01:33:33.000000Z\", \"updated_at\": \"2026-09-11T15:25:26.000000Z\", \"descripcion\": \"\", \"sucursal_id\": 1, \"tipo_compra\": \"CRÉDITO\", \"proveedor_id\": 1, \"estado_ingreso\": \"VERIFICADO\", \"fecha_registro\": \"2026-08-24\", \"tipo_ingreso_id\": 1, \"estado_faltantes\": null, \"fecha_registro_t\": \"24/08/2026\"}, \"ingreso_producto_id\": 3}', NULL, 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-11', '11:25:26', '2026-09-11 15:25:26', '2026-09-11 15:25:26'),
(101, 1, 'ELIMINACIÓN', 'EL USUARIO admin ELIMINÓ UN MOVIMIENTO DE CAJA', '{\"id\": 15, \"hora\": \"12:11:43\", \"tipo\": \"PAGO POR COMPRA DE PRODUCTOS\", \"fecha\": \"2026-09-10\", \"monto\": \"100.00\", \"modulo\": \"IngresoPago\", \"status\": 1, \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-10T16:11:43.000000Z\", \"updated_at\": \"2026-09-10T16:12:52.000000Z\", \"descripcion\": \"PAGO POR COMPRA DE PRODUCTOS\", \"registro_id\": 8, \"sucursal_id\": 1, \"tipo_movimiento\": \"EGRESO\"}', '{\"id\": 15, \"hora\": \"12:11:43\", \"tipo\": \"PAGO POR COMPRA DE PRODUCTOS\", \"fecha\": \"2026-09-10\", \"monto\": \"100.00\", \"modulo\": \"IngresoPago\", \"status\": 0, \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-10T16:11:43.000000Z\", \"updated_at\": \"2026-09-11T15:25:33.000000Z\", \"descripcion\": \"PAGO POR COMPRA DE PRODUCTOS\", \"registro_id\": 8, \"sucursal_id\": 1, \"tipo_movimiento\": \"EGRESO\"}', 'MOVIMIENTO DE CAJAS', '2026-09-11', '11:25:33', '2026-09-11 15:25:33', '2026-09-11 15:25:33'),
(102, 1, 'ELIMINACIÓN', 'EL USUARIO admin ELIMINÓ UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 8, \"hora\": \"12:11:43\", \"fecha\": \"2026-09-10\", \"monto\": \"100.00\", \"user_id\": 1, \"almacen_id\": 1, \"created_at\": \"2026-09-10T16:11:43.000000Z\", \"updated_at\": \"2026-09-10T16:12:52.000000Z\", \"sucursal_id\": 1, \"proveedor_id\": 1, \"ingreso_producto\": {\"id\": 3, \"saldo\": 480, \"total\": \"1080.00\", \"codigo\": \"L-00003\", \"status\": 1, \"user_id\": 1, \"cancelado\": \"0.00\", \"almacen_id\": 1, \"created_at\": \"2026-08-25T01:33:33.000000Z\", \"updated_at\": \"2026-09-11T15:25:33.000000Z\", \"descripcion\": \"\", \"sucursal_id\": 1, \"tipo_compra\": \"CRÉDITO\", \"proveedor_id\": 1, \"estado_ingreso\": \"VERIFICADO\", \"fecha_registro\": \"2026-08-24\", \"tipo_ingreso_id\": 1, \"estado_faltantes\": null, \"fecha_registro_t\": \"24/08/2026\"}, \"ingreso_producto_id\": 3}', NULL, 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-11', '11:25:33', '2026-09-11 15:25:33', '2026-09-11 15:25:33'),
(103, 1, 'ELIMINACIÓN', 'EL USUARIO admin ELIMINÓ UN MOVIMIENTO DE CAJA', '{\"id\": 14, \"hora\": \"12:11:13\", \"tipo\": \"PAGO POR COMPRA DE PRODUCTOS\", \"fecha\": \"2026-09-10\", \"monto\": \"10.00\", \"modulo\": \"IngresoPago\", \"status\": 1, \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-10T16:11:13.000000Z\", \"updated_at\": \"2026-09-10T16:11:13.000000Z\", \"descripcion\": \"PAGO POR COMPRA DE PRODUCTOS\", \"registro_id\": 7, \"sucursal_id\": 1, \"tipo_movimiento\": \"EGRESO\"}', '{\"id\": 14, \"hora\": \"12:11:13\", \"tipo\": \"PAGO POR COMPRA DE PRODUCTOS\", \"fecha\": \"2026-09-10\", \"monto\": \"10.00\", \"modulo\": \"IngresoPago\", \"status\": 0, \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-10T16:11:13.000000Z\", \"updated_at\": \"2026-09-11T15:25:36.000000Z\", \"descripcion\": \"PAGO POR COMPRA DE PRODUCTOS\", \"registro_id\": 7, \"sucursal_id\": 1, \"tipo_movimiento\": \"EGRESO\"}', 'MOVIMIENTO DE CAJAS', '2026-09-11', '11:25:36', '2026-09-11 15:25:36', '2026-09-11 15:25:36'),
(104, 1, 'ELIMINACIÓN', 'EL USUARIO admin ELIMINÓ UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 7, \"hora\": \"12:11:13\", \"fecha\": \"2026-09-10\", \"monto\": \"10.00\", \"user_id\": 1, \"almacen_id\": 1, \"created_at\": \"2026-09-10T16:11:13.000000Z\", \"updated_at\": \"2026-09-10T16:11:13.000000Z\", \"sucursal_id\": 1, \"proveedor_id\": 1, \"ingreso_producto\": {\"id\": 3, \"saldo\": 490, \"total\": \"1080.00\", \"codigo\": \"L-00003\", \"status\": 1, \"user_id\": 1, \"cancelado\": \"0.00\", \"almacen_id\": 1, \"created_at\": \"2026-08-25T01:33:33.000000Z\", \"updated_at\": \"2026-09-11T15:25:36.000000Z\", \"descripcion\": \"\", \"sucursal_id\": 1, \"tipo_compra\": \"CRÉDITO\", \"proveedor_id\": 1, \"estado_ingreso\": \"VERIFICADO\", \"fecha_registro\": \"2026-08-24\", \"tipo_ingreso_id\": 1, \"estado_faltantes\": null, \"fecha_registro_t\": \"24/08/2026\"}, \"ingreso_producto_id\": 3}', NULL, 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-11', '11:25:36', '2026-09-11 15:25:36', '2026-09-11 15:25:36'),
(105, 1, 'ELIMINACIÓN', 'EL USUARIO admin ELIMINÓ UN MOVIMIENTO DE CAJA', '{\"id\": 13, \"hora\": \"12:11:06\", \"tipo\": \"PAGO POR COMPRA DE PRODUCTOS\", \"fecha\": \"2026-09-10\", \"monto\": \"10.00\", \"modulo\": \"IngresoPago\", \"status\": 1, \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-10T16:11:06.000000Z\", \"updated_at\": \"2026-09-10T16:11:06.000000Z\", \"descripcion\": \"PAGO POR COMPRA DE PRODUCTOS\", \"registro_id\": 6, \"sucursal_id\": 1, \"tipo_movimiento\": \"EGRESO\"}', '{\"id\": 13, \"hora\": \"12:11:06\", \"tipo\": \"PAGO POR COMPRA DE PRODUCTOS\", \"fecha\": \"2026-09-10\", \"monto\": \"10.00\", \"modulo\": \"IngresoPago\", \"status\": 0, \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-10T16:11:06.000000Z\", \"updated_at\": \"2026-09-11T15:25:40.000000Z\", \"descripcion\": \"PAGO POR COMPRA DE PRODUCTOS\", \"registro_id\": 6, \"sucursal_id\": 1, \"tipo_movimiento\": \"EGRESO\"}', 'MOVIMIENTO DE CAJAS', '2026-09-11', '11:25:40', '2026-09-11 15:25:40', '2026-09-11 15:25:40'),
(106, 1, 'ELIMINACIÓN', 'EL USUARIO admin ELIMINÓ UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 6, \"hora\": \"12:11:06\", \"fecha\": \"2026-09-10\", \"monto\": \"10.00\", \"user_id\": 1, \"almacen_id\": 1, \"created_at\": \"2026-09-10T16:11:06.000000Z\", \"updated_at\": \"2026-09-10T16:11:06.000000Z\", \"sucursal_id\": 1, \"proveedor_id\": 1, \"ingreso_producto\": {\"id\": 3, \"saldo\": 500, \"total\": \"1080.00\", \"codigo\": \"L-00003\", \"status\": 1, \"user_id\": 1, \"cancelado\": \"0.00\", \"almacen_id\": 1, \"created_at\": \"2026-08-25T01:33:33.000000Z\", \"updated_at\": \"2026-09-11T15:25:40.000000Z\", \"descripcion\": \"\", \"sucursal_id\": 1, \"tipo_compra\": \"CRÉDITO\", \"proveedor_id\": 1, \"estado_ingreso\": \"VERIFICADO\", \"fecha_registro\": \"2026-08-24\", \"tipo_ingreso_id\": 1, \"estado_faltantes\": null, \"fecha_registro_t\": \"24/08/2026\"}, \"ingreso_producto_id\": 3}', NULL, 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-11', '11:25:40', '2026-09-11 15:25:40', '2026-09-11 15:25:40'),
(107, 1, 'ELIMINACIÓN', 'EL USUARIO admin ELIMINÓ UN MOVIMIENTO DE CAJA', '{\"id\": 12, \"hora\": \"12:09:08\", \"tipo\": \"PAGO POR COMPRA DE PRODUCTOS\", \"fecha\": \"2026-09-10\", \"monto\": \"100.00\", \"modulo\": \"IngresoPago\", \"status\": 1, \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-10T16:09:08.000000Z\", \"updated_at\": \"2026-09-10T16:10:57.000000Z\", \"descripcion\": \"PAGO POR COMPRA DE PRODUCTOS\", \"registro_id\": 5, \"sucursal_id\": 1, \"tipo_movimiento\": \"EGRESO\"}', '{\"id\": 12, \"hora\": \"12:09:08\", \"tipo\": \"PAGO POR COMPRA DE PRODUCTOS\", \"fecha\": \"2026-09-10\", \"monto\": \"100.00\", \"modulo\": \"IngresoPago\", \"status\": 0, \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-10T16:09:08.000000Z\", \"updated_at\": \"2026-09-11T15:25:45.000000Z\", \"descripcion\": \"PAGO POR COMPRA DE PRODUCTOS\", \"registro_id\": 5, \"sucursal_id\": 1, \"tipo_movimiento\": \"EGRESO\"}', 'MOVIMIENTO DE CAJAS', '2026-09-11', '11:25:45', '2026-09-11 15:25:45', '2026-09-11 15:25:45'),
(108, 1, 'ELIMINACIÓN', 'EL USUARIO admin ELIMINÓ UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 5, \"hora\": \"12:09:08\", \"fecha\": \"2026-09-10\", \"monto\": \"100.00\", \"user_id\": 1, \"almacen_id\": 1, \"created_at\": \"2026-09-10T16:09:08.000000Z\", \"updated_at\": \"2026-09-10T16:10:57.000000Z\", \"sucursal_id\": 1, \"proveedor_id\": 1, \"ingreso_producto\": {\"id\": 3, \"saldo\": 600, \"total\": \"1080.00\", \"codigo\": \"L-00003\", \"status\": 1, \"user_id\": 1, \"cancelado\": \"0.00\", \"almacen_id\": 1, \"created_at\": \"2026-08-25T01:33:33.000000Z\", \"updated_at\": \"2026-09-11T15:25:45.000000Z\", \"descripcion\": \"\", \"sucursal_id\": 1, \"tipo_compra\": \"CRÉDITO\", \"proveedor_id\": 1, \"estado_ingreso\": \"VERIFICADO\", \"fecha_registro\": \"2026-08-24\", \"tipo_ingreso_id\": 1, \"estado_faltantes\": null, \"fecha_registro_t\": \"24/08/2026\"}, \"ingreso_producto_id\": 3}', NULL, 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-11', '11:25:45', '2026-09-11 15:25:45', '2026-09-11 15:25:45'),
(109, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN INGRESO DE BS. 300 EN LA SUCURSAL SUCURSAL CENTRAL; almacén ALMACEN CENTRAL', '{\"id\": 19, \"hora\": \"11:30:21\", \"tipo\": \"MOVIMIENTO DE CAJA\", \"fecha\": \"2026-09-11\", \"monto\": \"300\", \"modulo\": \"MovimientoCaja\", \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-11T15:30:35.000000Z\", \"updated_at\": \"2026-09-11T15:30:35.000000Z\", \"descripcion\": \"ingreso prueba\", \"registro_id\": 19, \"sucursal_id\": 1, \"tipo_movimiento\": \"INGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-11', '11:30:35', '2026-09-11 15:30:35', '2026-09-11 15:30:35');
INSERT INTO `historial_accions` (`id`, `user_id`, `accion`, `descripcion`, `datos_original`, `datos_nuevo`, `modulo`, `fecha`, `hora`, `created_at`, `updated_at`) VALUES
(110, 1, 'ELIMINACIÓN', 'EL USUARIO admin ELIMINÓ UN MOVIMIENTO DE CAJA', '{\"id\": 19, \"hora\": \"11:30:21\", \"tipo\": \"MOVIMIENTO DE CAJA\", \"fecha\": \"2026-09-11\", \"monto\": \"400.00\", \"modulo\": \"MovimientoCaja\", \"status\": 1, \"user_id\": 1, \"tipo_pago\": \"QR\", \"almacen_id\": 1, \"created_at\": \"2026-09-11T15:30:35.000000Z\", \"updated_at\": \"2026-09-11T15:31:12.000000Z\", \"descripcion\": \"Ingreso prueba modificado\", \"registro_id\": 19, \"sucursal_id\": 1, \"tipo_movimiento\": \"INGRESO\"}', '{\"id\": 19, \"hora\": \"11:30:21\", \"tipo\": \"MOVIMIENTO DE CAJA\", \"fecha\": \"2026-09-11\", \"monto\": \"400.00\", \"modulo\": \"MovimientoCaja\", \"status\": 0, \"user_id\": 1, \"tipo_pago\": \"QR\", \"almacen_id\": 1, \"created_at\": \"2026-09-11T15:30:35.000000Z\", \"updated_at\": \"2026-09-11T15:31:50.000000Z\", \"descripcion\": \"Ingreso prueba modificado\", \"registro_id\": 19, \"sucursal_id\": 1, \"tipo_movimiento\": \"INGRESO\"}', 'MOVIMIENTO DE CAJAS', '2026-09-11', '11:31:50', '2026-09-11 15:31:50', '2026-09-11 15:31:50'),
(111, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN EGRESO DE BS. 240 EN LA SUCURSAL SUCURSAL CENTRAL; almacén ALMACEN CENTRAL', '{\"id\": 20, \"hora\": \"16:34:45\", \"tipo\": \"COMPRA DE PRODUCTOS\", \"fecha\": \"2026-09-13\", \"monto\": \"240\", \"modulo\": \"IngresoProducto\", \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-13T20:34:45.000000Z\", \"updated_at\": \"2026-09-13T20:34:45.000000Z\", \"descripcion\": \"COMPRA DE PRODUCTOS\", \"registro_id\": 9, \"sucursal_id\": 1, \"tipo_movimiento\": \"EGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-13', '16:34:45', '2026-09-13 20:34:45', '2026-09-13 20:34:45'),
(112, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA INGRESO DE PRODUCTO', '{\"id\": 9, \"saldo\": \"0.00\", \"total\": \"240.00\", \"codigo\": \"L-00009\", \"user_id\": 1, \"cancelado\": \"240\", \"almacen_id\": 1, \"created_at\": \"2026-09-13T20:34:45.000000Z\", \"updated_at\": \"2026-09-13T20:34:45.000000Z\", \"descripcion\": \"PRUEBA\", \"sucursal_id\": 1, \"tipo_compra\": \"CONTADO,\", \"proveedor_id\": \"1\", \"fecha_registro\": \"2026-09-13\", \"tipo_ingreso_id\": \"3\", \"ingreso_detalles\": [{\"id\": 9, \"costo\": \"240.00\", \"cantidad\": 1, \"repuesto\": 0, \"subtotal\": \"240.00\", \"faltantes\": null, \"created_at\": \"2026-09-13T20:34:45.000000Z\", \"updated_at\": \"2026-09-13T20:34:45.000000Z\", \"verificado\": null, \"observacion\": null, \"producto_id\": 5, \"cantidad_fisica\": null, \"tipo_ingreso_id\": 3, \"ingreso_producto_id\": 9}]}', NULL, 'INGRESO DE PRODUCTOS', '2026-09-13', '16:34:45', '2026-09-13 20:34:45', '2026-09-13 20:34:45'),
(113, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA INGRESO DE PRODUCTO', '{\"id\": 10, \"saldo\": \"720.00\", \"total\": \"720.00\", \"codigo\": \"L-00010\", \"user_id\": 1, \"cancelado\": \"0\", \"almacen_id\": 1, \"created_at\": \"2026-09-13T20:36:17.000000Z\", \"updated_at\": \"2026-09-13T20:36:17.000000Z\", \"descripcion\": \"PRUEBA 2\", \"sucursal_id\": 1, \"tipo_compra\": \"CRÉDITO\", \"proveedor_id\": \"1\", \"fecha_registro\": \"2026-09-13\", \"tipo_ingreso_id\": \"1\", \"ingreso_detalles\": [{\"id\": 10, \"costo\": \"240.00\", \"cantidad\": 3, \"repuesto\": 0, \"subtotal\": \"720.00\", \"faltantes\": null, \"created_at\": \"2026-09-13T20:36:17.000000Z\", \"updated_at\": \"2026-09-13T20:36:17.000000Z\", \"verificado\": null, \"observacion\": null, \"producto_id\": 5, \"cantidad_fisica\": null, \"tipo_ingreso_id\": 1, \"ingreso_producto_id\": 10}]}', NULL, 'INGRESO DE PRODUCTOS', '2026-09-13', '16:36:17', '2026-09-13 20:36:17', '2026-09-13 20:36:17'),
(114, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN TRASPASO DE PRODUCTOS DE ALMACEN CENTRAL A ALMACEN 2', '{\"id\": 7, \"user_id\": 1, \"cantidad\": \"5\", \"created_at\": \"2026-09-15T14:25:34.000000Z\", \"updated_at\": \"2026-09-15T14:25:34.000000Z\", \"descripcion\": \"TRASPASO A ALMACEN 2\", \"fecha_registro\": \"2026-09-15\", \"almacen_origen_id\": 1, \"traspaso_detalles\": [{\"id\": 13, \"cantidad\": 1, \"created_at\": \"2026-09-15T14:25:34.000000Z\", \"updated_at\": \"2026-09-15T14:25:34.000000Z\", \"observacion\": null, \"producto_id\": 2, \"traspaso_id\": 7}, {\"id\": 14, \"cantidad\": 1, \"created_at\": \"2026-09-15T14:25:34.000000Z\", \"updated_at\": \"2026-09-15T14:25:34.000000Z\", \"observacion\": null, \"producto_id\": 3, \"traspaso_id\": 7}, {\"id\": 15, \"cantidad\": 1, \"created_at\": \"2026-09-15T14:25:34.000000Z\", \"updated_at\": \"2026-09-15T14:25:34.000000Z\", \"observacion\": null, \"producto_id\": 4, \"traspaso_id\": 7}, {\"id\": 16, \"cantidad\": 1, \"created_at\": \"2026-09-15T14:25:34.000000Z\", \"updated_at\": \"2026-09-15T14:25:34.000000Z\", \"observacion\": null, \"producto_id\": 5, \"traspaso_id\": 7}, {\"id\": 17, \"cantidad\": 1, \"created_at\": \"2026-09-15T14:25:34.000000Z\", \"updated_at\": \"2026-09-15T14:25:34.000000Z\", \"observacion\": null, \"producto_id\": 6, \"traspaso_id\": 7}], \"almacen_destino_id\": 3, \"sucursal_origen_id\": 1, \"sucursal_destino_id\": 3}', NULL, 'TRASPASOS DE PRODUCTOS', '2026-09-15', '10:25:34', '2026-09-15 14:25:34', '2026-09-15 14:25:34'),
(115, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN INGRESO DE BS. 590.00 EN LA SUCURSAL SUCURSAL 2; almacén ALMACEN 2', '{\"id\": 21, \"hora\": \"10:41:26\", \"tipo\": \"VENTA\", \"fecha\": \"2026-09-15\", \"monto\": \"590.00\", \"modulo\": \"Venta\", \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 3, \"created_at\": \"2026-09-15T14:41:26.000000Z\", \"updated_at\": \"2026-09-15T14:41:26.000000Z\", \"descripcion\": \"INGRESO POR VENTA\", \"registro_id\": 14, \"sucursal_id\": 3, \"tipo_movimiento\": \"INGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-15', '10:41:26', '2026-09-15 14:41:26', '2026-09-15 14:41:26'),
(116, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA VENTA', '{\"id\": 14, \"hora\": \"10:41:26\", \"fecha\": \"2026-09-15\", \"saldo\": \"0.00\", \"total\": \"590.00\", \"nit_ci\": \"43343434\", \"user_id\": 1, \"subtotal\": \"590.00\", \"cancelado\": \"590.00\", \"descuento\": \"0\", \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 3, \"cliente_id\": 5, \"created_at\": \"2026-09-15T14:41:26.000000Z\", \"tipo_venta\": \"AL CONTADO\", \"updated_at\": \"2026-09-15T14:41:26.000000Z\", \"sucursal_id\": 3, \"codigo_venta\": \"V14\", \"fecha_registro\": \"2026-09-15\", \"venta_detalles\": [{\"id\": 15, \"total\": \"200.00\", \"precio\": \"200.00\", \"status\": 1, \"cantidad\": 1, \"venta_id\": 14, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"200.00\", \"created_at\": \"2026-09-15T14:41:26.000000Z\", \"updated_at\": \"2026-09-15T14:41:26.000000Z\", \"producto_id\": 2, \"precio_final\": \"200.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}, {\"id\": 16, \"total\": \"390.00\", \"precio\": \"390.00\", \"status\": 1, \"cantidad\": 1, \"venta_id\": 14, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"390.00\", \"created_at\": \"2026-09-15T14:41:26.000000Z\", \"updated_at\": \"2026-09-15T14:41:26.000000Z\", \"producto_id\": 4, \"precio_final\": \"390.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"tipo_documento_id\": 1, \"porcentaje_descuento\": 0}', NULL, 'VENTAS', '2026-09-15', '10:41:26', '2026-09-15 14:41:26', '2026-09-15 14:41:26'),
(117, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN CLIENTE', '{\"id\": 13, \"fono\": null, \"correo\": null, \"nombre\": \"JAVIER CLEMENTE\", \"created_at\": \"2026-09-15T14:45:14.000000Z\", \"updated_at\": \"2026-09-15T14:45:14.000000Z\", \"complemento\": null, \"nro_documento\": \"56565656\", \"fecha_registro\": \"2026-09-15\", \"tipo_documento_id\": 1}', NULL, 'CLIENTES', '2026-09-15', '10:45:14', '2026-09-15 14:45:14', '2026-09-15 14:45:14'),
(118, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA PROFORMA', '{\"id\": 3, \"hora\": \"10:45:17\", \"fecha\": \"2026-09-15\", \"saldo\": 0, \"total\": \"1130.00\", \"nit_ci\": \"56565656\", \"user_id\": 1, \"subtotal\": \"1140.00\", \"cancelado\": \"1130.00\", \"descuento\": \"10\", \"almacen_id\": 1, \"cliente_id\": 13, \"created_at\": \"2026-09-15T14:45:17.000000Z\", \"updated_at\": \"2026-09-15T14:45:17.000000Z\", \"sucursal_id\": 1, \"fecha_registro\": \"2026-09-15\", \"codigo_proforma\": \"P3\", \"proforma_detalles\": [{\"id\": 7, \"total\": \"396.48\", \"precio\": \"200.00\", \"cantidad\": 2, \"porcen_dt\": 0.88, \"porcen_du\": 0, \"total_uni\": \"400.00\", \"created_at\": \"2026-09-15T14:45:17.000000Z\", \"updated_at\": \"2026-09-15T14:45:17.000000Z\", \"producto_id\": 2, \"proforma_id\": 3, \"precio_final\": \"198.24\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"1.76\"}, {\"id\": 8, \"total\": \"346.92\", \"precio\": \"350.00\", \"cantidad\": 1, \"porcen_dt\": 0.88, \"porcen_du\": 0, \"total_uni\": \"350.00\", \"created_at\": \"2026-09-15T14:45:17.000000Z\", \"updated_at\": \"2026-09-15T14:45:17.000000Z\", \"producto_id\": 3, \"proforma_id\": 3, \"precio_final\": \"346.92\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"3.08\"}, {\"id\": 9, \"total\": \"386.57\", \"precio\": \"390.00\", \"cantidad\": 1, \"porcen_dt\": 0.88, \"porcen_du\": 0, \"total_uni\": \"390.00\", \"created_at\": \"2026-09-15T14:45:17.000000Z\", \"updated_at\": \"2026-09-15T14:45:17.000000Z\", \"producto_id\": 4, \"proforma_id\": 3, \"precio_final\": \"386.57\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"3.43\"}], \"tipo_documento_id\": 1, \"porcentaje_descuento\": \"0.88\"}', NULL, 'PROFORMAS', '2026-09-15', '10:45:17', '2026-09-15 14:45:17', '2026-09-15 14:45:17'),
(119, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN INGRESO DE BS. 500 EN LA SUCURSAL SUCURSAL CENTRAL; almacén ALMACEN CENTRAL', '{\"id\": 22, \"hora\": \"11:22:58\", \"tipo\": \"COBRO POR VENTA DE PRODUCTOS\", \"fecha\": \"2026-09-15\", \"monto\": \"500\", \"modulo\": \"VentaCobro\", \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-15T15:22:58.000000Z\", \"updated_at\": \"2026-09-15T15:22:58.000000Z\", \"descripcion\": \"COBRO POR VENTA DE PRODUCTOS\", \"registro_id\": 6, \"sucursal_id\": 1, \"tipo_movimiento\": \"INGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-15', '11:22:58', '2026-09-15 15:22:58', '2026-09-15 15:22:58'),
(120, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 6, \"hora\": \"11:22:58\", \"fecha\": \"2026-09-15\", \"monto\": \"500\", \"saldo\": 0, \"user_id\": 1, \"venta_id\": 10, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 3, \"created_at\": \"2026-09-15T15:22:58.000000Z\", \"updated_at\": \"2026-09-15T15:22:58.000000Z\", \"sucursal_id\": 1}', NULL, 'COBROS DE CRÉDITOS POR VENTAS', '2026-09-15', '11:22:58', '2026-09-15 15:22:58', '2026-09-15 15:22:58'),
(121, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN INGRESO DE BS. 50 EN LA SUCURSAL SUCURSAL CENTRAL; almacén ALMACEN CENTRAL', '{\"id\": 23, \"hora\": \"11:23:38\", \"tipo\": \"COBRO POR VENTA DE PRODUCTOS\", \"fecha\": \"2026-09-15\", \"monto\": \"50\", \"modulo\": \"VentaCobro\", \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-15T15:23:38.000000Z\", \"updated_at\": \"2026-09-15T15:23:38.000000Z\", \"descripcion\": \"COBRO POR VENTA DE PRODUCTOS\", \"registro_id\": 7, \"sucursal_id\": 1, \"tipo_movimiento\": \"INGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-15', '11:23:38', '2026-09-15 15:23:38', '2026-09-15 15:23:38'),
(122, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 7, \"hora\": \"11:23:38\", \"fecha\": \"2026-09-15\", \"monto\": \"50\", \"saldo\": 0, \"user_id\": 1, \"venta_id\": 10, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 3, \"created_at\": \"2026-09-15T15:23:38.000000Z\", \"updated_at\": \"2026-09-15T15:23:38.000000Z\", \"sucursal_id\": 1}', NULL, 'COBROS DE CRÉDITOS POR VENTAS', '2026-09-15', '11:23:38', '2026-09-15 15:23:38', '2026-09-15 15:23:38'),
(123, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UN PAGO POR VENTA DE PRODUCTOS', '{\"id\": 7, \"hora\": \"11:23:38\", \"fecha\": \"2026-09-15\", \"monto\": \"50.00\", \"saldo\": \"0.00\", \"user_id\": 1, \"venta_id\": 10, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 3, \"created_at\": \"2026-09-15T15:23:38.000000Z\", \"updated_at\": \"2026-09-15T15:23:38.000000Z\", \"sucursal_id\": 1}', '{\"id\": 7, \"hora\": \"11:23:49\", \"fecha\": \"2026-09-15\", \"monto\": \"50.00\", \"saldo\": 0, \"user_id\": 1, \"venta_id\": 10, \"tipo_pago\": \"QR\", \"almacen_id\": 1, \"cliente_id\": 3, \"created_at\": \"2026-09-15T15:23:38.000000Z\", \"updated_at\": \"2026-09-15T15:23:49.000000Z\", \"sucursal_id\": 1}', 'COBROS DE CRÉDITOS POR VENTAS', '2026-09-15', '11:23:49', '2026-09-15 15:23:49', '2026-09-15 15:23:49'),
(124, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA INGRESO DE PRODUCTO', '{\"id\": 11, \"saldo\": \"300.00\", \"total\": \"300.00\", \"codigo\": \"L-00011\", \"user_id\": 1, \"cancelado\": \"0\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T14:13:28.000000Z\", \"updated_at\": \"2026-09-16T14:13:28.000000Z\", \"descripcion\": \"\", \"sucursal_id\": 1, \"tipo_compra\": \"CRÉDITO\", \"proveedor_id\": \"1\", \"fecha_registro\": \"2026-09-16\", \"tipo_ingreso_id\": \"1\", \"ingreso_detalles\": [{\"id\": 11, \"costo\": \"300.00\", \"cantidad\": 1, \"repuesto\": 0, \"subtotal\": \"300.00\", \"faltantes\": null, \"created_at\": \"2026-09-16T14:13:28.000000Z\", \"updated_at\": \"2026-09-16T14:13:28.000000Z\", \"verificado\": null, \"observacion\": null, \"producto_id\": 3, \"cantidad_fisica\": null, \"tipo_ingreso_id\": 1, \"ingreso_producto_id\": 11}]}', NULL, 'INGRESO DE PRODUCTOS', '2026-09-16', '10:13:28', '2026-09-16 14:13:28', '2026-09-16 14:13:28'),
(125, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN TRASPASO DE PRODUCTOS DE ALMACEN CENTRAL A ALMACEN 1', '{\"id\": 8, \"user_id\": 1, \"cantidad\": \"2\", \"created_at\": \"2026-09-16T14:17:07.000000Z\", \"updated_at\": \"2026-09-16T14:17:07.000000Z\", \"descripcion\": \"TRASPASO A ALMACEN 1\", \"fecha_registro\": \"2026-09-16\", \"almacen_origen_id\": 1, \"traspaso_detalles\": [{\"id\": 18, \"cantidad\": 2, \"created_at\": \"2026-09-16T14:17:07.000000Z\", \"updated_at\": \"2026-09-16T14:17:07.000000Z\", \"observacion\": null, \"producto_id\": 2, \"traspaso_id\": 8}], \"almacen_destino_id\": 2, \"sucursal_origen_id\": 1, \"sucursal_destino_id\": 2}', NULL, 'TRASPASOS DE PRODUCTOS', '2026-09-16', '10:17:07', '2026-09-16 14:17:07', '2026-09-16 14:17:07'),
(126, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN EGRESO DE BS. 540 EN LA SUCURSAL SUCURSAL CENTRAL; almacén ALMACEN CENTRAL', '{\"id\": 24, \"hora\": \"10:22:25\", \"tipo\": \"COMPRA DE PRODUCTOS\", \"fecha\": \"2026-09-16\", \"monto\": \"540\", \"modulo\": \"IngresoProducto\", \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T14:22:25.000000Z\", \"updated_at\": \"2026-09-16T14:22:25.000000Z\", \"descripcion\": \"COMPRA DE PRODUCTOS\", \"registro_id\": 12, \"sucursal_id\": 1, \"tipo_movimiento\": \"EGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-16', '10:22:25', '2026-09-16 14:22:25', '2026-09-16 14:22:25'),
(127, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA INGRESO DE PRODUCTO', '{\"id\": 12, \"saldo\": \"1020.00\", \"total\": \"1560.00\", \"codigo\": \"L-00012\", \"user_id\": 1, \"cancelado\": \"540\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T14:22:25.000000Z\", \"updated_at\": \"2026-09-16T14:22:25.000000Z\", \"descripcion\": \"\", \"sucursal_id\": 1, \"tipo_compra\": \"CRÉDITO\", \"proveedor_id\": \"1\", \"fecha_registro\": \"2026-09-16\", \"tipo_ingreso_id\": \"1\", \"ingreso_detalles\": [{\"id\": 12, \"costo\": \"120.00\", \"cantidad\": 3, \"repuesto\": 0, \"subtotal\": \"360.00\", \"faltantes\": null, \"created_at\": \"2026-09-16T14:22:25.000000Z\", \"updated_at\": \"2026-09-16T14:22:25.000000Z\", \"verificado\": null, \"observacion\": null, \"producto_id\": 2, \"cantidad_fisica\": null, \"tipo_ingreso_id\": 1, \"ingreso_producto_id\": 12}, {\"id\": 13, \"costo\": \"300.00\", \"cantidad\": 4, \"repuesto\": 0, \"subtotal\": \"1200.00\", \"faltantes\": null, \"created_at\": \"2026-09-16T14:22:25.000000Z\", \"updated_at\": \"2026-09-16T14:22:25.000000Z\", \"verificado\": null, \"observacion\": null, \"producto_id\": 3, \"cantidad_fisica\": null, \"tipo_ingreso_id\": 1, \"ingreso_producto_id\": 12}]}', NULL, 'INGRESO DE PRODUCTOS', '2026-09-16', '10:22:25', '2026-09-16 14:22:25', '2026-09-16 14:22:25'),
(128, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA INGRESO DE PRODUCTO', '{\"id\": 13, \"saldo\": \"480.00\", \"total\": \"480.00\", \"codigo\": \"L-00013\", \"user_id\": 1, \"cancelado\": \"0\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T14:25:21.000000Z\", \"updated_at\": \"2026-09-16T14:25:21.000000Z\", \"descripcion\": \"\", \"sucursal_id\": 1, \"tipo_compra\": \"CRÉDITO\", \"proveedor_id\": \"1\", \"fecha_registro\": \"2026-09-16\", \"tipo_ingreso_id\": \"1\", \"ingreso_detalles\": [{\"id\": 14, \"costo\": \"120.00\", \"cantidad\": 4, \"repuesto\": 0, \"subtotal\": \"480.00\", \"faltantes\": null, \"created_at\": \"2026-09-16T14:25:21.000000Z\", \"updated_at\": \"2026-09-16T14:25:21.000000Z\", \"verificado\": null, \"observacion\": null, \"producto_id\": 2, \"cantidad_fisica\": null, \"tipo_ingreso_id\": 1, \"ingreso_producto_id\": 13}]}', NULL, 'INGRESO DE PRODUCTOS', '2026-09-16', '10:25:21', '2026-09-16 14:25:21', '2026-09-16 14:25:21'),
(129, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA PROFORMA', '{\"id\": 4, \"hora\": \"10:29:09\", \"fecha\": \"2026-09-16\", \"saldo\": 0, \"total\": \"2300.00\", \"nit_ci\": \"43344343\", \"user_id\": 1, \"subtotal\": \"2300.00\", \"cancelado\": \"2300.00\", \"descuento\": \"0\", \"almacen_id\": 1, \"cliente_id\": 8, \"created_at\": \"2026-09-16T14:29:09.000000Z\", \"updated_at\": \"2026-09-16T14:29:09.000000Z\", \"sucursal_id\": 1, \"fecha_registro\": \"2026-09-16\", \"codigo_proforma\": \"P4\", \"proforma_detalles\": [{\"id\": 10, \"total\": \"900.00\", \"precio\": \"300.00\", \"cantidad\": 3, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"900.00\", \"created_at\": \"2026-09-16T14:29:09.000000Z\", \"updated_at\": \"2026-09-16T14:29:09.000000Z\", \"producto_id\": 3, \"proforma_id\": 4, \"precio_final\": \"350.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}, {\"id\": 11, \"total\": \"800.00\", \"precio\": \"200.00\", \"cantidad\": 4, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"800.00\", \"created_at\": \"2026-09-16T14:29:09.000000Z\", \"updated_at\": \"2026-09-16T14:29:09.000000Z\", \"producto_id\": 2, \"proforma_id\": 4, \"precio_final\": \"200.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}, {\"id\": 12, \"total\": \"600.00\", \"precio\": \"300.00\", \"cantidad\": 2, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"600.00\", \"created_at\": \"2026-09-16T14:29:09.000000Z\", \"updated_at\": \"2026-09-16T14:29:09.000000Z\", \"producto_id\": 5, \"proforma_id\": 4, \"precio_final\": \"300.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"tipo_documento_id\": 2, \"porcentaje_descuento\": 0}', NULL, 'PROFORMAS', '2026-09-16', '10:29:09', '2026-09-16 14:29:09', '2026-09-16 14:29:09'),
(130, 1, 'ELIMINACIÓN', 'EL USUARIO admin ELIMINÓ UNA VENTA', '{\"id\": 14, \"hora\": \"10:41:26\", \"fecha\": \"2026-09-15\", \"saldo\": \"0.00\", \"total\": \"590.00\", \"nit_ci\": \"43343434\", \"status\": 1, \"user_id\": 1, \"subtotal\": \"590.00\", \"cancelado\": \"590.00\", \"descuento\": \"0.00\", \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 3, \"cliente_id\": 5, \"created_at\": \"2026-09-15T14:41:26.000000Z\", \"tipo_venta\": \"AL CONTADO\", \"updated_at\": \"2026-09-15T14:41:26.000000Z\", \"sucursal_id\": 3, \"codigo_venta\": \"V14\", \"fecha_registro\": \"2026-09-15\", \"venta_detalles\": [], \"tipo_documento_id\": 1, \"porcentaje_descuento\": 0}', '{\"id\": 14, \"hora\": \"10:41:26\", \"fecha\": \"2026-09-15\", \"saldo\": \"0.00\", \"total\": \"590.00\", \"nit_ci\": \"43343434\", \"status\": 0, \"user_id\": 1, \"subtotal\": \"590.00\", \"cancelado\": \"590.00\", \"descuento\": \"0.00\", \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 3, \"cliente_id\": 5, \"created_at\": \"2026-09-15T14:41:26.000000Z\", \"tipo_venta\": \"AL CONTADO\", \"updated_at\": \"2026-09-16T14:31:17.000000Z\", \"sucursal_id\": 3, \"codigo_venta\": \"V14\", \"fecha_registro\": \"2026-09-15\", \"venta_detalles\": [{\"id\": 15, \"total\": \"200.00\", \"precio\": \"200.00\", \"status\": 1, \"cantidad\": 1, \"venta_id\": 14, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"200.00\", \"created_at\": \"2026-09-15T14:41:26.000000Z\", \"updated_at\": \"2026-09-15T14:41:26.000000Z\", \"producto_id\": 2, \"precio_final\": \"200.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}, {\"id\": 16, \"total\": \"390.00\", \"precio\": \"390.00\", \"status\": 1, \"cantidad\": 1, \"venta_id\": 14, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"390.00\", \"created_at\": \"2026-09-15T14:41:26.000000Z\", \"updated_at\": \"2026-09-15T14:41:26.000000Z\", \"producto_id\": 4, \"precio_final\": \"390.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"tipo_documento_id\": 1, \"porcentaje_descuento\": 0}', 'VENTAS', '2026-09-16', '10:31:17', '2026-09-16 14:31:17', '2026-09-16 14:31:17'),
(131, 1, 'ELIMINACIÓN', 'EL USUARIO admin RESTAURÓ UNA VENTA', '{\"id\": 14, \"hora\": \"10:41:26\", \"fecha\": \"2026-09-15\", \"saldo\": \"0.00\", \"total\": \"590.00\", \"nit_ci\": \"43343434\", \"status\": 0, \"user_id\": 1, \"subtotal\": \"590.00\", \"cancelado\": \"590.00\", \"descuento\": \"0.00\", \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 3, \"cliente_id\": 5, \"created_at\": \"2026-09-15T14:41:26.000000Z\", \"tipo_venta\": \"AL CONTADO\", \"updated_at\": \"2026-09-16T14:31:17.000000Z\", \"sucursal_id\": 3, \"codigo_venta\": \"V14\", \"fecha_registro\": \"2026-09-15\", \"venta_detalles\": [], \"tipo_documento_id\": 1, \"porcentaje_descuento\": 0}', '{\"id\": 14, \"hora\": \"10:41:26\", \"fecha\": \"2026-09-15\", \"saldo\": \"0.00\", \"total\": \"590.00\", \"nit_ci\": \"43343434\", \"status\": 1, \"user_id\": 1, \"subtotal\": \"590.00\", \"cancelado\": \"590.00\", \"descuento\": \"0.00\", \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 3, \"cliente_id\": 5, \"created_at\": \"2026-09-15T14:41:26.000000Z\", \"tipo_venta\": \"AL CONTADO\", \"updated_at\": \"2026-09-16T14:31:22.000000Z\", \"sucursal_id\": 3, \"codigo_venta\": \"V14\", \"fecha_registro\": \"2026-09-15\", \"venta_detalles\": [], \"tipo_documento_id\": 1, \"porcentaje_descuento\": 0}', 'VENTAS', '2026-09-16', '10:31:22', '2026-09-16 14:31:22', '2026-09-16 14:31:22'),
(132, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN INGRESO DE BS. 50 EN LA SUCURSAL SUCURSAL CENTRAL; almacén ALMACEN CENTRAL', '{\"id\": 25, \"hora\": \"10:33:00\", \"tipo\": \"VENTA\", \"fecha\": \"2026-09-16\", \"monto\": \"50\", \"modulo\": \"Venta\", \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T14:33:00.000000Z\", \"updated_at\": \"2026-09-16T14:33:00.000000Z\", \"descripcion\": \"INGRESO POR VENTA\", \"registro_id\": 15, \"sucursal_id\": 1, \"tipo_movimiento\": \"INGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-16', '10:33:00', '2026-09-16 14:33:00', '2026-09-16 14:33:00'),
(133, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA VENTA', '{\"id\": 15, \"hora\": \"10:33:00\", \"fecha\": \"2026-09-16\", \"saldo\": \"240.00\", \"total\": \"290.00\", \"nit_ci\": \"123456\", \"user_id\": 1, \"subtotal\": \"290.00\", \"cancelado\": \"50\", \"descuento\": \"0\", \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 2, \"created_at\": \"2026-09-16T14:33:00.000000Z\", \"tipo_venta\": \"CRÉDITO\", \"updated_at\": \"2026-09-16T14:33:00.000000Z\", \"sucursal_id\": 1, \"codigo_venta\": \"V15\", \"fecha_registro\": \"2026-09-16\", \"venta_detalles\": [{\"id\": 17, \"total\": \"290.00\", \"precio\": \"290.00\", \"status\": 1, \"cantidad\": 1, \"venta_id\": 15, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"290.00\", \"created_at\": \"2026-09-16T14:33:00.000000Z\", \"updated_at\": \"2026-09-16T14:33:00.000000Z\", \"producto_id\": 2, \"precio_final\": \"290.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"tipo_documento_id\": 1, \"porcentaje_descuento\": 0}', NULL, 'VENTAS', '2026-09-16', '10:33:00', '2026-09-16 14:33:00', '2026-09-16 14:33:00'),
(134, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN EGRESO DE BS. 300 EN LA SUCURSAL SUCURSAL CENTRAL; almacén ALMACEN CENTRAL', '{\"id\": 26, \"hora\": \"10:36:53\", \"tipo\": \"PAGO POR COMPRA DE PRODUCTOS\", \"fecha\": \"2026-09-16\", \"monto\": \"300\", \"modulo\": \"IngresoPago\", \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T14:36:53.000000Z\", \"updated_at\": \"2026-09-16T14:36:53.000000Z\", \"descripcion\": \"PAGO POR COMPRA DE PRODUCTOS\", \"registro_id\": 11, \"sucursal_id\": 1, \"tipo_movimiento\": \"EGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-16', '10:36:53', '2026-09-16 14:36:53', '2026-09-16 14:36:53'),
(135, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 11, \"hora\": \"10:36:53\", \"fecha\": \"2026-09-16\", \"monto\": \"300\", \"user_id\": 1, \"almacen_id\": 1, \"created_at\": \"2026-09-16T14:36:53.000000Z\", \"updated_at\": \"2026-09-16T14:36:53.000000Z\", \"sucursal_id\": 1, \"proveedor_id\": 1, \"ingreso_producto_id\": 11}', NULL, 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-16', '10:36:53', '2026-09-16 14:36:53', '2026-09-16 14:36:53'),
(136, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN INGRESO DE BS. 2000 EN LA SUCURSAL SUCURSAL CENTRAL; almacén ALMACEN CENTRAL', '{\"id\": 27, \"hora\": \"10:37:02\", \"tipo\": \"MOVIMIENTO DE CAJA\", \"fecha\": \"2026-09-16\", \"monto\": \"2000\", \"modulo\": \"MovimientoCaja\", \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T14:38:13.000000Z\", \"updated_at\": \"2026-09-16T14:38:13.000000Z\", \"descripcion\": \"ingreso de prueba\", \"registro_id\": 27, \"sucursal_id\": 1, \"tipo_movimiento\": \"INGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-16', '10:38:13', '2026-09-16 14:38:13', '2026-09-16 14:38:13'),
(137, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA VENTA', '{\"id\": 16, \"hora\": \"14:45:46\", \"fecha\": \"2026-09-16\", \"saldo\": \"550.00\", \"total\": \"550.00\", \"nit_ci\": \"123456-CM\", \"user_id\": 1, \"subtotal\": \"550.00\", \"cancelado\": \"0\", \"descuento\": \"0\", \"tipo_pago\": null, \"almacen_id\": 1, \"cliente_id\": 1, \"created_at\": \"2026-09-16T18:45:46.000000Z\", \"tipo_venta\": \"CRÉDITO\", \"updated_at\": \"2026-09-16T18:45:46.000000Z\", \"sucursal_id\": 1, \"codigo_venta\": \"V16\", \"fecha_registro\": \"2026-09-16\", \"venta_detalles\": [{\"id\": 18, \"total\": \"200.00\", \"precio\": \"200.00\", \"status\": 1, \"cantidad\": 1, \"venta_id\": 16, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"200.00\", \"created_at\": \"2026-09-16T18:45:46.000000Z\", \"updated_at\": \"2026-09-16T18:45:46.000000Z\", \"producto_id\": 2, \"precio_final\": \"200.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}, {\"id\": 19, \"total\": \"350.00\", \"precio\": \"350.00\", \"status\": 1, \"cantidad\": 1, \"venta_id\": 16, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"350.00\", \"created_at\": \"2026-09-16T18:45:46.000000Z\", \"updated_at\": \"2026-09-16T18:45:46.000000Z\", \"producto_id\": 3, \"precio_final\": \"350.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"tipo_documento_id\": 1, \"porcentaje_descuento\": 0}', NULL, 'VENTAS', '2026-09-16', '14:45:46', '2026-09-16 18:45:46', '2026-09-16 18:45:46'),
(138, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA PROFORMA', '{\"id\": 5, \"hora\": \"14:46:11\", \"fecha\": \"2026-09-16\", \"saldo\": 0, \"total\": \"2300.00\", \"nit_ci\": \"3433333\", \"user_id\": 1, \"subtotal\": \"2300.00\", \"cancelado\": \"2300.00\", \"descuento\": \"0\", \"almacen_id\": 1, \"cliente_id\": 4, \"created_at\": \"2026-09-16T18:46:11.000000Z\", \"updated_at\": \"2026-09-16T18:46:11.000000Z\", \"sucursal_id\": 1, \"fecha_registro\": \"2026-09-16\", \"codigo_proforma\": \"P5\", \"proforma_detalles\": [{\"id\": 13, \"total\": \"200.00\", \"precio\": \"200.00\", \"cantidad\": 1, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"200.00\", \"created_at\": \"2026-09-16T18:46:11.000000Z\", \"updated_at\": \"2026-09-16T18:46:11.000000Z\", \"producto_id\": 2, \"proforma_id\": 5, \"precio_final\": \"200.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}, {\"id\": 14, \"total\": \"2100.00\", \"precio\": \"350.00\", \"cantidad\": 6, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"2100.00\", \"created_at\": \"2026-09-16T18:46:11.000000Z\", \"updated_at\": \"2026-09-16T18:46:11.000000Z\", \"producto_id\": 3, \"proforma_id\": 5, \"precio_final\": \"350.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"tipo_documento_id\": 1, \"porcentaje_descuento\": 0}', NULL, 'PROFORMAS', '2026-09-16', '14:46:11', '2026-09-16 18:46:11', '2026-09-16 18:46:11'),
(139, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UNA PROFORMA', '{\"id\": 5, \"hora\": \"14:46:11\", \"fecha\": \"2026-09-16\", \"saldo\": \"0.00\", \"total\": \"2300.00\", \"nit_ci\": \"3433333\", \"status\": 1, \"user_id\": 1, \"subtotal\": \"2300.00\", \"cancelado\": \"2300.00\", \"descuento\": \"0.00\", \"almacen_id\": 1, \"cliente_id\": 4, \"created_at\": \"2026-09-16T18:46:11.000000Z\", \"updated_at\": \"2026-09-16T18:46:11.000000Z\", \"sucursal_id\": 1, \"fecha_registro\": \"2026-09-16\", \"codigo_proforma\": \"P5\", \"proforma_detalles\": [{\"id\": 13, \"total\": \"200.00\", \"precio\": \"200.00\", \"cantidad\": 1, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"200.00\", \"created_at\": \"2026-09-16T18:46:11.000000Z\", \"updated_at\": \"2026-09-16T18:46:11.000000Z\", \"producto_id\": 2, \"proforma_id\": 5, \"precio_final\": \"200.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}, {\"id\": 14, \"total\": \"2100.00\", \"precio\": \"350.00\", \"cantidad\": 6, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"2100.00\", \"created_at\": \"2026-09-16T18:46:11.000000Z\", \"updated_at\": \"2026-09-16T18:46:11.000000Z\", \"producto_id\": 3, \"proforma_id\": 5, \"precio_final\": \"350.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"tipo_documento_id\": 1, \"porcentaje_descuento\": 0}', '{\"id\": 5, \"hora\": \"14:46:11\", \"fecha\": \"2026-09-16\", \"saldo\": \"800.00\", \"total\": \"3100.00\", \"nit_ci\": \"3433333\", \"status\": 1, \"user_id\": 1, \"subtotal\": \"3100.00\", \"cancelado\": \"2300.00\", \"descuento\": \"0.00\", \"almacen_id\": 1, \"cliente_id\": 4, \"created_at\": \"2026-09-16T18:46:11.000000Z\", \"updated_at\": \"2026-09-16T18:46:34.000000Z\", \"sucursal_id\": 1, \"fecha_registro\": \"2026-09-16\", \"codigo_proforma\": \"P5\", \"proforma_detalles\": [{\"id\": 13, \"total\": \"1000.00\", \"precio\": \"200.00\", \"cantidad\": 5, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"1000.00\", \"created_at\": \"2026-09-16T18:46:11.000000Z\", \"updated_at\": \"2026-09-16T18:46:34.000000Z\", \"producto_id\": 2, \"proforma_id\": 5, \"precio_final\": \"200.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}, {\"id\": 14, \"total\": \"2100.00\", \"precio\": \"350.00\", \"cantidad\": 6, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"2100.00\", \"created_at\": \"2026-09-16T18:46:11.000000Z\", \"updated_at\": \"2026-09-16T18:46:11.000000Z\", \"producto_id\": 3, \"proforma_id\": 5, \"precio_final\": \"350.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"tipo_documento_id\": 1, \"porcentaje_descuento\": \"0\"}', 'PROFORMAS', '2026-09-16', '14:46:34', '2026-09-16 18:46:34', '2026-09-16 18:46:34'),
(140, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA INGRESO DE PRODUCTO', '{\"id\": 14, \"saldo\": \"600.00\", \"total\": \"600.00\", \"codigo\": \"L-00014\", \"user_id\": 1, \"cancelado\": \"0\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T18:47:03.000000Z\", \"updated_at\": \"2026-09-16T18:47:03.000000Z\", \"descripcion\": \"\", \"sucursal_id\": 1, \"tipo_compra\": \"CRÉDITO\", \"proveedor_id\": \"1\", \"fecha_registro\": \"2026-09-16\", \"tipo_ingreso_id\": \"1\", \"ingreso_detalles\": [{\"id\": 15, \"costo\": \"300.00\", \"cantidad\": 2, \"repuesto\": 0, \"subtotal\": \"600.00\", \"faltantes\": null, \"created_at\": \"2026-09-16T18:47:03.000000Z\", \"updated_at\": \"2026-09-16T18:47:03.000000Z\", \"verificado\": null, \"observacion\": null, \"producto_id\": 3, \"cantidad_fisica\": null, \"tipo_ingreso_id\": 1, \"ingreso_producto_id\": 14}]}', NULL, 'INGRESO DE PRODUCTOS', '2026-09-16', '14:47:03', '2026-09-16 18:47:03', '2026-09-16 18:47:03'),
(141, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UNA VENTA', '{\"id\": 16, \"hora\": \"14:45:46\", \"fecha\": \"2026-09-16\", \"saldo\": \"550.00\", \"total\": \"550.00\", \"nit_ci\": \"123456-CM\", \"status\": 1, \"user_id\": 1, \"subtotal\": \"550.00\", \"cancelado\": \"0.00\", \"descuento\": \"0.00\", \"tipo_pago\": null, \"almacen_id\": 1, \"cliente_id\": 1, \"created_at\": \"2026-09-16T18:45:46.000000Z\", \"tipo_venta\": \"CRÉDITO\", \"updated_at\": \"2026-09-16T18:45:46.000000Z\", \"sucursal_id\": 1, \"codigo_venta\": \"V16\", \"fecha_registro\": \"2026-09-16\", \"venta_detalles\": [{\"id\": 18, \"total\": \"200.00\", \"precio\": \"200.00\", \"status\": 1, \"cantidad\": 1, \"venta_id\": 16, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"200.00\", \"created_at\": \"2026-09-16T18:45:46.000000Z\", \"updated_at\": \"2026-09-16T18:45:46.000000Z\", \"producto_id\": 2, \"precio_final\": \"200.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}, {\"id\": 19, \"total\": \"350.00\", \"precio\": \"350.00\", \"status\": 1, \"cantidad\": 1, \"venta_id\": 16, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"350.00\", \"created_at\": \"2026-09-16T18:45:46.000000Z\", \"updated_at\": \"2026-09-16T18:45:46.000000Z\", \"producto_id\": 3, \"precio_final\": \"350.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"tipo_documento_id\": 1, \"porcentaje_descuento\": 0}', '{\"id\": 16, \"hora\": \"14:45:46\", \"fecha\": \"2026-09-16\", \"saldo\": \"750.00\", \"total\": \"750.00\", \"nit_ci\": \"123456-CM\", \"status\": 1, \"user_id\": 1, \"subtotal\": \"750.00\", \"cancelado\": \"0.00\", \"descuento\": \"0.00\", \"tipo_pago\": null, \"almacen_id\": 1, \"cliente_id\": 1, \"created_at\": \"2026-09-16T18:45:46.000000Z\", \"tipo_venta\": \"CRÉDITO\", \"updated_at\": \"2026-09-16T18:49:44.000000Z\", \"sucursal_id\": 1, \"codigo_venta\": \"V16\", \"fecha_registro\": \"2026-09-16\", \"venta_detalles\": [{\"id\": 18, \"total\": \"400.00\", \"precio\": \"200.00\", \"status\": 1, \"cantidad\": 2, \"venta_id\": 16, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"400.00\", \"created_at\": \"2026-09-16T18:45:46.000000Z\", \"updated_at\": \"2026-09-16T18:49:44.000000Z\", \"producto_id\": 2, \"precio_final\": \"200.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}, {\"id\": 19, \"total\": \"350.00\", \"precio\": \"350.00\", \"status\": 1, \"cantidad\": 1, \"venta_id\": 16, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"350.00\", \"created_at\": \"2026-09-16T18:45:46.000000Z\", \"updated_at\": \"2026-09-16T18:45:46.000000Z\", \"producto_id\": 3, \"precio_final\": \"350.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"tipo_documento_id\": 1, \"porcentaje_descuento\": \"0\"}', 'VENTAS', '2026-09-16', '14:49:44', '2026-09-16 18:49:44', '2026-09-16 18:49:44'),
(142, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UNA VENTA', '{\"id\": 16, \"hora\": \"14:45:46\", \"fecha\": \"2026-09-16\", \"saldo\": \"750.00\", \"total\": \"750.00\", \"nit_ci\": \"123456-CM\", \"status\": 1, \"user_id\": 1, \"subtotal\": \"750.00\", \"cancelado\": \"0.00\", \"descuento\": \"0.00\", \"tipo_pago\": null, \"almacen_id\": 1, \"cliente_id\": 1, \"created_at\": \"2026-09-16T18:45:46.000000Z\", \"tipo_venta\": \"CRÉDITO\", \"updated_at\": \"2026-09-16T18:49:44.000000Z\", \"sucursal_id\": 1, \"codigo_venta\": \"V16\", \"fecha_registro\": \"2026-09-16\", \"venta_detalles\": [{\"id\": 18, \"total\": \"400.00\", \"precio\": \"200.00\", \"status\": 1, \"cantidad\": 2, \"venta_id\": 16, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"400.00\", \"created_at\": \"2026-09-16T18:45:46.000000Z\", \"updated_at\": \"2026-09-16T18:49:44.000000Z\", \"producto_id\": 2, \"precio_final\": \"200.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}, {\"id\": 19, \"total\": \"350.00\", \"precio\": \"350.00\", \"status\": 1, \"cantidad\": 1, \"venta_id\": 16, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"350.00\", \"created_at\": \"2026-09-16T18:45:46.000000Z\", \"updated_at\": \"2026-09-16T18:45:46.000000Z\", \"producto_id\": 3, \"precio_final\": \"350.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"tipo_documento_id\": 1, \"porcentaje_descuento\": 0}', '{\"id\": 16, \"hora\": \"14:45:46\", \"fecha\": \"2026-09-16\", \"saldo\": \"950.00\", \"total\": \"950.00\", \"nit_ci\": \"123456-CM\", \"status\": 1, \"user_id\": 1, \"subtotal\": \"950.00\", \"cancelado\": \"0.00\", \"descuento\": \"0.00\", \"tipo_pago\": null, \"almacen_id\": 1, \"cliente_id\": 1, \"created_at\": \"2026-09-16T18:45:46.000000Z\", \"tipo_venta\": \"CRÉDITO\", \"updated_at\": \"2026-09-16T18:50:00.000000Z\", \"sucursal_id\": 1, \"codigo_venta\": \"V16\", \"fecha_registro\": \"2026-09-16\", \"venta_detalles\": [{\"id\": 18, \"total\": \"600.00\", \"precio\": \"200.00\", \"status\": 1, \"cantidad\": 3, \"venta_id\": 16, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"600.00\", \"created_at\": \"2026-09-16T18:45:46.000000Z\", \"updated_at\": \"2026-09-16T18:50:00.000000Z\", \"producto_id\": 2, \"precio_final\": \"200.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}, {\"id\": 19, \"total\": \"350.00\", \"precio\": \"350.00\", \"status\": 1, \"cantidad\": 1, \"venta_id\": 16, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"350.00\", \"created_at\": \"2026-09-16T18:45:46.000000Z\", \"updated_at\": \"2026-09-16T18:45:46.000000Z\", \"producto_id\": 3, \"precio_final\": \"350.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"tipo_documento_id\": 1, \"porcentaje_descuento\": \"0\"}', 'VENTAS', '2026-09-16', '14:50:00', '2026-09-16 18:50:00', '2026-09-16 18:50:00'),
(143, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN INGRESO DE BS. 10 EN LA SUCURSAL SUCURSAL CENTRAL; almacén ALMACEN CENTRAL', '{\"id\": 28, \"hora\": \"14:50:35\", \"tipo\": \"COBRO POR VENTA DE PRODUCTOS\", \"fecha\": \"2026-09-16\", \"monto\": \"10\", \"modulo\": \"VentaCobro\", \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T18:50:35.000000Z\", \"updated_at\": \"2026-09-16T18:50:35.000000Z\", \"descripcion\": \"COBRO POR VENTA DE PRODUCTOS\", \"registro_id\": 8, \"sucursal_id\": 1, \"tipo_movimiento\": \"INGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-16', '14:50:35', '2026-09-16 18:50:35', '2026-09-16 18:50:35'),
(144, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 8, \"hora\": \"14:50:35\", \"fecha\": \"2026-09-16\", \"monto\": \"10\", \"saldo\": 0, \"user_id\": 1, \"venta_id\": 16, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 1, \"created_at\": \"2026-09-16T18:50:35.000000Z\", \"updated_at\": \"2026-09-16T18:50:35.000000Z\", \"sucursal_id\": 1}', NULL, 'COBROS DE CRÉDITOS POR VENTAS', '2026-09-16', '14:50:35', '2026-09-16 18:50:35', '2026-09-16 18:50:35'),
(145, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN INGRESO DE BS. 550.00 EN LA SUCURSAL SUCURSAL 2; almacén ALMACEN 2', '{\"id\": 29, \"hora\": \"10:41:26\", \"tipo\": \"VENTA\", \"fecha\": \"2026-09-15\", \"monto\": \"550.00\", \"modulo\": \"Venta\", \"user_id\": 1, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 3, \"created_at\": \"2026-09-16T19:05:17.000000Z\", \"updated_at\": \"2026-09-16T19:05:17.000000Z\", \"descripcion\": \"INGRESO POR VENTA\", \"registro_id\": 14, \"sucursal_id\": 3, \"tipo_movimiento\": \"INGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-16', '15:05:17', '2026-09-16 19:05:17', '2026-09-16 19:05:17'),
(146, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UNA VENTA', '{\"id\": 14, \"hora\": \"10:41:26\", \"fecha\": \"2026-09-15\", \"saldo\": \"0.00\", \"total\": \"590.00\", \"nit_ci\": \"43343434\", \"status\": 1, \"user_id\": 1, \"subtotal\": \"590.00\", \"cancelado\": \"590.00\", \"descuento\": \"0.00\", \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 3, \"cliente_id\": 5, \"created_at\": \"2026-09-15T14:41:26.000000Z\", \"tipo_venta\": \"AL CONTADO\", \"updated_at\": \"2026-09-16T14:31:22.000000Z\", \"sucursal_id\": 3, \"codigo_venta\": \"V14\", \"fecha_registro\": \"2026-09-15\", \"venta_detalles\": [], \"tipo_documento_id\": 1, \"porcentaje_descuento\": 0}', '{\"id\": 14, \"hora\": \"10:41:26\", \"fecha\": \"2026-09-15\", \"saldo\": \"0.00\", \"total\": \"550.00\", \"nit_ci\": \"43343434\", \"status\": 1, \"user_id\": 1, \"subtotal\": \"550.00\", \"cancelado\": \"550.00\", \"descuento\": \"0.00\", \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 3, \"cliente_id\": 5, \"created_at\": \"2026-09-15T14:41:26.000000Z\", \"tipo_venta\": \"AL CONTADO\", \"updated_at\": \"2026-09-16T19:05:17.000000Z\", \"sucursal_id\": 3, \"codigo_venta\": \"V14\", \"fecha_registro\": \"2026-09-15\", \"venta_detalles\": [{\"id\": 22, \"total\": \"200.00\", \"precio\": \"200.00\", \"status\": 1, \"cantidad\": 1, \"venta_id\": 14, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"200.00\", \"created_at\": \"2026-09-16T19:05:17.000000Z\", \"updated_at\": \"2026-09-16T19:05:17.000000Z\", \"producto_id\": 2, \"precio_final\": \"200.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}, {\"id\": 23, \"total\": \"350.00\", \"precio\": \"350.00\", \"status\": 1, \"cantidad\": 1, \"venta_id\": 14, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"350.00\", \"created_at\": \"2026-09-16T19:05:17.000000Z\", \"updated_at\": \"2026-09-16T19:05:17.000000Z\", \"producto_id\": 3, \"precio_final\": \"350.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"tipo_documento_id\": 1, \"porcentaje_descuento\": \"0\"}', 'VENTAS', '2026-09-16', '15:05:17', '2026-09-16 19:05:17', '2026-09-16 19:05:17'),
(147, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN TRASPASO DE PRODUCTOS DE ALMACEN CENTRAL A ALMACEN 2', '{\"id\": 9, \"user_id\": 1, \"cantidad\": \"10\", \"created_at\": \"2026-09-16T19:49:39.000000Z\", \"updated_at\": \"2026-09-16T19:49:39.000000Z\", \"descripcion\": \"TRASPASO 10 PRODUCTOS A ALMACEN 2\", \"fecha_registro\": \"2026-09-16\", \"almacen_origen_id\": 1, \"traspaso_detalles\": [{\"id\": 19, \"cantidad\": 10, \"created_at\": \"2026-09-16T19:49:39.000000Z\", \"updated_at\": \"2026-09-16T19:49:39.000000Z\", \"observacion\": null, \"producto_id\": 3, \"traspaso_id\": 9}], \"almacen_destino_id\": 3, \"sucursal_origen_id\": 1, \"sucursal_destino_id\": 3}', NULL, 'TRASPASOS DE PRODUCTOS', '2026-09-16', '15:49:39', '2026-09-16 19:49:39', '2026-09-16 19:49:39'),
(148, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UNA SUCURSAL', '{\"id\": 3, \"activo\": 0, \"nombre\": \"SUCURSAL 2\", \"ventas\": 1, \"created_at\": \"2026-07-11T15:33:42.000000Z\", \"updated_at\": \"2026-08-28T15:40:51.000000Z\", \"descripcion\": \"\", \"fecha_registro\": \"2026-07-11\"}', '{\"id\": 3, \"activo\": \"1\", \"nombre\": \"SUCURSAL 2\", \"ventas\": 1, \"created_at\": \"2026-07-11T15:33:42.000000Z\", \"updated_at\": \"2026-09-16T20:14:41.000000Z\", \"descripcion\": \"\", \"fecha_registro\": \"2026-07-11\"}', 'SUCURSALES', '2026-09-16', '16:14:41', '2026-09-16 20:14:41', '2026-09-16 20:14:41'),
(149, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UNA SUCURSAL', '{\"id\": 3, \"activo\": 1, \"nombre\": \"SUCURSAL 2\", \"ventas\": 1, \"created_at\": \"2026-07-11T15:33:42.000000Z\", \"updated_at\": \"2026-09-16T20:14:41.000000Z\", \"descripcion\": \"\", \"fecha_registro\": \"2026-07-11\"}', '{\"id\": 3, \"activo\": \"0\", \"nombre\": \"SUCURSAL 2\", \"ventas\": 1, \"created_at\": \"2026-07-11T15:33:42.000000Z\", \"updated_at\": \"2026-09-16T20:14:45.000000Z\", \"descripcion\": \"\", \"fecha_registro\": \"2026-07-11\"}', 'SUCURSALES', '2026-09-16', '16:14:45', '2026-09-16 20:14:45', '2026-09-16 20:14:45'),
(150, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UNA SUCURSAL', '{\"id\": 3, \"activo\": 0, \"nombre\": \"SUCURSAL 2\", \"ventas\": 1, \"created_at\": \"2026-07-11T15:33:42.000000Z\", \"updated_at\": \"2026-09-16T20:14:45.000000Z\", \"descripcion\": \"\", \"fecha_registro\": \"2026-07-11\"}', '{\"id\": 3, \"activo\": \"1\", \"nombre\": \"SUCURSAL 2\", \"ventas\": 1, \"created_at\": \"2026-07-11T15:33:42.000000Z\", \"updated_at\": \"2026-09-16T20:21:56.000000Z\", \"descripcion\": \"\", \"fecha_registro\": \"2026-07-11\"}', 'SUCURSALES', '2026-09-16', '16:21:56', '2026-09-16 20:21:56', '2026-09-16 20:21:56'),
(151, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN INGRESO DE BS. 40 EN LA SUCURSAL SUCURSAL CENTRAL; almacén ALMACEN CENTRAL', '{\"id\": 31, \"hora\": \"16:57:29\", \"tipo\": \"MOVIMIENTO DE CAJA\", \"fecha\": \"2026-09-16\", \"modulo\": \"MovimientoCaja\", \"user_id\": 1, \"monto_qr\": \"20\", \"tipo_pago\": \"EFECTIVO-QR\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T20:58:56.000000Z\", \"updated_at\": \"2026-09-16T20:58:56.000000Z\", \"descripcion\": \"ingreso mixto\", \"monto_total\": 40, \"registro_id\": 31, \"sucursal_id\": 1, \"monto_efectivo\": \"20\", \"tipo_movimiento\": \"INGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-16', '16:58:56', '2026-09-16 20:58:56', '2026-09-16 20:58:56'),
(152, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN EGRESO DE BS. 240 EN LA SUCURSAL SUCURSAL CENTRAL; almacén ALMACEN CENTRAL', '{\"id\": 32, \"hora\": \"17:08:19\", \"tipo\": \"COMPRA DE PRODUCTOS\", \"fecha\": \"2026-09-16\", \"modulo\": \"IngresoProducto\", \"user_id\": 1, \"monto_qr\": \"40\", \"tipo_pago\": \"EFECTIVO-QR\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T21:08:19.000000Z\", \"updated_at\": \"2026-09-16T21:08:19.000000Z\", \"descripcion\": \"COMPRA DE PRODUCTOS\", \"monto_total\": 240, \"registro_id\": 16, \"sucursal_id\": 1, \"monto_efectivo\": \"200\", \"tipo_movimiento\": \"EGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-16', '17:08:19', '2026-09-16 21:08:19', '2026-09-16 21:08:19'),
(153, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA INGRESO DE PRODUCTO', '{\"id\": 16, \"saldo\": \"0.00\", \"total\": \"240.00\", \"codigo\": \"L-00016\", \"user_id\": 1, \"almacen_id\": 1, \"created_at\": \"2026-09-16T21:08:19.000000Z\", \"updated_at\": \"2026-09-16T21:08:19.000000Z\", \"descripcion\": \"\", \"sucursal_id\": 1, \"tipo_compra\": \"CONTADO,\", \"cancelado_qr\": \"40\", \"proveedor_id\": \"3\", \"fecha_registro\": \"2026-09-16\", \"tipo_ingreso_id\": \"1\", \"total_cancelado\": 240, \"ingreso_detalles\": [{\"id\": 17, \"costo\": \"120.00\", \"cantidad\": 2, \"repuesto\": 0, \"subtotal\": \"240.00\", \"faltantes\": null, \"created_at\": \"2026-09-16T21:08:19.000000Z\", \"updated_at\": \"2026-09-16T21:08:19.000000Z\", \"verificado\": null, \"observacion\": null, \"producto_id\": 2, \"cantidad_fisica\": null, \"tipo_ingreso_id\": 1, \"ingreso_producto_id\": 16}], \"cancelado_efectivo\": \"200\"}', NULL, 'INGRESO DE PRODUCTOS', '2026-09-16', '17:08:19', '2026-09-16 21:08:19', '2026-09-16 21:08:19'),
(154, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA INGRESO DE PRODUCTO', '{\"id\": 17, \"saldo\": \"600.00\", \"total\": \"600.00\", \"codigo\": \"L-00017\", \"user_id\": 1, \"almacen_id\": 1, \"created_at\": \"2026-09-16T21:09:03.000000Z\", \"updated_at\": \"2026-09-16T21:09:03.000000Z\", \"descripcion\": \"\", \"sucursal_id\": 1, \"tipo_compra\": \"CRÉDITO\", \"cancelado_qr\": \"0\", \"proveedor_id\": \"1\", \"fecha_registro\": \"2026-09-16\", \"tipo_ingreso_id\": \"2\", \"total_cancelado\": 0, \"ingreso_detalles\": [{\"id\": 18, \"costo\": \"300.00\", \"cantidad\": 2, \"repuesto\": 0, \"subtotal\": \"600.00\", \"faltantes\": null, \"created_at\": \"2026-09-16T21:09:03.000000Z\", \"updated_at\": \"2026-09-16T21:09:03.000000Z\", \"verificado\": null, \"observacion\": null, \"producto_id\": 4, \"cantidad_fisica\": null, \"tipo_ingreso_id\": 2, \"ingreso_producto_id\": 17}], \"cancelado_efectivo\": \"0\"}', NULL, 'INGRESO DE PRODUCTOS', '2026-09-16', '17:09:03', '2026-09-16 21:09:03', '2026-09-16 21:09:03'),
(155, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN INGRESO DE BS. 550 EN LA SUCURSAL SUCURSAL CENTRAL; almacén ALMACEN CENTRAL', '{\"id\": 33, \"hora\": \"17:22:14\", \"tipo\": \"VENTA\", \"fecha\": \"2026-09-16\", \"modulo\": \"Venta\", \"user_id\": 1, \"monto_qr\": \"50\", \"tipo_pago\": \"EFECTIVO-QR\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T21:22:14.000000Z\", \"updated_at\": \"2026-09-16T21:22:14.000000Z\", \"descripcion\": \"INGRESO POR VENTA\", \"monto_total\": 550, \"registro_id\": 17, \"sucursal_id\": 1, \"monto_efectivo\": \"500\", \"tipo_movimiento\": \"INGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-16', '17:22:14', '2026-09-16 21:22:14', '2026-09-16 21:22:14');
INSERT INTO `historial_accions` (`id`, `user_id`, `accion`, `descripcion`, `datos_original`, `datos_nuevo`, `modulo`, `fecha`, `hora`, `created_at`, `updated_at`) VALUES
(156, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA VENTA', '{\"id\": 17, \"hora\": \"17:22:14\", \"fecha\": \"2026-09-16\", \"saldo\": \"0.00\", \"total\": \"550.00\", \"nit_ci\": \"32233\", \"user_id\": 1, \"subtotal\": \"550.00\", \"descuento\": \"0\", \"tipo_pago\": \"EFECTIVO-QR\", \"almacen_id\": 1, \"cliente_id\": 6, \"created_at\": \"2026-09-16T21:22:14.000000Z\", \"tipo_venta\": \"AL CONTADO\", \"updated_at\": \"2026-09-16T21:22:14.000000Z\", \"sucursal_id\": 1, \"cancelado_qr\": \"50\", \"codigo_venta\": \"V17\", \"fecha_registro\": \"2026-09-16\", \"venta_detalles\": [{\"id\": 24, \"total\": \"200.00\", \"precio\": \"200.00\", \"status\": 1, \"cantidad\": 1, \"venta_id\": 17, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"200.00\", \"created_at\": \"2026-09-16T21:22:14.000000Z\", \"updated_at\": \"2026-09-16T21:22:14.000000Z\", \"producto_id\": 2, \"precio_final\": \"200.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}, {\"id\": 25, \"total\": \"350.00\", \"precio\": \"350.00\", \"status\": 1, \"cantidad\": 1, \"venta_id\": 17, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"350.00\", \"created_at\": \"2026-09-16T21:22:14.000000Z\", \"updated_at\": \"2026-09-16T21:22:14.000000Z\", \"producto_id\": 3, \"precio_final\": \"350.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"total_cancelado\": 550, \"tipo_documento_id\": 1, \"cancelado_efectivo\": \"500\", \"porcentaje_descuento\": 0}', NULL, 'VENTAS', '2026-09-16', '17:22:14', '2026-09-16 21:22:14', '2026-09-16 21:22:14'),
(157, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN INGRESO DE BS. 750 EN LA SUCURSAL SUCURSAL CENTRAL; almacén ALMACEN CENTRAL', '{\"id\": 34, \"hora\": \"17:22:14\", \"tipo\": \"VENTA\", \"fecha\": \"2026-09-16\", \"modulo\": \"Venta\", \"user_id\": 1, \"monto_qr\": \"250\", \"tipo_pago\": \"EFECTIVO-QR\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T21:24:58.000000Z\", \"updated_at\": \"2026-09-16T21:24:58.000000Z\", \"descripcion\": \"INGRESO POR VENTA\", \"monto_total\": 750, \"registro_id\": 17, \"sucursal_id\": 1, \"monto_efectivo\": \"500.00\", \"tipo_movimiento\": \"INGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-16', '17:24:58', '2026-09-16 21:24:58', '2026-09-16 21:24:58'),
(158, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UNA VENTA', '{\"id\": 17, \"hora\": \"17:22:14\", \"fecha\": \"2026-09-16\", \"saldo\": \"0.00\", \"total\": \"550.00\", \"nit_ci\": \"32233\", \"status\": 1, \"user_id\": 1, \"subtotal\": \"550.00\", \"descuento\": \"0.00\", \"tipo_pago\": \"EFECTIVO-QR\", \"almacen_id\": 1, \"cliente_id\": 6, \"created_at\": \"2026-09-16T21:22:14.000000Z\", \"tipo_venta\": \"AL CONTADO\", \"updated_at\": \"2026-09-16T21:22:14.000000Z\", \"sucursal_id\": 1, \"cancelado_qr\": \"50.00\", \"codigo_venta\": \"V17\", \"fecha_registro\": \"2026-09-16\", \"venta_detalles\": [{\"id\": 24, \"total\": \"200.00\", \"precio\": \"200.00\", \"status\": 1, \"cantidad\": 1, \"venta_id\": 17, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"200.00\", \"created_at\": \"2026-09-16T21:22:14.000000Z\", \"updated_at\": \"2026-09-16T21:22:14.000000Z\", \"producto_id\": 2, \"precio_final\": \"200.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}, {\"id\": 25, \"total\": \"350.00\", \"precio\": \"350.00\", \"status\": 1, \"cantidad\": 1, \"venta_id\": 17, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"350.00\", \"created_at\": \"2026-09-16T21:22:14.000000Z\", \"updated_at\": \"2026-09-16T21:22:14.000000Z\", \"producto_id\": 3, \"precio_final\": \"350.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"total_cancelado\": \"550.00\", \"tipo_documento_id\": 1, \"cancelado_efectivo\": \"500.00\", \"porcentaje_descuento\": 0}', '{\"id\": 17, \"hora\": \"17:22:14\", \"fecha\": \"2026-09-16\", \"saldo\": \"0.00\", \"total\": \"750.00\", \"nit_ci\": \"32233\", \"status\": 1, \"user_id\": 1, \"subtotal\": \"750.00\", \"descuento\": \"0.00\", \"tipo_pago\": \"EFECTIVO-QR\", \"almacen_id\": 1, \"cliente_id\": 6, \"created_at\": \"2026-09-16T21:22:14.000000Z\", \"tipo_venta\": \"AL CONTADO\", \"updated_at\": \"2026-09-16T21:24:58.000000Z\", \"sucursal_id\": 1, \"cancelado_qr\": \"250\", \"codigo_venta\": \"V17\", \"fecha_registro\": \"2026-09-16\", \"venta_detalles\": [{\"id\": 24, \"total\": \"200.00\", \"precio\": \"200.00\", \"status\": 1, \"cantidad\": 1, \"venta_id\": 17, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"200.00\", \"created_at\": \"2026-09-16T21:22:14.000000Z\", \"updated_at\": \"2026-09-16T21:22:14.000000Z\", \"producto_id\": 2, \"precio_final\": \"200.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}, {\"id\": 25, \"total\": \"350.00\", \"precio\": \"350.00\", \"status\": 1, \"cantidad\": 1, \"venta_id\": 17, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"350.00\", \"created_at\": \"2026-09-16T21:22:14.000000Z\", \"updated_at\": \"2026-09-16T21:22:14.000000Z\", \"producto_id\": 3, \"precio_final\": \"350.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}, {\"id\": 26, \"total\": \"200.00\", \"precio\": \"200.00\", \"status\": 1, \"cantidad\": 1, \"venta_id\": 17, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"200.00\", \"created_at\": \"2026-09-16T21:24:58.000000Z\", \"updated_at\": \"2026-09-16T21:24:58.000000Z\", \"producto_id\": 6, \"precio_final\": \"200.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"total_cancelado\": 750, \"tipo_documento_id\": 1, \"cancelado_efectivo\": \"500.00\", \"porcentaje_descuento\": \"0\"}', 'VENTAS', '2026-09-16', '17:24:58', '2026-09-16 21:24:58', '2026-09-16 21:24:58'),
(159, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN INGRESO DE BS. 250 EN LA SUCURSAL SUCURSAL CENTRAL; almacén ALMACEN CENTRAL', '{\"id\": 35, \"hora\": \"17:22:14\", \"tipo\": \"VENTA\", \"fecha\": \"2026-09-16\", \"modulo\": \"Venta\", \"user_id\": 1, \"monto_qr\": \"250.00\", \"tipo_pago\": \"QR\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T21:25:13.000000Z\", \"updated_at\": \"2026-09-16T21:25:13.000000Z\", \"descripcion\": \"INGRESO POR VENTA\", \"monto_total\": 250, \"registro_id\": 17, \"sucursal_id\": 1, \"monto_efectivo\": \"0\", \"tipo_movimiento\": \"INGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-16', '17:25:13', '2026-09-16 21:25:13', '2026-09-16 21:25:13'),
(160, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UNA VENTA', '{\"id\": 17, \"hora\": \"17:22:14\", \"fecha\": \"2026-09-16\", \"saldo\": \"0.00\", \"total\": \"750.00\", \"nit_ci\": \"32233\", \"status\": 1, \"user_id\": 1, \"subtotal\": \"750.00\", \"descuento\": \"0.00\", \"tipo_pago\": \"EFECTIVO-QR\", \"almacen_id\": 1, \"cliente_id\": 6, \"created_at\": \"2026-09-16T21:22:14.000000Z\", \"tipo_venta\": \"AL CONTADO\", \"updated_at\": \"2026-09-16T21:24:58.000000Z\", \"sucursal_id\": 1, \"cancelado_qr\": \"250.00\", \"codigo_venta\": \"V17\", \"fecha_registro\": \"2026-09-16\", \"venta_detalles\": [{\"id\": 24, \"total\": \"200.00\", \"precio\": \"200.00\", \"status\": 1, \"cantidad\": 1, \"venta_id\": 17, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"200.00\", \"created_at\": \"2026-09-16T21:22:14.000000Z\", \"updated_at\": \"2026-09-16T21:22:14.000000Z\", \"producto_id\": 2, \"precio_final\": \"200.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}, {\"id\": 25, \"total\": \"350.00\", \"precio\": \"350.00\", \"status\": 1, \"cantidad\": 1, \"venta_id\": 17, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"350.00\", \"created_at\": \"2026-09-16T21:22:14.000000Z\", \"updated_at\": \"2026-09-16T21:22:14.000000Z\", \"producto_id\": 3, \"precio_final\": \"350.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}, {\"id\": 26, \"total\": \"200.00\", \"precio\": \"200.00\", \"status\": 1, \"cantidad\": 1, \"venta_id\": 17, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"200.00\", \"created_at\": \"2026-09-16T21:24:58.000000Z\", \"updated_at\": \"2026-09-16T21:24:58.000000Z\", \"producto_id\": 6, \"precio_final\": \"200.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"total_cancelado\": \"750.00\", \"tipo_documento_id\": 1, \"cancelado_efectivo\": \"500.00\", \"porcentaje_descuento\": 0}', '{\"id\": 17, \"hora\": \"17:22:14\", \"fecha\": \"2026-09-16\", \"saldo\": \"500.00\", \"total\": \"750.00\", \"nit_ci\": \"32233\", \"status\": 1, \"user_id\": 1, \"subtotal\": \"750.00\", \"descuento\": \"0.00\", \"tipo_pago\": \"QR\", \"almacen_id\": 1, \"cliente_id\": 6, \"created_at\": \"2026-09-16T21:22:14.000000Z\", \"tipo_venta\": \"CRÉDITO\", \"updated_at\": \"2026-09-16T21:25:13.000000Z\", \"sucursal_id\": 1, \"cancelado_qr\": \"250.00\", \"codigo_venta\": \"V17\", \"fecha_registro\": \"2026-09-16\", \"venta_detalles\": [{\"id\": 24, \"total\": \"200.00\", \"precio\": \"200.00\", \"status\": 1, \"cantidad\": 1, \"venta_id\": 17, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"200.00\", \"created_at\": \"2026-09-16T21:22:14.000000Z\", \"updated_at\": \"2026-09-16T21:22:14.000000Z\", \"producto_id\": 2, \"precio_final\": \"200.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}, {\"id\": 25, \"total\": \"350.00\", \"precio\": \"350.00\", \"status\": 1, \"cantidad\": 1, \"venta_id\": 17, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"350.00\", \"created_at\": \"2026-09-16T21:22:14.000000Z\", \"updated_at\": \"2026-09-16T21:22:14.000000Z\", \"producto_id\": 3, \"precio_final\": \"350.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}, {\"id\": 26, \"total\": \"200.00\", \"precio\": \"200.00\", \"status\": 1, \"cantidad\": 1, \"venta_id\": 17, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"200.00\", \"created_at\": \"2026-09-16T21:24:58.000000Z\", \"updated_at\": \"2026-09-16T21:24:58.000000Z\", \"producto_id\": 6, \"precio_final\": \"200.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"total_cancelado\": 250, \"tipo_documento_id\": 1, \"cancelado_efectivo\": \"0\", \"porcentaje_descuento\": \"0\"}', 'VENTAS', '2026-09-16', '17:25:13', '2026-09-16 21:25:13', '2026-09-16 21:25:13'),
(161, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN INGRESO DE BS. 550 EN LA SUCURSAL SUCURSAL 2; almacén ALMACEN 2', '{\"id\": 36, \"hora\": \"10:41:26\", \"tipo\": \"VENTA\", \"fecha\": \"2026-09-15\", \"modulo\": \"Venta\", \"user_id\": 1, \"monto_qr\": \"50\", \"tipo_pago\": \"EFECTIVO-QR\", \"almacen_id\": 3, \"created_at\": \"2026-09-16T21:25:32.000000Z\", \"updated_at\": \"2026-09-16T21:25:32.000000Z\", \"descripcion\": \"INGRESO POR VENTA\", \"monto_total\": 550, \"registro_id\": 14, \"sucursal_id\": 3, \"monto_efectivo\": \"500\", \"tipo_movimiento\": \"INGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-16', '17:25:32', '2026-09-16 21:25:32', '2026-09-16 21:25:32'),
(162, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UNA VENTA', '{\"id\": 14, \"hora\": \"10:41:26\", \"fecha\": \"2026-09-15\", \"saldo\": \"0.00\", \"total\": \"550.00\", \"nit_ci\": \"43343434\", \"status\": 1, \"user_id\": 1, \"subtotal\": \"550.00\", \"descuento\": \"0.00\", \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 3, \"cliente_id\": 5, \"created_at\": \"2026-09-15T14:41:26.000000Z\", \"tipo_venta\": \"AL CONTADO\", \"updated_at\": \"2026-09-16T19:05:17.000000Z\", \"sucursal_id\": 3, \"cancelado_qr\": \"0.00\", \"codigo_venta\": \"V14\", \"fecha_registro\": \"2026-09-15\", \"venta_detalles\": [{\"id\": 22, \"total\": \"200.00\", \"precio\": \"200.00\", \"status\": 1, \"cantidad\": 1, \"venta_id\": 14, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"200.00\", \"created_at\": \"2026-09-16T19:05:17.000000Z\", \"updated_at\": \"2026-09-16T19:05:17.000000Z\", \"producto_id\": 2, \"precio_final\": \"200.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}, {\"id\": 23, \"total\": \"350.00\", \"precio\": \"350.00\", \"status\": 1, \"cantidad\": 1, \"venta_id\": 14, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"350.00\", \"created_at\": \"2026-09-16T19:05:17.000000Z\", \"updated_at\": \"2026-09-16T19:05:17.000000Z\", \"producto_id\": 3, \"precio_final\": \"350.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"total_cancelado\": \"550.00\", \"tipo_documento_id\": 1, \"cancelado_efectivo\": \"550.00\", \"porcentaje_descuento\": 0}', '{\"id\": 14, \"hora\": \"10:41:26\", \"fecha\": \"2026-09-15\", \"saldo\": \"0.00\", \"total\": \"550.00\", \"nit_ci\": \"43343434\", \"status\": 1, \"user_id\": 1, \"subtotal\": \"550.00\", \"descuento\": \"0.00\", \"tipo_pago\": \"EFECTIVO-QR\", \"almacen_id\": 3, \"cliente_id\": 5, \"created_at\": \"2026-09-15T14:41:26.000000Z\", \"tipo_venta\": \"AL CONTADO\", \"updated_at\": \"2026-09-16T21:25:32.000000Z\", \"sucursal_id\": 3, \"cancelado_qr\": \"50\", \"codigo_venta\": \"V14\", \"fecha_registro\": \"2026-09-15\", \"venta_detalles\": [{\"id\": 22, \"total\": \"200.00\", \"precio\": \"200.00\", \"status\": 1, \"cantidad\": 1, \"venta_id\": 14, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"200.00\", \"created_at\": \"2026-09-16T19:05:17.000000Z\", \"updated_at\": \"2026-09-16T19:05:17.000000Z\", \"producto_id\": 2, \"precio_final\": \"200.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}, {\"id\": 23, \"total\": \"350.00\", \"precio\": \"350.00\", \"status\": 1, \"cantidad\": 1, \"venta_id\": 14, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"350.00\", \"created_at\": \"2026-09-16T19:05:17.000000Z\", \"updated_at\": \"2026-09-16T19:05:17.000000Z\", \"producto_id\": 3, \"precio_final\": \"350.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"total_cancelado\": 550, \"tipo_documento_id\": 1, \"cancelado_efectivo\": \"500\", \"porcentaje_descuento\": \"0\"}', 'VENTAS', '2026-09-16', '17:25:32', '2026-09-16 21:25:32', '2026-09-16 21:25:32'),
(163, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN INGRESO DE BS. 40 EN LA SUCURSAL SUCURSAL CENTRAL; almacén ALMACEN CENTRAL', '{\"id\": 37, \"hora\": \"17:34:57\", \"tipo\": \"COBRO POR VENTA DE PRODUCTOS\", \"fecha\": \"2026-09-16\", \"modulo\": \"VentaCobro\", \"user_id\": 1, \"monto_qr\": \"20\", \"tipo_pago\": \"EFECTIVO-QR\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T21:34:57.000000Z\", \"updated_at\": \"2026-09-16T21:34:57.000000Z\", \"descripcion\": \"COBRO POR VENTA DE PRODUCTOS\", \"monto_total\": 40, \"registro_id\": 9, \"sucursal_id\": 1, \"monto_efectivo\": \"20\", \"tipo_movimiento\": \"INGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-16', '17:34:57', '2026-09-16 21:34:57', '2026-09-16 21:34:57'),
(164, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 9, \"hora\": \"17:34:57\", \"fecha\": \"2026-09-16\", \"saldo\": 0, \"user_id\": 1, \"monto_qr\": \"20\", \"venta_id\": 15, \"tipo_pago\": \"EFECTIVO-QR\", \"almacen_id\": 1, \"cliente_id\": 2, \"created_at\": \"2026-09-16T21:34:57.000000Z\", \"updated_at\": \"2026-09-16T21:34:57.000000Z\", \"monto_total\": 40, \"sucursal_id\": 1, \"monto_efectivo\": \"20\"}', NULL, 'COBROS DE CRÉDITOS POR VENTAS', '2026-09-16', '17:34:57', '2026-09-16 21:34:57', '2026-09-16 21:34:57'),
(165, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UN PAGO POR VENTA DE PRODUCTOS', '{\"id\": 9, \"hora\": \"17:34:57\", \"fecha\": \"2026-09-16\", \"saldo\": \"0.00\", \"user_id\": 1, \"monto_qr\": \"20.00\", \"venta_id\": 15, \"tipo_pago\": \"EFECTIVO-QR\", \"almacen_id\": 1, \"cliente_id\": 2, \"created_at\": \"2026-09-16T21:34:57.000000Z\", \"updated_at\": \"2026-09-16T21:34:57.000000Z\", \"monto_total\": \"40.00\", \"sucursal_id\": 1, \"monto_efectivo\": \"20.00\"}', '{\"id\": 9, \"hora\": \"17:36:56\", \"fecha\": \"2026-09-16\", \"saldo\": 0, \"user_id\": 1, \"monto_qr\": \"0\", \"venta_id\": 15, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 2, \"created_at\": \"2026-09-16T21:34:57.000000Z\", \"updated_at\": \"2026-09-16T21:36:56.000000Z\", \"monto_total\": 20, \"sucursal_id\": 1, \"monto_efectivo\": \"20.00\"}', 'COBROS DE CRÉDITOS POR VENTAS', '2026-09-16', '17:36:56', '2026-09-16 21:36:56', '2026-09-16 21:36:56'),
(166, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UN PAGO POR VENTA DE PRODUCTOS', '{\"id\": 9, \"hora\": \"17:36:56\", \"fecha\": \"2026-09-16\", \"saldo\": \"0.00\", \"user_id\": 1, \"monto_qr\": \"0.00\", \"venta_id\": 15, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 2, \"created_at\": \"2026-09-16T21:34:57.000000Z\", \"updated_at\": \"2026-09-16T21:36:56.000000Z\", \"monto_total\": \"20.00\", \"sucursal_id\": 1, \"monto_efectivo\": \"20.00\"}', '{\"id\": 9, \"hora\": \"17:37:27\", \"fecha\": \"2026-09-16\", \"saldo\": 0, \"user_id\": 1, \"monto_qr\": \"20.00\", \"venta_id\": 15, \"tipo_pago\": \"EFECTIVO-QR\", \"almacen_id\": 1, \"cliente_id\": 2, \"created_at\": \"2026-09-16T21:34:57.000000Z\", \"updated_at\": \"2026-09-16T21:37:27.000000Z\", \"monto_total\": 40, \"sucursal_id\": 1, \"monto_efectivo\": \"20.00\"}', 'COBROS DE CRÉDITOS POR VENTAS', '2026-09-16', '17:37:27', '2026-09-16 21:37:27', '2026-09-16 21:37:27'),
(167, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UN PAGO POR VENTA DE PRODUCTOS', '{\"id\": 9, \"hora\": \"17:37:27\", \"fecha\": \"2026-09-16\", \"saldo\": \"0.00\", \"user_id\": 1, \"monto_qr\": \"20.00\", \"venta_id\": 15, \"tipo_pago\": \"EFECTIVO-QR\", \"almacen_id\": 1, \"cliente_id\": 2, \"created_at\": \"2026-09-16T21:34:57.000000Z\", \"updated_at\": \"2026-09-16T21:37:27.000000Z\", \"monto_total\": \"40.00\", \"sucursal_id\": 1, \"monto_efectivo\": \"20.00\"}', '{\"id\": 9, \"hora\": \"17:37:43\", \"fecha\": \"2026-09-16\", \"saldo\": 0, \"user_id\": 1, \"monto_qr\": \"20.00\", \"venta_id\": 15, \"tipo_pago\": \"EFECTIVO-QR\", \"almacen_id\": 1, \"cliente_id\": 2, \"created_at\": \"2026-09-16T21:34:57.000000Z\", \"updated_at\": \"2026-09-16T21:37:43.000000Z\", \"monto_total\": 40, \"sucursal_id\": 1, \"monto_efectivo\": \"20.00\"}', 'COBROS DE CRÉDITOS POR VENTAS', '2026-09-16', '17:37:43', '2026-09-16 21:37:43', '2026-09-16 21:37:43'),
(168, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UN PAGO POR VENTA DE PRODUCTOS', '{\"id\": 9, \"hora\": \"17:37:43\", \"fecha\": \"2026-09-16\", \"saldo\": \"0.00\", \"user_id\": 1, \"monto_qr\": \"20.00\", \"venta_id\": 15, \"tipo_pago\": \"EFECTIVO-QR\", \"almacen_id\": 1, \"cliente_id\": 2, \"created_at\": \"2026-09-16T21:34:57.000000Z\", \"updated_at\": \"2026-09-16T21:37:43.000000Z\", \"monto_total\": \"40.00\", \"sucursal_id\": 1, \"monto_efectivo\": \"20.00\"}', '{\"id\": 9, \"hora\": \"17:38:34\", \"fecha\": \"2026-09-16\", \"saldo\": 0, \"user_id\": 1, \"monto_qr\": \"20.00\", \"venta_id\": 15, \"tipo_pago\": \"EFECTIVO-QR\", \"almacen_id\": 1, \"cliente_id\": 2, \"created_at\": \"2026-09-16T21:34:57.000000Z\", \"updated_at\": \"2026-09-16T21:38:34.000000Z\", \"monto_total\": 40, \"sucursal_id\": 1, \"monto_efectivo\": \"20.00\"}', 'COBROS DE CRÉDITOS POR VENTAS', '2026-09-16', '17:38:34', '2026-09-16 21:38:34', '2026-09-16 21:38:34'),
(169, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN INGRESO DE BS. 2000 EN LA SUCURSAL SUCURSAL CENTRAL; almacén ALMACEN CENTRAL', '{\"id\": 38, \"hora\": \"17:38:50\", \"tipo\": \"COBRO POR VENTA DE PRODUCTOS\", \"fecha\": \"2026-09-16\", \"modulo\": \"VentaCobro\", \"user_id\": 1, \"monto_qr\": 0, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T21:38:50.000000Z\", \"updated_at\": \"2026-09-16T21:38:50.000000Z\", \"descripcion\": \"COBRO POR VENTA DE PRODUCTOS\", \"monto_total\": 2000, \"registro_id\": 10, \"sucursal_id\": 1, \"monto_efectivo\": \"2000\", \"tipo_movimiento\": \"INGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-16', '17:38:50', '2026-09-16 21:38:50', '2026-09-16 21:38:50'),
(170, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 10, \"hora\": \"17:38:50\", \"fecha\": \"2026-09-16\", \"saldo\": 0, \"user_id\": 1, \"monto_qr\": 0, \"venta_id\": 15, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 2, \"created_at\": \"2026-09-16T21:38:50.000000Z\", \"updated_at\": \"2026-09-16T21:38:50.000000Z\", \"monto_total\": 2000, \"sucursal_id\": 1, \"monto_efectivo\": \"2000\"}', NULL, 'COBROS DE CRÉDITOS POR VENTAS', '2026-09-16', '17:38:50', '2026-09-16 21:38:50', '2026-09-16 21:38:50'),
(171, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UN PAGO POR VENTA DE PRODUCTOS', '{\"id\": 10, \"hora\": \"17:38:50\", \"fecha\": \"2026-09-16\", \"saldo\": \"0.00\", \"user_id\": 1, \"monto_qr\": \"0.00\", \"venta_id\": 15, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 2, \"created_at\": \"2026-09-16T21:38:50.000000Z\", \"updated_at\": \"2026-09-16T21:38:50.000000Z\", \"monto_total\": \"2000.00\", \"sucursal_id\": 1, \"monto_efectivo\": \"2000.00\"}', '{\"id\": 10, \"hora\": \"17:39:31\", \"fecha\": \"2026-09-16\", \"saldo\": 0, \"user_id\": 1, \"monto_qr\": \"0.00\", \"venta_id\": 15, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 2, \"created_at\": \"2026-09-16T21:38:50.000000Z\", \"updated_at\": \"2026-09-16T21:39:31.000000Z\", \"monto_total\": 20, \"sucursal_id\": 1, \"monto_efectivo\": \"20\"}', 'COBROS DE CRÉDITOS POR VENTAS', '2026-09-16', '17:39:31', '2026-09-16 21:39:31', '2026-09-16 21:39:31'),
(172, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN INGRESO DE BS. 180 EN LA SUCURSAL SUCURSAL CENTRAL; almacén ALMACEN CENTRAL', '{\"id\": 39, \"hora\": \"17:39:52\", \"tipo\": \"COBRO POR VENTA DE PRODUCTOS\", \"fecha\": \"2026-09-16\", \"modulo\": \"VentaCobro\", \"user_id\": 1, \"monto_qr\": 0, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T21:39:52.000000Z\", \"updated_at\": \"2026-09-16T21:39:52.000000Z\", \"descripcion\": \"COBRO POR VENTA DE PRODUCTOS\", \"monto_total\": 180, \"registro_id\": 12, \"sucursal_id\": 1, \"monto_efectivo\": \"180\", \"tipo_movimiento\": \"INGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-16', '17:39:52', '2026-09-16 21:39:52', '2026-09-16 21:39:52'),
(173, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 12, \"hora\": \"17:39:52\", \"fecha\": \"2026-09-16\", \"saldo\": 0, \"user_id\": 1, \"monto_qr\": 0, \"venta_id\": 15, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 2, \"created_at\": \"2026-09-16T21:39:52.000000Z\", \"updated_at\": \"2026-09-16T21:39:52.000000Z\", \"monto_total\": 180, \"sucursal_id\": 1, \"monto_efectivo\": \"180\"}', NULL, 'COBROS DE CRÉDITOS POR VENTAS', '2026-09-16', '17:39:52', '2026-09-16 21:39:52', '2026-09-16 21:39:52'),
(174, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UN PAGO POR VENTA DE PRODUCTOS', '{\"id\": 8, \"hora\": \"14:50:35\", \"fecha\": \"2026-09-16\", \"saldo\": \"0.00\", \"user_id\": 1, \"monto_qr\": \"0.00\", \"venta_id\": 16, \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 1, \"created_at\": \"2026-09-16T18:50:35.000000Z\", \"updated_at\": \"2026-09-16T18:50:35.000000Z\", \"monto_total\": \"10.00\", \"sucursal_id\": 1, \"monto_efectivo\": \"10.00\"}', '{\"id\": 8, \"hora\": \"17:46:42\", \"fecha\": \"2026-09-16\", \"saldo\": 0, \"user_id\": 1, \"monto_qr\": \"10.00\", \"venta_id\": 16, \"tipo_pago\": \"EFECTIVO-QR\", \"almacen_id\": 1, \"cliente_id\": 1, \"created_at\": \"2026-09-16T18:50:35.000000Z\", \"updated_at\": \"2026-09-16T21:46:42.000000Z\", \"monto_total\": 20, \"sucursal_id\": 1, \"monto_efectivo\": \"10.00\"}', 'COBROS DE CRÉDITOS POR VENTAS', '2026-09-16', '17:46:42', '2026-09-16 21:46:42', '2026-09-16 21:46:42'),
(175, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN EGRESO DE BS. 40 EN LA SUCURSAL SUCURSAL CENTRAL; almacén ALMACEN CENTRAL', '{\"id\": 40, \"hora\": \"17:53:06\", \"tipo\": \"PAGO POR COMPRA DE PRODUCTOS\", \"fecha\": \"2026-09-16\", \"modulo\": \"IngresoPago\", \"user_id\": 1, \"monto_qr\": \"20\", \"tipo_pago\": \"EFECTIVO-QR\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T21:53:06.000000Z\", \"updated_at\": \"2026-09-16T21:53:06.000000Z\", \"descripcion\": \"PAGO POR COMPRA DE PRODUCTOS\", \"monto_total\": 40, \"registro_id\": 12, \"sucursal_id\": 1, \"monto_efectivo\": \"20\", \"tipo_movimiento\": \"EGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-16', '17:53:06', '2026-09-16 21:53:06', '2026-09-16 21:53:06'),
(176, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 12, \"hora\": \"17:53:06\", \"fecha\": \"2026-09-16\", \"user_id\": 1, \"monto_qr\": \"20\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T21:53:06.000000Z\", \"updated_at\": \"2026-09-16T21:53:06.000000Z\", \"monto_total\": 40, \"sucursal_id\": 1, \"proveedor_id\": 1, \"monto_efectivo\": \"20\", \"ingreso_producto_id\": 12}', NULL, 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-16', '17:53:06', '2026-09-16 21:53:06', '2026-09-16 21:53:06'),
(177, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 12, \"hora\": \"17:53:06\", \"fecha\": \"2026-09-16\", \"user_id\": 1, \"monto_qr\": \"20.00\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T21:53:06.000000Z\", \"updated_at\": \"2026-09-16T21:53:06.000000Z\", \"monto_total\": \"40.00\", \"sucursal_id\": 1, \"proveedor_id\": 1, \"monto_efectivo\": \"20.00\", \"ingreso_producto_id\": 12}', '{\"id\": 12, \"hora\": \"17:53:06\", \"fecha\": \"2026-09-16\", \"user_id\": 1, \"monto_qr\": \"20.00\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T21:53:06.000000Z\", \"updated_at\": \"2026-09-16T21:54:25.000000Z\", \"monto_total\": 140, \"sucursal_id\": 1, \"proveedor_id\": 1, \"monto_efectivo\": \"120.00\", \"ingreso_producto_id\": 12}', 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-16', '17:54:25', '2026-09-16 21:54:25', '2026-09-16 21:54:25'),
(178, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 12, \"hora\": \"17:53:06\", \"fecha\": \"2026-09-16\", \"user_id\": 1, \"monto_qr\": \"20.00\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T21:53:06.000000Z\", \"updated_at\": \"2026-09-16T21:54:25.000000Z\", \"monto_total\": \"140.00\", \"sucursal_id\": 1, \"proveedor_id\": 1, \"monto_efectivo\": \"120.00\", \"ingreso_producto_id\": 12}', '{\"id\": 12, \"hora\": \"17:53:06\", \"fecha\": \"2026-09-16\", \"user_id\": 1, \"monto_qr\": \"20.00\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T21:53:06.000000Z\", \"updated_at\": \"2026-09-16T21:55:38.000000Z\", \"monto_total\": 140, \"sucursal_id\": 1, \"proveedor_id\": 1, \"monto_efectivo\": \"120.00\", \"ingreso_producto_id\": 12}', 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-16', '17:55:38', '2026-09-16 21:55:38', '2026-09-16 21:55:38'),
(179, 1, 'ELIMINACIÓN', 'EL USUARIO admin ELIMINÓ UN MOVIMIENTO DE CAJA', '{\"id\": 40, \"hora\": \"17:53:06\", \"tipo\": \"PAGO POR COMPRA DE PRODUCTOS\", \"fecha\": \"2026-09-16\", \"modulo\": \"IngresoPago\", \"status\": 1, \"user_id\": 1, \"monto_qr\": \"20.00\", \"tipo_pago\": \"EFECTIVO-QR\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T21:53:06.000000Z\", \"updated_at\": \"2026-09-16T21:55:38.000000Z\", \"descripcion\": \"PAGO POR COMPRA DE PRODUCTOS\", \"monto_total\": \"140.00\", \"registro_id\": 12, \"sucursal_id\": 1, \"monto_efectivo\": \"120.00\", \"tipo_movimiento\": \"EGRESO\"}', '{\"id\": 40, \"hora\": \"17:53:06\", \"tipo\": \"PAGO POR COMPRA DE PRODUCTOS\", \"fecha\": \"2026-09-16\", \"modulo\": \"IngresoPago\", \"status\": 0, \"user_id\": 1, \"monto_qr\": \"20.00\", \"tipo_pago\": \"EFECTIVO-QR\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T21:53:06.000000Z\", \"updated_at\": \"2026-09-16T21:56:10.000000Z\", \"descripcion\": \"PAGO POR COMPRA DE PRODUCTOS\", \"monto_total\": \"140.00\", \"registro_id\": 12, \"sucursal_id\": 1, \"monto_efectivo\": \"120.00\", \"tipo_movimiento\": \"EGRESO\"}', 'MOVIMIENTO DE CAJAS', '2026-09-16', '17:56:10', '2026-09-16 21:56:10', '2026-09-16 21:56:10'),
(180, 1, 'ELIMINACIÓN', 'EL USUARIO admin ELIMINÓ UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 12, \"hora\": \"17:53:06\", \"fecha\": \"2026-09-16\", \"user_id\": 1, \"monto_qr\": \"20.00\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T21:53:06.000000Z\", \"updated_at\": \"2026-09-16T21:55:38.000000Z\", \"monto_total\": \"140.00\", \"sucursal_id\": 1, \"proveedor_id\": 1, \"monto_efectivo\": \"120.00\", \"ingreso_producto\": {\"id\": 12, \"saldo\": 1560, \"total\": \"1560.00\", \"codigo\": \"L-00012\", \"status\": 1, \"user_id\": 1, \"almacen_id\": 1, \"created_at\": \"2026-09-16T14:22:25.000000Z\", \"updated_at\": \"2026-09-16T21:56:10.000000Z\", \"descripcion\": \"\", \"sucursal_id\": 1, \"tipo_compra\": \"CRÉDITO\", \"cancelado_qr\": \"0.00\", \"proveedor_id\": 1, \"estado_ingreso\": \"VERIFICADO\", \"fecha_registro\": \"2026-09-16\", \"tipo_ingreso_id\": 1, \"total_cancelado\": \"540.00\", \"estado_faltantes\": \"COMPLETO\", \"fecha_registro_t\": \"16/09/2026\", \"cancelado_efectivo\": \"540.00\"}, \"ingreso_producto_id\": 12}', NULL, 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-16', '17:56:10', '2026-09-16 21:56:10', '2026-09-16 21:56:10'),
(181, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN EGRESO DE BS. 40 EN LA SUCURSAL SUCURSAL CENTRAL; almacén ALMACEN CENTRAL', '{\"id\": 41, \"hora\": \"17:56:38\", \"tipo\": \"PAGO POR COMPRA DE PRODUCTOS\", \"fecha\": \"2026-09-16\", \"modulo\": \"IngresoPago\", \"user_id\": 1, \"monto_qr\": \"20\", \"tipo_pago\": \"EFECTIVO-QR\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T21:56:38.000000Z\", \"updated_at\": \"2026-09-16T21:56:38.000000Z\", \"descripcion\": \"PAGO POR COMPRA DE PRODUCTOS\", \"monto_total\": 40, \"registro_id\": 13, \"sucursal_id\": 1, \"monto_efectivo\": \"20\", \"tipo_movimiento\": \"EGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-16', '17:56:38', '2026-09-16 21:56:38', '2026-09-16 21:56:38'),
(182, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 13, \"hora\": \"17:56:38\", \"fecha\": \"2026-09-16\", \"user_id\": 1, \"monto_qr\": \"20\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T21:56:38.000000Z\", \"updated_at\": \"2026-09-16T21:56:38.000000Z\", \"monto_total\": 40, \"sucursal_id\": 1, \"proveedor_id\": 1, \"monto_efectivo\": \"20\", \"ingreso_producto_id\": 12}', NULL, 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-16', '17:56:38', '2026-09-16 21:56:38', '2026-09-16 21:56:38'),
(183, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 13, \"hora\": \"17:56:38\", \"fecha\": \"2026-09-16\", \"user_id\": 1, \"monto_qr\": \"20.00\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T21:56:38.000000Z\", \"updated_at\": \"2026-09-16T21:56:38.000000Z\", \"monto_total\": \"40.00\", \"sucursal_id\": 1, \"proveedor_id\": 1, \"monto_efectivo\": \"20.00\", \"ingreso_producto_id\": 12}', '{\"id\": 13, \"hora\": \"17:56:38\", \"fecha\": \"2026-09-16\", \"user_id\": 1, \"monto_qr\": \"20.00\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T21:56:38.000000Z\", \"updated_at\": \"2026-09-16T21:57:49.000000Z\", \"monto_total\": 40, \"sucursal_id\": 1, \"proveedor_id\": 1, \"monto_efectivo\": \"20.00\", \"ingreso_producto_id\": 12}', 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-16', '17:57:49', '2026-09-16 21:57:49', '2026-09-16 21:57:49'),
(184, 1, 'ELIMINACIÓN', 'EL USUARIO admin ELIMINÓ UN MOVIMIENTO DE CAJA', '{\"id\": 41, \"hora\": \"17:56:38\", \"tipo\": \"PAGO POR COMPRA DE PRODUCTOS\", \"fecha\": \"2026-09-16\", \"modulo\": \"IngresoPago\", \"status\": 1, \"user_id\": 1, \"monto_qr\": \"20.00\", \"tipo_pago\": \"EFECTIVO-QR\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T21:56:38.000000Z\", \"updated_at\": \"2026-09-16T21:57:49.000000Z\", \"descripcion\": \"PAGO POR COMPRA DE PRODUCTOS\", \"monto_total\": \"40.00\", \"registro_id\": 13, \"sucursal_id\": 1, \"monto_efectivo\": \"20.00\", \"tipo_movimiento\": \"EGRESO\"}', '{\"id\": 41, \"hora\": \"17:56:38\", \"tipo\": \"PAGO POR COMPRA DE PRODUCTOS\", \"fecha\": \"2026-09-16\", \"modulo\": \"IngresoPago\", \"status\": 0, \"user_id\": 1, \"monto_qr\": \"20.00\", \"tipo_pago\": \"EFECTIVO-QR\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T21:56:38.000000Z\", \"updated_at\": \"2026-09-16T21:58:29.000000Z\", \"descripcion\": \"PAGO POR COMPRA DE PRODUCTOS\", \"monto_total\": \"40.00\", \"registro_id\": 13, \"sucursal_id\": 1, \"monto_efectivo\": \"20.00\", \"tipo_movimiento\": \"EGRESO\"}', 'MOVIMIENTO DE CAJAS', '2026-09-16', '17:58:29', '2026-09-16 21:58:29', '2026-09-16 21:58:29'),
(185, 1, 'ELIMINACIÓN', 'EL USUARIO admin ELIMINÓ UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 13, \"hora\": \"17:56:38\", \"fecha\": \"2026-09-16\", \"user_id\": 1, \"monto_qr\": \"20.00\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T21:56:38.000000Z\", \"updated_at\": \"2026-09-16T21:57:49.000000Z\", \"monto_total\": \"40.00\", \"sucursal_id\": 1, \"proveedor_id\": 1, \"monto_efectivo\": \"20.00\", \"ingreso_producto\": {\"id\": 12, \"saldo\": 1560, \"total\": \"1560.00\", \"codigo\": \"L-00012\", \"status\": 1, \"user_id\": 1, \"almacen_id\": 1, \"created_at\": \"2026-09-16T14:22:25.000000Z\", \"updated_at\": \"2026-09-16T21:58:29.000000Z\", \"descripcion\": \"\", \"sucursal_id\": 1, \"tipo_compra\": \"CRÉDITO\", \"cancelado_qr\": \"0.00\", \"proveedor_id\": 1, \"estado_ingreso\": \"VERIFICADO\", \"fecha_registro\": \"2026-09-16\", \"tipo_ingreso_id\": 1, \"total_cancelado\": \"540.00\", \"estado_faltantes\": \"COMPLETO\", \"fecha_registro_t\": \"16/09/2026\", \"cancelado_efectivo\": \"540.00\"}, \"ingreso_producto_id\": 12}', NULL, 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-16', '17:58:29', '2026-09-16 21:58:29', '2026-09-16 21:58:29'),
(186, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN EGRESO DE BS. 40 EN LA SUCURSAL SUCURSAL CENTRAL; almacén ALMACEN CENTRAL', '{\"id\": 42, \"hora\": \"17:58:42\", \"tipo\": \"PAGO POR COMPRA DE PRODUCTOS\", \"fecha\": \"2026-09-16\", \"modulo\": \"IngresoPago\", \"user_id\": 1, \"monto_qr\": \"20\", \"tipo_pago\": \"EFECTIVO-QR\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T21:58:42.000000Z\", \"updated_at\": \"2026-09-16T21:58:42.000000Z\", \"descripcion\": \"PAGO POR COMPRA DE PRODUCTOS\", \"monto_total\": 40, \"registro_id\": 14, \"sucursal_id\": 1, \"monto_efectivo\": \"20\", \"tipo_movimiento\": \"EGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-16', '17:58:42', '2026-09-16 21:58:42', '2026-09-16 21:58:42'),
(187, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 14, \"hora\": \"17:58:42\", \"fecha\": \"2026-09-16\", \"user_id\": 1, \"monto_qr\": \"20\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T21:58:42.000000Z\", \"updated_at\": \"2026-09-16T21:58:42.000000Z\", \"monto_total\": 40, \"sucursal_id\": 1, \"proveedor_id\": 1, \"monto_efectivo\": \"20\", \"ingreso_producto_id\": 12}', NULL, 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-16', '17:58:42', '2026-09-16 21:58:42', '2026-09-16 21:58:42'),
(188, 1, 'ELIMINACIÓN', 'EL USUARIO admin ELIMINÓ UN MOVIMIENTO DE CAJA', '{\"id\": 42, \"hora\": \"17:58:42\", \"tipo\": \"PAGO POR COMPRA DE PRODUCTOS\", \"fecha\": \"2026-09-16\", \"modulo\": \"IngresoPago\", \"status\": 1, \"user_id\": 1, \"monto_qr\": \"20.00\", \"tipo_pago\": \"EFECTIVO-QR\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T21:58:42.000000Z\", \"updated_at\": \"2026-09-16T21:58:42.000000Z\", \"descripcion\": \"PAGO POR COMPRA DE PRODUCTOS\", \"monto_total\": \"40.00\", \"registro_id\": 14, \"sucursal_id\": 1, \"monto_efectivo\": \"20.00\", \"tipo_movimiento\": \"EGRESO\"}', '{\"id\": 42, \"hora\": \"17:58:42\", \"tipo\": \"PAGO POR COMPRA DE PRODUCTOS\", \"fecha\": \"2026-09-16\", \"modulo\": \"IngresoPago\", \"status\": 0, \"user_id\": 1, \"monto_qr\": \"20.00\", \"tipo_pago\": \"EFECTIVO-QR\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T21:58:42.000000Z\", \"updated_at\": \"2026-09-16T21:59:36.000000Z\", \"descripcion\": \"PAGO POR COMPRA DE PRODUCTOS\", \"monto_total\": \"40.00\", \"registro_id\": 14, \"sucursal_id\": 1, \"monto_efectivo\": \"20.00\", \"tipo_movimiento\": \"EGRESO\"}', 'MOVIMIENTO DE CAJAS', '2026-09-16', '17:59:36', '2026-09-16 21:59:36', '2026-09-16 21:59:36'),
(189, 1, 'ELIMINACIÓN', 'EL USUARIO admin ELIMINÓ UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 14, \"hora\": \"17:58:42\", \"fecha\": \"2026-09-16\", \"user_id\": 1, \"monto_qr\": \"20.00\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T21:58:42.000000Z\", \"updated_at\": \"2026-09-16T21:58:42.000000Z\", \"monto_total\": \"40.00\", \"sucursal_id\": 1, \"proveedor_id\": 1, \"monto_efectivo\": \"20.00\", \"ingreso_producto\": {\"id\": 12, \"saldo\": 1020, \"total\": \"1560.00\", \"codigo\": \"L-00012\", \"status\": 1, \"user_id\": 1, \"almacen_id\": 1, \"created_at\": \"2026-09-16T14:22:25.000000Z\", \"updated_at\": \"2026-09-16T21:59:36.000000Z\", \"descripcion\": \"\", \"sucursal_id\": 1, \"tipo_compra\": \"CRÉDITO\", \"cancelado_qr\": \"0.00\", \"proveedor_id\": 1, \"estado_ingreso\": \"VERIFICADO\", \"fecha_registro\": \"2026-09-16\", \"tipo_ingreso_id\": 1, \"total_cancelado\": \"540.00\", \"estado_faltantes\": \"COMPLETO\", \"fecha_registro_t\": \"16/09/2026\", \"cancelado_efectivo\": \"540.00\"}, \"ingreso_producto_id\": 12}', NULL, 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-16', '17:59:36', '2026-09-16 21:59:36', '2026-09-16 21:59:36'),
(190, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN EGRESO DE BS. 40 EN LA SUCURSAL SUCURSAL CENTRAL; almacén ALMACEN CENTRAL', '{\"id\": 43, \"hora\": \"17:59:48\", \"tipo\": \"PAGO POR COMPRA DE PRODUCTOS\", \"fecha\": \"2026-09-16\", \"modulo\": \"IngresoPago\", \"user_id\": 1, \"monto_qr\": \"20\", \"tipo_pago\": \"EFECTIVO-QR\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T21:59:48.000000Z\", \"updated_at\": \"2026-09-16T21:59:48.000000Z\", \"descripcion\": \"PAGO POR COMPRA DE PRODUCTOS\", \"monto_total\": 40, \"registro_id\": 15, \"sucursal_id\": 1, \"monto_efectivo\": \"20\", \"tipo_movimiento\": \"EGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-16', '17:59:48', '2026-09-16 21:59:48', '2026-09-16 21:59:48'),
(191, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 15, \"hora\": \"17:59:48\", \"fecha\": \"2026-09-16\", \"user_id\": 1, \"monto_qr\": \"20\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T21:59:48.000000Z\", \"updated_at\": \"2026-09-16T21:59:48.000000Z\", \"monto_total\": 40, \"sucursal_id\": 1, \"proveedor_id\": 1, \"monto_efectivo\": \"20\", \"ingreso_producto_id\": 12}', NULL, 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-16', '17:59:48', '2026-09-16 21:59:48', '2026-09-16 21:59:48'),
(192, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 15, \"hora\": \"17:59:48\", \"fecha\": \"2026-09-16\", \"user_id\": 1, \"monto_qr\": \"20.00\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T21:59:48.000000Z\", \"updated_at\": \"2026-09-16T21:59:48.000000Z\", \"monto_total\": \"40.00\", \"sucursal_id\": 1, \"proveedor_id\": 1, \"monto_efectivo\": \"20.00\", \"ingreso_producto_id\": 12}', '{\"id\": 15, \"hora\": \"17:59:48\", \"fecha\": \"2026-09-16\", \"user_id\": 1, \"monto_qr\": \"20.00\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T21:59:48.000000Z\", \"updated_at\": \"2026-09-16T22:04:52.000000Z\", \"monto_total\": 40, \"sucursal_id\": 1, \"proveedor_id\": 1, \"monto_efectivo\": \"20.00\", \"ingreso_producto_id\": 12}', 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-16', '18:04:52', '2026-09-16 22:04:52', '2026-09-16 22:04:52'),
(193, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN EGRESO DE BS. 980 EN LA SUCURSAL SUCURSAL CENTRAL; almacén ALMACEN CENTRAL', '{\"id\": 44, \"hora\": \"18:09:40\", \"tipo\": \"PAGO POR COMPRA DE PRODUCTOS\", \"fecha\": \"2026-09-16\", \"modulo\": \"IngresoPago\", \"user_id\": 1, \"monto_qr\": \"80\", \"tipo_pago\": \"EFECTIVO-QR\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T22:09:40.000000Z\", \"updated_at\": \"2026-09-16T22:09:40.000000Z\", \"descripcion\": \"PAGO POR COMPRA DE PRODUCTOS\", \"monto_total\": 980, \"registro_id\": 16, \"sucursal_id\": 1, \"monto_efectivo\": \"900\", \"tipo_movimiento\": \"EGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-16', '18:09:40', '2026-09-16 22:09:40', '2026-09-16 22:09:40'),
(194, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN PAGO POR COMPRA DE PRODUCTOS', '{\"id\": 16, \"hora\": \"18:09:40\", \"fecha\": \"2026-09-16\", \"user_id\": 1, \"monto_qr\": \"80\", \"almacen_id\": 1, \"created_at\": \"2026-09-16T22:09:40.000000Z\", \"updated_at\": \"2026-09-16T22:09:40.000000Z\", \"monto_total\": 980, \"sucursal_id\": 1, \"proveedor_id\": 1, \"monto_efectivo\": \"900\", \"ingreso_producto_id\": 12}', NULL, 'PAGOS DE INGRESO DE PRODUCTOS', '2026-09-16', '18:09:40', '2026-09-16 22:09:40', '2026-09-16 22:09:40'),
(195, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA INGRESO DE PRODUCTO', '{\"id\": 18, \"saldo\": \"4200.00\", \"total\": \"4200.00\", \"codigo\": \"L-00018\", \"user_id\": 1, \"almacen_id\": 1, \"created_at\": \"2026-09-20T18:46:22.000000Z\", \"updated_at\": \"2026-09-20T18:46:22.000000Z\", \"descripcion\": \"\", \"sucursal_id\": 1, \"tipo_compra\": \"CRÉDITO\", \"cancelado_qr\": \"0\", \"proveedor_id\": \"1\", \"fecha_registro\": \"2026-09-20\", \"tipo_ingreso_id\": \"1\", \"total_cancelado\": 0, \"ingreso_detalles\": [{\"id\": 19, \"costo\": \"120.00\", \"cantidad\": 10, \"repuesto\": 0, \"subtotal\": \"1200.00\", \"faltantes\": null, \"created_at\": \"2026-09-20T18:46:22.000000Z\", \"updated_at\": \"2026-09-20T18:46:22.000000Z\", \"verificado\": null, \"observacion\": null, \"producto_id\": 2, \"cantidad_fisica\": null, \"tipo_ingreso_id\": 1, \"ingreso_producto_id\": 18}, {\"id\": 20, \"costo\": \"300.00\", \"cantidad\": 10, \"repuesto\": 0, \"subtotal\": \"3000.00\", \"faltantes\": null, \"created_at\": \"2026-09-20T18:46:22.000000Z\", \"updated_at\": \"2026-09-20T18:46:22.000000Z\", \"verificado\": null, \"observacion\": null, \"producto_id\": 3, \"cantidad_fisica\": null, \"tipo_ingreso_id\": 1, \"ingreso_producto_id\": 18}], \"cancelado_efectivo\": \"0\"}', NULL, 'INGRESO DE PRODUCTOS', '2026-09-20', '14:46:22', '2026-09-20 18:46:22', '2026-09-20 18:46:22'),
(196, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN PRECIO DE PRODUCTO DE CLIENTE', '{\"id\": 1, \"precio\": \"270\", \"cliente_id\": \"13\", \"created_at\": \"2026-09-21T14:42:55.000000Z\", \"updated_at\": \"2026-09-21T14:42:55.000000Z\", \"producto_id\": \"2\"}', NULL, 'PRECIO PRODUCTOS CLIENTES', '2026-09-21', '10:42:55', '2026-09-21 14:42:55', '2026-09-21 14:42:55'),
(197, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UN PRECIO DE PRODUCTO DE CLIENTE', '{\"id\": 1, \"precio\": \"270.00\", \"cliente_id\": 13, \"created_at\": \"2026-09-21T14:42:55.000000Z\", \"updated_at\": \"2026-09-21T14:42:55.000000Z\", \"producto_id\": 2}', '{\"id\": 1, \"precio\": \"275\", \"cliente_id\": \"13\", \"created_at\": \"2026-09-21T14:42:55.000000Z\", \"updated_at\": \"2026-09-21T14:52:28.000000Z\", \"producto_id\": \"2\"}', 'PRECIO PRODUCTOS CLIENTES', '2026-09-21', '10:52:28', '2026-09-21 14:52:28', '2026-09-21 14:52:28'),
(198, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN PRECIO DE PRODUCTO DE CLIENTE', '{\"id\": 2, \"precio\": \"255\", \"cliente_id\": \"13\", \"created_at\": \"2026-09-21T14:53:16.000000Z\", \"updated_at\": \"2026-09-21T14:53:16.000000Z\", \"producto_id\": \"2\"}', NULL, 'PRECIO PRODUCTOS CLIENTES', '2026-09-21', '10:53:16', '2026-09-21 14:53:16', '2026-09-21 14:53:16'),
(199, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN PRECIO DE PRODUCTO DE CLIENTE', '{\"id\": 3, \"precio\": \"360\", \"cliente_id\": \"13\", \"created_at\": \"2026-09-21T14:56:10.000000Z\", \"updated_at\": \"2026-09-21T14:56:10.000000Z\", \"producto_id\": \"3\"}', NULL, 'PRECIO PRODUCTOS CLIENTES', '2026-09-21', '10:56:10', '2026-09-21 14:56:10', '2026-09-21 14:56:10'),
(200, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN INGRESO DE BS. 600 EN LA SUCURSAL SUCURSAL CENTRAL; almacén ALMACEN CENTRAL', '{\"id\": 45, \"hora\": \"10:35:36\", \"tipo\": \"VENTA\", \"fecha\": \"2026-09-23\", \"modulo\": \"Venta\", \"user_id\": 1, \"monto_qr\": \"0\", \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"created_at\": \"2026-09-23T14:35:36.000000Z\", \"updated_at\": \"2026-09-23T14:35:36.000000Z\", \"descripcion\": \"INGRESO POR VENTA\", \"monto_total\": 600, \"registro_id\": 18, \"sucursal_id\": 1, \"monto_efectivo\": \"600\", \"tipo_movimiento\": \"INGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-23', '10:35:36', '2026-09-23 14:35:36', '2026-09-23 14:35:36'),
(201, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA VENTA', '{\"id\": 18, \"hora\": \"10:35:36\", \"fecha\": \"2026-09-23\", \"saldo\": \"0.00\", \"total\": \"600.00\", \"nit_ci\": \"56565656\", \"user_id\": 1, \"subtotal\": \"615.00\", \"descuento\": \"15\", \"tipo_pago\": \"EFECTIVO\", \"almacen_id\": 1, \"cliente_id\": 13, \"created_at\": \"2026-09-23T14:35:36.000000Z\", \"tipo_venta\": \"AL CONTADO\", \"updated_at\": \"2026-09-23T14:35:36.000000Z\", \"sucursal_id\": 1, \"cancelado_qr\": \"0\", \"codigo_venta\": \"V18\", \"fecha_registro\": \"2026-09-23\", \"venta_detalles\": [{\"id\": 27, \"total\": \"248.78\", \"precio\": \"255.00\", \"status\": 1, \"cantidad\": 1, \"venta_id\": 18, \"porcen_dt\": 2.44, \"porcen_du\": 0, \"total_uni\": \"255.00\", \"created_at\": \"2026-09-23T14:35:36.000000Z\", \"updated_at\": \"2026-09-23T14:35:36.000000Z\", \"producto_id\": 2, \"precio_final\": \"248.78\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"6.22\"}, {\"id\": 28, \"total\": \"351.22\", \"precio\": \"360.00\", \"status\": 1, \"cantidad\": 1, \"venta_id\": 18, \"porcen_dt\": 2.44, \"porcen_du\": 0, \"total_uni\": \"360.00\", \"created_at\": \"2026-09-23T14:35:36.000000Z\", \"updated_at\": \"2026-09-23T14:35:36.000000Z\", \"producto_id\": 3, \"precio_final\": \"351.22\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"8.78\"}], \"total_cancelado\": 600, \"tipo_documento_id\": 1, \"cancelado_efectivo\": \"600\", \"porcentaje_descuento\": \"2.44\"}', NULL, 'VENTAS', '2026-09-23', '10:35:36', '2026-09-23 14:35:36', '2026-09-23 14:35:36'),
(202, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA VENTA', '{\"id\": 23, \"hora\": \"10:39:37\", \"fecha\": \"2026-09-23\", \"saldo\": \"200.00\", \"total\": \"200.00\", \"nit_ci\": \"345345345\", \"user_id\": 1, \"subtotal\": \"200.00\", \"descuento\": \"0\", \"tipo_pago\": \"\", \"almacen_id\": 1, \"cliente_id\": 3, \"created_at\": \"2026-09-23T14:39:37.000000Z\", \"tipo_venta\": \"CRÉDITO\", \"updated_at\": \"2026-09-23T14:39:37.000000Z\", \"sucursal_id\": 1, \"cancelado_qr\": \"0\", \"codigo_venta\": \"V23\", \"fecha_registro\": \"2026-09-23\", \"venta_detalles\": [{\"id\": 29, \"total\": \"200.00\", \"precio\": \"200.00\", \"status\": 1, \"cantidad\": 1, \"venta_id\": 23, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"200.00\", \"created_at\": \"2026-09-23T14:39:37.000000Z\", \"updated_at\": \"2026-09-23T14:39:37.000000Z\", \"producto_id\": 2, \"precio_final\": \"200.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"total_cancelado\": 0, \"tipo_documento_id\": 2, \"cancelado_efectivo\": \"0\", \"porcentaje_descuento\": 0}', NULL, 'VENTAS', '2026-09-23', '10:39:37', '2026-09-23 14:39:37', '2026-09-23 14:39:37'),
(203, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA VENTA', '{\"id\": 24, \"hora\": \"10:40:45\", \"fecha\": \"2026-09-23\", \"saldo\": \"200.00\", \"total\": \"200.00\", \"nit_ci\": \"123456\", \"user_id\": 1, \"subtotal\": \"200.00\", \"descuento\": \"0\", \"tipo_pago\": \"\", \"almacen_id\": 1, \"cliente_id\": 2, \"created_at\": \"2026-09-23T14:40:45.000000Z\", \"tipo_venta\": \"CRÉDITO\", \"updated_at\": \"2026-09-23T14:40:45.000000Z\", \"sucursal_id\": 1, \"cancelado_qr\": \"0\", \"codigo_venta\": \"V24\", \"fecha_registro\": \"2026-09-23\", \"venta_detalles\": [{\"id\": 30, \"total\": \"200.00\", \"precio\": \"200.00\", \"status\": 1, \"cantidad\": 1, \"venta_id\": 24, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"200.00\", \"created_at\": \"2026-09-23T14:40:45.000000Z\", \"updated_at\": \"2026-09-23T14:40:45.000000Z\", \"producto_id\": 2, \"precio_final\": \"200.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"total_cancelado\": 0, \"tipo_documento_id\": 1, \"cancelado_efectivo\": \"0\", \"porcentaje_descuento\": 0}', NULL, 'VENTAS', '2026-09-23', '10:40:45', '2026-09-23 14:40:45', '2026-09-23 14:40:45'),
(204, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UN INGRESO DE BS. 360 EN LA SUCURSAL SUCURSAL CENTRAL; almacén ALMACEN CENTRAL', '{\"id\": 46, \"hora\": \"10:41:24\", \"tipo\": \"VENTA\", \"fecha\": \"2026-09-23\", \"modulo\": \"Venta\", \"user_id\": 1, \"monto_qr\": \"180\", \"tipo_pago\": \"EFECTIVO-QR\", \"almacen_id\": 1, \"created_at\": \"2026-09-23T14:41:24.000000Z\", \"updated_at\": \"2026-09-23T14:41:24.000000Z\", \"descripcion\": \"INGRESO POR VENTA\", \"monto_total\": 360, \"registro_id\": 25, \"sucursal_id\": 1, \"monto_efectivo\": \"180\", \"tipo_movimiento\": \"INGRESO\"}', NULL, 'MOVIMIENTO DE CAJAS', '2026-09-23', '10:41:24', '2026-09-23 14:41:24', '2026-09-23 14:41:24');
INSERT INTO `historial_accions` (`id`, `user_id`, `accion`, `descripcion`, `datos_original`, `datos_nuevo`, `modulo`, `fecha`, `hora`, `created_at`, `updated_at`) VALUES
(205, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA VENTA', '{\"id\": 25, \"hora\": \"10:41:24\", \"fecha\": \"2026-09-23\", \"saldo\": \"0.00\", \"total\": \"360.00\", \"nit_ci\": \"56565656\", \"user_id\": 1, \"subtotal\": \"360.00\", \"descuento\": \"0\", \"tipo_pago\": \"EFECTIVO-QR\", \"almacen_id\": 1, \"cliente_id\": 13, \"created_at\": \"2026-09-23T14:41:24.000000Z\", \"tipo_venta\": \"AL CONTADO\", \"updated_at\": \"2026-09-23T14:41:24.000000Z\", \"sucursal_id\": 1, \"cancelado_qr\": \"180\", \"codigo_venta\": \"V25\", \"fecha_registro\": \"2026-09-23\", \"venta_detalles\": [{\"id\": 31, \"total\": \"360.00\", \"precio\": \"360.00\", \"status\": 1, \"cantidad\": 1, \"venta_id\": 25, \"porcen_dt\": 0, \"porcen_du\": 0, \"total_uni\": \"360.00\", \"created_at\": \"2026-09-23T14:41:24.000000Z\", \"updated_at\": \"2026-09-23T14:41:24.000000Z\", \"producto_id\": 3, \"precio_final\": \"360.00\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"0.00\"}], \"total_cancelado\": 360, \"tipo_documento_id\": 1, \"cancelado_efectivo\": \"180\", \"porcentaje_descuento\": 0}', NULL, 'VENTAS', '2026-09-23', '10:41:24', '2026-09-23 14:41:24', '2026-09-23 14:41:24'),
(206, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UN TIPO DE INGRESO', '{\"id\": 1, \"nombre\": \"INGRESO 1\", \"created_at\": \"2026-07-13T19:57:24.000000Z\", \"updated_at\": \"2026-07-13T19:57:24.000000Z\", \"descripcion\": \"DESC INGRESO 1\"}', '{\"id\": 1, \"nombre\": \"POR COMPRAS\", \"created_at\": \"2026-07-13T19:57:24.000000Z\", \"updated_at\": \"2026-10-15T14:10:35.000000Z\", \"descripcion\": \"DESC INGRESO 1\"}', 'TIPO DE INGRESOS', '2026-10-15', '10:10:35', '2026-10-15 14:10:35', '2026-10-15 14:10:35'),
(207, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UN TIPO DE INGRESO', '{\"id\": 2, \"nombre\": \"INGRESO 2\", \"created_at\": \"2026-07-13T19:57:34.000000Z\", \"updated_at\": \"2026-07-13T19:57:34.000000Z\", \"descripcion\": \"\"}', '{\"id\": 2, \"nombre\": \"POR DONACION\", \"created_at\": \"2026-07-13T19:57:34.000000Z\", \"updated_at\": \"2026-10-15T14:10:48.000000Z\", \"descripcion\": \"\"}', 'TIPO DE INGRESOS', '2026-10-15', '10:10:48', '2026-10-15 14:10:48', '2026-10-15 14:10:48'),
(208, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UN TIPO DE INGRESO', '{\"id\": 2, \"nombre\": \"POR DONACION\", \"created_at\": \"2026-07-13T19:57:34.000000Z\", \"updated_at\": \"2026-10-15T14:10:48.000000Z\", \"descripcion\": \"\"}', '{\"id\": 2, \"nombre\": \"INGRESO 2\", \"created_at\": \"2026-07-13T19:57:34.000000Z\", \"updated_at\": \"2026-10-15T14:14:14.000000Z\", \"descripcion\": \"\"}', 'TIPO DE INGRESOS', '2026-10-15', '10:14:14', '2026-10-15 14:14:14', '2026-10-15 14:14:14'),
(209, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA INGRESO DE PRODUCTO', '{\"id\": 19, \"saldo\": \"720.00\", \"total\": \"720.00\", \"codigo\": \"L-00019\", \"user_id\": 1, \"almacen_id\": 1, \"created_at\": \"2026-10-15T14:15:19.000000Z\", \"updated_at\": \"2026-10-15T14:15:19.000000Z\", \"descripcion\": \"\", \"sucursal_id\": 1, \"tipo_compra\": \"CRÉDITO\", \"cancelado_qr\": \"0\", \"proveedor_id\": \"1\", \"fecha_registro\": \"2026-10-15\", \"tipo_ingreso_id\": \"1\", \"total_cancelado\": 0, \"ingreso_detalles\": [{\"id\": 21, \"costo\": \"120.00\", \"cantidad\": 1, \"repuesto\": 0, \"subtotal\": \"120.00\", \"faltantes\": null, \"created_at\": \"2026-10-15T14:15:19.000000Z\", \"updated_at\": \"2026-10-15T14:15:19.000000Z\", \"verificado\": null, \"observacion\": null, \"producto_id\": 2, \"cantidad_fisica\": null, \"tipo_ingreso_id\": 1, \"ingreso_producto_id\": 19}, {\"id\": 22, \"costo\": \"300.00\", \"cantidad\": 1, \"repuesto\": 0, \"subtotal\": \"300.00\", \"faltantes\": null, \"created_at\": \"2026-10-15T14:15:19.000000Z\", \"updated_at\": \"2026-10-15T14:15:19.000000Z\", \"verificado\": null, \"observacion\": null, \"producto_id\": 3, \"cantidad_fisica\": null, \"tipo_ingreso_id\": 1, \"ingreso_producto_id\": 19}, {\"id\": 23, \"costo\": \"300.00\", \"cantidad\": 1, \"repuesto\": 0, \"subtotal\": \"300.00\", \"faltantes\": null, \"created_at\": \"2026-10-15T14:15:19.000000Z\", \"updated_at\": \"2026-10-15T14:15:19.000000Z\", \"verificado\": null, \"observacion\": null, \"producto_id\": 4, \"cantidad_fisica\": null, \"tipo_ingreso_id\": 1, \"ingreso_producto_id\": 19}], \"cancelado_efectivo\": \"0\"}', NULL, 'INGRESO DE PRODUCTOS', '2026-10-15', '10:15:19', '2026-10-15 14:15:19', '2026-10-15 14:15:19'),
(210, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA UNIDAD DE MEDIDA', '{\"id\": 3, \"nombre\": \"CAJAS\", \"created_at\": \"2026-10-15T14:24:30.000000Z\", \"updated_at\": \"2026-10-15T14:24:30.000000Z\"}', NULL, 'UNIDADES DE MEDIDA', '2026-10-15', '10:24:30', '2026-10-15 14:24:30', '2026-10-15 14:24:30'),
(211, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UNA PRODUCTO', '{\"id\": 2, \"activo\": 1, \"codigo\": \"P001\", \"imagen\": \"21783799752.jpeg\", \"nombre\": \"PRODUCTO 1\", \"precio\": \"200.00\", \"precio2\": \"290.00\", \"precio3\": \"300.00\", \"precio4\": null, \"marca_id\": 1, \"stock_min\": 3, \"created_at\": \"2026-07-11T19:55:52.000000Z\", \"updated_at\": \"2026-09-06T21:17:59.000000Z\", \"categoria_id\": 1, \"precio_compra\": \"120.00\", \"fecha_registro\": \"2026-07-11\", \"unidad_medida_id\": 1}', '{\"id\": 2, \"activo\": \"1\", \"codigo\": \"F14242BAP\", \"imagen\": \"21783799752.jpeg\", \"nombre\": \"BARRO COPINO\", \"precio\": \"95\", \"precio2\": \"97\", \"precio3\": \"98\", \"precio4\": null, \"marca_id\": \"1\", \"stock_min\": \"3\", \"created_at\": \"2026-07-11T19:55:52.000000Z\", \"updated_at\": \"2026-10-15T14:32:06.000000Z\", \"categoria_id\": \"1\", \"precio_compra\": \"90\", \"fecha_registro\": \"2026-07-11\", \"unidad_medida_id\": \"1\"}', 'PRODUCTOS', '2026-10-15', '10:32:06', '2026-10-15 14:32:06', '2026-10-15 14:32:06'),
(212, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UNA PRODUCTO', '{\"id\": 2, \"activo\": 1, \"codigo\": \"F14242BAP\", \"imagen\": \"21783799752.jpeg\", \"nombre\": \"BARRO COPINO\", \"precio\": \"95.00\", \"precio2\": \"97.00\", \"precio3\": \"98.00\", \"precio4\": null, \"marca_id\": 1, \"stock_min\": 3, \"created_at\": \"2026-07-11T19:55:52.000000Z\", \"updated_at\": \"2026-10-15T14:32:06.000000Z\", \"categoria_id\": 1, \"precio_compra\": \"90.00\", \"fecha_registro\": \"2026-07-11\", \"unidad_medida_id\": 1}', '{\"id\": 2, \"activo\": \"1\", \"codigo\": \"F14242BAP\", \"imagen\": \"21783799752.jpeg\", \"nombre\": \"BARRO COPINO\", \"precio\": \"95.00\", \"precio2\": \"97.00\", \"precio3\": \"98.00\", \"precio4\": null, \"marca_id\": \"1\", \"stock_min\": \"3\", \"created_at\": \"2026-07-11T19:55:52.000000Z\", \"updated_at\": \"2026-10-15T14:33:05.000000Z\", \"categoria_id\": \"1\", \"precio_compra\": \"90.00\", \"fecha_registro\": \"2026-07-11\", \"unidad_medida_id\": \"3\"}', 'PRODUCTOS', '2026-10-15', '10:33:05', '2026-10-15 14:33:05', '2026-10-15 14:33:05'),
(213, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UNA PRODUCTO', '{\"id\": 41, \"activo\": 1, \"codigo\": \"P039\", \"imagen\": null, \"nombre\": \"PRODUCTO 39\", \"precio\": \"377.00\", \"calidad\": \"\", \"formato\": null, \"precio2\": null, \"precio3\": null, \"precio4\": null, \"marca_id\": 2, \"cobertura\": null, \"stock_min\": 1, \"created_at\": null, \"updated_at\": null, \"categoria_id\": 1, \"precio_compra\": \"266.00\", \"fecha_registro\": \"2026-09-16\", \"caracteristicas\": null, \"unidad_medida_id\": 1}', '{\"id\": 41, \"activo\": \"1\", \"codigo\": \"P039\", \"imagen\": null, \"nombre\": \"PRODUCTO 39\", \"precio\": \"377.00\", \"calidad\": \"EXTRA\", \"formato\": \"42x42\", \"precio2\": null, \"precio3\": null, \"precio4\": null, \"marca_id\": \"2\", \"cobertura\": \"1.77\", \"stock_min\": \"1\", \"created_at\": null, \"updated_at\": \"2026-10-17T14:16:22.000000Z\", \"categoria_id\": \"1\", \"precio_compra\": \"266.00\", \"fecha_registro\": \"2026-09-16\", \"caracteristicas\": \"\", \"unidad_medida_id\": \"1\"}', 'PRODUCTOS', '2026-10-17', '10:16:22', '2026-10-17 14:16:22', '2026-10-17 14:16:22'),
(214, 1, 'MODIFICACIÓN', 'EL USUARIO admin ACTUALIZÓ UNA PRODUCTO', '{\"id\": 41, \"activo\": 1, \"codigo\": \"P039\", \"imagen\": null, \"nombre\": \"PRODUCTO 39\", \"precio\": \"377.00\", \"calidad\": \"EXTRA\", \"formato\": \"42x42\", \"precio2\": null, \"precio3\": null, \"precio4\": null, \"marca_id\": 2, \"cobertura\": \"1.77\", \"stock_min\": 1, \"created_at\": null, \"updated_at\": \"2026-10-17T14:16:22.000000Z\", \"categoria_id\": 1, \"precio_compra\": \"266.00\", \"fecha_registro\": \"2026-09-16\", \"caracteristicas\": \"\", \"unidad_medida_id\": 1}', '{\"id\": 41, \"activo\": \"1\", \"codigo\": \"P039\", \"imagen\": null, \"nombre\": \"PRODUCTO 39\", \"precio\": \"377.00\", \"calidad\": \"EXTRA\", \"formato\": \"42x42\", \"precio2\": null, \"precio3\": null, \"precio4\": null, \"marca_id\": \"2\", \"cobertura\": \"1.77\", \"stock_min\": \"1\", \"created_at\": null, \"updated_at\": \"2026-10-17T14:18:15.000000Z\", \"categoria_id\": \"1\", \"precio_compra\": \"266.00\", \"fecha_registro\": \"2026-09-16\", \"caracteristicas\": \"NEQUE PORRO QUISQUAM EST QUI DOLOREM IPSUM QUIA DOLOR SIT AMET, CONSECTETUR, ADIPISCI VELIT\", \"unidad_medida_id\": \"1\"}', 'PRODUCTOS', '2026-10-17', '10:18:15', '2026-10-17 14:18:15', '2026-10-17 14:18:15');

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
(1, 3, 1, 2, 4, 4.00, 0, 0.00, NULL, 4.00, 120.00, 480.00, '2026-08-25 01:33:33', '2026-08-26 00:56:23'),
(2, 3, 1, 3, 1, 1.00, 0, 0.00, NULL, 1.00, 300.00, 300.00, '2026-08-25 01:33:33', '2026-08-26 00:56:23'),
(3, 3, 1, 4, 1, 1.00, 0, 0.00, NULL, 1.00, 300.00, 300.00, '2026-08-25 01:33:33', '2026-08-26 00:56:23'),
(4, 4, 1, 4, 1, 1.00, 0, 0.00, NULL, 1.00, 300.00, 300.00, '2026-08-25 01:35:28', '2026-08-30 15:28:12'),
(5, 5, 1, 3, 5, 3.00, 2, 0.00, 'faltan 2', 3.00, 300.00, 1500.00, '2026-08-29 15:44:23', '2026-08-30 15:26:54'),
(6, 6, 2, 4, 10, 7.00, 0, 3.00, NULL, 10.00, 300.00, 3000.00, '2026-08-30 16:01:02', '2026-08-30 16:02:46'),
(7, 7, 1, 3, 4, 2.00, 0, 2.00, NULL, 5.00, 300.00, 1200.00, '2026-08-30 16:05:07', '2026-08-30 16:12:35'),
(8, 8, 1, 2, 4, 2.00, 0, 2.00, NULL, 4.00, 120.00, 480.00, '2026-08-30 16:13:09', '2026-08-30 16:16:35'),
(9, 9, 3, 5, 1, 1.00, 0, 0.00, NULL, 1.00, 240.00, 240.00, '2026-09-13 20:34:45', '2026-09-13 20:53:57'),
(10, 10, 1, 5, 3, 2.00, 1, 0.00, 'falta 1', 2.00, 240.00, 720.00, '2026-09-13 20:36:17', '2026-09-13 20:56:20'),
(11, 11, 1, 3, 1, 1.00, 0, 0.00, NULL, 1.00, 300.00, 300.00, '2026-09-16 14:13:28', '2026-09-16 14:15:33'),
(12, 12, 1, 2, 3, 3.00, 0, 0.00, NULL, 3.00, 120.00, 360.00, '2026-09-16 14:22:25', '2026-09-16 14:23:36'),
(13, 12, 1, 3, 4, 3.00, 0, 1.00, 'observacion', 4.00, 300.00, 1200.00, '2026-09-16 14:22:25', '2026-09-16 14:24:18'),
(14, 13, 1, 2, 4, 2.00, 2, 0.00, NULL, 2.00, 120.00, 480.00, '2026-09-16 14:25:21', '2026-09-16 14:25:33'),
(15, 14, 1, 3, 2, 2.00, 0, 0.00, NULL, 2.00, 300.00, 600.00, '2026-09-16 18:47:03', '2026-09-16 18:47:18'),
(17, 16, 1, 2, 2, NULL, NULL, 0.00, NULL, NULL, 120.00, 240.00, '2026-09-16 21:08:19', '2026-09-16 21:08:19'),
(18, 17, 2, 4, 2, NULL, NULL, 0.00, NULL, NULL, 300.00, 600.00, '2026-09-16 21:09:03', '2026-09-16 21:09:03'),
(19, 18, 1, 2, 10, 5.00, 0, 5.00, NULL, 10.00, 120.00, 1200.00, '2026-09-20 18:46:22', '2026-09-21 01:13:09'),
(20, 18, 1, 3, 10, 5.00, 0, 5.00, NULL, 10.00, 300.00, 3000.00, '2026-09-20 18:46:22', '2026-09-21 01:13:09'),
(21, 19, 1, 2, 1, NULL, NULL, 0.00, NULL, NULL, 120.00, 120.00, '2026-10-15 14:15:19', '2026-10-15 14:15:19'),
(22, 19, 1, 3, 1, NULL, NULL, 0.00, NULL, NULL, 300.00, 300.00, '2026-10-15 14:15:19', '2026-10-15 14:15:19'),
(23, 19, 1, 4, 1, NULL, NULL, 0.00, NULL, NULL, 300.00, 300.00, '2026-10-15 14:15:19', '2026-10-15 14:15:19');

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

--
-- Volcado de datos para la tabla `ingreso_faltantes`
--

INSERT INTO `ingreso_faltantes` (`id`, `ingreso_producto_id`, `ingreso_detalle_id`, `cantidad`, `user_id`, `fecha`, `hora`, `created_at`, `updated_at`) VALUES
(1, 18, 19, 3, 1, '2026-09-20', '16:04:23', '2026-09-20 20:04:23', '2026-09-20 20:04:23'),
(2, 18, 20, 2, 1, '2026-09-20', '21:07:27', '2026-09-21 01:07:27', '2026-09-21 01:07:27'),
(3, 18, 20, 1, 1, '2026-09-20', '21:11:14', '2026-09-21 01:11:14', '2026-09-21 01:11:14'),
(4, 18, 20, 1, 1, '2026-09-20', '21:12:31', '2026-09-21 01:12:31', '2026-09-21 01:12:31'),
(5, 18, 19, 2, 1, '2026-09-20', '21:13:09', '2026-09-21 01:13:09', '2026-09-21 01:13:09'),
(6, 18, 20, 1, 1, '2026-09-20', '21:13:09', '2026-09-21 01:13:09', '2026-09-21 01:13:09');

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

--
-- Volcado de datos para la tabla `ingreso_pagos`
--

INSERT INTO `ingreso_pagos` (`id`, `sucursal_id`, `almacen_id`, `ingreso_producto_id`, `proveedor_id`, `monto_efectivo`, `monto_qr`, `monto_total`, `fecha`, `hora`, `user_id`, `created_at`, `updated_at`) VALUES
(3, 1, 1, 3, 1, 380.00, 0.00, 380.00, '2026-09-07', '12:30:17', 1, '2026-09-07 16:30:17', '2026-09-10 16:06:58'),
(4, 1, 1, 3, 1, 100.00, 0.00, 100.00, '2026-09-10', '12:07:07', 1, '2026-09-10 16:07:07', '2026-09-10 16:09:00'),
(11, 1, 1, 11, 1, 300.00, 0.00, 300.00, '2026-09-16', '10:36:53', 1, '2026-09-16 14:36:53', '2026-09-16 14:36:53'),
(15, 1, 1, 12, 1, 20.00, 20.00, 40.00, '2026-09-16', '17:59:48', 1, '2026-09-16 21:59:48', '2026-09-16 22:04:52'),
(16, 1, 1, 12, 1, 900.00, 80.00, 980.00, '2026-09-16', '18:09:40', 1, '2026-09-16 22:09:40', '2026-09-16 22:09:40');

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
(3, 'L-00003', 1, 1, 1, 1, '', 1080.00, 0.00, 0.00, 0.00, 600.00, 'CRÉDITO', '2026-08-24', 1, 'VERIFICADO', NULL, 1, '2026-08-25 01:33:33', '2026-09-11 15:25:45'),
(4, 'L-00004', 1, 1, 1, 1, '', 300.00, 300.00, 0.00, 300.00, 0.00, 'CONTADO', '2026-08-24', 1, 'VERIFICADO', NULL, 1, '2026-08-25 01:35:28', '2026-08-30 15:28:12'),
(5, 'L-00005', 1, 1, 1, 1, 'DESC', 1500.00, 0.00, 0.00, 0.00, 1500.00, 'CRÉDITO', '2026-08-29', 1, 'VERIFICADO', 'PENDIENTE', 1, '2026-08-29 15:44:23', '2026-08-30 15:26:54'),
(6, 'L-00006', 1, 1, 2, 2, '', 3000.00, 0.00, 0.00, 0.00, 3000.00, 'CRÉDITO', '2026-08-30', 1, 'VERIFICADO', 'COMPLETO', 1, '2026-08-30 16:01:02', '2026-08-30 16:02:46'),
(7, 'L-00007', 1, 1, 1, 1, '', 1200.00, 0.00, 0.00, 0.00, 1200.00, 'CRÉDITO', '2026-08-30', 1, 'VERIFICADO', 'COMPLETO', 1, '2026-08-30 16:05:07', '2026-08-30 16:12:35'),
(8, 'L-00008', 1, 1, 1, 1, '', 480.00, 0.00, 0.00, 0.00, 480.00, 'CRÉDITO', '2026-08-30', 1, 'VERIFICADO', 'COMPLETO', 1, '2026-08-30 16:13:09', '2026-08-30 16:16:35'),
(9, 'L-00009', 1, 1, 3, 1, 'PRUEBA', 240.00, 240.00, 0.00, 240.00, 0.00, 'CONTADO,', '2026-09-13', 1, 'VERIFICADO', 'SIN FALTANTES', 1, '2026-09-13 20:34:45', '2026-09-13 20:53:57'),
(10, 'L-00010', 1, 1, 1, 1, 'PRUEBA 2', 720.00, 0.00, 0.00, 0.00, 720.00, 'CRÉDITO', '2026-09-13', 1, 'VERIFICADO', 'PENDIENTE', 1, '2026-09-13 20:36:17', '2026-09-13 20:56:20'),
(11, 'L-00011', 1, 1, 1, 1, '', 300.00, 0.00, 0.00, 0.00, 0.00, 'CRÉDITO', '2026-09-16', 1, 'VERIFICADO', 'SIN FALTANTES', 1, '2026-09-16 14:13:28', '2026-09-16 14:36:53'),
(12, 'L-00012', 1, 1, 1, 1, '', 1560.00, 540.00, 0.00, 540.00, 0.00, 'CRÉDITO', '2026-09-16', 1, 'VERIFICADO', 'COMPLETO', 1, '2026-09-16 14:22:25', '2026-09-16 22:09:40'),
(13, 'L-00013', 1, 1, 1, 1, '', 480.00, 0.00, 0.00, 0.00, 480.00, 'CRÉDITO', '2026-09-16', 1, 'VERIFICADO', 'PENDIENTE', 1, '2026-09-16 14:25:21', '2026-09-16 14:25:33'),
(14, 'L-00014', 1, 1, 1, 1, '', 600.00, 0.00, 0.00, 0.00, 600.00, 'CRÉDITO', '2026-09-16', 1, 'VERIFICADO', 'SIN FALTANTES', 1, '2026-09-16 18:47:03', '2026-09-16 18:47:18'),
(16, 'L-00016', 1, 1, 1, 3, '', 240.00, 200.00, 40.00, 240.00, 0.00, 'CONTADO,', '2026-09-16', 1, 'PENDIENTE', NULL, 1, '2026-09-16 21:08:19', '2026-09-16 21:08:19'),
(17, 'L-00017', 1, 1, 2, 1, '', 600.00, 0.00, 0.00, 0.00, 600.00, 'CRÉDITO', '2026-09-16', 1, 'PENDIENTE', NULL, 1, '2026-09-16 21:09:03', '2026-09-16 21:09:03'),
(18, 'L-00018', 1, 1, 1, 1, '', 4200.00, 0.00, 0.00, 0.00, 4200.00, 'CRÉDITO', '2026-09-20', 1, 'VERIFICADO', 'COMPLETO', 1, '2026-09-20 18:46:22', '2026-09-21 01:13:09'),
(19, 'L-00019', 1, 1, 1, 1, '', 720.00, 0.00, 0.00, 0.00, 720.00, 'CRÉDITO', '2026-10-15', 1, 'PENDIENTE', NULL, 1, '2026-10-15 14:15:19', '2026-10-15 14:15:19');

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
  `tipo` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
  `cantidad_ingreso` double DEFAULT NULL,
  `cantidad_salida` double DEFAULT NULL,
  `cantidad_saldo` double NOT NULL,
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
(1, 1, 1, 1, 'INGRESO DE PRODUCTO', 1, 'IngresoDetalle', 2, 'INGRESO DE PRODUCTO', 120.00, 'INGRESO', 4, NULL, 4, 120.00, 480.00, NULL, 480.00, '2026-08-25', 1, '2026-08-26 00:56:23', '2026-08-26 00:56:23'),
(2, 1, 1, 2, 'INGRESO DE PRODUCTO', 2, 'IngresoDetalle', 3, 'INGRESO DE PRODUCTO', 300.00, 'INGRESO', 1, NULL, 1, 300.00, 300.00, NULL, 300.00, '2026-08-25', 1, '2026-08-26 00:56:23', '2026-08-26 00:56:23'),
(3, 1, 1, 3, 'INGRESO DE PRODUCTO', 3, 'IngresoDetalle', 4, 'INGRESO DE PRODUCTO', 300.00, 'INGRESO', 1, NULL, 1, 300.00, 300.00, NULL, 300.00, '2026-08-25', 1, '2026-08-26 00:56:23', '2026-08-26 00:56:23'),
(4, 1, 1, 5, 'INGRESO DE PRODUCTO', 5, 'IngresoDetalle', 3, 'INGRESO 1', 300.00, 'INGRESO', 3, NULL, 4, 300.00, 900.00, NULL, 1200.00, '2026-08-30', 1, '2026-08-30 15:26:54', '2026-08-30 15:26:54'),
(5, 1, 1, 4, 'INGRESO DE PRODUCTO', 4, 'IngresoDetalle', 4, 'INGRESO 1', 300.00, 'INGRESO', 1, NULL, 2, 300.00, 300.00, NULL, 600.00, '2026-08-30', 1, '2026-08-30 15:28:12', '2026-08-30 15:28:12'),
(6, 1, 1, 5, 'INGRESO DE PRODUCTO', 5, 'IngresoDetalle', 3, 'INGRESO 1', 300.00, 'INGRESO', 3, NULL, 7, 300.00, 900.00, NULL, 2100.00, '2026-08-30', 1, '2026-08-30 15:56:04', '2026-08-30 15:56:04'),
(7, 1, 1, 6, 'INGRESO DE PRODUCTO', 6, 'IngresoDetalle', 4, 'INGRESO 2', 300.00, 'INGRESO', 7, NULL, 9, 300.00, 2100.00, NULL, 2700.00, '2026-08-30', 1, '2026-08-30 16:01:19', '2026-08-30 16:01:19'),
(8, 1, 1, 6, 'INGRESO DE PRODUCTO', 6, 'IngresoDetalle', 4, 'INGRESO 2', 300.00, 'INGRESO', 7, NULL, 16, 300.00, 2100.00, NULL, 4800.00, '2026-08-30', 1, '2026-08-30 16:02:46', '2026-08-30 16:02:46'),
(9, 1, 1, 7, 'INGRESO DE PRODUCTO', 7, 'IngresoDetalle', 3, 'INGRESO 1', 300.00, 'INGRESO', 2, NULL, 9, 300.00, 600.00, NULL, 2700.00, '2026-08-30', 1, '2026-08-30 16:05:21', '2026-08-30 16:05:21'),
(10, 1, 1, 7, 'INGRESO DE PRODUCTO', 7, 'IngresoDetalle', 3, 'INGRESO POR FALTANTE DE COMPRA', 300.00, 'INGRESO', 1, NULL, 10, 300.00, 300.00, NULL, 3000.00, '2026-08-30', 1, '2026-08-30 16:05:52', '2026-08-30 16:05:52'),
(11, 1, 1, 7, 'INGRESO DE PRODUCTO', 7, 'IngresoDetalle', 3, 'INGRESO POR FALTANTE DE COMPRA', 300.00, 'INGRESO', 2, NULL, 12, 300.00, 600.00, NULL, 3600.00, '2026-08-30', 1, '2026-08-30 16:12:35', '2026-08-30 16:12:35'),
(12, 1, 1, 8, 'INGRESO DE PRODUCTO', 8, 'IngresoDetalle', 2, 'INGRESO 1', 120.00, 'INGRESO', 2, NULL, 6, 120.00, 240.00, NULL, 720.00, '2026-08-30', 1, '2026-08-30 16:13:25', '2026-08-30 16:13:25'),
(13, 1, 1, 8, 'INGRESO DE PRODUCTO', 8, 'IngresoDetalle', 2, 'INGRESO POR RECEPCIÓN DE FALTANTE DE COMPRA', 120.00, 'INGRESO', 2, NULL, 8, 120.00, 240.00, NULL, 960.00, '2026-08-30', 1, '2026-08-30 16:16:35', '2026-08-30 16:16:35'),
(17, 1, 1, 7, 'SALIDA DE PRODUCTO', 7, 'SalidaDetalle', 2, 'SALIDA 1', 120.00, 'EGRESO', NULL, 1, 7, 120.00, NULL, 120.00, 840.00, '2026-09-02', 1, '2026-09-02 14:23:39', '2026-09-02 14:23:39'),
(18, 1, 1, 8, 'SALIDA DE PRODUCTO', 8, 'SalidaDetalle', 3, 'SALIDA 2', 300.00, 'EGRESO', NULL, 1, 11, 300.00, NULL, 300.00, 3300.00, '2026-09-02', 1, '2026-09-02 14:23:39', '2026-09-02 14:23:39'),
(21, 1, 1, 2, 'TRASPASO DE PRODUCTOS', 2, 'TraspasoDetalle', 2, 'TRASPASO DE ALMACEN CENTRAL A ALMACEN 1', 120.00, 'EGRESO', NULL, 3, 4, 120.00, NULL, 360.00, 480.00, '2026-09-04', 1, '2026-09-04 15:07:52', '2026-09-04 15:07:52'),
(22, 2, 2, 2, 'TRASPASO DE PRODUCTOS', 2, 'TraspasoDetalle', 2, 'TRASPASO DE ALMACEN CENTRAL A ALMACEN 1', 120.00, 'INGRESO', 3, NULL, 3, 120.00, 360.00, NULL, 360.00, '2026-09-04', 1, '2026-09-04 15:07:52', '2026-09-04 15:07:52'),
(24, 1, 1, NULL, 'VENTA DE PRODUCTO', 8, 'VentaDetalle', 2, 'SALIDA POR VENTA', 200.00, 'EGRESO', NULL, 2, 2, 200.00, NULL, 400.00, 80.00, '2026-09-06', 1, '2026-09-06 22:24:22', '2026-09-06 22:24:22'),
(25, 1, 1, NULL, 'VENTA DE PRODUCTO', 9, 'VentaDetalle', 3, 'SALIDA POR VENTA', 350.00, 'EGRESO', NULL, 1, 10, 350.00, NULL, 350.00, 2950.00, '2026-09-07', 1, '2026-09-07 14:32:13', '2026-09-07 14:32:13'),
(26, 1, 1, NULL, 'VENTA DE PRODUCTO', 10, 'VentaDetalle', 3, 'SALIDA POR VENTA', 350.00, 'EGRESO', NULL, 3, 7, 350.00, NULL, 1050.00, 1900.00, '2026-09-07', 1, '2026-09-07 14:35:45', '2026-09-07 14:35:45'),
(27, 1, 1, NULL, 'VENTA DE PRODUCTO', 11, 'VentaDetalle', 3, 'SALIDA POR VENTA', 339.99, 'EGRESO', NULL, 2, 5, 339.99, NULL, 679.98, 1220.02, '2026-09-08', 1, '2026-09-08 14:55:31', '2026-09-08 14:55:31'),
(28, 1, 1, NULL, 'VENTA DE PRODUCTO', 12, 'VentaDetalle', 4, 'SALIDA POR VENTA', 374.99, 'EGRESO', NULL, 2, 14, 374.99, NULL, 749.97, 4050.03, '2026-09-08', 1, '2026-09-08 15:01:11', '2026-09-08 15:01:11'),
(29, 1, 1, NULL, 'VENTA DE PRODUCTO', 13, 'VentaDetalle', 3, 'SALIDA POR VENTA', 350.00, 'EGRESO', NULL, 1, 4, 350.00, NULL, 350.00, 870.02, '2026-09-09', 1, '2026-09-09 20:25:25', '2026-09-09 20:25:25'),
(30, 1, 1, NULL, 'VENTA DE PRODUCTO', 13, 'VentaDetalle', 3, 'INGRESO POR MODIFICACIÓN DE VENTA', 350.00, 'INGRESO', 1, NULL, 5, 350.00, 350.00, NULL, 1220.02, '2026-09-09', 1, '2026-09-09 20:57:39', '2026-09-09 20:57:39'),
(31, 1, 1, NULL, 'VENTA DE PRODUCTO', 13, 'VentaDetalle', 3, 'SALIDA POR VENTA', 350.00, 'EGRESO', NULL, 2, 3, 350.00, NULL, 700.00, 520.02, '2026-09-09', 1, '2026-09-09 20:57:39', '2026-09-09 20:57:39'),
(32, 1, 1, NULL, 'VENTA DE PRODUCTO', 13, 'VentaDetalle', 3, 'INGRESO POR MODIFICACIÓN DE VENTA', 350.00, 'INGRESO', 2, NULL, 5, 350.00, 700.00, NULL, 1220.02, '2026-09-09', 1, '2026-09-09 20:57:51', '2026-09-09 20:57:51'),
(33, 1, 1, NULL, 'VENTA DE PRODUCTO', 13, 'VentaDetalle', 3, 'SALIDA POR VENTA', 350.00, 'EGRESO', NULL, 2, 3, 350.00, NULL, 700.00, 520.02, '2026-09-09', 1, '2026-09-09 20:57:51', '2026-09-09 20:57:51'),
(34, 1, 1, NULL, 'VENTA DE PRODUCTO', 13, 'VentaDetalle', 3, 'INGRESO POR MODIFICACIÓN DE VENTA', 350.00, 'INGRESO', 2, NULL, 5, 350.00, 700.00, NULL, 1220.02, '2026-09-09', 1, '2026-09-09 20:58:04', '2026-09-09 20:58:04'),
(35, 1, 1, NULL, 'VENTA DE PRODUCTO', 13, 'VentaDetalle', 3, 'SALIDA POR VENTA', 350.00, 'EGRESO', NULL, 2, 3, 350.00, NULL, 700.00, 520.02, '2026-09-09', 1, '2026-09-09 20:58:04', '2026-09-09 20:58:04'),
(36, 1, 1, NULL, 'VENTA DE PRODUCTO', 13, 'VentaDetalle', 3, 'INGRESO POR MODIFICACIÓN DE VENTA', 350.00, 'INGRESO', 2, NULL, 5, 350.00, 700.00, NULL, 1220.02, '2026-09-09', 1, '2026-09-09 20:58:31', '2026-09-09 20:58:31'),
(37, 1, 1, NULL, 'VENTA DE PRODUCTO', 13, 'VentaDetalle', 3, 'SALIDA POR VENTA', 350.00, 'EGRESO', NULL, 2, 3, 350.00, NULL, 700.00, 520.02, '2026-09-09', 1, '2026-09-09 20:58:31', '2026-09-09 20:58:31'),
(38, 1, 1, NULL, 'VENTA DE PRODUCTO', 14, 'VentaDetalle', 4, 'SALIDA POR VENTA', 390.00, 'EGRESO', NULL, 1, 13, 390.00, NULL, 390.00, 3660.03, '2026-09-09', 1, '2026-09-09 20:58:31', '2026-09-09 20:58:31'),
(39, 1, 1, NULL, 'VENTA DE PRODUCTO', 13, 'VentaDetalle', 3, 'INGRESO POR ELIMINACIÓN DE VENTA', 350.00, 'INGRESO', 2, NULL, 5, 350.00, 700.00, NULL, 1220.02, '2026-09-10', 1, '2026-09-10 14:48:00', '2026-09-10 14:48:00'),
(40, 1, 1, NULL, 'VENTA DE PRODUCTO', 14, 'VentaDetalle', 4, 'INGRESO POR ELIMINACIÓN DE VENTA', 390.00, 'INGRESO', 1, NULL, 14, 390.00, 390.00, NULL, 4050.03, '2026-09-10', 1, '2026-09-10 14:48:00', '2026-09-10 14:48:00'),
(41, 1, 1, 9, 'INGRESO DE PRODUCTO', 9, 'IngresoDetalle', 5, 'INGRESO 3', 240.00, 'INGRESO', 1, NULL, 1, 240.00, 240.00, NULL, 240.00, '2026-09-13', 1, '2026-09-13 20:53:57', '2026-09-13 20:53:57'),
(42, 1, 1, 10, 'INGRESO DE PRODUCTO', 10, 'IngresoDetalle', 5, 'INGRESO 1', 240.00, 'INGRESO', 2, NULL, 3, 240.00, 480.00, NULL, 720.00, '2026-09-13', 1, '2026-09-13 20:56:20', '2026-09-13 20:56:20'),
(51, 1, 1, NULL, 'CARGA MASIVA', NULL, '', 2, 'STOCK INICIAL', 120.00, 'INGRESO', 10, NULL, 12, 120.00, 1200.00, NULL, 1280.00, '2026-09-15', 1, '2026-09-15 14:17:30', '2026-09-15 14:17:30'),
(52, 1, 1, NULL, 'CARGA MASIVA', NULL, '', 3, 'STOCK INICIAL', 300.00, 'INGRESO', 10, NULL, 15, 300.00, 3000.00, NULL, 4220.02, '2026-09-15', 1, '2026-09-15 14:17:30', '2026-09-15 14:17:30'),
(53, 1, 1, NULL, 'CARGA MASIVA', NULL, '', 6, 'STOCK INICIAL', 120.00, 'INGRESO', 10, NULL, 10, 120.00, 1200.00, NULL, 1200.00, '2026-09-15', 1, '2026-09-15 14:17:30', '2026-09-15 14:17:30'),
(54, 1, 1, NULL, 'CARGA MASIVA', NULL, '', 5, 'STOCK INICIAL', 240.00, 'INGRESO', 10, NULL, 13, 240.00, 2400.00, NULL, 3120.00, '2026-09-15', 1, '2026-09-15 14:17:30', '2026-09-15 14:17:30'),
(63, 1, 1, NULL, 'TRASPASO DE PRODUCTOS', 13, 'TraspasoDetalle', 2, 'TRASPASO A ALMACEN 2', 120.00, 'EGRESO', NULL, 1, 11, 120.00, NULL, 120.00, 1160.00, '2026-09-15', 1, '2026-09-15 14:25:34', '2026-09-15 14:25:34'),
(64, 3, 3, NULL, 'TRASPASO DE PRODUCTOS', 13, 'TraspasoDetalle', 2, 'TRASPASO A ALMACEN 2', 120.00, 'INGRESO', 1, NULL, 1, 120.00, 120.00, NULL, 120.00, '2026-09-15', 1, '2026-09-15 14:25:34', '2026-09-15 14:25:34'),
(65, 1, 1, NULL, 'TRASPASO DE PRODUCTOS', 14, 'TraspasoDetalle', 3, 'TRASPASO A ALMACEN 2', 300.00, 'EGRESO', NULL, 1, 14, 300.00, NULL, 300.00, 3920.02, '2026-09-15', 1, '2026-09-15 14:25:34', '2026-09-15 14:25:34'),
(66, 3, 3, NULL, 'TRASPASO DE PRODUCTOS', 14, 'TraspasoDetalle', 3, 'TRASPASO A ALMACEN 2', 300.00, 'INGRESO', 1, NULL, 1, 300.00, 300.00, NULL, 300.00, '2026-09-15', 1, '2026-09-15 14:25:34', '2026-09-15 14:25:34'),
(67, 1, 1, NULL, 'TRASPASO DE PRODUCTOS', 15, 'TraspasoDetalle', 4, 'TRASPASO A ALMACEN 2', 300.00, 'EGRESO', NULL, 1, 13, 300.00, NULL, 300.00, 3750.03, '2026-09-15', 1, '2026-09-15 14:25:34', '2026-09-15 14:25:34'),
(68, 3, 3, NULL, 'TRASPASO DE PRODUCTOS', 15, 'TraspasoDetalle', 4, 'TRASPASO A ALMACEN 2', 300.00, 'INGRESO', 1, NULL, 1, 300.00, 300.00, NULL, 300.00, '2026-09-15', 1, '2026-09-15 14:25:34', '2026-09-15 14:25:34'),
(69, 1, 1, NULL, 'TRASPASO DE PRODUCTOS', 16, 'TraspasoDetalle', 5, 'TRASPASO A ALMACEN 2', 240.00, 'EGRESO', NULL, 1, 12, 240.00, NULL, 240.00, 2880.00, '2026-09-15', 1, '2026-09-15 14:25:34', '2026-09-15 14:25:34'),
(70, 3, 3, NULL, 'TRASPASO DE PRODUCTOS', 16, 'TraspasoDetalle', 5, 'TRASPASO A ALMACEN 2', 240.00, 'INGRESO', 1, NULL, 1, 240.00, 240.00, NULL, 240.00, '2026-09-15', 1, '2026-09-15 14:25:34', '2026-09-15 14:25:34'),
(71, 1, 1, NULL, 'TRASPASO DE PRODUCTOS', 17, 'TraspasoDetalle', 6, 'TRASPASO A ALMACEN 2', 120.00, 'EGRESO', NULL, 1, 9, 120.00, NULL, 120.00, 1080.00, '2026-09-15', 1, '2026-09-15 14:25:34', '2026-09-15 14:25:34'),
(72, 3, 3, NULL, 'TRASPASO DE PRODUCTOS', 17, 'TraspasoDetalle', 6, 'TRASPASO A ALMACEN 2', 120.00, 'INGRESO', 1, NULL, 1, 120.00, 120.00, NULL, 120.00, '2026-09-15', 1, '2026-09-15 14:25:34', '2026-09-15 14:25:34'),
(73, 3, 3, NULL, 'VENTA DE PRODUCTO', 15, 'VentaDetalle', 2, 'SALIDA POR VENTA', 200.00, 'EGRESO', NULL, 1, 0, 200.00, NULL, 200.00, -80.00, '2026-09-15', 1, '2026-09-15 14:41:26', '2026-09-15 14:41:26'),
(74, 3, 3, NULL, 'VENTA DE PRODUCTO', 16, 'VentaDetalle', 4, 'SALIDA POR VENTA', 390.00, 'EGRESO', NULL, 1, 0, 390.00, NULL, 390.00, -90.00, '2026-09-15', 1, '2026-09-15 14:41:26', '2026-09-15 14:41:26'),
(75, 1, 1, 11, 'INGRESO DE PRODUCTO', 11, 'IngresoDetalle', 3, 'INGRESO 1', 300.00, 'INGRESO', 1, NULL, 15, 300.00, 300.00, NULL, 4220.02, '2026-09-16', 1, '2026-09-16 14:15:33', '2026-09-16 14:15:33'),
(76, 1, 1, NULL, 'TRASPASO DE PRODUCTOS', 18, 'TraspasoDetalle', 2, 'TRASPASO A ALMACEN 1', 120.00, 'EGRESO', NULL, 2, 9, 120.00, NULL, 240.00, 920.00, '2026-09-16', 1, '2026-09-16 14:17:07', '2026-09-16 14:17:07'),
(77, 2, 2, NULL, 'TRASPASO DE PRODUCTOS', 18, 'TraspasoDetalle', 2, 'TRASPASO A ALMACEN 1', 120.00, 'INGRESO', 2, NULL, 5, 120.00, 240.00, NULL, 600.00, '2026-09-16', 1, '2026-09-16 14:17:07', '2026-09-16 14:17:07'),
(78, 1, 1, 12, 'INGRESO DE PRODUCTO', 12, 'IngresoDetalle', 2, 'INGRESO 1', 120.00, 'INGRESO', 3, NULL, 12, 120.00, 360.00, NULL, 1280.00, '2026-09-16', 1, '2026-09-16 14:23:36', '2026-09-16 14:23:36'),
(79, 1, 1, 13, 'INGRESO DE PRODUCTO', 13, 'IngresoDetalle', 3, 'INGRESO 1', 300.00, 'INGRESO', 3, NULL, 18, 300.00, 900.00, NULL, 5120.02, '2026-09-16', 1, '2026-09-16 14:23:36', '2026-09-16 14:23:36'),
(80, 1, 1, 13, 'INGRESO DE PRODUCTO', 13, 'IngresoDetalle', 3, 'INGRESO POR RECEPCIÓN DE FALTANTE DE COMPRA', 300.00, 'INGRESO', 1, NULL, 19, 300.00, 300.00, NULL, 5420.02, '2026-09-16', 1, '2026-09-16 14:24:18', '2026-09-16 14:24:18'),
(81, 1, 1, 14, 'INGRESO DE PRODUCTO', 14, 'IngresoDetalle', 2, 'INGRESO 1', 120.00, 'INGRESO', 2, NULL, 14, 120.00, 240.00, NULL, 1520.00, '2026-09-16', 1, '2026-09-16 14:25:33', '2026-09-16 14:25:33'),
(82, 3, 3, NULL, 'VENTA DE PRODUCTO', 15, 'VentaDetalle', 2, 'INGRESO POR ELIMINACIÓN DE VENTA', 200.00, 'INGRESO', 1, NULL, 1, 200.00, 200.00, NULL, 120.00, '2026-09-16', 1, '2026-09-16 14:31:17', '2026-09-16 14:31:17'),
(83, 3, 3, NULL, 'VENTA DE PRODUCTO', 16, 'VentaDetalle', 4, 'INGRESO POR ELIMINACIÓN DE VENTA', 390.00, 'INGRESO', 1, NULL, 1, 390.00, 390.00, NULL, 300.00, '2026-09-16', 1, '2026-09-16 14:31:17', '2026-09-16 14:31:17'),
(84, 1, 1, NULL, 'VENTA DE PRODUCTO', 17, 'VentaDetalle', 2, 'SALIDA POR VENTA', 290.00, 'EGRESO', NULL, 1, 13, 290.00, NULL, 290.00, 1230.00, '2026-09-16', 1, '2026-09-16 14:33:00', '2026-09-16 14:33:00'),
(85, 1, 1, NULL, 'VENTA DE PRODUCTO', 18, 'VentaDetalle', 2, 'SALIDA POR VENTA', 200.00, 'EGRESO', NULL, 1, 12, 200.00, NULL, 200.00, 1030.00, '2026-09-16', 1, '2026-09-16 18:45:46', '2026-09-16 18:45:46'),
(86, 1, 1, NULL, 'VENTA DE PRODUCTO', 19, 'VentaDetalle', 3, 'SALIDA POR VENTA', 350.00, 'EGRESO', NULL, 1, 18, 350.00, NULL, 350.00, 5070.02, '2026-09-16', 1, '2026-09-16 18:45:46', '2026-09-16 18:45:46'),
(87, 1, 1, 15, 'INGRESO DE PRODUCTO', 15, 'IngresoDetalle', 3, 'INGRESO 1', 300.00, 'INGRESO', 2, NULL, 20, 300.00, 600.00, NULL, 5670.02, '2026-09-16', 1, '2026-09-16 18:47:18', '2026-09-16 18:47:18'),
(88, 1, 1, NULL, 'VENTA DE PRODUCTO', 18, 'VentaDetalle', 2, 'INGRESO POR MODIFICACIÓN DE VENTA', 200.00, 'INGRESO', 1, NULL, 13, 200.00, 200.00, NULL, 1230.00, '2026-09-16', 1, '2026-09-16 18:49:44', '2026-09-16 18:49:44'),
(89, 1, 1, NULL, 'VENTA DE PRODUCTO', 18, 'VentaDetalle', 2, 'SALIDA POR VENTA', 200.00, 'EGRESO', NULL, 2, 11, 200.00, NULL, 400.00, 830.00, '2026-09-16', 1, '2026-09-16 18:49:44', '2026-09-16 18:49:44'),
(90, 1, 1, NULL, 'VENTA DE PRODUCTO', 19, 'VentaDetalle', 3, 'INGRESO POR MODIFICACIÓN DE VENTA', 350.00, 'INGRESO', 1, NULL, 21, 350.00, 350.00, NULL, 6020.02, '2026-09-16', 1, '2026-09-16 18:49:44', '2026-09-16 18:49:44'),
(91, 1, 1, NULL, 'VENTA DE PRODUCTO', 19, 'VentaDetalle', 3, 'SALIDA POR VENTA', 350.00, 'EGRESO', NULL, 1, 20, 350.00, NULL, 350.00, 5670.02, '2026-09-16', 1, '2026-09-16 18:49:44', '2026-09-16 18:49:44'),
(92, 1, 1, NULL, 'VENTA DE PRODUCTO', 18, 'VentaDetalle', 2, 'INGRESO POR MODIFICACIÓN DE VENTA', 200.00, 'INGRESO', 2, NULL, 13, 200.00, 400.00, NULL, 1230.00, '2026-09-16', 1, '2026-09-16 18:50:00', '2026-09-16 18:50:00'),
(93, 1, 1, NULL, 'VENTA DE PRODUCTO', 18, 'VentaDetalle', 2, 'SALIDA POR VENTA', 200.00, 'EGRESO', NULL, 3, 10, 200.00, NULL, 600.00, 630.00, '2026-09-16', 1, '2026-09-16 18:50:00', '2026-09-16 18:50:00'),
(94, 1, 1, NULL, 'VENTA DE PRODUCTO', 19, 'VentaDetalle', 3, 'INGRESO POR MODIFICACIÓN DE VENTA', 350.00, 'INGRESO', 1, NULL, 21, 350.00, 350.00, NULL, 6020.02, '2026-09-16', 1, '2026-09-16 18:50:00', '2026-09-16 18:50:00'),
(95, 1, 1, NULL, 'VENTA DE PRODUCTO', 19, 'VentaDetalle', 3, 'SALIDA POR VENTA', 350.00, 'EGRESO', NULL, 1, 20, 350.00, NULL, 350.00, 5670.02, '2026-09-16', 1, '2026-09-16 18:50:00', '2026-09-16 18:50:00'),
(96, 3, 3, NULL, 'VENTA DE PRODUCTO', 22, 'VentaDetalle', 2, 'SALIDA POR VENTA', 200.00, 'EGRESO', NULL, 1, 0, 200.00, NULL, 200.00, -80.00, '2026-09-16', 1, '2026-09-16 19:05:17', '2026-09-16 19:05:17'),
(97, 3, 3, NULL, 'VENTA DE PRODUCTO', 23, 'VentaDetalle', 3, 'SALIDA POR VENTA', 350.00, 'EGRESO', NULL, 1, 0, 350.00, NULL, 350.00, -50.00, '2026-09-16', 1, '2026-09-16 19:05:17', '2026-09-16 19:05:17'),
(98, 1, 1, NULL, 'CARGA MASIVA', NULL, '', 7, 'INCREMENTO DE STOCK', 300.00, 'INGRESO', 20, NULL, 20, 300.00, 6000.00, NULL, 6000.00, '2026-09-16', 1, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(99, 1, 1, NULL, 'CARGA MASIVA', NULL, '', 8, 'INCREMENTO DE STOCK', 299.00, 'INGRESO', 20, NULL, 20, 299.00, 5980.00, NULL, 5980.00, '2026-09-16', 1, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(100, 1, 1, NULL, 'CARGA MASIVA', NULL, '', 9, 'INCREMENTO DE STOCK', 298.00, 'INGRESO', 20, NULL, 20, 298.00, 5960.00, NULL, 5960.00, '2026-09-16', 1, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(101, 1, 1, NULL, 'CARGA MASIVA', NULL, '', 10, 'INCREMENTO DE STOCK', 297.00, 'INGRESO', 20, NULL, 20, 297.00, 5940.00, NULL, 5940.00, '2026-09-16', 1, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(102, 1, 1, NULL, 'CARGA MASIVA', NULL, '', 11, 'INCREMENTO DE STOCK', 296.00, 'INGRESO', 20, NULL, 20, 296.00, 5920.00, NULL, 5920.00, '2026-09-16', 1, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(103, 1, 1, NULL, 'CARGA MASIVA', NULL, '', 12, 'INCREMENTO DE STOCK', 295.00, 'INGRESO', 20, NULL, 20, 295.00, 5900.00, NULL, 5900.00, '2026-09-16', 1, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(104, 1, 1, NULL, 'CARGA MASIVA', NULL, '', 13, 'INCREMENTO DE STOCK', 294.00, 'INGRESO', 20, NULL, 20, 294.00, 5880.00, NULL, 5880.00, '2026-09-16', 1, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(105, 1, 1, NULL, 'CARGA MASIVA', NULL, '', 14, 'INCREMENTO DE STOCK', 293.00, 'INGRESO', 20, NULL, 20, 293.00, 5860.00, NULL, 5860.00, '2026-09-16', 1, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(106, 1, 1, NULL, 'CARGA MASIVA', NULL, '', 15, 'INCREMENTO DE STOCK', 292.00, 'INGRESO', 20, NULL, 20, 292.00, 5840.00, NULL, 5840.00, '2026-09-16', 1, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(107, 1, 1, NULL, 'CARGA MASIVA', NULL, '', 16, 'INCREMENTO DE STOCK', 291.00, 'INGRESO', 20, NULL, 20, 291.00, 5820.00, NULL, 5820.00, '2026-09-16', 1, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(108, 1, 1, NULL, 'CARGA MASIVA', NULL, '', 17, 'INCREMENTO DE STOCK', 290.00, 'INGRESO', 20, NULL, 20, 290.00, 5800.00, NULL, 5800.00, '2026-09-16', 1, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(109, 1, 1, NULL, 'CARGA MASIVA', NULL, '', 18, 'INCREMENTO DE STOCK', 289.00, 'INGRESO', 20, NULL, 20, 289.00, 5780.00, NULL, 5780.00, '2026-09-16', 1, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(110, 1, 1, NULL, 'CARGA MASIVA', NULL, '', 19, 'INCREMENTO DE STOCK', 288.00, 'INGRESO', 20, NULL, 20, 288.00, 5760.00, NULL, 5760.00, '2026-09-16', 1, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(111, 1, 1, NULL, 'CARGA MASIVA', NULL, '', 20, 'INCREMENTO DE STOCK', 287.00, 'INGRESO', 20, NULL, 20, 287.00, 5740.00, NULL, 5740.00, '2026-09-16', 1, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(112, 1, 1, NULL, 'CARGA MASIVA', NULL, '', 21, 'INCREMENTO DE STOCK', 286.00, 'INGRESO', 20, NULL, 20, 286.00, 5720.00, NULL, 5720.00, '2026-09-16', 1, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(113, 1, 1, NULL, 'CARGA MASIVA', NULL, '', 22, 'INCREMENTO DE STOCK', 285.00, 'INGRESO', 20, NULL, 20, 285.00, 5700.00, NULL, 5700.00, '2026-09-16', 1, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(114, 1, 1, NULL, 'CARGA MASIVA', NULL, '', 23, 'INCREMENTO DE STOCK', 284.00, 'INGRESO', 20, NULL, 20, 284.00, 5680.00, NULL, 5680.00, '2026-09-16', 1, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(115, 1, 1, NULL, 'CARGA MASIVA', NULL, '', 24, 'INCREMENTO DE STOCK', 283.00, 'INGRESO', 20, NULL, 20, 283.00, 5660.00, NULL, 5660.00, '2026-09-16', 1, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(116, 1, 1, NULL, 'CARGA MASIVA', NULL, '', 25, 'INCREMENTO DE STOCK', 282.00, 'INGRESO', 20, NULL, 20, 282.00, 5640.00, NULL, 5640.00, '2026-09-16', 1, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(117, 1, 1, NULL, 'CARGA MASIVA', NULL, '', 26, 'INCREMENTO DE STOCK', 281.00, 'INGRESO', 20, NULL, 20, 281.00, 5620.00, NULL, 5620.00, '2026-09-16', 1, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(118, 1, 1, NULL, 'CARGA MASIVA', NULL, '', 27, 'INCREMENTO DE STOCK', 280.00, 'INGRESO', 20, NULL, 20, 280.00, 5600.00, NULL, 5600.00, '2026-09-16', 1, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(119, 1, 1, NULL, 'CARGA MASIVA', NULL, '', 28, 'INCREMENTO DE STOCK', 279.00, 'INGRESO', 20, NULL, 20, 279.00, 5580.00, NULL, 5580.00, '2026-09-16', 1, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(120, 1, 1, NULL, 'CARGA MASIVA', NULL, '', 29, 'INCREMENTO DE STOCK', 278.00, 'INGRESO', 20, NULL, 20, 278.00, 5560.00, NULL, 5560.00, '2026-09-16', 1, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(121, 1, 1, NULL, 'CARGA MASIVA', NULL, '', 30, 'INCREMENTO DE STOCK', 277.00, 'INGRESO', 20, NULL, 20, 277.00, 5540.00, NULL, 5540.00, '2026-09-16', 1, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(122, 1, 1, NULL, 'CARGA MASIVA', NULL, '', 31, 'INCREMENTO DE STOCK', 276.00, 'INGRESO', 20, NULL, 20, 276.00, 5520.00, NULL, 5520.00, '2026-09-16', 1, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(123, 1, 1, NULL, 'CARGA MASIVA', NULL, '', 32, 'INCREMENTO DE STOCK', 275.00, 'INGRESO', 20, NULL, 20, 275.00, 5500.00, NULL, 5500.00, '2026-09-16', 1, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(124, 1, 1, NULL, 'CARGA MASIVA', NULL, '', 33, 'INCREMENTO DE STOCK', 274.00, 'INGRESO', 20, NULL, 20, 274.00, 5480.00, NULL, 5480.00, '2026-09-16', 1, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(125, 1, 1, NULL, 'CARGA MASIVA', NULL, '', 34, 'INCREMENTO DE STOCK', 273.00, 'INGRESO', 20, NULL, 20, 273.00, 5460.00, NULL, 5460.00, '2026-09-16', 1, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(126, 1, 1, NULL, 'CARGA MASIVA', NULL, '', 35, 'INCREMENTO DE STOCK', 272.00, 'INGRESO', 20, NULL, 20, 272.00, 5440.00, NULL, 5440.00, '2026-09-16', 1, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(127, 1, 1, NULL, 'CARGA MASIVA', NULL, '', 36, 'INCREMENTO DE STOCK', 271.00, 'INGRESO', 20, NULL, 20, 271.00, 5420.00, NULL, 5420.00, '2026-09-16', 1, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(128, 1, 1, NULL, 'CARGA MASIVA', NULL, '', 37, 'INCREMENTO DE STOCK', 270.00, 'INGRESO', 20, NULL, 20, 270.00, 5400.00, NULL, 5400.00, '2026-09-16', 1, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(129, 1, 1, NULL, 'CARGA MASIVA', NULL, '', 38, 'INCREMENTO DE STOCK', 269.00, 'INGRESO', 20, NULL, 20, 269.00, 5380.00, NULL, 5380.00, '2026-09-16', 1, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(130, 1, 1, NULL, 'CARGA MASIVA', NULL, '', 39, 'INCREMENTO DE STOCK', 268.00, 'INGRESO', 20, NULL, 20, 268.00, 5360.00, NULL, 5360.00, '2026-09-16', 1, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(131, 1, 1, NULL, 'CARGA MASIVA', NULL, '', 40, 'INCREMENTO DE STOCK', 267.00, 'INGRESO', 20, NULL, 20, 267.00, 5340.00, NULL, 5340.00, '2026-09-16', 1, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(132, 1, 1, NULL, 'CARGA MASIVA', NULL, '', 41, 'INCREMENTO DE STOCK', 266.00, 'INGRESO', 20, NULL, 20, 266.00, 5320.00, NULL, 5320.00, '2026-09-16', 1, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(133, 1, 1, NULL, 'TRASPASO DE PRODUCTOS', 19, 'TraspasoDetalle', 3, 'TRASPASO 10 PRODUCTOS A ALMACEN 2', 300.00, 'EGRESO', NULL, 10, 10, 300.00, NULL, 3000.00, 2670.02, '2026-09-16', 1, '2026-09-16 19:49:39', '2026-09-16 19:49:39'),
(134, 3, 3, NULL, 'TRASPASO DE PRODUCTOS', 19, 'TraspasoDetalle', 3, 'TRASPASO 10 PRODUCTOS A ALMACEN 2', 300.00, 'INGRESO', 10, NULL, 10, 300.00, 3000.00, NULL, 2950.00, '2026-09-16', 1, '2026-09-16 19:49:39', '2026-09-16 19:49:39'),
(135, 1, 1, NULL, 'VENTA DE PRODUCTO', 24, 'VentaDetalle', 2, 'SALIDA POR VENTA', 200.00, 'EGRESO', NULL, 1, 9, 200.00, NULL, 200.00, 430.00, '2026-09-16', 1, '2026-09-16 21:22:14', '2026-09-16 21:22:14'),
(136, 1, 1, NULL, 'VENTA DE PRODUCTO', 25, 'VentaDetalle', 3, 'SALIDA POR VENTA', 350.00, 'EGRESO', NULL, 1, 9, 350.00, NULL, 350.00, 2320.02, '2026-09-16', 1, '2026-09-16 21:22:14', '2026-09-16 21:22:14'),
(137, 1, 1, NULL, 'VENTA DE PRODUCTO', 24, 'VentaDetalle', 2, 'INGRESO POR MODIFICACIÓN DE VENTA', 200.00, 'INGRESO', 1, NULL, 10, 200.00, 200.00, NULL, 630.00, '2026-09-16', 1, '2026-09-16 21:24:58', '2026-09-16 21:24:58'),
(138, 1, 1, NULL, 'VENTA DE PRODUCTO', 24, 'VentaDetalle', 2, 'SALIDA POR VENTA', 200.00, 'EGRESO', NULL, 1, 9, 200.00, NULL, 200.00, 430.00, '2026-09-16', 1, '2026-09-16 21:24:58', '2026-09-16 21:24:58'),
(139, 1, 1, NULL, 'VENTA DE PRODUCTO', 25, 'VentaDetalle', 3, 'INGRESO POR MODIFICACIÓN DE VENTA', 350.00, 'INGRESO', 1, NULL, 10, 350.00, 350.00, NULL, 2670.02, '2026-09-16', 1, '2026-09-16 21:24:58', '2026-09-16 21:24:58'),
(140, 1, 1, NULL, 'VENTA DE PRODUCTO', 25, 'VentaDetalle', 3, 'SALIDA POR VENTA', 350.00, 'EGRESO', NULL, 1, 9, 350.00, NULL, 350.00, 2320.02, '2026-09-16', 1, '2026-09-16 21:24:58', '2026-09-16 21:24:58'),
(141, 1, 1, NULL, 'VENTA DE PRODUCTO', 26, 'VentaDetalle', 6, 'SALIDA POR VENTA', 200.00, 'EGRESO', NULL, 1, 8, 200.00, NULL, 200.00, 880.00, '2026-09-16', 1, '2026-09-16 21:24:58', '2026-09-16 21:24:58'),
(142, 1, 1, NULL, 'VENTA DE PRODUCTO', 24, 'VentaDetalle', 2, 'INGRESO POR MODIFICACIÓN DE VENTA', 200.00, 'INGRESO', 1, NULL, 10, 200.00, 200.00, NULL, 630.00, '2026-09-16', 1, '2026-09-16 21:25:13', '2026-09-16 21:25:13'),
(143, 1, 1, NULL, 'VENTA DE PRODUCTO', 24, 'VentaDetalle', 2, 'SALIDA POR VENTA', 200.00, 'EGRESO', NULL, 1, 9, 200.00, NULL, 200.00, 430.00, '2026-09-16', 1, '2026-09-16 21:25:13', '2026-09-16 21:25:13'),
(144, 1, 1, NULL, 'VENTA DE PRODUCTO', 25, 'VentaDetalle', 3, 'INGRESO POR MODIFICACIÓN DE VENTA', 350.00, 'INGRESO', 1, NULL, 10, 350.00, 350.00, NULL, 2670.02, '2026-09-16', 1, '2026-09-16 21:25:13', '2026-09-16 21:25:13'),
(145, 1, 1, NULL, 'VENTA DE PRODUCTO', 25, 'VentaDetalle', 3, 'SALIDA POR VENTA', 350.00, 'EGRESO', NULL, 1, 9, 350.00, NULL, 350.00, 2320.02, '2026-09-16', 1, '2026-09-16 21:25:13', '2026-09-16 21:25:13'),
(146, 1, 1, NULL, 'VENTA DE PRODUCTO', 26, 'VentaDetalle', 6, 'INGRESO POR MODIFICACIÓN DE VENTA', 200.00, 'INGRESO', 1, NULL, 9, 200.00, 200.00, NULL, 1080.00, '2026-09-16', 1, '2026-09-16 21:25:13', '2026-09-16 21:25:13'),
(147, 1, 1, NULL, 'VENTA DE PRODUCTO', 26, 'VentaDetalle', 6, 'SALIDA POR VENTA', 200.00, 'EGRESO', NULL, 1, 8, 200.00, NULL, 200.00, 880.00, '2026-09-16', 1, '2026-09-16 21:25:13', '2026-09-16 21:25:13'),
(148, 3, 3, NULL, 'VENTA DE PRODUCTO', 22, 'VentaDetalle', 2, 'INGRESO POR MODIFICACIÓN DE VENTA', 200.00, 'INGRESO', 1, NULL, 1, 200.00, 200.00, NULL, 120.00, '2026-09-16', 1, '2026-09-16 21:25:32', '2026-09-16 21:25:32'),
(149, 3, 3, NULL, 'VENTA DE PRODUCTO', 22, 'VentaDetalle', 2, 'SALIDA POR VENTA', 200.00, 'EGRESO', NULL, 1, 0, 200.00, NULL, 200.00, -80.00, '2026-09-16', 1, '2026-09-16 21:25:32', '2026-09-16 21:25:32'),
(150, 3, 3, NULL, 'VENTA DE PRODUCTO', 23, 'VentaDetalle', 3, 'INGRESO POR MODIFICACIÓN DE VENTA', 350.00, 'INGRESO', 1, NULL, 11, 350.00, 350.00, NULL, 3300.00, '2026-09-16', 1, '2026-09-16 21:25:32', '2026-09-16 21:25:32'),
(151, 3, 3, NULL, 'VENTA DE PRODUCTO', 23, 'VentaDetalle', 3, 'SALIDA POR VENTA', 350.00, 'EGRESO', NULL, 1, 10, 350.00, NULL, 350.00, 2950.00, '2026-09-16', 1, '2026-09-16 21:25:32', '2026-09-16 21:25:32'),
(152, 1, 1, 19, 'INGRESO DE PRODUCTO', 19, 'IngresoDetalle', 2, 'INGRESO 1', 120.00, 'INGRESO', 5, NULL, 14, 120.00, 600.00, NULL, 1030.00, '2026-09-20', 1, '2026-09-20 18:46:44', '2026-09-20 18:46:44'),
(153, 1, 1, 20, 'INGRESO DE PRODUCTO', 20, 'IngresoDetalle', 3, 'INGRESO 1', 300.00, 'INGRESO', 5, NULL, 14, 300.00, 1500.00, NULL, 3820.02, '2026-09-20', 1, '2026-09-20 18:46:44', '2026-09-20 18:46:44'),
(154, 1, 1, 19, 'INGRESO DE PRODUCTO', 19, 'IngresoDetalle', 2, 'INGRESO POR RECEPCIÓN DE FALTANTE DE COMPRA', 120.00, 'INGRESO', 3, NULL, 17, 120.00, 360.00, NULL, 1390.00, '2026-09-20', 1, '2026-09-20 20:04:23', '2026-09-20 20:04:23'),
(155, 1, 1, 20, 'INGRESO DE PRODUCTO', 20, 'IngresoDetalle', 3, 'INGRESO POR RECEPCIÓN DE FALTANTE DE COMPRA', 300.00, 'INGRESO', 2, NULL, 16, 300.00, 600.00, NULL, 4420.02, '2026-09-20', 1, '2026-09-21 01:07:27', '2026-09-21 01:07:27'),
(156, 1, 1, 20, 'INGRESO DE PRODUCTO', 20, 'IngresoDetalle', 3, 'INGRESO POR RECEPCIÓN DE FALTANTE DE COMPRA', 300.00, 'INGRESO', 1, NULL, 17, 300.00, 300.00, NULL, 4720.02, '2026-09-20', 1, '2026-09-21 01:11:14', '2026-09-21 01:11:14'),
(157, 1, 1, 20, 'INGRESO DE PRODUCTO', 20, 'IngresoDetalle', 3, 'INGRESO POR RECEPCIÓN DE FALTANTE DE COMPRA', 300.00, 'INGRESO', 1, NULL, 18, 300.00, 300.00, NULL, 5020.02, '2026-09-20', 1, '2026-09-21 01:12:31', '2026-09-21 01:12:31'),
(158, 1, 1, 19, 'INGRESO DE PRODUCTO', 19, 'IngresoDetalle', 2, 'INGRESO POR RECEPCIÓN DE FALTANTE DE COMPRA', 120.00, 'INGRESO', 2, NULL, 19, 120.00, 240.00, NULL, 1630.00, '2026-09-20', 1, '2026-09-21 01:13:09', '2026-09-21 01:13:09'),
(159, 1, 1, 20, 'INGRESO DE PRODUCTO', 20, 'IngresoDetalle', 3, 'INGRESO POR RECEPCIÓN DE FALTANTE DE COMPRA', 300.00, 'INGRESO', 1, NULL, 19, 300.00, 300.00, NULL, 5320.02, '2026-09-20', 1, '2026-09-21 01:13:09', '2026-09-21 01:13:09'),
(160, 1, 1, NULL, 'VENTA DE PRODUCTO', 27, 'VentaDetalle', 2, 'SALIDA POR VENTA', 248.78, 'EGRESO', NULL, 1, 18, 248.78, NULL, 248.78, 1381.22, '2026-09-23', 1, '2026-09-23 14:35:36', '2026-09-23 14:35:36'),
(161, 1, 1, NULL, 'VENTA DE PRODUCTO', 28, 'VentaDetalle', 3, 'SALIDA POR VENTA', 351.22, 'EGRESO', NULL, 1, 18, 351.22, NULL, 351.22, 4968.80, '2026-09-23', 1, '2026-09-23 14:35:36', '2026-09-23 14:35:36'),
(162, 1, 1, NULL, 'VENTA DE PRODUCTO', 29, 'VentaDetalle', 2, 'SALIDA POR VENTA', 200.00, 'EGRESO', NULL, 1, 17, 200.00, NULL, 200.00, 1181.22, '2026-09-23', 1, '2026-09-23 14:39:37', '2026-09-23 14:39:37'),
(163, 1, 1, NULL, 'VENTA DE PRODUCTO', 30, 'VentaDetalle', 2, 'SALIDA POR VENTA', 200.00, 'EGRESO', NULL, 1, 16, 200.00, NULL, 200.00, 981.22, '2026-09-23', 1, '2026-09-23 14:40:45', '2026-09-23 14:40:45'),
(164, 1, 1, NULL, 'VENTA DE PRODUCTO', 31, 'VentaDetalle', 3, 'SALIDA POR VENTA', 360.00, 'EGRESO', NULL, 1, 17, 360.00, NULL, 360.00, 4608.80, '2026-09-23', 1, '2026-09-23 14:41:24', '2026-09-23 14:41:24');

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
(1, 1, 1, 'COMPRA DE PRODUCTOS', 'IngresoProducto', 4, 300.00, 0.00, 300.00, 'EGRESO', 'EFECTIVO', 'COMPRA DE PRODUCTOS', '2026-08-24', '21:35:28', 1, 1, '2026-08-25 01:35:28', '2026-08-25 01:35:28'),
(2, 1, 1, 'MOVIMIENTO DE CAJA', 'MovimientoCaja', 2, 2000.00, 0.00, 2000.00, 'INGRESO', 'EFECTIVO', 'ingreso de efectivo', '2026-09-03', '11:16:34', 1, 1, '2026-09-03 15:18:33', '2026-09-03 15:31:35'),
(3, 1, 1, 'VENTA', 'Venta', 9, 350.00, 0.00, 350.00, 'INGRESO', 'EFECTIVO', 'INGRESO POR VENTA', '2026-09-07', '10:32:13', 1, 1, '2026-09-07 14:32:14', '2026-09-07 14:32:14'),
(4, 1, 1, 'PAGO POR COMPRA DE PRODUCTOS', 'IngresoPago', 3, 380.00, 0.00, 380.00, 'EGRESO', 'EFECTIVO', 'PAGO POR COMPRA DE PRODUCTOS', '2026-09-07', '12:30:17', 1, 1, '2026-09-07 16:30:17', '2026-09-10 16:06:58'),
(5, 1, 1, 'VENTA', 'Venta', 12, 0.00, 100.00, 100.00, 'INGRESO', 'QR', 'INGRESO POR VENTA', '2026-09-08', '11:01:10', 1, 1, '2026-09-08 15:01:11', '2026-09-08 15:01:11'),
(6, 1, 1, 'COBRO POR VENTA DE PRODUCTOS', 'VentaCobro', 2, 700.00, 0.00, 700.00, 'INGRESO', 'EFECTIVO', 'COBRO POR VENTA DE PRODUCTOS', '2026-09-09', '10:25:07', 1, 0, '2026-09-09 14:25:07', '2026-09-11 15:13:14'),
(7, 1, 1, 'COBRO POR VENTA DE PRODUCTOS', 'VentaCobro', 3, 0.00, 70.00, 70.00, 'INGRESO', 'QR', 'COBRO POR VENTA DE PRODUCTOS', '2026-09-09', '10:26:40', 1, 0, '2026-09-09 14:26:40', '2026-09-11 15:12:45'),
(8, 1, 1, 'COBRO POR VENTA DE PRODUCTOS', 'VentaCobro', 4, 50.00, 0.00, 50.00, 'INGRESO', 'EFECTIVO', 'COBRO POR VENTA DE PRODUCTOS', '2026-09-09', '10:29:45', 1, 1, '2026-09-09 14:29:45', '2026-09-09 14:29:45'),
(10, 1, 1, 'VENTA', 'Venta', 13, 1090.00, 0.00, 1090.00, 'INGRESO', 'EFECTIVO', 'INGRESO POR VENTA', '2026-09-09', '16:25:25', 1, 1, '2026-09-09 20:58:31', '2026-09-09 20:58:31'),
(11, 1, 1, 'PAGO POR COMPRA DE PRODUCTOS', 'IngresoPago', 4, 100.00, 0.00, 100.00, 'EGRESO', 'EFECTIVO', 'PAGO POR COMPRA DE PRODUCTOS', '2026-09-10', '12:07:07', 1, 1, '2026-09-10 16:07:07', '2026-09-10 16:09:01'),
(12, 1, 1, 'PAGO POR COMPRA DE PRODUCTOS', 'IngresoPago', 5, 100.00, 0.00, 100.00, 'EGRESO', 'EFECTIVO', 'PAGO POR COMPRA DE PRODUCTOS', '2026-09-10', '12:09:08', 1, 0, '2026-09-10 16:09:08', '2026-09-11 15:25:45'),
(13, 1, 1, 'PAGO POR COMPRA DE PRODUCTOS', 'IngresoPago', 6, 10.00, 0.00, 10.00, 'EGRESO', 'EFECTIVO', 'PAGO POR COMPRA DE PRODUCTOS', '2026-09-10', '12:11:06', 1, 0, '2026-09-10 16:11:06', '2026-09-11 15:25:40'),
(14, 1, 1, 'PAGO POR COMPRA DE PRODUCTOS', 'IngresoPago', 7, 10.00, 0.00, 10.00, 'EGRESO', 'EFECTIVO', 'PAGO POR COMPRA DE PRODUCTOS', '2026-09-10', '12:11:13', 1, 0, '2026-09-10 16:11:13', '2026-09-11 15:25:36'),
(15, 1, 1, 'PAGO POR COMPRA DE PRODUCTOS', 'IngresoPago', 8, 100.00, 0.00, 100.00, 'EGRESO', 'EFECTIVO', 'PAGO POR COMPRA DE PRODUCTOS', '2026-09-10', '12:11:43', 1, 0, '2026-09-10 16:11:43', '2026-09-11 15:25:33'),
(16, 1, 1, 'PAGO POR COMPRA DE PRODUCTOS', 'IngresoPago', 9, 10.00, 0.00, 10.00, 'EGRESO', 'EFECTIVO', 'PAGO POR COMPRA DE PRODUCTOS', '2026-09-10', '12:13:03', 1, 0, '2026-09-10 16:13:03', '2026-09-11 15:25:26'),
(17, 1, 1, 'PAGO POR COMPRA DE PRODUCTOS', 'IngresoPago', 10, 20.00, 0.00, 20.00, 'EGRESO', 'EFECTIVO', 'PAGO POR COMPRA DE PRODUCTOS', '2026-09-10', '12:14:02', 1, 0, '2026-09-10 16:14:02', '2026-09-11 15:25:17'),
(18, 1, 1, 'COBRO POR VENTA DE PRODUCTOS', 'VentaCobro', 5, 10.00, 0.00, 10.00, 'INGRESO', 'EFECTIVO', 'COBRO POR VENTA DE PRODUCTOS', '2026-09-10', '12:16:07', 1, 1, '2026-09-10 16:16:07', '2026-09-10 16:16:07'),
(19, 1, 1, 'MOVIMIENTO DE CAJA', 'MovimientoCaja', 19, 0.00, 400.00, 400.00, 'INGRESO', 'QR', 'Ingreso prueba modificado', '2026-09-11', '11:30:21', 1, 1, '2026-09-11 15:30:35', '2026-09-11 15:31:50'),
(20, 1, 1, 'COMPRA DE PRODUCTOS', 'IngresoProducto', 9, 240.00, 0.00, 240.00, 'EGRESO', 'EFECTIVO', 'COMPRA DE PRODUCTOS', '2026-09-13', '16:34:45', 1, 1, '2026-09-13 20:34:45', '2026-09-13 20:34:45'),
(21, 3, 3, 'VENTA', 'Venta', 14, 590.00, 0.00, 590.00, 'INGRESO', 'EFECTIVO', 'INGRESO POR VENTA', '2026-09-15', '10:41:26', 1, 0, '2026-09-15 14:41:26', '2026-09-16 19:05:17'),
(22, 1, 1, 'COBRO POR VENTA DE PRODUCTOS', 'VentaCobro', 6, 500.00, 0.00, 500.00, 'INGRESO', 'EFECTIVO', 'COBRO POR VENTA DE PRODUCTOS', '2026-09-15', '11:22:58', 1, 1, '2026-09-15 15:22:58', '2026-09-15 15:22:58'),
(23, 1, 1, 'COBRO POR VENTA DE PRODUCTOS', 'VentaCobro', 7, 0.00, 50.00, 50.00, 'INGRESO', 'QR', 'COBRO POR VENTA DE PRODUCTOS', '2026-09-15', '11:23:38', 1, 1, '2026-09-15 15:23:38', '2026-09-15 15:23:49'),
(24, 1, 1, 'COMPRA DE PRODUCTOS', 'IngresoProducto', 12, 540.00, 0.00, 540.00, 'EGRESO', 'EFECTIVO', 'COMPRA DE PRODUCTOS', '2026-09-16', '10:22:25', 1, 1, '2026-09-16 14:22:25', '2026-09-16 14:22:25'),
(25, 1, 1, 'VENTA', 'Venta', 15, 50.00, 0.00, 50.00, 'INGRESO', 'EFECTIVO', 'INGRESO POR VENTA', '2026-09-16', '10:33:00', 1, 1, '2026-09-16 14:33:00', '2026-09-16 14:33:00'),
(26, 1, 1, 'PAGO POR COMPRA DE PRODUCTOS', 'IngresoPago', 11, 300.00, 0.00, 300.00, 'EGRESO', 'EFECTIVO', 'PAGO POR COMPRA DE PRODUCTOS', '2026-09-16', '10:36:53', 1, 1, '2026-09-16 14:36:53', '2026-09-16 14:36:53'),
(27, 1, 1, 'MOVIMIENTO DE CAJA', 'MovimientoCaja', 27, 2000.00, 0.00, 2000.00, 'INGRESO', 'EFECTIVO', 'ingreso de prueba', '2026-09-16', '10:37:02', 1, 1, '2026-09-16 14:38:13', '2026-09-16 14:38:13'),
(28, 1, 1, 'COBRO POR VENTA DE PRODUCTOS', 'VentaCobro', 8, 10.00, 10.00, 20.00, 'INGRESO', 'EFECTIVO-QR', 'COBRO POR VENTA DE PRODUCTOS', '2026-09-16', '14:50:35', 1, 1, '2026-09-16 18:50:35', '2026-09-16 21:46:42'),
(29, 3, 3, 'VENTA', 'Venta', 14, 550.00, 0.00, 550.00, 'INGRESO', 'EFECTIVO', 'INGRESO POR VENTA', '2026-09-15', '10:41:26', 1, 1, '2026-09-16 19:05:17', '2026-09-16 19:05:17'),
(31, 1, 1, 'MOVIMIENTO DE CAJA', 'MovimientoCaja', 31, 80.00, 20.00, 100.00, 'INGRESO', 'EFECTIVO-QR', 'ingreso mixto', '2026-09-16', '16:57:29', 1, 1, '2026-09-16 20:58:56', '2026-09-16 21:00:20'),
(32, 1, 1, 'COMPRA DE PRODUCTOS', 'IngresoProducto', 16, 200.00, 40.00, 240.00, 'EGRESO', 'EFECTIVO-QR', 'COMPRA DE PRODUCTOS', '2026-09-16', '17:08:19', 1, 1, '2026-09-16 21:08:19', '2026-09-16 21:08:19'),
(33, 1, 1, 'VENTA', 'Venta', 17, 500.00, 50.00, 550.00, 'INGRESO', 'EFECTIVO-QR', 'INGRESO POR VENTA', '2026-09-16', '17:22:14', 1, 0, '2026-09-16 21:22:14', '2026-09-16 21:24:58'),
(34, 1, 1, 'VENTA', 'Venta', 17, 500.00, 250.00, 750.00, 'INGRESO', 'EFECTIVO-QR', 'INGRESO POR VENTA', '2026-09-16', '17:22:14', 1, 1, '2026-09-16 21:24:58', '2026-09-16 21:24:58'),
(35, 1, 1, 'VENTA', 'Venta', 17, 0.00, 250.00, 250.00, 'INGRESO', 'QR', 'INGRESO POR VENTA', '2026-09-16', '17:22:14', 1, 1, '2026-09-16 21:25:13', '2026-09-16 21:25:13'),
(36, 3, 3, 'VENTA', 'Venta', 14, 500.00, 50.00, 550.00, 'INGRESO', 'EFECTIVO-QR', 'INGRESO POR VENTA', '2026-09-15', '10:41:26', 1, 1, '2026-09-16 21:25:32', '2026-09-16 21:25:32'),
(37, 1, 1, 'COBRO POR VENTA DE PRODUCTOS', 'VentaCobro', 9, 20.00, 20.00, 40.00, 'INGRESO', 'EFECTIVO-QR', 'COBRO POR VENTA DE PRODUCTOS', '2026-09-16', '17:34:57', 1, 1, '2026-09-16 21:34:57', '2026-09-16 21:38:34'),
(38, 1, 1, 'COBRO POR VENTA DE PRODUCTOS', 'VentaCobro', 10, 20.00, 0.00, 20.00, 'INGRESO', 'EFECTIVO', 'COBRO POR VENTA DE PRODUCTOS', '2026-09-16', '17:38:50', 1, 1, '2026-09-16 21:38:50', '2026-09-16 21:39:31'),
(39, 1, 1, 'COBRO POR VENTA DE PRODUCTOS', 'VentaCobro', 12, 180.00, 0.00, 180.00, 'INGRESO', 'EFECTIVO', 'COBRO POR VENTA DE PRODUCTOS', '2026-09-16', '17:39:52', 1, 1, '2026-09-16 21:39:52', '2026-09-16 21:39:52'),
(40, 1, 1, 'PAGO POR COMPRA DE PRODUCTOS', 'IngresoPago', 12, 120.00, 20.00, 140.00, 'EGRESO', 'EFECTIVO-QR', 'PAGO POR COMPRA DE PRODUCTOS', '2026-09-16', '17:53:06', 1, 0, '2026-09-16 21:53:06', '2026-09-16 21:56:10'),
(41, 1, 1, 'PAGO POR COMPRA DE PRODUCTOS', 'IngresoPago', 13, 20.00, 20.00, 40.00, 'EGRESO', 'EFECTIVO-QR', 'PAGO POR COMPRA DE PRODUCTOS', '2026-09-16', '17:56:38', 1, 0, '2026-09-16 21:56:38', '2026-09-16 21:58:29'),
(42, 1, 1, 'PAGO POR COMPRA DE PRODUCTOS', 'IngresoPago', 14, 20.00, 20.00, 40.00, 'EGRESO', 'EFECTIVO-QR', 'PAGO POR COMPRA DE PRODUCTOS', '2026-09-16', '17:58:42', 1, 0, '2026-09-16 21:58:42', '2026-09-16 21:59:36'),
(43, 1, 1, 'PAGO POR COMPRA DE PRODUCTOS', 'IngresoPago', 15, 20.00, 20.00, 40.00, 'EGRESO', 'EFECTIVO-QR', 'PAGO POR COMPRA DE PRODUCTOS', '2026-09-16', '17:59:48', 1, 1, '2026-09-16 21:59:48', '2026-09-16 22:04:52'),
(44, 1, 1, 'PAGO POR COMPRA DE PRODUCTOS', 'IngresoPago', 16, 900.00, 80.00, 980.00, 'EGRESO', 'EFECTIVO-QR', 'PAGO POR COMPRA DE PRODUCTOS', '2026-09-16', '18:09:40', 1, 1, '2026-09-16 22:09:40', '2026-09-16 22:09:40'),
(45, 1, 1, 'VENTA', 'Venta', 18, 600.00, 0.00, 600.00, 'INGRESO', 'EFECTIVO', 'INGRESO POR VENTA', '2026-09-23', '10:35:36', 1, 1, '2026-09-23 14:35:36', '2026-09-23 14:35:36'),
(46, 1, 1, 'VENTA', 'Venta', 25, 180.00, 180.00, 360.00, 'INGRESO', 'EFECTIVO-QR', 'INGRESO POR VENTA', '2026-09-23', '10:41:24', 1, 1, '2026-09-23 14:41:24', '2026-09-23 14:41:24');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notificacions`
--

CREATE TABLE `notificacions` (
  `id` bigint UNSIGNED NOT NULL,
  `modulo` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `registro_id` bigint UNSIGNED DEFAULT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci NOT NULL,
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
  `caracteristicas` text COLLATE utf8mb4_unicode_ci,
  `calidad` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cobertura` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `formato` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
(2, 'F14242BAP', 'BARRO COPINO', 1, 1, 3, NULL, '', NULL, NULL, 95.00, 97.00, 98.00, NULL, 90.00, 3, '21783799752.jpeg', 1, '2026-07-11', '2026-07-11 19:55:52', '2026-10-15 14:33:05'),
(3, 'P002', 'PRODUCTO 2', 1, 1, 1, NULL, '', NULL, NULL, 350.00, 400.00, 420.00, 450.00, 300.00, 3, NULL, 1, '2026-07-11', '2026-07-11 20:00:05', '2026-09-06 21:18:15'),
(4, 'P003', 'PRODUCTO 3', 2, 2, 1, NULL, '', NULL, NULL, 390.00, NULL, NULL, NULL, 300.00, 5, NULL, 1, '2026-07-13', '2026-07-13 20:15:16', '2026-07-15 20:02:46'),
(5, 'CODP', 'PRODUCTO NUEVO', 3, 3, 1, NULL, '', NULL, NULL, 300.00, 200.00, NULL, NULL, 240.00, 1, NULL, 1, '2026-09-11', NULL, NULL),
(6, 'P004', 'PRODUCTO 4', 2, 4, 1, NULL, '', NULL, NULL, 200.00, 190.00, NULL, NULL, 120.00, 1, NULL, 1, '2026-09-13', NULL, NULL),
(7, 'P005', 'PRODUCTO 5', 1, 2, 1, NULL, '', NULL, NULL, 343.00, NULL, NULL, NULL, 300.00, 1, NULL, 1, '2026-09-16', NULL, NULL),
(8, 'P006', 'PRODUCTO 6', 1, 2, 1, NULL, '', NULL, NULL, 344.00, NULL, NULL, NULL, 299.00, 1, NULL, 1, '2026-09-16', NULL, NULL),
(9, 'P007', 'PRODUCTO 7', 1, 2, 1, NULL, '', NULL, NULL, 345.00, NULL, NULL, NULL, 298.00, 1, NULL, 1, '2026-09-16', NULL, NULL),
(10, 'P008', 'PRODUCTO 8', 1, 2, 1, NULL, '', NULL, NULL, 346.00, NULL, NULL, NULL, 297.00, 1, NULL, 1, '2026-09-16', NULL, NULL),
(11, 'P009', 'PRODUCTO 9', 1, 2, 1, NULL, '', NULL, NULL, 347.00, NULL, NULL, NULL, 296.00, 1, NULL, 1, '2026-09-16', NULL, NULL),
(12, 'P010', 'PRODUCTO 10', 1, 2, 1, NULL, '', NULL, NULL, 348.00, NULL, NULL, NULL, 295.00, 1, NULL, 1, '2026-09-16', NULL, NULL),
(13, 'P011', 'PRODUCTO 11', 1, 2, 1, NULL, '', NULL, NULL, 349.00, NULL, NULL, NULL, 294.00, 1, NULL, 1, '2026-09-16', NULL, NULL),
(14, 'P012', 'PRODUCTO 12', 1, 2, 1, NULL, '', NULL, NULL, 350.00, NULL, NULL, NULL, 293.00, 1, NULL, 1, '2026-09-16', NULL, NULL),
(15, 'P013', 'PRODUCTO 13', 1, 2, 1, NULL, '', NULL, NULL, 351.00, NULL, NULL, NULL, 292.00, 1, NULL, 1, '2026-09-16', NULL, NULL),
(16, 'P014', 'PRODUCTO 14', 1, 2, 1, NULL, '', NULL, NULL, 352.00, NULL, NULL, NULL, 291.00, 1, NULL, 1, '2026-09-16', NULL, NULL),
(17, 'P015', 'PRODUCTO 15', 1, 2, 1, NULL, '', NULL, NULL, 353.00, NULL, NULL, NULL, 290.00, 1, NULL, 1, '2026-09-16', NULL, NULL),
(18, 'P016', 'PRODUCTO 16', 1, 2, 1, NULL, '', NULL, NULL, 354.00, NULL, NULL, NULL, 289.00, 1, NULL, 1, '2026-09-16', NULL, NULL),
(19, 'P017', 'PRODUCTO 17', 1, 2, 1, NULL, '', NULL, NULL, 355.00, NULL, NULL, NULL, 288.00, 1, NULL, 1, '2026-09-16', NULL, NULL),
(20, 'P018', 'PRODUCTO 18', 1, 2, 1, NULL, '', NULL, NULL, 356.00, NULL, NULL, NULL, 287.00, 1, NULL, 1, '2026-09-16', NULL, NULL),
(21, 'P019', 'PRODUCTO 19', 1, 2, 1, NULL, '', NULL, NULL, 357.00, NULL, NULL, NULL, 286.00, 1, NULL, 1, '2026-09-16', NULL, NULL),
(22, 'P020', 'PRODUCTO 20', 1, 2, 1, NULL, '', NULL, NULL, 358.00, NULL, NULL, NULL, 285.00, 1, NULL, 1, '2026-09-16', NULL, NULL),
(23, 'P021', 'PRODUCTO 21', 1, 2, 1, NULL, '', NULL, NULL, 359.00, NULL, NULL, NULL, 284.00, 1, NULL, 1, '2026-09-16', NULL, NULL),
(24, 'P022', 'PRODUCTO 22', 1, 2, 1, NULL, '', NULL, NULL, 360.00, NULL, NULL, NULL, 283.00, 1, NULL, 1, '2026-09-16', NULL, NULL),
(25, 'P023', 'PRODUCTO 23', 1, 2, 1, NULL, '', NULL, NULL, 361.00, NULL, NULL, NULL, 282.00, 1, NULL, 1, '2026-09-16', NULL, NULL),
(26, 'P024', 'PRODUCTO 24', 1, 2, 1, NULL, '', NULL, NULL, 362.00, NULL, NULL, NULL, 281.00, 1, NULL, 1, '2026-09-16', NULL, NULL),
(27, 'P025', 'PRODUCTO 25', 1, 2, 1, NULL, '', NULL, NULL, 363.00, NULL, NULL, NULL, 280.00, 1, NULL, 1, '2026-09-16', NULL, NULL),
(28, 'P026', 'PRODUCTO 26', 1, 2, 1, NULL, '', NULL, NULL, 364.00, NULL, NULL, NULL, 279.00, 1, NULL, 1, '2026-09-16', NULL, NULL),
(29, 'P027', 'PRODUCTO 27', 1, 2, 1, NULL, '', NULL, NULL, 365.00, NULL, NULL, NULL, 278.00, 1, NULL, 1, '2026-09-16', NULL, NULL),
(30, 'P028', 'PRODUCTO 28', 1, 2, 1, NULL, '', NULL, NULL, 366.00, NULL, NULL, NULL, 277.00, 1, NULL, 1, '2026-09-16', NULL, NULL),
(31, 'P029', 'PRODUCTO 29', 1, 2, 1, NULL, '', NULL, NULL, 367.00, NULL, NULL, NULL, 276.00, 1, NULL, 1, '2026-09-16', NULL, NULL),
(32, 'P030', 'PRODUCTO 30', 1, 2, 1, NULL, '', NULL, NULL, 368.00, NULL, NULL, NULL, 275.00, 1, NULL, 1, '2026-09-16', NULL, NULL),
(33, 'P031', 'PRODUCTO 31', 1, 2, 1, NULL, '', NULL, NULL, 369.00, NULL, NULL, NULL, 274.00, 1, NULL, 1, '2026-09-16', NULL, NULL),
(34, 'P032', 'PRODUCTO 32', 1, 2, 1, NULL, '', NULL, NULL, 370.00, NULL, NULL, NULL, 273.00, 1, NULL, 1, '2026-09-16', NULL, NULL),
(35, 'P033', 'PRODUCTO 33', 1, 2, 1, NULL, '', NULL, NULL, 371.00, NULL, NULL, NULL, 272.00, 1, NULL, 1, '2026-09-16', NULL, NULL),
(36, 'P034', 'PRODUCTO 34', 1, 2, 1, NULL, '', NULL, NULL, 372.00, NULL, NULL, NULL, 271.00, 1, NULL, 1, '2026-09-16', NULL, NULL),
(37, 'P035', 'PRODUCTO 35', 1, 2, 1, NULL, '', NULL, NULL, 373.00, NULL, NULL, NULL, 270.00, 1, NULL, 1, '2026-09-16', NULL, NULL),
(38, 'P036', 'PRODUCTO 36', 1, 2, 1, NULL, '', NULL, NULL, 374.00, NULL, NULL, NULL, 269.00, 1, NULL, 1, '2026-09-16', NULL, NULL),
(39, 'P037', 'PRODUCTO 37', 1, 2, 1, NULL, '', NULL, NULL, 375.00, NULL, NULL, NULL, 268.00, 1, NULL, 1, '2026-09-16', NULL, NULL),
(40, 'P038', 'PRODUCTO 38', 1, 2, 1, NULL, '', NULL, NULL, 376.00, NULL, NULL, NULL, 267.00, 1, NULL, 1, '2026-09-16', NULL, NULL),
(41, 'P039', 'PRODUCTO 39', 1, 2, 1, 'NEQUE PORRO QUISQUAM EST QUI DOLOREM IPSUM QUIA DOLOR SIT AMET, CONSECTETUR, ADIPISCI VELIT', 'EXTRA', '1.77', '42x42', 377.00, NULL, NULL, NULL, 266.00, 1, NULL, 1, '2026-09-16', NULL, '2026-10-17 14:18:15');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto_sucursals`
--

CREATE TABLE `producto_sucursals` (
  `id` bigint UNSIGNED NOT NULL,
  `sucursal_id` bigint UNSIGNED NOT NULL,
  `almacen_id` bigint UNSIGNED NOT NULL,
  `producto_id` bigint UNSIGNED NOT NULL,
  `stock_actual` double NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `producto_sucursals`
--

INSERT INTO `producto_sucursals` (`id`, `sucursal_id`, `almacen_id`, `producto_id`, `stock_actual`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 2, 26, '2026-08-26 00:56:23', '2026-09-23 14:40:45'),
(2, 1, 1, 3, 27, '2026-08-26 00:56:23', '2026-09-23 14:41:24'),
(3, 1, 1, 4, 13, '2026-08-26 00:56:23', '2026-09-15 14:25:34'),
(5, 2, 2, 2, 5, '2026-09-04 15:07:52', '2026-09-16 14:17:07'),
(6, 1, 4, 2, 20, '2026-09-13 20:05:01', '2026-09-13 20:07:28'),
(7, 1, 4, 3, 20, '2026-09-13 20:05:01', '2026-09-13 20:07:28'),
(8, 1, 4, 6, 20, '2026-09-13 20:05:01', '2026-09-13 20:07:28'),
(9, 1, 1, 6, 8, '2026-09-13 20:07:59', '2026-09-16 21:25:13'),
(10, 1, 1, 5, 9, '2026-09-13 20:53:57', '2026-09-15 14:25:34'),
(18, 3, 3, 2, 0, '2026-09-15 14:25:34', '2026-09-16 21:25:32'),
(19, 3, 3, 3, 10, '2026-09-15 14:25:34', '2026-09-16 21:25:32'),
(20, 3, 3, 4, 1, '2026-09-15 14:25:34', '2026-09-16 14:31:17'),
(21, 3, 3, 5, 1, '2026-09-15 14:25:34', '2026-09-15 14:25:34'),
(22, 3, 3, 6, 1, '2026-09-15 14:25:34', '2026-09-15 14:25:34'),
(23, 1, 1, 7, 20, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(24, 1, 1, 8, 20, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(25, 1, 1, 9, 20, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(26, 1, 1, 10, 20, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(27, 1, 1, 11, 20, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(28, 1, 1, 12, 20, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(29, 1, 1, 13, 20, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(30, 1, 1, 14, 20, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(31, 1, 1, 15, 20, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(32, 1, 1, 16, 20, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(33, 1, 1, 17, 20, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(34, 1, 1, 18, 20, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(35, 1, 1, 19, 20, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(36, 1, 1, 20, 20, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(37, 1, 1, 21, 20, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(38, 1, 1, 22, 20, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(39, 1, 1, 23, 20, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(40, 1, 1, 24, 20, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(41, 1, 1, 25, 20, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(42, 1, 1, 26, 20, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(43, 1, 1, 27, 20, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(44, 1, 1, 28, 20, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(45, 1, 1, 29, 20, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(46, 1, 1, 30, 20, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(47, 1, 1, 31, 20, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(48, 1, 1, 32, 20, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(49, 1, 1, 33, 20, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(50, 1, 1, 34, 20, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(51, 1, 1, 35, 20, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(52, 1, 1, 36, 20, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(53, 1, 1, 37, 20, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(54, 1, 1, 38, 20, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(55, 1, 1, 39, 20, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(56, 1, 1, 40, 20, '2026-09-16 19:10:03', '2026-09-16 19:10:03'),
(57, 1, 1, 41, 20, '2026-09-16 19:10:03', '2026-09-16 19:10:03');

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

--
-- Volcado de datos para la tabla `proformas`
--

INSERT INTO `proformas` (`id`, `codigo_proforma`, `sucursal_id`, `almacen_id`, `cliente_id`, `tipo_documento_id`, `nit_ci`, `subtotal`, `descuento`, `porcentaje_descuento`, `total`, `cancelado`, `saldo`, `fecha`, `hora`, `fecha_registro`, `status`, `user_id`, `created_at`, `updated_at`) VALUES
(2, 'P2', 3, 3, 9, 1, '32323', 2650.00, 0.00, 0, 2650.00, 2100.00, 550.00, '2026-09-09', '16:28:35', '2026-09-09', 1, 1, '2026-09-09 20:28:35', '2026-09-09 21:06:05'),
(3, 'P3', 1, 1, 13, 1, '56565656', 1140.00, 10.00, 0.88, 1130.00, 1130.00, 0.00, '2026-09-15', '10:45:17', '2026-09-15', 1, 1, '2026-09-15 14:45:17', '2026-09-15 14:45:17'),
(4, 'P4', 1, 1, 8, 2, '43344343', 2300.00, 0.00, 0, 2300.00, 2300.00, 0.00, '2026-09-16', '10:29:09', '2026-09-16', 1, 1, '2026-09-16 14:29:09', '2026-09-16 14:29:09'),
(5, 'P5', 1, 1, 4, 1, '3433333', 3100.00, 0.00, 0, 3100.00, 2300.00, 800.00, '2026-09-16', '14:46:11', '2026-09-16', 1, 1, '2026-09-16 18:46:11', '2026-09-16 18:46:34');

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

--
-- Volcado de datos para la tabla `proforma_detalles`
--

INSERT INTO `proforma_detalles` (`id`, `proforma_id`, `producto_id`, `cantidad`, `precio`, `descuento_uni`, `porcen_du`, `descuento_total`, `porcen_dt`, `precio_final`, `total`, `total_uni`, `created_at`, `updated_at`) VALUES
(4, 2, 3, 7, 350.00, 0.00, 0, 0.00, 0, 350.00, 2450.00, 2450.00, '2026-09-09 20:28:35', '2026-09-09 21:05:53'),
(5, 2, 2, 1, 200.00, 0.00, 0, 0.00, 0, 200.00, 200.00, 200.00, '2026-09-09 21:05:53', '2026-09-09 21:05:53'),
(7, 3, 2, 2, 200.00, 0.00, 0, 1.76, 0.88, 198.24, 396.48, 400.00, '2026-09-15 14:45:17', '2026-09-15 14:45:17'),
(8, 3, 3, 1, 350.00, 0.00, 0, 3.08, 0.88, 346.92, 346.92, 350.00, '2026-09-15 14:45:17', '2026-09-15 14:45:17'),
(9, 3, 4, 1, 390.00, 0.00, 0, 3.43, 0.88, 386.57, 386.57, 390.00, '2026-09-15 14:45:17', '2026-09-15 14:45:17'),
(10, 4, 3, 3, 300.00, 0.00, 0, 0.00, 0, 350.00, 900.00, 900.00, '2026-09-16 14:29:09', '2026-09-16 14:29:09'),
(11, 4, 2, 4, 200.00, 0.00, 0, 0.00, 0, 200.00, 800.00, 800.00, '2026-09-16 14:29:09', '2026-09-16 14:29:09'),
(12, 4, 5, 2, 300.00, 0.00, 0, 0.00, 0, 300.00, 600.00, 600.00, '2026-09-16 14:29:09', '2026-09-16 14:29:09'),
(13, 5, 2, 5, 200.00, 0.00, 0, 0.00, 0, 200.00, 1000.00, 1000.00, '2026-09-16 18:46:11', '2026-09-16 18:46:34'),
(14, 5, 3, 6, 350.00, 0.00, 0, 0.00, 0, 350.00, 2100.00, 2100.00, '2026-09-16 18:46:11', '2026-09-16 18:46:11');

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

--
-- Volcado de datos para la tabla `salida_detalles`
--

INSERT INTO `salida_detalles` (`id`, `salida_producto_id`, `tipo_salida_id`, `producto_id`, `cantidad`, `observacion`, `created_at`, `updated_at`) VALUES
(7, 6, 1, 2, 1, NULL, '2026-09-02 14:23:39', '2026-09-02 14:23:39'),
(8, 6, 2, 3, 1, NULL, '2026-09-02 14:23:39', '2026-09-02 14:23:39');

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

--
-- Volcado de datos para la tabla `salida_productos`
--

INSERT INTO `salida_productos` (`id`, `sucursal_id`, `almacen_id`, `tipo_salida_id`, `cantidad`, `descripcion`, `fecha_registro`, `user_id`, `created_at`, `updated_at`) VALUES
(6, 1, 1, NULL, 2.00, '', '2026-09-02', 1, '2026-09-02 14:23:39', '2026-09-02 14:23:39');

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
(1, 'POR COMPRAS', 'DESC INGRESO 1', '2026-07-13 19:57:24', '2026-10-15 14:10:35'),
(2, 'INGRESO 2', '', '2026-07-13 19:57:34', '2026-10-15 14:14:14'),
(3, 'INGRESO 3', 'DESC ING 3', '2026-07-13 20:00:47', '2026-07-13 20:01:31');

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

--
-- Volcado de datos para la tabla `traspasos`
--

INSERT INTO `traspasos` (`id`, `sucursal_origen_id`, `almacen_origen_id`, `sucursal_destino_id`, `almacen_destino_id`, `cantidad`, `descripcion`, `fecha_registro`, `user_id`, `created_at`, `updated_at`) VALUES
(3, 1, 1, 2, 2, 3, 'TRASPASO DE ALMACEN CENTRAL A ALMACEN 1', '2026-09-04', 1, '2026-09-04 15:07:52', '2026-09-04 15:07:52'),
(7, 1, 1, 3, 3, 5, 'TRASPASO A ALMACEN 2', '2026-09-15', 1, '2026-09-15 14:25:34', '2026-09-15 14:25:34'),
(8, 1, 1, 2, 2, 2, 'TRASPASO A ALMACEN 1', '2026-09-16', 1, '2026-09-16 14:17:07', '2026-09-16 14:17:07'),
(9, 1, 1, 3, 3, 10, 'TRASPASO 10 PRODUCTOS A ALMACEN 2', '2026-09-16', 1, '2026-09-16 19:49:39', '2026-09-16 19:49:39');

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

--
-- Volcado de datos para la tabla `traspaso_detalles`
--

INSERT INTO `traspaso_detalles` (`id`, `traspaso_id`, `producto_id`, `cantidad`, `observacion`, `created_at`, `updated_at`) VALUES
(2, 3, 2, 3, NULL, '2026-09-04 15:07:52', '2026-09-04 15:07:52'),
(13, 7, 2, 1, NULL, '2026-09-15 14:25:34', '2026-09-15 14:25:34'),
(14, 7, 3, 1, NULL, '2026-09-15 14:25:34', '2026-09-15 14:25:34'),
(15, 7, 4, 1, NULL, '2026-09-15 14:25:34', '2026-09-15 14:25:34'),
(16, 7, 5, 1, NULL, '2026-09-15 14:25:34', '2026-09-15 14:25:34'),
(17, 7, 6, 1, NULL, '2026-09-15 14:25:34', '2026-09-15 14:25:34'),
(18, 8, 2, 2, NULL, '2026-09-16 14:17:07', '2026-09-16 14:17:07'),
(19, 9, 3, 10, NULL, '2026-09-16 19:49:39', '2026-09-16 19:49:39');

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
(1, 'UNIDAD', '2026-07-11 19:53:50', '2026-07-11 19:53:50'),
(2, 'KILOS', '2026-07-11 19:54:00', '2026-07-11 19:54:00'),
(3, 'CAJAS', '2026-10-15 14:24:30', '2026-10-15 14:24:30');

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
(2, 'FMAMANI1', 'FERNANDO', 'MAMANI', 'MAMANI', '123456', 'LP', 'LOS PEDREGALES', 'fernando@gmail.com', '78787878', '$2y$12$FlgY4NRltp7YvoMwbd6V..zeg/e/dASkPw.I9WbSJt/Zco1OxE1Gm', '21783785963.jpg', 'ADMINISTRACIÓN', 2, 1, NULL, 1, '2026-07-11', 1, '2026-07-11 16:06:03', '2026-07-11 16:08:52');

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
(8, 'V8', 1, 1, 1, 1, '123456-CM', 'AL CONTADO', 'EFECTIVO', 400.00, 0.00, 0.00, 400.00, 400.00, 0.00, 400.00, 0.00, '2026-09-06', '18:24:22', '2026-09-06', 1, 1, '2026-09-06 22:24:22', '2026-09-06 22:24:22'),
(9, 'V9', 1, 1, 1, 1, '123456-CM', 'AL CONTADO', 'EFECTIVO', 350.00, 0.00, 0.00, 350.00, 350.00, 0.00, 350.00, 0.00, '2026-09-07', '10:32:13', '2026-09-07', 1, 1, '2026-09-07 14:32:13', '2026-09-07 14:32:13'),
(10, 'V10', 1, 1, 3, 2, '345345345', 'CRÉDITO', NULL, 1050.00, 0.00, 0.00, 1050.00, 0.00, 0.00, 0.00, 500.00, '2026-09-07', '10:35:45', '2026-09-07', 1, 1, '2026-09-07 14:35:45', '2026-09-15 15:23:49'),
(11, 'V11', 1, 1, 2, 1, '123456', 'CRÉDITO', NULL, 700.00, 20.00, 2.86, 680.00, 0.00, 0.00, 0.00, 680.00, '2026-09-08', '10:55:31', '2026-09-08', 1, 1, '2026-09-08 14:55:31', '2026-09-08 14:55:31'),
(12, 'V12', 1, 1, 3, 2, '345345345', 'CRÉDITO', 'QR', 780.00, 30.00, 3.85, 750.00, 0.00, 100.00, 100.00, 650.00, '2026-09-08', '11:01:10', '2026-09-08', 1, 1, '2026-09-08 15:01:10', '2026-09-08 15:01:10'),
(14, 'V14', 3, 3, 5, 1, '43343434', 'AL CONTADO', 'EFECTIVO-QR', 550.00, 0.00, 0.00, 550.00, 500.00, 50.00, 550.00, 0.00, '2026-09-15', '10:41:26', '2026-09-15', 1, 1, '2026-09-15 14:41:26', '2026-09-16 21:25:32'),
(15, 'V15', 1, 1, 2, 1, '123456', 'CRÉDITO', 'EFECTIVO', 290.00, 0.00, 0.00, 290.00, 50.00, 0.00, 50.00, 0.00, '2026-09-16', '10:33:00', '2026-09-16', 1, 1, '2026-09-16 14:33:00', '2026-09-16 21:39:52'),
(16, 'V16', 1, 1, 1, 1, '123456-CM', 'CRÉDITO', NULL, 950.00, 0.00, 0.00, 950.00, 0.00, 0.00, 0.00, 930.00, '2026-09-16', '14:45:46', '2026-09-16', 1, 1, '2026-09-16 18:45:46', '2026-09-16 21:46:42'),
(17, 'V17', 1, 1, 6, 1, '32233', 'CRÉDITO', 'QR', 750.00, 0.00, 0.00, 750.00, 0.00, 250.00, 250.00, 500.00, '2026-09-16', '17:22:14', '2026-09-16', 1, 1, '2026-09-16 21:22:14', '2026-09-16 21:25:13'),
(18, 'V18', 1, 1, 13, 1, '56565656', 'AL CONTADO', 'EFECTIVO', 615.00, 15.00, 2.44, 600.00, 600.00, 0.00, 600.00, 0.00, '2026-09-23', '10:35:36', '2026-09-23', 1, 1, '2026-09-23 14:35:36', '2026-09-23 14:35:36'),
(23, 'V23', 1, 1, 3, 2, '345345345', 'CRÉDITO', '', 200.00, 0.00, 0.00, 200.00, 0.00, 0.00, 0.00, 200.00, '2026-09-23', '10:39:37', '2026-09-23', 1, 1, '2026-09-23 14:39:37', '2026-09-23 14:39:37'),
(24, 'V24', 1, 1, 2, 1, '123456', 'CRÉDITO', '', 200.00, 0.00, 0.00, 200.00, 0.00, 0.00, 0.00, 200.00, '2026-09-23', '10:40:45', '2026-09-23', 1, 1, '2026-09-23 14:40:45', '2026-09-23 14:40:45'),
(25, 'V25', 1, 1, 13, 1, '56565656', 'AL CONTADO', 'EFECTIVO-QR', 360.00, 0.00, 0.00, 360.00, 180.00, 180.00, 360.00, 0.00, '2026-09-23', '10:41:24', '2026-09-23', 1, 1, '2026-09-23 14:41:24', '2026-09-23 14:41:24');

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

--
-- Volcado de datos para la tabla `venta_cobros`
--

INSERT INTO `venta_cobros` (`id`, `sucursal_id`, `almacen_id`, `venta_id`, `cliente_id`, `tipo_pago`, `monto_efectivo`, `monto_qr`, `monto_total`, `saldo`, `fecha`, `hora`, `user_id`, `created_at`, `updated_at`) VALUES
(6, 1, 1, 10, 3, 'EFECTIVO', 500.00, 0.00, 500.00, 0.00, '2026-09-15', '11:22:58', 1, '2026-09-15 15:22:58', '2026-09-15 15:22:58'),
(7, 1, 1, 10, 3, 'QR', 0.00, 50.00, 50.00, 0.00, '2026-09-15', '11:23:49', 1, '2026-09-15 15:23:38', '2026-09-15 15:23:49'),
(8, 1, 1, 16, 1, 'EFECTIVO-QR', 10.00, 10.00, 20.00, 0.00, '2026-09-16', '17:46:42', 1, '2026-09-16 18:50:35', '2026-09-16 21:46:42'),
(9, 1, 1, 15, 2, 'EFECTIVO-QR', 20.00, 20.00, 40.00, 0.00, '2026-09-16', '17:38:34', 1, '2026-09-16 21:34:57', '2026-09-16 21:38:34'),
(10, 1, 1, 15, 2, 'EFECTIVO', 20.00, 0.00, 20.00, 0.00, '2026-09-16', '17:39:31', 1, '2026-09-16 21:38:50', '2026-09-16 21:39:31'),
(12, 1, 1, 15, 2, 'EFECTIVO', 180.00, 0.00, 180.00, 0.00, '2026-09-16', '17:39:52', 1, '2026-09-16 21:39:52', '2026-09-16 21:39:52');

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
(8, 8, 2, 2, 200.00, 0.00, 0.00, 0.00, 0.00, 200.00, 400.00, 400.00, 1, '2026-09-06 22:24:22', '2026-09-06 22:24:22'),
(9, 9, 3, 1, 350.00, 0.00, 0.00, 0.00, 0.00, 350.00, 350.00, 350.00, 1, '2026-09-07 14:32:13', '2026-09-07 14:32:13'),
(10, 10, 3, 3, 350.00, 0.00, 0.00, 0.00, 0.00, 350.00, 1050.00, 1050.00, 1, '2026-09-07 14:35:45', '2026-09-07 14:35:45'),
(11, 11, 3, 2, 350.00, 0.00, 0.00, 10.01, 2.86, 339.99, 679.98, 700.00, 1, '2026-09-08 14:55:31', '2026-09-08 14:55:31'),
(12, 12, 4, 2, 390.00, 0.00, 0.00, 15.02, 3.85, 374.99, 749.97, 780.00, 1, '2026-09-08 15:01:10', '2026-09-08 15:01:10'),
(15, 14, 2, 1, 200.00, 0.00, 0.00, 0.00, 0.00, 200.00, 200.00, 200.00, 0, '2026-09-15 14:41:26', '2026-09-16 14:31:17'),
(16, 14, 4, 1, 390.00, 0.00, 0.00, 0.00, 0.00, 390.00, 390.00, 390.00, 0, '2026-09-15 14:41:26', '2026-09-16 14:31:17'),
(17, 15, 2, 1, 290.00, 0.00, 0.00, 0.00, 0.00, 290.00, 290.00, 290.00, 1, '2026-09-16 14:33:00', '2026-09-16 14:33:00'),
(18, 16, 2, 3, 200.00, 0.00, 0.00, 0.00, 0.00, 200.00, 600.00, 600.00, 1, '2026-09-16 18:45:46', '2026-09-16 18:50:00'),
(19, 16, 3, 1, 350.00, 0.00, 0.00, 0.00, 0.00, 350.00, 350.00, 350.00, 1, '2026-09-16 18:45:46', '2026-09-16 18:45:46'),
(22, 14, 2, 1, 200.00, 0.00, 0.00, 0.00, 0.00, 200.00, 200.00, 200.00, 1, '2026-09-16 19:05:17', '2026-09-16 19:05:17'),
(23, 14, 3, 1, 350.00, 0.00, 0.00, 0.00, 0.00, 350.00, 350.00, 350.00, 1, '2026-09-16 19:05:17', '2026-09-16 19:05:17'),
(24, 17, 2, 1, 200.00, 0.00, 0.00, 0.00, 0.00, 200.00, 200.00, 200.00, 1, '2026-09-16 21:22:14', '2026-09-16 21:22:14'),
(25, 17, 3, 1, 350.00, 0.00, 0.00, 0.00, 0.00, 350.00, 350.00, 350.00, 1, '2026-09-16 21:22:14', '2026-09-16 21:22:14'),
(26, 17, 6, 1, 200.00, 0.00, 0.00, 0.00, 0.00, 200.00, 200.00, 200.00, 1, '2026-09-16 21:24:58', '2026-09-16 21:24:58'),
(27, 18, 2, 1, 255.00, 0.00, 0.00, 6.22, 2.44, 248.78, 248.78, 255.00, 1, '2026-09-23 14:35:36', '2026-09-23 14:35:36'),
(28, 18, 3, 1, 360.00, 0.00, 0.00, 8.78, 2.44, 351.22, 351.22, 360.00, 1, '2026-09-23 14:35:36', '2026-09-23 14:35:36'),
(29, 23, 2, 1, 200.00, 0.00, 0.00, 0.00, 0.00, 200.00, 200.00, 200.00, 1, '2026-09-23 14:39:37', '2026-09-23 14:39:37'),
(30, 24, 2, 1, 200.00, 0.00, 0.00, 0.00, 0.00, 200.00, 200.00, 200.00, 1, '2026-09-23 14:40:45', '2026-09-23 14:40:45'),
(31, 25, 3, 1, 360.00, 0.00, 0.00, 0.00, 0.00, 360.00, 360.00, 360.00, 1, '2026-09-23 14:41:24', '2026-09-23 14:41:24');

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
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=215;

--
-- AUTO_INCREMENT de la tabla `ingreso_detalles`
--
ALTER TABLE `ingreso_detalles`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT de la tabla `ingreso_faltantes`
--
ALTER TABLE `ingreso_faltantes`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `ingreso_pagos`
--
ALTER TABLE `ingreso_pagos`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de la tabla `ingreso_productos`
--
ALTER TABLE `ingreso_productos`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT de la tabla `ingreso_recepcions`
--
ALTER TABLE `ingreso_recepcions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `kardex_productos`
--
ALTER TABLE `kardex_productos`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=165;

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
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `movimiento_cajas`
--
ALTER TABLE `movimiento_cajas`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

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
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT de la tabla `producto_sucursals`
--
ALTER TABLE `producto_sucursals`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=58;

--
-- AUTO_INCREMENT de la tabla `proformas`
--
ALTER TABLE `proformas`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `proforma_detalles`
--
ALTER TABLE `proforma_detalles`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

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
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `salida_productos`
--
ALTER TABLE `salida_productos`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

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
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `tipo_salidas`
--
ALTER TABLE `tipo_salidas`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `traspasos`
--
ALTER TABLE `traspasos`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `traspaso_detalles`
--
ALTER TABLE `traspaso_detalles`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT de la tabla `unidad_medidas`
--
ALTER TABLE `unidad_medidas`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `ventas`
--
ALTER TABLE `ventas`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT de la tabla `venta_cobros`
--
ALTER TABLE `venta_cobros`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `venta_detalles`
--
ALTER TABLE `venta_detalles`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

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
