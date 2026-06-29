package com.nob.p2.auditoria;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/auditoria")
@RequiredArgsConstructor
public class LogAuditoriaController {

    private final LogAuditoriaService service;
}
