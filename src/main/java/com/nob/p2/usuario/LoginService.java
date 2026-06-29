package com.nob.p2.usuario;

import com.nob.p2.config.Conexao;
import java.sql.SQLException;
import javax.swing.JOptionPane;

public class LoginService {

    public String selecionarPerfil() {
        String[] opcoes = {"Funcionário", "Aluno", "Sair"};
        int escolha = JOptionPane.showOptionDialog(
            null,
            "Qual é o seu perfil de acesso?",
            "LibriTech - Login",
            JOptionPane.DEFAULT_OPTION,
            JOptionPane.QUESTION_MESSAGE,
            null,
            opcoes,
            opcoes[0]
        );

        if (escolha == 2 || escolha == JOptionPane.CLOSED_OPTION) {
            return null;
        }
        return opcoes[escolha];
    }

    public boolean autenticar(String titulo) {
        String usuario = JOptionPane.showInputDialog(
            null, "Usuário do Banco (ex: usr_gerente, usr_bibliotecario, usr_estagiario, usr_aluno):",
            titulo, JOptionPane.QUESTION_MESSAGE);
        if (usuario == null) return false;

        String senha = JOptionPane.showInputDialog(
            null, "Senha do Banco:",
            titulo, JOptionPane.QUESTION_MESSAGE);
        if (senha == null) return false;

        String erro = Conexao.conectar(usuario, senha);
        if (erro == null) {
            JOptionPane.showMessageDialog(null,
                "Conectado como " + usuario + "!",
                "Sucesso", JOptionPane.INFORMATION_MESSAGE);
            return true;
        }

        JOptionPane.showMessageDialog(null,
            "Erro de conexão:\n" + erro,
            "Erro de Conexão", JOptionPane.ERROR_MESSAGE);
        return false;
    }

    public Usuario buscarUsuarioLogado(String email, String senha) {
        try {
            UsuarioDAO usuarioDAO = new UsuarioDAO();
            Usuario usuario = usuarioDAO.buscarPorEmail(email);

            if (usuario != null && usuario.getSenha().equals(senha)) {
                return usuario;
            }
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null,
                "Erro ao consultar o banco de dados. Tente novamente.",
                "Erro", JOptionPane.ERROR_MESSAGE);
        }
        return null;
    }
}
