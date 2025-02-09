CREATE TABLE EuropeanCountriesData (
    country VARCHAR(100),
    year INT,
    gdp NUMERIC(15, 2),
    gini NUMERIC(5, 2),
    population BIGINT
);
INSERT INTO EuropeanCountriesData (country, year, gdp, gini, population)
SELECT 
    country,
    year,
    gdp,
    gini,
    population
FROM 
    economies AS e
WHERE 
    country IN ('Germany', 'France', 'Italy', 'Spain', 'Netherlands', 'Sweden', 'Poland', 'Belgium', 'Austria', 
	'Denmark', 'Finland', 'Greece', 'Portugal', 'Ireland', 'Czechia', 'Romania', 'Hungary', 'Slovakia', 'Luxembourg', 
	'Bulgaria', 'Slovenia', 'Lithuania', 'Latvia', 'Cyprus', 'Estonia', 'Malta') 
	AND 
	e.year BETWEEN 2006 AND 2018;
