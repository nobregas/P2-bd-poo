package com.nob.p2.usuario;

import com.nob.p2.config.Conexao;
import com.nob.p2.usuario.enums.Role;
import java.sql.*;

public class UsuarioDAO {

    public Usuario buscarPorEmail(String email) throws SQLException {
        String sql = "SELECT * FROM vw_login_usuario WHERE email = ? AND ativo = 1";
        PreparedStatement stmt = Conexao.getConnection().prepareStatement(sql);
        stmt.setString(1, email);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            return mapearUsuario(rs);
        }
        return null;
    }

    public Usuario buscarPorId(int id) throws SQLException {
        String sql = "SELECT * FROM vw_login_usuario WHERE id_usuario = ?";
        PreparedStatement stmt = Conexao.getConnection().prepareStatement(sql);
        stmt.setInt(1, id);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            return mapearUsuario(rs);
        }
        return null;
    }

    private Usuario mapearUsuario(ResultSet rs) throws SQLException {
        String tipo = rs.getString("tipo");
        Role role = Role.valueOf(tipo);

        Usuario usuario;
        if (role == Role.ALUNO) {
            usuario = new Aluno();
        } else {
            usuario = new Funcionario();
        }

        usuario.setId(rs.getInt("id_usuario"));
        usuario.setNome(rs.getString("nome"));
        usuario.setCpf(rs.getString("cpf"));
        usuario.setEmail(rs.getString("email"));
        usuario.setSenha(rs.getString("senha"));
        usuario.setAtivo(rs.getBoolean("ativo"));
        usuario.setTipo(role);

        return usuario;
    }
}
