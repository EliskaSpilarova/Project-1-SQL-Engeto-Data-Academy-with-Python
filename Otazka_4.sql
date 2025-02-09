-- Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
WITH mzdy AS (
    SELECT 
        payroll_year AS rok,
        value AS vyse_mzdy
    FROM czechia_payroll
    WHERE value_type_code = 5958
),
ceny AS (
    SELECT 
        EXTRACT(YEAR FROM date_from) AS rok,
        value AS cena
    FROM czechia_price
),
zmeny_mezd AS (
    SELECT 
        rok,
        AVG(vyse_mzdy) AS prumerna_mzda,
        LAG(AVG(vyse_mzdy)) OVER (ORDER BY rok) AS predchozi_mzda,
        ((AVG(vyse_mzdy) - LAG(AVG(vyse_mzdy)) OVER (ORDER BY rok)) / LAG(AVG(vyse_mzdy)) OVER (ORDER BY rok) * 100) AS rust_mezd_procenta
    FROM mzdy
    GROUP BY rok
),
zmeny_cen AS (
    SELECT 
        rok,
        AVG(cena) AS prumerna_cena,
        LAG(AVG(cena)) OVER (ORDER BY rok) AS predchozi_cena,
        ((AVG(cena) - LAG(AVG(cena)) OVER (ORDER BY rok)) / LAG(AVG(cena)) OVER (ORDER BY rok) * 100) AS rust_cen_procenta
    FROM ceny
    GROUP BY rok
)
SELECT 
    zm.rok,
    zm.rust_mezd_procenta,
    zc.rust_cen_procenta
FROM zmeny_mezd zm
JOIN zmeny_cen zc ON zm.rok = zc.rok
WHERE zc.rust_cen_procenta - zm.rust_mezd_procenta > 10;
