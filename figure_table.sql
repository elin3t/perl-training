CREATE TABLE `figure` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `figure_color` varchar(45) DEFAULT NULL,
  `figure_type` varchar(45) DEFAULT NULL,
  `figure_points` varchar(255) DEFAULT NULL,
  `radio` decimal(10,0) DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `FIGURE_TYPE` (`figure_type` ASC))
ENGINE = InnoDB