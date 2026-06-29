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
    @Column(name = "id_log")
    private Integer id;

    private String tabelaAfetada;
    private String acao;
    private String usuarioResponsavel;
    private String dadosAntigos;
    private LocalDateTime dataHora;
}
