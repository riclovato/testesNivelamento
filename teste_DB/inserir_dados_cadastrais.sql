COPY operadoras 
FROM 'C:\dados\Relatorio_cadop.csv' 
WITH (
    FORMAT CSV,
    HEADER true,
    DELIMITER ';',
    ENCODING 'UTF8'
);

