package com.nob.p2.auditoria;

import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Getter
@Setter
public class LogAuditoria {
    private Integer id;
    private String tabelaAfetada;
    private String acao;
    private String usuarioResponsavel;
    private String dadosAntigos;
    private LocalDateTime dataHora;
}
