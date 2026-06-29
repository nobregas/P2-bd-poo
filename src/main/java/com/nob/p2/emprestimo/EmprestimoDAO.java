package com.nob.p2.emprestimo;

import com.nob.p2.config.Conexao;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmprestimoDAO {

    private void setHoraSimulada() throws SQLException {
        Statement stmt = Conexao.getConnection().createStatement();
        stmt.execute("SET @hora_simulada = 10");
        stmt.close();
    }

    public void realizarEmprestimo(int idUsuario, int idLivro) throws SQLException {
//        setHoraSimulada();
        String sql = "CALL sp_transacao_emprestimo(?, ?)";
        CallableStatement stmt = Conexao.getConnection().prepareCall(sql);
        stmt.setInt(1, idUsuario);
        stmt.setInt(2, idLivro);
        stmt.execute();
    }

    public void renovarEmprestimo(int idEmprestimo) throws SQLException {
//        setHoraSimulada();
        String sql = "CALL sp_renovar_emprestimo(?)";
        CallableStatement stmt = Conexao.getConnection().prepareCall(sql);
        stmt.setInt(1, idEmprestimo);
        stmt.execute();
    }

    public void realizarDevolucao(int idEmprestimo) throws SQLException {
//        setHoraSimulada();
        String sql = "CALL sp_transacao_devolucao(?)";
        CallableStatement stmt = Conexao.getConnection().prepareCall(sql);
        stmt.setInt(1, idEmprestimo);
        stmt.execute();
    }

    public List<Emprestimo> listarPorUsuario(int idUsuario) throws SQLException {
        String sql = "SELECT * FROM emprestimos WHERE id_usuario_fk = ? ORDER BY data_saida DESC";
        PreparedStatement stmt = Conexao.getConnection().prepareStatement(sql);
        stmt.setInt(1, idUsuario);
        ResultSet rs = stmt.executeQuery();

        List<Emprestimo> emprestimos = new ArrayList<>();
        while (rs.next()) {
            emprestimos.add(mapearEmprestimo(rs));
        }
        return emprestimos;
    }

    private Emprestimo mapearEmprestimo(ResultSet rs) throws SQLException {
        Emprestimo emp = new Emprestimo();
        emp.setId(rs.getInt("id_emprestimo"));
        emp.setIdUsuario(rs.getInt("id_usuario_fk"));
        emp.setIdLivro(rs.getInt("id_livro_fk"));

        Timestamp saida = rs.getTimestamp("data_saida");
        if (saida != null) emp.setDataSaida(saida.toLocalDateTime());

        Date prevista = rs.getDate("data_prevista");
        if (prevista != null) emp.setDataPrevista(prevista.toLocalDate());

        Timestamp devolucao = rs.getTimestamp("data_devolucao");
        if (devolucao != null) emp.setDataDevolucao(devolucao.toLocalDateTime());

        return emp;
    }
}
