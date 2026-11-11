# GEIH Colombia 2020 — Encuestas de hogares Q1 y Q2

TP de Desarrollo Económico Aplicado (Maestría en Economía Aplicada, UBA).
Profesora: Vera Chiodi. Alumnos: César Leonardo Ferrer y Santiago Martínez Soler.

## Datos

Gran Encuesta Integrada de Hogares (GEIH) 2020, DANE.
Descarga: microdatos.dane.gov.co → GEIH 2020 → Obtener Microdatos.

Bajar `1.Enero.zip` a `6.Junio.zip` y copiarlos en `data/raw/zips/`.
Los datos no se suben al repo.

## Cómo correrlo

1. Cambiar la ruta `global root` en `do/00_master.do`.
2. Correr `do/00_master.do`.

| Archivo | Qué hace |
|---|---|
| `01_descomprimir.do` | Descomprime los zips de enero a junio |
| `02_armar_trimestres.do` | Arma las bases de personas de Q1 y Q2 |
| `03_validar_y_tasas.do` | Valida la condición de actividad y calcula TD, TO y TGP mensuales |
| `04_panel.do` | Verifica si hay hogares repetidos entre meses |

## Bases que genera (`data/derived/`)

- `geih_q1_2020_personas.dta`: enero a marzo
- `geih_q2_2020_personas.dta`: abril a junio
- `geih_s1_2020_personas.dta`: ambos trimestres apilados
