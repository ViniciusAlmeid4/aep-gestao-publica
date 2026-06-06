package com.portal.gestao_publica.controllers;

import com.portal.gestao_publica.dtos.LoginRequestDTO;
import com.portal.gestao_publica.dtos.LoginResponseDTO;
import com.portal.gestao_publica.services.AuthService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/auth")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/login")
    public ResponseEntity<LoginResponseDTO> login(@RequestBody LoginRequestDTO dto) {
        return ResponseEntity.ok(authService.login(dto));
    }
}