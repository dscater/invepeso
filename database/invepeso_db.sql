-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 08-09-2026 a las 15:01:54
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
  `nombre` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(900) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
(2, 'CATEGORIA 2', '2026-07-11 19:59:39', '2026-07-11 19:59:39');

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
(4, 'MARCOS', 1, '3433333', NULL, NULL, NULL, '2026-07-11', 1, '2026-07-11 16:48:20', '2026-07-11 16:48:20');

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
(29, 1, 'CREACIÓN', 'EL USUARIO admin REGISTRO UNA VENTA', '{\"id\": 12, \"hora\": \"11:01:10\", \"fecha\": \"2026-09-08\", \"saldo\": \"650.00\", \"total\": \"750.00\", \"nit_ci\": \"345345345\", \"user_id\": 1, \"subtotal\": \"780.00\", \"cancelado\": \"100\", \"descuento\": \"30\", \"tipo_pago\": \"QR\", \"almacen_id\": 1, \"cliente_id\": 3, \"created_at\": \"2026-09-08T15:01:10.000000Z\", \"tipo_venta\": \"CRÉDITO\", \"updated_at\": \"2026-09-08T15:01:10.000000Z\", \"sucursal_id\": 1, \"codigo_venta\": \"V12\", \"fecha_registro\": \"2026-09-08\", \"venta_detalles\": [{\"id\": 12, \"total\": \"749.97\", \"precio\": \"390.00\", \"cantidad\": 2, \"venta_id\": 12, \"porcen_dt\": 3.85, \"porcen_du\": 0, \"total_uni\": \"780.00\", \"created_at\": \"2026-09-08T15:01:10.000000Z\", \"updated_at\": \"2026-09-08T15:01:10.000000Z\", \"producto_id\": 4, \"precio_final\": \"374.99\", \"descuento_uni\": \"0.00\", \"descuento_total\": \"15.02\"}], \"tipo_documento_id\": 2, \"porcentaje_descuento\": \"3.85\"}', NULL, 'VENTAS', '2026-09-08', '11:01:11', '2026-09-08 15:01:11', '2026-09-08 15:01:11');

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
(6, 6, 2, 4, 10, 7.00, 3, 3.00, NULL, 10.00, 300.00, 3000.00, '2026-08-30 16:01:02', '2026-08-30 16:02:46'),
(7, 7, 1, 3, 4, 2.00, 2, 2.00, NULL, 5.00, 300.00, 1200.00, '2026-08-30 16:05:07', '2026-08-30 16:12:35'),
(8, 8, 1, 2, 4, 2.00, 2, 2.00, NULL, 4.00, 120.00, 480.00, '2026-08-30 16:13:09', '2026-08-30 16:16:35');

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
  `monto` decimal(24,2) NOT NULL,
  `fecha` date NOT NULL,
  `hora` time NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `ingreso_pagos`
--

INSERT INTO `ingreso_pagos` (`id`, `sucursal_id`, `almacen_id`, `ingreso_producto_id`, `proveedor_id`, `monto`, `fecha`, `hora`, `user_id`, `created_at`, `updated_at`) VALUES
(3, 1, 1, 3, 1, 500.00, '2026-09-07', '12:30:17', 1, '2026-09-07 16:30:17', '2026-09-07 16:30:17');

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
  `cancelado` decimal(24,2) NOT NULL,
  `saldo` decimal(24,2) NOT NULL,
  `tipo_compra` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
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

INSERT INTO `ingreso_productos` (`id`, `codigo`, `sucursal_id`, `almacen_id`, `tipo_ingreso_id`, `proveedor_id`, `descripcion`, `total`, `cancelado`, `saldo`, `tipo_compra`, `fecha_registro`, `user_id`, `estado_ingreso`, `estado_faltantes`, `status`, `created_at`, `updated_at`) VALUES
(3, 'L-00003', 1, 1, 1, 1, '', 1080.00, 0.00, 580.00, 'CRÉDITO', '2026-08-24', 1, 'VERIFICADO', NULL, 1, '2026-08-25 01:33:33', '2026-09-07 16:30:17'),
(4, 'L-00004', 1, 1, 1, 1, '', 300.00, 300.00, 0.00, 'CONTADO', '2026-08-24', 1, 'VERIFICADO', NULL, 1, '2026-08-25 01:35:28', '2026-08-30 15:28:12'),
(5, 'L-00005', 1, 1, 1, 1, 'DESC', 1500.00, 0.00, 1500.00, 'CRÉDITO', '2026-08-29', 1, 'VERIFICADO', 'PENDIENTE', 1, '2026-08-29 15:44:23', '2026-08-30 15:26:54'),
(6, 'L-00006', 1, 1, 2, 2, '', 3000.00, 0.00, 3000.00, 'CRÉDITO', '2026-08-30', 1, 'VERIFICADO', 'COMPLETO', 1, '2026-08-30 16:01:02', '2026-08-30 16:02:46'),
(7, 'L-00007', 1, 1, 1, 1, '', 1200.00, 0.00, 1200.00, 'CRÉDITO', '2026-08-30', 1, 'VERIFICADO', 'COMPLETO', 1, '2026-08-30 16:05:07', '2026-08-30 16:12:35'),
(8, 'L-00008', 1, 1, 1, 1, '', 480.00, 0.00, 480.00, 'CRÉDITO', '2026-08-30', 1, 'VERIFICADO', 'COMPLETO', 1, '2026-08-30 16:13:09', '2026-08-30 16:16:35');

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
(28, 1, 1, NULL, 'VENTA DE PRODUCTO', 12, 'VentaDetalle', 4, 'SALIDA POR VENTA', 374.99, 'EGRESO', NULL, 2, 14, 374.99, NULL, 749.97, 4050.03, '2026-09-08', 1, '2026-09-08 15:01:11', '2026-09-08 15:01:11');

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
(2, 'MARCA 2', '2026-07-11 19:59:34', '2026-07-11 19:59:34');

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
(32, '2026_09_07_112006_create_ingreso_pagos_table', 8);

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
  `tipo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `modulo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `registro_id` bigint UNSIGNED DEFAULT NULL,
  `monto` decimal(24,2) NOT NULL,
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

INSERT INTO `movimiento_cajas` (`id`, `sucursal_id`, `almacen_id`, `tipo`, `modulo`, `registro_id`, `monto`, `tipo_movimiento`, `tipo_pago`, `descripcion`, `fecha`, `hora`, `user_id`, `status`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 'COMPRA DE PRODUCTOS', 'IngresoProducto', 4, 300.00, 'EGRESO', 'EFECTIVO', 'COMPRA DE PRODUCTOS', '2026-08-24', '21:35:28', 1, 1, '2026-08-25 01:35:28', '2026-08-25 01:35:28'),
(2, 1, 1, 'MOVIMIENTO DE CAJA', 'MovimientoCaja', 2, 2000.00, 'INGRESO', 'EFECTIVO', 'ingreso de efectivo', '2026-09-03', '11:16:34', 1, 1, '2026-09-03 15:18:33', '2026-09-03 15:31:35'),
(3, 1, 1, 'VENTA', 'Venta', 9, 350.00, 'INGRESO', 'EFECTIVO', 'INGRESO POR VENTA', '2026-09-07', '10:32:13', 1, 1, '2026-09-07 14:32:14', '2026-09-07 14:32:14'),
(4, 1, 1, 'PAGO POR COMPRA DE PRODUCTOS', 'IngresoPago', 3, 500.00, 'EGRESO', 'EFECTIVO', 'PAGO POR COMPRA DE PRODUCTOS', '2026-09-07', '12:30:17', 1, 1, '2026-09-07 16:30:17', '2026-09-07 16:30:17'),
(5, 1, 1, 'VENTA', 'Venta', 12, 100.00, 'INGRESO', 'QR', 'INGRESO POR VENTA', '2026-09-08', '11:01:10', 1, 1, '2026-09-08 15:01:11', '2026-09-08 15:01:11');

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

INSERT INTO `productos` (`id`, `codigo`, `nombre`, `categoria_id`, `marca_id`, `unidad_medida_id`, `precio`, `precio2`, `precio3`, `precio4`, `precio_compra`, `stock_min`, `imagen`, `activo`, `fecha_registro`, `created_at`, `updated_at`) VALUES
(2, 'P001', 'PRODUCTO 1', 1, 1, 1, 200.00, 290.00, 300.00, NULL, 120.00, 3, '21783799752.jpeg', 1, '2026-07-11', '2026-07-11 19:55:52', '2026-09-06 21:17:59'),
(3, 'P002', 'PRODUCTO 2', 1, 1, 1, 350.00, 400.00, 420.00, 450.00, 300.00, 3, NULL, 1, '2026-07-11', '2026-07-11 20:00:05', '2026-09-06 21:18:15'),
(4, 'P003', 'PRODUCTO 3', 2, 2, 1, 390.00, NULL, NULL, NULL, 300.00, 5, NULL, 1, '2026-07-13', '2026-07-13 20:15:16', '2026-07-15 20:02:46');

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
(1, 1, 1, 2, 2, '2026-08-26 00:56:23', '2026-09-06 22:24:22'),
(2, 1, 1, 3, 5, '2026-08-26 00:56:23', '2026-09-08 14:55:31'),
(3, 1, 1, 4, 14, '2026-08-26 00:56:23', '2026-09-08 15:01:11'),
(5, 2, 2, 2, 3, '2026-09-04 15:07:52', '2026-09-04 15:07:52');

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
(2, 'PROVEEDOR 2', NULL, '2026-07-13 19:47:02', '2026-07-13 19:47:02');

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
  `observacion` varchar(900) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
(3, 'SUCURSAL 2', '', 0, 1, '2026-07-11', '2026-07-11 15:33:42', '2026-08-28 15:40:51');

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
(1, 'INGRESO 1', 'DESC INGRESO 1', '2026-07-13 19:57:24', '2026-07-13 19:57:24'),
(2, 'INGRESO 2', '', '2026-07-13 19:57:34', '2026-07-13 19:57:34'),
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
  `descripcion` varchar(900) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_registro` date NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `traspasos`
--

INSERT INTO `traspasos` (`id`, `sucursal_origen_id`, `almacen_origen_id`, `sucursal_destino_id`, `almacen_destino_id`, `cantidad`, `descripcion`, `fecha_registro`, `user_id`, `created_at`, `updated_at`) VALUES
(3, 1, 1, 2, 2, 3, 'TRASPASO DE ALMACEN CENTRAL A ALMACEN 1', '2026-09-04', 1, '2026-09-04 15:07:52', '2026-09-04 15:07:52');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `traspaso_detalles`
--

CREATE TABLE `traspaso_detalles` (
  `id` bigint UNSIGNED NOT NULL,
  `traspaso_id` bigint UNSIGNED NOT NULL,
  `producto_id` bigint UNSIGNED NOT NULL,
  `cantidad` double NOT NULL,
  `observacion` varchar(900) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `traspaso_detalles`
--

INSERT INTO `traspaso_detalles` (`id`, `traspaso_id`, `producto_id`, `cantidad`, `observacion`, `created_at`, `updated_at`) VALUES
(2, 3, 2, 3, NULL, '2026-09-04 15:07:52', '2026-09-04 15:07:52');

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
(2, 'KILOS', '2026-07-11 19:54:00', '2026-07-11 19:54:00');

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
  `tipo_venta` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo_pago` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `subtotal` decimal(24,2) NOT NULL,
  `descuento` decimal(24,2) NOT NULL,
  `porcentaje_descuento` double(8,2) NOT NULL,
  `total` decimal(24,2) NOT NULL,
  `cancelado` decimal(24,2) NOT NULL,
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

INSERT INTO `ventas` (`id`, `codigo_venta`, `sucursal_id`, `almacen_id`, `cliente_id`, `tipo_documento_id`, `nit_ci`, `tipo_venta`, `tipo_pago`, `subtotal`, `descuento`, `porcentaje_descuento`, `total`, `cancelado`, `saldo`, `fecha`, `hora`, `fecha_registro`, `status`, `user_id`, `created_at`, `updated_at`) VALUES
(8, 'V8', 1, 1, 1, 1, '123456-CM', 'AL CONTADO', 'EFECTIVO', 400.00, 0.00, 0.00, 400.00, 400.00, 0.00, '2026-09-06', '18:24:22', '2026-09-06', 1, 1, '2026-09-06 22:24:22', '2026-09-06 22:24:22'),
(9, 'V9', 1, 1, 1, 1, '123456-CM', 'AL CONTADO', 'EFECTIVO', 350.00, 0.00, 0.00, 350.00, 350.00, 0.00, '2026-09-07', '10:32:13', '2026-09-07', 1, 1, '2026-09-07 14:32:13', '2026-09-07 14:32:13'),
(10, 'V10', 1, 1, 3, 2, '345345345', 'CRÉDITO', NULL, 1050.00, 0.00, 0.00, 1050.00, 0.00, 1050.00, '2026-09-07', '10:35:45', '2026-09-07', 1, 1, '2026-09-07 14:35:45', '2026-09-07 14:35:45'),
(11, NULL, 1, 1, 2, 1, '123456', 'CRÉDITO', NULL, 700.00, 20.00, 2.86, 680.00, 0.00, 680.00, '2026-09-08', '10:55:31', '2026-09-08', 1, 1, '2026-09-08 14:55:31', '2026-09-08 14:55:31'),
(12, NULL, 1, 1, 3, 2, '345345345', 'CRÉDITO', 'QR', 780.00, 30.00, 3.85, 750.00, 100.00, 650.00, '2026-09-08', '11:01:10', '2026-09-08', 1, 1, '2026-09-08 15:01:10', '2026-09-08 15:01:10');

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
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `venta_detalles`
--

INSERT INTO `venta_detalles` (`id`, `venta_id`, `producto_id`, `cantidad`, `precio`, `descuento_uni`, `porcen_du`, `descuento_total`, `porcen_dt`, `precio_final`, `total`, `total_uni`, `created_at`, `updated_at`) VALUES
(8, 8, 2, 2, 200.00, 0.00, 0.00, 0.00, 0.00, 200.00, 400.00, 400.00, '2026-09-06 22:24:22', '2026-09-06 22:24:22'),
(9, 9, 3, 1, 350.00, 0.00, 0.00, 0.00, 0.00, 350.00, 350.00, 350.00, '2026-09-07 14:32:13', '2026-09-07 14:32:13'),
(10, 10, 3, 3, 350.00, 0.00, 0.00, 0.00, 0.00, 350.00, 1050.00, 1050.00, '2026-09-07 14:35:45', '2026-09-07 14:35:45'),
(11, 11, 3, 2, 350.00, 0.00, 0.00, 10.01, 2.86, 339.99, 679.98, 700.00, '2026-09-08 14:55:31', '2026-09-08 14:55:31'),
(12, 12, 4, 2, 390.00, 0.00, 0.00, 15.02, 3.85, 374.99, 749.97, 780.00, '2026-09-08 15:01:10', '2026-09-08 15:01:10');

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
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `configuracions`
--
ALTER TABLE `configuracions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `historial_accions`
--
ALTER TABLE `historial_accions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT de la tabla `ingreso_detalles`
--
ALTER TABLE `ingreso_detalles`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `ingreso_pagos`
--
ALTER TABLE `ingreso_pagos`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `ingreso_productos`
--
ALTER TABLE `ingreso_productos`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `kardex_productos`
--
ALTER TABLE `kardex_productos`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT de la tabla `marcas`
--
ALTER TABLE `marcas`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT de la tabla `modulos`
--
ALTER TABLE `modulos`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `movimiento_cajas`
--
ALTER TABLE `movimiento_cajas`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `permisos`
--
ALTER TABLE `permisos`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `producto_sucursals`
--
ALTER TABLE `producto_sucursals`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `proveedors`
--
ALTER TABLE `proveedors`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

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
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `traspaso_detalles`
--
ALTER TABLE `traspaso_detalles`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `unidad_medidas`
--
ALTER TABLE `unidad_medidas`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `ventas`
--
ALTER TABLE `ventas`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `venta_detalles`
--
ALTER TABLE `venta_detalles`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `almacens`
--
ALTER TABLE `almacens`
  ADD CONSTRAINT `almacens_sucursal_id_foreign` FOREIGN KEY (`sucursal_id`) REFERENCES `sucursals` (`id`);

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
-- Filtros para la tabla `venta_detalles`
--
ALTER TABLE `venta_detalles`
  ADD CONSTRAINT `venta_detalles_producto_id_foreign` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`),
  ADD CONSTRAINT `venta_detalles_venta_id_foreign` FOREIGN KEY (`venta_id`) REFERENCES `ventas` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
