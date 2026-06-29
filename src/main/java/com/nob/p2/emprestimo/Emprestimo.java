package com.nob.p2.emprestimo;

import com.nob.p2.livro.Livro;
import com.nob.p2.usuario.Usuario;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Emprestimo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_emprestimo")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "id_usuario_fk")
    private Usuario usuario;

    @ManyToOne
    @JoinColumn(name = "id_livro_fk")
    private Livro livro;

    private LocalDateTime dataSaida;
    private LocalDate dataPrevista;
    private LocalDateTime dataDevolucao;
}
