-- PROYECTO DE PORTAFOLIO: ANÁLISIS AVANZADO DE AUSENTISMO LABORAL CON ORACLE SQL
-- Autor: JUAN EMILIO ORTEGA RISSO
-- Fecha: 1/11/2025
-- Objetivo: Demostrar habilidades en Modelado DDL, Transformación DML y Análisis SQL Avanzado (Funciones de Ventana y CTE).
--------------------------------------------------------------------------------
-- INSTRUCCIONES: IMPORTAR ARCHIVO AUSENTISMO.CSV, 
-- USAR EL SIGUIENTE FORMATO PARA LA TABLA DE DATOS CRUDOS LLAMADA RAW_AUSENTISMO
CREATE TABLE RAW_AUSENTISMO (
    "ID"                              NUMBER(10,0) PRIMARY KEY, -- Clave Primaria (PK)
    "MOTIVO_AUSENCIA_ID"              NUMBER(2,0), 
    "MES_AUSENCIA"                    NUMBER(2,0), 
    "DIA_SEMANA"                      NUMBER(1,0), 
    "SEASONS"                         NUMBER(1,0), 
    "GASTOS_TRANSPORTE"               NUMBER(5,2), 
    "DISNTANCIA_KILOMETROS_TRABAJO_CASA" NUMBER(4,1), 
    "TIEMPO_SERVICIO"                 NUMBER(3,0), 
    "EDAD"                            NUMBER(3,0), 
    "CARGA_TRABAJO_DIA_PROMEDIO"      NUMBER(4,0), 
    "PROMEDIO_ALCANZADO"              NUMBER(3,0), 
    "FALLO_DISCIPLINARIO"             NUMBER(1,0), 
    "EDUCACION"                       NUMBER(1,0), 
    "HIJOS"                           NUMBER(2,0), 
    "BEBEDOR"                         NUMBER(1,0), 
    "FUMADOR"                         NUMBER(1,0), 
    "MASCOTAS"                        NUMBER(2,0), 
    "PESO"                            NUMBER(5,2), 
    "ALTURA"                          NUMBER(3,0), 
    "INDICE_MASA_CORPORAL"            NUMBER(4,2), 
    "AUSENTISMO_HORAS"                NUMBER(4,2)  
);
-- Y EL FORMATO PARA LA TABLA DIM_MOTIVOS_AUSENCIA
CREATE TABLE DIM_MOTIVOS_AUSENCIA (
    MOTIVO_ID      NUMBER(2,0)     PRIMARY KEY, -- Restricción PK definida aquí
    DESCRIPCION    VARCHAR2(100)   NOT NULL     -- Restricción NOT NULL definida aquí
);
-- PONER DESCRIPCION 
-- 2.1 POBLAR DIMENSIONAL (Necesario para que el JOIN funcione en el análisis)
INSERT INTO DIM_MOTIVOS_AUSENCIA (MOTIVO_ID, DESCRIPCION) VALUES (1, 'Ciertas enfermedades infecciosas y parasitarias');
INSERT INTO DIM_MOTIVOS_AUSENCIA (MOTIVO_ID, DESCRIPCION) VALUES (2, 'Neoplasias');
INSERT INTO DIM_MOTIVOS_AUSENCIA (MOTIVO_ID, DESCRIPCION) VALUES (3, 'Enfermedades de la sangre y de los órganos hematopoyético');
INSERT INTO DIM_MOTIVOS_AUSENCIA (MOTIVO_ID, DESCRIPCION) VALUES (4, 'Enfermedades endocrinas, nutricionales y metabólicas');
INSERT INTO DIM_MOTIVOS_AUSENCIA (MOTIVO_ID, DESCRIPCION) VALUES (5, 'Trastornos mentales y del comportamiento');
INSERT INTO DIM_MOTIVOS_AUSENCIA (MOTIVO_ID, DESCRIPCION) VALUES (6, 'Enfermedades del sistema nervioso');
INSERT INTO DIM_MOTIVOS_AUSENCIA (MOTIVO_ID, DESCRIPCION) VALUES (7, 'Enfermedades del ojo y sus anexos');
INSERT INTO DIM_MOTIVOS_AUSENCIA (MOTIVO_ID, DESCRIPCION) VALUES (8, 'Enfermedades del oído y de la apófisis mastoides');
INSERT INTO DIM_MOTIVOS_AUSENCIA (MOTIVO_ID, DESCRIPCION) VALUES (9, 'Enfermedades del sistema circulatorio');
INSERT INTO DIM_MOTIVOS_AUSENCIA (MOTIVO_ID, DESCRIPCION) VALUES (10, 'Enfermedades del sistema respiratorio');
INSERT INTO DIM_MOTIVOS_AUSENCIA (MOTIVO_ID, DESCRIPCION) VALUES (11, 'Enfermedades del sistema digestivo');
INSERT INTO DIM_MOTIVOS_AUSENCIA (MOTIVO_ID, DESCRIPCION) VALUES (12, 'Enfermedades de la piel y del tejido subcutáneo');
INSERT INTO DIM_MOTIVOS_AUSENCIA (MOTIVO_ID, DESCRIPCION) VALUES (13, 'Enfermedades del sistema musculoesquelético y del tejido conectivo');
INSERT INTO DIM_MOTIVOS_AUSENCIA (MOTIVO_ID, DESCRIPCION) VALUES (14, 'Enfermedades del sistema genitourinario');
INSERT INTO DIM_MOTIVOS_AUSENCIA (MOTIVO_ID, DESCRIPCION) VALUES (15, 'Embarazo, parto y puerperio');
INSERT INTO DIM_MOTIVOS_AUSENCIA (MOTIVO_ID, DESCRIPCION) VALUES (16, 'Ciertas afecciones originadas en el período perinatal');
INSERT INTO DIM_MOTIVOS_AUSENCIA (MOTIVO_ID, DESCRIPCION) VALUES (17, 'Malformaciones congénitas, deformaciones y anomalías');
INSERT INTO DIM_MOTIVOS_AUSENCIA (MOTIVO_ID, DESCRIPCION) VALUES (18, 'Síntomas, signos y hallazgos clínicos y de laboratorio anormales');
INSERT INTO DIM_MOTIVOS_AUSENCIA (MOTIVO_ID, DESCRIPCION) VALUES (19, 'Lesiones, intoxicaciones y ciertas otras consecuencias de causas externas');
INSERT INTO DIM_MOTIVOS_AUSENCIA (MOTIVO_ID, DESCRIPCION) VALUES (20, 'Causas externas de morbilidad y mortalidad');
INSERT INTO DIM_MOTIVOS_AUSENCIA (MOTIVO_ID, DESCRIPCION) VALUES (21, 'Factores que influyen en el estado de salud y el contacto con los servicios sanitarios.');
INSERT INTO DIM_MOTIVOS_AUSENCIA (MOTIVO_ID, DESCRIPCION) VALUES (22, 'seguimiento');
INSERT INTO DIM_MOTIVOS_AUSENCIA (MOTIVO_ID, DESCRIPCION) VALUES (24, 'donaciones de sangre');
INSERT INTO DIM_MOTIVOS_AUSENCIA (MOTIVO_ID, DESCRIPCION) VALUES (25, 'exámenes de laboratorio');
INSERT INTO DIM_MOTIVOS_AUSENCIA (MOTIVO_ID, DESCRIPCION) VALUES (26, 'ausencias injustificadas');
INSERT INTO DIM_MOTIVOS_AUSENCIA (MOTIVO_ID, DESCRIPCION) VALUES (27, 'fisioterapia');
INSERT INTO DIM_MOTIVOS_AUSENCIA (MOTIVO_ID, DESCRIPCION) VALUES (28, 'consultas dentales');
INSERT INTO DIM_MOTIVOS_AUSENCIA (MOTIVO_ID, DESCRIPCION) VALUES (0, 'sin datos');
------------------------------------------------------------
--ESTABLECER CLAVE FORÁNEA (FK)
-- Enlaza la tabla de hechos con la de motivos, demostrando el modelado relacional.
ALTER TABLE RAW_AUSENTISMO ADD CONSTRAINT FK_MOTIVO_GLOBAL
    FOREIGN KEY (MOTIVO_AUSENCIA_ID)
    REFERENCES DIM_MOTIVOS_AUSENCIA(MOTIVO_ID);

--TRANSFORMACIÓN DE DATOS: CÁLCULO Y VALIDACIÓN DEL IMC
-- Se recalcula el IMC (Peso / (Altura/100)^2) para asegurar la exactitud.
UPDATE RAW_AUSENTISMO
SET INDICE_MASA_CORPORAL = "PESO" / (("ALTURA" / 100) * ("ALTURA" / 100))
WHERE "PESO" IS NOT NULL AND "ALTURA" IS NOT NULL AND "ALTURA" > 0;
COMMIT;
---------------------------------------------------------
--OBJETIVO 1: IDENTIFICACIÓN DE PICOS DE RIESGO Y PERFILES
-- FUNCIÓN: GROUP BY y CASE
-- INFERENCIA: Muestra los grupos (Día/Mes/Hábito) con la mayor cantidad de horas perdidas.
SELECT
    RA.DIA_SEMANA,
    RA.MES_AUSENCIA,
    CASE WHEN RA.BEBEDOR = 1 THEN 'Sí' ELSE 'No' END AS CONSUME_ALCOHOL,
    CASE WHEN RA.FUMADOR = 1 THEN 'Sí' ELSE 'No' END AS ES_FUMADOR,
    
    COUNT(RA.ID) AS Total_Casos,
    ROUND(SUM(RA.AUSENTISMO_HORAS), 2) AS Total_Horas_Perdidas,
    ROUND(AVG(RA.GASTOS_TRANSPORTE), 2) AS Promedio_Gasto_Transporte,
    ROUND(AVG(RA.INDICE_MASA_CORPORAL), 2) AS Promedio_IMC
FROM
    RAW_AUSENTISMO RA
GROUP BY
    RA.DIA_SEMANA, RA.MES_AUSENCIA, RA.BEBEDOR, RA.FUMADOR
HAVING
    COUNT(RA.ID) > 10
ORDER BY
    Total_Horas_Perdidas DESC;
-- ---------------------------------------------------------------------------------
--OBJETIVO 2: ANÁLISIS COMPARATIVO DE AUSENTISMO POR EDUCACIÓN
-- FUNCIÓN: FUNCIONES DE VENTANA (RANK() OVER y AVG() OVER)
-- INFERENCIA: Identifica las ausencias más largas (Ranking 1) para motivos médicos,
--             comparándolas con el promedio del mismo nivel educativo.
SELECT
    RA.ID,
    RA.EDUCACION,
    DM.DESCRIPCION AS Motivo_Ausencia,
    RA.AUSENTISMO_HORAS,
    
    AVG(RA.AUSENTISMO_HORAS) OVER (PARTITION BY RA.EDUCACION) AS Promedio_Horas_Educacion,
    
    RANK() OVER (
        PARTITION BY RA.EDUCACION
        ORDER BY RA.AUSENTISMO_HORAS DESC
    ) AS Ranking_Ausentismo
FROM
    RAW_AUSENTISMO RA
JOIN
    DIM_MOTIVOS_AUSENCIA DM ON RA.MOTIVO_AUSENCIA_ID = DM.MOTIVO_ID
WHERE
    -- Filtrar por motivos médicos para enfocarse en la salud.
    DM.DESCRIPCION LIKE '%Enfermedad%' 
    OR DM.DESCRIPCION LIKE '%Médico%'
FETCH FIRST 20 ROWS ONLY;
-- ---------------------------------------------------------------------------------
-- OBJETIVO 3: ANÁLISIS DE FALLA DISCIPLINARIA
-- FUNCIÓN: CTE (Common Table Expression - WITH)
-- INFERENCIA: Compara el perfil de empleados con y sin fallos, destacando la distancia al trabajo.
WITH Perfil_Disciplinario AS (
    SELECT
        FALLO_DISCIPLINARIO,
        COUNT(ID) AS Total_Empleados,
        ROUND(AVG(TIEMPO_SERVICIO), 1) AS Avg_Tiempo_Servicio,
        ROUND(AVG(DISNTANCIA_KILOMETROS_TRABAJO_CASA), 1) AS Avg_Distancia_Km
    FROM
        RAW_AUSENTISMO
    GROUP BY
        FALLO_DISCIPLINARIO
)
SELECT
    CASE WHEN PD.FALLO_DISCIPLINARIO = 1 THEN 'Sí (Con Fallo)' ELSE 'No (Sin Fallo)' END AS Estatus_Disciplinario,
    PD.Total_Empleados,
    PD.Avg_Tiempo_Servicio,
    PD.Avg_Distancia_Km,
    -- Calcula la diferencia porcentual
    ROUND(
        (PD.Avg_Tiempo_Servicio - (SELECT Avg_Tiempo_Servicio FROM Perfil_Disciplinario WHERE FALLO_DISCIPLINARIO = 0)) 
        / (SELECT Avg_Tiempo_Servicio FROM Perfil_Disciplinario WHERE FALLO_DISCIPLINARIO = 0) * 100
    , 2) AS Diferencia_Servicio_Porc
FROM
    Perfil_Disciplinario PD;