package com.tp.financial_coach_backend.profile.controller;

import com.tp.financial_coach_backend.profile.dto.UserProfileRequest;
import com.tp.financial_coach_backend.profile.dto.UserProfileResponse;
import com.tp.financial_coach_backend.profile.service.UserProfileService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/profile")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class UserProfileController {

    private final UserProfileService profileService;

    /**
     * Récupérer l'ID de l'utilisateur authentifié
     */
    private UUID getCurrentUserId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String userId = (String) authentication.getPrincipal();
        return UUID.fromString(userId);
    }

    /**
     * GET /api/profile - Récupérer le profil de l'utilisateur authentifié
     */
    @GetMapping
    public ResponseEntity<UserProfileResponse> getProfile() {
        try {
            UUID userId = getCurrentUserId();
            UserProfileResponse profile = profileService.getProfileByUserId(userId);
            return ResponseEntity.ok(profile);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
    }

    /**
     * POST /api/profile - Créer un nouveau profil
     */
    @PostMapping
    public ResponseEntity<UserProfileResponse> createProfile(@RequestBody UserProfileRequest request) {
        try {
            UUID userId = getCurrentUserId();
            UserProfileResponse profile = profileService.createProfile(userId, request);
            return ResponseEntity.status(HttpStatus.CREATED).body(profile);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        }
    }

    /**
     * PUT /api/profile - Mettre à jour le profil existant
     */
    @PutMapping
    public ResponseEntity<UserProfileResponse> updateProfile(@RequestBody UserProfileRequest request) {
        try {
            UUID userId = getCurrentUserId();
            UserProfileResponse profile = profileService.updateProfile(userId, request);
            return ResponseEntity.ok(profile);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
    }

    /**
     * DELETE /api/profile - Supprimer le profil
     */
    @DeleteMapping
    public ResponseEntity<Void> deleteProfile() {
        try {
            UUID userId = getCurrentUserId();
            profileService.deleteProfile(userId);
            return ResponseEntity.noContent().build();
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
    }

    /**
     * GET /api/profile/exists - Vérifier si un profil existe
     */
    @GetMapping("/exists")
    public ResponseEntity<Boolean> hasProfile() {
        UUID userId = getCurrentUserId();
        boolean exists = profileService.hasProfile(userId);
        return ResponseEntity.ok(exists);
    }
}
