-- Importação das Operadoras Ativas (ignorando duplicatas)
CREATE TEMPORARY TABLE temp_operadoras (
    Registro_ANS VARCHAR(20),
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
    Data_Registro_ANS TEXT
);

-- Copia os dados do CSV para a tabela temporária
COPY temp_operadoras FROM 'C:/dados/Relatorio_cadop.csv'
WITH (FORMAT CSV, DELIMITER ';', HEADER, ENCODING 'UTF8');

-- Insere os dados na tabela principal, ignorando duplicatas
INSERT INTO operadoras_ativas (
    Registro_ANS,
    CNPJ,
    Razao_Social,
    Nome_Fantasia,
    Modalidade,
    Logradouro,
    Numero,
    Complemento,
    Bairro,
    Cidade,
    UF,
    CEP,
    DDD,
    Telefone,
    Fax,
    Endereco_eletronico,
    Representante,
    Cargo_Representante,
    Regiao_de_Comercializacao,
    Data_Registro_ANS
)
SELECT 
    Registro_ANS,
    CNPJ,
    Razao_Social,
    Nome_Fantasia,
    Modalidade,
    Logradouro,
    Numero,
    Complemento,
    Bairro,
    Cidade,
    UF,
    CEP,
    DDD,
    Telefone,
    Fax,
    Endereco_eletronico,
    Representante,
    Cargo_Representante,
    Regiao_de_Comercializacao,
    CASE 
        WHEN Data_Registro_ANS ~ '^\d{2}/\d{2}/\d{4}$' 
        THEN TO_DATE(Data_Registro_ANS, 'DD/MM/YYYY')
        ELSE NULL
    END
FROM temp_operadoras
ON CONFLICT (Registro_ANS) DO NOTHING;

DROP TABLE temp_operadoras;

-- Função para Importação das Demonstrações Contábeis 
CREATE OR REPLACE FUNCTION importar_demonstracoes(arquivo_path TEXT, trimestre INT, ano INT)
RETURNS VOID AS $$
BEGIN
    -- Cria tabela temporária
    EXECUTE format('
        CREATE TEMPORARY TABLE temp_demonstracoes (
            DATA TEXT,
            REG_ANS TEXT,
            CD_CONTA_CONTABIL TEXT,
            DESCRICAO TEXT,
            VL_SALDO_INICIAL TEXT,
            VL_SALDO_FINAL TEXT
        );
    ');

    -- Copia dados do CSV
    EXECUTE format('
        COPY temp_demonstracoes FROM %L 
        WITH (FORMAT CSV, DELIMITER '';'', HEADER, ENCODING ''UTF8'');
    ', arquivo_path);

    -- Insere dados na tabela principal
    EXECUTE format('
        INSERT INTO demonstracoes_contabeis 
            (DATA, REG_ANS, CD_CONTA_CONTABIL, DESCRICAO, 
             VL_SALDO_INICIAL, VL_SALDO_FINAL, TRIMESTRE, ANO)
        SELECT 
            CASE 
                WHEN DATA ~ ''^\d{2}/\d{2}/\d{4}$'' THEN TO_DATE(DATA, ''DD/MM/YYYY'')
                WHEN DATA ~ ''^\d{4}-\d{2}-\d{2}$'' THEN TO_DATE(DATA, ''YYYY-MM-DD'')
                ELSE NULL
            END,
            TRIM(REG_ANS),
            CD_CONTA_CONTABIL,
            DESCRICAO,
            REPLACE(VL_SALDO_INICIAL, '','', ''.'')::DECIMAL(15,2),
            REPLACE(VL_SALDO_FINAL, '','', ''.'')::DECIMAL(15,2),
            $1, $2
        FROM temp_demonstracoes
        WHERE 
            TRIM(REG_ANS) IN (SELECT Registro_ANS FROM operadoras_ativas)
            AND DATA IS NOT NULL;
    ') USING trimestre, ano;

    EXECUTE 'DROP TABLE temp_demonstracoes;';

EXCEPTION
    WHEN others THEN 
        RAISE NOTICE 'Erro ao processar %: %', arquivo_path, SQLERRM;
END;
$$ LANGUAGE plpgsql;

-- Importação dos arquivos trimestrais
SELECT importar_demonstracoes('C:/dados/1T2023.csv', 1, 2023);
SELECT importar_demonstracoes('C:/dados/2T2023.csv', 2, 2023);
SELECT importar_demonstracoes('C:/dados/3T2023.csv', 3, 2023);
SELECT importar_demonstracoes('C:/dados/4T2023.csv', 4, 2023);
SELECT importar_demonstracoes('C:/dados/1T2024.csv', 1, 2024);
SELECT importar_demonstracoes('C:/dados/2T2024.csv', 2, 2024);
SELECT importar_demonstracoes('C:/dados/3T2024.csv', 3, 2024);
SELECT importar_demonstracoes('C:/dados/4T2024.csv', 4, 2024);

DROP FUNCTION importar_demonstracoes(TEXT, INT, INT);