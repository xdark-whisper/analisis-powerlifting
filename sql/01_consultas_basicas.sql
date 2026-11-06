-- 1. Cantidad total de registros
SELECT COUNT(*) FROM powerlifting;

-- 2. Rendimiento promedio por sexo
SELECT Sex,
       COUNT(*) AS registros,
       ROUND(AVG(TotalKg), 1) AS total_promedio,
       ROUND(AVG(Dots), 1) AS dots_promedio
FROM powerlifting
GROUP BY Sex;

-- 3. Los 10 países con más registros
SELECT MeetCountry, COUNT(*) AS registros
FROM powerlifting
GROUP BY MeetCountry
ORDER BY registros DESC
LIMIT 10;

-- 4. Argentina contra el resto del mundo
SELECT CASE WHEN MeetCountry = 'Argentina' THEN 'Argentina' ELSE 'Resto del mundo' END AS grupo,
       COUNT(*) AS registros,
       ROUND(AVG(Dots), 1) AS dots_promedio
FROM powerlifting
GROUP BY grupo;