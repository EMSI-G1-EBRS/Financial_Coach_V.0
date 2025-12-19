package com.tp.financial_coach_backend.profile.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserProfileResponse {

    private Long id;
    private String userId;
    private String email;

    // Informations personnelles
    private String fullName;
    private Integer age;
    private String occupation;
    private String country;
    private String city;

    // Informations financières
    private Double monthlyIncome;
    private Double monthlySavings;
    private Double savingsRate;
    private String riskTolerance;
    private List<String> financialGoals;
    private Map<String, Double> budgetCategories;

    // Préférences
    private String preferredLanguage;
    private String currency;

    // Métadonnées
    private Boolean hasCompletedOnboarding;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
