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

GRANT INSERT ON db_libritech.emprestimos TO 'usr_estagiario'@'localhost';
GRANT SELECT ON db_libritech.emprestimos TO 'usr_estagiario'@'localhost';
GRANT SELECT ON db_libritech.usuarios TO 'usr_estagiario'@'localhost';
GRANT DELETE ON db_libritech.livros TO 'usr_estagiario'@'localhost';
REVOKE DELETE ON db_libritech.livros FROM 'usr_estagiario'@'localhost';

FLUSH PRIVILEGES;
