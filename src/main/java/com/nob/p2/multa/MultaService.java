package com.nob.p2.multa;

import org.springframework.stereotype.Service;

@Service
public class MultaService {

    private final MultaRepository repository;

    public MultaService(MultaRepository repository) {
        this.repository = repository;
    }
}
