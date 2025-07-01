
------------------------------------------------------------

CREATE PROCEDURE consultaMorbPorRegion
(
    @Servidor NVARCHAR(100),  -- Ej: 'ARTURITOPRUEBA'
    @Tabla NVARCHAR(100)      -- Ej: 'SURp3.dbo.SUR'
)
AS
BEGIN
    DECLARE @SQLString NVARCHAR(MAX);

    SET @SQLString = '
    SELECT ''diabetes'' AS morbilidad,
           100.0 * SUM(CASE WHEN diabetes = 1 THEN 1 ELSE 0 END) / COUNT(*) AS porcentaje
    FROM OPENQUERY([' + @Servidor + '], ''
        SELECT diabetes, clasificacion_final
        FROM ' + @Tabla + '
        WHERE clasificacion_final IN (1, 2, 3)
    '') 
    UNION ALL
    SELECT ''obesidad'' AS morbilidad,
           100.0 * SUM(CASE WHEN obesidad = 1 THEN 1 ELSE 0 END) / COUNT(*) AS porcentaje
    FROM OPENQUERY([' + @Servidor + '], ''
        SELECT obesidad, clasificacion_final
        FROM ' + @Tabla + '
        WHERE clasificacion_final IN (1, 2, 3)
    '') 
    UNION ALL
    SELECT ''hipertensión'' AS morbilidad,
           100.0 * SUM(CASE WHEN hipertension = 1 THEN 1 ELSE 0 END) / COUNT(*) AS porcentaje
    FROM OPENQUERY([' + @Servidor + '], ''
        SELECT hipertension, clasificacion_final
        FROM ' + @Tabla + '
        WHERE clasificacion_final IN (1, 2, 3)
    '')';



    EXEC sp_executesql @SQLString;

