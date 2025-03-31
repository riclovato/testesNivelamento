COPY operadoras (
    registro_ans, cnpj, razao_social, nome_fantasia, modalidade,
    logradouro, numero, complemento, bairro, cidade, uf, cep,
    ddd, telefone, fax, endereco_eletronico, representante,
    cargo_representante, regiao_comercializacao, data_registro_ans
)
FROM 'C:\dados\Relatorio_cadop.csv'
WITH (
    FORMAT CSV,
    HEADER true,
    DELIMITER ';',
    ENCODING 'UTF8'
);