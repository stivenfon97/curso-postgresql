ALTER TABLE country
	ADD CHECK(
		(continent = 'Asia'::text) OR
		(continent = 'South America'::text) OR
		(continent = 'North America'::text) OR
		(continent = 'Oceania'::text) OR
		(continent = 'Antarctica'::text) OR
		(continent = 'Africa'::text) OR
		(continent = 'Europe'::text) OR
		(continent = 'Central America'::text)
	);

SELECT DISTINCT continent FROM country;

CREATE UNIQUE INDEX "unique_name_countrycode_district" ON city (
	name, countrycode, district
);

CREATE UNIQUE INDEX "index_name_countrycode_district" ON city (
	district
);

/* RELACIONAMIENTO DE TABLAS */

SELECT * FROM country WHERE code = 'NAM';
SELECT * FROM city WHERE countrycode = 'NAM';
SELECT * FROM countrylanguage WHERE countrycode = 'NAM';
INSERT INTO country
		values('NAM', 'Namibia', 'Africa', 'Southern Africa', 824292, 1990, 1726000, 42.5, 3101.00, 3384.00, 'Namibia', 'Republic', 'Sam Nujoma', 2726, 'NA')

-- ID, NAME, COUNTRYCODE, DISTRICT, POPULATION
-- 2726, Windhoek, NAM, Khomas, 169000

DELETE FROM city WHERE countrycode = 'NAM';

INSERT INTO country
		values('AFG', 'Afghanistan', 'Asia', 'Southern Asia', 652860, 1919, 40000000, 62, 69000000, NULL, 'Afghanistan', 'Totalitarian', NULL, NULL, 'AF');

ALTER TABLE city
	ADD CONSTRAINT fk_country_code
	FOREIGN KEY ( countrycode )
	REFERENCES country ( code ); -- ON DELETE CASCADE


ALTER TABLE countrylanguage
	ADD CONSTRAINT fk_country_code_language
	FOREIGN KEY ( countrycode )
	REFERENCES country ( code ); -- ON DELETE CASCADE

/* ON DELETE CASCADE */