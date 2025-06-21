
-----------------------------------------------------------------------------------------------------------------------------------------CONSULTA 3----------------------------------------------------------

SELECT morbilidad,
       100.0 * SUM(casos) / SUM(total_confirmados) AS porcentaje
FROM (
    -- NORTE
    SELECT 'diabetes' AS morbilidad, SUM(CASE WHEN diabetes = 1 THEN 1 ELSE 0 END) AS casos, COUNT(*) AS total_confirmados
    FROM nortep3.dbo.norte
    WHERE clasificacion_final IN (1, 2, 3)
    UNION ALL
    SELECT 'obesidad', SUM(CASE WHEN obesidad = 1 THEN 1 ELSE 0 END), COUNT(*)
    FROM nortep3.dbo.norte
    WHERE clasificacion_final IN (1, 2, 3)
    UNION ALL
    SELECT 'hipertensión', SUM(CASE WHEN hipertension = 1 THEN 1 ELSE 0 END), COUNT(*)
    FROM nortep3.dbo.norte
    WHERE clasificacion_final IN (1, 2, 3)
  -- SUR
    UNION ALL
    SELECT 'diabetes', SUM(CASE WHEN diabetes = 1 THEN 1 ELSE 0 END), COUNT(*)
    FROM OPENQUERY(ARTURITOPRUEBA, '
        SELECT diabetes, clasificacion_final
        FROM SURp3.dbo.SUR
        WHERE clasificacion_final IN (1, 2, 3)  ')
    UNION ALL
    SELECT 'obesidad', SUM(CASE WHEN obesidad = 1 THEN 1 ELSE 0 END), COUNT(*)
    FROM OPENQUERY(ARTURITOPRUEBA, '
        SELECT obesidad, clasificacion_final
        FROM SURp3.dbo.SUR
        WHERE clasificacion_final IN (1, 2, 3) ')
    UNION ALL
    SELECT 'hipertensión', SUM(CASE WHEN hipertension = 1 THEN 1 ELSE 0 END), COUNT(*)
    FROM OPENQUERY(ARTURITOPRUEBA, '
        SELECT hipertension, clasificacion_final
        FROM SURp3.dbo.SUR
        WHERE clasificacion_final IN (1, 2, 3) ')
    -- CENTRO
    UNION ALL
    SELECT 'diabetes', SUM(CASE WHEN diabetes = 1 THEN 1 ELSE 0 END), COUNT(*)
    FROM OPENQUERY(SERVERLESLIE, '
        SELECT diabetes, clasificacion_final
        FROM centrop3.centro
        WHERE clasificacion_final IN (1, 2, 3) ')
    UNION ALL
    SELECT 'obesidad', SUM(CASE WHEN obesidad = 1 THEN 1 ELSE 0 END), COUNT(*)
    FROM OPENQUERY(SERVERLESLIE, '
        SELECT obesidad, clasificacion_final
        FROM centrop3.centro
        WHERE clasificacion_final IN (1, 2, 3)  ')
    UNION ALL
    SELECT 'hipertensión', SUM(CASE WHEN hipertension = 1 THEN 1 ELSE 0 END), COUNT(*)
    FROM OPENQUERY(SERVERLESLIE, '
        SELECT hipertension, clasificacion_final
        FROM centrop3.centro
        WHERE clasificacion_final IN (1, 2, 3)  ')
) AS morbilidades
GROUP BY morbilidad;







--------------------------------------------------CONSULTA 4------------------------------------------------------------------------------------------
SELECT MUNICIPIO_RES
FROM (
    -- Nodo NORTE (local)
    SELECT MUNICIPIO_RES, HIPERTENSION, OBESIDAD, DIABETES, TABAQUISMO
    FROM nortep3.dbo.norte
    WHERE CLASIFICACION_FINAL IN (1, 2, 3)
    UNION ALL
   -- Nodo SUR
    SELECT MUNICIPIO_RES, HIPERTENSION, OBESIDAD, DIABETES, TABAQUISMO
    FROM OPENQUERY(ARTURITOPRUEBA, '
        SELECT MUNICIPIO_RES, HIPERTENSION, OBESIDAD, DIABETES, TABAQUISMO
        FROM SURp3.dbo.SUR
        WHERE CLASIFICACION_FINAL IN (1, 2, 3)')
    UNION ALL
    -- Nodo CENTRO
    SELECT MUNICIPIO_RES, HIPERTENSION, OBESIDAD, DIABETES, TABAQUISMO
    FROM OPENQUERY(SERVERLESLIE, '
        SELECT MUNICIPIO_RES, HIPERTENSION, OBESIDAD, DIABETES, TABAQUISMO
        FROM centrop3.centro
        WHERE CLASIFICACION_FINAL IN (1, 2, 3)  ')
) AS datos_unidos
GROUP BY MUNICIPIO_RES
HAVING SUM(CASE WHEN HIPERTENSION = 1 THEN 1 ELSE 0 END) = 0
   AND SUM(CASE WHEN OBESIDAD = 1 THEN 1 ELSE 0 END) = 0
   AND SUM(CASE WHEN DIABETES = 1 THEN 1 ELSE 0 END) = 0
   AND SUM(CASE WHEN TABAQUISMO = 1 THEN 1 ELSE 0 END) = 0;








---------------------------------------CONSULTA 5--------------------------------------------------------------------------------------------5--------------------

SELECT ENTIDAD_UM, COUNT(*) AS Casos_recuperados
FROM (
    -- Nodo NORTE (local)
    SELECT ENTIDAD_UM
    FROM nortep3.dbo.norte
    WHERE NEUMONIA = 1 AND FECHA_DEF = '9999-99-99'
    UNION ALL
    -- Nodo SUR ARTURO
    SELECT ENTIDAD_UM
    FROM ARTURITOPRUEBA.SURp3.dbo.SUR
        WHERE NEUMONIA = 1 AND FECHA_DEF = '9999-99-99 '
    UNION ALL
    -- Nodo CENTRO LESLIE
    SELECT ENTIDAD_UM
    FROM OPENQUERY(SERVERLESLIE, '
        SELECT ENTIDAD_UM
        FROM centrop3.centro
        WHERE NEUMONIA = 1 AND FECHA_DEF = ''9999-99-99''
    ')
) AS datos_unidos
GROUP BY ENTIDAD_UM
ORDER BY Casos_recuperados DESC;







-------------------------------------------------------------CONSULTA 7---------------------------------------------------------------------------------------------------------------------------
SELECT TOP 1 *
FROM (
    -- CENTRO (MySQL)
    SELECT sub.Año, sub.Mes, sub.ENTIDAD_RES, COUNT(*) AS Total_Casos
    FROM OPENQUERY(SERVERLESLIE, '
        SELECT DATE_FORMAT(FECHA_INGRESO, ''%Y'') AS Año,
               DATE_FORMAT(FECHA_INGRESO, ''%m'') AS Mes,
               ENTIDAD_RES,
               CLASIFICACION_FINAL
        FROM centrop3.centro
        WHERE FECHA_INGRESO BETWEEN ''2020-01-01'' AND ''2021-12-31''
          AND CLASIFICACION_FINAL IN (1, 2, 3, 6)
    ') AS sub
    GROUP BY sub.Año, sub.Mes, sub.ENTIDAD_RES

    UNION ALL

    -- NORTE (SQL Server)
    SELECT YEAR(FECHA_INGRESO) AS Año, MONTH(FECHA_INGRESO) AS Mes, ENTIDAD_RES, COUNT(*) AS Total_Casos
    FROM NORTEp3.dbo.NORTE
    WHERE YEAR(FECHA_INGRESO) IN (2020, 2021)
      AND CLASIFICACION_FINAL IN (1, 2, 3, 6)
    GROUP BY YEAR(FECHA_INGRESO), MONTH(FECHA_INGRESO), ENTIDAD_RES

    UNION ALL

    -- SUR (SQL Server)
    SELECT sub.Año, sub.Mes, sub.ENTIDAD_RES, COUNT(*) AS Total_Casos
    FROM OPENQUERY(ARTURITOPRUEBA, '
        SELECT YEAR(FECHA_INGRESO) AS Año,
               MONTH(FECHA_INGRESO) AS Mes,
               ENTIDAD_RES,
               CLASIFICACION_FINAL
        FROM SURp3.dbo.SUR
        WHERE YEAR(FECHA_INGRESO) IN (2020, 2021)
          AND CLASIFICACION_FINAL IN (1, 2, 3, 6)
    ') AS sub
    GROUP BY sub.Año, sub.Mes, sub.ENTIDAD_RES
) AS todos
ORDER BY Total_Casos DESC;
