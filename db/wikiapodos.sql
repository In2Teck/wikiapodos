-- MySQL Administrator dump 1.4
--
-- ------------------------------------------------------
-- Server version  5.1.54-log


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


--
-- Create schema jc_wikiapodos
--

CREATE DATABASE IF NOT EXISTS jc_wikiapodos;
USE jc_wikiapodos;

--
-- Definition of table `jc_wikiapodos`.`apodos`
--

DROP TABLE IF EXISTS `jc_wikiapodos`.`apodos`;
CREATE TABLE  `jc_wikiapodos`.`apodos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `autor_id` varchar(45) DEFAULT NULL,
  `nombre` varchar(45) DEFAULT NULL COMMENT '	',
  `prefijo` varchar(45) DEFAULT NULL,
  `descripcion` varchar(45) DEFAULT NULL,
  `imagen_url` varchar(45) DEFAULT NULL,
  `calificacion` double DEFAULT NULL,
  `visible` tinyint(1) DEFAULT NULL,
  `destacado` tinyint(1) DEFAULT NULL,
  `fecha_creacion` datetime NOT NULL,
  `fecha_actualizacion` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Definition of table `jc_wikiapodos`.`apodos_usuarios`
--

DROP TABLE IF EXISTS `jc_wikiapodos`.`apodos_usuarios`;
CREATE TABLE  `jc_wikiapodos`.`apodos_usuarios` (
  `usuario_desde_id` varchar(45) NOT NULL,
  `usuario_para_id` varchar(45) NOT NULL,
  `apodo_id` int(11) NOT NULL,
  `status` varchar(45) DEFAULT NULL,
  `visible` tinyint(1) DEFAULT NULL,
  `fecha_creacion` datetime NOT NULL,
  `fecha_actualizacion` datetime NOT NULL,
  PRIMARY KEY (`usuario_desde_id`,`usuario_para_id`,`apodo_id`),
  KEY `apodos_idx` (`apodo_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Definition of table `jc_wikiapodos`.`calificaciones`
--

DROP TABLE IF EXISTS `jc_wikiapodos`.`calificaciones`;
CREATE TABLE  `jc_wikiapodos`.`calificaciones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usuario_id` varchar(45) NOT NULL,
  `apodo_id` int(11) DEFAULT NULL,
  `calificacion` int(11) DEFAULT NULL,
  `fecha_creacion` datetime NOT NULL,
  `fecha_actualizacion` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `apodo_calif_idx` (`apodo_id`),
  KEY `usuario_calif_idx` (`usuario_id`),
  CONSTRAINT `usuario_calif` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`facebook_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `apodo_calif` FOREIGN KEY (`apodo_id`) REFERENCES `apodos` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Definition of table `jc_wikiapodos`.`categorias`
--

DROP TABLE IF EXISTS `jc_wikiapodos`.`categorias`;
CREATE TABLE  `jc_wikiapodos`.`categorias` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(45) DEFAULT NULL,
  `imagen_url` varchar(45) DEFAULT NULL,
  `fecha_creacion` datetime NOT NULL,
  `fecha_actualizacion` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `jc_wikiapodos`.`categorias`
--

/*!40000 ALTER TABLE `categorias` DISABLE KEYS */;
LOCK TABLES `categorias` WRITE;
UNLOCK TABLES;
/*!40000 ALTER TABLE `categorias` ENABLE KEYS */;


--
-- Definition of table `jc_wikiapodos`.`compartidos`
--

DROP TABLE IF EXISTS `jc_wikiapodos`.`compartidos`;
CREATE TABLE  `jc_wikiapodos`.`compartidos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usuario_id` varchar(45) DEFAULT NULL,
  `apodo_id` int(11) DEFAULT NULL,
  `fecha` varchar(45) DEFAULT NULL,
  `origen` varchar(45) DEFAULT NULL,
  `fecha_creacion` datetime NOT NULL,
  `fecha_actualizacion` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `usuarios_comp_idx` (`usuario_id`),
  KEY `apodos_comp_idx` (`apodo_id`),
  CONSTRAINT `apodos_comp` FOREIGN KEY (`apodo_id`) REFERENCES `apodos` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Definition of table `jc_wikiapodos`.`configuraciones`
--

DROP TABLE IF EXISTS `jc_wikiapodos`.`configuraciones`;
CREATE TABLE  `jc_wikiapodos`.`configuraciones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `llave` varchar(45) DEFAULT NULL,
  `valor` text,
  `fecha_creacion` datetime NOT NULL,
  `fecha_actualizacion` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `jc_wikiapodos`.`configuraciones`
--

/*!40000 ALTER TABLE `configuraciones` DISABLE KEYS */;
LOCK TABLES `configuraciones` WRITE;
INSERT INTO `jc_wikiapodos`.`configuraciones` VALUES  (1,'titulo_pagina','Wikiapodos','2013-06-24 14:14:16','2013-06-24 14:14:16'),
 (2,'descripcion_pagina','Descripción de la página','2013-06-24 14:14:16','2013-06-24 14:14:16'),
 (3,'url_portal','https://apps.t2omedia.com.mx/php1/wikiapodos/','2013-06-24 14:14:16','2013-06-24 14:14:16'),
 (4,'url_portal_fb','http://www.facebook.com/In2Teck/app_288059641339246','2013-06-24 14:14:16','2013-06-24 14:14:16'),
 (5,'url_app_fb','http://apps.facebook.com/wikiapodos','2013-06-24 14:14:16','2013-06-24 14:14:16'),
 (6,'fb_app_id','288059641339246','2013-06-24 14:14:16','2013-06-24 14:14:16'),
 (7,'fb_app_secret','351d16a6b16d21d2fbd4af74b0b97d63','2013-06-24 14:14:16','2013-06-24 14:14:16'),
 (8,'fb_like_page_id','116098461808546','2013-06-24 14:14:16','2013-06-24 14:14:16'),
 (9,'fb_permissions','email,publish_stream,user_likes','2013-06-24 14:14:16','2013-06-24 14:14:16'),
 (10,'url_imagenes_facebook','https://graph.facebook.com/{id}/picture','2013-06-24 14:14:16','2013-06-24 14:14:16'),
 (11,'pagination_limit_apodo','15','2013-06-24 14:14:16','2013-06-24 14:14:16'),
 (12,'pagination_limit_reporte','20','2013-06-24 14:14:16','2013-06-24 14:14:16'),
 (13,'youtube_video_id','-T07ms9Brow','2013-06-24 14:14:16','2013-06-24 14:14:16'),
 (14,'ultima_modificacion','2013-06-27 12:01:16','2013-06-24 14:14:16','2013-06-24 14:14:16');
UNLOCK TABLES;
/*!40000 ALTER TABLE `configuraciones` ENABLE KEYS */;


--
-- Definition of table `jc_wikiapodos`.`cuerpos`
--

DROP TABLE IF EXISTS `jc_wikiapodos`.`cuerpos`;
CREATE TABLE  `jc_wikiapodos`.`cuerpos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(45) DEFAULT NULL,
  `imagen_url` varchar(45) DEFAULT NULL,
  `fecha_creacion` datetime NOT NULL,
  `fecha_actualizacion` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Definition of table `jc_wikiapodos`.`imagenes`
--

DROP TABLE IF EXISTS `jc_wikiapodos`.`imagenes`;
CREATE TABLE  `jc_wikiapodos`.`imagenes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cuerpo_id` int(11) DEFAULT NULL,
  `objeto_id` int(11) DEFAULT NULL,
  `imagen_url` varchar(45) DEFAULT NULL,
  `fecha_creacion` datetime NOT NULL,
  `fecha_actualizacion` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `imagen_cuerpo_idx` (`cuerpo_id`),
  KEY `imagen_objeto_idx` (`objeto_id`),
  CONSTRAINT `imagen_cuerpo` FOREIGN KEY (`cuerpo_id`) REFERENCES `cuerpos` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `imagen_objeto` FOREIGN KEY (`objeto_id`) REFERENCES `objetos` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Definition of table `jc_wikiapodos`.`objetos`
--

DROP TABLE IF EXISTS `jc_wikiapodos`.`objetos`;
CREATE TABLE  `jc_wikiapodos`.`objetos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `categoria_id` int(11) DEFAULT NULL,
  `descripcion` varchar(45) DEFAULT NULL,
  `imagen_url` varchar(45) DEFAULT NULL,
  `fecha_creacion` datetime NOT NULL,
  `fecha_actualizacion` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `obj_categoria_idx` (`categoria_id`),
  CONSTRAINT `obj_categoria` FOREIGN KEY (`categoria_id`) REFERENCES `categorías` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Definition of table `jc_wikiapodos`.`reportes`
--

DROP TABLE IF EXISTS `jc_wikiapodos`.`reportes`;
CREATE TABLE  `jc_wikiapodos`.`reportes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usuario_id` varchar(45) DEFAULT NULL,
  `apodo_id` int(11) DEFAULT NULL,
  `fecha` varchar(45) DEFAULT NULL,
  `razon` text,
  `fecha_creacion` datetime NOT NULL,
  `fecha_actualizacion` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `usuarios_comp_idx` (`usuario_id`),
  KEY `apodos_comp_idx` (`apodo_id`),
  CONSTRAINT `apodos_comp0` FOREIGN KEY (`apodo_id`) REFERENCES `apodos` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Definition of table `jc_wikiapodos`.`usuarios`
--

DROP TABLE IF EXISTS `jc_wikiapodos`.`usuarios`;
CREATE TABLE  `jc_wikiapodos`.`usuarios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `facebook_id` varchar(45) DEFAULT NULL,
  `nombre` varchar(45) DEFAULT NULL,
  `apellido` varchar(45) DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL,
  `es_fan` varchar(45) DEFAULT NULL,
  `fecha_creacion` datetime NOT NULL,
  `fecha_actualizacion` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `facebook_id_UNIQUE` (`facebook_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
