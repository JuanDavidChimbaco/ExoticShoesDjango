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

-- Volcando datos para la tabla tiendaexoticshoes.appexoticshoes_categorias: ~3 rows (aproximadamente)
INSERT IGNORE INTO `appexoticshoes_categorias` (`id`, `nombre`) VALUES
	(3, 'Accesorios'),
	(2, 'Blusas'),
	(4, 'Lociones'),
	(1, 'Tenis');

-- Volcando datos para la tabla tiendaexoticshoes.appexoticshoes_productos: ~5 rows (aproximadamente)
INSERT IGNORE INTO `appexoticshoes_productos` (`id`, `nombre`, `descripcion`, `precio`, `cantidadEnInventario`, `foto`, `estado`, `categoria_id`) VALUES
	(1, 'Nike', 'tenis Air Mag "Back to the Future"', 264000.00, 10, 'productos/Nike_mag_flight_club.jpg', 1, 1),
	(2, 'SKECHERS', 'Tenis Skechers Hombre Moda Summits', 244990.00, 15, 'productos/tenis.jpg', 0, 1),
	(3, 'adidas', 'Adidas Skateboarding', 560000.00, 8, 'productos/adidas-printemps-2011-7.jpg', 1, 1),
	(4, 'VIP212', 'Locion Para dama', 150000.00, 5, 'productos/OIP.jpg', 1, 4),
	(5, 'Blusa TShirt', 'blusa negra talla', 40000.00, 10, 'productos/blusa.jpg', 1, 2);

-- Volcando datos para la tabla tiendaexoticshoes.appexoticshoes_usuarios: ~0 rows (aproximadamente)
INSERT IGNORE INTO `appexoticshoes_usuarios` (`user_ptr_id`, `telefono`, `FechaNacimiento`, `direccion`) VALUES
	(2, '3172917178', '1998-03-18', 'Carrera 9');

-- Volcando datos para la tabla tiendaexoticshoes.auth_user: ~0 rows (aproximadamente)
INSERT IGNORE INTO `auth_user` (`id`, `password`, `last_login`, `is_superuser`, `username`, `first_name`, `last_name`, `email`, `is_staff`, `is_active`, `date_joined`) VALUES
	(1, 'pbkdf2_sha256$600000$j6vdn897Mwqp23Xbe0IGZu$S8UGu03lxyAWxo0T3GrkodvHBak+RihPxb5bPTMW8d4=', '2023-07-27 20:54:42.655158', 1, 'admin', '', '', 'dajun318@gmail.com', 1, 1, '2023-07-22 21:48:31.519058'),
	(2, '1234', NULL, 0, 'user', 'Juan David', 'Chimbaco Herrera', '', 0, 1, '2023-07-27 23:37:58.751003');

-- Volcando datos para la tabla tiendaexoticshoes.auth_user_groups: ~0 rows (aproximadamente)
INSERT IGNORE INTO `auth_user_groups` (`id`, `user_id`, `group_id`) VALUES
	(1, 2, 2);

-- Volcando datos para la tabla tiendaexoticshoes.auth_user_user_permissions: ~0 rows (aproximadamente)

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
