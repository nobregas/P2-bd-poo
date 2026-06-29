package com.nob.p2.multa;

import com.nob.p2.emprestimo.Emprestimo;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;

@Entity
@Table(name = "multas")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Multa {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_multa")
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "id_emprestimo_fk")
    private Emprestimo emprestimo;

    private BigDecimal valor;
    private Boolean pago;
}
