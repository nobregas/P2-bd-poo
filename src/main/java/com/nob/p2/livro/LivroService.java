package com.nob.p2.livro;

import org.springframework.stereotype.Service;

@Service
public class LivroService {

    private final LivroRepository repository;

    public LivroService(LivroRepository repository) {
        this.repository = repository;
    }
}
