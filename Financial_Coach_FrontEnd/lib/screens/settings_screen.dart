import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/user_profile_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 32,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Change username
              _buildSettingItem(
                context,
                title: 'Change username',
                description: 'Update your display name and how others see you',
                onTap: () => _showChangeUsernameDialog(context),
              ),
              _buildDivider(),

              // Change email
              _buildSettingItem(
                context,
                title: 'Change email',
                description: 'Update your email address for account notifications',
                onTap: () => _showChangeEmailDialog(context),
              ),
              _buildDivider(),

              // Change password
              _buildSettingItem(
                context,
                title: 'Change password',
                description: 'Update your password to keep your account secure',
                onTap: () => _showChangePasswordDialog(context),
              ),
              _buildDivider(),

              // Change language
              _buildSettingItem(
                context,
                title: 'Change language',
                description: 'Select your preferred language for the app',
                onTap: () => _showLanguageDialog(context),
              ),
              _buildDivider(),

              // Theme color
              _buildThemeSettingItem(context),
              _buildDivider(),

              const SizedBox(height: 20),

              // Delete account
              _buildSettingItem(
                context,
                title: 'Delete account',
                description: 'Permanently delete your account and all data',
                titleColor: const Color(0xFFFF0000),
                onTap: () => _showDeleteAccountDialog(context),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required String title,
    required String description,
    required VoidCallback onTap,
    Color? titleColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: titleColor ?? Colors.black,
                    fontSize: 19,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: titleColor ?? Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                color: Color(0xFFADADAD),
                fontSize: 12,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSettingItem(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final isDark = themeProvider.isDarkMode;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Theme color',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Switch(
                    value: isDark,
                    onChanged: (value) => themeProvider.toggleTheme(),
                    activeTrackColor: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                isDark
                    ? 'Dark mode is currently enabled'
                    : 'Light mode is currently enabled',
                style: const TextStyle(
                  color: Color(0xFFADADAD),
                  fontSize: 12,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: const Color(0xFFE6E6E6),
    );
  }

  void _showChangeUsernameDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    final profileProvider = context.read<UserProfileProvider>();

    controller.text = profileProvider.profile?.fullName ?? '';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Change Username'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'New username',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                await profileProvider.updatePersonalInfo(
                  fullName: controller.text,
                );
                if (ctx.mounted) {
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Username updated successfully')),
                  );
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showChangeEmailDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Change Email'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'New email',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement email change
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Email change feature coming soon')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final TextEditingController currentController = TextEditingController();
    final TextEditingController newController = TextEditingController();
    final TextEditingController confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentController,
              decoration: const InputDecoration(
                labelText: 'Current password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newController,
              decoration: const InputDecoration(
                labelText: 'New password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmController,
              decoration: const InputDecoration(
                labelText: 'Confirm new password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (newController.text == confirmController.text) {
                // TODO: Implement password change
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password change feature coming soon')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Passwords do not match')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final localeProvider = context.read<LocaleProvider>();
    final profileProvider = context.read<UserProfileProvider>();
    final currentLang = localeProvider.languageCode;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.language,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            const Text('Change Language'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption(ctx, 'Français', 'fr', currentLang, localeProvider, profileProvider),
            _buildLanguageOption(ctx, 'English', 'en', currentLang, localeProvider, profileProvider),
            _buildLanguageOption(ctx, 'Español', 'es', currentLang, localeProvider, profileProvider),
            _buildLanguageOption(ctx, 'العربية (Darija)', 'ar', currentLang, localeProvider, profileProvider),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext ctx,
    String label,
    String code,
    String currentLang,
    LocaleProvider localeProvider,
    UserProfileProvider profileProvider,
  ) {
    return RadioListTile<String>(
      title: Text(label),
      value: code,
      groupValue: currentLang,
      activeColor: Theme.of(ctx).colorScheme.primary,
      onChanged: (value) async {
        if (value != null) {
          // Update locale provider
          await localeProvider.setLocale(value);
          // Update profile preferences
          await profileProvider.updatePreferences(preferredLanguage: value);
          if (ctx.mounted) {
            Navigator.of(ctx).pop();
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(
                content: Text('Language changed to $label'),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        }
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Delete Account',
          style: TextStyle(color: Color(0xFFFF0000)),
        ),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF0000),
            ),
            onPressed: () async {
              final profileProvider = context.read<UserProfileProvider>();
              final authProvider = context.read<AuthProvider>();

              // Delete profile
              await profileProvider.deleteProfile();

              // Logout
              await authProvider.logout();

              if (ctx.mounted) {
                Navigator.of(ctx).pop();
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }
}
