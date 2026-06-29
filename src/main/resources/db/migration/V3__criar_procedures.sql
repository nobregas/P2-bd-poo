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

DELIMITER ;
