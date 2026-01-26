import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_colors.dart';
import '../screens/settings_screen.dart';
import '../screens/login_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/projects/projects_screen.dart';
import '../screens/diary/diary_screen.dart';
import '../screens/lists/lists_screen.dart';
import '../screens/notes/notes_screen.dart';
import '../screens/reminders/reminders_screen.dart';

class AppDrawer extends StatelessWidget {
  final String? currentRoute;
  
  const AppDrawer({super.key, this.currentRoute});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Drawer(
      backgroundColor: AppColors.yellow,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Menu',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkNavy,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.darkNavy),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Menu Items
            _DrawerItem(
              icon: Icons.home,
              title: 'Pulpit',
              isSelected: currentRoute == 'home' || currentRoute == null,
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                  (route) => false,
                );
              },
            ),
            _DrawerItem(
              icon: Icons.folder,
              title: 'Projekty',
              isSelected: currentRoute == 'projects',
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ProjectsScreen()),
                );
              },
            ),
            _DrawerItem(
              icon: Icons.book,
              title: 'Dziennik',
              isSelected: currentRoute == 'diary',
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const DiaryScreen()),
                );
              },
            ),
            _DrawerItem(
              icon: Icons.list,
              title: 'Listy',
              isSelected: currentRoute == 'lists',
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ListsScreen()),
                );
              },
            ),
            _DrawerItem(
              icon: Icons.note,
              title: 'Notatnik',
              isSelected: currentRoute == 'notes',
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const NotesScreen()),
                );
              },
            ),
            _DrawerItem(
              icon: Icons.notification_important,
              title: 'Przypomnienia',
              isSelected: currentRoute == 'reminders',
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const RemindersScreen()),
                );
              },
            ),

            const Spacer(),

            // Settings
            _DrawerItem(
              icon: Icons.settings,
              title: 'Ustawienia',
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.title,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: AppColors.darkNavy,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: AppColors.darkNavy,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
