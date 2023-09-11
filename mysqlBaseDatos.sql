-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versión del servidor:         8.0.30 - MySQL Community Server - GPL
-- SO del servidor:              Win64
-- HeidiSQL Versión:             12.1.0.6537
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Volcando estructura de base de datos para db_tienda
CREATE DATABASE IF NOT EXISTS `db_tienda` /*!40100 DEFAULT CHARACTER SET utf8mb3 COLLATE utf8mb3_spanish_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `db_tienda`;

-- Volcando estructura para tabla db_tienda.appexoticshoes_cart
CREATE TABLE IF NOT EXISTS `appexoticshoes_cart` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla db_tienda.appexoticshoes_cart: ~0 rows (aproximadamente)

-- Volcando estructura para tabla db_tienda.appexoticshoes_cartitem
CREATE TABLE IF NOT EXISTS `appexoticshoes_cartitem` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `quantity` int unsigned NOT NULL,
  `cart_id` bigint NOT NULL,
  `product_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `appExoticShoes_carti_cart_id_0f4f7278_fk_appExotic` (`cart_id`),
  KEY `appExoticShoes_carti_product_id_e214d863_fk_appExotic` (`product_id`),
  CONSTRAINT `appExoticShoes_carti_cart_id_0f4f7278_fk_appExotic` FOREIGN KEY (`cart_id`) REFERENCES `appexoticshoes_cart` (`id`),
  CONSTRAINT `appExoticShoes_carti_product_id_e214d863_fk_appExotic` FOREIGN KEY (`product_id`) REFERENCES `appexoticshoes_producto` (`id`),
  CONSTRAINT `appexoticshoes_cartitem_chk_1` CHECK ((`quantity` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla db_tienda.appexoticshoes_cartitem: ~0 rows (aproximadamente)

-- Volcando estructura para tabla db_tienda.appexoticshoes_categoria
CREATE TABLE IF NOT EXISTS `appexoticshoes_categoria` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) COLLATE utf8mb3_spanish_ci NOT NULL,
  `imagen` varchar(100) COLLATE utf8mb3_spanish_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla db_tienda.appexoticshoes_categoria: ~1 rows (aproximadamente)
REPLACE INTO `appexoticshoes_categoria` (`id`, `nombre`, `imagen`) VALUES
	(1, 'Ropa', 'categorias/ropa.jpg'),
	(2, 'Herramientas', 'categorias/herramientas_Z4ZKgdN.jpg');

-- Volcando estructura para tabla db_tienda.appexoticshoes_detallepedido
CREATE TABLE IF NOT EXISTS `appexoticshoes_detallepedido` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `cantidad` int NOT NULL,
  `subtotal` double NOT NULL,
  `pedido_id` bigint NOT NULL,
  `producto_id` bigint NOT NULL,
  `talla_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `appExoticShoes_detal_pedido_id_8c7306f0_fk_appExotic` (`pedido_id`),
  KEY `appExoticShoes_detal_producto_id_29dfa03e_fk_appExotic` (`producto_id`),
  KEY `FK_appexoticshoes_detallepedido_appexoticshoes_talla` (`talla_id`),
  CONSTRAINT `appExoticShoes_detal_pedido_id_8c7306f0_fk_appExotic` FOREIGN KEY (`pedido_id`) REFERENCES `appexoticshoes_pedido` (`id`),
  CONSTRAINT `appExoticShoes_detal_producto_id_29dfa03e_fk_appExotic` FOREIGN KEY (`producto_id`) REFERENCES `appexoticshoes_producto` (`id`),
  CONSTRAINT `FK_appexoticshoes_detallepedido_appexoticshoes_talla` FOREIGN KEY (`talla_id`) REFERENCES `appexoticshoes_talla` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla db_tienda.appexoticshoes_detallepedido: ~0 rows (aproximadamente)
REPLACE INTO `appexoticshoes_detallepedido` (`id`, `cantidad`, `subtotal`, `pedido_id`, `producto_id`, `talla_id`) VALUES
	(1, 3, 83.4, 1, 1, 2);

-- Volcando estructura para tabla db_tienda.appexoticshoes_devolucione
CREATE TABLE IF NOT EXISTS `appexoticshoes_devolucione` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `motivo` varchar(255) COLLATE utf8mb3_spanish_ci NOT NULL,
  `detalles` longtext COLLATE utf8mb3_spanish_ci,
  `fechaDevolucion` datetime(6) NOT NULL,
  `pedido_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `appExoticShoes_devol_pedido_id_bb4f1ffb_fk_appExotic` (`pedido_id`),
  CONSTRAINT `appExoticShoes_devol_pedido_id_bb4f1ffb_fk_appExotic` FOREIGN KEY (`pedido_id`) REFERENCES `appexoticshoes_pedido` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla db_tienda.appexoticshoes_devolucione: ~0 rows (aproximadamente)

-- Volcando estructura para tabla db_tienda.appexoticshoes_envio
CREATE TABLE IF NOT EXISTS `appexoticshoes_envio` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `servicioEnvio` varchar(30) COLLATE utf8mb3_spanish_ci NOT NULL,
  `DireccionEnvio` varchar(45) COLLATE utf8mb3_spanish_ci NOT NULL,
  `fechaEnvio` datetime(6) NOT NULL,
  `estado` varchar(45) COLLATE utf8mb3_spanish_ci NOT NULL,
  `estadoPago_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `appExoticShoes_envio_estadoPago_id_b142f800_fk_appExotic` (`estadoPago_id`),
  CONSTRAINT `appExoticShoes_envio_estadoPago_id_b142f800_fk_appExotic` FOREIGN KEY (`estadoPago_id`) REFERENCES `appexoticshoes_pago` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla db_tienda.appexoticshoes_envio: ~0 rows (aproximadamente)
REPLACE INTO `appexoticshoes_envio` (`id`, `servicioEnvio`, `DireccionEnvio`, `fechaEnvio`, `estado`, `estadoPago_id`) VALUES
	(1, 'Interrapidisimo', 'Carrera 9a', '2023-09-10 19:12:13.000000', 'pendiente', 1);

-- Volcando estructura para tabla db_tienda.appexoticshoes_pago
CREATE TABLE IF NOT EXISTS `appexoticshoes_pago` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `metodo` varchar(45) COLLATE utf8mb3_spanish_ci NOT NULL,
  `fechaPago` datetime(6) NOT NULL,
  `estadoPago` varchar(45) COLLATE utf8mb3_spanish_ci NOT NULL,
  `confirmado` tinyint(1) NOT NULL,
  `pedidos_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `appExoticShoes_pago_pedidos_id_18f1d6da_fk_appExotic` (`pedidos_id`),
  CONSTRAINT `appExoticShoes_pago_pedidos_id_18f1d6da_fk_appExotic` FOREIGN KEY (`pedidos_id`) REFERENCES `appexoticshoes_pedido` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla db_tienda.appexoticshoes_pago: ~0 rows (aproximadamente)
REPLACE INTO `appexoticshoes_pago` (`id`, `metodo`, `fechaPago`, `estadoPago`, `confirmado`, `pedidos_id`) VALUES
	(1, 'contraEntrega', '2023-09-10 19:11:44.000000', 'pendiente', 0, 1);

-- Volcando estructura para tabla db_tienda.appexoticshoes_pedido
CREATE TABLE IF NOT EXISTS `appexoticshoes_pedido` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `codigoPedido` varchar(45) COLLATE utf8mb3_spanish_ci NOT NULL,
  `fechaPedido` date NOT NULL,
  `total` double NOT NULL,
  `estadoPedido` varchar(50) COLLATE utf8mb3_spanish_ci NOT NULL,
  `usuario_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codigoPedido` (`codigoPedido`),
  KEY `appExoticShoes_pedid_usuario_id_22d781f1_fk_appExotic` (`usuario_id`),
  CONSTRAINT `appExoticShoes_pedid_usuario_id_22d781f1_fk_appExotic` FOREIGN KEY (`usuario_id`) REFERENCES `appexoticshoes_usuario` (`user_ptr_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla db_tienda.appexoticshoes_pedido: ~1 rows (aproximadamente)
REPLACE INTO `appexoticshoes_pedido` (`id`, `codigoPedido`, `fechaPedido`, `total`, `estadoPedido`, `usuario_id`) VALUES
	(1, 'COD001', '2023-09-10', 150000, 'pendiente', 2);

-- Volcando estructura para tabla db_tienda.appexoticshoes_producto
CREATE TABLE IF NOT EXISTS `appexoticshoes_producto` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) COLLATE utf8mb3_spanish_ci NOT NULL,
  `descripcion` longtext COLLATE utf8mb3_spanish_ci NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `imagen` varchar(100) COLLATE utf8mb3_spanish_ci DEFAULT NULL,
  `estado` tinyint(1) NOT NULL,
  `categoria_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `appExoticShoes_produ_categoria_id_54e33dee_fk_appExotic` (`categoria_id`),
  CONSTRAINT `appExoticShoes_produ_categoria_id_54e33dee_fk_appExotic` FOREIGN KEY (`categoria_id`) REFERENCES `appexoticshoes_categoria` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla db_tienda.appexoticshoes_producto: ~10 rows (aproximadamente)
REPLACE INTO `appexoticshoes_producto` (`id`, `nombre`, `descripcion`, `precio`, `imagen`, `estado`, `categoria_id`) VALUES
	(1, 'Blusa kanara', 'Blusas Kanaras colores blanco y negro', 27800.00, 'productos/blusa-kanara.jpg', 1, 1),
	(10, 'martillo stanley', 'martillo con mango de madera y punta de metal', 15000.00, 'productos/martillo_2IJrg5w.jpg', 0, 2),
	(11, 'taladro', 'taladro dewald multi', 15000.00, 'productos/taladro.jpg', 1, 2),
	(12, 'blusa Negra', 'blusas', 15000.00, 'productos/blusa-kanara_i474Pkv.jpg', 1, 1),
	(13, 'dfsad', 'sdf', 3232432.00, '', 1, 1),
	(14, 'dfsasadsadfsd', 'sdf', 3232432.00, '', 1, 1),
	(15, 'dfe', 'sdf', 3232432.00, '', 1, 1),
	(16, '432ffsfd', 'sdf', 3232432.00, '', 1, 1),
	(17, 'sadfsdaf', 'sadfsdaf', 2342323.00, '', 1, 2),
	(18, 'opik,ouijpmkoj', 'sadfsdaf', 2342323.00, '', 1, 2);

-- Volcando estructura para tabla db_tienda.appexoticshoes_talla
CREATE TABLE IF NOT EXISTS `appexoticshoes_talla` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `talla` varchar(10) COLLATE utf8mb3_spanish_ci NOT NULL,
  `cantidad` int NOT NULL,
  `producto_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `appExoticShoes_talla_producto_id_ef02f00b_fk_appExotic` (`producto_id`),
  CONSTRAINT `appExoticShoes_talla_producto_id_ef02f00b_fk_appExotic` FOREIGN KEY (`producto_id`) REFERENCES `appexoticshoes_producto` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla db_tienda.appexoticshoes_talla: ~2 rows (aproximadamente)
REPLACE INTO `appexoticshoes_talla` (`id`, `talla`, `cantidad`, `producto_id`) VALUES
	(1, 'S', 5, 1),
	(2, 'M', 2, 1),
	(3, 'S', 3, 11);

-- Volcando estructura para tabla db_tienda.appexoticshoes_usuario
CREATE TABLE IF NOT EXISTS `appexoticshoes_usuario` (
  `user_ptr_id` int NOT NULL,
  `telefono` varchar(45) COLLATE utf8mb3_spanish_ci NOT NULL,
  `fechaNacimiento` date NOT NULL,
  `direccion` varchar(45) COLLATE utf8mb3_spanish_ci NOT NULL,
  `fotoPerfil` varchar(100) COLLATE utf8mb3_spanish_ci DEFAULT NULL,
  PRIMARY KEY (`user_ptr_id`),
  CONSTRAINT `appExoticShoes_usuario_user_ptr_id_deccbb7e_fk_auth_user_id` FOREIGN KEY (`user_ptr_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla db_tienda.appexoticshoes_usuario: ~1 rows (aproximadamente)
REPLACE INTO `appexoticshoes_usuario` (`user_ptr_id`, `telefono`, `fechaNacimiento`, `direccion`, `fotoPerfil`) VALUES
	(2, '3168885906', '1975-12-10', 'Carrera 9a', 'perfiles/cliente.png');

-- Volcando estructura para tabla db_tienda.authtoken_token
CREATE TABLE IF NOT EXISTS `authtoken_token` (
  `key` varchar(40) COLLATE utf8mb3_spanish_ci NOT NULL,
  `created` datetime(6) NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`key`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `authtoken_token_user_id_35299eff_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla db_tienda.authtoken_token: ~0 rows (aproximadamente)

-- Volcando estructura para tabla db_tienda.auth_group
CREATE TABLE IF NOT EXISTS `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) COLLATE utf8mb3_spanish_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla db_tienda.auth_group: ~2 rows (aproximadamente)
REPLACE INTO `auth_group` (`id`, `name`) VALUES
	(1, 'admin'),
	(2, 'cliente');

-- Volcando estructura para tabla db_tienda.auth_group_permissions
CREATE TABLE IF NOT EXISTS `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla db_tienda.auth_group_permissions: ~44 rows (aproximadamente)
REPLACE INTO `auth_group_permissions` (`id`, `group_id`, `permission_id`) VALUES
	(1, 1, 25),
	(2, 1, 26),
	(3, 1, 27),
	(4, 1, 28),
	(5, 1, 29),
	(6, 1, 30),
	(7, 1, 31),
	(8, 1, 32),
	(9, 1, 33),
	(10, 1, 34),
	(11, 1, 35),
	(12, 1, 36),
	(13, 1, 37),
	(14, 1, 38),
	(15, 1, 39),
	(16, 1, 40),
	(17, 1, 41),
	(18, 1, 42),
	(19, 1, 43),
	(20, 1, 44),
	(21, 1, 45),
	(22, 1, 46),
	(23, 1, 47),
	(24, 1, 48),
	(25, 1, 49),
	(26, 1, 50),
	(27, 1, 51),
	(28, 1, 52),
	(29, 1, 53),
	(30, 1, 54),
	(31, 1, 55),
	(32, 1, 56),
	(33, 1, 57),
	(34, 1, 58),
	(35, 1, 59),
	(36, 1, 60),
	(37, 1, 61),
	(38, 1, 62),
	(39, 1, 63),
	(40, 1, 64),
	(41, 1, 65),
	(42, 1, 66),
	(43, 1, 67),
	(44, 1, 68);

-- Volcando estructura para tabla db_tienda.auth_permission
CREATE TABLE IF NOT EXISTS `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb3_spanish_ci NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) COLLATE utf8mb3_spanish_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla db_tienda.auth_permission: ~76 rows (aproximadamente)
REPLACE INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
	(1, 'Can add log entry', 1, 'add_logentry'),
	(2, 'Can change log entry', 1, 'change_logentry'),
	(3, 'Can delete log entry', 1, 'delete_logentry'),
	(4, 'Can view log entry', 1, 'view_logentry'),
	(5, 'Can add permission', 2, 'add_permission'),
	(6, 'Can change permission', 2, 'change_permission'),
	(7, 'Can delete permission', 2, 'delete_permission'),
	(8, 'Can view permission', 2, 'view_permission'),
	(9, 'Can add group', 3, 'add_group'),
	(10, 'Can change group', 3, 'change_group'),
	(11, 'Can delete group', 3, 'delete_group'),
	(12, 'Can view group', 3, 'view_group'),
	(13, 'Can add user', 4, 'add_user'),
	(14, 'Can change user', 4, 'change_user'),
	(15, 'Can delete user', 4, 'delete_user'),
	(16, 'Can view user', 4, 'view_user'),
	(17, 'Can add content type', 5, 'add_contenttype'),
	(18, 'Can change content type', 5, 'change_contenttype'),
	(19, 'Can delete content type', 5, 'delete_contenttype'),
	(20, 'Can view content type', 5, 'view_contenttype'),
	(21, 'Can add session', 6, 'add_session'),
	(22, 'Can change session', 6, 'change_session'),
	(23, 'Can delete session', 6, 'delete_session'),
	(24, 'Can view session', 6, 'view_session'),
	(25, 'Can add cart', 7, 'add_cart'),
	(26, 'Can change cart', 7, 'change_cart'),
	(27, 'Can delete cart', 7, 'delete_cart'),
	(28, 'Can view cart', 7, 'view_cart'),
	(29, 'Can add categoria', 8, 'add_categoria'),
	(30, 'Can change categoria', 8, 'change_categoria'),
	(31, 'Can delete categoria', 8, 'delete_categoria'),
	(32, 'Can view categoria', 8, 'view_categoria'),
	(33, 'Can add producto', 9, 'add_producto'),
	(34, 'Can change producto', 9, 'change_producto'),
	(35, 'Can delete producto', 9, 'delete_producto'),
	(36, 'Can view producto', 9, 'view_producto'),
	(37, 'Can add user', 10, 'add_usuario'),
	(38, 'Can change user', 10, 'change_usuario'),
	(39, 'Can delete user', 10, 'delete_usuario'),
	(40, 'Can view user', 10, 'view_usuario'),
	(41, 'Can add talla', 11, 'add_talla'),
	(42, 'Can change talla', 11, 'change_talla'),
	(43, 'Can delete talla', 11, 'delete_talla'),
	(44, 'Can view talla', 11, 'view_talla'),
	(45, 'Can add pedido', 12, 'add_pedido'),
	(46, 'Can change pedido', 12, 'change_pedido'),
	(47, 'Can delete pedido', 12, 'delete_pedido'),
	(48, 'Can view pedido', 12, 'view_pedido'),
	(49, 'Can add pago', 13, 'add_pago'),
	(50, 'Can change pago', 13, 'change_pago'),
	(51, 'Can delete pago', 13, 'delete_pago'),
	(52, 'Can view pago', 13, 'view_pago'),
	(53, 'Can add envio', 14, 'add_envio'),
	(54, 'Can change envio', 14, 'change_envio'),
	(55, 'Can delete envio', 14, 'delete_envio'),
	(56, 'Can view envio', 14, 'view_envio'),
	(57, 'Can add devolucione', 15, 'add_devolucione'),
	(58, 'Can change devolucione', 15, 'change_devolucione'),
	(59, 'Can delete devolucione', 15, 'delete_devolucione'),
	(60, 'Can view devolucione', 15, 'view_devolucione'),
	(61, 'Can add detalle pedido', 16, 'add_detallepedido'),
	(62, 'Can change detalle pedido', 16, 'change_detallepedido'),
	(63, 'Can delete detalle pedido', 16, 'delete_detallepedido'),
	(64, 'Can view detalle pedido', 16, 'view_detallepedido'),
	(65, 'Can add cart item', 17, 'add_cartitem'),
	(66, 'Can change cart item', 17, 'change_cartitem'),
	(67, 'Can delete cart item', 17, 'delete_cartitem'),
	(68, 'Can view cart item', 17, 'view_cartitem'),
	(69, 'Can add Token', 18, 'add_token'),
	(70, 'Can change Token', 18, 'change_token'),
	(71, 'Can delete Token', 18, 'delete_token'),
	(72, 'Can view Token', 18, 'view_token'),
	(73, 'Can add token', 19, 'add_tokenproxy'),
	(74, 'Can change token', 19, 'change_tokenproxy'),
	(75, 'Can delete token', 19, 'delete_tokenproxy'),
	(76, 'Can view token', 19, 'view_tokenproxy');

-- Volcando estructura para tabla db_tienda.auth_user
CREATE TABLE IF NOT EXISTS `auth_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(128) COLLATE utf8mb3_spanish_ci NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) COLLATE utf8mb3_spanish_ci NOT NULL,
  `first_name` varchar(150) COLLATE utf8mb3_spanish_ci NOT NULL,
  `last_name` varchar(150) COLLATE utf8mb3_spanish_ci NOT NULL,
  `email` varchar(254) COLLATE utf8mb3_spanish_ci NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla db_tienda.auth_user: ~2 rows (aproximadamente)
REPLACE INTO `auth_user` (`id`, `password`, `last_login`, `is_superuser`, `username`, `first_name`, `last_name`, `email`, `is_staff`, `is_active`, `date_joined`) VALUES
	(1, 'pbkdf2_sha256$600000$UYLpzzfrgVKa21t8x3fojW$QIiBRQsri8/mlNZFW2nv9SsmlA19xsa55rHbPgL52oA=', '2023-09-11 00:42:45.236961', 1, 'admin', '', '', 'dajun318@gmail.com', 1, 1, '2023-09-10 18:53:41.000000'),
	(2, 'pbkdf2_sha256$600000$wnkb1wepDprRkfzyR7mwwP$EXjggzCMyfQaGE87NNhShTZYcI+oZErrBy7CTV/YShI=', NULL, 0, 'cliente', 'Jaime', 'Chimbaco', 'jaimechimbaco1@gmail.com', 0, 1, '2023-09-10 19:00:58.000000');

-- Volcando estructura para tabla db_tienda.auth_user_groups
CREATE TABLE IF NOT EXISTS `auth_user_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla db_tienda.auth_user_groups: ~2 rows (aproximadamente)
REPLACE INTO `auth_user_groups` (`id`, `user_id`, `group_id`) VALUES
	(1, 1, 1),
	(2, 2, 2);

-- Volcando estructura para tabla db_tienda.auth_user_user_permissions
CREATE TABLE IF NOT EXISTS `auth_user_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla db_tienda.auth_user_user_permissions: ~0 rows (aproximadamente)

-- Volcando estructura para tabla db_tienda.django_admin_log
CREATE TABLE IF NOT EXISTS `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext COLLATE utf8mb3_spanish_ci,
  `object_repr` varchar(200) COLLATE utf8mb3_spanish_ci NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext COLLATE utf8mb3_spanish_ci NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla db_tienda.django_admin_log: ~10 rows (aproximadamente)
REPLACE INTO `django_admin_log` (`id`, `action_time`, `object_id`, `object_repr`, `action_flag`, `change_message`, `content_type_id`, `user_id`) VALUES
	(1, '2023-09-10 18:54:18.660765', '1', 'admin', 1, '[{"added": {}}]', 3, 1),
	(2, '2023-09-10 18:54:27.008657', '2', 'cliente', 1, '[{"added": {}}]', 3, 1),
	(3, '2023-09-10 18:54:37.675371', '1', 'admin', 2, '[{"changed": {"fields": ["Groups"]}}]', 4, 1),
	(4, '2023-09-10 18:56:22.818570', '1', 'Ropa', 1, '[{"added": {}}]', 8, 1),
	(5, '2023-09-10 18:58:09.637878', '1', 'Producto object (1)', 1, '[{"added": {}}]', 9, 1),
	(6, '2023-09-10 19:00:18.283146', '1', 'S', 1, '[{"added": {}}]', 11, 1),
	(7, '2023-09-10 19:00:33.379279', '2', 'M', 1, '[{"added": {}}]', 11, 1),
	(8, '2023-09-10 19:02:52.675521', '2', 'cliente', 1, '[{"added": {}}]', 10, 1),
	(9, '2023-09-10 19:03:16.983369', '2', 'cliente', 2, '[{"changed": {"fields": ["password"]}}]', 4, 1),
	(10, '2023-09-10 19:03:45.469480', '1', 'Pedido COD001', 1, '[{"added": {}}]', 12, 1),
	(11, '2023-09-10 19:11:22.657201', '1', 'Detalle de pedido COD001', 1, '[{"added": {}}]', 16, 1),
	(12, '2023-09-10 19:11:55.642711', '1', 'Pago 1', 1, '[{"added": {}}]', 13, 1),
	(13, '2023-09-10 19:12:24.285630', '1', 'Envio object (1)', 1, '[{"added": {}}]', 14, 1);

-- Volcando estructura para tabla db_tienda.django_content_type
CREATE TABLE IF NOT EXISTS `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) COLLATE utf8mb3_spanish_ci NOT NULL,
  `model` varchar(100) COLLATE utf8mb3_spanish_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla db_tienda.django_content_type: ~19 rows (aproximadamente)
REPLACE INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
	(1, 'admin', 'logentry'),
	(7, 'appExoticShoes', 'cart'),
	(17, 'appExoticShoes', 'cartitem'),
	(8, 'appExoticShoes', 'categoria'),
	(16, 'appExoticShoes', 'detallepedido'),
	(15, 'appExoticShoes', 'devolucione'),
	(14, 'appExoticShoes', 'envio'),
	(13, 'appExoticShoes', 'pago'),
	(12, 'appExoticShoes', 'pedido'),
	(9, 'appExoticShoes', 'producto'),
	(11, 'appExoticShoes', 'talla'),
	(10, 'appExoticShoes', 'usuario'),
	(3, 'auth', 'group'),
	(2, 'auth', 'permission'),
	(4, 'auth', 'user'),
	(18, 'authtoken', 'token'),
	(19, 'authtoken', 'tokenproxy'),
	(5, 'contenttypes', 'contenttype'),
	(6, 'sessions', 'session');

-- Volcando estructura para tabla db_tienda.django_migrations
CREATE TABLE IF NOT EXISTS `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) COLLATE utf8mb3_spanish_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb3_spanish_ci NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla db_tienda.django_migrations: ~22 rows (aproximadamente)
REPLACE INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
	(1, 'contenttypes', '0001_initial', '2023-09-10 18:53:14.753900'),
	(2, 'auth', '0001_initial', '2023-09-10 18:53:15.407880'),
	(3, 'admin', '0001_initial', '2023-09-10 18:53:15.551587'),
	(4, 'admin', '0002_logentry_remove_auto_add', '2023-09-10 18:53:15.561369'),
	(5, 'admin', '0003_logentry_add_action_flag_choices', '2023-09-10 18:53:15.574361'),
	(6, 'contenttypes', '0002_remove_content_type_name', '2023-09-10 18:53:15.684445'),
	(7, 'auth', '0002_alter_permission_name_max_length', '2023-09-10 18:53:15.755614'),
	(8, 'auth', '0003_alter_user_email_max_length', '2023-09-10 18:53:15.844027'),
	(9, 'auth', '0004_alter_user_username_opts', '2023-09-10 18:53:15.856036'),
	(10, 'auth', '0005_alter_user_last_login_null', '2023-09-10 18:53:15.935273'),
	(11, 'auth', '0006_require_contenttypes_0002', '2023-09-10 18:53:15.939487'),
	(12, 'auth', '0007_alter_validators_add_error_messages', '2023-09-10 18:53:15.948835'),
	(13, 'auth', '0008_alter_user_username_max_length', '2023-09-10 18:53:16.028258'),
	(14, 'auth', '0009_alter_user_last_name_max_length', '2023-09-10 18:53:16.141534'),
	(15, 'auth', '0010_alter_group_name_max_length', '2023-09-10 18:53:16.248469'),
	(16, 'auth', '0011_update_proxy_permissions', '2023-09-10 18:53:16.264460'),
	(17, 'auth', '0012_alter_user_first_name_max_length', '2023-09-10 18:53:16.374393'),
	(18, 'appExoticShoes', '0001_initial', '2023-09-10 18:53:17.315218'),
	(19, 'authtoken', '0001_initial', '2023-09-10 18:53:17.433852'),
	(20, 'authtoken', '0002_auto_20160226_1747', '2023-09-10 18:53:17.483838'),
	(21, 'authtoken', '0003_tokenproxy', '2023-09-10 18:53:17.488832'),
	(22, 'sessions', '0001_initial', '2023-09-10 18:53:17.538186'),
	(23, 'appExoticShoes', '0002_rename_nombre_talla_talla', '2023-09-10 21:08:03.396873'),
	(24, 'appExoticShoes', '0003_alter_producto_imagen', '2023-09-10 22:30:59.542626');

-- Volcando estructura para tabla db_tienda.django_session
CREATE TABLE IF NOT EXISTS `django_session` (
  `session_key` varchar(40) COLLATE utf8mb3_spanish_ci NOT NULL,
  `session_data` longtext COLLATE utf8mb3_spanish_ci NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla db_tienda.django_session: ~1 rows (aproximadamente)
REPLACE INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
	('470lq45a6ibvdk6egmrh7uod90w8swmp', '.eJxVjEsOAiEQBe_C2pBu-YlL956BQDfIqIFkmFkZ766TzEK3r6reS4S4LjWsI89hYnEWKA6_W4r0yG0DfI_t1iX1tsxTkpsidzrktXN-Xnb376DGUb-1R6BUcjYWFRbUcNI2ok_OEngsilMxGlwpDKCQnE6GGCF71HRk78T7A9eaN5I:1qfPiG:wkFS0LoZhxoOms0YLqebg1pmYwbgAH8Y8apyuH5C2FU', '2023-09-11 03:03:16.992363'),
	('51ypwc2t5pgoaf40k4ttof3y1kkidtch', '.eJxVjEEOwiAQRe_C2pAZS4t06d4zEGAGixow0CYa4921SRe6_e_99xLWLfNkl8bVJhKjQLH73bwLV84roIvL5yJDyXNNXq6K3GiTp0J8O27uX2Bybfq-DULwkbkfsMOICg5qcGi8HgIYjB352CvQMRJAh0Er3wdCYIMq7MnoNdq4tVSy5cc91acY4f0BeVg-zw:1qfTqL:-U7758p4HYspE_IMLL8THN_Ha06RQOwuN8djvppey30', '2023-09-11 07:27:53.981336'),
	('9eocejsjkkr70o5i33mv00yiyg79m1tl', '.eJxVjEEOwiAQRe_C2pAZS4t06d4zEGAGixow0CYa4921SRe6_e_99xLWLfNkl8bVJhKjQLH73bwLV84roIvL5yJDyXNNXq6K3GiTp0J8O27uX2Bybfq-DULwkbkfsMOICg5qcGi8HgIYjB352CvQMRJAh0Er3wdCYIMq7MnoNdq4tVSy5cc91acY4f0BeVg-zw:1qfR1y:ZdlVkNNOfu7jhsj8aFrVIvVdNWuSxjz25n2NANoS7H0', '2023-09-11 04:27:42.097923'),
	('9n741i1pijvb4n6yq50f2rk7jd17fep5', '.eJxVjEEOwiAQRe_C2pAZS4t06d4zEGAGixow0CYa4921SRe6_e_99xLWLfNkl8bVJhKjQLH73bwLV84roIvL5yJDyXNNXq6K3GiTp0J8O27uX2Bybfq-DULwkbkfsMOICg5qcGi8HgIYjB352CvQMRJAh0Er3wdCYIMq7MnoNdq4tVSy5cc91acY4f0BeVg-zw:1qfRdj:dXDGurcjKPLEv2BUZq_JbyYYysuuh_Ka7TeR91rywFQ', '2023-09-11 05:06:43.596118'),
	('q8ryr5pf0g1yyvjaofvn6j6m6fydr4qc', '.eJxVjEEOwiAQRe_C2pAZS4t06d4zEGAGixow0CYa4921SRe6_e_99xLWLfNkl8bVJhKjQLH73bwLV84roIvL5yJDyXNNXq6K3GiTp0J8O27uX2Bybfq-DULwkbkfsMOICg5qcGi8HgIYjB352CvQMRJAh0Er3wdCYIMq7MnoNdq4tVSy5cc91acY4f0BeVg-zw:1qfTfv:V1wVAmhfWMht1mHWlulcjuRIIsDuESNqzjQGkf-bq1U', '2023-09-11 07:17:07.925692'),
	('w5truqka7ppc8nhejwekqnqvg620pd03', '.eJxVjEEOwiAQRe_C2pAZS4t06d4zEGAGixow0CYa4921SRe6_e_99xLWLfNkl8bVJhKjQLH73bwLV84roIvL5yJDyXNNXq6K3GiTp0J8O27uX2Bybfq-DULwkbkfsMOICg5qcGi8HgIYjB352CvQMRJAh0Er3wdCYIMq7MnoNdq4tVSy5cc91acY4f0BeVg-zw:1qfV0n:LWNSKOvgek6KJ0BgLb26HQUr6meTC8iFNwW8-mIF0JE', '2023-09-11 08:42:45.240324');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
