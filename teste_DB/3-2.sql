-- Configurar ambiente para aceitar vírgula como separador decimal
SET lc_numeric TO 'pt_BR.UTF-8';

-- Importar todos os arquivos trimestrais
COPY temp_saldos FROM 'C:\dados\1T2023.csv' WITH (FORMAT CSV, HEADER true, DELIMITER ';', ENCODING 'UTF8');
COPY temp_saldos FROM 'C:\dados\2T2023.csv' WITH (FORMAT CSV, HEADER true, DELIMITER ';', ENCODING 'UTF8');
COPY temp_saldos FROM 'C:\dados\3T2023.csv' WITH (FORMAT CSV, HEADER true, DELIMITER ';', ENCODING 'UTF8');
COPY temp_saldos FROM 'C:\dados\4T2023.csv' WITH (FORMAT CSV, HEADER true, DELIMITER ';', ENCODING 'UTF8');
COPY temp_saldos FROM 'C:\dados\1T2024.csv' WITH (FORMAT CSV, HEADER true, DELIMITER ';', ENCODING 'UTF8');
COPY temp_saldos FROM 'C:\dados\2T2024.csv' WITH (FORMAT CSV, HEADER true, DELIMITER ';', ENCODING 'UTF8');
COPY temp_saldos FROM 'C:\dados\3T2024.csv' WITH (FORMAT CSV, HEADER true, DELIMITER ';', ENCODING 'UTF8');
COPY temp_saldos FROM 'C:\dados\4T2024.csv' WITH (FORMAT CSV, HEADER true, DELIMITER ';', ENCODING 'UTF8');