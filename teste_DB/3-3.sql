-- Inserir contas pai (códigos mais curtos)
INSERT INTO contas_contabeis (cd_conta_contabil, descricao, cd_conta_pai)
SELECT DISTINCT 
    LEFT(cd_conta_contabil, LENGTH(cd_conta_contabil) - 1),
    descricao,
    NULL
FROM temp_saldos
WHERE 
    LENGTH(cd_conta_contabil) > 3
    AND LEFT(cd_conta_contabil, LENGTH(cd_conta_contabil) - 1) NOT IN (SELECT cd_conta_contabil FROM contas_contabeis)
ON CONFLICT (cd_conta_contabil) DO NOTHING;

-- Inserir todas as contas (incluindo filhos)
INSERT INTO contas_contabeis (cd_conta_contabil, descricao, cd_conta_pai)
SELECT DISTINCT 
    cd_conta_contabil,
    descricao,
    CASE 
        WHEN LENGTH(cd_conta_contabil) > 3 THEN LEFT(cd_conta_contabil, LENGTH(cd_conta_contabil) - 1)
        ELSE NULL 
    END AS cd_conta_pai
FROM temp_saldos
ORDER BY LENGTH(cd_conta_contabil) ASC -- Garante ordem hierárquica
ON CONFLICT (cd_conta_contabil) DO NOTHING;