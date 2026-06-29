package com.nob.p2.auditoria;

import com.nob.p2.config.Conexao;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LogAuditoriaDAO {

    public List<LogAuditoria> listarTodos() throws SQLException {
        String sql = "SELECT * FROM log_auditoria ORDER BY data_hora DESC";
        Statement stmt = Conexao.getConnection().createStatement();
        ResultSet rs = stmt.executeQuery(sql);

        List<LogAuditoria> logs = new ArrayList<>();
        while (rs.next()) {
            LogAuditoria log = new LogAuditoria();
            log.setId(rs.getInt("id_log"));
            log.setTabelaAfetada(rs.getString("tabela_afetada"));
            log.setAcao(rs.getString("acao"));
            log.setUsuarioResponsavel(rs.getString("usuario_responsavel"));
            log.setDadosAntigos(rs.getString("dados_antigos"));

            Timestamp ts = rs.getTimestamp("data_hora");
            if (ts != null) log.setDataHora(ts.toLocalDateTime());

            logs.add(log);
        }
        return logs;
    }
}
