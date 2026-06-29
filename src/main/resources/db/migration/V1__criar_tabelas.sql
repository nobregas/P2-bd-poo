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
