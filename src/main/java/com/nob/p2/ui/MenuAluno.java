package com.nob.p2.ui;

import com.nob.p2.emprestimo.EmprestimoDAO;
import com.nob.p2.livro.LivroDAO;
import com.nob.p2.emprestimo.Emprestimo;
import com.nob.p2.livro.Livro;
import com.nob.p2.usuario.Usuario;
import java.sql.SQLException;
import java.util.List;
import javax.swing.JOptionPane;

public class MenuAluno {

    private final Usuario usuario;

    public MenuAluno(Usuario usuario) {
        this.usuario = usuario;
    }

    public void exibir() {
        String[] opcoes = {
            "Consultar Acervo Disponível",
            "Meus Empréstimos",
            "Sair"
        };

        while (true) {
            int escolha = JOptionPane.showOptionDialog(
                null,
                "Bem-vindo, " + usuario.getNome() + "!\nEscolha uma opção:",
                "Menu do Aluno",
                JOptionPane.DEFAULT_OPTION,
                JOptionPane.INFORMATION_MESSAGE,
                null,
                opcoes,
                opcoes[0]
            );

            switch (escolha) {
                case 0 -> consultarAcervo();
                case 1 -> meusEmprestimos();
                case 2, JOptionPane.CLOSED_OPTION -> {
                    JOptionPane.showMessageDialog(null, "Voltando ao login...");
                    return;
                }
            }
        }
    }

    private void consultarAcervo() {
        try {
            List<Livro> livros = new LivroDAO().listarAcervoPublico();
            if (livros.isEmpty()) {
                JOptionPane.showMessageDialog(null, "Nenhum livro disponível no acervo.");
                return;
            }
            StringBuilder sb = new StringBuilder("=== ACERVO DISPONÍVEL ===\n\n");
            for (Livro l : livros) {
                sb.append(String.format("ID: %d | %s | %s | ISBN: %s | Estoque: %d | %s\n",
                    l.getId(), l.getTitulo(), l.getAutor(), l.getIsbn(),
                    l.getQuantidadeEstoque(), l.getStatus()));
            }
            JOptionPane.showMessageDialog(null, sb.toString(), "Acervo", JOptionPane.INFORMATION_MESSAGE);
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Erro ao consultar acervo.", "Erro", JOptionPane.ERROR_MESSAGE);
        }
    }

    private void meusEmprestimos() {
        try {
            List<Emprestimo> lista = new EmprestimoDAO().listarPorUsuario(usuario.getId());
            if (lista.isEmpty()) {
                JOptionPane.showMessageDialog(null, "Nenhum empréstimo encontrado.");
                return;
            }
            StringBuilder sb = new StringBuilder("=== MEUS EMPRÉSTIMOS ===\n\n");
            for (Emprestimo e : lista) {
                String status = (e.getDataDevolucao() != null) ? "Devolvido" : "Ativo";
                sb.append(String.format("ID: %d | Livro ID: %d | Saída: %s | Prevista: %s | %s\n",
                    e.getId(), e.getIdLivro(),
                    e.getDataSaida() != null ? e.getDataSaida().toLocalDate() : "N/A",
                    e.getDataPrevista(), status));
            }
            JOptionPane.showMessageDialog(null, sb.toString(), "Empréstimos", JOptionPane.INFORMATION_MESSAGE);
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Erro ao listar empréstimos.", "Erro", JOptionPane.ERROR_MESSAGE);
        }
    }
}
