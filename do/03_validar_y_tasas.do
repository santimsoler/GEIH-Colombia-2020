*==============================================================================
* 03_validar_y_tasas.do
* Valida la condición de actividad y calcula tasas mensuales ponderadas.
* Resultado esperado (verificado en Python con los CSV):
*   mes  TD    TO    TGP
*   1    13,5  55,3  63,9
*   2    12,8  56,1  64,3
*   3    13,2  52,5  60,4
*   4    20,5  42,5  53,4
*   5    22,0  44,2  56,7
*   6    20,4  46,9  58,9
*==============================================================================

use "$derived/geih_s1_2020_personas.dta", clear

foreach v in OCI DSI INI PETI {
    replace `v' = 0 if missing(`v')
}

* 1) OCI, DSI e INI son excluyentes y suman PETI
assert OCI + DSI + INI <= 1
assert OCI + DSI + INI == PETI

* 2) edad mínima de la PET (en estas bases es 15)
sum P6040 if PETI == 1
di as result "Edad mínima PET: " r(min)

* 3) población expandida por mes (~49 millones)
tabstat FEX_C, by(mes_n) stat(sum) format(%14.0fc)

* 4) tasas de mercado de trabajo
gen PEA = (OCI == 1 | DSI == 1)
collapse (sum) OCI DSI PEA PETI [pw = FEX_C], by(mes_n)
gen TD  = 100 * DSI / PEA
gen TO  = 100 * OCI / PETI
gen TGP = 100 * PEA / PETI
format TD TO TGP %5.1f
list mes_n TD TO TGP, noobs sep(0)

export delimited using "$output/tasas_mensuales_2020.csv", replace
