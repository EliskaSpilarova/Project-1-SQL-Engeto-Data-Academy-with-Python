CREATE TABLE t_eliska_spilarova_project_SQL_secondary_final AS (
    SELECT
        country,
        year,
        gdp,
        gini,
        population
    FROM economies
    WHERE country IN (
        'Germany', 'France', 'Italy', 'Spain', 'Netherlands', 
        'Sweden', 'Poland', 'Belgium', 'Austria', 'Denmark', 
        'Finland', 'Greece', 'Portugal', 'Ireland', 'Czechia', 
        'Romania', 'Hungary', 'Slovakia', 'Luxembourg', 'Bulgaria', 
        'Slovenia', 'Lithuania', 'Latvia', 'Cyprus', 'Estonia', 'Malta'
    )
    AND year BETWEEN 2006 AND 2018
);
