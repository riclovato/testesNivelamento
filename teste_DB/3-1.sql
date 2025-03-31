CREATE TEMP TABLE temp_saldos (
    trimestre VARCHAR(7), -- Formato: '1T2023'
    reg_ans VARCHAR(20),
    cd_conta_contabil VARCHAR(20),
    descricao VARCHAR(255),
    vl_saldo_inicial TEXT, -- Usar TEXT para evitar erros de conversão
    vl_saldo_final TEXT
);