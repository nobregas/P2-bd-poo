package com.nob.p2.auditoria;

import org.springframework.stereotype.Service;

@Service
public class LogAuditoriaService {

    private final LogAuditoriaRepository repository;

    public LogAuditoriaService(LogAuditoriaRepository repository) {
        this.repository = repository;
    }
}
