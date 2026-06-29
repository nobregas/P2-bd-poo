package com.nob.p2.multa;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class MultaService {

    private final MultaRepository repository;
}
