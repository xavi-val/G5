-- proyecto1.Eleccion definition

CREATE TABLE `Eleccion` (
  `ID_Eleccion` int NOT NULL AUTO_INCREMENT,
  `Nombre_Eleccion` varchar(255) DEFAULT NULL,
  `Ano_Eleccion` int DEFAULT NULL,
  `ID_Zona` int DEFAULT NULL,
  PRIMARY KEY (`ID_Eleccion`),
  KEY `fk_zona_eleccion` (`ID_Zona`),
  CONSTRAINT `fk_zona_eleccion` FOREIGN KEY (`ID_Zona`) REFERENCES `Zona` (`ID_Zona`)
) ENGINE=InnoDB AUTO_INCREMENT=1171 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- proyecto1.Zona definition

CREATE TABLE `Zona` (
  `ID_Zona` int NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(255) DEFAULT NULL,
  `ID_ZonaPadre` int DEFAULT NULL,
  `Tipo` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID_Zona`),
  KEY `fk_zona_padre` (`ID_ZonaPadre`),
  CONSTRAINT `fk_zona_padre` FOREIGN KEY (`ID_ZonaPadre`) REFERENCES `Zona` (`ID_Zona`)
) ENGINE=InnoDB AUTO_INCREMENT=1280 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- proyecto1.PartidoPolitico definition

CREATE TABLE `PartidoPolitico` (
  `ID_Partido` int NOT NULL AUTO_INCREMENT,
  `Nombre_Partido` varchar(255) DEFAULT NULL,
  `Acronimo` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ID_Partido`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- proyecto1.Raza definition

CREATE TABLE `Raza` (
  `ID_Raza` int NOT NULL AUTO_INCREMENT,
  `Raza` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID_Raza`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- proyecto1.Votos definition

CREATE TABLE `Votos` (
  `ID_Votos` int NOT NULL AUTO_INCREMENT,
  `Analfabetos` bigint DEFAULT NULL,
  `Primaria` bigint DEFAULT NULL,
  `Nivel_Medio` bigint DEFAULT NULL,
  `Universitarios` bigint DEFAULT NULL,
  PRIMARY KEY (`ID_Votos`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- proyecto1.Resultado definition

CREATE TABLE `Resultado` (
  `ID_Resultado` int NOT NULL AUTO_INCREMENT,
  `ID_Eleccion` int DEFAULT NULL,
  `ID_Partido` int DEFAULT NULL,
  `ID_Raza` int DEFAULT NULL,
  `ID_Votos` int DEFAULT NULL,
  PRIMARY KEY (`ID_Resultado`),
  KEY `fk_eleccion_resultado` (`ID_Eleccion`),
  KEY `fk_partido_resultado` (`ID_Partido`),
  KEY `fk_clasificacion_resultado` (`ID_Raza`),
  KEY `fk_votos_resultado` (`ID_Votos`),
  CONSTRAINT `fk_clasificacion_resultado` FOREIGN KEY (`ID_Raza`) REFERENCES `Raza` (`ID_Raza`),
  CONSTRAINT `fk_eleccion_resultado` FOREIGN KEY (`ID_Eleccion`) REFERENCES `Eleccion` (`ID_Eleccion`),
  CONSTRAINT `fk_partido_resultado` FOREIGN KEY (`ID_Partido`) REFERENCES `PartidoPolitico` (`ID_Partido`),
  CONSTRAINT `fk_votos_resultado` FOREIGN KEY (`ID_Votos`) REFERENCES `Votos` (`ID_Votos`)
) ENGINE=InnoDB AUTO_INCREMENT=20971 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



CREATE TABLE `Sexo` (
  `ID_Sexo` int NOT NULL AUTO_INCREMENT,
  `Descripcion` varchar(50) NOT NULL,
  PRIMARY KEY (`ID_Sexo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;






















