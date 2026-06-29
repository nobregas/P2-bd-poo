package com.nob.p2.auditoria;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
public class LogAuditoria {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String tabela;
    private String operacao;
    private String dadosAntigos;
    private String dadosNovos;
    private String usuario;
    private LocalDateTime dataHora;
}
