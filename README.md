# GEIH Colombia 2020 — Encuestas de hogares Q1 y Q2

TP de Desarrollo Económico Aplicado (Maestría en Economía Aplicada, UBA).
Profesora: Vera Chiodi. Alumnos: César Leonardo Ferrer y Santiago Martínez Soler.

## Datos

Gran Encuesta Integrada de Hogares (GEIH) 2020, DANE.
Descarga: microdatos.dane.gov.co → GEIH 2020 → Obtener Microdatos.

Los zips originales de enero a junio (`1.Enero.zip` a `6.Junio.zip`) están en `data/raw/zips/`.

## Cómo correrlo

1. Cambiar la ruta `global root` en `do/00_master.do`.
2. Correr `do/00_master.do`.

| Archivo | Qué hace |
|---|---|
| `01_descomprimir.do` | Descomprime los zips de enero a junio |
| `02_armar_trimestres.do` | Arma las bases de personas de Q1 y Q2 |
| `03_validar_y_tasas.do` | Valida la condición de actividad y calcula TD, TO y TGP mensuales |
| `04_panel.do` | Verifica si hay hogares repetidos entre meses |
| `05_variables.do` | Construye las variables de la lista de la cátedra |

## Bases que genera (`data/derived/`)

- `geih_q1_2020_personas.dta`: enero a marzo
- `geih_q2_2020_personas.dta`: abril a junio
- `geih_s1_2020_personas.dta`: ambos trimestres apilados
- `geih_q1_2020_variables.dta` y `geih_q2_2020_variables.dta`: variables de la lista

## Variables de la lista y disponibilidad

De marzo a junio, en las cabeceras se usó un formulario telefónico reducido
(variable `form_reducido`). El área rural siguió con el formulario completo.
La tabla de otros ingresos solo existe en enero y febrero.

% de casos con dato dentro de su universo (cab = cabecera, resto = rural):

| Variable | Lista | Q1 cab | Q1 resto | Q2 cab | Q2 resto |
|---|---|---|---|---|---|
| `ing_hogar` | Household income | 70 | 68 | 0 | 0 |
| `ing_pc` | Per capita family income | 70 | 68 | 0 | 0 |
| `dec_ing` | Decile income | 66 | 68 | 0 | 0 |
| `dec_ingpc` | Decile pc income | 70 | 68 | 0 | 0 |
| `hrs_ppal` | Week hours main job | 100 | 100 | 100 | 100 |
| `hrs_sec` | Week hours other job | 71 | 100 | 0 | 100 |
| `ing_ind` | Total individual income | 70 | 68 | 0 | 0 |
| `ing_sec` | Other job income | 71 | 98 | 0 | 99 |
| `ing_ppal` | Main job income | 95 | 99 | 93 | 99 |
| `extras_sal` | Monthly wage extras | 73 | 100 | 0 | 100 |
| `ing_nolab` | Total non work income | 70 | 68 | 0 | 0 |
| `salud_publica` | Public health coverage | 66 | 100 | 62 | 100 |
| `sin_salud` | No health coverage | 66 | 100 | 62 | 100 |
| `un_empleo` | One job | 71 | 100 | 0 | 100 |
| `multi_empleo` | More than one job | 71 | 100 | 0 | 100 |
| `quiere_mas_hrs` | Want work more | 71 | 100 | 0 | 100 |
| `quiere_disp_mas_hrs` | Want can work more | 71 | 100 | 0 | 100 |
| `busca_mas_hrs` | Search + hrs to work last month | 71 | 100 | 0 | 100 |
| `busca_otro_empleo` | Search another job | 71 | 100 | 0 | 100 |
| `subempleado` | Under employed | 71 | 100 | 0 | 100 |
| `pleno_empleo` | Full employed | 71 | 100 | 0 | 100 |
| `sector_publico` | Public sector job | 100 | 100 | 100 | 100 |
| `sector_privado` | Private sector job | 100 | 100 | 100 | 100 |
| `servicio_domestico` | Domestic employee | 100 | 100 | 100 | 100 |
| `lugar_oficina_negocio_finca` | Office business farm employee | 71 | 100 | 64 | 100 |
| `lugar_casa_cliente` | At customers home | 71 | 100 | 64 | 100 |
| `lugar_calle_movil` | Street mobile employee | 71 | 100 | 64 | 100 |
| `antig_1a5` | One to five years continous work | 71 | 100 | 0 | 100 |
| `antig_mas5` | More five years continuous work | 71 | 100 | 0 | 100 |
| `contrato_indef` | Fixed employment | 71 | 100 | 0 | 100 |
| `comida` | Free meal | 71 | 100 | 0 | 100 |
| `vacaciones` | Paid holidays | 71 | 100 | 0 | 100 |
| `prima_navidad` | Thirteenth month | 71 | 100 | 0 | 100 |
| `salud_por_trabajo` | Medical insurance from work | 68 | 100 | 64 | 100 |
| `aporte_pension` | Pension discount | 71 | 100 | 64 | 100 |
| — | Sick leave days | no existe en la GEIH | | | |
| — | Formal receipt for payment | no existe en la GEIH | | | |
