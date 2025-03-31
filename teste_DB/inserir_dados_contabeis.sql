-- Importar 2023
COPY saldos_contabeis(trimestre, reg_ans, cd_conta_contabil, vl_saldo_inicial, vl_saldo_final)
FROM 'C:\dados\1T2023.csv' WITH (FORMAT CSV, HEADER true, DELIMITER ';', ENCODING 'UTF8');
COPY saldos_contabeis(trimestre, reg_ans, cd_conta_contabil, vl_saldo_inicial, vl_saldo_final)
FROM 'C:\dados\2T2023.csv' WITH (FORMAT CSV, HEADER true, DELIMITER ';', ENCODING 'UTF8');
COPY saldos_contabeis(trimestre, reg_ans, cd_conta_contabil, vl_saldo_inicial, vl_saldo_final)
FROM 'C:\dados\3T2023.csv' WITH (FORMAT CSV, HEADER true, DELIMITER ';', ENCODING 'UTF8');
COPY saldos_contabeis(trimestre, reg_ans, cd_conta_contabil, vl_saldo_inicial, vl_saldo_final)
FROM 'C:\dados\4T2023.csv' WITH (FORMAT CSV, HEADER true, DELIMITER ';', ENCODING 'UTF8');

-- Importar 2024 
COPY saldos_contabeis(trimestre, reg_ans, cd_conta_contabil, vl_saldo_inicial, vl_saldo_final)
FROM 'C:\dados\1T2024.csv' WITH (FORMAT CSV, HEADER true, DELIMITER ';', ENCODING 'UTF8');
COPY saldos_contabeis(trimestre, reg_ans, cd_conta_contabil, vl_saldo_inicial, vl_saldo_final)
FROM 'C:\dados\2T2024.csv' WITH (FORMAT CSV, HEADER true, DELIMITER ';', ENCODING 'UTF8');
COPY saldos_contabeis(trimestre, reg_ans, cd_conta_contabil, vl_saldo_inicial, vl_saldo_final)
FROM 'C:\dados\3T2024.csv' WITH (FORMAT CSV, HEADER true, DELIMITER ';', ENCODING 'UTF8');
COPY saldos_contabeis(trimestre, reg_ans, cd_conta_contabil, vl_saldo_inicial, vl_saldo_final)
FROM 'C:\dados\4T2024.csv' WITH (FORMAT CSV, HEADER true, DELIMITER ';', ENCODING 'UTF8');