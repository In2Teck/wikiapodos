SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `jc_wikiapodos` DEFAULT CHARACTER SET utf8 ;
USE `jc_wikiapodos` ;

-- -----------------------------------------------------
-- Table `jc_wikiapodos`.`apodos`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `jc_wikiapodos`.`apodos` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `autor_id` VARCHAR(45) NULL DEFAULT NULL ,
  `nombre` VARCHAR(25) NULL DEFAULT NULL COMMENT '	' ,
  `prefijo` VARCHAR(5) NULL DEFAULT NULL ,
  `descripcion` VARCHAR(300) NULL DEFAULT NULL ,
  `imagen_url` VARCHAR(255) NULL DEFAULT NULL ,
  `url_corto` VARCHAR(30) NULL DEFAULT NULL ,
  `calificacion` DOUBLE NULL DEFAULT NULL ,
  `visible` TINYINT(1) NULL DEFAULT NULL ,
  `destacado` TINYINT(1) NULL DEFAULT NULL ,
  `fecha_creacion` DATETIME NOT NULL ,
  `fecha_actualizacion` DATETIME NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
AUTO_INCREMENT = 51
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `jc_wikiapodos`.`apodos_usuarios`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `jc_wikiapodos`.`apodos_usuarios` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `usuario_desde_id` VARCHAR(45) NOT NULL ,
  `usuario_para_id` VARCHAR(45) NOT NULL ,
  `apodo_id` INT(11) NOT NULL ,
  `status` VARCHAR(45) NULL DEFAULT NULL ,
  `visible` TINYINT(1) NULL DEFAULT NULL ,
  `fecha_creacion` DATETIME NOT NULL ,
  `fecha_actualizacion` DATETIME NOT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) ,
  UNIQUE INDEX `fields_UNIQUE` (`usuario_desde_id` ASC, `usuario_para_id` ASC, `apodo_id` ASC) ,
  INDEX `apodos_idx` (`apodo_id` ASC) )
ENGINE = InnoDB
AUTO_INCREMENT = 40
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `jc_wikiapodos`.`usuarios`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `jc_wikiapodos`.`usuarios` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `facebook_id` VARCHAR(45) NULL DEFAULT NULL ,
  `nombre` VARCHAR(45) NULL DEFAULT NULL ,
  `apellido` VARCHAR(45) NULL DEFAULT NULL ,
  `email` VARCHAR(45) NULL DEFAULT NULL ,
  `es_fan` VARCHAR(45) NULL DEFAULT NULL ,
  `fecha_creacion` DATETIME NOT NULL ,
  `fecha_actualizacion` DATETIME NOT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `facebook_id_UNIQUE` (`facebook_id` ASC) )
ENGINE = InnoDB
AUTO_INCREMENT = 12
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `jc_wikiapodos`.`calificaciones`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `jc_wikiapodos`.`calificaciones` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `usuario_id` VARCHAR(45) NOT NULL ,
  `apodo_id` INT(11) NULL DEFAULT NULL ,
  `calificacion` INT(11) NULL DEFAULT NULL ,
  `fecha_creacion` DATETIME NOT NULL ,
  `fecha_actualizacion` DATETIME NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `apodo_calif_idx` (`apodo_id` ASC) ,
  INDEX `usuario_calif_idx` (`usuario_id` ASC) ,
  CONSTRAINT `usuario_calif`
    FOREIGN KEY (`usuario_id` )
    REFERENCES `jc_wikiapodos`.`usuarios` (`facebook_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `apodo_calif`
    FOREIGN KEY (`apodo_id` )
    REFERENCES `jc_wikiapodos`.`apodos` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 16
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `jc_wikiapodos`.`categorias`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `jc_wikiapodos`.`categorias` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `orden` INT(11) NOT NULL DEFAULT '1' ,
  `descripcion` VARCHAR(45) NOT NULL ,
  `imagen_url` VARCHAR(45) NOT NULL ,
  `fecha_creacion` DATETIME NOT NULL ,
  `fecha_actualizacion` DATETIME NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `jc_wikiapodos`.`compartidos`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `jc_wikiapodos`.`compartidos` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `usuario_id` VARCHAR(45) NULL DEFAULT NULL ,
  `apodo_id` INT(11) NULL DEFAULT NULL ,
  `fecha` VARCHAR(45) NULL DEFAULT NULL ,
  `origen` VARCHAR(45) NULL DEFAULT NULL ,
  `fecha_creacion` DATETIME NOT NULL ,
  `fecha_actualizacion` DATETIME NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `usuarios_comp_idx` (`usuario_id` ASC) ,
  INDEX `apodos_comp_idx` (`apodo_id` ASC) ,
  CONSTRAINT `apodos_comp`
    FOREIGN KEY (`apodo_id` )
    REFERENCES `jc_wikiapodos`.`apodos` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `jc_wikiapodos`.`configuraciones`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `jc_wikiapodos`.`configuraciones` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `llave` VARCHAR(45) NULL DEFAULT NULL ,
  `valor` TEXT NULL DEFAULT NULL ,
  `fecha_creacion` DATETIME NOT NULL ,
  `fecha_actualizacion` DATETIME NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
AUTO_INCREMENT = 16
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `jc_wikiapodos`.`cuerpos`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `jc_wikiapodos`.`cuerpos` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `orden` INT(11) NOT NULL ,
  `descripcion` VARCHAR(45) NOT NULL ,
  `imagen_url` VARCHAR(45) NOT NULL ,
  `fecha_creacion` DATETIME NOT NULL ,
  `fecha_actualizacion` DATETIME NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `jc_wikiapodos`.`objetos`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `jc_wikiapodos`.`objetos` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `categoria_id` INT(11) NULL DEFAULT NULL ,
  `orden` INT(11) NOT NULL DEFAULT '1' ,
  `descripcion` VARCHAR(45) NOT NULL ,
  `imagen_url` VARCHAR(45) NOT NULL ,
  `fecha_creacion` DATETIME NOT NULL ,
  `fecha_actualizacion` DATETIME NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `obj_categoria_idx` (`categoria_id` ASC) ,
  CONSTRAINT `obj_categoria`
    FOREIGN KEY (`categoria_id` )
    REFERENCES `jc_wikiapodos`.`categorias` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 28
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `jc_wikiapodos`.`imagenes`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `jc_wikiapodos`.`imagenes` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `cuerpo_id` INT(11) NULL DEFAULT NULL ,
  `objeto_id` INT(11) NULL DEFAULT NULL ,
  `imagen_url` VARCHAR(45) NULL DEFAULT NULL ,
  `fecha_creacion` DATETIME NOT NULL ,
  `fecha_actualizacion` DATETIME NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `imagen_cuerpo_idx` (`cuerpo_id` ASC) ,
  INDEX `imagen_objeto_idx` (`objeto_id` ASC) ,
  CONSTRAINT `imagen_cuerpo`
    FOREIGN KEY (`cuerpo_id` )
    REFERENCES `jc_wikiapodos`.`cuerpos` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `imagen_objeto`
    FOREIGN KEY (`objeto_id` )
    REFERENCES `jc_wikiapodos`.`objetos` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `jc_wikiapodos`.`reportes`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `jc_wikiapodos`.`reportes` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `usuario_id` VARCHAR(45) NULL DEFAULT NULL ,
  `apodo_id` INT(11) NULL DEFAULT NULL ,
  `fecha` VARCHAR(45) NULL DEFAULT NULL ,
  `razon` TEXT NULL DEFAULT NULL ,
  `fecha_creacion` DATETIME NOT NULL ,
  `fecha_actualizacion` DATETIME NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `usuarios_comp_idx` (`usuario_id` ASC) ,
  INDEX `apodos_comp_idx` (`apodo_id` ASC) ,
  CONSTRAINT `apodos_comp0`
    FOREIGN KEY (`apodo_id` )
    REFERENCES `jc_wikiapodos`.`apodos` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8;

USE `jc_wikiapodos` ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
