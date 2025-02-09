-- Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

WITH mzdy AS ( 
    SELECT 
        payroll_year AS rok,
        industry_branch_code AS kod_odvetvi,
        value::numeric AS vyse_mzdy
    FROM czechia_payroll
    WHERE value_type_code = 5958  
    AND value IS NOT NULL  
    AND industry_branch_code IS NOT NULL  
),
zmeny_mezd AS (
    SELECT 
        mzdy.rok,
        mzdy.kod_odvetvi,
        mzdy.vyse_mzdy AS aktualni_mzda,
        LAG(mzdy.vyse_mzdy::numeric) OVER (PARTITION BY mzdy.kod_odvetvi ORDER BY mzdy.rok) AS predchozi_mzda,
        (mzdy.vyse_mzdy::numeric - LAG(mzdy.vyse_mzdy::numeric) OVER (PARTITION BY mzdy.kod_odvetvi ORDER BY mzdy.rok)) AS rozdil,
        ROUND(((mzdy.vyse_mzdy::numeric - LAG(mzdy.vyse_mzdy::numeric) OVER (PARTITION BY mzdy.kod_odvetvi ORDER BY mzdy.rok)) / LAG(mzdy.vyse_mzdy::numeric) OVER (PARTITION BY mzdy.kod_odvetvi ORDER BY mzdy.rok)) * 100, 2) AS vypocet_rustu,
        cpib.name AS nazev_odvetvi 
    FROM mzdy
    LEFT JOIN czechia_payroll_industry_branch cpib ON mzdy.kod_odvetvi = cpib.code
)
SELECT 
    rok,
    kod_odvetvi,
    nazev_odvetvi,
    aktualni_mzda,
    predchozi_mzda,
    rozdil,
    vypocet_rustu
FROM zmeny_mezd
WHERE predchozi_mzda IS NOT NULL
ORDER BY rok, kod_odvetvi;
