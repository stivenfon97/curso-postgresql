SELECT * FROM public.continent
ORDER BY code ASC;

SELECT * FROM public.country
ORDER BY code ASC;

-- COUNTRY A - name, continent (codigo numerico)
-- continent B - name as continent

SELECT a.name, a.continent AS code, b.name
FROM country a
FULL OUTER JOIN continent b ON a.continent = b.code
ORDER BY b.code DESC;

SELECT a.name, a.continent AS code, b.name
FROM country a
RIGHT JOIN continent b ON a.continent = b.code
WHERE a.code IS NULL
ORDER BY b.code DESC;

SELECT COUNT(*) as count, a.continent AS code, b.name
FROM country a
FULL OUTER JOIN continent b ON a.continent = b.code
GROUP BY a.continent, b.name
-- ORDER BY b.code ASC;
-- ORDER BY COUNT(*) ASC;
UNION
SELECT 0 as count, a.continent AS code, b.name
FROM country a
RIGHT JOIN continent b ON a.continent = b.code
WHERE a.continent IS NULL
GROUP BY a.continent, b.name
ORDER BY count ASC;