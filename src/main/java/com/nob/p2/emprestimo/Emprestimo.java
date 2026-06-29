package com.nob.p2.emprestimo;

import lombok.Getter;
import lombok.Setter;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@Setter
public class Emprestimo {
    private Integer id;
    private Integer idUsuario;
    private Integer idLivro;
    private LocalDateTime dataSaida;
    private LocalDate dataPrevista;
    private LocalDateTime dataDevolucao;
}
