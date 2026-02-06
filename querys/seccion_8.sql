-- Funcones basicas

SELECT
	now(),
	CURRENT_DATE,
	CURRENT_TIME,
	date_part('hours', now()) as Hours,
	date_part('minutes', now()) as Minutes,
	date_part('seconds', now()) as Seconds,
	date_part('days', now()) as Days,
	date_part('months', now()) as Mounths,
	date_part('years', now()) as Years;
	

-- Consultas sobre fechas

SELECT
	max(hire_date) as mas_nuevo,
	min(hire_date) as mas_antiguo
FROM employees;

SELECT * FROM employees
WHERE hire_date > date('1998-02-05')
ORDER BY hire_date DESC;

SELECT * FROM employees
WHERE hire_date BETWEEN '1990-01-01' AND '2000-01-01'
ORDER BY hire_date DESC;


-- INTERVALOS

SELECT
	max(hire_date),
	max(hire_date) + INTERVAL '1 days' AS days,
	max(hire_date) + INTERVAL '1 month' AS months,
	max(hire_date) + INTERVAL '1 year' AS years,
	max(hire_date) + INTERVAL '1.1 year' AS year_month,
	max(hire_date) + INTERVAL '1.1 year' + INTERVAL '1 days' AS year_month_day,
	date_part('year', now()),
	MAKE_INTERVAL( YEARS := date_part('year', now())::integer),
	max(hire_date) + MAKE_INTERVAL( YEARS:=23 )
FROM employees;


-- Diferencia entre fechas y actualizaciones

SELECT
	hire_date,
	MAKE_INTERVAL( YEARS := 2026 - EXTRACT( YEARS FROM hire_date )::integer) AS manual,
	MAKE_INTERVAL( YEARS := date_part('years', CURRENT_DATE)::integer - EXTRACT( YEARS FROM hire_date )::integer) AS computed
FROM employees
ORDER BY hire_date DESC;

UPDATE employees
SET hire_date = hire_date - MAKE_INTERVAL( YEARS := date_part('year', now())::integer)

UPDATE employees
SET hire_date = hire_date + INTERVAL '26 years'

-- Clausula CASE - THEN

SELECT
	first_name,
	last_name,
	hire_date,
	CASE
		WHEN hire_date > now() - INTERVAL '1 year' THEN '1 año o menos'
		WHEN hire_date > now() - INTERVAL '3 year' THEN '1 a 3 años'
		WHEN hire_date > now() - INTERVAL '6 year' THEN '1 a 6 años'
		ELSE '+6 años'
	END AS rango_antiguedad,
	MAKE_INTERVAL( YEARS := date_part('years', CURRENT_DATE)::integer - EXTRACT( YEARS FROM hire_date )::integer) AS cantidad
FROM employees
ORDER BY hire_date DESC;