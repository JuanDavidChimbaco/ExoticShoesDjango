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
  `imagenCategoria` varchar(100) COLLATE utf8mb3_spanish_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla db_tienda.appexoticshoes_categoria: ~0 rows (aproximadamente)

-- Volcando estructura para tabla db_tienda.appexoticshoes_detallepedido
CREATE TABLE IF NOT EXISTS `appexoticshoes_detallepedido` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `cantidad` int NOT NULL,
  `subtotal` double NOT NULL,
  `pedido_id` bigint NOT NULL,
  `producto_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `appExoticShoes_detal_pedido_id_8c7306f0_fk_appExotic` (`pedido_id`),
  KEY `appExoticShoes_detal_producto_id_29dfa03e_fk_appExotic` (`producto_id`),
  CONSTRAINT `appExoticShoes_detal_pedido_id_8c7306f0_fk_appExotic` FOREIGN KEY (`pedido_id`) REFERENCES `appexoticshoes_pedido` (`id`),
  CONSTRAINT `appExoticShoes_detal_producto_id_29dfa03e_fk_appExotic` FOREIGN KEY (`producto_id`) REFERENCES `appexoticshoes_producto` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla db_tienda.appexoticshoes_detallepedido: ~0 rows (aproximadamente)

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla db_tienda.appexoticshoes_envio: ~0 rows (aproximadamente)

-- Volcando estructura para tabla db_tienda.appexoticshoes_imagenproducto
CREATE TABLE IF NOT EXISTS `appexoticshoes_imagenproducto` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `imagen` varchar(100) COLLATE utf8mb3_spanish_ci NOT NULL,
  `producto_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `appExoticShoes_image_producto_id_40d0e70e_fk_appExotic` (`producto_id`),
  CONSTRAINT `appExoticShoes_image_producto_id_40d0e70e_fk_appExotic` FOREIGN KEY (`producto_id`) REFERENCES `appexoticshoes_producto` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla db_tienda.appexoticshoes_imagenproducto: ~0 rows (aproximadamente)

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla db_tienda.appexoticshoes_pago: ~0 rows (aproximadamente)

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla db_tienda.appexoticshoes_pedido: ~0 rows (aproximadamente)

-- Volcando estructura para tabla db_tienda.appexoticshoes_producto
CREATE TABLE IF NOT EXISTS `appexoticshoes_producto` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) COLLATE utf8mb3_spanish_ci NOT NULL,
  `descripcion` varchar(45) COLLATE utf8mb3_spanish_ci NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `existencias` int NOT NULL,
  `estado` tinyint(1) NOT NULL,
  `categoria_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `appExoticShoes_produ_categoria_id_54e33dee_fk_appExotic` (`categoria_id`),
  CONSTRAINT `appExoticShoes_produ_categoria_id_54e33dee_fk_appExotic` FOREIGN KEY (`categoria_id`) REFERENCES `appexoticshoes_categoria` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla db_tienda.appexoticshoes_producto: ~0 rows (aproximadamente)

-- Volcando estructura para tabla db_tienda.appexoticshoes_productocontalla
CREATE TABLE IF NOT EXISTS `appexoticshoes_productocontalla` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `existencias` int NOT NULL,
  `producto_id` bigint NOT NULL,
  `talla_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `appExoticShoes_produ_producto_id_55b557aa_fk_appExotic` (`producto_id`),
  KEY `appExoticShoes_produ_talla_id_e452754a_fk_appExotic` (`talla_id`),
  CONSTRAINT `appExoticShoes_produ_producto_id_55b557aa_fk_appExotic` FOREIGN KEY (`producto_id`) REFERENCES `appexoticshoes_producto` (`id`),
  CONSTRAINT `appExoticShoes_produ_talla_id_e452754a_fk_appExotic` FOREIGN KEY (`talla_id`) REFERENCES `appexoticshoes_talla` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla db_tienda.appexoticshoes_productocontalla: ~0 rows (aproximadamente)

-- Volcando estructura para tabla db_tienda.appexoticshoes_talla
CREATE TABLE IF NOT EXISTS `appexoticshoes_talla` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nombre` varchar(3) COLLATE utf8mb3_spanish_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla db_tienda.appexoticshoes_talla: ~0 rows (aproximadamente)

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
	(2, '3167599628', '2000-09-04', 'Carrera 9b', '');

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
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla db_tienda.auth_group_permissions: ~52 rows (aproximadamente)
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
	(44, 1, 68),
	(45, 1, 69),
	(46, 1, 70),
	(47, 1, 71),
	(48, 1, 72),
	(49, 1, 73),
	(50, 1, 74),
	(51, 1, 75),
	(52, 1, 76);

-- Volcando estructura para tabla db_tienda.auth_permission
CREATE TABLE IF NOT EXISTS `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb3_spanish_ci NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) COLLATE utf8mb3_spanish_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla db_tienda.auth_permission: ~84 rows (aproximadamente)
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
	(37, 'Can add talla', 10, 'add_talla'),
	(38, 'Can change talla', 10, 'change_talla'),
	(39, 'Can delete talla', 10, 'delete_talla'),
	(40, 'Can view talla', 10, 'view_talla'),
	(41, 'Can add user', 11, 'add_usuario'),
	(42, 'Can change user', 11, 'change_usuario'),
	(43, 'Can delete user', 11, 'delete_usuario'),
	(44, 'Can view user', 11, 'view_usuario'),
	(45, 'Can add producto con talla', 12, 'add_productocontalla'),
	(46, 'Can change producto con talla', 12, 'change_productocontalla'),
	(47, 'Can delete producto con talla', 12, 'delete_productocontalla'),
	(48, 'Can view producto con talla', 12, 'view_productocontalla'),
	(49, 'Can add pedido', 13, 'add_pedido'),
	(50, 'Can change pedido', 13, 'change_pedido'),
	(51, 'Can delete pedido', 13, 'delete_pedido'),
	(52, 'Can view pedido', 13, 'view_pedido'),
	(53, 'Can add pago', 14, 'add_pago'),
	(54, 'Can change pago', 14, 'change_pago'),
	(55, 'Can delete pago', 14, 'delete_pago'),
	(56, 'Can view pago', 14, 'view_pago'),
	(57, 'Can add imagen producto', 15, 'add_imagenproducto'),
	(58, 'Can change imagen producto', 15, 'change_imagenproducto'),
	(59, 'Can delete imagen producto', 15, 'delete_imagenproducto'),
	(60, 'Can view imagen producto', 15, 'view_imagenproducto'),
	(61, 'Can add envio', 16, 'add_envio'),
	(62, 'Can change envio', 16, 'change_envio'),
	(63, 'Can delete envio', 16, 'delete_envio'),
	(64, 'Can view envio', 16, 'view_envio'),
	(65, 'Can add devolucione', 17, 'add_devolucione'),
	(66, 'Can change devolucione', 17, 'change_devolucione'),
	(67, 'Can delete devolucione', 17, 'delete_devolucione'),
	(68, 'Can view devolucione', 17, 'view_devolucione'),
	(69, 'Can add detalle pedido', 18, 'add_detallepedido'),
	(70, 'Can change detalle pedido', 18, 'change_detallepedido'),
	(71, 'Can delete detalle pedido', 18, 'delete_detallepedido'),
	(72, 'Can view detalle pedido', 18, 'view_detallepedido'),
	(73, 'Can add cart item', 19, 'add_cartitem'),
	(74, 'Can change cart item', 19, 'change_cartitem'),
	(75, 'Can delete cart item', 19, 'delete_cartitem'),
	(76, 'Can view cart item', 19, 'view_cartitem'),
	(77, 'Can add Token', 20, 'add_token'),
	(78, 'Can change Token', 20, 'change_token'),
	(79, 'Can delete Token', 20, 'delete_token'),
	(80, 'Can view Token', 20, 'view_token'),
	(81, 'Can add token', 21, 'add_tokenproxy'),
	(82, 'Can change token', 21, 'change_tokenproxy'),
	(83, 'Can delete token', 21, 'delete_tokenproxy'),
	(84, 'Can view token', 21, 'view_tokenproxy');

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
	(1, 'pbkdf2_sha256$600000$UOXlknYpzUlyOsAVSUgeSV$IhoGMhwh3wglWZkz9Oyv7Fg5GHY66eS5eRfW0aUEgVs=', '2023-09-05 04:33:16.239912', 1, 'admin', '', '', 'dajun318@gmail.com', 1, 1, '2023-09-05 02:37:56.000000'),
	(2, '1234', NULL, 0, 'admin2', 'Maira', 'Solano', '30414d63546c42626169@findtempmail.best', 0, 1, '2023-09-05 04:34:36.000000');

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
	(2, 2, 1);

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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla db_tienda.django_admin_log: ~4 rows (aproximadamente)
REPLACE INTO `django_admin_log` (`id`, `action_time`, `object_id`, `object_repr`, `action_flag`, `change_message`, `content_type_id`, `user_id`) VALUES
	(1, '2023-09-05 04:29:30.793325', '1', 'admin', 1, '[{"added": {}}]', 3, 1),
	(2, '2023-09-05 04:29:41.711233', '2', 'cliente', 1, '[{"added": {}}]', 3, 1),
	(3, '2023-09-05 04:33:05.016231', '1', 'admin', 2, '[{"changed": {"fields": ["Groups"]}}]', 4, 1),
	(4, '2023-09-05 04:36:04.262044', '2', 'admin2', 1, '[{"added": {}}]', 11, 1);

-- Volcando estructura para tabla db_tienda.django_content_type
CREATE TABLE IF NOT EXISTS `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) COLLATE utf8mb3_spanish_ci NOT NULL,
  `model` varchar(100) COLLATE utf8mb3_spanish_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla db_tienda.django_content_type: ~21 rows (aproximadamente)
REPLACE INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
	(1, 'admin', 'logentry'),
	(7, 'appExoticShoes', 'cart'),
	(19, 'appExoticShoes', 'cartitem'),
	(8, 'appExoticShoes', 'categoria'),
	(18, 'appExoticShoes', 'detallepedido'),
	(17, 'appExoticShoes', 'devolucione'),
	(16, 'appExoticShoes', 'envio'),
	(15, 'appExoticShoes', 'imagenproducto'),
	(14, 'appExoticShoes', 'pago'),
	(13, 'appExoticShoes', 'pedido'),
	(9, 'appExoticShoes', 'producto'),
	(12, 'appExoticShoes', 'productocontalla'),
	(10, 'appExoticShoes', 'talla'),
	(11, 'appExoticShoes', 'usuario'),
	(3, 'auth', 'group'),
	(2, 'auth', 'permission'),
	(4, 'auth', 'user'),
	(20, 'authtoken', 'token'),
	(21, 'authtoken', 'tokenproxy'),
	(5, 'contenttypes', 'contenttype'),
	(6, 'sessions', 'session');

-- Volcando estructura para tabla db_tienda.django_migrations
CREATE TABLE IF NOT EXISTS `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) COLLATE utf8mb3_spanish_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb3_spanish_ci NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla db_tienda.django_migrations: ~22 rows (aproximadamente)
REPLACE INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
	(1, 'contenttypes', '0001_initial', '2023-09-05 02:36:41.327122'),
	(2, 'auth', '0001_initial', '2023-09-05 02:36:41.992649'),
	(3, 'admin', '0001_initial', '2023-09-05 02:36:42.151444'),
	(4, 'admin', '0002_logentry_remove_auto_add', '2023-09-05 02:36:42.162438'),
	(5, 'admin', '0003_logentry_add_action_flag_choices', '2023-09-05 02:36:42.177358'),
	(6, 'contenttypes', '0002_remove_content_type_name', '2023-09-05 02:36:42.338249'),
	(7, 'auth', '0002_alter_permission_name_max_length', '2023-09-05 02:36:42.489158'),
	(8, 'auth', '0003_alter_user_email_max_length', '2023-09-05 02:36:42.626072'),
	(9, 'auth', '0004_alter_user_username_opts', '2023-09-05 02:36:42.645061'),
	(10, 'auth', '0005_alter_user_last_login_null', '2023-09-05 02:36:42.737003'),
	(11, 'auth', '0006_require_contenttypes_0002', '2023-09-05 02:36:42.742001'),
	(12, 'auth', '0007_alter_validators_add_error_messages', '2023-09-05 02:36:42.751996'),
	(13, 'auth', '0008_alter_user_username_max_length', '2023-09-05 02:36:42.841914'),
	(14, 'auth', '0009_alter_user_last_name_max_length', '2023-09-05 02:36:42.949094'),
	(15, 'auth', '0010_alter_group_name_max_length', '2023-09-05 02:36:43.035547'),
	(16, 'auth', '0011_update_proxy_permissions', '2023-09-05 02:36:43.045538'),
	(17, 'auth', '0012_alter_user_first_name_max_length', '2023-09-05 02:36:43.138715'),
	(18, 'appExoticShoes', '0001_initial', '2023-09-05 02:36:44.308027'),
	(19, 'authtoken', '0001_initial', '2023-09-05 02:36:44.447301'),
	(20, 'authtoken', '0002_auto_20160226_1747', '2023-09-05 02:36:44.499267'),
	(21, 'authtoken', '0003_tokenproxy', '2023-09-05 02:36:44.503788'),
	(22, 'sessions', '0001_initial', '2023-09-05 02:36:44.548460');

-- Volcando estructura para tabla db_tienda.django_session
CREATE TABLE IF NOT EXISTS `django_session` (
  `session_key` varchar(40) COLLATE utf8mb3_spanish_ci NOT NULL,
  `session_data` longtext COLLATE utf8mb3_spanish_ci NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla db_tienda.django_session: ~2 rows (aproximadamente)
REPLACE INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
	('4urifqftgp0dt15hrugz0u7i69ujn8dv', '.eJxVjMsOwiAQRf-FtSE8Kkxduu83kGEYpGogKe3K-O_apAvd3nPOfYmA21rC1nkJcxIXocXpd4tID647SHestyap1XWZo9wVedAup5b4eT3cv4OCvXxrdEDKnwc_ZB9ZKWPYGQA0UTmC0WrmzNmmRMmPg2ZnwWAkdgpQaevF-wPb0zfR:1qdLxR:ykUE3D87_Q9ayekIDjBTY5NKV-Na1fYREHpIT-2mp8s', '2023-09-05 03:08:25.631878'),
	('jocalt211pecnuo5gusfuu2tqctt425l', '.eJxVjMsOwiAQRf-FtSE8Kkxduu83kGEYpGogKe3K-O_apAvd3nPOfYmA21rC1nkJcxIXocXpd4tID647SHestyap1XWZo9wVedAup5b4eT3cv4OCvXxrdEDKnwc_ZB9ZKWPYGQA0UTmC0WrmzNmmRMmPg2ZnwWAkdgpQaevF-wPb0zfR:1qdNka:IYOag4M5LuPF7RtFFbsTNCox1MK_Flzolbyha81e6OE', '2023-09-05 05:03:16.243916');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
