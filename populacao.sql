
-- (DML - INSERT)
-- ATENÇÃO: A ordem foi ajustada para respeitar as chaves estrangeiras!

-- INSERINDO DADOS NA TABELA CLIENTE (tb_cliente) | COM O PROCEDURE

CALL sp_inserir_cliente (123456789, 'Flavinho do Grau', 44000111);

-- INSERINDO DADOS NA TABELA FUNCIONÁRIO (tb_funcionario) | COM O PROCEDURE

CALL sp_inserir_funcionario ('Fernando Silva', 'vendedor', 3200.00, 5);

-- INSERINDO DADOS NA TABELA PEDIDO (tb_pedido)
-- Inserindo PEDIDO usando subconsultas para achar o CPF do cliente e o Registro do funcionário pelo nome
INSERT INTO tb_pedido (status_ped, tipo, datahora, idcliente, num_registro_ped) 
VALUES ('Em Andamento', 'Manutenção Preventiva', NOW(), 
    (SELECT cpf FROM tb_cliente WHERE nome = 'Flavinho do Grau'), 
    (SELECT num_registro FROM tb_funcionario WHERE nome = 'Fernando Silva')
);

-- INSERINDO DADOS NA TABELA ESTOQUE (tb_estoque)
INSERT INTO tb_estoque (num_estoque, descricao, setor, qt_atual) VALUES (1, 'Ferragens', 1, 100);
INSERT INTO tb_estoque (num_estoque, descricao, setor, qt_atual) VALUES (2, 'Equipamentos de Proteção', 1, 100);
INSERT INTO tb_estoque (num_estoque, descricao, setor, qt_atual) VALUES (3, 'Ferramentas de Corte', 1, 100);

-- INSERINDO DADOS NA TABELA PRODUTO (tb_produto) - Precisa vir antes da movimentação!
-- Inserindo PRODUTO usando subconsulta para achar o número do estoque
INSERT INTO tb_produto (tipo, preco, num_estoque_prod) 
VALUES ('Parafuso Aço', 5.50, (SELECT num_estoque FROM tb_estoque WHERE descricao = 'Ferragens' LIMIT 1));

-- INSERINDO DADOS NA TABELA MOVIMENTAÇÃO (tb_movimentacao)
-- Corrigido: Dia 30 de setembro (setembro não tem 31) e referenciando o num_registro = 1 (Roberto Carlos)
-- Inserindo MOVIMENTAÇÃO usando subconsultas para achar o Funcionário e o Produto
INSERT INTO tb_movimentacao (status_mov, tipo_, data_hora, num_registro, id_produto)
VALUES ('Finalizado', 'Saída', NOW(), 
    (SELECT num_registro FROM tb_funcionario WHERE nome = 'Fernando Silva'),
    (SELECT id_produto FROM tb_produto WHERE tipo = 'Parafuso Aço' LIMIT 1)
);

-- 1. MAIS CLIENTES
INSERT INTO tb_cliente (cpf, nome, cep) VALUES 
(98765432100, 'Mariana Silva', 44001222),
(11122233344, 'João Pedro Santos', 44050333),
(55566677788, 'Beatriz Oliveira', 41000000),
(99988877766, 'Carlos Eduardo', 44025111);

-- 2. MAIS FUNCIONÁRIOS (Para testar SUM, AVG e funções de agregação)
INSERT INTO tb_funcionario (nome, funcao, salario, tmp_serviço) VALUES 
('Ana Costa', 'Gerente', 8500.00, 10),
('Marcos Souza', 'Tecnico', 3200.00, 3),
('Luciana Farias', 'Analista', 4200.00, 2),
('Ricardo Alves', 'Auxiliar', 2100.00, 1);

-- 3. MAIS ITENS NO ESTOQUE
INSERT INTO tb_estoque (num_estoque, descricao, setor, qt_atual) VALUES 
(4, 'Lubrificantes', 2, 50),
(5, 'EPIs Diversos', 3, 200),
(6, 'Rolamentos', 2, 30);

-- 4. MAIS PRODUTOS
INSERT INTO tb_produto (tipo, preco, num_estoque_prod) VALUES 
('Luva de Proteção Anticorte', 32.50, 2),
('Chave Inglesa', 85.50, 1),
('Capacete de Segurança', 45.00, 2),
('Óleo Hidráulico', 120.00, 4),
('Disco de Corte', 15.90, 3),
('Rolamento de Esferas', 210.00, 6);

-- 5. MAIS PEDIDOS (Relacionando Clientes e Funcionários)
INSERT INTO tb_pedido (status_ped, tipo, datahora, idcliente, num_registro_ped) VALUES 
('Concluído', 'Manutenção Preventiva', '2026-03-10 09:00:00', 98765432100, 2),
('Cancelado', 'Troca de Peças', '2026-03-15 11:20:00', 11122233344, 1),
('Em Andamento', 'Consultoria Técnica', '2026-03-27 16:00:00', 55566677788, 3),
('Aguardando', 'Reparo Emergencial', '2026-03-28 10:00:00', 123456789, 2);

-- 6. MAIS MOVIMENTAÇÕES
INSERT INTO tb_movimentacao (status_mov, tipo_, data_hora, num_registro, id_produto) VALUES 
('Finalizado', 'Saída de Material', '2026-03-20 08:30:00', 2, 2), -- Chave Inglesa
('Pendente', 'Entrada de Estoque', '2026-03-25 10:15:00', 4, 4), -- Óleo
('Finalizado', 'Uso Interno', '2026-03-28 09:00:00', 1, 3); -- Capacete
