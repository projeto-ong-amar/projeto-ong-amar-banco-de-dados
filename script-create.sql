CREATE DATABASE IF NOT EXISTS projeto_amar;
USE projeto_amar;

CREATE TABLE IF NOT EXISTS categoria (
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nome VARCHAR(45) NOT NULL,
    descricao VARCHAR(45) NOT NULL
);

CREATE TABLE IF NOT EXISTS produto (
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nome VARCHAR(45) NOT NULL,
    unidade_medida VARCHAR(45),
    fk_categoria INT NOT NULL,
    CONSTRAINT fk_item_categoria FOREIGN KEY (fk_categoria) REFERENCES categoria(id)
);

CREATE TABLE IF NOT EXISTS produto_lote (
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    quantidade INT NOT NULL,
    validade DATE,
    data_entrada DATE NOT NULL,
    fk_produto INT NOT NULL,
    CONSTRAINT fk_lote_produto FOREIGN KEY (fk_produto) REFERENCES produto(id)
);

CREATE TABLE IF NOT EXISTS usuario (
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(45) NOT NULL,
    senha VARCHAR(255) NOT NULL,
    tipo_usuario ENUM("ADMINISTRADOR", "VOLUNTARIO") NOT NULL,
    status VARCHAR(45) NOT NULL
);

CREATE TABLE IF NOT EXISTS movimentacao (
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    tipo ENUM('ENTRADA', 'SAIDA', 'PERDA') NOT NULL,
    quantidade INT NOT NULL,
    data DATE NOT NULL,
    motivo VARCHAR(255) NOT NULL,
    fk_produto INT NOT NULL,
    fk_usuario INT NOT NULL,
    CONSTRAINT fk_movimentacao_produto FOREIGN KEY (fk_produto) REFERENCES produto(id),
    CONSTRAINT fk_movimentacao_usuario FOREIGN KEY (fk_usuario) REFERENCES usuario(id)
);

CREATE TABLE IF NOT EXISTS movimentacao_estoque (
	id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	quantidade INT NOT NULL,
	fk_movimentacao INT NOT NULL,
	fk_produto_lote INT NOT NULL,
	CONSTRAINT fk_movimentacao_estoque_movimentacao FOREIGN KEY (fk_movimentacao) REFERENCES movimentacao(id),
	CONSTRAINT fk_movimentacao_estoque_produto_lote FOREIGN KEY (fk_produto_lote) REFERENCES produto_lote(id)
);
