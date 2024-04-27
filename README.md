# Documentación

# Identificación de Entidades

Se han identificado las siguientes principales entidades involucradas en la base de datos de elecciones, cada una con su propósito específico y su contribución al conjunto de datos global.

 ### Entidades Principales

### Elección
- **Descripción:** Almacena información sobre cada elección.
- **Detalles Importantes:** Incluye datos como el nombre de la elección, el año en que se lleva a cabo y los enlaces a las zonas geográficas relevantes.

### Zona
- **Descripción:** Contiene detalles geográficos relevantes para las elecciones.
- **Detalles Importantes:** Incluye el país, región, departamento y municipio.

### Partido Político
- **Descripción:** Proporciona información sobre los partidos políticos que participan en las elecciones.
- **Detalles Importantes:** Incluye nombres de los partidos, acrónimos y otras descripciones relevantes.

### Raza
- **Descripción:** Clasifica a los votantes en grupos étnicos específicos.
- **Detalles Importantes:** Ayuda en el análisis demográfico y en la segmentación de los votos según las etnias.

### Votos
- **Descripción:** Detalla los votos segmentados por nivel educativo.
- **Detalles Importantes:** Incluye categorías como votos de analfabetos, votos de personas con educación primaria, secundaria y universitaria.

### Sexo
- **Descripción:** Clasifica a los votantes por sexo.
- **Detalles Importantes:** Utilizado para análisis demográficos y estadísticas de votación segmentadas por género.




## Entidades y Atributos

### 1. Elección
-- **ID_Elección (PK)**: Identificador único para cada elección, tipo entero (int), autoincremental.
-- **Nombre_Elección**: Nombre descriptivo de la elección, tipo cadena de caracteres (varchar 255).
-- **Año_Elección**: Año en que se realiza la elección (int).
-- **ID_Zona (FK)**: Clave foránea que referencia al identificador de la zona (ID_Zona) en la tabla Zona, tipo entero (int).
- **Descripción**: Define cada elección, vinculándola a todos los niveles geográficos relevantes, desde el municipio hasta el país.

### 2. Zona
-- **ID_Zona (PK)**: Identificador único para cada zona, tipo entero (int), autoincremental.
-- **Nombre**: Nombre de la zona, tipo cadena de caracteres (varchar 255).
-- **ID_ZonaPadre (FK)**: Identificador de la zona padre, tipo entero (int). Este campo puede ser null si la zona es un país.
-- **Tipo**: Define el nivel de la zona (país, región, departamento, municipio), tipo cadena de caracteres (varchar) con un máximo de 50 caracteres.
- **Descripción**: Representa las distintas divisiones geográficas.

### 3. Partido Político
-- **ID_Partido (PK)**: Identificador único para cada partido político, tipo entero (int), autoincremental.
-- **Nombre_Partido**: Nombre completo del partido político, tipo cadena de caracteres (varchar) con un máximo de 255 caracteres.
-- **Acronimo**: Acrónimo representativo del partido, tipo cadena de caracteres (varchar 100).
- **Descripción**: Contiene la información referente a los partidos políticos que participan en las elecciones.

### 4. Raza
-- **ID_Raza (PK)**: Identificador único para cada grupo étnico, tipo entero (int), autoincremental.
-- **Raza**: Nombre del grupo étnico, tipo cadena de caracteres (varchar 255).
- **Descripción**: Clasifica los grupos étnicos de los votantes en las elecciones.

### 5. Votos
-- **ID_Votos (PK)**: Identificador único para cada conjunto de votos, tipo entero (int), autoincremental.
-- **Analfabetos**: Número de votos provenientes de personas analfabetas, tipo numérico grande (bigint).
-- **Primaria**: Número de votos de personas con educación primaria, tipo numérico grande (bigint).
-- **Nivel_Medio**: Número de votos de personas con educación de nivel medio, tipo numérico grande (bigint).
-- **Universitarios**: Número de votos de personas con educación universitaria, tipo numérico grande (bigint).
- **Descripción**: Almacena la información sobre los votos segmentados por el nivel educativo de los votantes.

### 6. Sexo
-- **ID_Sexo (PK)**: Identificador único para cada clasificación de sexo, tipo entero (int), autoincremental.
-- **Descripcion: Descripción del sexo (ejemplo: Masculino, Femenino), tipo cadena de caracteres (varchar) con un máximo de 50 caracteres.**{

- **Descripcion**: Descripción del sexo (ejemplo: Masculino, Femenino), tipo cadena de caracteres (varchar) con un máximo de 50 caracteres.


# Reglas de Normalización para la Base de Datos de Elecciones

## Objetivos y Transformaciones Aplicadas

### 1. Primera Forma Normal (1NF)
**Objetivo:** Eliminar los grupos repetitivos en tablas individuales, crear una tabla separada para cada conjunto de datos relacionados y asignar una clave primaria única a cada tabla.
- **Datos originales:** Toda la información está en una única tabla con columnas repetidas para Sexo y Raza.
- **Transformación:** Se separaron los datos en múltiples tablas (Eleccion, Zona, Partido Politico, Raza, Votos, Sexo) con sus propios atributos específicos. Cada tabla tiene una clave primaria (ID_Elección, ID_Zona, ID_Partido, etc.) que garantiza la unicidad de cada fila.

### 2. Segunda Forma Normal (2NF)
**Objetivo:** Asegurarse de que cada atributo “no clave” de la tabla sea funcionalmente dependiente de la totalidad de la clave primaria.
- **Datos originales:** Atributos como el nombre del partido, raza o datos de votos estaban mezclados con otros datos, creando dependencias parciales.
- **Transformación:** Los atributos específicos que dependen de una parte de la clave primaria se movieron a nuevas tablas. Por ejemplo, los datos de votos se segmentaron en una tabla “Votos” donde cada tipo de voto es funcionalmente dependiente solo de ID_Votos.

### 3. Tercera Forma Normal (3NF)
**Objetivo:** Asegurarse de que los atributos no clave de una tabla no tengan dependencias entre sí.
- **Datos originales:** Los campos como Nombre_Partido y Acronimo que son dependientes entre sí estaban en la misma tabla.
- **Transformación:** Creación de la tabla Partido Politico con Nombre_Partido y Acronimo que elimina dependencias transitivas, ya que estos datos solo dependen de ID_Partido.

### 4. Forma Normal de Boyce-Codd (BCNF)
**Objetivo:** Reforzar aún más las reglas de la 3NF cuando hay múltiples candidatos a clave primaria.
- **Transformación:** Las claves primarias y foráneas fueron cuidadosamente asignadas para asegurar que cada tabla esté en BCNF, donde cada determinante es una superclave.

## Implementaciones Adicionales
- **Integridad Referencial:** Las claves foráneas (por ejemplo, ID_Zona en Eleccion refiere a Zona) se implementaron para mantener la consistencia entre las tablas.
- **Jerarquía de Zonas:** La tabla Zona utiliza un campo ID_ZonaPadre para crear una relación jerárquica, lo que quiere decir cada zona excepto 'país' tiene un 'ID_ZonaPadre' que refiere a su nivel superior (por ejemplo, un departamento refiere a una región).


# Modelo entidad - relación

![](https://github.com/y0naldez/PythonBasico/blob/main/WhatsApp%20Image%202024-04-26%20at%2011.20.48%20PM.jpeg)