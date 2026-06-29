package com.nob.p2.emprestimo;

import com.nob.p2.livro.Livro;
import com.nob.p2.usuario.Usuario;
import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
public class Emprestimo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "usuario_id")
    private Usuario usuario;

    @ManyToOne
    @JoinColumn(name = "livro_id")
    private Livro livro;

    private LocalDate dataSaida;
    private LocalDate dataPrevista;
    private LocalDate dataDevolucao;
}
