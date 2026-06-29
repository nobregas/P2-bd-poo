package com.nob.p2.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexao {

    private static final String URL = "jdbc:mysql://localhost:3306/db_libritech?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static Connection connection = null;

    public static String conectar(String usuario, String senha) {
        try {
            connection = DriverManager.getConnection(URL, usuario, senha);
            if (connection != null && connection.isValid(5)) {
                return null;
            }
            return "Conexão inválida após estabelecer.";
        } catch (SQLException e) {
            return "Erro de conexão com o banco de dados. Verifique as credenciais e se o servidor MySQL está rodando.";
        }
    }

    public static Connection getConnection() {
        return connection;
    }

    public static void desconectar() {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
            }
            connection = null;
        }
    }

    public static boolean isConectado() {
        try {
            return connection != null && connection.isValid(3);
        } catch (SQLException e) {
            return false;
        }
    }
}
