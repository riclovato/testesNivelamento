-- Tabela de Operadoras Ativas
CREATE TABLE operadoras_ativas (
    Registro_ANS VARCHAR(20) PRIMARY KEY,
    CNPJ VARCHAR(20),
    Razao_Social VARCHAR(255),
    Nome_Fantasia VARCHAR(255),
    Modalidade VARCHAR(100),
    Logradouro VARCHAR(255),
    Numero VARCHAR(20),
    Complemento VARCHAR(255),
    Bairro VARCHAR(100),
    Cidade VARCHAR(100),
    UF CHAR(2),
    CEP VARCHAR(10),
    DDD VARCHAR(5),
    Telefone VARCHAR(20),
    Fax VARCHAR(20),
    Endereco_eletronico VARCHAR(100),
    Representante VARCHAR(255),
    Cargo_Representante VARCHAR(100),
    Regiao_de_Comercializacao VARCHAR(100),
    Data_Registro_ANS DATE
);

-- Tabela de Demonstrações Contábeis
CREATE TABLE demonstracoes_contabeis (
    id SERIAL PRIMARY KEY,
    DATA DATE,
    REG_ANS VARCHAR(20),
    CD_CONTA_CONTABIL VARCHAR(20),
    DESCRICAO VARCHAR(255),
    VL_SALDO_INICIAL DECIMAL(15, 2),
    VL_SALDO_FINAL DECIMAL(15, 2),
    TRIMESTRE INT,
    ANO INT,
    FOREIGN KEY (REG_ANS) REFERENCES operadoras_ativas(Registro_ANS) ON DELETE SET NULL
);

-- Índices para otimização
CREATE INDEX idx_reg_ans ON demonstracoes_contabeis(REG_ANS);
CREATE INDEX idx_conta_contabil ON demonstracoes_contabeis(CD_CONTA_CONTABIL);
CREATE INDEX idx_data ON demonstracoes_contabeis(DATA);
CREATE INDEX idx_trimestre_ano ON demonstracoes_contabeis(TRIMESTRE, ANO);