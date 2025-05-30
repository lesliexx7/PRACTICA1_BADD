/************************************
    consulta no.3 listar el porcentaje de casos confirmados en cada una 
    de las siguientes morbilidades a nivel nacional: diabetes, obesidad e hipertensión. 
    significado de los valores de los catalogos: 
    responsable: palacios reyes leslie noemi
    comentarios: 
*************************************/
select 
    'diabetes' as morbilidad,
    100.0 * sum(case when diabetes = 1 then 1 else 0 end) / count(*) as porcentaje
from datoscovid
where clasificacion_final in (1, 2, 3)
union all
select 
    'obesidad' as morbilidad,
    100.0 * sum(case when obesidad = 1 then 1 else 0 end) / count(*) as porcentaje
from datoscovid
where clasificacion_final in (1, 2, 3)
union all
select 
    'hipertensión' as morbilidad,
    100.0 * sum(case when hipertension = 1 then 1 else 0 end) / count(*) as porcentaje
from datoscovid
where clasificacion_final in (1, 2, 3);


drop index idx_diab ON datoscovid
CREATE NONCLUSTERED INDEX idx_diab
ON datoscovid (DIABETES);

drop index idx_obesi ON datoscovid
CREATE NONCLUSTERED INDEX idx_obesi
ON datoscovid (OBESIDAD);

drop index idx_hiper ON datoscovid
CREATE NONCLUSTERED INDEX idx_hiper
ON datoscovid (HIPERTENSION);




/************************************
	Consulta No.4 Listar los municipios que no tengan casos confirmados en todas las morbilidades: 
hipertensión, obesidad, diabetes, tabaquismo. 
	Requisitos: tener pacientes que tengan neumonia, que no hayan fallecido y que su total sea mayor que los que si lo hicieron
	Responsable: Macías Galván Arturo Daniel

*************************************/
drop index idx_tabaq ON datoscovid
CREATE NONCLUSTERED INDEX idx_tabaq
ON datoscovid (TABAQUISMO);

SELECT MUNICIPIO_RES
FROM datoscovid
WHERE CLASIFICACION_FINAL IN (1, 2, 3) -- Casos confirmados
GROUP BY MUNICIPIO_RES
HAVING SUM(CASE WHEN HIPERTENSION = 1 THEN 1 ELSE 0 END) = 0
   AND SUM(CASE WHEN OBESIDAD = 1 THEN 1 ELSE 0 END) = 0
   AND SUM(CASE WHEN DIABETES = 1 THEN 1 ELSE 0 END) = 0
   AND SUM(CASE WHEN TABAQUISMO = 1 THEN 1 ELSE 0 END) = 0;

/************************************
	Consulta No.5 Listar los estados con mÃ¡s casos recuperados con neumonÃ­a
	Requisitos: tener pacientes que tengan neumonia, que no hayan fallecido y que su total sea mayor que los que si lo hicieron
	Responsable: Legorreta Rodriguez Maria Fernanda

*************************************/

select entidad, casos_recuperados
from (
    select entidad, casos_recuperados, total_fallecidos
    from (
        select c.entidad, 
               COUNT(CASE when d.FECHA_DEF = '9999-99-99' then 1 end) as casos_recuperados,
               COUNT(CASE when d.FECHA_DEF <> '9999-99-99' then 1 end) as total_fallecidos
       from datoscovid d
        JOIN cat_entidades c on d.ENTIDAD_UM = c.clave
        where d.NEUMONIA = '1'
        group by c.entidad
    ) as conteo
    where casos_recuperados > total_fallecidos 
) as resultado
order by casos_recuperados desc;

drop index idx_fechaDef on datoscovid
CREATE NONCLUSTERED INDEX idx_fechaDef
ON datoscovid (FECHA_DEF);

drop index idx_neumonia on datoscovid
CREATE NONCLUSTERED INDEX idx_neumonia
ON datoscovid (NEUMONIA);
