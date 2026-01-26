

-- ¿Cuál es el idioma (y código del idioma) oficial más hablado por diferentes países en Europa?

select * from countrylanguage where isofficial = true;

select * from country;

select * from continent;

Select * from "language";

SELECT COUNT(*) AS total, a.code, a.name AS language FROM language a
INNER JOIN countrylanguage b ON  a.code = b.languagecode
INNER JOIN country c ON b.countrycode = c.code
INNER JOIN continent d ON c.continent = d.code
where b.isofficial = true AND d.name = 'Europe'
GROUP BY a.code, a.name
ORDER BY total desc
LIMIT 1;

-- Otra forma de hacerlo
SELECT count(*), b.languagecode, b.language FROM country a
INNER JOIN countrylanguage b ON a.code = b.countrycode
WHERE a.continent = 5 AND b.isofficial = true
GROUP BY b.language
ORDER BY count(*) DESC
LIMIT 1;

-- Listado de todos los países cuyo idioma oficial es el más hablado de Europa 
-- (no hacer subquery, tomar el código anterior)
-- 135

SELECT a.*, c.name AS language FROM country a
INNER JOIN countrylanguage b ON a.code = b.countrycode
INNER JOIN language c ON b.languagecode = c.code
WHERE c.code = 135 AND a.continen = 5 AND b.isofficial = true







