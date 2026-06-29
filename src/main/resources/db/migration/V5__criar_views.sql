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

GRANT SELECT ON db_libritech.vw_acervo_publico TO 'usr_estagiario'@'localhost';
GRANT SELECT ON db_libritech.vw_acervo_publico TO 'usr_aluno'@'localhost';
GRANT SELECT ON db_libritech.vw_livros_atrasados TO 'usr_aluno'@'localhost';
GRANT SELECT ON db_libritech.vw_ranking_leitura TO 'usr_aluno'@'localhost';
