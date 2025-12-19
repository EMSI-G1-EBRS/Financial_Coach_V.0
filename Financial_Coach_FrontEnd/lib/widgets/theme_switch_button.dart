import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class ThemeSwitchButton extends StatelessWidget {
  final bool isIconOnly;
  final double iconSize;

  const ThemeSwitchButton({
    super.key,
    this.isIconOnly = false,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDark = themeProvider.isDarkMode;

        if (isIconOnly) {
          return IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              size: iconSize,
            ),
            tooltip: isDark ? 'Thème clair' : 'Thème sombre',
            onPressed: () => themeProvider.toggleTheme(),
          );
        }

        return ElevatedButton.icon(
          onPressed: () => themeProvider.toggleTheme(),
          icon: Icon(
            isDark ? Icons.light_mode : Icons.dark_mode,
            size: iconSize,
          ),
          label: Text(isDark ? 'Thème clair' : 'Thème sombre'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        );
      },
    );
  }
}

// Widget alternatif avec animation de switch
class AnimatedThemeSwitch extends StatelessWidget {
  const AnimatedThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDark = themeProvider.isDarkMode;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.light_mode,
              size: 20,
              color: !isDark
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
            const SizedBox(width: 8),
            Switch(
              value: isDark,
              onChanged: (value) => themeProvider.toggleTheme(),
              activeTrackColor: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.dark_mode,
              size: 20,
              color: isDark
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
          ],
        );
      },
    );
  }
}

// Widget de carte de paramètres de thème
class ThemeSettingTile extends StatelessWidget {
  const ThemeSettingTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDark = themeProvider.isDarkMode;

        return Card(
          child: ListTile(
            leading: Icon(
              isDark ? Icons.dark_mode : Icons.light_mode,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('Thème de l\'application'),
            subtitle: Text(isDark ? 'Mode sombre' : 'Mode clair'),
            trailing: Switch(
              value: isDark,
              onChanged: (value) => themeProvider.toggleTheme(),
              activeTrackColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        );
      },
    );
  }
}
