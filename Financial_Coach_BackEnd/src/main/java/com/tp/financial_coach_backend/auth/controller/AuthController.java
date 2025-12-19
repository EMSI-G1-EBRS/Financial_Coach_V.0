package com.tp.financial_coach_backend.auth.controller;

import com.tp.financial_coach_backend.auth.dto.AuthResponse;
import com.tp.financial_coach_backend.auth.dto.LoginRequest;
import com.tp.financial_coach_backend.auth.dto.RefreshTokenRequest;
import com.tp.financial_coach_backend.auth.dto.RegisterRequest;
import com.tp.financial_coach_backend.auth.service.AuthService;
import jakarta.validation.Valid;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping
@CrossOrigin(origins = "*")
public class AuthController {

    private static final Logger log = LoggerFactory.getLogger(AuthController.class);
    private final AuthService authService;

    // Constructeur manuel
    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    /**
     * Inscription d'un nouvel utilisateur
     * POST /register
     */
    @PostMapping("/register")
    public ResponseEntity<AuthResponse> register(@Valid @RequestBody RegisterRequest request) {
        log.info("Requête d'inscription reçue pour: {}", request.getEmail());
        AuthResponse response = authService.register(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    /**
     * Connexion d'un utilisateur
     * POST /login
     */
    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@Valid @RequestBody LoginRequest request) {
        log.info("Requête de connexion reçue pour: {}", request.getEmail());
        AuthResponse response = authService.login(request);
        return ResponseEntity.ok(response);
    }

    /**
     * Rafraîchir l'access token
     * POST /refresh
     */
    @PostMapping("/refresh")
    public ResponseEntity<AuthResponse> refresh(@Valid @RequestBody RefreshTokenRequest request) {
        log.info("Requête de rafraîchissement du token");
        AuthResponse response = authService.refreshToken(request);
        return ResponseEntity.ok(response);
    }

    /**
     * Déconnexion (supprime le refresh token)
     * POST /logout
     */
    @PostMapping("/logout")
    public ResponseEntity<Map<String, String>> logout(@Valid @RequestBody RefreshTokenRequest request) {
        log.info("Requête de déconnexion");
        authService.logout(request.getRefreshToken());
        return ResponseEntity.ok(Map.of("message", "Déconnexion réussie"));
    }

    /**
     * Health check
     * GET /health
     */
    @GetMapping("/health")
    public ResponseEntity<Map<String, String>> health() {
        return ResponseEntity.ok(Map.of(
                "status", "UP",
                "service", "auth-service",
                "timestamp", String.valueOf(System.currentTimeMillis())
        ));
    }
}