-- MySQL Script generated by MySQL Workbench
-- Qua 17 Jan 2018 16:10:32 -02
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema dicionario
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `dicionario` ;

-- -----------------------------------------------------
-- Schema dicionario
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `dicionario` DEFAULT CHARACTER SET utf8 ;
USE `dicionario` ;

-- -----------------------------------------------------
-- Table `dicionario`.`categoriaGram`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dicionario`.`categoriaGram` ;

CREATE TABLE IF NOT EXISTS `dicionario`.`categoriaGram` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Descricao` VARCHAR(30) NOT NULL,
  `sigla` VARCHAR(4) NOT NULL COMMENT '	',
  PRIMARY KEY (`Id`),
  UNIQUE INDEX `Id_UNIQUE` (`Id` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `dicionario`.`classeGram`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dicionario`.`classeGram` ;

CREATE TABLE IF NOT EXISTS `dicionario`.`classeGram` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Descricao` VARCHAR(45) NOT NULL,
  `sigla` VARCHAR(4) NOT NULL COMMENT '	',
  PRIMARY KEY (`Id`),
  UNIQUE INDEX `Id_UNIQUE` (`Id` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `dicionario`.`referencias`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dicionario`.`referencias` ;

CREATE TABLE IF NOT EXISTS `dicionario`.`referencias` (
  `Cod` INT NOT NULL AUTO_INCREMENT,
  `Descricao` VARCHAR(45) NOT NULL,
  `Ano` INT(4) NOT NULL,
  `Autor` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Cod`),
  UNIQUE INDEX `Cod_UNIQUE` (`Cod` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `dicionario`.`base`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dicionario`.`base` ;

CREATE TABLE IF NOT EXISTS `dicionario`.`base` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `palavra` VARCHAR(30) NOT NULL,
  `subpalavra` VARCHAR(30) NULL,
  `idioma` CHAR(2) NOT NULL,
  `contexto` VARCHAR(30) NULL,
  `equivalente` VARCHAR(45) NULL COMMENT '	',
  `palavra_catGram` INT NULL,
  `subpalavra_catGram` INT NULL,
  `palavra_classeGram` INT NULL,
  `subpalavra_classeGram` INT NULL,
  `acepcao` VARCHAR(45) NOT NULL,
  `definicao` VARCHAR(45) NOT NULL,
  `exemplos_original` TEXT NULL,
  `exemplos_traduzido` TEXT NULL,
  `traducao` INT NULL,
  `rubrica` VARCHAR(45) NULL,
  `falsos_cognatos` INT NULL,
  `referencia_verbete` INT NOT NULL,
  `referencia_exemplo` TINYTEXT NOT NULL,
  `notas_gramatica` TINYTEXT NULL,
  `notas_cultura` TINYTEXT NULL,
  `heterogenerico` VARCHAR(45) NULL,
  `heterotonico` VARCHAR(45) NULL,
  `compl_verbo` VARCHAR(45) NULL,
  `compl_adjetivo` VARCHAR(45) NULL,
  PRIMARY KEY (`Id`),
  INDEX `FK_catGram_palavra_idx` (`palavra_catGram` ASC),
  INDEX `FK_catGram_subpalavra_idx` (`subpalavra_catGram` ASC),
  INDEX `FK_classeGram_palavra_idx` (`palavra_classeGram` ASC),
  INDEX `FK_classeGram_subpalavra_idx` (`subpalavra_classeGram` ASC),
  INDEX `FK_Ref_idx` (`referencia_verbete` ASC),
  UNIQUE INDEX `Id_UNIQUE` (`Id` ASC),
  CONSTRAINT `FK_catGram_palavra`
    FOREIGN KEY (`palavra_catGram`)
    REFERENCES `dicionario`.`categoriaGram` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_catGram_subpalavra`
    FOREIGN KEY (`subpalavra_catGram`)
    REFERENCES `dicionario`.`categoriaGram` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_classeGram_palavra`
    FOREIGN KEY (`palavra_classeGram`)
    REFERENCES `dicionario`.`classeGram` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_classeGram_subpalavra`
    FOREIGN KEY (`subpalavra_classeGram`)
    REFERENCES `dicionario`.`classeGram` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_Ref`
    FOREIGN KEY (`referencia_verbete`)
    REFERENCES `dicionario`.`referencias` (`Cod`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `dicionario`.`Rubrica`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dicionario`.`Rubrica` ;

CREATE TABLE IF NOT EXISTS `dicionario`.`Rubrica` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Descricao` VARCHAR(45) NOT NULL,
  `sigla` VARCHAR(4) NOT NULL,
  PRIMARY KEY (`Id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `dicionario`.`Palavra`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dicionario`.`Palavra` ;

CREATE TABLE IF NOT EXISTS `dicionario`.`Palavra` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Lema` VARCHAR(45) NOT NULL,
  `Id_catGram` INT NULL,
  `Id_classeGram` INT NULL,
  `Idioma` CHAR(2) NOT NULL,
  `Rubrica` INT NULL,
  `heterogenerico` VARCHAR(45) NULL,
  `heterotonico` VARCHAR(45) NULL,
  `equivalente` INT NULL,
  `referencia_verbete` INT NULL,
  `referencia_exemplo` TINYTEXT NULL,
  `notas_gramatica` TINYTEXT NULL,
  `notas_cultura` TEXT NULL,
  `acepcao` TINYINT NULL,
  `notas_gramatica_avancado` TEXT NULL,
  PRIMARY KEY (`Id`),
  INDEX `FK_Categoria_idx` (`Id_catGram` ASC),
  INDEX `FK_Classe_idx` (`Id_classeGram` ASC),
  INDEX `FK_Referencia_idx` (`referencia_verbete` ASC),
  UNIQUE INDEX `Id_UNIQUE` (`Id` ASC),
  INDEX `FK_Rubrica_idx` (`Rubrica` ASC),
  CONSTRAINT `FK_Categoria`
    FOREIGN KEY (`Id_catGram`)
    REFERENCES `dicionario`.`categoriaGram` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_Classe`
    FOREIGN KEY (`Id_classeGram`)
    REFERENCES `dicionario`.`classeGram` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_Referencia`
    FOREIGN KEY (`referencia_verbete`)
    REFERENCES `dicionario`.`referencias` (`Cod`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_Rubrica`
    FOREIGN KEY (`Rubrica`)
    REFERENCES `dicionario`.`Rubrica` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `dicionario`.`sublemas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dicionario`.`sublemas` ;

CREATE TABLE IF NOT EXISTS `dicionario`.`sublemas` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `sublema_antes` VARCHAR(45) NULL,
  `sublema_depois` VARCHAR(45) NULL,
  PRIMARY KEY (`Id`),
  UNIQUE INDEX `Id_UNIQUE` (`Id` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `dicionario`.`Entrada`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dicionario`.`Entrada` ;

CREATE TABLE IF NOT EXISTS `dicionario`.`Entrada` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Id_Palavra` INT NOT NULL,
  `Id_Equivalente` INT NOT NULL,
  `referencia_verbete` INT NULL,
  `referencia_exemplo` TINYTEXT NULL,
  `notas_cultura` TEXT NULL,
  `notas_gramatica` TINYTEXT NULL,
  `Id_sublema` INT NULL,
  `Id_catGram` INT NULL,
  `Id_classeGram` INT NULL,
  `acepcao` TINYINT NULL,
  `rubrica` INT NULL,
  `notas_gramatica_avancado` TEXT NULL,
  PRIMARY KEY (`Id`),
  INDEX `FK_Palavra_idx` (`Id_Palavra` ASC),
  INDEX `FK_Sublema_idx` (`Id_sublema` ASC),
  INDEX `FK_Referencia_idx` (`referencia_verbete` ASC),
  INDEX `FK_Traducao_idx` (`Id_Equivalente` ASC),
  INDEX `FK_classe_idx` (`Id_classeGram` ASC),
  INDEX `FK_categoria_idx` (`Id_catGram` ASC),
  UNIQUE INDEX `Id_UNIQUE` (`Id` ASC),
  INDEX `FK_rubrica_idx` (`rubrica` ASC),
  CONSTRAINT `FK_Palavra`
    FOREIGN KEY (`Id_Palavra`)
    REFERENCES `dicionario`.`Palavra` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_Sublema`
    FOREIGN KEY (`Id_sublema`)
    REFERENCES `dicionario`.`sublemas` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_Referencia`
    FOREIGN KEY (`referencia_verbete`)
    REFERENCES `dicionario`.`referencias` (`Cod`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_Traducao`
    FOREIGN KEY (`Id_Equivalente`)
    REFERENCES `dicionario`.`Palavra` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_classe`
    FOREIGN KEY (`Id_classeGram`)
    REFERENCES `dicionario`.`classeGram` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_categoria`
    FOREIGN KEY (`Id_catGram`)
    REFERENCES `dicionario`.`categoriaGram` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_rubrica`
    FOREIGN KEY (`rubrica`)
    REFERENCES `dicionario`.`Rubrica` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `dicionario`.`falso_cognato`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dicionario`.`falso_cognato` ;

CREATE TABLE IF NOT EXISTS `dicionario`.`falso_cognato` (
  `pai` INT NOT NULL,
  `verbete` INT NOT NULL,
  PRIMARY KEY (`pai`, `verbete`),
  INDEX `FK_destino_idx` (`verbete` ASC),
  CONSTRAINT `FK_origem`
    FOREIGN KEY (`pai`)
    REFERENCES `dicionario`.`Entrada` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_destino`
    FOREIGN KEY (`verbete`)
    REFERENCES `dicionario`.`Palavra` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `dicionario`.`usr`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dicionario`.`usr` ;

CREATE TABLE IF NOT EXISTS `dicionario`.`usr` (
  `usr` INT NOT NULL,
  `pass` VARCHAR(45) NOT NULL,
  `nivel_permissao` ENUM('ADM', 'EDT', 'USR') NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `nome` VARCHAR(45) NULL,
  `contato` VARCHAR(45) NULL,
  `rede_social` VARCHAR(45) NULL,
  `cpf` CHAR(11) NOT NULL,
  `telefone` CHAR(13) NULL,
  PRIMARY KEY (`usr`),
  UNIQUE INDEX `usr_UNIQUE` (`usr` ASC),
  UNIQUE INDEX `cpf_UNIQUE` (`cpf` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `dicionario`.`config`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dicionario`.`config` ;

CREATE TABLE IF NOT EXISTS `dicionario`.`config` (
  `endereco_servidor` TINYTEXT NOT NULL,
  `porta` INT NOT NULL,
  `usuario` VARCHAR(45) NOT NULL,
  `senha` VARCHAR(45) NOT NULL,
  `nome_bd` VARCHAR(45) NOT NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci
MAX_ROWS = 1
MIN_ROWS = 1;


-- -----------------------------------------------------
-- Table `dicionario`.`Equivalencias`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dicionario`.`Equivalencias` ;

CREATE TABLE IF NOT EXISTS `dicionario`.`Equivalencias` (
  `Origem` INT NOT NULL,
  `equivalente` INT NOT NULL COMMENT '	',
  PRIMARY KEY (`Origem`, `equivalente`),
  INDEX `fk_Equivalencias_2_idx` (`equivalente` ASC),
  CONSTRAINT `fk_Equivalencias_1`
    FOREIGN KEY (`Origem`)
    REFERENCES `dicionario`.`Entrada` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Equivalencias_2`
    FOREIGN KEY (`equivalente`)
    REFERENCES `dicionario`.`Palavra` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Equivalente nada mais é do que *Tradução*';


-- -----------------------------------------------------
-- Table `dicionario`.`GramatVerbo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dicionario`.`GramatVerbo` ;

CREATE TABLE IF NOT EXISTS `dicionario`.`GramatVerbo` (
  `Id` INT NOT NULL,
  `Descricao` VARCHAR(45) NULL,
  `sigla` VARCHAR(45) NULL,
  PRIMARY KEY (`Id`),
  UNIQUE INDEX `Id_UNIQUE` (`Id` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci
COMMENT = 'Para uso nos complementos';


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
