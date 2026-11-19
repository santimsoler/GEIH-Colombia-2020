# Colombia: GEIH, primer y segundo trimestre de 2020

## Fuente de datos y productor

La fuente es la **Gran Encuesta Integrada de Hogares (GEIH)**, producida por el
Departamento Administrativo Nacional de Estadística (**DANE**), a través de su
Dirección de Metodología y Producción Estadística (DIMPE). Es una encuesta
continua, con recolección mensual y muestreo probabilístico, estratificado y
multietápico. Los microdatos se publican por mes en el catálogo
DANE-DIMPE-GEIH-2020 (microdatos.dane.gov.co); cada trimestre se arma uniendo
tres meses.

| | Q1 (ene-mar) | Q2 (abr-jun) |
|---|---|---|
| Personas | 188.314 | 207.686 |
| Hogares | 58.607 | 62.939 |
| Población expandida por mes | ~49 millones | ~49 millones |

## Población cubierta

La población civil no institucional residente en hogares particulares.

## Estructura de panel

La GEIH **no tiene estructura de panel**. La muestra rota por segmentos para que
no se repitan hogares en períodos cortos: en las capitales de departamento, un
mismo segmento no vuelve a encuestarse en al menos tres años. La proporción de
la muestra que puede seguirse entre Q1 y Q2 es, por lo tanto, nula.

Lo verificamos en los microdatos (`do/03_panel.do`): 337 identificadores de
vivienda aparecen en dos meses distintos, pero no corresponden a los mismos
hogares. Al cruzar a sus integrantes, el sexo coincide en la mitad de los casos,
la edad casi nunca y el área tampoco: son identificadores reutilizados.

## Representatividad geográfica

Es representativa a **nivel nacional**, para cabeceras y para centros poblados
y rural disperso. También tiene representatividad para las 13 principales
ciudades con sus áreas metropolitanas, 11 ciudades intermedias y las 8
capitales de los nuevos departamentos. No es solo urbana. La única exclusión
son las cabeceras municipales que no son capitales, los centros poblados y el
rural disperso de los nuevos departamentos, donde vive cerca del 1% de la
población.

## Cambios metodológicos entre Q1 y Q2 de 2020

- **Modo de recolección:** desde marzo de 2020, por la pandemia, en las zonas
  urbanas la encuesta pasó a hacerse por teléfono. En las zonas rurales se
  mantuvo la entrevista presencial.
- **Formulario reducido:** en las zonas urbanas se aplicó un formulario de 39
  preguntas en lugar de unas 200. Mantuvo sexo, edad, clasificación laboral e
  ingreso del empleo principal, y dejó afuera contrato, beneficios, segundo
  empleo, horas deseadas, búsqueda de empleo y otros ingresos. Desde mayo
  volvieron salud, aportes a pensión, tamaño de la empresa y lugar de trabajo.
- **Tablas publicadas:** marzo y abril traen solo tres tablas (personas, fuerza
  de trabajo y ocupados). La tabla de otros ingresos solo existe en enero y
  febrero, por lo que el ingreso total del hogar no puede construirse para Q2.
- **Preguntas nuevas:** en mayo y junio se agregó un bloque sobre dificultades
  causadas por el COVID-19.
- **Indicadores afectados:** el DANE informó que no pudo calcular el subempleo
  entre marzo y junio de 2020.
- **Comparabilidad:** en la práctica, Q2 urbano y Q2 rural se relevaron con
  instrumentos distintos. Las comparaciones entre trimestres solo son
  homogéneas para las variables del formulario reducido o para el área rural.
