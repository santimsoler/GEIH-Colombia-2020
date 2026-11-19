*==============================================================================
* 03_panel.do
* ¿Se pueden seguir los mismos hogares o personas entre Q1 y Q2?
*
* Según la metodología del DANE, la GEIH rota segmentos para no repetir
* hogares en períodos cortos (en capitales, un segmento no se repite en al
* menos tres años). No es un panel.
*
* Resultado esperado: 337 DIRECTORIO aparecen en dos meses (marzo-mayo y
* abril-mayo), pero no son las mismas personas: al cruzarlas, el sexo
* coincide ~50% de las veces, la edad (0 o 1 año de diferencia) ~3% y el
* área ~5%. Son números de directorio reutilizados.
*==============================================================================

use "$derived/geih_q1_2020_variables.dta", clear
append using "$derived/geih_q2_2020_variables.dta"

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
