-- Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
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
zmeny_cen AS (
    SELECT 
        rok,
        kod_kategorie,
        prumerna_cena,
        LAG(prumerna_cena) OVER (PARTITION BY kod_kategorie ORDER BY rok) AS predchozi_cena,
        ROUND(
            (prumerna_cena - LAG(prumerna_cena) OVER (PARTITION BY kod_kategorie ORDER BY rok))::numeric / 
            LAG(prumerna_cena) OVER (PARTITION BY kod_kategorie ORDER BY rok)::numeric * 100, 2
        ) AS rust_cen_procenta
    FROM prumerne_ceny
)
SELECT 
    c.kod_kategorie AS kategorie,
    cpc.name AS nazev_kategorie,  
    ROUND(AVG(c.rust_cen_procenta)::numeric, 2) AS prumerny_rust_cen
FROM zmeny_cen c
LEFT JOIN czechia_price_category cpc ON c.kod_kategorie = cpc.code
WHERE c.rust_cen_procenta IS NOT NULL
GROUP BY c.kod_kategorie, cpc.name
ORDER BY prumerny_rust_cen;
