-- Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
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
),
zmeny_mezd AS (
    SELECT 
        rok,
        prumerna_mzda,
        LAG(prumerna_mzda) OVER (ORDER BY rok) AS predchozi_mzda,
        ((prumerna_mzda - LAG(prumerna_mzda) OVER (ORDER BY rok)) / LAG(prumerna_mzda) OVER (ORDER BY rok) * 100) AS rust_mezd_procenta
    FROM mzdy
),
zmeny_cen AS (
    SELECT 
        rok,
        prumerna_cena,
        LAG(prumerna_cena) OVER (ORDER BY rok) AS predchozi_cena,
        ((prumerna_cena - LAG(prumerna_cena) OVER (ORDER BY rok)) / LAG(prumerna_cena) OVER (ORDER BY rok) * 100) AS rust_cen_procenta
    FROM ceny
),
zmeny_hdp AS (
    SELECT 
        rok,
        hdp,
        LAG(hdp) OVER (ORDER BY rok) AS predchozi_hdp,
        ((hdp - LAG(hdp) OVER (ORDER BY rok)) / LAG(hdp) OVER (ORDER BY rok) * 100) AS rust_hdp_procenta
    FROM gdp
)
SELECT 
    z_hdp.rok,
    z_hdp.rust_hdp_procenta,
    z_mezd.rust_mezd_procenta,
    z_cen.rust_cen_procenta
FROM zmeny_hdp z_hdp
JOIN zmeny_mezd z_mezd ON z_hdp.rok = z_mezd.rok
JOIN zmeny_cen z_cen ON z_hdp.rok = z_cen.rok;
