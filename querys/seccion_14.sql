CREATE OR REPLACE FUNCTION greet_employee(employee_name VARCHAR)
RETURNS VARCHAR
AS $$

BEGIN
	RETURN 'Hola ' || employee_name;
END;

$$
LANGUAGE plpgsql;


SELECT greet_employee('stiven')

SELECT first_name, greet_employee(first_name) FROM employees;

--------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION max_raise_4( empl_id INT )
RETURNS NUMERIC(8,2) AS $$

DECLARE 
	employee_job_id INT;
	current_salary NUMERIC(8,2);
	job_max_salary NUMERIC(8,2);
	possible_raise NUMERIC(8,2);

BEGIN

	-- Tomar el puesto de trabajo y el salario
	SELECT
		job_id, salary
		INTO
		employee_job_id, current_salary
	FROM employees WHERE employee_id = empl_id;

	-- Tomar el max salary, acorde a su job
	SELECT
		max_salary INTO job_max_salary
	FROM jobs WHERE job_id = employee_job_id;

	-- Calculos
	possible_raise = job_max_salary - current_salary;
	
	-- RAISE NOTICE 'Max: %, Actual: %, Resta: %', job_max_salary, current_salary, possible_raise;
	
	IF ( possible_raise < 0 ) THEN
		RAISE EXCEPTION 'Persona con salario mayor max_salary: %', empl_id;
		-- possible_raise = 0;
	END IF;

	RETURN possible_raise;
END;
$$
LANGUAGE plpgsql;

SELECT
	employee_id,
	first_name,
	salary,
	max_salary,
	max_salary - salary AS possible_raise,
	max_raise( employee_id ),
	max_raise_2( employee_id )
FROM employees
INNER JOIN jobs on jobs.job_id = employees.job_id
WHERE employees.employee_id = 206;

SELECT employee_id, first_name, salary, max_raise_4( employee_id ) FROM employees WHERE employees.employee_id = 206;

---------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION max_raise_5( empl_id INT )
RETURNS NUMERIC(8,2) AS $$

DECLARE 
	selected_employee employees%rowtype;
	selected_job jobs%rowtype;
	
	possible_raise NUMERIC(8,2);

BEGIN

	-- Tomar el puesto de trabajo y el salario
	SELECT * FROM employees INTO selected_employee
	WHERE employee_id = empl_id;

	-- Tomar el max salary, acorde a su job
	SELECT * FROM jobs INTO selected_job
	WHERE job_id = selected_employee.job_id;

	-- Calculos
	possible_raise = selected_job.max_salary - selected_employee.salary;
	
	-- RAISE NOTICE 'Max: %, Actual: %, Resta: %', job_max_salary, current_salary, possible_raise;
	
	IF ( possible_raise < 0 ) THEN
		RAISE EXCEPTION 'Persona con salario mayor max_salary: %', selected_employee.first_name;
		-- possible_raise = 0;
	END IF;

	RETURN possible_raise;
END;
$$
LANGUAGE plpgsql;
