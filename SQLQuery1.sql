select * from dbo.cat_entidades;
select * from dbo.datoscovid;

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

/************************************
    consulta no.6 listar el total de casos confirmados/sospechosos 
    por estado en cada uno de los años registrados en la base de datos.  
    responsable: palacios reyes leslie noemi
*************************************/
select 
    entidad_res as estado,  
    year(try_cast(fecha_ingreso as date)) as año,  
    count(*) as total_casos  
from datoscovid  
where clasificacion_final in (1, 2, 3)  -- 1, 2, 3 son casos confirmados o sospechosos  
and try_cast(fecha_ingreso as date) is not null  
group by entidad_res, year(try_cast(fecha_ingreso as date))  
order by año, total_casos desc;

/************************************
    consulta no. 9. listar el top 3 de municipios con menos casos 
    recuperados en el año 2021.  
    responsable: palacios reyes leslie noemi
*************************************/
with casos_recuperados as (
    select 
        entidad_res, 
        municipio_res, 
        count(*) as total_recuperados
    from datoscovid
    where year(try_cast(fecha_ingreso as date)) = 2021
    and fecha_def = '9999-99-99'  -- casos recuperados (asumimos que no han fallecido)
    group by entidad_res, municipio_res
)
select  top 3 * 
from casos_recuperados 
order by total_recuperados asc, entidad_res, municipio_res;

/************************************
    consulta no. 12 Listar total de casos negativos por estado en los años 2020 y 2021.
    significado de los valores de los catalogos: 
    responsable: palacios reyes leslie noemi
*************************************/
select 
    ce.entidad as estado,
    year(try_cast(dc.fecha_ingreso as date)) as año,
    count(*) as total_casos_negativos  
from dbo.datoscovid dc
join dbo.cat_entidades ce on dc.entidad_res = ce.clave
where dc.clasificacion_final = 7  -- casos negativos
and year(try_cast(dc.fecha_ingreso as date)) in (2020, 2021)
group by ce.entidad, year(try_cast(dc.fecha_ingreso as date))
order by ce.entidad, año;
