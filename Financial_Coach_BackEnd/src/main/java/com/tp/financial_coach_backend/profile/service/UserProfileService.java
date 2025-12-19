package com.tp.financial_coach_backend.profile.service;

import com.tp.financial_coach_backend.auth.entity.User;
import com.tp.financial_coach_backend.auth.repository.UserRepository;
import com.tp.financial_coach_backend.profile.dto.UserProfileRequest;
import com.tp.financial_coach_backend.profile.dto.UserProfileResponse;
import com.tp.financial_coach_backend.profile.entity.UserProfile;
import com.tp.financial_coach_backend.profile.repository.UserProfileRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class UserProfileService {

    private final UserProfileRepository profileRepository;
    private final UserRepository userRepository;

    @Transactional(readOnly = true)
    public UserProfileResponse getProfileByUserId(UUID userId) {
        UserProfile profile = profileRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("Profil non trouvé pour l'utilisateur ID: " + userId));
        return mapToResponse(profile);
    }

    @Transactional
    public UserProfileResponse createProfile(UUID userId, UserProfileRequest request) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Utilisateur non trouvé avec l'ID: " + userId));

        if (profileRepository.existsByUserId(userId)) {
            throw new RuntimeException("Un profil existe déjà pour cet utilisateur");
        }

        UserProfile profile = UserProfile.builder()
                .user(user)
                .fullName(request.getFullName())
                .age(request.getAge())
                .occupation(request.getOccupation())
                .country(request.getCountry())
                .city(request.getCity())
                .monthlyIncome(request.getMonthlyIncome())
                .monthlySavings(request.getMonthlySavings())
                .riskTolerance(request.getRiskTolerance())
                .financialGoals(request.getFinancialGoals() != null ? request.getFinancialGoals() : new ArrayList<>())
                .budgetCategories(request.getBudgetCategories() != null ? request.getBudgetCategories() : new HashMap<>())
                .preferredLanguage(request.getPreferredLanguage() != null ? request.getPreferredLanguage() : "fr")
                .currency(request.getCurrency() != null ? request.getCurrency() : "EUR")
                .hasCompletedOnboarding(request.getHasCompletedOnboarding() != null ? request.getHasCompletedOnboarding() : false)
                .build();

        profile = profileRepository.save(profile);
        return mapToResponse(profile);
    }

    @Transactional
    public UserProfileResponse updateProfile(UUID userId, UserProfileRequest request) {
        UserProfile profile = profileRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("Profil non trouvé pour l'utilisateur ID: " + userId));

        // Mettre à jour les informations personnelles
        if (request.getFullName() != null) profile.setFullName(request.getFullName());
        if (request.getAge() != null) profile.setAge(request.getAge());
        if (request.getOccupation() != null) profile.setOccupation(request.getOccupation());
        if (request.getCountry() != null) profile.setCountry(request.getCountry());
        if (request.getCity() != null) profile.setCity(request.getCity());

        // Mettre à jour les informations financières
        if (request.getMonthlyIncome() != null) profile.setMonthlyIncome(request.getMonthlyIncome());
        if (request.getMonthlySavings() != null) profile.setMonthlySavings(request.getMonthlySavings());
        if (request.getRiskTolerance() != null) profile.setRiskTolerance(request.getRiskTolerance());
        if (request.getFinancialGoals() != null) profile.setFinancialGoals(request.getFinancialGoals());
        if (request.getBudgetCategories() != null) profile.setBudgetCategories(request.getBudgetCategories());

        // Mettre à jour les préférences
        if (request.getPreferredLanguage() != null) profile.setPreferredLanguage(request.getPreferredLanguage());
        if (request.getCurrency() != null) profile.setCurrency(request.getCurrency());

        // Mettre à jour les métadonnées
        if (request.getHasCompletedOnboarding() != null) profile.setHasCompletedOnboarding(request.getHasCompletedOnboarding());

        profile = profileRepository.save(profile);
        return mapToResponse(profile);
    }

    @Transactional
    public void deleteProfile(UUID userId) {
        if (!profileRepository.existsByUserId(userId)) {
            throw new RuntimeException("Profil non trouvé pour l'utilisateur ID: " + userId);
        }
        profileRepository.deleteByUserId(userId);
    }

    @Transactional(readOnly = true)
    public boolean hasProfile(UUID userId) {
        return profileRepository.existsByUserId(userId);
    }

    private UserProfileResponse mapToResponse(UserProfile profile) {
        return UserProfileResponse.builder()
                .id(profile.getId())
                .userId(profile.getUser().getId().toString())
                .email(profile.getUser().getEmail())
                .fullName(profile.getFullName())
                .age(profile.getAge())
                .occupation(profile.getOccupation())
                .country(profile.getCountry())
                .city(profile.getCity())
                .monthlyIncome(profile.getMonthlyIncome())
                .monthlySavings(profile.getMonthlySavings())
                .savingsRate(profile.getSavingsRate())
                .riskTolerance(profile.getRiskTolerance())
                .financialGoals(profile.getFinancialGoals())
                .budgetCategories(profile.getBudgetCategories())
                .preferredLanguage(profile.getPreferredLanguage())
                .currency(profile.getCurrency())
                .hasCompletedOnboarding(profile.getHasCompletedOnboarding())
                .createdAt(profile.getCreatedAt())
                .updatedAt(profile.getUpdatedAt())
                .build();
    }
}
