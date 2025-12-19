package com.tp.financial_coach_backend.auth.service;

import com.tp.financial_coach_backend.auth.dto.AuthResponse;
import com.tp.financial_coach_backend.auth.dto.LoginRequest;
import com.tp.financial_coach_backend.auth.dto.RefreshTokenRequest;
import com.tp.financial_coach_backend.auth.dto.RegisterRequest;
import com.tp.financial_coach_backend.auth.entity.RefreshToken;
import com.tp.financial_coach_backend.auth.entity.Role;
import com.tp.financial_coach_backend.auth.entity.User;
import com.tp.financial_coach_backend.auth.exception.AuthException;
import com.tp.financial_coach_backend.auth.repository.RefreshTokenRepository;
import com.tp.financial_coach_backend.auth.repository.RoleRepository;
import com.tp.financial_coach_backend.auth.repository.UserRepository;
import com.tp.financial_coach_backend.auth.security.JwtService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class AuthService {

    private static final Logger log = LoggerFactory.getLogger(AuthService.class);

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final RefreshTokenRepository refreshTokenRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;
    private final UserDetailsService userDetailsService;

    // Constructeur manuel
    public AuthService(
            UserRepository userRepository,
            RoleRepository roleRepository,
            RefreshTokenRepository refreshTokenRepository,
            PasswordEncoder passwordEncoder,
            JwtService jwtService,
            AuthenticationManager authenticationManager,
            UserDetailsService userDetailsService
    ) {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
        this.refreshTokenRepository = refreshTokenRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
        this.authenticationManager = authenticationManager;
        this.userDetailsService = userDetailsService;
    }

    /**
     * Inscription d'un nouvel utilisateur
     */
    @Transactional
    public AuthResponse register(RegisterRequest request) {
        log.info("Tentative d'inscription pour l'email: {}", request.getEmail());

        // Vérifier si l'email existe déjà
        if (userRepository.existsByEmail(request.getEmail())) {
            log.warn("Email déjà existant: {}", request.getEmail());
            throw new AuthException("Cet email est déjà utilisé");
        }

        // Vérifier que les mots de passe correspondent
        if (!request.getPassword().equals(request.getConfirmPassword())) {
            throw new AuthException("Les mots de passe ne correspondent pas");
        }

        // Récupérer le rôle USER par défaut
        Role userRole = roleRepository.findByName(Role.RoleName.ROLE_USER)
                .orElseGet(() -> {
                    Role newRole = Role.builder()
                            .name(Role.RoleName.ROLE_USER)
                            .build();
                    return roleRepository.save(newRole);
                });

        // Créer l'utilisateur
        User user = User.builder()
                .email(request.getEmail())
                .password(passwordEncoder.encode(request.getPassword()))
                .enabled(true)
                .emailVerified(false)
                .build();

        user.addRole(userRole);
        user = userRepository.save(user);

        log.info("Utilisateur créé avec succès: {} (ID: {})", user.getEmail(), user.getId());

        // Générer les tokens
        return generateAuthResponse(user);
    }

    /**
     * Connexion d'un utilisateur
     */
    @Transactional
    public AuthResponse login(LoginRequest request) {
        log.info("Tentative de connexion pour l'email: {}", request.getEmail());

        // Authentifier l'utilisateur
        try {
            authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(
                            request.getEmail(),
                            request.getPassword()
                    )
            );
        } catch (Exception e) {
            log.error("Échec de l'authentification pour: {}", request.getEmail());
            throw new AuthException("Email ou mot de passe incorrect");
        }

        // Récupérer l'utilisateur
        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new AuthException("Utilisateur non trouvé"));

        // Mettre à jour la date de dernière connexion
        user.setLastLogin(LocalDateTime.now());
        userRepository.save(user);

        log.info("Connexion réussie pour: {} (ID: {})", user.getEmail(), user.getId());

        // Générer les tokens
        return generateAuthResponse(user);
    }

    /**
     * Rafraîchir l'access token
     */
    @Transactional
    public AuthResponse refreshToken(RefreshTokenRequest request) {
        log.info("Tentative de rafraîchissement du token");

        // Vérifier le refresh token
        RefreshToken refreshToken = refreshTokenRepository.findByToken(request.getRefreshToken())
                .orElseThrow(() -> new AuthException("Refresh token invalide"));

        // Vérifier l'expiration
        if (refreshToken.isExpired()) {
            refreshTokenRepository.delete(refreshToken);
            log.warn("Refresh token expiré");
            throw new AuthException("Refresh token expiré");
        }

        // Récupérer l'utilisateur
        User user = refreshToken.getUser();
        log.info("Rafraîchissement du token pour: {} (ID: {})", user.getEmail(), user.getId());

        // Générer un nouveau access token
        UserDetails userDetails = userDetailsService.loadUserByUsername(user.getEmail());
        String newAccessToken = jwtService.generateAccessToken(userDetails, user.getId());

        Set<String> roles = user.getRoles().stream()
                .map(role -> role.getName().name())
                .collect(Collectors.toSet());

        return AuthResponse.builder()
                .userId(user.getId())
                .email(user.getEmail())
                .accessToken(newAccessToken)
                .refreshToken(request.getRefreshToken())
                .tokenType("Bearer")
                .expiresIn(jwtService.getAccessTokenExpirationInSeconds())
                .roles(roles)
                .build();
    }

    /**
     * Déconnexion (supprime le refresh token)
     */
    @Transactional
    public void logout(String refreshToken) {
        log.info("Déconnexion demandée");
        refreshTokenRepository.findByToken(refreshToken).ifPresent(token -> {
            refreshTokenRepository.delete(token);
            log.info("Refresh token supprimé pour l'utilisateur ID: {}", token.getUser().getId());
        });
    }

    /**
     * Génère la réponse d'authentification complète
     */
    private AuthResponse generateAuthResponse(User user) {
        UserDetails userDetails = userDetailsService.loadUserByUsername(user.getEmail());

        // Générer access token
        String accessToken = jwtService.generateAccessToken(userDetails, user.getId());

        // Générer refresh token
        String refreshTokenString = jwtService.generateRefreshToken(userDetails);

        // Sauvegarder le refresh token en base
        RefreshToken refreshToken = RefreshToken.builder()
                .token(refreshTokenString)
                .user(user)
                .expiryDate(LocalDateTime.now().plusSeconds(jwtService.getRefreshTokenExpirationInSeconds()))
                .build();
        refreshTokenRepository.save(refreshToken);

        // Extraire les rôles
        Set<String> roles = user.getRoles().stream()
                .map(role -> role.getName().name())
                .collect(Collectors.toSet());

        return AuthResponse.builder()
                .userId(user.getId())
                .email(user.getEmail())
                .accessToken(accessToken)
                .refreshToken(refreshTokenString)
                .tokenType("Bearer")
                .expiresIn(jwtService.getAccessTokenExpirationInSeconds())
                .roles(roles)
                .build();
    }
}