package com.nob.p2.emprestimo;

import org.springframework.stereotype.Service;

@Service
public class EmprestimoService {

    private final EmprestimoRepository repository;

    public EmprestimoService(EmprestimoRepository repository) {
        this.repository = repository;
    }
}
