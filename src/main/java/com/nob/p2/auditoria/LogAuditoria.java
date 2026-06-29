package com.nob.p2.auditoria;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
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
