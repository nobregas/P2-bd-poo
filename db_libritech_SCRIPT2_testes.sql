USE db_libritech;

SHOW TABLES;

SELECT * FROM vw_acervo_publico;

SELECT * FROM vw_livros_atrasados;

SELECT * FROM vw_ranking_leitura;

SELECT * FROM vw_dashboard_financeiro;

SELECT * FROM usuarios;

SELECT * FROM emprestimos;

SELECT * FROM multas;

SELECT * FROM log_auditoria;

CALL sp_transacao_emprestimo(6, 6);

SELECT * FROM emprestimos WHERE id_usuario_fk = 6;

SELECT id_livro, titulo, quantidade_estoque, status FROM livros WHERE id_livro = 6;

CALL sp_renovar_emprestimo(2);

SELECT id_emprestimo, data_prevista FROM emprestimos WHERE id_emprestimo = 2;

SET @valor_multa = 0;
CALL sp_calcular_multa(4, @valor_multa);
SELECT @valor_multa AS multa_emprestimo_4_devolvido_em_atraso;

SET @valor_multa2 = 0;
CALL sp_calcular_multa(6, @valor_multa2);
SELECT @valor_multa2 AS multa_emprestimo_6_devolvido_em_atraso;

CALL sp_transacao_cadastro_completo(
    'Novo Usuario Teste',
    '77777777777',
    'novousuario@libritech.com',
    '$2a$12$hashedsenhateste',
    'ALUNO',
    'Rua Teste, 999',
    'Bairro Teste',
    'Campina Grande',
    'PB'
);
SELECT * FROM usuarios WHERE cpf = '77777777777';
SELECT * FROM enderecos WHERE cidade = 'Campina Grande' ORDER BY id_endereco DESC LIMIT 1;

CALL sp_transacao_devolucao(5);
SELECT id_emprestimo, data_devolucao FROM emprestimos WHERE id_emprestimo = 5;
SELECT id_livro, quantidade_estoque, status FROM livros WHERE id_livro = 4;

EXPLAIN SELECT * FROM livros WHERE titulo LIKE 'Banco%';

EXPLAIN SELECT * FROM usuarios WHERE cpf = '44444444444';

EXPLAIN SELECT * FROM emprestimos WHERE id_usuario_fk = 4;

EXPLAIN SELECT * FROM emprestimos WHERE data_prevista < CURDATE();

EXPLAIN SELECT * FROM livros WHERE status = 'DISPONIVEL';

SET @hora_simulada = 22;
INSERT INTO emprestimos (id_usuario_fk, id_livro_fk, data_saida, data_prevista)
VALUES (6, 7, NOW(), DATE_ADD(CURDATE(), INTERVAL 7 DAY));
SET @hora_simulada = NULL;

SET @hora_simulada = 10;
INSERT INTO emprestimos (id_usuario_fk, id_livro_fk, data_saida, data_prevista)
VALUES (4, 7, NOW(), DATE_ADD(CURDATE(), INTERVAL 7 DAY));
SET @hora_simulada = NULL;

INSERT INTO emprestimos (id_usuario_fk, id_livro_fk, data_saida, data_prevista)
VALUES (4, 8, NOW(), DATE_ADD(CURDATE(), INTERVAL 7 DAY));

UPDATE livros SET quantidade_estoque = -1 WHERE id_livro = 1;

UPDATE livros SET status = 'RESERVADO' WHERE id_livro = 9;
CALL sp_renovar_emprestimo(5);
UPDATE livros SET status = 'DISPONIVEL' WHERE id_livro = 9;

DELETE FROM livros WHERE id_livro = 10;
SELECT * FROM log_auditoria;

SELECT * FROM emprestimos;
