CREATE DATABASE IF NOT EXISTS projeto_amar;
USE projeto_amar;

CREATE TABLE IF NOT EXISTS produto (
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nome VARCHAR(45) NOT NULL,
    categoria ENUM('ALIMENTOS', 'PRODUTOS DE HIGIENE'),
    unidade_medida VARCHAR(45),
    status VARCHAR(45) NOT NULL DEFAULT 'ATIVO'
);

CREATE TABLE IF NOT EXISTS produto_lote (
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    quantidade INT NOT NULL,
    validade DATE,
    data_entrada DATE NOT NULL,
    fk_produto INT NOT NULL,

    CONSTRAINT fk_lote_produto
        FOREIGN KEY (fk_produto)
        REFERENCES produto(id)
);

CREATE TABLE IF NOT EXISTS usuario (
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    tipo_usuario ENUM('ADMINISTRADOR', 'VOLUNTARIO') NOT NULL,
    status VARCHAR(45) NOT NULL,
    versao_token INT NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS token_recuperacao_senha (
    id BIGINT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    token_hash CHAR(64) NOT NULL UNIQUE,
    expira_em DATETIME NOT NULL,
    utilizado BOOLEAN NOT NULL DEFAULT FALSE,
    fk_usuario INT NOT NULL,

    CONSTRAINT fk_token_recuperacao_usuario
        FOREIGN KEY (fk_usuario)
        REFERENCES usuario(id)
);

CREATE TABLE IF NOT EXISTS movimentacao (
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    tipo ENUM('ENTRADA', 'SAIDA', 'PERDA') NOT NULL,
    quantidade INT NOT NULL,
    data DATE NOT NULL,
    motivo VARCHAR(255) NOT NULL,
    fk_produto INT NOT NULL,
    fk_usuario INT NOT NULL,

    CONSTRAINT fk_movimentacao_produto
        FOREIGN KEY (fk_produto)
        REFERENCES produto(id),

    CONSTRAINT fk_movimentacao_usuario
        FOREIGN KEY (fk_usuario)
        REFERENCES usuario(id)
);

CREATE TABLE IF NOT EXISTS movimentacao_estoque (
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    quantidade INT NOT NULL,
    fk_movimentacao INT NOT NULL,
    fk_produto_lote INT NOT NULL,

    CONSTRAINT fk_movimentacao_estoque_movimentacao
        FOREIGN KEY (fk_movimentacao)
        REFERENCES movimentacao(id),

    CONSTRAINT fk_movimentacao_estoque_produto_lote
        FOREIGN KEY (fk_produto_lote)
        REFERENCES produto_lote(id)
);

CREATE TABLE IF NOT EXISTS configuracao_metrica (
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    estoque_baixo INT NOT NULL,
    risco_vencimento_dias INT NOT NULL,
    vencimento_proximo_dias INT NOT NULL,
    sem_movimentacao_dias INT NOT NULL,
    periodo_indicadores_dias INT NOT NULL,
    data_atualizacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    fk_usuario_atualizacao INT NULL,

    CONSTRAINT fk_configuracao_metrica_usuario
        FOREIGN KEY (fk_usuario_atualizacao)
        REFERENCES usuario(id)
);

CREATE TABLE IF NOT EXISTS configuracao_alerta_dashboard (
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    vencimento_proximo BOOLEAN NOT NULL,
    estoque_baixo BOOLEAN NOT NULL,
    sem_doacoes BOOLEAN NOT NULL,
    sem_movimentacao BOOLEAN NOT NULL,
    data_atualizacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS preferencia_notificacao (
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    estoque_baixo BOOLEAN NOT NULL DEFAULT TRUE,
    risco_vencimento BOOLEAN NOT NULL DEFAULT TRUE,
    novas_entradas BOOLEAN NOT NULL DEFAULT TRUE,
    novas_saidas BOOLEAN NOT NULL DEFAULT TRUE,
    email_notificacao VARCHAR(255) NULL,
    data_atualizacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    fk_usuario INT NOT NULL,

    CONSTRAINT fk_preferencia_notificacao_usuario
        FOREIGN KEY (fk_usuario)
        REFERENCES usuario(id)
);