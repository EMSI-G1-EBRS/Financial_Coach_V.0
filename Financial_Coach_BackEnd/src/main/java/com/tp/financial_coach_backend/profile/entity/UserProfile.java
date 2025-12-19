package com.tp.financial_coach_backend.profile.entity;

import com.tp.financial_coach_backend.auth.entity.User;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Entity
@Table(name = "user_profiles")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserProfile {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    @JoinColumn(name = "user_id", nullable = false, unique = true)
    private User user;

    // Informations personnelles
    @Column(name = "full_name")
    private String fullName;

    @Column(name = "age")
    private Integer age;

    @Column(name = "occupation")
    private String occupation;

    @Column(name = "country")
    private String country;

    @Column(name = "city")
    private String city;

    // Informations financières
    @Column(name = "monthly_income")
    private Double monthlyIncome;

    @Column(name = "monthly_savings")
    private Double monthlySavings;

    @Column(name = "risk_tolerance")
    private String riskTolerance; // low, medium, high

    // Objectifs financiers (stockés en JSON)
    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "user_financial_goals", joinColumns = @JoinColumn(name = "profile_id"))
    @Column(name = "goal")
    @Builder.Default
    private List<String> financialGoals = new ArrayList<>();

    // Catégories de budget (stockées en JSON)
    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "user_budget_categories", joinColumns = @JoinColumn(name = "profile_id"))
    @MapKeyColumn(name = "category")
    @Column(name = "amount")
    @Builder.Default
    private Map<String, Double> budgetCategories = new HashMap<>();

    // Préférences
    @Column(name = "preferred_language")
    private String preferredLanguage;

    @Column(name = "currency")
    private String currency;

    // Métadonnées
    @Column(name = "has_completed_onboarding")
    @Builder.Default
    private Boolean hasCompletedOnboarding = false;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    // Calculer le taux d'épargne
    public Double getSavingsRate() {
        if (monthlyIncome != null && monthlySavings != null && monthlyIncome > 0) {
            return (monthlySavings / monthlyIncome) * 100;
        }
        return null;
    }
}
