import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_colors.dart';
import 'login_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_of_service_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ustawienia'),
      ),
      body: ListView(
        children: [
          // Appearance Section
          _SectionHeader(title: 'Wygląd'),
          _SettingsTile(
            title: 'Dostosuj kolorystykę aplikacji do swoich preferencji.',
            child: Consumer<ThemeProvider>(
              builder: (context, themeProvider, _) {
                return Row(
                  children: [
                    Expanded(
                      child: _ThemeButton(
                        icon: Icons.wb_sunny,
                        label: 'Jasny',
                        isSelected: !themeProvider.isDarkMode,
                        onTap: () => themeProvider.setDarkMode(false),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ThemeButton(
                        icon: Icons.nightlight_round,
                        label: 'Ciemny',
                        isSelected: themeProvider.isDarkMode,
                        onTap: () => themeProvider.setDarkMode(true),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // Synchronization Section
          _SectionHeader(title: 'Synchronizacja'),
          _SettingsTile(
            title:
                'Zaloguj się na tym samym koncie na komputerze i telefonie, aby mieć dostęp do tych samych danych.',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Icon(Icons.phone_android, size: 40, color: AppColors.mediumGray),
                    const SizedBox(height: 4),
                    const Text('Telefon', style: TextStyle(fontSize: 12)),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.computer, size: 40, color: AppColors.mediumGray),
                    const SizedBox(height: 4),
                    const Text('Komputer', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: ElevatedButton(
              onPressed: () {
                // TODO: Sync devices
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Funkcja synchronizacji trwająca implementacja...'),
                    backgroundColor: AppColors.yellow,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Połącz urządzenia'),
            ),
          ),

          const SizedBox(height: 24),

          // Legal Section
          _SectionHeader(title: 'Prawne'),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined, color: AppColors.darkNavy),
            title: const Text('Polityka prywatności'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const PrivacyPolicyScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined, color: AppColors.darkNavy),
            title: const Text('Regulamin'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const TermsOfServiceScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // Account Section
          _SectionHeader(title: 'Konto'),
          Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              return ListTile(
                leading: const Icon(Icons.logout, color: AppColors.error),
                title: const Text(
                  'Wyloguj się',
                  style: TextStyle(color: AppColors.error),
                ),
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Wylogować się?'),
                      content: const Text(
                        'Czy na pewno chcesz się wylogować? Twoje dane pozostaną zapisane lokalnie.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Anuluj'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Wyloguj'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true && context.mounted) {
                    await authProvider.signOut();
                    if (context.mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    }
                  }
                },
              );
            },
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final Widget child;

  const _SettingsTile({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.darkGray,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _ThemeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppColors.yellow : AppColors.lightGray,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.darkNavy : AppColors.darkGray,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppColors.darkNavy : AppColors.darkGray,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
