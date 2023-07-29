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

-- Volcando estructura para tabla tiendaexoticshoes.appexoticshoes_categorias
CREATE TABLE IF NOT EXISTS `appexoticshoes_categorias` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) COLLATE utf8mb3_spanish_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla tiendaexoticshoes.appexoticshoes_categorias: ~0 rows (aproximadamente)
INSERT IGNORE INTO `appexoticshoes_categorias` (`id`, `nombre`) VALUES
	(3, 'Accesorios'),
	(2, 'Blusas'),
	(4, 'Lociones'),
	(1, 'Tenis');

-- Volcando estructura para tabla tiendaexoticshoes.appexoticshoes_detallepedido
CREATE TABLE IF NOT EXISTS `appexoticshoes_detallepedido` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `cantidad` int NOT NULL,
  `subtotal` double NOT NULL,
  `pedido_id` bigint NOT NULL,
  `producto_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `appExoticShoes_detal_pedido_id_8c7306f0_fk_appExotic` (`pedido_id`),
  KEY `appExoticShoes_detal_producto_id_29dfa03e_fk_appExotic` (`producto_id`),
  CONSTRAINT `appExoticShoes_detal_pedido_id_8c7306f0_fk_appExotic` FOREIGN KEY (`pedido_id`) REFERENCES `appexoticshoes_pedidos` (`id`),
  CONSTRAINT `appExoticShoes_detal_producto_id_29dfa03e_fk_appExotic` FOREIGN KEY (`producto_id`) REFERENCES `appexoticshoes_productos` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla tiendaexoticshoes.appexoticshoes_detallepedido: ~0 rows (aproximadamente)

-- Volcando estructura para tabla tiendaexoticshoes.appexoticshoes_devoluciones
CREATE TABLE IF NOT EXISTS `appexoticshoes_devoluciones` (
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

-- Volcando datos para la tabla tiendaexoticshoes.appexoticshoes_devoluciones: ~0 rows (aproximadamente)

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

-- Volcando estructura para tabla tiendaexoticshoes.appexoticshoes_itemcarrito
CREATE TABLE IF NOT EXISTS `appexoticshoes_itemcarrito` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `cantidad` int unsigned NOT NULL,
  `producto_id` bigint NOT NULL,
  `usuario_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `appExoticShoes_itemc_producto_id_94307026_fk_appExotic` (`producto_id`),
  KEY `appExoticShoes_itemc_usuario_id_ce8323bc_fk_appExotic` (`usuario_id`),
  CONSTRAINT `appExoticShoes_itemc_producto_id_94307026_fk_appExotic` FOREIGN KEY (`producto_id`) REFERENCES `appexoticshoes_productos` (`id`),
  CONSTRAINT `appExoticShoes_itemc_usuario_id_ce8323bc_fk_appExotic` FOREIGN KEY (`usuario_id`) REFERENCES `appexoticshoes_usuarios` (`user_ptr_id`),
  CONSTRAINT `appexoticshoes_itemcarrito_chk_1` CHECK ((`cantidad` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla tiendaexoticshoes.appexoticshoes_itemcarrito: ~0 rows (aproximadamente)

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
  CONSTRAINT `appExoticShoes_pago_pedidos_id_18f1d6da_fk_appExotic` FOREIGN KEY (`pedidos_id`) REFERENCES `appexoticshoes_pedidos` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla tiendaexoticshoes.appexoticshoes_pago: ~0 rows (aproximadamente)

-- Volcando estructura para tabla tiendaexoticshoes.appexoticshoes_pedidos
CREATE TABLE IF NOT EXISTS `appexoticshoes_pedidos` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `fechaPedido` date NOT NULL,
  `usuario_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `appExoticShoes_pedid_usuario_id_4c709d32_fk_appExotic` (`usuario_id`),
  CONSTRAINT `appExoticShoes_pedid_usuario_id_4c709d32_fk_appExotic` FOREIGN KEY (`usuario_id`) REFERENCES `appexoticshoes_usuarios` (`user_ptr_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla tiendaexoticshoes.appexoticshoes_pedidos: ~0 rows (aproximadamente)

-- Volcando estructura para tabla tiendaexoticshoes.appexoticshoes_productos
CREATE TABLE IF NOT EXISTS `appexoticshoes_productos` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) COLLATE utf8mb3_spanish_ci NOT NULL,
  `descripcion` varchar(45) COLLATE utf8mb3_spanish_ci NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `cantidadEnInventario` int NOT NULL,
  `foto` varchar(100) COLLATE utf8mb3_spanish_ci DEFAULT NULL,
  `estado` tinyint(1) NOT NULL,
  `categoria_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `appExoticShoes_produ_categoria_id_00b87b98_fk_appExotic` (`categoria_id`),
  CONSTRAINT `appExoticShoes_produ_categoria_id_00b87b98_fk_appExotic` FOREIGN KEY (`categoria_id`) REFERENCES `appexoticshoes_categorias` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla tiendaexoticshoes.appexoticshoes_productos: ~0 rows (aproximadamente)
INSERT IGNORE INTO `appexoticshoes_productos` (`id`, `nombre`, `descripcion`, `precio`, `cantidadEnInventario`, `foto`, `estado`, `categoria_id`) VALUES
	(1, 'Nike', 'tenis Air Mag "Back to the Future"', 264000.00, 10, 'productos/tenis.jpg', 1, 1),
	(2, 'SKECHERS', 'Tenis Skechers Hombre Moda Summits', 244990.00, 15, 'productos/tenis.jpg', 0, 1),
	(3, 'adidas', 'Adidas Skateboarding', 560000.00, 8, 'productos/tenis2.jpeg', 1, 1),
	(4, 'VIP212', 'Locion Para dama', 150000.00, 5, 'productos/locion.jpeg', 1, 4),
	(5, 'Blusa TShirt', 'blusa negra talla', 40000.00, 10, 'productos/blusa.jpg', 1, 2);

-- Volcando estructura para tabla tiendaexoticshoes.appexoticshoes_usuarios
CREATE TABLE IF NOT EXISTS `appexoticshoes_usuarios` (
  `user_ptr_id` int NOT NULL,
  `telefono` varchar(45) COLLATE utf8mb3_spanish_ci NOT NULL,
  `FechaNacimiento` date NOT NULL,
  `direccion` varchar(45) COLLATE utf8mb3_spanish_ci NOT NULL,
  PRIMARY KEY (`user_ptr_id`),
  CONSTRAINT `appExoticShoes_usuarios_user_ptr_id_7861db0c_fk_auth_user_id` FOREIGN KEY (`user_ptr_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla tiendaexoticshoes.appexoticshoes_usuarios: ~0 rows (aproximadamente)
INSERT IGNORE INTO `appexoticshoes_usuarios` (`user_ptr_id`, `telefono`, `FechaNacimiento`, `direccion`) VALUES
	(2, '3172917178', '1998-03-18', 'Carrera 9'),
	(3, '3172917178', '1998-03-18', 'Carrera 9');

-- Volcando estructura para tabla tiendaexoticshoes.appexoticshoes_usuarios_grupos
CREATE TABLE IF NOT EXISTS `appexoticshoes_usuarios_grupos` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `usuarios_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `appExoticShoes_usuarios__usuarios_id_group_id_d4652439_uniq` (`usuarios_id`,`group_id`),
  KEY `appExoticShoes_usuar_group_id_1191b4ab_fk_auth_grou` (`group_id`),
  CONSTRAINT `appExoticShoes_usuar_group_id_1191b4ab_fk_auth_grou` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `appExoticShoes_usuar_usuarios_id_ec589e3b_fk_appExotic` FOREIGN KEY (`usuarios_id`) REFERENCES `appexoticshoes_usuarios` (`user_ptr_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla tiendaexoticshoes.appexoticshoes_usuarios_grupos: ~0 rows (aproximadamente)
INSERT IGNORE INTO `appexoticshoes_usuarios_grupos` (`id`, `usuarios_id`, `group_id`) VALUES
	(1, 2, 2),
	(2, 3, 1);

-- Volcando estructura para tabla tiendaexoticshoes.auth_group
CREATE TABLE IF NOT EXISTS `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) COLLATE utf8mb3_spanish_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla tiendaexoticshoes.auth_group: ~0 rows (aproximadamente)
INSERT IGNORE INTO `auth_group` (`id`, `name`) VALUES
	(1, 'Administrador'),
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
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla tiendaexoticshoes.auth_group_permissions: ~0 rows (aproximadamente)
INSERT IGNORE INTO `auth_group_permissions` (`id`, `group_id`, `permission_id`) VALUES
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
	(37, 2, 57),
	(38, 2, 58),
	(39, 2, 59),
	(40, 2, 60);

-- Volcando estructura para tabla tiendaexoticshoes.auth_permission
CREATE TABLE IF NOT EXISTS `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb3_spanish_ci NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) COLLATE utf8mb3_spanish_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla tiendaexoticshoes.auth_permission: ~60 rows (aproximadamente)
INSERT IGNORE INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
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
	(25, 'Can add categorias', 7, 'add_categorias'),
	(26, 'Can change categorias', 7, 'change_categorias'),
	(27, 'Can delete categorias', 7, 'delete_categorias'),
	(28, 'Can view categorias', 7, 'view_categorias'),
	(29, 'Can add user', 8, 'add_usuarios'),
	(30, 'Can change user', 8, 'change_usuarios'),
	(31, 'Can delete user', 8, 'delete_usuarios'),
	(32, 'Can view user', 8, 'view_usuarios'),
	(33, 'Can add productos', 9, 'add_productos'),
	(34, 'Can change productos', 9, 'change_productos'),
	(35, 'Can delete productos', 9, 'delete_productos'),
	(36, 'Can view productos', 9, 'view_productos'),
	(37, 'Can add pedidos', 10, 'add_pedidos'),
	(38, 'Can change pedidos', 10, 'change_pedidos'),
	(39, 'Can delete pedidos', 10, 'delete_pedidos'),
	(40, 'Can view pedidos', 10, 'view_pedidos'),
	(41, 'Can add pago', 11, 'add_pago'),
	(42, 'Can change pago', 11, 'change_pago'),
	(43, 'Can delete pago', 11, 'delete_pago'),
	(44, 'Can view pago', 11, 'view_pago'),
	(45, 'Can add envio', 12, 'add_envio'),
	(46, 'Can change envio', 12, 'change_envio'),
	(47, 'Can delete envio', 12, 'delete_envio'),
	(48, 'Can view envio', 12, 'view_envio'),
	(49, 'Can add devoluciones', 13, 'add_devoluciones'),
	(50, 'Can change devoluciones', 13, 'change_devoluciones'),
	(51, 'Can delete devoluciones', 13, 'delete_devoluciones'),
	(52, 'Can view devoluciones', 13, 'view_devoluciones'),
	(53, 'Can add detalle pedido', 14, 'add_detallepedido'),
	(54, 'Can change detalle pedido', 14, 'change_detallepedido'),
	(55, 'Can delete detalle pedido', 14, 'delete_detallepedido'),
	(56, 'Can view detalle pedido', 14, 'view_detallepedido'),
	(57, 'Can add item carrito', 15, 'add_itemcarrito'),
	(58, 'Can change item carrito', 15, 'change_itemcarrito'),
	(59, 'Can delete item carrito', 15, 'delete_itemcarrito'),
	(60, 'Can view item carrito', 15, 'view_itemcarrito');

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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla tiendaexoticshoes.auth_user: ~0 rows (aproximadamente)
INSERT IGNORE INTO `auth_user` (`id`, `password`, `last_login`, `is_superuser`, `username`, `first_name`, `last_name`, `email`, `is_staff`, `is_active`, `date_joined`) VALUES
	(1, 'pbkdf2_sha256$600000$j6vdn897Mwqp23Xbe0IGZu$S8UGu03lxyAWxo0T3GrkodvHBak+RihPxb5bPTMW8d4=', '2023-07-29 18:09:42.987629', 1, 'admin', 'Juan David', 'Chimbaco Herrera', 'dajun318@gmail.com', 1, 1, '2023-07-22 21:48:31.000000'),
	(2, '1234', NULL, 0, 'user', 'Juan David', 'Chimbaco Herrera', 'dajun318@gmail.com', 0, 1, '2023-07-27 23:37:58.000000'),
	(3, '1234', NULL, 1, 'admin2', 'Juan David', 'Chimbaco Herrera', 'dajun318@gmail.com', 1, 1, '2023-07-28 23:51:33.000000');

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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla tiendaexoticshoes.auth_user_groups: ~0 rows (aproximadamente)
INSERT IGNORE INTO `auth_user_groups` (`id`, `user_id`, `group_id`) VALUES
	(2, 1, 1),
	(1, 2, 2),
	(3, 3, 1);

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
) ENGINE=InnoDB AUTO_INCREMENT=97 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla tiendaexoticshoes.auth_user_user_permissions: ~0 rows (aproximadamente)
INSERT IGNORE INTO `auth_user_user_permissions` (`id`, `user_id`, `permission_id`) VALUES
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
	(37, 3, 1),
	(38, 3, 2),
	(39, 3, 3),
	(40, 3, 4),
	(41, 3, 5),
	(42, 3, 6),
	(43, 3, 7),
	(44, 3, 8),
	(45, 3, 9),
	(46, 3, 10),
	(47, 3, 11),
	(48, 3, 12),
	(49, 3, 13),
	(50, 3, 14),
	(51, 3, 15),
	(52, 3, 16),
	(53, 3, 17),
	(54, 3, 18),
	(55, 3, 19),
	(56, 3, 20),
	(57, 3, 21),
	(58, 3, 22),
	(59, 3, 23),
	(60, 3, 24),
	(61, 3, 25),
	(62, 3, 26),
	(63, 3, 27),
	(64, 3, 28),
	(65, 3, 29),
	(66, 3, 30),
	(67, 3, 31),
	(68, 3, 32),
	(69, 3, 33),
	(70, 3, 34),
	(71, 3, 35),
	(72, 3, 36),
	(73, 3, 37),
	(74, 3, 38),
	(75, 3, 39),
	(76, 3, 40),
	(77, 3, 41),
	(78, 3, 42),
	(79, 3, 43),
	(80, 3, 44),
	(81, 3, 45),
	(82, 3, 46),
	(83, 3, 47),
	(84, 3, 48),
	(85, 3, 49),
	(86, 3, 50),
	(87, 3, 51),
	(88, 3, 52),
	(89, 3, 53),
	(90, 3, 54),
	(91, 3, 55),
	(92, 3, 56),
	(93, 3, 57),
	(94, 3, 58),
	(95, 3, 59),
	(96, 3, 60);

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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla tiendaexoticshoes.django_admin_log: ~0 rows (aproximadamente)
INSERT IGNORE INTO `django_admin_log` (`id`, `action_time`, `object_id`, `object_repr`, `action_flag`, `change_message`, `content_type_id`, `user_id`) VALUES
	(1, '2023-07-28 23:39:03.177317', '1', 'Administrador', 1, '[{"added": {}}]', 3, 1),
	(2, '2023-07-28 23:39:33.566821', '2', 'cliente', 1, '[{"added": {}}]', 3, 1),
	(3, '2023-07-28 23:49:29.238164', '1', 'admin', 2, '[{"changed": {"fields": ["First name", "Last name", "Groups", "User permissions"]}}]', 4, 1),
	(4, '2023-07-28 23:51:21.869944', '2', 'user', 2, '[{"changed": {"fields": ["Email address", "Grupos"]}}]', 8, 1),
	(5, '2023-07-28 23:52:42.234094', '3', 'admin2', 1, '[{"added": {}}]', 8, 1);

-- Volcando estructura para tabla tiendaexoticshoes.django_content_type
CREATE TABLE IF NOT EXISTS `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) COLLATE utf8mb3_spanish_ci NOT NULL,
  `model` varchar(100) COLLATE utf8mb3_spanish_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla tiendaexoticshoes.django_content_type: ~15 rows (aproximadamente)
INSERT IGNORE INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
	(1, 'admin', 'logentry'),
	(7, 'appExoticShoes', 'categorias'),
	(14, 'appExoticShoes', 'detallepedido'),
	(13, 'appExoticShoes', 'devoluciones'),
	(12, 'appExoticShoes', 'envio'),
	(15, 'appExoticShoes', 'itemcarrito'),
	(11, 'appExoticShoes', 'pago'),
	(10, 'appExoticShoes', 'pedidos'),
	(9, 'appExoticShoes', 'productos'),
	(8, 'appExoticShoes', 'usuarios'),
	(3, 'auth', 'group'),
	(2, 'auth', 'permission'),
	(4, 'auth', 'user'),
	(5, 'contenttypes', 'contenttype'),
	(6, 'sessions', 'session');

-- Volcando estructura para tabla tiendaexoticshoes.django_migrations
CREATE TABLE IF NOT EXISTS `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) COLLATE utf8mb3_spanish_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb3_spanish_ci NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla tiendaexoticshoes.django_migrations: ~22 rows (aproximadamente)
INSERT IGNORE INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
	(1, 'contenttypes', '0001_initial', '2023-07-28 22:41:01.254770'),
	(2, 'auth', '0001_initial', '2023-07-28 22:41:01.955902'),
	(3, 'admin', '0001_initial', '2023-07-28 22:41:02.125174'),
	(4, 'admin', '0002_logentry_remove_auto_add', '2023-07-28 22:41:02.140166'),
	(5, 'admin', '0003_logentry_add_action_flag_choices', '2023-07-28 22:41:02.155155'),
	(6, 'contenttypes', '0002_remove_content_type_name', '2023-07-28 22:41:02.298068'),
	(7, 'auth', '0002_alter_permission_name_max_length', '2023-07-28 22:41:02.442977'),
	(8, 'auth', '0003_alter_user_email_max_length', '2023-07-28 22:41:02.561903'),
	(9, 'auth', '0004_alter_user_username_opts', '2023-07-28 22:41:02.577895'),
	(10, 'auth', '0005_alter_user_last_login_null', '2023-07-28 22:41:02.681832'),
	(11, 'auth', '0006_require_contenttypes_0002', '2023-07-28 22:41:02.694824'),
	(12, 'auth', '0007_alter_validators_add_error_messages', '2023-07-28 22:41:02.713810'),
	(13, 'auth', '0008_alter_user_username_max_length', '2023-07-28 22:41:02.827741'),
	(14, 'auth', '0009_alter_user_last_name_max_length', '2023-07-28 22:41:02.937672'),
	(15, 'auth', '0010_alter_group_name_max_length', '2023-07-28 22:41:03.049607'),
	(16, 'auth', '0011_update_proxy_permissions', '2023-07-28 22:41:03.090584'),
	(17, 'auth', '0012_alter_user_first_name_max_length', '2023-07-28 22:41:03.200510'),
	(18, 'appExoticShoes', '0001_initial', '2023-07-28 22:41:03.935480'),
	(19, 'appExoticShoes', '0002_usuarios_grupos', '2023-07-28 22:41:04.127359'),
	(20, 'appExoticShoes', '0003_alter_productos_estado_alter_productos_precio', '2023-07-28 22:41:04.218687'),
	(21, 'appExoticShoes', '0004_itemcarrito', '2023-07-28 22:41:04.396018'),
	(22, 'sessions', '0001_initial', '2023-07-28 22:41:04.455527');

-- Volcando estructura para tabla tiendaexoticshoes.django_session
CREATE TABLE IF NOT EXISTS `django_session` (
  `session_key` varchar(40) COLLATE utf8mb3_spanish_ci NOT NULL,
  `session_data` longtext COLLATE utf8mb3_spanish_ci NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_spanish_ci;

-- Volcando datos para la tabla tiendaexoticshoes.django_session: ~0 rows (aproximadamente)
INSERT IGNORE INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
	('avhov3okgqsu6uekq1zf1q3gd7yb99bt', '.eJxVjMsOwiAURH9FWRvCow9x6Vr_wIRc4NKiFZJSEhPjv0uTLnQzizkz5000lGXUJeOsgyMnwsnhtzNgHxhX4O4Qh0RtisscDF0ndKOZXpPD6bxt_wQj5LG-jeo8eCFa0fS9b5lkQjhADkevOomdckJKb2vRMOMFd41E4Nyi8EpJ8FU6pSFEnYu1mLN-1oABq_pWGAN-WekOX2FJOe3J5wvB0EjP:1qPWml:1QbMLbzw7LM8bsUk0KNG7dbseRm-ITI2xjqD3OdiPeY', '2023-08-11 23:22:15.552635'),
	('k74g6j2jza1jh3x4faeoh8csywwkos6c', '.eJxVjMsOwiAURH9FWRvCow9x6Vr_wIRc4NKiFZJSEhPjv0uTLnQzizkz5000lGXUJeOsgyMnwsnhtzNgHxhX4O4Qh0RtisscDF0ndKOZXpPD6bxt_wQj5LG-jeo8eCFa0fS9b5lkQjhADkevOomdckJKb2vRMOMFd41E4Nyi8EpJ8FU6pSFEnYu1mLN-1oABq_pWGAN-WekOX2FJOe3J5wvB0EjP:1qPoNq:xQN2wOM-DspkaN7sina6acxDwK9__K8Fm96382eh-5c', '2023-08-12 18:09:42.990622');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
