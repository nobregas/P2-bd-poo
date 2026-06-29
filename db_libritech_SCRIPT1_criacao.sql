DROP DATABASE IF EXISTS db_libritech;
CREATE DATABASE db_libritech CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE db_libritech;

CREATE TABLE usuarios (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE,
    email VARCHAR(150) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    tipo ENUM('ALUNO','GERENTE','BIBLIOTECARIO','ESTAGIARIO') NOT NULL,
    ativo TINYINT(1) NOT NULL DEFAULT 1
);

CREATE TABLE enderecos (
    id_endereco INT PRIMARY KEY AUTO_INCREMENT,
    logradouro VARCHAR(200) NOT NULL,
    bairro VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    uf CHAR(2) NOT NULL,
    id_usuario_fk INT NOT NULL,
    CONSTRAINT fk_endereco_usuario FOREIGN KEY (id_usuario_fk) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
);

CREATE TABLE livros (
    id_livro INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(200) NOT NULL,
    autor VARCHAR(150) NOT NULL,
    isbn VARCHAR(20) NOT NULL UNIQUE,
    preco_custo DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    quantidade_estoque INT NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'DISPONIVEL'
);

CREATE TABLE emprestimos (
    id_emprestimo INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario_fk INT NOT NULL,
    id_livro_fk INT NOT NULL,
    data_saida DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_prevista DATE NOT NULL,
    data_devolucao DATETIME NULL DEFAULT NULL,
    CONSTRAINT fk_emprestimo_usuario FOREIGN KEY (id_usuario_fk) REFERENCES usuarios(id_usuario),
    CONSTRAINT fk_emprestimo_livro FOREIGN KEY (id_livro_fk) REFERENCES livros(id_livro)
);

CREATE TABLE multas (
    id_multa INT PRIMARY KEY AUTO_INCREMENT,
    id_emprestimo_fk INT NOT NULL,
    valor DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    pago TINYINT(1) NOT NULL DEFAULT 0,
    CONSTRAINT fk_multa_emprestimo FOREIGN KEY (id_emprestimo_fk) REFERENCES emprestimos(id_emprestimo)
);

CREATE TABLE log_auditoria (
    id_log INT PRIMARY KEY AUTO_INCREMENT,
    tabela_afetada VARCHAR(100) NOT NULL,
    acao VARCHAR(100) NOT NULL,
    usuario_responsavel VARCHAR(150) NOT NULL,
    dados_antigos TEXT NULL,
    data_hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_livros_titulo ON livros(titulo);
CREATE INDEX idx_usuarios_cpf ON usuarios(cpf);
CREATE INDEX idx_emprestimos_usuario ON emprestimos(id_usuario_fk);
CREATE INDEX idx_emprestimos_data_prevista ON emprestimos(data_prevista);
CREATE INDEX idx_livros_status ON livros(status);

INSERT INTO usuarios (nome, cpf, email, senha, tipo) VALUES
('Carlos Eduardo Gerente', '11111111111', 'gerente@libritech.com', '$2a$12$hashedpassword_gerente', 'GERENTE'),
('Ana Paula Bibliotecaria', '22222222222', 'bibliotecaria@libritech.com', '$2a$12$hashedpassword_biblio', 'BIBLIOTECARIO'),
('Joao Estagiario Silva', '33333333333', 'estagiario@libritech.com', '$2a$12$hashedpassword_estag', 'ESTAGIARIO'),
('Maria Aluna Souza', '44444444444', 'aluno1@libritech.com', '$2a$12$hashedpassword_aluno1', 'ALUNO'),
('Pedro Aluno Oliveira', '55555555555', 'aluno2@libritech.com', '$2a$12$hashedpassword_aluno2', 'ALUNO'),
('Lucia Aluna Costa', '66666666666', 'aluno3@libritech.com', '$2a$12$hashedpassword_aluno3', 'ALUNO');

INSERT INTO enderecos (logradouro, bairro, cidade, uf, id_usuario_fk) VALUES
('Rua das Flores, 100', 'Centro', 'Campina Grande', 'PB', 1),
('Av. Brasil, 250', 'Jardim', 'Campina Grande', 'PB', 2),
('Rua do Comercio, 45', 'Bela Vista', 'Campina Grande', 'PB', 3),
('Rua Universitaria, 10', 'Universitario', 'Campina Grande', 'PB', 4),
('Rua Nova, 78', 'Centro', 'Campina Grande', 'PB', 5),
('Av. das Palmeiras, 321', 'Palmeiras', 'Campina Grande', 'PB', 6);

INSERT INTO livros (titulo, autor, isbn, preco_custo, quantidade_estoque, status) VALUES
('Banco de Dados Orientado a Objetos', 'Ramez Elmasri', '9788543004877', 89.90, 5, 'DISPONIVEL'),
('Sistemas de Banco de Dados', 'Abraham Silberschatz', '9788535245356', 120.00, 3, 'DISPONIVEL'),
('Java Como Programar', 'Paul Deitel', '9788576059929', 150.00, 4, 'DISPONIVEL'),
('Estruturas de Dados e Algoritmos', 'Michael T. Goodrich', '9788582600023', 95.00, 2, 'DISPONIVEL'),
('Clean Code', 'Robert C. Martin', '9788576082675', 75.00, 6, 'DISPONIVEL'),
('Design Patterns', 'Gang of Four', '9780201633610', 110.00, 3, 'DISPONIVEL'),
('Introducao a Algoritmos', 'Thomas Cormen', '9788535236996', 200.00, 2, 'DISPONIVEL'),
('Engenharia de Software', 'Ian Sommerville', '9788579361081', 130.00, 3, 'DISPONIVEL'),
('Redes de Computadores', 'Andrew Tanenbaum', '9788582605608', 140.00, 2, 'DISPONIVEL'),
('Arquitetura de Computadores', 'David Patterson', '9788535283945', 160.00, 2, 'DISPONIVEL');

INSERT INTO emprestimos (id_usuario_fk, id_livro_fk, data_saida, data_prevista, data_devolucao) VALUES
(4, 1, '2025-06-01 10:00:00', '2025-06-08', '2025-06-07 09:00:00'),
(4, 2, '2025-06-10 11:00:00', '2025-06-17', NULL),
(4, 3, '2025-06-12 14:00:00', '2025-06-19', NULL),
(5, 1, '2025-05-20 09:00:00', '2025-05-27', '2025-06-05 10:00:00'),
(5, 4, '2025-06-15 10:00:00', '2025-06-22', NULL),
(6, 5, '2025-06-01 08:00:00', '2025-06-08', '2025-06-20 11:00:00');

UPDATE livros SET quantidade_estoque = quantidade_estoque - 1 WHERE id_livro = 2;
UPDATE livros SET quantidade_estoque = quantidade_estoque - 1 WHERE id_livro = 3;
UPDATE livros SET quantidade_estoque = quantidade_estoque - 1 WHERE id_livro = 4;

INSERT INTO multas (id_emprestimo_fk, valor, pago) VALUES
(4, 18.00, 1),
(6, 24.00, 0);

CREATE OR REPLACE VIEW vw_acervo_publico AS
SELECT
    id_livro,
    titulo,
    autor,
    isbn,
    quantidade_estoque,
    status
FROM livros;

CREATE OR REPLACE VIEW vw_livros_atrasados AS
SELECT
    e.id_emprestimo,
    u.nome AS nome_usuario,
    u.email AS contato_usuario,
    l.titulo AS titulo_livro,
    e.data_saida,
    e.data_prevista,
    DATEDIFF(CURDATE(), e.data_prevista) AS dias_atraso
FROM emprestimos e
INNER JOIN usuarios u ON u.id_usuario = e.id_usuario_fk
INNER JOIN livros l ON l.id_livro = e.id_livro_fk
WHERE e.data_devolucao IS NULL
  AND e.data_prevista < CURDATE();

CREATE OR REPLACE VIEW vw_ranking_leitura AS
SELECT
    l.id_livro,
    l.titulo,
    l.autor,
    COUNT(e.id_emprestimo) AS total_emprestimos
FROM livros l
LEFT JOIN emprestimos e ON e.id_livro_fk = l.id_livro
GROUP BY l.id_livro, l.titulo, l.autor
ORDER BY total_emprestimos DESC
LIMIT 10;

CREATE OR REPLACE VIEW vw_dashboard_financeiro AS
SELECT
    COUNT(m.id_multa) AS total_multas,
    SUM(m.valor) AS soma_total,
    SUM(CASE WHEN m.pago = 1 THEN m.valor ELSE 0 END) AS soma_pago,
    SUM(CASE WHEN m.pago = 0 THEN m.valor ELSE 0 END) AS soma_pendente
FROM multas m;

CREATE OR REPLACE VIEW vw_login_usuario AS
SELECT id_usuario, nome, cpf, email, senha, tipo, ativo FROM usuarios;

DELIMITER $$

CREATE PROCEDURE sp_transacao_emprestimo(
    IN p_id_usuario INT,
    IN p_id_livro INT
)
BEGIN
    DECLARE v_pendencias INT DEFAULT 0;
    DECLARE v_estoque INT DEFAULT 0;
    DECLARE v_data_prevista DATE;
    DECLARE v_tipo_usuario VARCHAR(20);
    DECLARE v_prazo INT DEFAULT 7;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT tipo INTO v_tipo_usuario
    FROM usuarios WHERE id_usuario = p_id_usuario;

    IF v_tipo_usuario = 'ALUNO' THEN
        SET v_prazo = 7;
    ELSE
        SET v_prazo = 14;
    END IF;

    SELECT COUNT(*) INTO v_pendencias
    FROM emprestimos e
    INNER JOIN multas m ON m.id_emprestimo_fk = e.id_emprestimo
    WHERE e.id_usuario_fk = p_id_usuario AND m.pago = 0;

    IF v_pendencias > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Usuario possui multas pendentes. Regularize antes de novo emprestimo.';
    END IF;

    SELECT quantidade_estoque INTO v_estoque
    FROM livros WHERE id_livro = p_id_livro FOR UPDATE;

    IF v_estoque <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Livro sem estoque disponivel.';
    END IF;

    SET v_data_prevista = DATE_ADD(CURDATE(), INTERVAL v_prazo DAY);

    INSERT INTO emprestimos (id_usuario_fk, id_livro_fk, data_saida, data_prevista)
    VALUES (p_id_usuario, p_id_livro, NOW(), v_data_prevista);

    UPDATE livros
    SET quantidade_estoque = quantidade_estoque - 1
    WHERE id_livro = p_id_livro;

    UPDATE livros
    SET status = 'INDISPONIVEL'
    WHERE id_livro = p_id_livro AND quantidade_estoque = 0;

    COMMIT;
END$$

CREATE PROCEDURE sp_renovar_emprestimo(
    IN p_id_emprestimo INT
)
BEGIN
    DECLARE v_id_livro INT;
    DECLARE v_status_livro VARCHAR(20);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT id_livro_fk INTO v_id_livro
    FROM emprestimos WHERE id_emprestimo = p_id_emprestimo FOR UPDATE;

    SELECT status INTO v_status_livro
    FROM livros WHERE id_livro = v_id_livro;

    IF v_status_livro = 'RESERVADO' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Renovacao negada: livro esta reservado por outro usuario.';
    END IF;

    UPDATE emprestimos
    SET data_prevista = DATE_ADD(data_prevista, INTERVAL 7 DAY)
    WHERE id_emprestimo = p_id_emprestimo;

    COMMIT;
END$$

CREATE PROCEDURE sp_calcular_multa(
    IN p_id_emprestimo INT,
    OUT p_valor_multa DECIMAL(10,2)
)
BEGIN
    DECLARE v_data_prevista DATE;
    DECLARE v_data_devolucao DATETIME;
    DECLARE v_dias_atraso INT DEFAULT 0;
    DECLARE v_data_referencia DATE;

    SELECT data_prevista, data_devolucao
    INTO v_data_prevista, v_data_devolucao
    FROM emprestimos WHERE id_emprestimo = p_id_emprestimo;

    IF v_data_devolucao IS NOT NULL THEN
        SET v_data_referencia = DATE(v_data_devolucao);
    ELSE
        SET v_data_referencia = CURDATE();
    END IF;

    SET v_dias_atraso = DATEDIFF(v_data_referencia, v_data_prevista);

    IF v_dias_atraso > 0 THEN
        SET p_valor_multa = v_dias_atraso * 2.00;
    ELSE
        SET p_valor_multa = 0.00;
    END IF;
END$$

CREATE PROCEDURE sp_transacao_cadastro_completo(
    IN p_nome VARCHAR(150),
    IN p_cpf CHAR(11),
    IN p_email VARCHAR(150),
    IN p_senha VARCHAR(255),
    IN p_tipo ENUM('ALUNO','GERENTE','BIBLIOTECARIO','ESTAGIARIO'),
    IN p_logradouro VARCHAR(200),
    IN p_bairro VARCHAR(100),
    IN p_cidade VARCHAR(100),
    IN p_uf CHAR(2)
)
BEGIN
    DECLARE v_novo_id INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    INSERT INTO usuarios (nome, cpf, email, senha, tipo)
    VALUES (p_nome, p_cpf, p_email, p_senha, p_tipo);

    SET v_novo_id = LAST_INSERT_ID();

    INSERT INTO enderecos (logradouro, bairro, cidade, uf, id_usuario_fk)
    VALUES (p_logradouro, p_bairro, p_cidade, p_uf, v_novo_id);

    COMMIT;
END$$

CREATE PROCEDURE sp_transacao_devolucao(
    IN p_id_emprestimo INT
)
BEGIN
    DECLARE v_id_livro INT;
    DECLARE v_data_prevista DATE;
    DECLARE v_dias_atraso INT DEFAULT 0;
    DECLARE v_valor_multa DECIMAL(10,2) DEFAULT 0.00;
    DECLARE v_ja_devolvido INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT COUNT(*) INTO v_ja_devolvido
    FROM emprestimos
    WHERE id_emprestimo = p_id_emprestimo AND data_devolucao IS NOT NULL;

    IF v_ja_devolvido > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Este emprestimo ja foi devolvido.';
    END IF;

    SELECT id_livro_fk, data_prevista
    INTO v_id_livro, v_data_prevista
    FROM emprestimos WHERE id_emprestimo = p_id_emprestimo FOR UPDATE;

    UPDATE emprestimos
    SET data_devolucao = NOW()
    WHERE id_emprestimo = p_id_emprestimo;

    UPDATE livros
    SET quantidade_estoque = quantidade_estoque + 1
    WHERE id_livro = v_id_livro;

    UPDATE livros
    SET status = 'DISPONIVEL'
    WHERE id_livro = v_id_livro AND quantidade_estoque > 0;

    SET v_dias_atraso = DATEDIFF(CURDATE(), v_data_prevista);

    IF v_dias_atraso > 0 THEN
        SET v_valor_multa = v_dias_atraso * 2.00;
        INSERT INTO multas (id_emprestimo_fk, valor, pago)
        VALUES (p_id_emprestimo, v_valor_multa, 0);
    END IF;

    COMMIT;
END$$

CREATE TRIGGER trg_trava_horario_comercial
BEFORE INSERT ON emprestimos
FOR EACH ROW
BEGIN
    DECLARE v_hora INT;
    IF @hora_simulada IS NOT NULL THEN
        SET v_hora = @hora_simulada;
    ELSE
        SET v_hora = HOUR(NOW());
    END IF;
    IF v_hora < 8 OR v_hora >= 18 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Operacao bloqueada: fora do horario comercial (08h-18h).';
    END IF;
END$$

CREATE TRIGGER trg_trava_horario_comercial_upd
BEFORE UPDATE ON emprestimos
FOR EACH ROW
BEGIN
    DECLARE v_hora INT;
    IF @hora_simulada IS NOT NULL THEN
        SET v_hora = @hora_simulada;
    ELSE
        SET v_hora = HOUR(NOW());
    END IF;
    IF v_hora < 8 OR v_hora >= 18 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Operacao bloqueada: fora do horario comercial (08h-18h).';
    END IF;
END$$

CREATE TRIGGER trg_auditoria_delecao
AFTER DELETE ON livros
FOR EACH ROW
BEGIN
    INSERT INTO log_auditoria (tabela_afetada, acao, usuario_responsavel, dados_antigos)
    VALUES (
        'livros',
        'DELETE',
        USER(),
        CONCAT(
            '{"id_livro":', OLD.id_livro,
            ',"titulo":"', OLD.titulo,
            '","autor":"', OLD.autor,
            '","isbn":"', OLD.isbn,
            '","preco_custo":', OLD.preco_custo,
            ',"quantidade_estoque":', OLD.quantidade_estoque,
            ',"status":"', OLD.status, '"}'
        )
    );
END$$

CREATE TRIGGER trg_limite_emprestimos
BEFORE INSERT ON emprestimos
FOR EACH ROW
BEGIN
    DECLARE v_tipo VARCHAR(20);
    DECLARE v_total INT;

    SELECT tipo INTO v_tipo FROM usuarios WHERE id_usuario = NEW.id_usuario_fk;

    IF v_tipo = 'ALUNO' THEN
        SELECT COUNT(*) INTO v_total
        FROM emprestimos
        WHERE id_usuario_fk = NEW.id_usuario_fk
          AND data_devolucao IS NULL;

        IF v_total >= 3 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Limite de emprestimos atingido: aluno ja possui 3 livros emprestados.';
        END IF;
    END IF;
END$$

CREATE TRIGGER trg_preventiva_estoque
BEFORE UPDATE ON livros
FOR EACH ROW
BEGIN
    IF NEW.quantidade_estoque < 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Operacao bloqueada: estoque nao pode ficar negativo.';
    END IF;
END$$

DELIMITER ;

DROP USER IF EXISTS 'usr_gerente'@'localhost';
DROP USER IF EXISTS 'usr_bibliotecario'@'localhost';
DROP USER IF EXISTS 'usr_estagiario'@'localhost';
DROP USER IF EXISTS 'usr_aluno'@'localhost';

CREATE USER 'usr_gerente'@'localhost' IDENTIFIED BY 'Gerente@2024!';
CREATE USER 'usr_bibliotecario'@'localhost' IDENTIFIED BY 'Biblio@2024!';
CREATE USER 'usr_estagiario'@'localhost' IDENTIFIED BY 'Estag@2024!';
CREATE USER 'usr_aluno'@'localhost' IDENTIFIED BY 'Aluno@2024!';

GRANT ALL PRIVILEGES ON db_libritech.* TO 'usr_gerente'@'localhost';

GRANT SELECT, INSERT, UPDATE ON db_libritech.livros TO 'usr_bibliotecario'@'localhost';
GRANT SELECT, INSERT, UPDATE ON db_libritech.emprestimos TO 'usr_bibliotecario'@'localhost';
GRANT SELECT, INSERT, UPDATE ON db_libritech.usuarios TO 'usr_bibliotecario'@'localhost';
GRANT SELECT, INSERT, UPDATE ON db_libritech.enderecos TO 'usr_bibliotecario'@'localhost';
GRANT SELECT, INSERT, UPDATE ON db_libritech.multas TO 'usr_bibliotecario'@'localhost';
GRANT SELECT ON db_libritech.log_auditoria TO 'usr_bibliotecario'@'localhost';
GRANT EXECUTE ON db_libritech.* TO 'usr_bibliotecario'@'localhost';

GRANT SELECT ON db_libritech.vw_acervo_publico TO 'usr_estagiario'@'localhost';
GRANT INSERT ON db_libritech.emprestimos TO 'usr_estagiario'@'localhost';
GRANT SELECT ON db_libritech.emprestimos TO 'usr_estagiario'@'localhost';
GRANT SELECT ON db_libritech.usuarios TO 'usr_estagiario'@'localhost';
GRANT DELETE ON db_libritech.livros TO 'usr_estagiario'@'localhost';
REVOKE DELETE ON db_libritech.livros FROM 'usr_estagiario'@'localhost';

GRANT SELECT ON db_libritech.vw_acervo_publico TO 'usr_aluno'@'localhost';
GRANT SELECT ON db_libritech.vw_livros_atrasados TO 'usr_aluno'@'localhost';
GRANT SELECT ON db_libritech.vw_ranking_leitura TO 'usr_aluno'@'localhost';
GRANT SELECT ON db_libritech.vw_login_usuario TO 'usr_aluno'@'localhost';
GRANT SELECT ON db_libritech.emprestimos TO 'usr_aluno'@'localhost';

GRANT SELECT ON db_libritech.vw_login_usuario TO 'usr_estagiario'@'localhost';
GRANT SELECT ON db_libritech.vw_login_usuario TO 'usr_bibliotecario'@'localhost';
GRANT SELECT ON db_libritech.vw_ranking_leitura TO 'usr_bibliotecario'@'localhost';
GRANT SELECT ON db_libritech.vw_login_usuario TO 'usr_gerente'@'localhost';

FLUSH PRIVILEGES;
