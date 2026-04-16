-- CRIACÃO DAS STORED PROCEDURES (SÃO COMO FUNÇÕES):    (vão ser usadar para simplificar os inserts manuais)

DELIMITER $$

CREATE PROCEDURE sp_inserir_cliente
(
--
	IN p_cpf BIGINT,
    IN p_nome VARCHAR(45),
    IN p_cep INT    
)
BEGIN
	INSERT INTO tb_cliente (cpf, nome, cep)
    VALUES (p_cpf, p_nome, p_cep);
    
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_inserir_funcionario
(
	IN p_num_registro INT,
	IN p_nome VARCHAR(45),
    IN p_funcao VARCHAR(45),
    IN p_salario FLOAT,
    IN p_tmp_serviço INT(2)
)
BEGIN
    INSERT INTO tb_funcionario (num_registro, nome, funcao, salario, tmp_serviço)
    VALUES (p_num_registro, p_nome, p_funcao, p_salario, p_tmp_serviço);
	END $$

DELIMITER ;

-- PROCEDURE DE DESCONTO

DELIMITER $$

CREATE PROCEDURE sp_aplicar_bonus_antiguidade(
    IN p_num_registro INT,
    OUT p_novo_salario FLOAT
)
BEGIN

    UPDATE tb_funcionario 
    SET salario = salario * 1.10 
    WHERE num_registro = p_num_registro AND tmp_serviço >= 5;

    SELECT salario INTO p_novo_salario 
    FROM tb_funcionario 
    WHERE num_registro = p_num_registro;
END $$

DELIMITER ;

-- VENDO O DESCONTO DO FUNCIONÁRIO:

CALL sp_aplicar_bonus_antiguidade(15465123, @resultado);
SELECT @resultado AS salario_atualizado;
