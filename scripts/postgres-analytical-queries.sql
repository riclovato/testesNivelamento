-- 1. Top 10 operadoras no último trimestre 
SELECT 
    o.Registro_ANS,
    o.Razao_Social,
    o.Nome_Fantasia,
    ABS(d.VL_SALDO_FINAL) AS Despesa_Total
FROM 
    demonstracoes_contabeis d
JOIN 
    operadoras_ativas o ON d.REG_ANS = o.Registro_ANS
WHERE 
    d.DESCRICAO ILIKE '%SINISTROS%' 
    AND d.TRIMESTRE = 4
    AND d.ANO = 2024
ORDER BY 
    Despesa_Total DESC
LIMIT 10;
-- 1. Top 10 operadoras no último Ano
SELECT 

SELECT 
    o.Registro_ANS,
    o.Razao_Social,
    SUM(ABS(d.VL_SALDO_FINAL)) AS Despesa_Total_Anual
FROM 
    demonstracoes_contabeis d
JOIN 
    operadoras_ativas o ON d.REG_ANS = o.Registro_ANS
WHERE 
    d.DESCRICAO ILIKE '%SINISTROS%' 
    AND d.ANO = 2024
GROUP BY 
    o.Registro_ANS, o.Razao_Social
ORDER BY 
    Despesa_Total_Anual DESC
LIMIT 10;
