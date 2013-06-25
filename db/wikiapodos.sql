SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

DROP SCHEMA IF EXISTS `mydb` ;
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`configuraciones`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`configuraciones` ;

CREATE  TABLE IF NOT EXISTS `mydb`.`configuraciones` (
  `id` INT NOT NULL ,
  `llave` VARCHAR(45) NULL ,
  `valor` TEXT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`usuarios`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`usuarios` ;

CREATE  TABLE IF NOT EXISTS `mydb`.`usuarios` (
  `id` INT NOT NULL ,
  `facebook_id` VARCHAR(45) NULL ,
  `nombre` VARCHAR(45) NULL ,
  `apellido` VARCHAR(45) NULL ,
  `email` VARCHAR(45) NULL ,
  `es_fan` VARCHAR(45) NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`apodos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`apodos` ;

CREATE  TABLE IF NOT EXISTS `mydb`.`apodos` (
  `id` INT NOT NULL ,
  `autor_id` INT NULL ,
  `nombre` VARCHAR(45) NULL COMMENT '	' ,
  `prefijo` VARCHAR(45) NULL ,
  `descripcion` VARCHAR(45) NULL ,
  `imagen_url` VARCHAR(45) NULL ,
  `calificacion` DOUBLE NULL ,
  `visible` TINYINT(1) NULL ,
  `destacado` TINYINT(1) NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`compartidos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`compartidos` ;

CREATE  TABLE IF NOT EXISTS `mydb`.`compartidos` (
  `id` INT NOT NULL ,
  `usuario_id` INT NULL ,
  `apodo_id` INT NULL ,
  `fecha` VARCHAR(45) NULL ,
  `origen` VARCHAR(45) NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `usuarios_comp_idx` (`usuario_id` ASC) ,
  INDEX `apodos_comp_idx` (`apodo_id` ASC) ,
  CONSTRAINT `usuarios_comp`
    FOREIGN KEY (`usuario_id` )
    REFERENCES `mydb`.`usuarios` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `apodos_comp`
    FOREIGN KEY (`apodo_id` )
    REFERENCES `mydb`.`apodos` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`apodos_usuarios`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`apodos_usuarios` ;

CREATE  TABLE IF NOT EXISTS `mydb`.`apodos_usuarios` (
  `usuario_desde_id` VARCHAR(45) NOT NULL ,
  `usuario_para_id` VARCHAR(45) NULL ,
  `apodo_id` INT NULL ,
  `status` VARCHAR(45) NULL ,
  `visible` TINYINT(1) NULL ,
  PRIMARY KEY (`usuario_desde_id`) ,
  INDEX `apodos_idx` (`apodo_id` ASC) ,
  CONSTRAINT `usuario_desde`
    FOREIGN KEY (`apodo_id` )
    REFERENCES `mydb`.`usuarios` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `apodos`
    FOREIGN KEY (`apodo_id` )
    REFERENCES `mydb`.`apodos` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`cuerpos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`cuerpos` ;

CREATE  TABLE IF NOT EXISTS `mydb`.`cuerpos` (
  `id` INT NOT NULL ,
  `descripcion` VARCHAR(45) NULL ,
  `imagen_url` VARCHAR(45) NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`categorías`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`categorías` ;

CREATE  TABLE IF NOT EXISTS `mydb`.`categorías` (
  `id` INT NOT NULL ,
  `descripcion` VARCHAR(45) NULL ,
  `imagen_url` VARCHAR(45) NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`objetos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`objetos` ;

CREATE  TABLE IF NOT EXISTS `mydb`.`objetos` (
  `id` INT NOT NULL ,
  `categoria_id` INT NULL ,
  `descripcion` VARCHAR(45) NULL ,
  `imagen_url` VARCHAR(45) NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `obj_categoria_idx` (`categoria_id` ASC) ,
  CONSTRAINT `obj_categoria`
    FOREIGN KEY (`categoria_id` )
    REFERENCES `mydb`.`categorías` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`table1`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`table1` ;

CREATE  TABLE IF NOT EXISTS `mydb`.`table1` (
)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`imagenes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`imagenes` ;

CREATE  TABLE IF NOT EXISTS `mydb`.`imagenes` (
  `id` INT NOT NULL ,
  `cuerpo_id` INT NULL ,
  `objeto_id` INT NULL ,
  `imagen_url` VARCHAR(45) NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `imagen_cuerpo_idx` (`cuerpo_id` ASC) ,
  INDEX `imagen_objeto_idx` (`objeto_id` ASC) ,
  CONSTRAINT `imagen_cuerpo`
    FOREIGN KEY (`cuerpo_id` )
    REFERENCES `mydb`.`cuerpos` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `imagen_objeto`
    FOREIGN KEY (`objeto_id` )
    REFERENCES `mydb`.`objetos` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`calificaciones`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`calificaciones` ;

CREATE  TABLE IF NOT EXISTS `mydb`.`calificaciones` (
  `id` INT NOT NULL ,
  `usuario_id` INT NULL ,
  `apodo_id` INT NULL ,
  `calificacion` INT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `apodo_calif_idx` (`apodo_id` ASC) ,
  INDEX `usuario_calif_idx` (`usuario_id` ASC) ,
  CONSTRAINT `usuario_calif`
    FOREIGN KEY (`usuario_id` )
    REFERENCES `mydb`.`usuarios` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `apodo_calif`
    FOREIGN KEY (`apodo_id` )
    REFERENCES `mydb`.`apodos` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`reportes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`reportes` ;

CREATE  TABLE IF NOT EXISTS `mydb`.`reportes` (
  `id` INT NOT NULL ,
  `usuario_id` INT NULL ,
  `apodo_id` INT NULL ,
  `fecha` VARCHAR(45) NULL ,
  `razon` TEXT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `usuarios_comp_idx` (`usuario_id` ASC) ,
  INDEX `apodos_comp_idx` (`apodo_id` ASC) ,
  CONSTRAINT `usuarios_comp0`
    FOREIGN KEY (`usuario_id` )
    REFERENCES `mydb`.`usuarios` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `apodos_comp0`
    FOREIGN KEY (`apodo_id` )
    REFERENCES `mydb`.`apodos` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `mydb` ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
