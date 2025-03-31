CREATE TABLE contas_contabeis (
    cd_conta_contabil VARCHAR(20) PRIMARY KEY,
    descricao VARCHAR(255) NOT NULL,
    cd_conta_pai VARCHAR(20),
    FOREIGN KEY (cd_conta_pai) REFERENCES contas_contabeis(cd_conta_contabil)
);