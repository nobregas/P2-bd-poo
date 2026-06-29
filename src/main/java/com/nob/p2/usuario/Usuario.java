package com.nob.p2.usuario;

import com.nob.p2.usuario.enums.Role;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public abstract class Usuario {
    private Integer id;
    private String nome;
    private String cpf;
    private String email;
    private String senha;
    private Boolean ativo;
    private Role tipo;

    public abstract int getDiasPrazoEmprestimo();
}
