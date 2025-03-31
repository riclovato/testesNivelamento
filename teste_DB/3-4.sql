INSERT INTO saldos_contabeis (trimestre, reg_ans, cd_conta_contabil, vl_saldo_inicial, vl_saldo_final)
SELECT 
    trimestre,
    reg_ans,
    cd_conta_contabil,
    REPLACE(vl_saldo_inicial, ',', '.')::DECIMAL(15,2), -- Converter vírgula para ponto
    REPLACE(vl_saldo_final, ',', '.')::DECIMAL(15,2)
FROM temp_saldos;

-- Limpar tabela temporária
DROP TABLE temp_saldos;

-- Restaurar configurações
RESET lc_numeric;