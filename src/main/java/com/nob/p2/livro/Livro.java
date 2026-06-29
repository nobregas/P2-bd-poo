package com.nob.p2.livro;

import lombok.Getter;
import lombok.Setter;
import java.math.BigDecimal;

@Getter
@Setter
public class Livro {
    private Integer id;
    private String titulo;
    private String autor;
    private String isbn;
    private BigDecimal precoCusto;
    private Integer quantidadeEstoque;
    private String status;
}
