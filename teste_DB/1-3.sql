CREATE TABLE saldos_contabeis (
    id SERIAL PRIMARY KEY,
    trimestre VARCHAR(7) NOT NULL, -- Formato: '1T2023', '2T2023'
    reg_ans VARCHAR(20) NOT NULL,
    cd_conta_contabil VARCHAR(20) NOT NULL,
    vl_saldo_inicial DECIMAL(15, 2) NOT NULL,
    vl_saldo_final DECIMAL(15, 2) NOT NULL,
    FOREIGN KEY (cd_conta_contabil) REFERENCES contas_contabeis(cd_conta_contabil)
);