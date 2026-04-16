-- IMPLEMENTAÇÃO DE TRIGGERS PARA ATUALIZAÇÃO AUTOMÁTICA DE VENDAS

DELIMITER //

CREATE TRIGGER tgr_updvendas
AFTER INSERT ON tb_movimentacao -- O trigger acontecerá após inserir dados na tabela tb_movimentacao
FOR EACH ROW
BEGIN
	UPDATE tb_estoque
	SET qt_atual = qt_atual - NEW.quantidade -- NEW refere-se aos dados que acabaram de ser inseridos
    WHERE num_estoque = 
	(SELECT num_estoque_prod FROM tb_produto WHERE id_produto = NEW.id_produto);
END//

DELIMITER ;