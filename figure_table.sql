CREATE TABLE IF NOT EXISTS `figures`.`figure` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `figure_color` VARCHAR(45) NULL,
  `figure_type` VARCHAR(45) NULL,
  `figure_points` MULTIPOINT NULL,
  `radio` DECIMAL(10,0) NULL,
  PRIMARY KEY (`id`),
  INDEX `FIGURE_TYPE` (`figure_type` ASC))
ENGINE = InnoDB