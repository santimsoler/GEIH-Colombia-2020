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

* --- CAMBIAR ESTA RUTA a la carpeta donde está el repo -----------------------
global root "C:/Users/TU_USUARIO/Documents/GEIH-Colombia-2020"
*------------------------------------------------------------------------------

global do      "$root/do"
global zips    "$root/data/raw/zips"
global raw     "$root/data/raw"
global derived "$root/data/derived"

cap mkdir "$derived"

do "$do/01_descomprimir.do"
do "$do/02_bases_variables.do"
do "$do/03_panel.do"
