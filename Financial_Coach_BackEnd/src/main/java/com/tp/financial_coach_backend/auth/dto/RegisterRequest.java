package com.tp.financial_coach_backend.auth.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public class RegisterRequest {

    @NotBlank(message = "L'email est requis")
    @Email(message = "L'email doit être valide")
    private String email;

    @NotBlank(message = "Le mot de passe est requis")
    @Size(min = 8, message = "Le mot de passe doit contenir au moins 8 caractères")
    private String password;

    @NotBlank(message = "La confirmation du mot de passe est requise")
    private String confirmPassword;

    // Constructeur par défaut
    public RegisterRequest() {
    }

    // Constructeur avec tous les paramètres
    public RegisterRequest(String email, String password, String confirmPassword) {
        this.email = email;
        this.password = password;
        this.confirmPassword = confirmPassword;
    }

    // Getters
    public String getEmail() {
        return email;
    }

    public String getPassword() {
        return password;
    }

    public String getConfirmPassword() {
        return confirmPassword;
    }

    // Setters
    public void setEmail(String email) {
        this.email = email;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setConfirmPassword(String confirmPassword) {
        this.confirmPassword = confirmPassword;
    }

    // toString (optionnel, utile pour le debug)
    @Override
    public String toString() {
        return "RegisterRequest{" +
                "email='" + email + '\'' +
                ", password='[PROTECTED]'" +
                ", confirmPassword='[PROTECTED]'" +
                '}';
    }
}