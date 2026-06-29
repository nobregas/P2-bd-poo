package com.nob.p2.endereco;

import org.springframework.stereotype.Service;

@Service
public class EnderecoService {

    private final EnderecoRepository repository;

    public EnderecoService(EnderecoRepository repository) {
        this.repository = repository;
    }
}
