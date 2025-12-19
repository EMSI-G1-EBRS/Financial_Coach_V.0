import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Auth imports
import 'providers/auth_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/user_profile_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/avatar_provider.dart';
import 'services/auth_service.dart';
import 'services/secure_storage_service.dart';
import 'services/api_service.dart';
import 'services/voice_service.dart';
import 'services/profile_service.dart';
import 'theme/app_theme.dart';

// Screens
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/change_image_screen.dart';
import 'screens/about_us_screen.dart';
import 'screens/faq_screen.dart';
import 'screens/help_feedback_screen.dart';
import 'screens/support_us_screen.dart';
import 'screens/language_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Configuration de l'URL de base selon la plateforme
  String get authBaseUrl {
    // Si c'est le web, utiliser localhost
    if (kIsWeb) {
      return 'http://localhost:8081/api/auth';
    }

    // Sinon, détecter la plateforme mobile/desktop
    if (Platform.isAndroid) {
      // Pour l'émulateur Android
      return 'http://10.0.2.2:8081/api/auth';
    } else if (Platform.isIOS) {
      // Pour le simulateur iOS
      return 'http://localhost:8081/api/auth';
    } else {
      // Pour un appareil physique (remplacer par votre IP)
      return 'http://192.168.1.100:8081/api/auth';
    }
  }

  String get chatBaseUrl {
    // Si c'est le web, utiliser localhost
    if (kIsWeb) {
      return 'http://localhost:5000';
    }

    // Sinon, détecter la plateforme mobile/desktop
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:5000';
    } else if (Platform.isIOS) {
      return 'http://localhost:5000';
    } else {
      // Pour un appareil physique (remplacer par votre IP)
      return 'http://10.29.58.82:5000';
    }
  }

  String get profileBaseUrl {
    // Si c'est le web, utiliser localhost
    if (kIsWeb) {
      return 'http://localhost:8081/api';
    }

    // Sinon, détecter la plateforme mobile/desktop
    if (Platform.isAndroid) {
      // Pour l'émulateur Android
      return 'http://10.0.2.2:8081/api';
    } else if (Platform.isIOS) {
      // Pour le simulateur iOS
      return 'http://localhost:8081/api';
    } else {
      // Pour un appareil physique (remplacer par votre IP)
      return 'http://192.168.1.100:8081/api';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Theme Provider
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),

        // Locale Provider
        ChangeNotifierProvider(
          create: (_) => LocaleProvider(),
        ),

        // Avatar Provider
        ChangeNotifierProvider(
          create: (_) => AvatarProvider(),
        ),

        // User Profile Provider
        ChangeNotifierProvider(
          create: (_) {
            final storageService = SecureStorageService();
            final profileProvider = UserProfileProvider();
            final profileService = ProfileService(
              baseUrl: profileBaseUrl,
              storageService: storageService,
            );
            profileProvider.initializeService(profileService);
            profileProvider.loadProfile();
            return profileProvider;
          },
        ),

        // Auth Provider
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            authService: AuthService(baseUrl: authBaseUrl),
            storageService: SecureStorageService(),
          ),
        ),

        // Chat Provider (votre provider existant)
        ChangeNotifierProvider(
          create: (_) => ChatProvider(
            ApiService(baseUrl: chatBaseUrl),
            VoiceService(),
          )..initializeVoice(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'WealthPath',
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,

            // Routes
            initialRoute: '/',
            routes: {
              '/': (context) => const SplashScreen(),
              '/login': (context) => const LoginPage(),
              '/register': (context) => const RegisterScreen(),
              '/onboarding': (context) => const OnboardingScreen(),
              '/profile': (context) => const AuthWrapper(child: ProfileScreen()),
              '/settings': (context) => const AuthWrapper(child: SettingsScreen()),
              '/home': (context) => const AuthWrapper(child: ChatScreen()),
              '/language': (context) => const AuthWrapper(child: LanguageScreen()),
              '/change-image': (context) => const AuthWrapper(child: ChangeImageScreen()),
              '/about': (context) => const AboutUsScreen(),
              '/faq': (context) => const FAQScreen(),
              '/help-feedback': (context) => const HelpFeedbackScreen(),
              '/support': (context) => const SupportUsScreen(),
            },
          );
        },
      ),
    );
  }
}

/// Widget wrapper pour protéger les routes authentifiées
class AuthWrapper extends StatelessWidget {
  final Widget child;

  const AuthWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        // Si non authentifié, rediriger vers login
        if (!authProvider.isAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed('/login');
          });
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Si authentifié, afficher l'écran
        return child;
      },
    );
  }
}