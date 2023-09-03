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


-- Volcando estructura de base de datos para tiendaexoticshoes
CREATE DATABASE IF NOT EXISTS `tiendaexoticshoes` /*!40100 DEFAULT CHARACTER SET utf8mb3 COLLATE utf8mb3_spanish_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `tiendaexoticshoes`;

-- Volcando estructura para tabla tiendaexoticshoes.appexoticshoes_cart
CREATE TABLE IF NOT EXISTS `appexoticshoes_cart` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `appExoticShoes_cart_user_id_01fba2fe_fk_appExotic` FOREIGN KEY (`user_id`) REFERENCES `appexoticshoes_usuario` (`user_ptr_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla tiendaexoticshoes.appexoticshoes_cart: ~0 rows (aproximadamente)

-- Volcando estructura para tabla tiendaexoticshoes.appexoticshoes_cartitem
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

-- Volcando datos para la tabla tiendaexoticshoes.appexoticshoes_cartitem: ~0 rows (aproximadamente)

-- Volcando estructura para tabla tiendaexoticshoes.appexoticshoes_categoria
CREATE TABLE IF NOT EXISTS `appexoticshoes_categoria` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) COLLATE utf8mb3_spanish_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla tiendaexoticshoes.appexoticshoes_categoria: ~4 rows (aproximadamente)
REPLACE INTO `appexoticshoes_categoria` (`id`, `nombre`) VALUES
	(3, 'Blusas'),
	(2, 'Herramientas'),
	(4, 'Lociones'),
	(1, 'Zapatos');

-- Volcando estructura para tabla tiendaexoticshoes.appexoticshoes_detallepedido
CREATE TABLE IF NOT EXISTS `appexoticshoes_detallepedido` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `cantidad` int NOT NULL,
  `subtotal` double NOT NULL,
  `pedido_id` bigint NOT NULL,
  `producto_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `appExoticShoes_detal_producto_id_29dfa03e_fk_appExotic` (`producto_id`),
  KEY `appExoticShoes_detal_pedido_id_8c7306f0_fk_appExotic` (`pedido_id`),
  CONSTRAINT `appExoticShoes_detal_pedido_id_8c7306f0_fk_appExotic` FOREIGN KEY (`pedido_id`) REFERENCES `appexoticshoes_pedido` (`id`),
  CONSTRAINT `appExoticShoes_detal_producto_id_29dfa03e_fk_appExotic` FOREIGN KEY (`producto_id`) REFERENCES `appexoticshoes_producto` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla tiendaexoticshoes.appexoticshoes_detallepedido: ~0 rows (aproximadamente)

-- Volcando estructura para tabla tiendaexoticshoes.appexoticshoes_devolucione
CREATE TABLE IF NOT EXISTS `appexoticshoes_devolucione` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `fechaDevolucion` datetime(6) DEFAULT NULL,
  `motivo` varchar(200) COLLATE utf8mb3_spanish_ci NOT NULL,
  `productosDevueltos` varchar(45) COLLATE utf8mb3_spanish_ci DEFAULT NULL,
  `cantidadDevuelta` int DEFAULT NULL,
  `envio_id` bigint DEFAULT NULL,
  `pago_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `appExoticShoes_devol_envio_id_1a62d54e_fk_appExotic` (`envio_id`),
  KEY `appExoticShoes_devol_pago_id_566dc979_fk_appExotic` (`pago_id`),
  CONSTRAINT `appExoticShoes_devol_envio_id_1a62d54e_fk_appExotic` FOREIGN KEY (`envio_id`) REFERENCES `appexoticshoes_envio` (`id`),
  CONSTRAINT `appExoticShoes_devol_pago_id_566dc979_fk_appExotic` FOREIGN KEY (`pago_id`) REFERENCES `appexoticshoes_pago` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla tiendaexoticshoes.appexoticshoes_devolucione: ~0 rows (aproximadamente)

-- Volcando estructura para tabla tiendaexoticshoes.appexoticshoes_envio
CREATE TABLE IF NOT EXISTS `appexoticshoes_envio` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `servicioEnvio` varchar(45) COLLATE utf8mb3_spanish_ci NOT NULL,
  `DireccionEnv` varchar(45) COLLATE utf8mb3_spanish_ci NOT NULL,
  `fechaEnvio` datetime(6) NOT NULL,
  `fechaEntrega` datetime(6) NOT NULL,
  `estado` varchar(45) COLLATE utf8mb3_spanish_ci DEFAULT NULL,
  `estadoPago_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `appExoticShoes_envio_estadoPago_id_b142f800_fk_appExotic` (`estadoPago_id`),
  CONSTRAINT `appExoticShoes_envio_estadoPago_id_b142f800_fk_appExotic` FOREIGN KEY (`estadoPago_id`) REFERENCES `appexoticshoes_pago` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla tiendaexoticshoes.appexoticshoes_envio: ~0 rows (aproximadamente)

-- Volcando estructura para tabla tiendaexoticshoes.appexoticshoes_pago
CREATE TABLE IF NOT EXISTS `appexoticshoes_pago` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `metodo` varchar(45) COLLATE utf8mb3_spanish_ci NOT NULL,
  `monto` double NOT NULL,
  `fecha` datetime(6) NOT NULL,
  `estado` varchar(45) COLLATE utf8mb3_spanish_ci DEFAULT NULL,
  `pedidos_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `appExoticShoes_pago_pedidos_id_18f1d6da_fk_appExotic` (`pedidos_id`),
  CONSTRAINT `appExoticShoes_pago_pedidos_id_18f1d6da_fk_appExotic` FOREIGN KEY (`pedidos_id`) REFERENCES `appexoticshoes_pedido` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla tiendaexoticshoes.appexoticshoes_pago: ~0 rows (aproximadamente)

-- Volcando estructura para tabla tiendaexoticshoes.appexoticshoes_pedido
CREATE TABLE IF NOT EXISTS `appexoticshoes_pedido` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `fechaPedido` date NOT NULL,
  `usuario_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `appExoticShoes_pedid_usuario_id_4c709d32_fk_appExotic` (`usuario_id`),
  CONSTRAINT `appExoticShoes_pedid_usuario_id_4c709d32_fk_appExotic` FOREIGN KEY (`usuario_id`) REFERENCES `appexoticshoes_usuario` (`user_ptr_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla tiendaexoticshoes.appexoticshoes_pedido: ~0 rows (aproximadamente)

-- Volcando estructura para tabla tiendaexoticshoes.appexoticshoes_producto
CREATE TABLE IF NOT EXISTS `appexoticshoes_producto` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) COLLATE utf8mb3_spanish_ci NOT NULL,
  `descripcion` varchar(45) COLLATE utf8mb3_spanish_ci NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `existencias` int NOT NULL,
  `foto` varchar(100) COLLATE utf8mb3_spanish_ci DEFAULT NULL,
  `estado` tinyint(1) NOT NULL,
  `categoria_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `appExoticShoes_produ_categoria_id_00b87b98_fk_appExotic` (`categoria_id`),
  CONSTRAINT `appExoticShoes_produ_categoria_id_00b87b98_fk_appExotic` FOREIGN KEY (`categoria_id`) REFERENCES `appexoticshoes_categoria` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla tiendaexoticshoes.appexoticshoes_producto: ~3 rows (aproximadamente)
REPLACE INTO `appexoticshoes_producto` (`id`, `nombre`, `descripcion`, `precio`, `existencias`, `foto`, `estado`, `categoria_id`) VALUES
	(1, 'Nike', 'tenis Air Mag "Back to the Future"', 50000.00, 10, 'productos/tenis_gEsuSMG.jpg', 1, 1),
	(2, 'Martillo', 'martillo cafe', 15000.00, 10, 'productos/martillo_KvsFia6.jpg', 0, 2),
	(3, 'Martillo', 'martillo mango de madra', 15000.00, 8, 'productos/martillo_5jyF7DJ.jpg', 1, 2);

-- Volcando estructura para tabla tiendaexoticshoes.appexoticshoes_usuario
CREATE TABLE IF NOT EXISTS `appexoticshoes_usuario` (
  `user_ptr_id` int NOT NULL,
  `telefono` varchar(45) COLLATE utf8mb3_spanish_ci NOT NULL,
  `fechaNacimiento` date NOT NULL,
  `direccion` varchar(45) COLLATE utf8mb3_spanish_ci NOT NULL,
  PRIMARY KEY (`user_ptr_id`),
  CONSTRAINT `appExoticShoes_usuarios_user_ptr_id_7861db0c_fk_auth_user_id` FOREIGN KEY (`user_ptr_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla tiendaexoticshoes.appexoticshoes_usuario: ~8 rows (aproximadamente)
REPLACE INTO `appexoticshoes_usuario` (`user_ptr_id`, `telefono`, `fechaNacimiento`, `direccion`) VALUES
	(7, '1232321312r5', '2023-08-05', 'calle 1'),
	(8, '3547548754', '1998-09-02', 'calle 1 # 5-3'),
	(9, 'asdsadasdas', '1972-09-02', 'calle 1'),
	(10, '17895644', '1980-09-02', 'calle 5'),
	(11, '213423', '1979-09-21', 'calle 54'),
	(12, '123412312', '2023-08-31', 'sfdsadfsafsa');

-- Volcando estructura para tabla tiendaexoticshoes.authtoken_token
CREATE TABLE IF NOT EXISTS `authtoken_token` (
  `key` varchar(40) COLLATE utf8mb3_spanish_ci NOT NULL,
  `created` datetime(6) NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`key`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `authtoken_token_user_id_35299eff_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla tiendaexoticshoes.authtoken_token: ~0 rows (aproximadamente)
REPLACE INTO `authtoken_token` (`key`, `created`, `user_id`) VALUES
	('6298b3efa278aaa8fe065d41a7e50815d834c09c', '2023-09-03 00:40:52.636072', 7),
	('6aa8ee7214214e5666b50e99954fbdc4627b33dd', '2023-09-02 19:00:30.249257', 12),
	('a52378c5eff1a4c26c2e4e0a5d9486d94e70256a', '2023-09-02 00:18:40.858025', 1),
	('a8cb68eb796bb37aa95eb5793f3223896a7f148c', '2023-09-03 00:41:51.637983', 13),
	('bd2797c4ee208d05415a4ae469bf1309d93e574a', '2023-09-03 00:53:14.415423', 8);

-- Volcando estructura para tabla tiendaexoticshoes.auth_group
CREATE TABLE IF NOT EXISTS `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) COLLATE utf8mb3_spanish_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla tiendaexoticshoes.auth_group: ~2 rows (aproximadamente)
REPLACE INTO `auth_group` (`id`, `name`) VALUES
	(3, 'admin'),
	(2, 'cliente');

-- Volcando estructura para tabla tiendaexoticshoes.auth_group_permissions
CREATE TABLE IF NOT EXISTS `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla tiendaexoticshoes.auth_group_permissions: ~40 rows (aproximadamente)
REPLACE INTO `auth_group_permissions` (`id`, `group_id`, `permission_id`) VALUES
	(41, 3, 25),
	(42, 3, 26),
	(43, 3, 27),
	(44, 3, 28),
	(45, 3, 29),
	(46, 3, 30),
	(47, 3, 31),
	(48, 3, 32),
	(49, 3, 33),
	(50, 3, 34),
	(51, 3, 35),
	(52, 3, 36),
	(53, 3, 37),
	(54, 3, 38),
	(55, 3, 39),
	(56, 3, 40),
	(57, 3, 41),
	(58, 3, 42),
	(59, 3, 43),
	(60, 3, 44),
	(61, 3, 45),
	(62, 3, 46),
	(63, 3, 47),
	(64, 3, 48),
	(65, 3, 49),
	(66, 3, 50),
	(67, 3, 51),
	(68, 3, 52),
	(69, 3, 53),
	(70, 3, 54),
	(71, 3, 55),
	(72, 3, 56),
	(73, 3, 57),
	(74, 3, 58),
	(75, 3, 59),
	(76, 3, 60),
	(77, 3, 61),
	(78, 3, 62),
	(79, 3, 63),
	(80, 3, 64);

-- Volcando estructura para tabla tiendaexoticshoes.auth_permission
CREATE TABLE IF NOT EXISTS `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb3_spanish_ci NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) COLLATE utf8mb3_spanish_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla tiendaexoticshoes.auth_permission: ~64 rows (aproximadamente)
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
	(25, 'Can add pago', 7, 'add_pago'),
	(26, 'Can change pago', 7, 'change_pago'),
	(27, 'Can delete pago', 7, 'delete_pago'),
	(28, 'Can view pago', 7, 'view_pago'),
	(29, 'Can add envio', 8, 'add_envio'),
	(30, 'Can change envio', 8, 'change_envio'),
	(31, 'Can delete envio', 8, 'delete_envio'),
	(32, 'Can view envio', 8, 'view_envio'),
	(33, 'Can add detalle pedido', 9, 'add_detallepedido'),
	(34, 'Can change detalle pedido', 9, 'change_detallepedido'),
	(35, 'Can delete detalle pedido', 9, 'delete_detallepedido'),
	(36, 'Can view detalle pedido', 9, 'view_detallepedido'),
	(37, 'Can add cart', 10, 'add_cart'),
	(38, 'Can change cart', 10, 'change_cart'),
	(39, 'Can delete cart', 10, 'delete_cart'),
	(40, 'Can view cart', 10, 'view_cart'),
	(41, 'Can add cart item', 11, 'add_cartitem'),
	(42, 'Can change cart item', 11, 'change_cartitem'),
	(43, 'Can delete cart item', 11, 'delete_cartitem'),
	(44, 'Can view cart item', 11, 'view_cartitem'),
	(45, 'Can add categoria', 12, 'add_categoria'),
	(46, 'Can change categoria', 12, 'change_categoria'),
	(47, 'Can delete categoria', 12, 'delete_categoria'),
	(48, 'Can view categoria', 12, 'view_categoria'),
	(49, 'Can add producto', 13, 'add_producto'),
	(50, 'Can change producto', 13, 'change_producto'),
	(51, 'Can delete producto', 13, 'delete_producto'),
	(52, 'Can view producto', 13, 'view_producto'),
	(53, 'Can add user', 14, 'add_usuario'),
	(54, 'Can change user', 14, 'change_usuario'),
	(55, 'Can delete user', 14, 'delete_usuario'),
	(56, 'Can view user', 14, 'view_usuario'),
	(57, 'Can add devolucione', 15, 'add_devolucione'),
	(58, 'Can change devolucione', 15, 'change_devolucione'),
	(59, 'Can delete devolucione', 15, 'delete_devolucione'),
	(60, 'Can view devolucione', 15, 'view_devolucione'),
	(61, 'Can add pedido', 16, 'add_pedido'),
	(62, 'Can change pedido', 16, 'change_pedido'),
	(63, 'Can delete pedido', 16, 'delete_pedido'),
	(64, 'Can view pedido', 16, 'view_pedido'),
	(65, 'Can add Token', 17, 'add_token'),
	(66, 'Can change Token', 17, 'change_token'),
	(67, 'Can delete Token', 17, 'delete_token'),
	(68, 'Can view Token', 17, 'view_token'),
	(69, 'Can add token', 18, 'add_tokenproxy'),
	(70, 'Can change token', 18, 'change_tokenproxy'),
	(71, 'Can delete token', 18, 'delete_tokenproxy'),
	(72, 'Can view token', 18, 'view_tokenproxy');

-- Volcando estructura para tabla tiendaexoticshoes.auth_user
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
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla tiendaexoticshoes.auth_user: ~8 rows (aproximadamente)
REPLACE INTO `auth_user` (`id`, `password`, `last_login`, `is_superuser`, `username`, `first_name`, `last_name`, `email`, `is_staff`, `is_active`, `date_joined`) VALUES
	(1, 'pbkdf2_sha256$600000$0eIn9k8312poiXFyLjgVYi$JwVtYBpGjlZYKmktJkWOp6YGez05LpMErN5JoZ8A/8c=', '2023-09-02 21:28:37.119790', 1, 'admin', 'juan', 'herrera', 'dajun318@gmail.com', 1, 1, '2023-08-28 21:57:53.000000'),
	(7, 'pbkdf2_sha256$600000$OyzRgLAr0YRwWBapaHVAAG$7zmcOUgCyyxcg4oGLcnct4KOH0Z1fYDs7VtHZTZsf6w=', '2023-09-03 03:44:22.848068', 0, 'cliente2', 'nombre2', 'apellido2', 'correo2@mail.com', 0, 1, '2023-09-02 00:36:27.231772'),
	(8, 'pbkdf2_sha256$600000$l99Pp1CFIxK5sxpRcrq4JS$hgu5jaYoTQmXNcXRiVJ9jGmejAIOgFc+F8vrSCqMFAI=', '2023-09-03 03:54:00.950919', 0, 'cliente3', 'carlos', 'ramirez', '30414d63546c42626169@findtempmail.best', 0, 1, '2023-09-02 18:37:09.527378'),
	(9, 'pbkdf2_sha256$600000$jGa6IHpjwtpjlDy0sbRHf5$VwwRThEXnN3CVJEzeu9ZUO3ENiEtZgpEJDph/NPDf4Y=', NULL, 0, 'cliente4', 'luis', 'vieda', 'correo1@mail.com', 0, 1, '2023-09-02 18:38:40.829490'),
	(10, 'pbkdf2_sha256$600000$OI4iw4yF6Lzoz0gTIOBDKJ$aYBHJvwpyf7lupqVUywbYI20zXKfqPVB3c7wSbfq2bs=', NULL, 0, 'cliente5', 'andres', 'morales', 'correo5@mail.com', 0, 1, '2023-09-02 18:54:42.662291'),
	(11, 'pbkdf2_sha256$600000$yWGh8jc4gwXE1SnzSNauKs$2J1izNP2+7bBbzc2rtqRXnYivk6pfKT1EbdRq26CQco=', NULL, 0, 'admin6', 'Marlon', 'Puentes', '30414d63546c42626112@findtempmail.best', 0, 1, '2023-09-02 18:59:16.271612'),
	(12, 'pbkdf2_sha256$600000$1z7pSgw4IoWSAi7x2hFPlu$vle1/LIZeD+acQjDvfpgFI/Tq3KlCzRcdjI0OHyXlAE=', NULL, 0, 'admin7', 'esquizo', 'frenico', '30414d63546c426349@findtempmail.best', 0, 1, '2023-09-02 19:00:29.633637'),
	(13, 'pbkdf2_sha256$600000$md5t0AP61vqcVhGdhdnskQ$KK7aDlLOLmjvyCWhdQhOaGT5u3vnoPwTVpJTC7JjZeY=', '2023-09-03 00:41:51.633837', 0, 'admin2', 'Maira', 'Solano', 'dajun318@gmail.com', 0, 1, '2023-09-02 21:21:56.000000');

-- Volcando estructura para tabla tiendaexoticshoes.auth_user_groups
CREATE TABLE IF NOT EXISTS `auth_user_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla tiendaexoticshoes.auth_user_groups: ~8 rows (aproximadamente)
REPLACE INTO `auth_user_groups` (`id`, `user_id`, `group_id`) VALUES
	(2, 1, 3),
	(5, 7, 2),
	(6, 8, 2),
	(7, 9, 2),
	(8, 10, 2),
	(9, 11, 2),
	(10, 12, 2),
	(11, 13, 3);

-- Volcando estructura para tabla tiendaexoticshoes.auth_user_user_permissions
CREATE TABLE IF NOT EXISTS `auth_user_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla tiendaexoticshoes.auth_user_user_permissions: ~64 rows (aproximadamente)
REPLACE INTO `auth_user_user_permissions` (`id`, `user_id`, `permission_id`) VALUES
	(1, 1, 1),
	(2, 1, 2),
	(3, 1, 3),
	(4, 1, 4),
	(5, 1, 5),
	(6, 1, 6),
	(7, 1, 7),
	(8, 1, 8),
	(9, 1, 9),
	(10, 1, 10),
	(11, 1, 11),
	(12, 1, 12),
	(13, 1, 13),
	(14, 1, 14),
	(15, 1, 15),
	(16, 1, 16),
	(17, 1, 17),
	(18, 1, 18),
	(19, 1, 19),
	(20, 1, 20),
	(21, 1, 21),
	(22, 1, 22),
	(23, 1, 23),
	(24, 1, 24),
	(25, 1, 25),
	(26, 1, 26),
	(27, 1, 27),
	(28, 1, 28),
	(29, 1, 29),
	(30, 1, 30),
	(31, 1, 31),
	(32, 1, 32),
	(33, 1, 33),
	(34, 1, 34),
	(35, 1, 35),
	(36, 1, 36),
	(37, 1, 37),
	(38, 1, 38),
	(39, 1, 39),
	(40, 1, 40),
	(41, 1, 41),
	(42, 1, 42),
	(43, 1, 43),
	(44, 1, 44),
	(45, 1, 45),
	(46, 1, 46),
	(47, 1, 47),
	(48, 1, 48),
	(49, 1, 49),
	(50, 1, 50),
	(51, 1, 51),
	(52, 1, 52),
	(53, 1, 53),
	(54, 1, 54),
	(55, 1, 55),
	(56, 1, 56),
	(57, 1, 57),
	(58, 1, 58),
	(59, 1, 59),
	(60, 1, 60),
	(61, 1, 61),
	(62, 1, 62),
	(63, 1, 63),
	(64, 1, 64);

-- Volcando estructura para tabla tiendaexoticshoes.django_admin_log
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

-- Volcando datos para la tabla tiendaexoticshoes.django_admin_log: ~9 rows (aproximadamente)
REPLACE INTO `django_admin_log` (`id`, `action_time`, `object_id`, `object_repr`, `action_flag`, `change_message`, `content_type_id`, `user_id`) VALUES
	(1, '2023-08-30 00:54:14.660804', '1', 'Administrador', 1, '[{"added": {}}]', 3, 1),
	(2, '2023-08-30 00:54:45.235207', '2', 'cliente', 1, '[{"added": {}}]', 3, 1),
	(3, '2023-08-30 00:55:57.622424', '2', 'cr3ck', 1, '[{"added": {}}]', 14, 1),
	(4, '2023-09-01 02:01:02.472140', '1', 'admin', 2, '[{"changed": {"fields": ["First name", "Last name", "Groups", "User permissions"]}}]', 4, 1),
	(5, '2023-09-01 02:01:25.733880', '2', 'cr3ck', 2, '[{"changed": {"fields": ["First name", "Last name"]}}]', 4, 1),
	(6, '2023-09-01 02:01:48.725905', '1', 'Administrador', 3, '', 3, 1),
	(7, '2023-09-01 02:02:21.845862', '3', 'admin', 2, '[{"changed": {"fields": ["Permissions"]}}]', 3, 1),
	(8, '2023-09-01 03:01:49.616861', '3', 'admin2', 3, '', 4, 1),
	(9, '2023-09-01 03:02:18.617418', '5', 'admin4', 3, '', 4, 1),
	(10, '2023-09-01 03:02:24.151198', '4', 'admin5', 3, '', 4, 1),
	(11, '2023-09-02 00:27:46.658986', '6', 'cliente1', 1, '[{"added": {}}]', 14, 1),
	(12, '2023-09-02 21:21:56.636861', '13', 'admin2', 1, '[{"added": {}}]', 4, 1),
	(13, '2023-09-02 21:22:42.560810', '13', 'admin2', 2, '[{"changed": {"fields": ["First name", "Last name", "Email address", "Groups"]}}]', 4, 1);

-- Volcando estructura para tabla tiendaexoticshoes.django_content_type
CREATE TABLE IF NOT EXISTS `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) COLLATE utf8mb3_spanish_ci NOT NULL,
  `model` varchar(100) COLLATE utf8mb3_spanish_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla tiendaexoticshoes.django_content_type: ~16 rows (aproximadamente)
REPLACE INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
	(1, 'admin', 'logentry'),
	(10, 'appExoticShoes', 'cart'),
	(11, 'appExoticShoes', 'cartitem'),
	(12, 'appExoticShoes', 'categoria'),
	(9, 'appExoticShoes', 'detallepedido'),
	(15, 'appExoticShoes', 'devolucione'),
	(8, 'appExoticShoes', 'envio'),
	(7, 'appExoticShoes', 'pago'),
	(16, 'appExoticShoes', 'pedido'),
	(13, 'appExoticShoes', 'producto'),
	(14, 'appExoticShoes', 'usuario'),
	(3, 'auth', 'group'),
	(2, 'auth', 'permission'),
	(4, 'auth', 'user'),
	(17, 'authtoken', 'token'),
	(18, 'authtoken', 'tokenproxy'),
	(5, 'contenttypes', 'contenttype'),
	(6, 'sessions', 'session');

-- Volcando estructura para tabla tiendaexoticshoes.django_migrations
CREATE TABLE IF NOT EXISTS `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) COLLATE utf8mb3_spanish_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb3_spanish_ci NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla tiendaexoticshoes.django_migrations: ~30 rows (aproximadamente)
REPLACE INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
	(1, 'contenttypes', '0001_initial', '2023-08-28 21:56:31.312103'),
	(2, 'auth', '0001_initial', '2023-08-28 21:56:31.966158'),
	(3, 'admin', '0001_initial', '2023-08-28 21:56:32.148960'),
	(4, 'admin', '0002_logentry_remove_auto_add', '2023-08-28 21:56:32.163954'),
	(5, 'admin', '0003_logentry_add_action_flag_choices', '2023-08-28 21:56:32.174944'),
	(6, 'contenttypes', '0002_remove_content_type_name', '2023-08-28 21:56:32.324362'),
	(7, 'auth', '0002_alter_permission_name_max_length', '2023-08-28 21:56:32.436321'),
	(8, 'auth', '0003_alter_user_email_max_length', '2023-08-28 21:56:32.546610'),
	(9, 'auth', '0004_alter_user_username_opts', '2023-08-28 21:56:32.559981'),
	(10, 'auth', '0005_alter_user_last_login_null', '2023-08-28 21:56:32.657114'),
	(11, 'auth', '0006_require_contenttypes_0002', '2023-08-28 21:56:32.662355'),
	(12, 'auth', '0007_alter_validators_add_error_messages', '2023-08-28 21:56:32.674070'),
	(13, 'auth', '0008_alter_user_username_max_length', '2023-08-28 21:56:32.770440'),
	(14, 'auth', '0009_alter_user_last_name_max_length', '2023-08-28 21:56:32.863444'),
	(15, 'auth', '0010_alter_group_name_max_length', '2023-08-28 21:56:32.957312'),
	(16, 'auth', '0011_update_proxy_permissions', '2023-08-28 21:56:32.968460'),
	(17, 'auth', '0012_alter_user_first_name_max_length', '2023-08-28 21:56:33.093892'),
	(18, 'appExoticShoes', '0001_initial', '2023-08-28 21:56:33.995560'),
	(19, 'appExoticShoes', '0002_usuarios_grupos', '2023-08-28 21:56:34.172449'),
	(20, 'appExoticShoes', '0003_alter_productos_estado_alter_productos_precio', '2023-08-28 21:56:34.275388'),
	(21, 'appExoticShoes', '0004_itemcarrito', '2023-08-28 21:56:34.496250'),
	(22, 'appExoticShoes', '0005_itemcarrito_subtotal_itemcarrito_total_precio', '2023-08-28 21:56:34.591197'),
	(23, 'appExoticShoes', '0006_alter_pedidos_options_alter_pedidos_unique_together', '2023-08-28 21:56:34.653160'),
	(24, 'appExoticShoes', '0007_alter_pedidos_options_alter_pedidos_unique_together', '2023-08-28 21:56:34.739750'),
	(25, 'appExoticShoes', '0008_remove_usuarios_grupos', '2023-08-28 21:56:34.775729'),
	(26, 'appExoticShoes', '0009_cart_cartitem_delete_itemcarrito_cart_products_and_more', '2023-08-28 21:56:35.121515'),
	(27, 'appExoticShoes', '0010_alter_productos_categoria', '2023-08-28 21:56:35.144500'),
	(28, 'appExoticShoes', '0011_rename_categorias_categoria_and_more', '2023-08-28 21:56:35.769807'),
	(29, 'appExoticShoes', '0012_rename_devoluciones_devolucione_and_more', '2023-08-28 21:56:36.223310'),
	(30, 'sessions', '0001_initial', '2023-08-28 21:56:36.276278'),
	(31, 'appExoticShoes', '0013_alter_cart_user_alter_cartitem_cart_and_more', '2023-08-31 02:18:19.826061'),
	(32, 'authtoken', '0001_initial', '2023-09-01 21:06:18.711349'),
	(33, 'authtoken', '0002_auto_20160226_1747', '2023-09-01 21:06:18.763916'),
	(34, 'authtoken', '0003_tokenproxy', '2023-09-01 21:06:18.770910'),
	(35, 'appExoticShoes', '0014_rename_cantidadeninventario_producto_existencias_and_more', '2023-09-02 19:24:03.217864');

-- Volcando estructura para tabla tiendaexoticshoes.django_session
CREATE TABLE IF NOT EXISTS `django_session` (
  `session_key` varchar(40) COLLATE utf8mb3_spanish_ci NOT NULL,
  `session_data` longtext COLLATE utf8mb3_spanish_ci NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla tiendaexoticshoes.django_session: ~1 rows (aproximadamente)
REPLACE INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
	('11ah2x0yy6lb2lmbdg5lqs9vypyrv0il', '.eJxVjMsOwiAQRf-FtSE82gIu3fsNhGFmpGogKe3K-O_apAvd3nPOfYmYtrXErdMSZxRn4cXpd4OUH1R3gPdUb03mVtdlBrkr8qBdXhvS83K4fwcl9fKtA46OCUgFZusNZ2fdyJR58EgOlQ3GWATQNsGUJ63As8aBFbAnG4J4fwARcjjf:1qcd6i:9PO35-m23a1pThUQHd_6ESfbxmqnLE3jMYlk4MgkdHM', '2023-09-03 03:15:00.543889'),
	('1qcx86xlwsookizuqinqkwhdinob5l93', '.eJxVjMsOwiAQRf-FtSE82gIu3fsNhGFmpGogKe3K-O_apAvd3nPOfYmYtrXErdMSZxRn4cXpd4OUH1R3gPdUb03mVtdlBrkr8qBdXhvS83K4fwcl9fKtA46OCUgFZusNZ2fdyJR58EgOlQ3GWATQNsGUJ63As8aBFbAnG4J4fwARcjjf:1qcd73:2yYtpZWVlDEBV3PBOqe_rMYaEH91Ojs6GKU6-nqo3rc', '2023-09-03 03:15:21.402215'),
	('77vdwztz8jw5tpxzrd7e5nibnzrjjlcp', '.eJxVjMsOwiAQRf-FtSE82gIu3fsNhGFmpGogKe3K-O_apAvd3nPOfYmYtrXErdMSZxRn4cXpd4OUH1R3gPdUb03mVtdlBrkr8qBdXhvS83K4fwcl9fKtA46OCUgFZusNZ2fdyJR58EgOlQ3GWATQNsGUJ63As8aBFbAnG4J4fwARcjjf:1qcdEY:wa8-tUuBzLHTXH7Fx_eyQ1hyu48xiZY-sVZ8rDnzf8o', '2023-09-03 03:23:06.213952'),
	('7yae41zwtwmuotxviqo5vthtdadwqt1l', '.eJxVjMsOwiAQRf-FtSE82gIu3fsNhGFmpGogKe3K-O_apAvd3nPOfYmYtrXErdMSZxRn4cXpd4OUH1R3gPdUb03mVtdlBrkr8qBdXhvS83K4fwcl9fKtA46OCUgFZusNZ2fdyJR58EgOlQ3GWATQNsGUJ63As8aBFbAnG4J4fwARcjjf:1qcd2v:3_yn7YVF3hwKhAOqGDko-jtZSx6phNOYey3NClEUbKc', '2023-09-03 03:11:05.480550'),
	('em1dagwg2blx8erzgvn2jy6gkbx8ih0o', '.eJxVjMsOwiAQRf-FtSE82gIu3fsNhGFmpGogKe3K-O_apAvd3nPOfYmYtrXErdMSZxRn4cXpd4OUH1R3gPdUb03mVtdlBrkr8qBdXhvS83K4fwcl9fKtA46OCUgFZusNZ2fdyJR58EgOlQ3GWATQNsGUJ63As8aBFbAnG4J4fwARcjjf:1qccz2:t71H55PKABpSxoAEV6a-M6DUboatR2jnC85__TMZprw', '2023-09-03 03:07:04.786831'),
	('nua5z5wifd5iwihnvu1eq53h9idqp15w', '.eJxVjMsOwiAQRf-FtSE82gIu3fsNhGFmpGogKe3K-O_apAvd3nPOfYmYtrXErdMSZxRn4cXpd4OUH1R3gPdUb03mVtdlBrkr8qBdXhvS83K4fwcl9fKtA46OCUgFZusNZ2fdyJR58EgOlQ3GWATQNsGUJ63As8aBFbAnG4J4fwARcjjf:1qceBU:NUmmANVYSrNsTNnoKV2AbiOsYPmK5W6Yp83Ebm36pdM', '2023-09-03 04:24:00.956914'),
	('pqip980cskz9wy17rjtt4vlej3dk3pij', '.eJxVjMsOwiAQRf-FtSE82gIu3fsNhGFmpGogKe3K-O_apAvd3nPOfYmYtrXErdMSZxRn4cXpd4OUH1R3gPdUb03mVtdlBrkr8qBdXhvS83K4fwcl9fKtA46OCUgFZusNZ2fdyJR58EgOlQ3GWATQNsGUJ63As8aBFbAnG4J4fwARcjjf:1qcd1W:Jf6XgmmngfxXih_CFTF3FDQZV9SZLCsR1lt1r1nKWCI', '2023-09-03 03:09:38.761369'),
	('puqi2aby1059weux6yi9cykl5oq7ebpn', '.eJxVjMsOwiAQRf-FtSE82gIu3fsNhGFmpGogKe3K-O_apAvd3nPOfYmYtrXErdMSZxRn4cXpd4OUH1R3gPdUb03mVtdlBrkr8qBdXhvS83K4fwcl9fKtA46OCUgFZusNZ2fdyJR58EgOlQ3GWATQNsGUJ63As8aBFbAnG4J4fwARcjjf:1qccrJ:8AsKWXZz1vYETowweL88IUGQlcQ2Ge1GnqQFndjbYds', '2023-09-03 02:59:05.089385'),
	('qx1g9zrbira89cflmeo3xe51o6auwb8j', '.eJxVjMsOwiAQRf-FtSFAKQ-X7v0GMp1hpGogKe3K-O_apAvd3nPOfYkE21rS1vOSZhJnocXpd5sAH7nugO5Qb01iq-syT3JX5EG7vDbKz8vh_h0U6OVbB_JkFFrr9AABbDBRW8eOPWBEIvKRclbMyOM4eA0ATpEh9qyVM5N4fwDusjiV:1qbtmC:98YPEu1sagyLr3_Cb8i6LGK40f6zZcB_wHeN8bOooOU', '2023-09-15 02:20:48.858327'),
	('rklqpn8v0pv5sfk1pu876l3c00u14yss', '.eJxVjMsOwiAQRf-FtSE82gIu3fsNhGFmpGogKe3K-O_apAvd3nPOfYmYtrXErdMSZxRn4cXpd4OUH1R3gPdUb03mVtdlBrkr8qBdXhvS83K4fwcl9fKtA46OCUgFZusNZ2fdyJR58EgOlQ3GWATQNsGUJ63As8aBFbAnG4J4fwARcjjf:1qccxi:2AsryzJ_LD_01rpqtcahawopx-TDjB7NYck4g7WBbSg', '2023-09-03 03:05:42.048530'),
	('vulqd9or3os46yq4k5wrsiqnzooo7ynf', '.eJxVjMsOwiAQRf-FtSE82gIu3fsNhGFmpGogKe3K-O_apAvd3nPOfYmYtrXErdMSZxRn4cXpd4OUH1R3gPdUb03mVtdlBrkr8qBdXhvS83K4fwcl9fKtA46OCUgFZusNZ2fdyJR58EgOlQ3GWATQNsGUJ63As8aBFbAnG4J4fwARcjjf:1qcbz4:Ba91uHJGr1wbRwweV8Y6KEbW71HdvAR1rJSYLWaJV0U', '2023-09-03 02:03:02.310037'),
	('xk4p7a95mf9u4roh6ti2na60x4uy0505', '.eJxVjMsOwiAQRf-FtSE82gIu3fsNhGFmpGogKe3K-O_apAvd3nPOfYmYtrXErdMSZxRn4cXpd4OUH1R3gPdUb03mVtdlBrkr8qBdXhvS83K4fwcl9fKtA46OCUgFZusNZ2fdyJR58EgOlQ3GWATQNsGUJ63As8aBFbAnG4J4fwARcjjf:1qccyt:dkcQALE5SBY8OwTamDH9Lbps0R_lQ0csuzitZRY7MGI', '2023-09-03 03:06:55.731829');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
