-- Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
WITH mzdy AS (
    SELECT 
        payroll_year AS rok,
        industry_branch_code AS kod_odvetvi,
        value AS vyse_mzdy
    FROM czechia_payroll
    WHERE value_type_code = 5958  
),
ceny AS (
    SELECT 
        EXTRACT(YEAR FROM date_from) AS rok, 
        category_code AS kod_kategorie,
        value AS cena
    FROM czechia_price
),
prumerne_ceny AS (
    SELECT 
        rok,
        kod_kategorie,
        AVG(cena) AS prumerna_cena
    FROM ceny
    GROUP BY rok, kod_kategorie
),
prumerne_mzdy AS (
    SELECT 
        rok,
        ROUND(AVG(vyse_mzdy)::numeric, 2) AS prumerna_mzda
    FROM mzdy
    GROUP BY rok
)
SELECT 
    m.rok,
    m.prumerna_mzda,
    COALESCE(chleb.prumerna_cena, 0) AS cena_chleba,
    COALESCE(mleko.prumerna_cena, 0) AS cena_mleka,
    COALESCE(ROUND((m.prumerna_mzda / NULLIF(mleko.prumerna_cena, 0))::numeric, 2), 0) AS litru_mleka,
    COALESCE(ROUND((m.prumerna_mzda / NULLIF(chleb.prumerna_cena, 0))::numeric, 2), 0) AS kg_chleba
FROM prumerne_mzdy m
LEFT JOIN prumerne_ceny mleko ON m.rok = mleko.rok AND mleko.kod_kategorie = '114201'
LEFT JOIN prumerne_ceny chleb ON m.rok = chleb.rok AND chleb.kod_kategorie = '111301'
ORDER BY rok;
