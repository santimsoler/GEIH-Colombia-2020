*==============================================================================
* TP Desarrollo Económico Aplicado - Maestría en Economía Aplicada (UBA)
* Encuestas de hogares 2020 - Colombia (GEIH, DANE)
* Alumnos: César Leonardo Ferrer y Santiago Martínez Soler
* Profesora: Vera Chiodi
*
* 00_master.do: define rutas y corre todo el proceso
*==============================================================================

clear all
set more off
version 16

* --- CAMBIAR ESTA RUTA a la carpeta donde clonaste el repo -------------------
global root "C:/Users/TU_USUARIO/Documents/GEIH-Colombia-2020"
*------------------------------------------------------------------------------

global do      "$root/do"
global zips    "$root/data/raw/zips"     // acá van los 6 zips del DANE (1.Enero.zip ... 6.Junio.zip)
global raw     "$root/data/raw"
global derived "$root/data/derived"
global output  "$root/output"

cap mkdir "$derived"
cap mkdir "$output"

do "$do/01_descomprimir.do"
do "$do/02_armar_trimestres.do"
do "$do/03_validar_y_tasas.do"
do "$do/04_panel.do"
do "$do/05_variables.do"
