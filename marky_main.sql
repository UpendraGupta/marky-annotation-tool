SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

DROP SCHEMA IF EXISTS `marky` ;
CREATE SCHEMA IF NOT EXISTS `marky` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `marky` ;

-- -----------------------------------------------------
-- Table `marky`.`groups`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `marky`.`groups` ;

CREATE TABLE IF NOT EXISTS `marky`.`groups` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `marky`.`users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `marky`.`users` ;

CREATE TABLE IF NOT EXISTS `marky`.`users` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `group_id` INT UNSIGNED NOT NULL,
  `username` VARCHAR(50) NOT NULL,
  `surname` VARCHAR(45) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `password` VARCHAR(50) NOT NULL,
  `created` DATETIME NULL,
  `modified` DATETIME NULL,
  `image` MEDIUMBLOB NULL,
  `image_type` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_users_groups1`
    FOREIGN KEY (`group_id`)
    REFERENCES `marky`.`groups` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_users_groups1_idx` ON `marky`.`users` (`group_id` ASC);

CREATE UNIQUE INDEX `email_UNIQUE` ON `marky`.`users` (`email` ASC);


-- -----------------------------------------------------
-- Table `marky`.`projects`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `marky`.`projects` ;

CREATE TABLE IF NOT EXISTS `marky`.`projects` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(200) NOT NULL,
  `created` DATETIME NULL,
  `modified` DATETIME NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `marky`.`rounds`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `marky`.`rounds` ;

CREATE TABLE IF NOT EXISTS `marky`.`rounds` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `project_id` INT UNSIGNED NOT NULL,
  `title` VARCHAR(45) NOT NULL,
  `ends_in_date` DATE NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_rounds_projects1`
    FOREIGN KEY (`project_id`)
    REFERENCES `marky`.`projects` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_rounds_projects1_idx` ON `marky`.`rounds` (`project_id` ASC);


-- -----------------------------------------------------
-- Table `marky`.`documents`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `marky`.`documents` ;

CREATE TABLE IF NOT EXISTS `marky`.`documents` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(200) NOT NULL,
  `created` DATETIME NULL,
  `html` LONGBLOB NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `marky`.`users_rounds`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `marky`.`users_rounds` ;

CREATE TABLE IF NOT EXISTS `marky`.`users_rounds` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED NOT NULL,
  `round_id` INT UNSIGNED NOT NULL,
  `document_id` INT UNSIGNED NOT NULL,
  `text_marked` LONGBLOB NULL,
  `created` DATETIME NULL,
  `modified` DATETIME NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_users_has_rounds_users1`
    FOREIGN KEY (`user_id`)
    REFERENCES `marky`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_users_has_rounds_rounds1`
    FOREIGN KEY (`round_id`)
    REFERENCES `marky`.`rounds` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_users_rounds_documents1`
    FOREIGN KEY (`document_id`)
    REFERENCES `marky`.`documents` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_users_has_rounds_rounds1_idx` ON `marky`.`users_rounds` (`round_id` ASC);

CREATE INDEX `fk_users_has_rounds_users1_idx` ON `marky`.`users_rounds` (`user_id` ASC);

CREATE INDEX `fk_users_rounds_documents1_idx` ON `marky`.`users_rounds` (`document_id` ASC);


-- -----------------------------------------------------
-- Table `marky`.`types`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `marky`.`types` ;

CREATE TABLE IF NOT EXISTS `marky`.`types` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `project_id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `colour` VARCHAR(45) NOT NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_types_projects1`
    FOREIGN KEY (`project_id`)
    REFERENCES `marky`.`projects` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_types_projects1_idx` ON `marky`.`types` (`project_id` ASC);


-- -----------------------------------------------------
-- Table `marky`.`annotations`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `marky`.`annotations` ;

CREATE TABLE IF NOT EXISTS `marky`.`annotations` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `users_round_id` INT UNSIGNED NOT NULL,
  `type_id` INT UNSIGNED NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  `document_id` INT UNSIGNED NOT NULL,
  `round_id` INT UNSIGNED NOT NULL,
  `init` INT UNSIGNED NULL,
  `end` INT UNSIGNED NULL,
  `annotated_text` TEXT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_annotations_users_rounds1`
    FOREIGN KEY (`users_round_id`)
    REFERENCES `marky`.`users_rounds` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_annotations_rounds1`
    FOREIGN KEY (`round_id`)
    REFERENCES `marky`.`rounds` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_annotations_documents1`
    FOREIGN KEY (`document_id`)
    REFERENCES `marky`.`documents` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_annotations_types1`
    FOREIGN KEY (`type_id`)
    REFERENCES `marky`.`types` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_annotations_users1`
    FOREIGN KEY (`user_id`)
    REFERENCES `marky`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_annotations_users_rounds` ON `marky`.`annotations` (`users_round_id` ASC);

CREATE INDEX `fk_annotations_rounds` ON `marky`.`annotations` (`round_id` ASC);

CREATE INDEX `fk_annotations_documents` ON `marky`.`annotations` (`document_id` ASC);

CREATE INDEX `fk_annotations_types` ON `marky`.`annotations` (`type_id` ASC);

CREATE INDEX `fk_annotations_users` ON `marky`.`annotations` (`user_id` ASC);

CREATE INDEX `complex_index_2` USING HASH ON `marky`.`annotations` (`round_id` ASC, `user_id` ASC, `document_id` ASC, `type_id` ASC, `init` ASC, `end` ASC);


-- -----------------------------------------------------
-- Table `marky`.`questions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `marky`.`questions` ;

CREATE TABLE IF NOT EXISTS `marky`.`questions` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `type_id` INT UNSIGNED NOT NULL,
  `question` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_questions_classes1`
    FOREIGN KEY (`type_id`)
    REFERENCES `marky`.`types` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_questions_classes1_idx` ON `marky`.`questions` (`type_id` ASC);


-- -----------------------------------------------------
-- Table `marky`.`projects_users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `marky`.`projects_users` ;

CREATE TABLE IF NOT EXISTS `marky`.`projects_users` (
  `project_id` INT UNSIGNED NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`project_id`, `user_id`),
  CONSTRAINT `fk_projects_has_users_projects1`
    FOREIGN KEY (`project_id`)
    REFERENCES `marky`.`projects` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_projects_has_users_users1`
    FOREIGN KEY (`user_id`)
    REFERENCES `marky`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_projects_has_users_users1_idx` ON `marky`.`projects_users` (`user_id` ASC);

CREATE INDEX `fk_projects_has_users_projects1_idx` ON `marky`.`projects_users` (`project_id` ASC);


-- -----------------------------------------------------
-- Table `marky`.`annotations_questions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `marky`.`annotations_questions` ;

CREATE TABLE IF NOT EXISTS `marky`.`annotations_questions` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `annotation_id` INT UNSIGNED NOT NULL,
  `question_id` INT UNSIGNED NOT NULL,
  `answer` TEXT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_anotations_has_questions_anotations1`
    FOREIGN KEY (`annotation_id`)
    REFERENCES `marky`.`annotations` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_anotations_has_questions_questions1`
    FOREIGN KEY (`question_id`)
    REFERENCES `marky`.`questions` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_anotations_has_questions_questions1_idx` USING HASH ON `marky`.`annotations_questions` (`question_id` ASC);

CREATE INDEX `fk_anotations_has_questions_anotations1_idx` USING HASH ON `marky`.`annotations_questions` (`annotation_id` ASC);


-- -----------------------------------------------------
-- Table `marky`.`documents_projects`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `marky`.`documents_projects` ;

CREATE TABLE IF NOT EXISTS `marky`.`documents_projects` (
  `document_id` INT UNSIGNED NOT NULL,
  `project_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`document_id`, `project_id`),
  CONSTRAINT `fk_documents_has_projects_documents1`
    FOREIGN KEY (`document_id`)
    REFERENCES `marky`.`documents` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_documents_has_projects_projects1`
    FOREIGN KEY (`project_id`)
    REFERENCES `marky`.`projects` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_documents_has_projects_projects1_idx` ON `marky`.`documents_projects` (`project_id` ASC);

CREATE INDEX `fk_documents_has_projects_documents1_idx` ON `marky`.`documents_projects` (`document_id` ASC);


-- -----------------------------------------------------
-- Table `marky`.`types_rounds`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `marky`.`types_rounds` ;

CREATE TABLE IF NOT EXISTS `marky`.`types_rounds` (
  `round_id` INT UNSIGNED NOT NULL,
  `type_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`round_id`, `type_id`),
  CONSTRAINT `fk_rounds_has_types_rounds1`
    FOREIGN KEY (`round_id`)
    REFERENCES `marky`.`rounds` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_rounds_has_types_types1`
    FOREIGN KEY (`type_id`)
    REFERENCES `marky`.`types` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_rounds_has_types_types1_idx` ON `marky`.`types_rounds` (`type_id` ASC);

CREATE INDEX `fk_rounds_has_types_rounds1_idx` ON `marky`.`types_rounds` (`round_id` ASC);


-- -----------------------------------------------------
-- Table `marky`.`posts`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `marky`.`posts` ;

CREATE TABLE IF NOT EXISTS `marky`.`posts` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED NOT NULL,
  `title` VARCHAR(120) NOT NULL,
  `body` TEXT NOT NULL,
  `created` DATETIME NULL,
  `modified` DATETIME NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_posts_users1`
    FOREIGN KEY (`user_id`)
    REFERENCES `marky`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_posts_users1_idx` ON `marky`.`posts` (`user_id` ASC);


-- -----------------------------------------------------
-- Table `marky`.`consensusAnnotations`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `marky`.`consensusAnnotations` ;

CREATE TABLE IF NOT EXISTS `marky`.`consensusAnnotations` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `round_id` INT UNSIGNED NOT NULL,
  `document_id` INT UNSIGNED NOT NULL,
  `annotation` TEXT NOT NULL,
  `init` INT UNSIGNED NOT NULL,
  `end` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_consensusAnnotations_documents1`
    FOREIGN KEY (`document_id`)
    REFERENCES `marky`.`documents` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_consensusAnnotations_rounds1`
    FOREIGN KEY (`round_id`)
    REFERENCES `marky`.`rounds` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_init_end` ON `marky`.`consensusAnnotations` (`init` ASC, `end` ASC);

CREATE INDEX `fk_consensusAnnotations_documents1_idx` ON `marky`.`consensusAnnotations` (`document_id` ASC);

CREATE INDEX `fk_consensusAnnotations_rounds1_idx` ON `marky`.`consensusAnnotations` (`round_id` ASC);


-- -----------------------------------------------------
-- Table `marky`.`documents_assessments`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `marky`.`documents_assessments` ;

CREATE TABLE IF NOT EXISTS `marky`.`documents_assessments` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `document_id` INT UNSIGNED NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  `project_id` INT UNSIGNED NOT NULL,
  `positive` TINYINT NULL,
  `neutral` TINYINT NULL,
  `negative` TINYINT NULL,
  `about_author` VARCHAR(500) NULL,
  `topic` VARCHAR(500) NULL,
  `note` TEXT NULL,
  PRIMARY KEY (`id`, `document_id`, `user_id`, `project_id`),
  CONSTRAINT `fk_documents_has_users_documents1`
    FOREIGN KEY (`document_id`)
    REFERENCES `marky`.`documents` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_documents_has_users_users1`
    FOREIGN KEY (`user_id`)
    REFERENCES `marky`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_documents_rates_projects1`
    FOREIGN KEY (`project_id`)
    REFERENCES `marky`.`projects` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_documents_has_users_users1_idx` ON `marky`.`documents_assessments` (`user_id` ASC);

CREATE INDEX `fk_documents_has_users_documents1_idx` ON `marky`.`documents_assessments` (`document_id` ASC);

CREATE INDEX `fk_documents_rates_projects1_idx` ON `marky`.`documents_assessments` (`project_id` ASC);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `marky`.`groups`
-- -----------------------------------------------------
START TRANSACTION;
USE `marky`;
INSERT INTO `marky`.`groups` (`id`, `name`) VALUES (1, 'Admin');
INSERT INTO `marky`.`groups` (`id`, `name`) VALUES (2, 'User');

COMMIT;

