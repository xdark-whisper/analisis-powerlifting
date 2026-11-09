-- Numera las competencias de cada levantador y promedia el Dots por número
WITH numeradas AS (
    SELECT Name, Sex, Dots,
           ROW_NUMBER() OVER (PARTITION BY Name, Sex ORDER BY Date) AS nro
    FROM powerlifting
)
SELECT nro AS nro_competencia,
       COUNT(*) AS levantadores,
       ROUND(AVG(Dots), 1) AS dots_promedio
FROM numeradas
WHERE nro <= 10
GROUP BY nro
ORDER BY nro;

-- Compara a los MISMOS levantadores (los que llegaron a 5 competencias)
WITH numeradas AS (
    SELECT Name, Sex, Dots,
           ROW_NUMBER() OVER (PARTITION BY Name, Sex ORDER BY Date) AS nro
    FROM powerlifting
),
llegaron_a_5 AS (
    SELECT Name, Sex
    FROM numeradas
    WHERE nro = 5
)
SELECT COUNT(DISTINCT n.Name || n.Sex) AS levantadores,
       ROUND(AVG(CASE WHEN n.nro = 1 THEN n.Dots END), 1) AS dots_primera,
       ROUND(AVG(CASE WHEN n.nro = 5 THEN n.Dots END), 1) AS dots_quinta
FROM numeradas n
JOIN llegaron_a_5 c ON n.Name = c.Name AND n.Sex = c.Sex
WHERE n.nro IN (1, 5);

-- Mejora promedio de Dots respecto de la competencia anterior
WITH numeradas AS (
    SELECT Name, Sex, Dots,
           ROW_NUMBER() OVER (PARTITION BY Name, Sex ORDER BY Date) AS nro,
           LAG(Dots) OVER (PARTITION BY Name, Sex ORDER BY Date) AS dots_anterior
    FROM powerlifting
)
SELECT nro AS nro_competencia,
       COUNT(*) AS levantadores,
       ROUND(AVG(Dots - dots_anterior), 1) AS cambio_promedio
FROM numeradas
WHERE nro BETWEEN 2 AND 10
GROUP BY nro
ORDER BY nro;


-- ¿Quienes siguen compitiendo arrancaron más fuertes? 
-- Dots de la primera competencia según cuántas competencias hicieron en total
WITH numeradas AS (
    SELECT Name, Sex, Dots,
           ROW_NUMBER() OVER (PARTITION BY Name, Sex ORDER BY Date) AS nro,
           COUNT(*) OVER (PARTITION BY Name, Sex) AS total_comps
    FROM powerlifting
)
SELECT CASE WHEN total_comps >= 10 THEN '10+' ELSE CAST(total_comps AS TEXT) END AS competencias_totales,
       COUNT(*) AS levantadores,
       ROUND(AVG(Dots), 1) AS dots_primera
FROM numeradas
WHERE nro = 1
GROUP BY competencias_totales
ORDER BY MIN(total_comps);

-- Años promedio que pasan entre la primera y la quinta competencia
WITH numeradas AS (
    SELECT Name, Sex, Date,
           ROW_NUMBER() OVER (PARTITION BY Name, Sex ORDER BY Date) AS nro,
           MIN(Date) OVER (PARTITION BY Name, Sex) AS primera_fecha
    FROM powerlifting
)
SELECT COUNT(*) AS levantadores,
       ROUND(AVG(julianday(Date) - julianday(primera_fecha)) / 365.25, 1) AS anios_hasta_la_quinta
FROM numeradas
WHERE nro = 5;