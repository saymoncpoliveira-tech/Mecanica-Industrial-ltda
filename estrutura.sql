-- CRIAÇÃO DO BANCO DE DADOS
CREATE DATABASE mec_industrial;
USE mec_industrial;

-- ||CRIAÇÃO DAS TABELAS||

-- TABELA CLIENTE
CREATE TABLE tb_cliente(
    cpf BIGINT NOT NULL PRIMARY KEY, -- Mudado para BIGINT para caber números grandes de CPF
    nome VARCHAR (45) NOT NULL,
    cep INT NOT NULL
);

-- TABELA FUNCIONÁRIO
CREATE TABLE tb_funcionario ( 
    num_registro INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nome VARCHAR(45) NOT NULL, 
    funcao VARCHAR (45) NOT NULL,
    salario FLOAT NOT NULL,
    tmp_serviço INT(2) 
);
  
-- TABELA PEDIDO
CREATE TABLE tb_pedido (
    idpedido INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    status_ped VARCHAR(30) NOT NULL,
    tipo VARCHAR(45) NOT NULL,
    datahora DATETIME,
    idcliente BIGINT NOT NULL, -- Atualizado para BIGINT acompanhando a tb_cliente
    num_registro_ped INT NOT NULL,

    FOREIGN KEY (idcliente) REFERENCES tb_cliente(cpf),
    FOREIGN KEY (num_registro_ped) REFERENCES tb_funcionario(num_registro)
);

-- TABELA ESTOQUE
CREATE TABLE tb_estoque (
    num_estoque INT PRIMARY KEY NOT NULL,
    descricao VARCHAR(45) NOT NULL,
    setor INT NOT NULL,
    qt_atual INT NOT NULL,
    estoque_minimo INT NOT NULL DEFAULT 10
);

-- TABELA PRODUTO
CREATE TABLE tb_produto (
    id_produto INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    tipo VARCHAR(45) NOT NULL,
    preco FLOAT NOT NULL,
    num_estoque_prod INT NOT NULL,
    fornecedor_principal VARCHAR(45) DEFAULT '[A definir]',
    FOREIGN KEY (num_estoque_prod) REFERENCES tb_estoque(num_estoque)
);


  
-- TABELA MOVIMENTAÇÃO
CREATE TABLE tb_movimentacao (
    cod INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    status_mov VARCHAR(45) NOT NULL,
    tipo_ VARCHAR (45) NOT NULL,
    data_hora DATETIME NOT NULL,

    num_registro INT NOT NULL,

    id_produto INT NOT NULL,
    quantidade INT NOT NULL DEFAULT 1,

    id_pedido INT,

    FOREIGN KEY (num_registro) REFERENCES tb_funcionario (num_registro),
    FOREIGN KEY (id_produto) REFERENCES tb_produto (id_produto),
    FOREIGN KEY (id_pedido) REFERENCES tb_pedido
    (idpedido)

);
