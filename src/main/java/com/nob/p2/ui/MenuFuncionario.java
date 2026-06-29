package com.nob.p2.ui;

import com.nob.p2.emprestimo.EmprestimoDAO;
import com.nob.p2.livro.LivroDAO;
import com.nob.p2.multa.MultaDAO;
import com.nob.p2.auditoria.LogAuditoriaDAO;
import com.nob.p2.emprestimo.Emprestimo;
import com.nob.p2.livro.Livro;
import com.nob.p2.multa.Multa;
import com.nob.p2.usuario.Usuario;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import javax.swing.JOptionPane;

public class MenuFuncionario {

    private final Usuario usuario;
    private final LivroDAO livroDAO;
    private final EmprestimoDAO emprestimoDAO;
    private final MultaDAO multaDAO;
    private final LogAuditoriaDAO logAuditoriaDAO;

    public MenuFuncionario(Usuario usuario) {
        this.usuario = usuario;
        this.livroDAO = new LivroDAO();
        this.emprestimoDAO = new EmprestimoDAO();
        this.multaDAO = new MultaDAO();
        this.logAuditoriaDAO = new LogAuditoriaDAO();
    }

    public void exibir() {
        String[] opcoes = {
            "Cadastrar Livro",
            "Realizar Empréstimo",
            "Renovar Empréstimo",
            "Realizar Devolução",
            "Excluir Livro",
            "Gerar Relatórios / Backup",
            "Sair"
        };

        while (true) {
            int escolha = JOptionPane.showOptionDialog(
                null,
                "Bem-vindo, " + usuario.getNome() + " (" + usuario.getTipo() + ")!\nEscolha uma opção:",
                "Menu do Funcionário",
                JOptionPane.DEFAULT_OPTION,
                JOptionPane.INFORMATION_MESSAGE,
                null,
                opcoes,
                opcoes[0]
            );

            switch (escolha) {
                case 0 -> cadastrarLivro();
                case 1 -> realizarEmprestimo();
                case 2 -> renovarEmprestimo();
                case 3 -> realizarDevolucao();
                case 4 -> excluirLivro();
                case 5 -> exibirSubMenuRelatorios();
                case 6, JOptionPane.CLOSED_OPTION -> {
                    JOptionPane.showMessageDialog(null, "Voltando ao login...");
                    return;
                }
            }
        }
    }

    private void cadastrarLivro() {
        try {
            String titulo = JOptionPane.showInputDialog("Título do livro:");
            if (titulo == null) return;
            String autor = JOptionPane.showInputDialog("Autor:");
            if (autor == null) return;
            String isbn = JOptionPane.showInputDialog("ISBN:");
            if (isbn == null) return;

            String precoStr = JOptionPane.showInputDialog("Preço de custo:");
            if (precoStr == null) return;
            BigDecimal preco = new BigDecimal(precoStr);

            String qtdStr = JOptionPane.showInputDialog("Quantidade em estoque:");
            if (qtdStr == null) return;
            int qtd = Integer.parseInt(qtdStr);

            Livro livro = new Livro();
            livro.setTitulo(titulo);
            livro.setAutor(autor);
            livro.setIsbn(isbn);
            livro.setPrecoCusto(preco);
            livro.setQuantidadeEstoque(qtd);
            livro.setStatus("DISPONIVEL");

            livroDAO.inserir(livro);
            JOptionPane.showMessageDialog(null, "Livro cadastrado com sucesso! ID: " + livro.getId());
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Erro ao cadastrar livro. Verifique os dados e tente novamente.", "Erro", JOptionPane.ERROR_MESSAGE);
        } catch (NumberFormatException e) {
            JOptionPane.showMessageDialog(null, "Valor numérico inválido.");
        }
    }

    private void realizarEmprestimo() {
        try {
            String idStr = JOptionPane.showInputDialog("ID do livro para empréstimo:");
            if (idStr == null) return;
            int idLivro = Integer.parseInt(idStr);

            emprestimoDAO.realizarEmprestimo(usuario.getId(), idLivro);
            JOptionPane.showMessageDialog(null, "Empréstimo realizado com sucesso!");
        } catch (SQLException e) {
            String msg = e.getMessage();
            if (msg != null && !msg.isBlank()) {
                JOptionPane.showMessageDialog(null, msg, "Erro", JOptionPane.ERROR_MESSAGE);
            } else {
                JOptionPane.showMessageDialog(null, "Erro ao realizar empréstimo.", "Erro", JOptionPane.ERROR_MESSAGE);
            }
        }
    }

    private void renovarEmprestimo() {
        try {
            String idStr = JOptionPane.showInputDialog("ID do empréstimo para renovar:");
            if (idStr == null) return;
            int id = Integer.parseInt(idStr);

            emprestimoDAO.renovarEmprestimo(id);
            JOptionPane.showMessageDialog(null, "Empréstimo renovado com sucesso! +7 dias.");
        } catch (SQLException e) {
            String msg = e.getMessage();
            if (msg != null && !msg.isBlank()) {
                JOptionPane.showMessageDialog(null, msg, "Erro", JOptionPane.ERROR_MESSAGE);
            } else {
                JOptionPane.showMessageDialog(null, "Erro ao renovar empréstimo.", "Erro", JOptionPane.ERROR_MESSAGE);
            }
        }
    }

    private void realizarDevolucao() {
        try {
            String idStr = JOptionPane.showInputDialog("ID do empréstimo para devolver:");
            if (idStr == null) return;
            int id = Integer.parseInt(idStr);

            emprestimoDAO.realizarDevolucao(id);

            BigDecimal multa = multaDAO.calcularMulta(id);
            if (multa.compareTo(BigDecimal.ZERO) > 0) {
                JOptionPane.showMessageDialog(null,
                    "Devolução realizada! Multa gerada: R$ " + multa);
            } else {
                JOptionPane.showMessageDialog(null, "Devolução realizada sem multas!");
            }
        } catch (SQLException e) {
            String msg = e.getMessage();
            if (msg != null && !msg.isBlank()) {
                JOptionPane.showMessageDialog(null, msg, "Erro", JOptionPane.ERROR_MESSAGE);
            } else {
                JOptionPane.showMessageDialog(null, "Erro ao realizar devolução.", "Erro", JOptionPane.ERROR_MESSAGE);
            }
        }
    }

    private void excluirLivro() {
        try {
            String idStr = JOptionPane.showInputDialog("ID do livro para excluir:");
            if (idStr == null) return;
            int id = Integer.parseInt(idStr);

            livroDAO.excluir(id);
            JOptionPane.showMessageDialog(null, "Livro excluído com sucesso!");
        } catch (SQLException e) {
            String msg = e.getMessage();
            if (msg != null && (msg.contains("Access denied") || msg.contains("DELETE") || msg.contains("permission"))) {
                JOptionPane.showMessageDialog(null,
                    "ERRO: Acesso Negado! Seu perfil de usuário não tem permissão para excluir registros do sistema.",
                    "Acesso Negado", JOptionPane.ERROR_MESSAGE);
            } else if (msg != null && !msg.isBlank()) {
                JOptionPane.showMessageDialog(null, msg, "Erro", JOptionPane.ERROR_MESSAGE);
            } else {
                JOptionPane.showMessageDialog(null, "Erro ao excluir livro.", "Erro", JOptionPane.ERROR_MESSAGE);
            }
        }
    }

    private void exibirSubMenuRelatorios() {
        String[] opcoes = {
            "Relatório Financeiro",
            "Log de Auditoria",
            "Ranking de Leitura",
            "Listar Todos os Livros",
            "Voltar"
        };

        while (true) {
            int escolha = JOptionPane.showOptionDialog(
                null, "Escolha um relatório:", "Relatórios",
                JOptionPane.DEFAULT_OPTION, JOptionPane.INFORMATION_MESSAGE,
                null, opcoes, opcoes[0]);

            switch (escolha) {
                case 0 -> gerarRelatorioFinanceiro();
                case 1 -> gerarLogAuditoria();
                case 2 -> gerarRankingLeitura();
                case 3 -> listarTodosLivros();
                case 4, JOptionPane.CLOSED_OPTION -> { return; }
            }
        }
    }

    private void gerarRelatorioFinanceiro() {
        try {
            StringBuilder sb = new StringBuilder("=== RELATÓRIO FINANCEIRO ===\n\n");
            List<Multa> multas = multaDAO.listarTodas();
            if (multas.isEmpty()) {
                sb.append("Nenhuma multa registrada.\n");
            } else {
                BigDecimal total = BigDecimal.ZERO;
                BigDecimal recebido = BigDecimal.ZERO;
                for (Multa m : multas) {
                    total = total.add(m.getValor());
                    if (m.getPago()) recebido = recebido.add(m.getValor());
                    sb.append(String.format("Multa ID %d | Empréstimo ID %d | R$%.2f | %s\n",
                        m.getId(), m.getIdEmprestimo(), m.getValor(),
                        m.getPago() ? "Pago" : "Pendente"));
                }
                sb.append(String.format("\nTotal: R$%.2f\nRecebido: R$%.2f\nPendente: R$%.2f\n",
                    total, recebido, total.subtract(recebido)));
            }
            JOptionPane.showMessageDialog(null, sb.toString(), "Financeiro", JOptionPane.INFORMATION_MESSAGE);
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Erro ao gerar relatório financeiro.", "Erro", JOptionPane.ERROR_MESSAGE);
        }
    }

    private void gerarLogAuditoria() {
        try {
            var logs = logAuditoriaDAO.listarTodos();
            if (logs.isEmpty()) {
                JOptionPane.showMessageDialog(null, "Nenhum registro de auditoria.");
                return;
            }
            StringBuilder sb = new StringBuilder("=== LOG DE AUDITORIA ===\n\n");
            for (var log : logs) {
                sb.append(String.format("[%s] %s na tabela %s por %s\nDados: %s\n\n",
                    log.getDataHora(), log.getAcao(), log.getTabelaAfetada(),
                    log.getUsuarioResponsavel(),
                    log.getDadosAntigos() != null ? log.getDadosAntigos() : "N/A"));
            }
            JOptionPane.showMessageDialog(null, sb.toString(), "Auditoria", JOptionPane.INFORMATION_MESSAGE);
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Erro ao consultar auditoria.", "Erro", JOptionPane.ERROR_MESSAGE);
        }
    }

    private void gerarRankingLeitura() {
        try {
            String sql = "SELECT * FROM vw_ranking_leitura";
            var stmt = com.nob.p2.config.Conexao.getConnection().createStatement();
            var rs = stmt.executeQuery(sql);

            StringBuilder sb = new StringBuilder("=== RANKING DE LEITURA ===\n\n");
            int pos = 1;
            while (rs.next()) {
                sb.append(String.format("%dº - %s (%s) - %d empréstimos\n",
                    pos++, rs.getString("titulo"), rs.getString("autor"),
                    rs.getInt("total_emprestimos")));
            }
            if (pos == 1) sb.append("Nenhum dado disponível.\n");
            JOptionPane.showMessageDialog(null, sb.toString(), "Ranking", JOptionPane.INFORMATION_MESSAGE);
            rs.close();
            stmt.close();
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Erro ao gerar ranking de leitura.", "Erro", JOptionPane.ERROR_MESSAGE);
        }
    }

    private void listarTodosLivros() {
        try {
            List<Livro> livros = livroDAO.listarTodos();
            if (livros.isEmpty()) {
                JOptionPane.showMessageDialog(null, "Nenhum livro cadastrado.");
                return;
            }
            StringBuilder sb = new StringBuilder("=== TODOS OS LIVROS ===\n\n");
            for (Livro l : livros) {
                sb.append(String.format("ID: %d | %s | %s | ISBN: %s | Preço: R$%.2f | Estoque: %d | %s\n",
                    l.getId(), l.getTitulo(), l.getAutor(), l.getIsbn(),
                    l.getPrecoCusto(), l.getQuantidadeEstoque(), l.getStatus()));
            }
            JOptionPane.showMessageDialog(null, sb.toString(), "Livros", JOptionPane.INFORMATION_MESSAGE);
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Erro ao consultar livros.", "Erro", JOptionPane.ERROR_MESSAGE);
        }
    }
}
