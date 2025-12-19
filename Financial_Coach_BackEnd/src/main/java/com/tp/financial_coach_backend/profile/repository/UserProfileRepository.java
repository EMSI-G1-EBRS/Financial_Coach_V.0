package com.tp.financial_coach_backend.profile.repository;

import com.tp.financial_coach_backend.profile.entity.UserProfile;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface UserProfileRepository extends JpaRepository<UserProfile, Long> {

    Optional<UserProfile> findByUserId(UUID userId);

    boolean existsByUserId(UUID userId);

    void deleteByUserId(UUID userId);
}
