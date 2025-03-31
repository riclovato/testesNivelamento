-- Tabela de contas (mantida)
CREATE TABLE contas_contabeis (
    cd_conta_contabil VARCHAR(20) PRIMARY KEY,
    descricao VARCHAR(255) NOT NULL,
    cd_conta_pai VARCHAR(20),
    FOREIGN KEY (cd_conta_pai) REFERENCES contas_contabeis(cd_conta_contabil)
);

-- Tabela de saldos (ajustada para dados corrigidos)
CREATE TABLE saldos_contabeis (
    id SERIAL PRIMARY KEY,
    data DATE NOT NULL, -- Exige formato 'AAAA-MM-DD'
    reg_ans INT NOT NULL,
    cd_conta_contabil VARCHAR(20) NOT NULL,
    vl_saldo_inicial DECIMAL(15, 2) NOT NULL, -- Exige '.' como separador
    vl_saldo_final DECIMAL(15, 2) NOT NULL,
    FOREIGN KEY (cd_conta_contabil) REFERENCES contas_contabeis(cd_conta_contabil)
);