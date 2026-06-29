package com.nob.p2.multa;

import lombok.Getter;
import lombok.Setter;
import java.math.BigDecimal;

@Getter
@Setter
public class Multa {
    private Integer id;
    private Integer idEmprestimo;
    private BigDecimal valor;
    private Boolean pago;
}
