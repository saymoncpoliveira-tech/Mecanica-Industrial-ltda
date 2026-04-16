

-- Atualizando um exemplo para teste
UPDATE tb_produto SET fornecedor_principal = 'Metalúrgica Parafuso Ltda' WHERE id_produto in (1, 2, 5, 6);
UPDATE tb_estoque SET estoque_minimo = 150 WHERE num_estoque = 1; -- Para o parafuso ficar "abaixo do mínimo"


