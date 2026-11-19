*==============================================================================
* TP Desarrollo Económico Aplicado - Maestría en Economía Aplicada (UBA)
* Encuestas de hogares 2020 - Colombia (GEIH, DANE)
* Alumnos: César Leonardo Ferrer y Santiago Martínez Soler
* Profesora: Vera Chiodi
*
* Arma la base de personas del primer (ene-mar) y segundo (abr-jun) trimestre
* de 2020 y construye las variables pedidas por la cátedra.
*
* Insumos: los zips mensuales de la GEIH 2020 del DANE (1.Enero.zip a
* 6.Junio.zip), en la carpeta $root/zips.
* Resultado: geih_colombia_2020_q1q2.dta (variable trimestre: 1 = Q1, 2 = Q2).
*
* Disponibilidad:
* - De marzo a junio, en las cabeceras (CLASE==1) se usó un formulario
*   telefónico reducido. Solo pregunta ingreso del empleo principal, horas,
*   posición ocupacional y, desde mayo, salud, pensión, tamaño y lugar de
*   trabajo. El resto (rural) siguió con el formulario completo.
* - La tabla "Otros ingresos" solo está en enero y febrero. Por eso el ingreso
*   total individual y del hogar (y sus deciles) solo existen en ene-feb.
* - "Sick leave days" y "Formal receipt for payment" no tienen pregunta
*   equivalente en la GEIH 2020: no se construyen.
*==============================================================================

clear all
set more off
version 16

* --- CAMBIAR ESTA RUTA: carpeta con este do-file y la subcarpeta zips --------
global root "C:/Users/TU_USUARIO/Documents/TP_GEIH_Colombia"
*------------------------------------------------------------------------------

global zips "$root/zips"
global raw  "$root/raw"
cap mkdir "$raw"

*==============================================================================
* 1. Descomprimir los zips de enero a junio
*==============================================================================
local zip01 "1.Enero.zip"
local zip02 "2.Febrero.zip"
local zip03 "3.Marzo.zip"
local zip04 "4.Abril.zip"
local zip05 "5.Mayo.zip"
local zip06 "6.Junio.zip"

local dir_actual "`c(pwd)'"
foreach m in 01 02 03 04 05 06 {
    cap mkdir "$raw/m`m'"
    cd "$raw/m`m'"
    unzipfile "$zips/`zip`m''", replace
}
cd "`dir_actual'"

*==============================================================================
* 2. Bases de Q1 y Q2 y variables
*==============================================================================
local usar DIRECTORIO SECUENCIA_P ORDEN HOGAR CLASE AREA DPTO MES FEX_C ///
    P6040 P6020 P6050 P6090 P6100 P6110 OCI DSI INI PETI ///
    P6430 P6500 P6750 P6760 P550 P6510S1 P6510S2 P6545S1 P6545S2 ///
    P6580S1 P6580S2 P6585S1A1 P6585S1A2 P6585S2A1 P6585S2A2 ///
    P6585S3A1 P6585S3A2 P6585S4A1 P6585S4A2 ///
    P6630S1A1 P6630S2A1 P6630S3A1 P6630S4A1 P6630S6A1 ///
    P7040 P7045 P7070 P6800 P7090 P7110 P7120 P7130 P7150 ///
    P6880 P6426 P6440 P6460 P6590 P6424S1 P6424S2 P6920 ///
    P7500S1A1 P7500S2A1 P7500S3A1 ///
    P7510S1A1 P7510S2A1 P7510S3A1 P7510S5A1 P7510S6A1 P7510S7A1

tempfile acum ocu oi

foreach m in 01 02 03 04 05 06 {

    local sub : dir "$raw/m`m'" dirs "*"
    local sub : word 1 of `sub'
    local dtadir "$raw/m`m'/`sub'/DTA"

    * --- ocupados
    local f : dir "`dtadir'" files "Ocupados*", respectcase
    local f : word 1 of `f'
    use "`dtadir'/`f'", clear
    rename *, upper
    keep DIRECTORIO SECUENCIA_P ORDEN P*
    save `ocu', replace

    * --- otros ingresos (solo existe en enero y febrero)
    local f : dir "`dtadir'" files "Otros ingresos*", respectcase
    local hay_oi = (`"`f'"' != "")
    if `hay_oi' {
        local f : word 1 of `f'
        use "`dtadir'/`f'", clear
        rename *, upper
        keep DIRECTORIO SECUENCIA_P ORDEN P7500* P7510*
        save `oi', replace
    }

    * --- personas
    local f : dir "`dtadir'" files "*ersonas*", respectcase
    local f : word 1 of `f'
    use "`dtadir'/`f'", clear
    rename *, upper
    cap rename FEX_C_2011 FEX_C

    merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using `ocu', nogen keep(master match)
    if `hay_oi' merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using `oi', nogen keep(master match)

    local keep ""
    foreach v of local usar {
        cap confirm variable `v'
        if !_rc local keep `keep' `v'
    }
    keep `keep'
    destring _all, replace
    gen mes_n = real("`m'")

    if "`m'" != "01" append using `acum', force
    save `acum', replace
    di as result "Mes `m' listo (otros ingresos: `hay_oi')"
}

use `acum', clear

* variables que no existen en ningún mes quedan creadas como missing
foreach v of local usar {
    cap confirm variable `v'
    if _rc gen `v' = .
}

*------------------------------------------------------------------------------
* Auxiliares
*------------------------------------------------------------------------------
gen trimestre     = cond(mes_n <= 3, 1, 2)
gen form_reducido = (CLASE == 1 & mes_n >= 3)
gen ocu   = (OCI == 1)
gen asal  = ocu & inlist(P6430, 1, 2, 3, 8)
gen indep = ocu & inlist(P6430, 4, 5, 9)
gen miembro = !inlist(P6050, 6, 7, 8)   // excluye servicio doméstico, pensionistas y trabajadores

label var trimestre     "Trimestre (1=ene-mar, 2=abr-jun)"
label var form_reducido "Formulario telefónico reducido (cabecera, mar-jun)"

* montos: 98 = no sabe, 99 = no informa
foreach v in P6500 P6750 P550 P7070 P6510S1 P6545S1 P6580S1 ///
             P6585S1A1 P6585S2A1 P6585S3A1 P6585S4A1 ///
             P6630S1A1 P6630S2A1 P6630S3A1 P6630S4A1 P6630S6A1 ///
             P7500S1A1 P7500S2A1 P7500S3A1 ///
             P7510S1A1 P7510S2A1 P7510S3A1 P7510S5A1 P7510S6A1 P7510S7A1 {
    replace `v' = . if inlist(`v', 98, 99)
}

*------------------------------------------------------------------------------
* Ingresos (mensuales, pesos corrientes)
*------------------------------------------------------------------------------
* Main job income
gen ing_ppal = .
replace ing_ppal = P6500 if asal
replace ing_ppal = P6750 / P6760 if indep & P6760 > 0 & !missing(P6760)
replace ing_ppal = P550 / 12 if indep & missing(ing_ppal) & !missing(P550)
replace ing_ppal = 0 if ocu & inlist(P6430, 6, 7)

* Monthly wage extras: horas extras, primas, bonificaciones y subsidios no
* incluidos en el salario declarado + primas anuales / 12
gen extras_sal = 0 if asal & !form_reducido
foreach par in "P6510S1 P6510S2" "P6545S1 P6545S2" "P6580S1 P6580S2" ///
               "P6585S1A1 P6585S1A2" "P6585S2A1 P6585S2A2" ///
               "P6585S3A1 P6585S3A2" "P6585S4A1 P6585S4A2" {
    local a : word 1 of `par'
    local b : word 2 of `par'
    replace extras_sal = extras_sal + `a' if !missing(extras_sal, `a') & `b' == 2
}
foreach s in 1 2 3 4 6 {
    replace extras_sal = extras_sal + P6630S`s'A1 / 12 if !missing(extras_sal, P6630S`s'A1)
}

* Other job income
gen ing_sec = P7070 if ocu & !form_reducido & P7040 == 1
replace ing_sec = 0 if ocu & !form_reducido & P7040 == 2

* Total non work income (solo ene-feb): mensuales + últimos 12 meses / 12
gen ing_nolab = 0 if mes_n <= 2 & PETI == 1
foreach v in P7500S1A1 P7500S2A1 P7500S3A1 {
    replace ing_nolab = ing_nolab + `v' if !missing(ing_nolab, `v')
}
foreach v in P7510S1A1 P7510S2A1 P7510S3A1 P7510S5A1 P7510S6A1 P7510S7A1 {
    replace ing_nolab = ing_nolab + `v' / 12 if !missing(ing_nolab, `v')
}

* Total individual income (solo ene-feb)
egen ing_lab = rowtotal(ing_ppal extras_sal ing_sec)
gen ing_ind = ing_lab + ing_nolab if mes_n <= 2
drop ing_lab

* Household income y per capita
gen ing_ind_m = ing_ind if miembro
bysort mes_n DIRECTORIO SECUENCIA_P: egen ing_hogar  = total(ing_ind_m), missing
bysort mes_n DIRECTORIO SECUENCIA_P: egen n_miembros = total(miembro)
gen ing_pc = ing_hogar / n_miembros
drop ing_ind_m

* Deciles (ponderados, dentro de cada trimestre)
gen dec_ing   = .
gen dec_ingpc = .
forvalues t = 1/2 {
    qui count if trimestre == `t' & P6050 == 1 & !missing(ing_hogar)
    if r(N) > 0 {
        xtile tmp = ing_hogar [pw = FEX_C] if trimestre == `t' & P6050 == 1, nq(10)
        replace dec_ing = tmp if trimestre == `t' & P6050 == 1
        drop tmp
        xtile tmp = ing_pc [pw = FEX_C] if trimestre == `t' & miembro, nq(10)
        replace dec_ingpc = tmp if trimestre == `t' & miembro
        drop tmp
    }
}
bysort mes_n DIRECTORIO SECUENCIA_P: egen tmp = max(dec_ing)
replace dec_ing = tmp
drop tmp

*------------------------------------------------------------------------------
* Horas
*------------------------------------------------------------------------------
gen hrs_ppal = P6800 if ocu
gen hrs_sec  = P7045 if ocu & P7040 == 1
replace hrs_sec = 0 if ocu & P7040 == 2

*------------------------------------------------------------------------------
* Salud
*------------------------------------------------------------------------------
gen salud_publica = (P6100 == 3) if inlist(P6090, 1, 2)   // régimen subsidiado
gen sin_salud     = (P6090 == 2) if inlist(P6090, 1, 2)

*------------------------------------------------------------------------------
* Empleo, horas deseadas y búsqueda (universo: ocupados)
*------------------------------------------------------------------------------
gen un_empleo           = (P7040 == 2) if ocu & inlist(P7040, 1, 2)
gen multi_empleo        = (P7040 == 1) if ocu & inlist(P7040, 1, 2)
gen quiere_mas_hrs      = (P7090 == 1) if ocu & inlist(P7090, 1, 2)
gen quiere_disp_mas_hrs = (P7090 == 1 & P7120 == 1) if ocu & inlist(P7090, 1, 2)
gen busca_mas_hrs       = (P7090 == 1 & P7110 == 1) if ocu & inlist(P7090, 1, 2)
gen busca_otro_empleo   = (P7150 == 1) if ocu & inlist(P7130, 1, 2)

* Subempleo por insuficiencia de horas: quiere y puede trabajar más, y
* trabaja normalmente menos de 48 horas en total (umbral del DANE)
gen hrs_tot = hrs_ppal + hrs_sec
gen subempleado  = (P7090 == 1 & P7120 == 1 & hrs_tot < 48) ///
                   if ocu & inlist(P7090, 1, 2) & !missing(hrs_tot)
gen pleno_empleo = 1 - subempleado
drop hrs_tot

*------------------------------------------------------------------------------
* Sector y lugar de trabajo (universo: ocupados)
*------------------------------------------------------------------------------
gen sector_publico     = (P6430 == 2) if ocu & !missing(P6430)
gen sector_privado     = (P6430 == 1) if ocu & !missing(P6430)
gen servicio_domestico = (P6430 == 3) if ocu & !missing(P6430)

gen lugar_oficina_negocio_finca = inlist(P6880, 7, 8)    if ocu & inrange(P6880, 1, 11)
gen lugar_casa_cliente          = (P6880 == 2)           if ocu & inrange(P6880, 1, 11)
gen lugar_calle_movil           = inlist(P6880, 4, 5, 6) if ocu & inrange(P6880, 1, 11)

*------------------------------------------------------------------------------
* Antigüedad (meses continuos en la empresa, universo: ocupados)
*------------------------------------------------------------------------------
gen antig_1a5  = inrange(P6426, 12, 60) if ocu & !missing(P6426)
gen antig_mas5 = (P6426 > 60)           if ocu & !missing(P6426)

*------------------------------------------------------------------------------
* Beneficios (universo: asalariados, salvo salud y pensión: ocupados)
*------------------------------------------------------------------------------
gen contrato_indef = (P6440 == 1 & P6460 == 1)   if asal & inlist(P6440, 1, 2)
gen comida         = (P6590 == 1)                if asal & inlist(P6590, 1, 2, 9)
gen vacaciones     = (P6440 == 1 & P6424S1 == 1) if asal & inlist(P6440, 1, 2)
gen prima_navidad  = (P6440 == 1 & P6424S2 == 1) if asal & inlist(P6440, 1, 2)
gen salud_por_trabajo = (P6100 == 1 & inlist(P6110, 1, 4)) if ocu & inlist(P6090, 1, 2)
gen aporte_pension    = (P6920 == 1) if ocu & inlist(P6920, 1, 2, 3)

*------------------------------------------------------------------------------
* Etiquetas (nombres de la lista de la cátedra)
*------------------------------------------------------------------------------
label var ing_hogar            "Household income"
label var ing_pc               "Per capita family income"
label var dec_ing              "Decile income"
label var dec_ingpc            "Decile pc income"
label var hrs_ppal             "Week hours main job"
label var hrs_sec              "Week hours other job"
label var ing_ind              "Total individual income"
label var ing_sec              "Other job income"
label var ing_ppal             "Main job income"
label var extras_sal           "Monthly wage extras"
label var ing_nolab            "Total non work income"
label var salud_publica        "Public health coverage"
label var sin_salud            "No health coverage"
label var un_empleo            "One job"
label var multi_empleo         "More than one job"
label var quiere_mas_hrs       "Want work more"
label var quiere_disp_mas_hrs  "Want can work more"
label var busca_mas_hrs        "Search + hrs to work last month"
label var busca_otro_empleo    "Search another job"
label var subempleado          "Under employed"
label var pleno_empleo         "Full employed"
label var sector_publico       "Public sector job"
label var sector_privado       "Private sector job"
label var servicio_domestico   "Domestic employee"
label var lugar_oficina_negocio_finca "Office business farm employee"
label var lugar_casa_cliente   "At customers home"
label var lugar_calle_movil    "Street mobile employee"
label var antig_1a5            "One to five years continous work"
label var antig_mas5           "More five years continuous work"
label var contrato_indef       "Fixed employment"
label var comida               "Free meal"
label var vacaciones           "Paid holidays"
label var prima_navidad        "Thirteenth month"
label var salud_por_trabajo    "Medical insurance from work"
label var aporte_pension       "Pension discount"

local vars ing_hogar ing_pc dec_ing dec_ingpc hrs_ppal hrs_sec ing_ind ing_sec ///
    ing_ppal extras_sal ing_nolab salud_publica sin_salud un_empleo multi_empleo ///
    quiere_mas_hrs quiere_disp_mas_hrs busca_mas_hrs busca_otro_empleo ///
    subempleado pleno_empleo sector_publico sector_privado servicio_domestico ///
    lugar_oficina_negocio_finca lugar_casa_cliente lugar_calle_movil ///
    antig_1a5 antig_mas5 contrato_indef comida vacaciones prima_navidad ///
    salud_por_trabajo aporte_pension

*------------------------------------------------------------------------------
* Control: medias ponderadas por trimestre
*------------------------------------------------------------------------------
tabstat `vars' [aw = FEX_C], by(trimestre) stat(mean n) columns(statistics) format(%12.3f)

keep DIRECTORIO SECUENCIA_P ORDEN HOGAR trimestre mes_n form_reducido ///
     CLASE AREA DPTO FEX_C P6020 P6040 P6050 OCI DSI INI PETI `vars'
compress
order DIRECTORIO SECUENCIA_P ORDEN HOGAR trimestre mes_n form_reducido ///
      CLASE AREA DPTO FEX_C P6020 P6040 P6050 OCI DSI INI PETI `vars'
save "$root/geih_colombia_2020_q1q2.dta", replace

*==============================================================================
* 3. Estructura de panel: ¿se pueden seguir hogares entre meses?
*    Según la metodología del DANE, la GEIH rota segmentos y no es un panel.
*    Resultado: 337 DIRECTORIO aparecen en dos meses (marzo-mayo y abril-mayo),
*    pero no son las mismas personas: el sexo coincide ~50% de las veces, la
*    edad (0 o 1 año de diferencia) ~3% y el área ~5%.
*==============================================================================
use "$root/geih_colombia_2020_q1q2.dta", clear

* 1) hogares (DIRECTORIO) en cuántos meses distintos aparecen
preserve
keep DIRECTORIO mes_n
duplicates drop
bysort DIRECTORIO: gen n_meses = _N
by DIRECTORIO: keep if _n == 1
tab n_meses
restore

* 2) ¿son las mismas personas? cruzar meses y comparar sexo, edad y área
foreach par in "3 5" "4 5" {
    local a : word 1 of `par'
    local b : word 2 of `par'

    preserve
    keep if mes_n == `b'
    keep DIRECTORIO SECUENCIA_P ORDEN P6020 P6040 AREA
    rename (P6020 P6040 AREA) (sexo_b edad_b area_b)
    tempfile mb
    save `mb'
    restore

    preserve
    keep if mes_n == `a'
    keep DIRECTORIO SECUENCIA_P ORDEN P6020 P6040 AREA
    merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using `mb', keep(match) nogen
    di as result _n "Mes `a' vs mes `b': " _N " personas con el mismo identificador"
    gen mismo_sexo = P6020 == sexo_b
    gen edad_ok    = inlist(edad_b - P6040, 0, 1)
    gen misma_area = AREA == area_b
    sum mismo_sexo edad_ok misma_area
    restore
}
