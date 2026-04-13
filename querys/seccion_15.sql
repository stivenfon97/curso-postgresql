CREATE OR REPLACE FUNCTION country_region()
	RETURNS TABLE ( id CHARACTER(2), name VARCHAR(40), region VARCHAR(25) )
	
AS $$

BEGIN

	RETURN QUERY
		SELECT country_id, country_name, region_name FROM countries
		INNER JOIN regions ON countries.region_id = regions.region_id;
END;

$$ LANGUAGE plpgsql;

SELECT * FROM country_region();

---------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE insert_region_proc( INT, VARCHAR )
AS $$
BEGIN

	INSERT INTO regions( region_id, region_name)
	VALUES ($1, $2);

	ROLLBACK;
	COMMIT;
	
END;
$$ LANGUAGE plpgsql;


CALL insert_region_proc(5, 'Central America');

SELECT * FROM regions

---------------------------------------------------------------------------

SELECT
	current_date AS "date",
	salary,
	max_raise( employee_id ),
	max_raise( employee_id ) * 0.05 AS amount,
	5 AS percentage
FROM employees;


---------------------------------------------------------------------------

DROP TABLE IF EXISTS "public"."raise_history";
-- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS raise_history_id_seq;

-- Table Definition
CREATE TABLE "public"."raise_history" (
    "id" int4 NOT NULL DEFAULT nextval('raise_history_id_seq'::regclass),
    "date" date,
    "employee_id" int4,
    "base_salary" numeric(8,2),
    "amount" numeric(8,2),
    "percentage" numeric(4,2),
    PRIMARY KEY ("id")
);

SELECT * FROM raise_history 


---------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE controlled_raise( percentage NUMERIC )AS 
$$
DECLARE
	real_percentage NUMERIC(8,2);
	total_employees INT;
	
BEGIN
	real_percentage = percentage / 100; --5% = 0.05;
	-- RAISE NOTICE 'Porcentaje: %'
	-- Mantener el historico
	INSERT INTO raise_history(date, employee_id, base_salary, amount, percentage)
	SELECT
		current_date AS "date",
		salary,
		max_raise( employee_id ),
		max_raise( employee_id ) * 0.05 AS amount,
		percentage
	FROM employees;

	-- Impactar la tabla de empleados
	UPDATE employees
		SET salary = ( max_raise( employee_id ) * real_percentage ) + salary;
	
	COMMIT;

	SELECT COUNT(*) INTO total_employees FROM employees;

	RAISE NOTICE 'Afectados % empleados ', total_employees;
END;
$$ LANGUAGE plpgsql;

CALL controlled_raise(10)

SELECT * FROM employees;
SELECT * FROM raise_history;