# GEIH Colombia 2020 — Encuestas de hogares Q1 y Q2

TP de Desarrollo Económico Aplicado (Maestría en Economía Aplicada, UBA).
Profesora: Vera Chiodi. Alumnos: César Leonardo Ferrer y Santiago Martínez Soler.

## Contenido

| Carpeta / archivo | Qué es |
|---|---|
| `TEXTO.md` | Texto breve: fuente, población, panel, representatividad y cambios de 2020 |
| `data/raw/zips/` | Microdatos originales del DANE, enero a junio de 2020 |
| `docs/` | Documentación metodológica y cuestionarios |
| `do/` | Código en Stata |

## Cómo correrlo

1. Cambiar la ruta `global root` en `do/00_master.do`.
2. Correr `do/00_master.do`.

| Do-file | Qué hace |
|---|---|
| `01_descomprimir.do` | Descomprime los zips de enero a junio |
| `02_bases_variables.do` | Arma las bases de Q1 y Q2 y construye las variables |
| `03_panel.do` | Verifica si se pueden seguir hogares entre meses |

Genera en `data/derived/` las bases `geih_q1_2020_variables.dta` (enero a
marzo) y `geih_q2_2020_variables.dta` (abril a junio).

## Variables

Porcentaje de casos con dato dentro de su universo (cab = cabecera, resto =
centros poblados y rural disperso).

| Variable | Lista | Pregunta GEIH | Q1 cab | Q1 resto | Q2 cab | Q2 resto |
|---|---|---|---|---|---|---|
| `ing_hogar` | Household income | suma de `ing_ind` del hogar | 70 | 68 | 0 | 0 |
| `ing_pc` | Per capita family income | `ing_hogar` / miembros | 70 | 68 | 0 | 0 |
| `dec_ing` | Decile income | deciles de `ing_hogar` | 66 | 68 | 0 | 0 |
| `dec_ingpc` | Decile pc income | deciles de `ing_pc` | 70 | 68 | 0 | 0 |
| `hrs_ppal` | Week hours main job | P6800 | 100 | 100 | 100 | 100 |
| `hrs_sec` | Week hours other job | P7045 | 71 | 100 | 0 | 100 |
| `ing_ind` | Total individual income | laboral + no laboral | 70 | 68 | 0 | 0 |
| `ing_sec` | Other job income | P7070 | 71 | 98 | 0 | 99 |
| `ing_ppal` | Main job income | P6500, P6750/P6760, P550 | 95 | 99 | 93 | 99 |
| `extras_sal` | Monthly wage extras | P6510, P6545, P6580, P6585, P6630 | 73 | 100 | 0 | 100 |
| `ing_nolab` | Total non work income | P7500, P7510 | 70 | 68 | 0 | 0 |
| `salud_publica` | Public health coverage | P6100 = 3 (subsidiado) | 66 | 100 | 62 | 100 |
| `sin_salud` | No health coverage | P6090 = 2 | 66 | 100 | 62 | 100 |
| `un_empleo` | One job | P7040 = 2 | 71 | 100 | 0 | 100 |
| `multi_empleo` | More than one job | P7040 = 1 | 71 | 100 | 0 | 100 |
| `quiere_mas_hrs` | Want work more | P7090 | 71 | 100 | 0 | 100 |
| `quiere_disp_mas_hrs` | Want can work more | P7090 y P7120 | 71 | 100 | 0 | 100 |
| `busca_mas_hrs` | Search + hrs to work last month | P7090 y P7110 | 71 | 100 | 0 | 100 |
| `busca_otro_empleo` | Search another job | P7150 | 71 | 100 | 0 | 100 |
| `subempleado` | Under employed | quiere y puede más horas, < 48 hs | 71 | 100 | 0 | 100 |
| `pleno_empleo` | Full employed | ocupado no subempleado | 71 | 100 | 0 | 100 |
| `sector_publico` | Public sector job | P6430 = 2 | 100 | 100 | 100 | 100 |
| `sector_privado` | Private sector job | P6430 = 1 | 100 | 100 | 100 | 100 |
| `servicio_domestico` | Domestic employee | P6430 = 3 | 100 | 100 | 100 | 100 |
| `lugar_oficina_negocio_finca` | Office business farm employee | P6880 = 7, 8 | 71 | 100 | 64 | 100 |
| `lugar_casa_cliente` | At customers home | P6880 = 2 | 71 | 100 | 64 | 100 |
| `lugar_calle_movil` | Street mobile employee | P6880 = 4, 5, 6 | 71 | 100 | 64 | 100 |
| `antig_1a5` | One to five years continous work | P6426 entre 12 y 60 meses | 71 | 100 | 0 | 100 |
| `antig_mas5` | More five years continuous work | P6426 > 60 meses | 71 | 100 | 0 | 100 |
| `contrato_indef` | Fixed employment | P6460 = 1 (indefinido) | 71 | 100 | 0 | 100 |
| `comida` | Free meal | P6590 = 1 | 71 | 100 | 0 | 100 |
| `vacaciones` | Paid holidays | P6424S1 = 1 | 71 | 100 | 0 | 100 |
| `prima_navidad` | Thirteenth month | P6424S2 = 1 | 71 | 100 | 0 | 100 |
| `salud_por_trabajo` | Medical insurance from work | P6100 = 1 y P6110 = 1, 4 | 68 | 100 | 64 | 100 |
| `aporte_pension` | Pension discount | P6920 = 1 | 71 | 100 | 64 | 100 |
| — | Sick leave days | sin pregunta en la GEIH | | | | |
| — | Formal receipt for payment | sin pregunta en la GEIH | | | | |
