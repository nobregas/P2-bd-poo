package com.nob.p2.ui;

import com.nob.p2.config.Conexao;
import com.nob.p2.usuario.LoginService;
import com.nob.p2.usuario.Usuario;
import javax.swing.*;

public class TelaLogin {

    private final LoginService loginService;

    public TelaLogin() {
        this.loginService = new LoginService();
    }

    public void iniciar() {
        while (true) {
            String perfil = loginService.selecionarPerfil();
            if (perfil == null) {
                JOptionPane.showMessageDialog(null, "Saindo do sistema...");
                return;
            }

            boolean conectado = loginService.autenticar("Login " + perfil);
            if (!conectado) continue;

            Usuario usuario = null;
            while (usuario == null) {
                String email = JOptionPane.showInputDialog(null,
                    "Email do usuário:", "Identificação", JOptionPane.QUESTION_MESSAGE);
                if (email == null) break;

                String senha = JOptionPane.showInputDialog(null,
                    "Senha do usuário:", "Identificação", JOptionPane.QUESTION_MESSAGE);
                if (senha == null) break;

                usuario = loginService.buscarUsuarioLogado(email, senha);
                if (usuario == null) {
                    JOptionPane.showMessageDialog(null,
                        "Usuário ou senha inválidos.", "Erro", JOptionPane.ERROR_MESSAGE);
                }
            }

            if (usuario == null) {
                Conexao.desconectar();
                continue;
            }

            if (perfil.equals("Funcionário")) {
                new MenuFuncionario(usuario).exibir();
            } else {
                new MenuAluno(usuario).exibir();
            }

            Conexao.desconectar();
        }
    }
}
