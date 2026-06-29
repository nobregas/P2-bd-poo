package com.nob.p2.endereco;

import com.nob.p2.config.Conexao;
import java.sql.*;

public class EnderecoDAO {

    public void inserir(Endereco endereco) throws SQLException {
        String sql = "INSERT INTO enderecos (logradouro, bairro, cidade, uf, id_usuario_fk) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement stmt = Conexao.getConnection().prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        stmt.setString(1, endereco.getLogradouro());
        stmt.setString(2, endereco.getBairro());
        stmt.setString(3, endereco.getCidade());
        stmt.setString(4, endereco.getUf());
        stmt.setInt(5, endereco.getIdUsuario());
        stmt.executeUpdate();

        ResultSet rs = stmt.getGeneratedKeys();
        if (rs.next()) {
            endereco.setId(rs.getInt(1));
        }
    }

    public Endereco buscarPorIdUsuario(int idUsuario) throws SQLException {
        String sql = "SELECT * FROM enderecos WHERE id_usuario_fk = ?";
        PreparedStatement stmt = Conexao.getConnection().prepareStatement(sql);
        stmt.setInt(1, idUsuario);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            Endereco endereco = new Endereco();
            endereco.setId(rs.getInt("id_endereco"));
            endereco.setLogradouro(rs.getString("logradouro"));
            endereco.setBairro(rs.getString("bairro"));
            endereco.setCidade(rs.getString("cidade"));
            endereco.setUf(rs.getString("uf"));
            endereco.setIdUsuario(rs.getInt("id_usuario_fk"));
            return endereco;
        }
        return null;
    }
}
