# Análisis de powerlifting con Python y SQL

Análisis exploratorio de más de 2,5 millones de resultados de competencias de
powerlifting para entender cómo se distribuye la fuerza según sexo, edad, peso
corporal y país, y cómo se compara Argentina con el resto del mundo.

## Preguntas que busca responder
- ¿A qué edad se alcanza el pico de fuerza?
- ¿Cómo progresa un levantador entre su primera y sus siguientes competencias?
- ¿Cómo se compara el rendimiento de Argentina con el resto del mundo?

## Datos
Proyecto OpenPowerlifting (openpowerlifting.org), de dominio público (CC0).
Cada fila es un levantador en una competencia. Los datos no se incluyen en
este repo por su tamaño; ver "Cómo reproducirlo".

## Herramientas
Python (pandas, matplotlib, seaborn), SQLite, Jupyter, Git/GitHub.

## Estructura del repo
- `src/`: scripts de limpieza y carga a SQLite
- `sql/`: consultas con comentarios
- `notebooks/`: exploración y análisis
- `data/`: datos (no versionados)

## Cómo reproducirlo
1. Clonar el repo y crear un entorno virtual con Python 3.13.
2. Instalar dependencias: `pip install -r requirements.txt`
3. Descargar el CSV de openpowerlifting.org y guardarlo como `data/raw/openpowerlifting.csv`
4. Ejecutar `python src/limpieza.py`
5. Ejecutar `python src/cargar_sqlite.py`

## Decisiones de limpieza
Se partió de 4.059.940 filas y quedaron 2.591.805.
- Solo competencias completas (sentadilla, banca y peso muerto): el total de
  una competencia de solo banca no es comparable con el de una completa.
- Se descartaron filas sin total, peso corporal o Dots (232.436), típicamente
  levantadores descalificados o con datos incompletos.
- Se eliminaron 108.073 duplicados exactos, que parecen ser la misma actuación
  cargada dos veces en la misma competencia.
- No se borraron las filas sin edad (36% del dataset original): los análisis
  por edad usan solo las filas que la tienen.

## Hallazgos
[pendiente: acá van los gráficos y las conclusiones principales]

## Limitaciones
- "Argentina" se define por el país de la competencia, no por la nacionalidad
  del levantador.
- Cada fila es una competencia, no una persona: quienes compiten más veces
  pesan más en los promedios.

## Autor
Ramirez Sergio Ezequiel - https://github.com/xdark-whisper