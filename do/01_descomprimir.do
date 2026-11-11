*==============================================================================
* 01_descomprimir.do
* Descomprime los zips mensuales de la GEIH 2020 (enero a junio).
* Cada zip queda en data/raw/mMM/ (m01, m02, ..., m06).
* Los zips se bajan de: microdatos.dane.gov.co -> GEIH 2020 -> Obtener Microdatos
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
    di as result "Mes `m' descomprimido"
}

cd "`dir_actual'"
