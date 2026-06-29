DELIMITER $$

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
