package com.tp.financial_coach_backend.auth.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Set;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AuthResponse {

    private UUID userId;
    private String email;
    private String accessToken;
    private String refreshToken;
    private String tokenType = "Bearer";
    private Long expiresIn; // en secondes
    private Set<String> roles;

    public AuthResponse(UUID userId, String email, String accessToken, String refreshToken, Long expiresIn, Set<String> roles) {
        this.userId = userId;
        this.email = email;
        this.accessToken = accessToken;
        this.refreshToken = refreshToken;
        this.expiresIn = expiresIn;
        this.roles = roles;
    }
}
