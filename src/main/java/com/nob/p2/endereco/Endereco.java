package com.nob.p2.endereco;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Endereco {
    private Integer id;
    private String logradouro;
    private String bairro;
    private String cidade;
    private String uf;
    private Integer idUsuario;
}
