-- Total y Dots promedio según equipamiento y sexo (desde 2015)
SELECT Equipment, Sex,
       COUNT(*) AS registros,
       ROUND(AVG(TotalKg), 1) AS total_promedio,
       ROUND(AVG(Dots), 1) AS dots_promedio
FROM powerlifting
WHERE Sex IN ('M', 'F') AND Equipment <> 'Straps' AND Year >= 2015
GROUP BY Equipment, Sex
ORDER BY Sex, dots_promedio;

-- Mismos levantadores: mejor Dots en Raw vs en Single-ply (desde 2015)
WITH por_persona AS (
    SELECT Name, Sex,
           MAX(CASE WHEN Equipment = 'Raw' THEN Dots END) AS mejor_raw,
           MAX(CASE WHEN Equipment = 'Single-ply' THEN Dots END) AS mejor_single
    FROM powerlifting
    WHERE Sex IN ('M', 'F') AND Year >= 2015
    GROUP BY Name, Sex
)
SELECT Sex,
       COUNT(*) AS levantadores,
       ROUND(AVG(mejor_raw), 1) AS dots_raw,
       ROUND(AVG(mejor_single), 1) AS dots_single_ply,
       ROUND(AVG(mejor_single - mejor_raw), 1) AS diferencia
FROM por_persona
WHERE mejor_raw IS NOT NULL AND mejor_single IS NOT NULL
GROUP BY Sex;

-- Cada levantamiento como múltiplo del peso corporal, según equipamiento (desde 2015)
SELECT Equipment, Sex,
       COUNT(*) AS registros,
       ROUND(AVG(Best3SquatKg / BodyweightKg), 2) AS sentadilla,
       ROUND(AVG(Best3BenchKg / BodyweightKg), 2) AS banca,
       ROUND(AVG(Best3DeadliftKg / BodyweightKg), 2) AS peso_muerto
FROM powerlifting
WHERE Sex IN ('M', 'F') AND Equipment <> 'Straps' AND Year >= 2015
  AND Best3SquatKg > 0 AND Best3BenchKg > 0 AND Best3DeadliftKg > 0
GROUP BY Equipment, Sex
ORDER BY Sex, sentadilla;

-- Mismas personas: diferencia (Single-ply menos Raw) en cada levantamiento, como múltiplo del peso corporal
WITH por_persona AS (
    SELECT Name, Sex,
           MAX(CASE WHEN Equipment = 'Raw' THEN Best3SquatKg / BodyweightKg END) AS sq_raw,
           MAX(CASE WHEN Equipment = 'Single-ply' THEN Best3SquatKg / BodyweightKg END) AS sq_sp,
           MAX(CASE WHEN Equipment = 'Raw' THEN Best3BenchKg / BodyweightKg END) AS bn_raw,
           MAX(CASE WHEN Equipment = 'Single-ply' THEN Best3BenchKg / BodyweightKg END) AS bn_sp,
           MAX(CASE WHEN Equipment = 'Raw' THEN Best3DeadliftKg / BodyweightKg END) AS dl_raw,
           MAX(CASE WHEN Equipment = 'Single-ply' THEN Best3DeadliftKg / BodyweightKg END) AS dl_sp
    FROM powerlifting
    WHERE Sex IN ('M', 'F') AND Year >= 2015
      AND Best3SquatKg > 0 AND Best3BenchKg > 0 AND Best3DeadliftKg > 0
    GROUP BY Name, Sex
)
SELECT Sex,
       COUNT(*) AS levantadores,
       ROUND(AVG(sq_sp - sq_raw), 2) AS dif_sentadilla,
       ROUND(AVG(bn_sp - bn_raw), 2) AS dif_banca,
       ROUND(AVG(dl_sp - dl_raw), 2) AS dif_peso_muerto
FROM por_persona
WHERE sq_raw IS NOT NULL AND sq_sp IS NOT NULL
  AND bn_raw IS NOT NULL AND bn_sp IS NOT NULL
  AND dl_raw IS NOT NULL AND dl_sp IS NOT NULL
GROUP BY Sex;