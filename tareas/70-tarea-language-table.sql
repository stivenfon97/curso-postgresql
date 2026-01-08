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

SELECT * FROM country

CREATE TABLE continent (
    code SERIAL PRIMARY KEY,
    name VARCHAR(100)
);

INSERT INTO continent(name) (SELECT DISTINCT continent FROM country)

SELECT * FROM continent

ALTER TABLE country DROP CONSTRAINT country_continent_check1

SELECT 
	a.name, 
	a.continent,
	( SELECT b.code FROM continent b WHERE b.name = a.continent )
FROM  country a;

UPDATE country a 
SET continent = ( SELECT b.code FROM continent b WHERE b.name = a.continent );

ALTER TABLE country
	ALTER COLUMN continent TYPE int4
USING continent::integer;


ALTER TABLE country
ADD CONSTRAINT fk_country_continent
FOREIGN KEY (continent)
REFERENCES continent (code);



CREATE SEQUENCE language_code_seq START 1 INCREMENT 1;

CREATE TABLE public.language (
    code INT NOT NULL DEFAULT nextval('language_code_seq'),
    name TEXT NOT NULL,
    PRIMARY KEY (code)
);


ALTER TABLE countrylanguage
ADD COLUMN languagecode VARCHAR(3)

SELECT * FROM countrylanguage;

INSERT INTO language(name) (SELECT DISTINCT language FROM countrylanguage)

SELECT * FROM language;

ALTER TABLE countrylanguage
	ALTER COLUMN languagecode TYPE INT
USING languagecode::integer;

UPDATE countrylanguage a SET languagecode = (SELECT b.code FROM language b WHERE b.name = a.language )

ALTER TABLE countrylanguage
ADD CONSTRAINT fk_country_language
FOREIGN KEY (languagecode)
REFERENCES language (code)