package com.nob.p2.livro;

import com.nob.p2.config.Conexao;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LivroDAO {

    public List<Livro> listarAcervoPublico() throws SQLException {
        String sql = "SELECT * FROM vw_acervo_publico";
        Statement stmt = Conexao.getConnection().createStatement();
        ResultSet rs = stmt.executeQuery(sql);

        List<Livro> livros = new ArrayList<>();
        while (rs.next()) {
            livros.add(mapearLivro(rs));
        }
        return livros;
    }

    public List<Livro> listarTodos() throws SQLException {
        String sql = "SELECT * FROM livros";
        Statement stmt = Conexao.getConnection().createStatement();
        ResultSet rs = stmt.executeQuery(sql);

        List<Livro> livros = new ArrayList<>();
        while (rs.next()) {
            livros.add(mapearLivro(rs));
        }
        return livros;
    }

    public Livro buscarPorId(int id) throws SQLException {
        String sql = "SELECT * FROM livros WHERE id_livro = ?";
        PreparedStatement stmt = Conexao.getConnection().prepareStatement(sql);
        stmt.setInt(1, id);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            return mapearLivro(rs);
        }
        return null;
    }

    public void inserir(Livro livro) throws SQLException {
        String sql = "INSERT INTO livros (titulo, autor, isbn, preco_custo, quantidade_estoque, status) VALUES (?, ?, ?, ?, ?, ?)";
        PreparedStatement stmt = Conexao.getConnection().prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        stmt.setString(1, livro.getTitulo());
        stmt.setString(2, livro.getAutor());
        stmt.setString(3, livro.getIsbn());
        stmt.setBigDecimal(4, livro.getPrecoCusto());
        stmt.setInt(5, livro.getQuantidadeEstoque());
        stmt.setString(6, livro.getStatus());
        stmt.executeUpdate();

        ResultSet rs = stmt.getGeneratedKeys();
        if (rs.next()) {
            livro.setId(rs.getInt(1));
        }
    }

    public void excluir(int id) throws SQLException {
        String sql = "DELETE FROM livros WHERE id_livro = ?";
        PreparedStatement stmt = Conexao.getConnection().prepareStatement(sql);
        stmt.setInt(1, id);
        stmt.executeUpdate();
    }

    private Livro mapearLivro(ResultSet rs) throws SQLException {
        Livro livro = new Livro();
        livro.setId(rs.getInt("id_livro"));
        livro.setTitulo(rs.getString("titulo"));
        livro.setAutor(rs.getString("autor"));
        livro.setIsbn(rs.getString("isbn"));

        try {
            livro.setPrecoCusto(rs.getBigDecimal("preco_custo"));
        } catch (SQLException e) {
            livro.setPrecoCusto(BigDecimal.ZERO);
        }

        livro.setQuantidadeEstoque(rs.getInt("quantidade_estoque"));
        livro.setStatus(rs.getString("status"));
        return livro;
    }
}
