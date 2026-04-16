-- CRIAÇÃO DE VIEWS

-- Criação de view para a verificação de produtos sem pedidos

CREATE VIEW prods_sem_pedidos AS
SELECT p.tipo, COUNT(m.id_produto) AS total_vendas
FROM tb_produto p
LEFT JOIN tb_movimentacao m ON p.id_produto = m.id_produto
GROUP BY p.tipo
HAVING total_vendas = 0;

-- Criação de view para a Ticket médio por cliente

CREATE VIEW ticketmedio AS
SELECT 
    c.nome AS cliente, 
    AVG(p.preco) AS ticket_medio,
    COUNT(ped.idpedido) AS total_pedidos
FROM tb_cliente c
INNER JOIN tb_pedido ped ON c.cpf = ped.idcliente
INNER JOIN tb_movimentacao m ON ped.num_registro_ped = m.num_registro
INNER JOIN tb_produto p ON m.id_produto = p.id_produto
GROUP BY c.nome;

-- VISUALIZANDO VIEWS

SELECT * FROM prods_sem_pedidos;
SELECT * FROM ticketmedio;


-- SELECTS

-- 1. Produtos que aparecem juntos na mesma movimentação/atendimento
SELECT 
    p1.tipo AS produto_a, 
    p2.tipo AS produto_b, 
    COUNT(*) AS frequencia_conjunta
FROM tb_movimentacao m1
JOIN tb_movimentacao m2 ON m1.num_registro = m2.num_registro 
    AND m1.data_hora = m2.data_hora 
    AND m1.id_produto < m2.id_produto
JOIN tb_produto p1 ON m1.id_produto = p1.id_produto
JOIN tb_produto p2 ON m2.id_produto = p2.id_produto
GROUP BY p1.tipo, p2.tipo
ORDER BY frequencia_conjunta DESC;

-- Verificação de produtos sem pedidos (Dados Incompletos)
SELECT p.tipo, COUNT(m.id_produto) AS total_vendas
FROM tb_produto p
LEFT JOIN tb_movimentacao m ON p.id_produto = m.id_produto
GROUP BY p.tipo
HAVING total_vendas = 0;

-- 2. Ticket médio de gasto por cliente
SELECT 
    c.nome AS cliente, 
    AVG(p.preco) AS ticket_medio,
    COUNT(ped.idpedido) AS total_pedidos
FROM tb_cliente c
INNER JOIN tb_pedido ped ON c.cpf = ped.idcliente
INNER JOIN tb_movimentacao m ON ped.num_registro_ped = m.num_registro
INNER JOIN tb_produto p ON m.id_produto = p.id_produto
GROUP BY c.nome;

-- 3. Quais fornecedores estão com entregas pendentes associadas a ordens de serviço em aberto;
-- (Com o adendo de que, na ausencia de uma tabela de fornecedores, houve uma adaptação usando como base a tabela de pedidos, solicitando o status do mesmo.)

SELECT *
FROM tb_pedido 
WHERE status_ped IN (
    -- Subconsulta: Isola apenas os status que representam pedidos "em aberto"
    SELECT DISTINCT status_ped 
    FROM tb_pedido 
    WHERE status_ped NOT IN ('Concluído', 'Cancelado')
);

-- 4. Todos os produtos que nunca foram vendidos (ou que não tiveram saídas nos últimos 6 meses);

-- Subconsulta listando produtos que nunca tiveram uma movimentação (Subconsulta com NOT IN)
SELECT tipo 
FROM tb_produto 
WHERE id_produto NOT IN (
    -- Subconsulta: Filtra produtos que TIVERAM saídas recentes (últimos 6 meses)
    -- Se o produto não estiver nesta lista, ele ou nunca saiu ou está parado há muito tempo.
    SELECT id_produto 
    FROM tb_movimentacao 
    WHERE tipo_ = 'Saída' 
    AND data_hora >= DATE_SUB(NOW(), INTERVAL 6 MONTH)
);

-- 5. Clientes cujo total acumulado de compras seja maior do que a média de gastos de todos os clientes da base;

SELECT c.nome, SUM(p.preco) AS total_gasto
FROM tb_cliente c
JOIN tb_pedido ped ON c.cpf = ped.idcliente
JOIN tb_movimentacao m ON ped.num_registro_ped = m.num_registro
JOIN tb_produto p ON m.id_produto = p.id_produto
GROUP BY c.nome
HAVING SUM(p.preco) > (
    SELECT AVG(total_cliente) FROM (
        SELECT SUM(p2.preco) as total_cliente 
        FROM tb_movimentacao m2 
        JOIN tb_produto p2 ON m2.id_produto = p2.id_produto 
        GROUP BY m2.num_registro
    ) AS media_geral
);

-- 6. O nome da categoria do produto, a quantidade total de itens vendidos dessa categoria e o faturamento total (soma) gerado por ela;

SELECT p.tipo AS categoria, COUNT(m.cod) AS total_itens, SUM(p.preco) AS faturamento_total
FROM tb_produto p
JOIN tb_movimentacao m ON p.id_produto = m.id_produto
WHERE m.tipo_ = 'Saída de Material'
GROUP BY p.tipo;

-- 7.  Quais produtos estão com estoque abaixo do "Estoque Mínimo" definido, exibindo o nome do fornecedor principal de cada um desses produtos para agilizar a cotação.

SELECT 
    p.tipo AS Produto, 
    e.qt_atual AS Estoque_Atual, 
    e.estoque_minimo AS Minimo_Exigido,
    p.fornecedor_principal AS Fornecedor
FROM tb_produto p
INNER JOIN tb_estoque e ON p.num_estoque_prod = e.num_estoque
WHERE e.qt_atual < e.estoque_minimo;
