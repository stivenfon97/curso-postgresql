/*===============================================================*/
/*======================= QUERYS DE PRUEBAS =====================*/
/*===============================================================*/

SELECT date_trunc('week', posts.created_at) AS weeks, 
	COUNT( DISTINCT posts.post_id) AS number_of_posts,
	SUM( claps.counter ) AS total_claps
FROM posts
INNER JOIN claps ON claps.post_id = posts.post_id
GROUP BY weeks
ORDER BY weeks DESC;

UPDATE posts SET created_at = '2025-12-20 16:20:33' WHERE post_id = 1

/*=======================================================================*/
/*=================== VISTAS & VISTAS MATERIALIZADAS ====================*/
/*=======================================================================*/

CREATE VIEW comments_per_week AS
SELECT date_trunc('week', posts.created_at) AS weeks, 
	COUNT( DISTINCT posts.post_id) AS number_of_posts,
	SUM( claps.counter ) AS total_claps,
	COUNT(*) AS number_of_claps
FROM posts
INNER JOIN claps ON claps.post_id = posts.post_id
GROUP BY weeks
ORDER BY weeks DESC;

SELECT * FROM comments_per_week;

CREATE MATERIALIZED VIEW comments_per_week_mat AS
SELECT date_trunc('week', posts.created_at) AS weeks, 
	COUNT( DISTINCT posts.post_id) AS number_of_posts,
	SUM( claps.counter ) AS total_claps,
	COUNT(*) AS number_of_claps
FROM posts
INNER JOIN claps ON claps.post_id = posts.post_id
GROUP BY weeks
ORDER BY weeks DESC;


SELECT * FROM comments_per_week_mat;

#Refresh de la vista materializada para actualizar los datos
REFRESH MATERIALIZED VIEW comments_per_week_mat;

# Renombrar la vista materializada
ALTER VIEW comments_per_week_mat RENAME TO post_per_week;

/*=======================================================================*/
/*=================== COMMON TABLE EXPRESSION (CTE) ====================*/
/*=======================================================================*/

WITH post_week_2024 AS (
    SELECT 
        date_trunc('week'::text, posts.created_at) AS weeks,
        sum(claps.counter) AS total_claps,
        count(DISTINCT posts.post_id) AS number_of_posts,
        count(*) AS number_of_claps
    FROM posts
    JOIN claps ON claps.post_id = posts.post_id
    GROUP BY 1 -- Agrupar por la primera columna (weeks)
    ORDER BY 1 DESC
)

-- AQUÍ FALTA EL LLAMADO FINAL:
SELECT * FROM post_week_2024
WHERE weeks BETWEEN '2024-01-01' AND '2024-12-31' AND total_claps >= 600;

-------------------------------------------------------------------------------

WITH claps_per_post AS (
	SELECT post_id, SUM(counter) FROM claps
	GROUP BY post_id
), post_from_2023 AS (
	SELECT * FROM posts WHERE created_at BETWEEN '2023-01-01' AND '2023-12-31'
)

SELECT * FROM claps_per_post
	WHERE claps_per_post.post_id IN (SELECT post_id FROM post_from_2023)


--------------------------------------------------------------------------------
-- nombre de la tabla en memoria
-- campos que vamos a tener
WITH RECURSIVE countdown( val ) AS (
	-- Initializacion => primer nivel o valores iniciales
	SELECT 5 as val
	
	UNION
	-- QUERY RECURSIVO
	SELECT val - 1 FROM countdown WHERE val > 1
)

-- Select de los campos
SELECT * FROM countdown

-- nombre de la tabla en memoria
-- campos que vamos a tener
WITH RECURSIVE contador( val ) AS (
	-- Initializacion => primer nivel o valores iniciales
	SELECT 1 as val
	
	UNION
	-- QUERY RECURSIVO
	SELECT val + 1 FROM contador WHERE val < 10
)

-- Select de los campos
SELECT * FROM contador

--------------------------------------------------------------------------------

WITH RECURSIVE multiplication_table(base, val, result) AS (
	-- Init
	SELECT 5 AS base, 1 AS val, 5 AS result

	UNION
	-- Recursiva
	SELECT 5 AS base, val + 1, (val + 1) * base FROM multiplication_table
	WHERE val < 10
)

SELECT * FROM multiplication_table;

-----------------------------------------------------------------------------------

WITH RECURSIVE bosses AS (
	-- Init
		SELECT id, name, report_to FROM employees WHERE id = 8
	UNION
		SELECT employees.id, employees.name, employees.report_to FROM employees
			INNER JOIN bosses ON bosses.id = employees.report_to
	-- Recursive
)

SELECT * FROM bosses;

WITH RECURSIVE bosses AS (
	-- Init
		SELECT id, name, report_to, 1 as depth FROM employees WHERE id = 1
	UNION
	-- Recursive
		SELECT employees.id, employees.name, employees.report_to, depth + 1 FROM employees
			INNER JOIN bosses ON bosses.id = employees.report_to
		WHERE depth < 2
)

SELECT * FROM bosses;


WITH RECURSIVE bosses AS (
	-- Init
		SELECT id, name, report_to, name AS report, 1 as depth FROM employees WHERE id = 1
			
	UNION
	-- Recursive
		SELECT employees.id, employees.name, employees.report_to, bosses.name, depth + 1 FROM employees
			INNER JOIN bosses ON bosses.id = employees.report_to
		-- WHERE depth < 2
)

SELECT * FROM bosses;

WITH RECURSIVE bosses AS (
	-- Init
		SELECT id, name, report_to, 1 as depth FROM employees WHERE id = 1
			
	UNION
	-- Recursive
		SELECT employees.id, employees.name, employees.report_to, depth + 1 FROM employees
			INNER JOIN bosses ON bosses.id = employees.report_to
		-- WHERE depth < 2
)
SELECT bosses.*, employees.name as reports_to_name FROM bosses
LEFT JOIN employees ON employees.id = bosses.report_to
ORDER BY depth;

--------------------------------------------------------------------------------

SELECT * FROM public.followers

SELECT f.leader_id, u.name AS leader,
	f.follower_id, uf.name AS follower
FROM public.followers f
INNER JOIN public."user" u ON u.id = f.leader_id
INNER JOIN public."user" uf ON uf.id = f.follower_id;


SELECT follower_id FROM followers WHERE leader_id = 1;

SELECT * FROM followers
WHERE leader_id IN (
	SELECT follower_id FROM followers WHERE leader_id = 1
)