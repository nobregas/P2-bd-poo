package com.nob.p2.usuario;

import com.nob.p2.usuario.enums.Role;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "usuarios")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Usuario {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_usuario")
    private Integer id;

    private String nome;
    private String cpf;
    private String email;
    private String senha;
    private Boolean ativo;

    @Enumerated(EnumType.STRING)
    private Role tipo;
}
