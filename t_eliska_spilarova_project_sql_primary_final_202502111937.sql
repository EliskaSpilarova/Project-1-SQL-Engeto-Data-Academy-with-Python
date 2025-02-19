 CREATE TABLE t_eliska_spilarova_project_SQL_primary_final AS (
    WITH mzdy AS (
        SELECT
            payroll_year AS rok,
            AVG(value) AS prumerna_mzda
        FROM czechia_payroll
        WHERE value_type_code = 5958
        GROUP BY payroll_year
    ),
    ceny AS (
        SELECT
            EXTRACT(YEAR FROM date_from) AS rok,
            AVG(value) AS prumerna_cena
        FROM czechia_price
        GROUP BY EXTRACT(YEAR FROM date_from)
    ),
    gdp AS (
        SELECT
            year AS rok,
            gdp AS hdp
        FROM economies
        WHERE country = 'Czech Republic'
    )
    SELECT
        m.rok,
        m.prumerna_mzda,
        c.prumerna_cena,
        g.hdp
    FROM mzdy m
    JOIN ceny c ON m.rok = c.rok
    JOIN gdp g ON m.rok = g.rok
);
