*==============================================================================
* 02_armar_trimestres.do
* Arma las bases de personas de Q1 (ene-mar) y Q2 (abr-jun) 2020 a partir de
* la tabla "Características generales (personas)" de cada mes.
*
* Notas:
* - Marzo y abril solo traen 3 tablas (personas, fuerza de trabajo, ocupados).
*   La condición de actividad (OCI, DSI, INI, PETI) está en la tabla de
*   personas, así que no se pierde información en esos meses.
* - Los nombres de archivo del DANE tienen errores de tipeo y acentos, por eso
*   se buscan por patrón ("*ersonas*").
* - El factor de expansión figura como FEX_C (en el diccionario: fex_c_2011).
*==============================================================================

local vars DIRECTORIO SECUENCIA_P ORDEN HOGAR AREA CLASE DPTO MES FEX_C ///
           P6040 P6020 P6050 P6210 ESC OCI DSI INI PETI PEAI DSAI DSOI CES

tempfile acum

foreach m in 01 02 03 04 05 06 {

    * carpeta del mes (ej: "1. Enero", "2.Febrero")
    local sub : dir "$raw/m`m'" dirs "*"
    local sub : word 1 of `sub'
    local dtadir "$raw/m`m'/`sub'/DTA"

    * archivo de personas
    local f : dir "`dtadir'" files "*ersonas*", respectcase
    local f : word 1 of `f'
    di as text "Mes `m': `f'"

    use "`dtadir'/`f'", clear
    rename *, upper
    cap rename FEX_C_2011 FEX_C

    * conservar solo las variables que existen en el mes
    local keep ""
    foreach v of local vars {
        cap confirm variable `v'
        if !_rc local keep `keep' `v'
    }
    * variables COVID (solo mayo y junio)
    cap ds P3147*
    if !_rc local keep `keep' `r(varlist)'

    keep `keep'
    destring _all, replace

    gen mes_n = real("`m'")
    gen trimestre = cond(mes_n <= 3, 1, 2)

    if "`m'" != "01" append using `acum'
    save `acum', replace
}

use `acum', clear
order DIRECTORIO SECUENCIA_P ORDEN trimestre mes_n
label define trim 1 "Q1 (ene-mar)" 2 "Q2 (abr-jun)"
label values trimestre trim

label var FEX_C   "Factor de expansión"
label var P6040   "Edad"
label var P6020   "Sexo (1=hombre, 2=mujer)"
label var OCI     "Ocupado (1)"
label var DSI     "Desocupado (1)"
label var INI     "Inactivo (1)"
label var PETI    "Población en edad de trabajar (1)"

compress
preserve
keep if trimestre == 1
save "$derived/geih_q1_2020_personas.dta", replace
restore
keep if trimestre == 2
save "$derived/geih_q2_2020_personas.dta", replace

* base apilada para comparar trimestres
use "$derived/geih_q1_2020_personas.dta", clear
append using "$derived/geih_q2_2020_personas.dta"
save "$derived/geih_s1_2020_personas.dta", replace

tab mes_n trimestre
