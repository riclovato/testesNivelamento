SELECT 
    s.reg_ans,
    o.razao_social,
    SUM(s.vl_saldo_final) AS total_despesas
FROM saldos_contabeis s
JOIN operadoras o ON s.reg_ans = o.registro_ans
WHERE 
    s.cd_conta_contabil = '463919'
    AND s.trimestre LIKE '%2023' -- Substitua pelo ano desejado
GROUP BY s.reg_ans, o.razao_social
ORDER BY total_despesas DESC
LIMIT 10;