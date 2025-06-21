create database NORTEp3
go

use NORTEp3
go



CREATE TABLE NORTE(
	[FECHA_ACTUALIZACION] [nvarchar](15) NULL,
	[ID_REGISTRO] [varchar](15) NOT NULL,
	[ORIGEN] [int] NULL,
	[SECTOR] [int] NULL,
	[ENTIDAD_UM] [nvarchar](15) NULL,
	[SEXO] [int] NULL,
	[ENTIDAD_NAC] [nvarchar](15) NULL,
	[ENTIDAD_RES] [nvarchar](15) NULL,
	[MUNICIPIO_RES] [nvarchar](15) NULL,
	[TIPO_PACIENTE] [int] NULL,
	[FECHA_INGRESO] [nvarchar](15) NULL,
	[FECHA_SINTOMAS] [nvarchar](15) NULL,
	[FECHA_DEF] [nvarchar](15) NULL,
	[INTUBADO] [int] NULL,
	[NEUMONIA] [int] NULL,
	[EDAD] [nvarchar](7) NULL,
	[NACIONALIDAD] [int] NULL,
	[EMBARAZO] [int] NULL,
	[HABLA_LENGUA_INDIG] [int] NULL,
	[INDIGENA] [int] NULL,
	[DIABETES] [int] NULL,
	[EPOC] [int] NULL,
	[ASMA] [int] NULL,
	[INMUSUPR] [int] NULL,
	[HIPERTENSION] [int] NULL,
	[OTRA_COM] [int] NULL,
	[CARDIOVASCULAR] [int] NULL,
	[OBESIDAD] [int] NULL,
	[RENAL_CRONICA] [int] NULL,
	[TABAQUISMO] [int] NULL,
	[OTRO_CASO] [int] NULL,
	[TOMA_MUESTRA_LAB] [int] NULL,
	[RESULTADO_LAB] [int] NULL,
	[TOMA_MUESTRA_ANTIGENO] [int] NULL,
	[RESULTADO_ANTIGENO] [int] NULL,
	[CLASIFICACION_FINAL] [int] NULL,
	[MIGRANTE] [int] NULL,
	[PAIS_NACIONALIDAD] [nvarchar](50) NULL,
	[PAIS_ORIGEN] [nvarchar](50) NULL,
	[UCI] [nvarchar](50) NULL
	);

INSERT INTO NORTE
SELECT * FROM covidHistorico.dbo.datoscovid
WHERE ENTIDAD_UM IN ('02','03','05','08','10','19','24','25','26','28');

