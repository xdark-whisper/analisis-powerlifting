-- Tipos de equipamiento y cantidad de registros
SELECT Equipment, COUNT(*) AS registros
FROM powerlifting
GROUP BY Equipment
ORDER BY registros DESC;

-- Dots promedio por edad exacta y sexo (solo Raw)
SELECT CAST(Age AS INTEGER) AS edad,
       Sex,
       COUNT(*) AS registros,
       ROUND(AVG(Dots), 1) AS dots_promedio
FROM powerlifting
WHERE Equipment = 'Raw'
  AND Sex IN ('M', 'F')
  AND Age = CAST(Age AS INTEGER)
  AND Age BETWEEN 14 AND 70
GROUP BY edad, Sex
HAVING COUNT(*) >= 200
ORDER BY Sex, edad;

-- Edad en la que cada levantador logró su mejor Dots (solo quienes compitieron 5+ veces, Raw)
WITH ranking AS (
    SELECT Name, Sex, Age, Dots,
           ROW_NUMBER() OVER (PARTITION BY Name, Sex ORDER BY Dots DESC) AS puesto,
           COUNT(*) OVER (PARTITION BY Name, Sex) AS total_comps
    FROM powerlifting
    WHERE Equipment = 'Raw'
      AND Sex IN ('M', 'F')
      AND Age = CAST(Age AS INTEGER)
)
SELECT Sex,
       CAST(Age AS INTEGER) AS edad_mejor_marca,
       COUNT(*) AS levantadores
FROM ranking
WHERE puesto = 1 AND total_comps >= 5
GROUP BY Sex, edad_mejor_marca
ORDER BY Sex, edad_mejor_marca;

-- Mejora de Dots entre la 1ª y la 5ª competencia según la edad al debutar (solo Raw)
-- "Primera" = primera competencia Raw con edad informada
WITH numeradas AS (
    SELECT Name, Sex, Age, Dots,
           ROW_NUMBER() OVER (PARTITION BY Name, Sex ORDER BY Date) AS nro
    FROM powerlifting
    WHERE Equipment = 'Raw'
      AND Sex IN ('M', 'F')
      AND Age IS NOT NULL
),
primera AS (
    SELECT Name, Sex, Age AS edad_debut, Dots AS dots_primera
    FROM numeradas
    WHERE nro = 1
),
quinta AS (
    SELECT Name, Sex, Dots AS dots_quinta
    FROM numeradas
    WHERE nro = 5
)
SELECT CASE WHEN p.edad_debut < 20 THEN '1) Menos de 20'
            WHEN p.edad_debut < 30 THEN '2) 20 a 29'
            WHEN p.edad_debut < 40 THEN '3) 30 a 39'
            WHEN p.edad_debut < 50 THEN '4) 40 a 49'
            ELSE '5) 50 o más' END AS edad_al_debutar,
       COUNT(*) AS levantadores,
       ROUND(AVG(p.dots_primera), 1) AS dots_primera,
       ROUND(AVG(q.dots_quinta), 1) AS dots_quinta,
       ROUND(AVG(q.dots_quinta - p.dots_primera), 1) AS mejora
FROM primera p
JOIN quinta q ON p.Name = q.Name AND p.Sex = q.Sex
GROUP BY edad_al_debutar
ORDER BY edad_al_debutar;