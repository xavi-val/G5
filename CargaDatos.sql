CREATE DEFINER=`root`@`%` PROCEDURE `proyecto1`.`TransferirDatos_v2`()
BEGIN
    DECLARE fin INT DEFAULT FALSE;
    DECLARE v_nombre_eleccion, v_pais, v_region, v_departamento, v_municipio,
            v_partido, v_nombre_partido, v_sexo, v_raza VARCHAR(255);
    DECLARE v_ano_eleccion, v_analfabetos, v_alfabetos, v_primaria, v_nivel_medio, v_universitarios INT;
    DECLARE v_id_votos, v_id_raza, v_id_sexo, v_id_eleccion, v_id_zona_municipio INT;

    -- Cursor para los datos de la tabla temporal
    DECLARE cursor_datos CURSOR FOR 
        SELECT Nombre_Eleccion, Ano_Eleccion, Pais, Region, Departamento, Municipio,
               Partido, Nombre_Partido, Sexo, Raza, Analfabetos, Alfabetos, 
               Primaria, Nivel_Medio, Universitarios
        FROM DatosTemporales;

    -- Handler para el final del cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = TRUE;

    START TRANSACTION;

    OPEN cursor_datos;

    transfer_loop: LOOP
        FETCH cursor_datos INTO v_nombre_eleccion, v_ano_eleccion, v_pais, v_region, v_departamento, v_municipio,
            v_partido, v_nombre_partido, v_sexo, v_raza, v_analfabetos, v_alfabetos, 
            v_primaria, v_nivel_medio, v_universitarios;
        IF fin THEN
            LEAVE transfer_loop;
        END IF;
       
       
       -- Zona
        IF NOT EXISTS (SELECT 1 FROM Zona WHERE Nombre = v_pais AND Tipo = 'pais') THEN
            INSERT INTO Zona (Nombre, Tipo) VALUES (v_pais, 'pais');
            SET @id_zona_pais = LAST_INSERT_ID();
        ELSE
            SELECT ID_Zona INTO @id_zona_pais FROM Zona WHERE Nombre = v_pais AND Tipo = 'pais';
        END IF;

        IF NOT EXISTS (SELECT 1 FROM Zona WHERE Nombre = v_region AND Tipo = 'region' AND ID_ZonaPadre = @id_zona_pais) THEN
            INSERT INTO Zona (Nombre, Tipo, ID_ZonaPadre) VALUES (v_region, 'region', @id_zona_pais);
            SET @id_zona_region = LAST_INSERT_ID();
        ELSE
            SELECT ID_Zona INTO @id_zona_region FROM Zona WHERE Nombre = v_region AND Tipo = 'region' AND ID_ZonaPadre = @id_zona_pais;
        END IF;

        IF NOT EXISTS (SELECT 1 FROM Zona WHERE Nombre = v_departamento AND Tipo = 'departamento' AND ID_ZonaPadre = @id_zona_region) THEN
            INSERT INTO Zona (Nombre, Tipo, ID_ZonaPadre) VALUES (v_departamento, 'departamento', @id_zona_region);
            SET @id_zona_departamento = LAST_INSERT_ID();
        ELSE
            SELECT ID_Zona INTO @id_zona_departamento FROM Zona WHERE Nombre = v_departamento AND Tipo = 'departamento' AND ID_ZonaPadre = @id_zona_region;
        END IF;

        IF NOT EXISTS (SELECT 1 FROM Zona WHERE Nombre = v_municipio AND Tipo = 'municipio' AND ID_ZonaPadre = @id_zona_departamento) THEN
            INSERT INTO Zona (Nombre, Tipo, ID_ZonaPadre) VALUES (v_municipio, 'municipio', @id_zona_departamento);
            SET @id_zona_municipio = LAST_INSERT_ID();
        ELSE
            SELECT ID_Zona INTO @id_zona_municipio FROM Zona WHERE Nombre = v_municipio AND Tipo = 'municipio' AND ID_ZonaPadre = @id_zona_departamento;
        END IF;

         -- Eleccion
        IF NOT EXISTS (SELECT 1 FROM Eleccion WHERE Nombre_Eleccion = v_nombre_eleccion AND Ano_Eleccion = v_ano_eleccion AND ID_Zona = @id_zona_municipio) THEN
            INSERT INTO Eleccion (Nombre_Eleccion, Ano_Eleccion, ID_Zona) VALUES (v_nombre_eleccion, v_ano_eleccion, @id_zona_municipio);
            SET @id_eleccion = LAST_INSERT_ID();
        ELSE
            SELECT ID_Eleccion INTO @id_eleccion FROM Eleccion WHERE Nombre_Eleccion = v_nombre_eleccion AND Ano_Eleccion = v_ano_eleccion AND ID_Zona = @id_zona_municipio;
        END IF;
        
        -- PartidoPolitico        
		IF NOT EXISTS (SELECT 1 FROM PartidoPolitico WHERE Nombre_Partido = v_nombre_partido AND Acronimo = v_partido) THEN
		    INSERT INTO PartidoPolitico (Nombre_Partido, Acronimo) VALUES (v_nombre_partido, v_partido);
		    SET @id_partido = LAST_INSERT_ID();
		ELSE
		    SELECT ID_Partido INTO @id_partido FROM PartidoPolitico WHERE Nombre_Partido = v_nombre_partido AND Acronimo = v_partido;
		END IF;

		-- Sexo
        IF NOT EXISTS (SELECT 1 FROM Sexo WHERE Descripcion = v_sexo) THEN
            INSERT INTO Sexo (Descripcion) VALUES (v_sexo);
            SET v_id_sexo = LAST_INSERT_ID();
        ELSE
            SELECT ID_Sexo INTO v_id_sexo FROM Sexo WHERE Descripcion = v_sexo;
        END IF;

        -- Raza
        IF NOT EXISTS (SELECT 1 FROM Raza WHERE Raza = v_raza) THEN
            INSERT INTO Raza (Raza) VALUES (v_raza);
            SET v_id_raza = LAST_INSERT_ID();
        ELSE
            SELECT ID_Raza INTO v_id_raza FROM Raza WHERE Raza = v_raza;
        END IF;

        -- Votos
        INSERT INTO Votos (Analfabetos, Primaria, Nivel_Medio, Universitarios) VALUES (v_analfabetos, v_primaria, v_nivel_medio, v_universitarios);
        SET v_id_votos = LAST_INSERT_ID();

        -- Resultado
        INSERT INTO Resultado (ID_Eleccion, ID_Partido, ID_Raza, ID_Votos, ID_Sexo) 
        VALUES (@id_eleccion, @id_partido, v_id_raza, v_id_votos, v_id_sexo);

    END LOOP;

    CLOSE cursor_datos;
    COMMIT;
END