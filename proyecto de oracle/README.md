Proyecto de Portafolio: Análisis de Ausentismo Laboral con Oracle Database
Introducción: Este proyecto demuestra el ciclo completo de análisis de datos: desde el modelado dimensional y la limpieza ETL en Oracle PL/SQL hasta la extracción de insights mediante SQL Avanzado (Funciones de Ventana y CTE) .
Autor: Juan Emilio Ortega Risso
Fecha: 3/11/2025

Motor de Base de Datos Oracle Database
Lenguajes: SQL, PL/SQL (para el procedimiento ETL).
Herramientas de Desarrollo: SQL Developer / SQLcl.

Fuente: https://www.kaggle.com/datasets/kewagbln/absenteeism-at-work-uci-ml-repositiory/data
Alcance: registro de ausentismo de 

Arquitectura de la Base de Datos (Esquema Estrella)
Se implementó un modelo dimensional para optimizar el análisis, compuesto por:

Tabla de Hechos: RAW_AUSENTISMO
Dimensiones: DIM_MOTIVOS_AUSENCIA`: Catálogo de 28 motivos con descripciones y códigos CIE10.


Resultados y Análisis de Negocio

El análisis se centró en identificar los patrones de riesgo y el perfil de los empleados.

Objetivo 1: Identificación de Picos de Riesgo
Objetivo 2: Análisis Comparativo de Ausentismo (Funciones de Ventana)
Objetivo 3: Análisis de Fallo Disciplinario (CTE)