package com.nob.p2.multa;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/multa")
@RequiredArgsConstructor
public class MultaController {

    private final MultaService service;
}
