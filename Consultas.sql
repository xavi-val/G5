
-- proyecto1.reporte1 source

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `reporte1` AS with `votos_por_pais` as (
select
    `elec`.`Nombre_Eleccion` AS `Nombre_Eleccion`,
    `elec`.`Ano_Eleccion` AS `Ano_Eleccion`,
    `pais`.`Nombre` AS `Pais`,
    sum((((`v`.`Analfabetos` + `v`.`Primaria`) + `v`.`Nivel_Medio`) + `v`.`Universitarios`)) AS `suma_votos`
from
    (((((((`Resultado` `res`
join `Eleccion` `elec` on
    ((`elec`.`ID_Eleccion` = `res`.`ID_Eleccion`)))
join `Zona` `mun` on
    ((`elec`.`ID_Zona` = `mun`.`ID_Zona`)))
join `Zona` `dep` on
    ((`mun`.`ID_ZonaPadre` = `dep`.`ID_Zona`)))
join `Zona` `reg` on
    ((`dep`.`ID_ZonaPadre` = `reg`.`ID_Zona`)))
join `Zona` `pais` on
    ((`reg`.`ID_ZonaPadre` = `pais`.`ID_Zona`)))
join `PartidoPolitico` `pp` on
    ((`pp`.`ID_Partido` = `res`.`ID_Partido`)))
join `Votos` `v` on
    ((`v`.`ID_Votos` = `res`.`ID_Votos`)))
group by
    `elec`.`Nombre_Eleccion`,
    `elec`.`Ano_Eleccion`,
    `pais`.`Nombre`),
`votos_por_partido` as (
select
    `elec`.`Nombre_Eleccion` AS `Nombre_Eleccion`,
    `elec`.`Ano_Eleccion` AS `Ano_Eleccion`,
    `pp`.`Nombre_Partido` AS `Nombre_Partido`,
    `pais`.`Nombre` AS `Pais`,
    sum((((`v`.`Analfabetos` + `v`.`Primaria`) + `v`.`Nivel_Medio`) + `v`.`Universitarios`)) AS `suma_votos`
from
    (((((((`Resultado` `res`
join `Eleccion` `elec` on
    ((`elec`.`ID_Eleccion` = `res`.`ID_Eleccion`)))
join `Zona` `mun` on
    ((`elec`.`ID_Zona` = `mun`.`ID_Zona`)))
join `Zona` `dep` on
    ((`mun`.`ID_ZonaPadre` = `dep`.`ID_Zona`)))
join `Zona` `reg` on
    ((`dep`.`ID_ZonaPadre` = `reg`.`ID_Zona`)))
join `Zona` `pais` on
    ((`reg`.`ID_ZonaPadre` = `pais`.`ID_Zona`)))
join `PartidoPolitico` `pp` on
    ((`pp`.`ID_Partido` = `res`.`ID_Partido`)))
join `Votos` `v` on
    ((`v`.`ID_Votos` = `res`.`ID_Votos`)))
group by
    `elec`.`Nombre_Eleccion`,
    `elec`.`Ano_Eleccion`,
    `pp`.`Nombre_Partido`,
    `pais`.`Nombre`),
`porcentaje_votos` as (
select
    `votos_por_partido`.`Nombre_Eleccion` AS `Nombre_Eleccion`,
    `votos_por_partido`.`Ano_Eleccion` AS `Ano_Eleccion`,
    `votos_por_partido`.`Nombre_Partido` AS `Nombre_Partido`,
    `votos_por_partido`.`Pais` AS `Pais`,
    round(((`votos_por_partido`.`suma_votos` / `votos_por_pais`.`suma_votos`) * 100), 6) AS `porcentaje`
from
    (`votos_por_pais`
join `votos_por_partido` on
    (((`votos_por_partido`.`Nombre_Eleccion` = `votos_por_pais`.`Nombre_Eleccion`)
        and (`votos_por_partido`.`Ano_Eleccion` = `votos_por_pais`.`Ano_Eleccion`)
            and (`votos_por_partido`.`Pais` = `votos_por_pais`.`Pais`))))),
`mejores_por_pais` as (
select
    `pv`.`Pais` AS `Pais`,
    max(`pv`.`porcentaje`) AS `Mayor_Porcentaje_Votos`
from
    `porcentaje_votos` `pv`
group by
    `pv`.`Pais`)
select
    `pv`.`Nombre_Eleccion` AS `Nombre_Eleccion`,
    `pv`.`Ano_Eleccion` AS `Ano_Eleccion`,
    `pv`.`Pais` AS `Pais`,
    `pv`.`Nombre_Partido` AS `Nombre_Partido`,
    `pv`.`porcentaje` AS `porcentaje`
from
    (`porcentaje_votos` `pv`
join `mejores_por_pais` `mp` on
    (((`pv`.`Pais` = `mp`.`Pais`)
        and (`pv`.`porcentaje` = `mp`.`Mayor_Porcentaje_Votos`))))
order by
    `pv`.`Pais`,
    `pv`.`Ano_Eleccion`;


-- proyecto1.reporte2 source

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `reporte2` AS with `votos_mujeres_por_pais` as (
select
    `elec`.`Nombre_Eleccion` AS `Nombre_Eleccion`,
    `elec`.`Ano_Eleccion` AS `Ano_Eleccion`,
    `pais`.`Nombre` AS `Pais`,
    sum((((`v`.`Analfabetos` + `v`.`Primaria`) + `v`.`Nivel_Medio`) + `v`.`Universitarios`)) AS `total_votos`
from
    (((((((`Resultado` `res`
join `Eleccion` `elec` on
    ((`elec`.`ID_Eleccion` = `res`.`ID_Eleccion`)))
join `Zona` `mun` on
    ((`elec`.`ID_Zona` = `mun`.`ID_Zona`)))
join `Zona` `dep` on
    ((`mun`.`ID_ZonaPadre` = `dep`.`ID_Zona`)))
join `Zona` `reg` on
    ((`dep`.`ID_ZonaPadre` = `reg`.`ID_Zona`)))
join `Zona` `pais` on
    ((`reg`.`ID_ZonaPadre` = `pais`.`ID_Zona`)))
join `Sexo` `s` on
    ((`s`.`ID_Sexo` = `res`.`ID_Sexo`)))
join `Votos` `v` on
    ((`v`.`ID_Votos` = `res`.`ID_Votos`)))
where
    (`s`.`Descripcion` = 'mujeres')
group by
    `elec`.`Nombre_Eleccion`,
    `elec`.`Ano_Eleccion`,
    `pais`.`Nombre`),
`votos_mujeres_por_departamento` as (
select
    `elec`.`Nombre_Eleccion` AS `Nombre_Eleccion`,
    `elec`.`Ano_Eleccion` AS `Ano_Eleccion`,
    `dep`.`Nombre` AS `Departamento`,
    `pais`.`Nombre` AS `Pais`,
    sum((((`v`.`Analfabetos` + `v`.`Primaria`) + `v`.`Nivel_Medio`) + `v`.`Universitarios`)) AS `total_votos`
from
    (((((((`Resultado` `res`
join `Eleccion` `elec` on
    ((`elec`.`ID_Eleccion` = `res`.`ID_Eleccion`)))
join `Zona` `mun` on
    ((`elec`.`ID_Zona` = `mun`.`ID_Zona`)))
join `Zona` `dep` on
    ((`mun`.`ID_ZonaPadre` = `dep`.`ID_Zona`)))
join `Zona` `reg` on
    ((`dep`.`ID_ZonaPadre` = `reg`.`ID_Zona`)))
join `Zona` `pais` on
    ((`reg`.`ID_ZonaPadre` = `pais`.`ID_Zona`)))
join `Sexo` `s` on
    ((`s`.`ID_Sexo` = `res`.`ID_Sexo`)))
join `Votos` `v` on
    ((`v`.`ID_Votos` = `res`.`ID_Votos`)))
where
    (`s`.`Descripcion` = 'mujeres')
group by
    `elec`.`Nombre_Eleccion`,
    `elec`.`Ano_Eleccion`,
    `dep`.`Nombre`,
    `pais`.`Nombre`)
select
    `vmd`.`Nombre_Eleccion` AS `Nombre_Eleccion`,
    `vmd`.`Ano_Eleccion` AS `Ano_Eleccion`,
    `vmd`.`Pais` AS `Pais`,
    `vmd`.`Departamento` AS `Departamento`,
    `vmd`.`total_votos` AS `total_votos`,
    round(((`vmd`.`total_votos` / `vmp`.`total_votos`) * 100), 2) AS `porcentaje_votos`
from
    (`votos_mujeres_por_departamento` `vmd`
join `votos_mujeres_por_pais` `vmp` on
    ((`vmp`.`Pais` = `vmd`.`Pais`)));



-- proyecto1.reporte3 source

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `reporte3` AS with `votos_por_partido` as (
select
    `elec`.`Nombre_Eleccion` AS `Nombre_Eleccion`,
    `elec`.`Ano_Eleccion` AS `Ano_Eleccion`,
    `pp`.`Nombre_Partido` AS `Nombre_Partido`,
    `pais`.`Nombre` AS `Pais`,
    `mun`.`Nombre` AS `Municipio`,
    sum((((`v`.`Analfabetos` + `v`.`Primaria`) + `v`.`Nivel_Medio`) + `v`.`Universitarios`)) AS `suma_votos`
from
    (((((((`Resultado` `res`
join `Eleccion` `elec` on
    ((`elec`.`ID_Eleccion` = `res`.`ID_Eleccion`)))
join `Zona` `mun` on
    ((`elec`.`ID_Zona` = `mun`.`ID_Zona`)))
join `Zona` `dep` on
    ((`mun`.`ID_ZonaPadre` = `dep`.`ID_Zona`)))
join `Zona` `reg` on
    ((`dep`.`ID_ZonaPadre` = `reg`.`ID_Zona`)))
join `Zona` `pais` on
    ((`reg`.`ID_ZonaPadre` = `pais`.`ID_Zona`)))
join `PartidoPolitico` `pp` on
    ((`pp`.`ID_Partido` = `res`.`ID_Partido`)))
join `Votos` `v` on
    ((`v`.`ID_Votos` = `res`.`ID_Votos`)))
group by
    `elec`.`Nombre_Eleccion`,
    `elec`.`Ano_Eleccion`,
    `pp`.`Nombre_Partido`,
    `pais`.`Nombre`,
    `mun`.`Nombre`),
`votos_maximos_por_municipio` as (
select
    `vpp`.`Nombre_Eleccion` AS `Nombre_Eleccion`,
    `vpp`.`Ano_Eleccion` AS `Ano_Eleccion`,
    `vpp`.`Pais` AS `Pais`,
    `vpp`.`Municipio` AS `Municipio`,
    max(`vpp`.`suma_votos`) AS `Ganador`
from
    `votos_por_partido` `vpp`
group by
    `vpp`.`Nombre_Eleccion`,
    `vpp`.`Ano_Eleccion`,
    `vpp`.`Pais`,
    `vpp`.`Municipio`),
`ganadores_por_municipio` as (
select
    `vpp`.`Nombre_Eleccion` AS `Nombre_Eleccion`,
    `vpp`.`Ano_Eleccion` AS `Ano_Eleccion`,
    `vpp`.`Nombre_Partido` AS `Nombre_Partido`,
    `vpp`.`Pais` AS `Pais`,
    `vpp`.`Municipio` AS `Municipio`,
    `vpp`.`suma_votos` AS `suma_votos`
from
    (`votos_por_partido` `vpp`
join `votos_maximos_por_municipio` `vmpm` on
    (((`vmpm`.`Nombre_Eleccion` = `vpp`.`Nombre_Eleccion`)
        and (`vmpm`.`Ano_Eleccion` = `vpp`.`Ano_Eleccion`)
            and (`vmpm`.`Pais` = `vpp`.`Pais`)
                and (`vmpm`.`Municipio` = `vpp`.`Municipio`)
                    and (`vmpm`.`Ganador` = `vpp`.`suma_votos`)))))
select
    `gpm`.`Pais` AS `Pais`,
    `gpm`.`Nombre_Partido` AS `Nombre_Partido`,
    (
    select
        count(0)
    from
        `ganadores_por_municipio` `gpm2`
    where
        (`gpm2`.`Nombre_Partido` = `gpm`.`Nombre_Partido`)) AS `cantidad_alcaldias_ganadas`
from
    `ganadores_por_municipio` `gpm`
group by
    `gpm`.`Pais`,
    `gpm`.`Nombre_Partido`
order by
    `gpm`.`Pais`;




-- proyecto1.reporte4 source

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `reporte4` AS with `VotosPorRaza` as (
select
    `zp`.`Nombre` AS `Pais`,
    `zr`.`Nombre` AS `Region`,
    `rz`.`Raza` AS `Raza`,
    sum((((`v`.`Analfabetos` + `v`.`Primaria`) + `v`.`Nivel_Medio`) + `v`.`Universitarios`)) AS `TotalVotos`
from
    (((((((`Resultado` `r`
join `Eleccion` `e` on
    ((`e`.`ID_Eleccion` = `r`.`ID_Eleccion`)))
join `Votos` `v` on
    ((`v`.`ID_Votos` = `r`.`ID_Votos`)))
join `Raza` `rz` on
    ((`rz`.`ID_Raza` = `r`.`ID_Raza`)))
join `Zona` `zm` on
    ((`zm`.`ID_Zona` = `e`.`ID_Zona`)))
join `Zona` `zd` on
    ((`zd`.`ID_Zona` = `zm`.`ID_ZonaPadre`)))
join `Zona` `zr` on
    ((`zr`.`ID_Zona` = `zd`.`ID_ZonaPadre`)))
join `Zona` `zp` on
    ((`zp`.`ID_Zona` = `zr`.`ID_ZonaPadre`)))
where
    (`zm`.`Tipo` = 'municipio')
group by
    `zp`.`Nombre`,
    `zr`.`Nombre`,
    `rz`.`Raza`),
`MaxVotosPorRegion` as (
select
    `VotosPorRaza`.`Pais` AS `Pais`,
    `VotosPorRaza`.`Region` AS `Region`,
    max(`VotosPorRaza`.`TotalVotos`) AS `MaxVotos`
from
    `VotosPorRaza`
group by
    `VotosPorRaza`.`Pais`,
    `VotosPorRaza`.`Region`),
`RegionesConPredominanciaIndigena` as (
select
    `vpr`.`Pais` AS `Pais`,
    `vpr`.`Region` AS `Region`
from
    (`VotosPorRaza` `vpr`
join `MaxVotosPorRegion` `mvr` on
    (((`mvr`.`Pais` = `vpr`.`Pais`)
        and (`mvr`.`Region` = `vpr`.`Region`)
            and (`mvr`.`MaxVotos` = `vpr`.`TotalVotos`))))
where
    (`vpr`.`Raza` = 'INDIGENAS'))
select
    `RegionesConPredominanciaIndigena`.`Pais` AS `Pais`,
    `RegionesConPredominanciaIndigena`.`Region` AS `Region`
from
    `RegionesConPredominanciaIndigena`;



-- proyecto1.reporte5 source

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `reporte5` AS with `total_votos_por_departamento` as (
select
    `elec`.`Nombre_Eleccion` AS `Nombre_Eleccion`,
    `elec`.`Ano_Eleccion` AS `Ano_Eleccion`,
    `dep`.`Nombre` AS `Departamento`,
    `pais`.`Nombre` AS `Pais`,
    sum(`v`.`Universitarios`) AS `total_votos`
from
    (((((((`Resultado` `res`
join `Eleccion` `elec` on
    ((`elec`.`ID_Eleccion` = `res`.`ID_Eleccion`)))
join `Zona` `mun` on
    ((`elec`.`ID_Zona` = `mun`.`ID_Zona`)))
join `Zona` `dep` on
    ((`mun`.`ID_ZonaPadre` = `dep`.`ID_Zona`)))
join `Zona` `reg` on
    ((`dep`.`ID_ZonaPadre` = `reg`.`ID_Zona`)))
join `Zona` `pais` on
    ((`reg`.`ID_ZonaPadre` = `pais`.`ID_Zona`)))
join `Sexo` `s` on
    ((`s`.`ID_Sexo` = `res`.`ID_Sexo`)))
join `Votos` `v` on
    ((`v`.`ID_Votos` = `res`.`ID_Votos`)))
group by
    `elec`.`Nombre_Eleccion`,
    `elec`.`Ano_Eleccion`,
    `dep`.`Nombre`,
    `pais`.`Nombre`),
`votos_hombres_por_departamento` as (
select
    `elec`.`Nombre_Eleccion` AS `Nombre_Eleccion`,
    `elec`.`Ano_Eleccion` AS `Ano_Eleccion`,
    `dep`.`Nombre` AS `Departamento`,
    `pais`.`Nombre` AS `Pais`,
    sum(`v`.`Universitarios`) AS `total_votos`
from
    (((((((`Resultado` `res`
join `Eleccion` `elec` on
    ((`elec`.`ID_Eleccion` = `res`.`ID_Eleccion`)))
join `Zona` `mun` on
    ((`elec`.`ID_Zona` = `mun`.`ID_Zona`)))
join `Zona` `dep` on
    ((`mun`.`ID_ZonaPadre` = `dep`.`ID_Zona`)))
join `Zona` `reg` on
    ((`dep`.`ID_ZonaPadre` = `reg`.`ID_Zona`)))
join `Zona` `pais` on
    ((`reg`.`ID_ZonaPadre` = `pais`.`ID_Zona`)))
join `Sexo` `s` on
    ((`s`.`ID_Sexo` = `res`.`ID_Sexo`)))
join `Votos` `v` on
    ((`v`.`ID_Votos` = `res`.`ID_Votos`)))
where
    (`s`.`Descripcion` = 'hombres')
group by
    `elec`.`Nombre_Eleccion`,
    `elec`.`Ano_Eleccion`,
    `dep`.`Nombre`,
    `pais`.`Nombre`),
`votos_mujeres_por_departamento` as (
select
    `elec`.`Nombre_Eleccion` AS `Nombre_Eleccion`,
    `elec`.`Ano_Eleccion` AS `Ano_Eleccion`,
    `dep`.`Nombre` AS `Departamento`,
    `pais`.`Nombre` AS `Pais`,
    sum(`v`.`Universitarios`) AS `total_votos`
from
    (((((((`Resultado` `res`
join `Eleccion` `elec` on
    ((`elec`.`ID_Eleccion` = `res`.`ID_Eleccion`)))
join `Zona` `mun` on
    ((`elec`.`ID_Zona` = `mun`.`ID_Zona`)))
join `Zona` `dep` on
    ((`mun`.`ID_ZonaPadre` = `dep`.`ID_Zona`)))
join `Zona` `reg` on
    ((`dep`.`ID_ZonaPadre` = `reg`.`ID_Zona`)))
join `Zona` `pais` on
    ((`reg`.`ID_ZonaPadre` = `pais`.`ID_Zona`)))
join `Sexo` `s` on
    ((`s`.`ID_Sexo` = `res`.`ID_Sexo`)))
join `Votos` `v` on
    ((`v`.`ID_Votos` = `res`.`ID_Votos`)))
where
    (`s`.`Descripcion` = 'mujeres')
group by
    `elec`.`Nombre_Eleccion`,
    `elec`.`Ano_Eleccion`,
    `dep`.`Nombre`,
    `pais`.`Nombre`),
`porcentaje_votos` as (
select
    `tvpd`.`Nombre_Eleccion` AS `Nombre_Eleccion`,
    `tvpd`.`Ano_Eleccion` AS `Ano_Eleccion`,
    `tvpd`.`Pais` AS `Pais`,
    `tvpd`.`Departamento` AS `Departamento`,
    round(((`vmd`.`total_votos` / `tvpd`.`total_votos`) * 100), 2) AS `porcentaje_votos_mujeres_universitarias`,
    round(((`vhd`.`total_votos` / `tvpd`.`total_votos`) * 100), 2) AS `porcentaje_votos_hombres_universitarias`
from
    ((`total_votos_por_departamento` `tvpd`
join `votos_mujeres_por_departamento` `vmd` on
    (((`vmd`.`Pais` = `tvpd`.`Pais`)
        and (`vmd`.`Departamento` = `tvpd`.`Departamento`))))
join `votos_hombres_por_departamento` `vhd` on
    (((`vhd`.`Pais` = `tvpd`.`Pais`)
        and (`vhd`.`Departamento` = `tvpd`.`Departamento`)))))
select
    `pv`.`Nombre_Eleccion` AS `Nombre_Eleccion`,
    `pv`.`Ano_Eleccion` AS `Ano_Eleccion`,
    `pv`.`Pais` AS `Pais`,
    `pv`.`Departamento` AS `Departamento`,
    `pv`.`porcentaje_votos_mujeres_universitarias` AS `porcentaje_votos_mujeres_universitarias`,
    `pv`.`porcentaje_votos_hombres_universitarias` AS `porcentaje_votos_hombres_universitarias`
from
    `porcentaje_votos` `pv`
where
    (`pv`.`porcentaje_votos_mujeres_universitarias` > `pv`.`porcentaje_votos_hombres_universitarias`)
order by
    `pv`.`Pais`;



-- proyecto1.reporte6 source

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `reporte6` AS
select
    `pais`.`Nombre` AS `Pais`,
    `region`.`Nombre` AS `Region`,
    `sub_region`.`Total` AS `Total_Region`,
    `sub_region_depto`.`Total` AS `Total_Deptos`,
    (`sub_region`.`Total` / `sub_region_depto`.`Total`) AS `Promedio`
from
    ((((((((`Resultado` `res`
join `Votos` `v` on
    ((`res`.`ID_Votos` = `v`.`ID_Votos`)))
join `Eleccion` `eleccion` on
    ((`res`.`ID_Eleccion` = `eleccion`.`ID_Eleccion`)))
join `Zona` `municipio` on
    ((`eleccion`.`ID_Zona` = `municipio`.`ID_Zona`)))
join `Zona` `provincia` on
    ((`municipio`.`ID_ZonaPadre` = `provincia`.`ID_Zona`)))
join `Zona` `region` on
    ((`provincia`.`ID_ZonaPadre` = `region`.`ID_Zona`)))
join `Zona` `pais` on
    ((`region`.`ID_ZonaPadre` = `pais`.`ID_Zona`)))
join (
    select
        `region`.`ID_Zona` AS `ID_Zona`,
        count(`provincia`.`Nombre`) AS `Total`
    from
        ((`Zona` `provincia`
    join `Zona` `region` on
        ((`provincia`.`ID_ZonaPadre` = `region`.`ID_Zona`)))
    join `Zona` `pais` on
        ((`region`.`ID_ZonaPadre` = `pais`.`ID_Zona`)))
    where
        (`pais`.`Tipo` = 'pais')
    group by
        `region`.`ID_Zona`) `sub_region_depto` on
    ((`region`.`ID_Zona` = `sub_region_depto`.`ID_Zona`)))
join (
    select
        `region`.`ID_Zona` AS `ID_Zona`,
        sum((((`v`.`Analfabetos` + `v`.`Primaria`) + `v`.`Nivel_Medio`) + `v`.`Universitarios`)) AS `Total`
    from
        ((((((`Resultado` `res`
    join `Votos` `v` on
        ((`res`.`ID_Votos` = `v`.`ID_Votos`)))
    join `Eleccion` `eleccion` on
        ((`res`.`ID_Eleccion` = `eleccion`.`ID_Eleccion`)))
    join `Zona` `municipio` on
        ((`eleccion`.`ID_Zona` = `municipio`.`ID_Zona`)))
    join `Zona` `provincia` on
        ((`municipio`.`ID_ZonaPadre` = `provincia`.`ID_Zona`)))
    join `Zona` `region` on
        ((`provincia`.`ID_ZonaPadre` = `region`.`ID_Zona`)))
    join `Zona` `pais` on
        ((`region`.`ID_ZonaPadre` = `pais`.`ID_Zona`)))
    where
        (`pais`.`Tipo` = 'pais')
    group by
        `region`.`ID_Zona`) `sub_region` on
    ((`region`.`ID_Zona` = `sub_region`.`ID_Zona`)))
where
    (`pais`.`Tipo` = 'pais')
group by
    `pais`.`Nombre`,
    `region`.`Nombre`,
    `sub_region_depto`.`Total`,
    `sub_region`.`Total`
order by
    `pais`.`Nombre`;



-- proyecto1.reporte7 source

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `reporte7` AS
select
    `pais`.`Nombre` AS `Pais`,
    `raza`.`Raza` AS `Raza`,
    sum((((`v`.`Analfabetos` + `v`.`Primaria`) + `v`.`Nivel_Medio`) + `v`.`Universitarios`)) AS `Total_Votos`,
    `sub_pais`.`Total` AS `Total_Pais`,
    ((sum((((`v`.`Analfabetos` + `v`.`Primaria`) + `v`.`Nivel_Medio`) + `v`.`Universitarios`)) / `sub_pais`.`Total`) * 100) AS `Porcentaje`
from
    ((((((((`Resultado` `res`
join `Votos` `v` on
    ((`res`.`ID_Votos` = `v`.`ID_Votos`)))
join `Raza` `raza` on
    ((`res`.`ID_Raza` = `raza`.`ID_Raza`)))
join `Eleccion` `eleccion` on
    ((`res`.`ID_Eleccion` = `eleccion`.`ID_Eleccion`)))
join `Zona` `municipio` on
    ((`eleccion`.`ID_Zona` = `municipio`.`ID_Zona`)))
join `Zona` `provincia` on
    ((`municipio`.`ID_ZonaPadre` = `provincia`.`ID_Zona`)))
join `Zona` `region` on
    ((`provincia`.`ID_ZonaPadre` = `region`.`ID_Zona`)))
join `Zona` `pais` on
    ((`region`.`ID_ZonaPadre` = `pais`.`ID_Zona`)))
join (
    select
        `pais1`.`ID_Zona` AS `ID_Zona`,
        sum((((`v`.`Analfabetos` + `v`.`Primaria`) + `v`.`Nivel_Medio`) + `v`.`Universitarios`)) AS `Total`
    from
        ((((((`Resultado` `res`
    join `Votos` `v` on
        ((`res`.`ID_Votos` = `v`.`ID_Votos`)))
    join `Eleccion` `eleccion` on
        ((`res`.`ID_Eleccion` = `eleccion`.`ID_Eleccion`)))
    join `Zona` `municipio` on
        ((`eleccion`.`ID_Zona` = `municipio`.`ID_Zona`)))
    join `Zona` `provincia` on
        ((`municipio`.`ID_ZonaPadre` = `provincia`.`ID_Zona`)))
    join `Zona` `region` on
        ((`provincia`.`ID_ZonaPadre` = `region`.`ID_Zona`)))
    join `Zona` `pais1` on
        ((`region`.`ID_ZonaPadre` = `pais1`.`ID_Zona`)))
    where
        (`pais1`.`Tipo` = 'pais')
    group by
        `pais1`.`ID_Zona`) `sub_pais` on
    ((`pais`.`ID_Zona` = `sub_pais`.`ID_Zona`)))
where
    (`pais`.`Tipo` = 'pais')
group by
    `Pais`,
    `raza`.`Raza`,
    `sub_pais`.`Total`
order by
    `Pais`;



-- proyecto1.reporte8 source

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `reporte8` AS
select
    `z`.`Nombre` AS `Nombre`
from
    (`Zona` `z`
join (
    select
        `PORCENTAJES`.`ID_Zona` AS `ID_Zona`,
        max(`PORCENTAJES`.`PorcentajeVotos`) AS `MaxPorcentaje`,
        min(`PORCENTAJES`.`PorcentajeVotos`) AS `MinPorcentaje`,
        (max(`PORCENTAJES`.`PorcentajeVotos`) - min(`PORCENTAJES`.`PorcentajeVotos`)) AS `Diferencia`
    from
        ((
        select
            `pai`.`ID_Zona` AS `ID_Zona`,
            `pp`.`Nombre_Partido` AS `Nombre_Partido`,
            sum((((`v`.`Analfabetos` + `v`.`Primaria`) + `v`.`Nivel_Medio`) + `v`.`Universitarios`)) AS `VotosTotales`,
            ((sum((((`v`.`Analfabetos` + `v`.`Primaria`) + `v`.`Nivel_Medio`) + `v`.`Universitarios`)) / `VOTOS_PAIS`.`VotosTotalesPais`) * 100) AS `PorcentajeVotos`
        from
            ((((((((`Resultado` `r`
        join `Votos` `v` on
            ((`r`.`ID_Votos` = `v`.`ID_Votos`)))
        join `Eleccion` `e` on
            ((`r`.`ID_Eleccion` = `e`.`ID_Eleccion`)))
        join `Zona` `mun` on
            ((`e`.`ID_Zona` = `mun`.`ID_Zona`)))
        join `Zona` `dep` on
            ((`mun`.`ID_ZonaPadre` = `dep`.`ID_Zona`)))
        join `Zona` `reg` on
            ((`dep`.`ID_ZonaPadre` = `reg`.`ID_Zona`)))
        join `Zona` `pai` on
            ((`reg`.`ID_ZonaPadre` = `pai`.`ID_Zona`)))
        join `PartidoPolitico` `pp` on
            ((`r`.`ID_Partido` = `pp`.`ID_Partido`)))
        join (
            select
                sum((((`v`.`Analfabetos` + `v`.`Primaria`) + `v`.`Nivel_Medio`) + `v`.`Universitarios`)) AS `VotosTotalesPais`,
                `pai`.`ID_Zona` AS `ID_Zona`
            from
                ((((((`Resultado` `r`
            join `Votos` `v` on
                ((`r`.`ID_Votos` = `v`.`ID_Votos`)))
            join `Eleccion` `e` on
                ((`r`.`ID_Eleccion` = `e`.`ID_Eleccion`)))
            join `Zona` `mun` on
                ((`e`.`ID_Zona` = `mun`.`ID_Zona`)))
            join `Zona` `dep` on
                ((`mun`.`ID_ZonaPadre` = `dep`.`ID_Zona`)))
            join `Zona` `reg` on
                ((`dep`.`ID_ZonaPadre` = `reg`.`ID_Zona`)))
            join `Zona` `pai` on
                ((`reg`.`ID_ZonaPadre` = `pai`.`ID_Zona`)))
            group by
                `e`.`Ano_Eleccion`,
                `pai`.`ID_Zona`
            order by
                `VotosTotalesPais` desc) `VOTOS_PAIS` on
            ((`pai`.`ID_Zona` = `VOTOS_PAIS`.`ID_Zona`)))
        group by
            `pai`.`ID_Zona`,
            `pp`.`ID_Partido`,
            `VOTOS_PAIS`.`VotosTotalesPais`) `PORCENTAJES`
    join `Zona` `z` on
        ((`PORCENTAJES`.`ID_Zona` = `z`.`ID_Zona`)))
    group by
        `PORCENTAJES`.`ID_Zona`
    order by
        `Diferencia`
    limit 1) `Resultado` on
    ((`z`.`ID_Zona` = `Resultado`.`ID_Zona`)));








-- proyecto1.reporte9 source

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `reporte9` AS
select
    `z`.`Nombre` AS `Nombre`
from
    (`Zona` `z`
join (
    select
        `pai`.`ID_Zona` AS `ID_Zona`,
        sum((((`v`.`Analfabetos` + `v`.`Primaria`) + `v`.`Nivel_Medio`) + `v`.`Universitarios`)) AS `VotosTotales`,
        ((sum(`v`.`Analfabetos`) / sum((((`v`.`Analfabetos` + `v`.`Primaria`) + `v`.`Nivel_Medio`) + `v`.`Universitarios`))) * 100) AS `VotosAnalfabetos`,
        `e`.`Ano_Eleccion` AS `Ano_Eleccion`
    from
        ((((((`Resultado` `r`
    join `Votos` `v` on
        ((`r`.`ID_Votos` = `v`.`ID_Votos`)))
    join `Eleccion` `e` on
        ((`r`.`ID_Eleccion` = `e`.`ID_Eleccion`)))
    join `Zona` `mun` on
        ((`e`.`ID_Zona` = `mun`.`ID_Zona`)))
    join `Zona` `dep` on
        ((`mun`.`ID_ZonaPadre` = `dep`.`ID_Zona`)))
    join `Zona` `reg` on
        ((`dep`.`ID_ZonaPadre` = `reg`.`ID_Zona`)))
    join `Zona` `pai` on
        ((`reg`.`ID_ZonaPadre` = `pai`.`ID_Zona`)))
    group by
        `pai`.`ID_Zona`,
        `e`.`Ano_Eleccion`) `VOTOS_ANALFABETOS` on
    ((`z`.`ID_Zona` = `VOTOS_ANALFABETOS`.`ID_Zona`)))
order by
    `VOTOS_ANALFABETOS`.`VotosAnalfabetos` desc
limit 1;




-- proyecto1.reporte10 source

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `reporte10` AS
select
    `z`.`Nombre` AS `Nombre`,
    `VOTOS_GUATEMALA`.`VotosTotales` AS `VotosTotales`
from
    (`Zona` `z`
join (
    select
        `dep`.`ID_Zona` AS `ID_Zona`,
        sum((((`v`.`Analfabetos` + `v`.`Primaria`) + `v`.`Nivel_Medio`) + `v`.`Universitarios`)) AS `VotosTotales`
    from
        ((((((`Resultado` `r`
    join `Votos` `v` on
        ((`r`.`ID_Votos` = `v`.`ID_Votos`)))
    join `Eleccion` `e` on
        ((`r`.`ID_Eleccion` = `e`.`ID_Eleccion`)))
    join `Zona` `mun` on
        ((`e`.`ID_Zona` = `mun`.`ID_Zona`)))
    join `Zona` `dep` on
        ((`mun`.`ID_ZonaPadre` = `dep`.`ID_Zona`)))
    join `Zona` `reg` on
        ((`dep`.`ID_ZonaPadre` = `reg`.`ID_Zona`)))
    join `Zona` `pai` on
        ((`reg`.`ID_ZonaPadre` = `pai`.`ID_Zona`)))
    where
        (`pai`.`ID_Zona` = 914)
    group by
        `dep`.`ID_Zona`) `VOTOS_GUATEMALA` on
    ((`z`.`ID_Zona` = `VOTOS_GUATEMALA`.`ID_Zona`)))
where
    (`VOTOS_GUATEMALA`.`VotosTotales` > (
    select
        sum((((`v`.`Analfabetos` + `v`.`Primaria`) + `v`.`Nivel_Medio`) + `v`.`Universitarios`)) AS `VotosTotales`
    from
        ((((`Resultado` `r`
    join `Votos` `v` on
        ((`r`.`ID_Votos` = `v`.`ID_Votos`)))
    join `Eleccion` `e` on
        ((`r`.`ID_Eleccion` = `e`.`ID_Eleccion`)))
    join `Zona` `mun` on
        ((`e`.`ID_Zona` = `mun`.`ID_Zona`)))
    join `Zona` `dep` on
        ((`mun`.`ID_ZonaPadre` = `dep`.`ID_Zona`)))
    where
        (`dep`.`ID_Zona` = 916)
    group by
        `dep`.`ID_Zona`));









