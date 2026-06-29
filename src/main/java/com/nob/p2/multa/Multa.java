package com.nob.p2.multa;

import com.nob.p2.emprestimo.Emprestimo;
import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
public class Multa {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "emprestimo_id")
    private Emprestimo emprestimo;

    private BigDecimal valor;
    private Boolean pago;
}
