package com.nob.p2.multa;

import com.nob.p2.config.Conexao;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MultaDAO {

    public BigDecimal calcularMulta(int idEmprestimo) throws SQLException {
        String sql = "{CALL sp_calcular_multa(?, ?)}";
        CallableStatement stmt = Conexao.getConnection().prepareCall(sql);
        stmt.setInt(1, idEmprestimo);
        stmt.registerOutParameter(2, Types.DECIMAL);
        stmt.execute();
        return stmt.getBigDecimal(2);
    }

    public List<Multa> listarTodas() throws SQLException {
        String sql = "SELECT * FROM multas";
        Statement stmt = Conexao.getConnection().createStatement();
        ResultSet rs = stmt.executeQuery(sql);

        List<Multa> multas = new ArrayList<>();
        while (rs.next()) {
            multas.add(mapearMulta(rs));
        }
        return multas;
    }

    private Multa mapearMulta(ResultSet rs) throws SQLException {
        Multa multa = new Multa();
        multa.setId(rs.getInt("id_multa"));
        multa.setIdEmprestimo(rs.getInt("id_emprestimo_fk"));
        multa.setValor(rs.getBigDecimal("valor"));
        multa.setPago(rs.getBoolean("pago"));
        return multa;
    }
}
