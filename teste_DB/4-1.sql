CREATE INDEX idx_trimestre ON saldos_contabeis(trimestre);
CREATE INDEX idx_conta ON saldos_contabeis(cd_conta_contabil);
CREATE INDEX idx_operadora ON operadoras(registro_ans);