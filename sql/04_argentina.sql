-- Argentina vs resto del mundo, por sexo (solo Raw)
SELECT CASE WHEN MeetCountry = 'Argentina' THEN 'Argentina' ELSE 'Resto del mundo' END AS grupo,
       Sex,
       COUNT(*) AS registros,
       COUNT(DISTINCT Name) AS levantadores_distintos,
       ROUND(AVG(Dots), 1) AS dots_promedio
FROM powerlifting
WHERE Equipment = 'Raw' AND Sex IN ('M', 'F')
GROUP BY grupo, Sex
ORDER BY Sex, grupo;

-- Argentina vs resto del mundo en el mismo período (2023 en adelante), solo Raw
SELECT CASE WHEN MeetCountry = 'Argentina' THEN 'Argentina' ELSE 'Resto del mundo' END AS grupo,
       Sex,
       COUNT(*) AS registros,
       ROUND(AVG(Dots), 1) AS dots_promedio
FROM powerlifting
WHERE Equipment = 'Raw' AND Sex IN ('M', 'F') AND Year >= 2023
GROUP BY grupo, Sex
ORDER BY Sex, grupo;

-- Argentina (Raw): Dots promedio por año y federación, desde 2022
SELECT Year, Federation,
       COUNT(*) AS registros,
       ROUND(AVG(Dots), 1) AS dots_promedio
FROM powerlifting
WHERE MeetCountry = 'Argentina' AND Equipment = 'Raw' AND Year >= 2022
GROUP BY Year, Federation
ORDER BY Year, registros DESC;

-- Salto 2023 -> 2024 usando solo federaciones presentes en ambos años
SELECT Year, COUNT(*) AS registros, ROUND(AVG(Dots), 1) AS dots_promedio
FROM powerlifting
WHERE MeetCountry = 'Argentina' AND Equipment = 'Raw'
  AND Year IN (2023, 2024)
  AND Federation IN ('WRPF-Argentina', 'FALPO', 'ARPL', 'AAP')
GROUP BY Year;