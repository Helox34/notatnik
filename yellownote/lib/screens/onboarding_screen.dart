import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/sync_status_card.dart';
import '../widgets/app_drawer.dart';
import 'projects/projects_screen.dart';
import 'diary/diary_screen.dart';
import 'lists/lists_screen.dart';
import 'notes/notes_screen.dart';
import 'reminders/reminders_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (context) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return IconButton(
              icon: Icon(
                Icons.menu,
                color: isDark ? Colors.white : AppColors.darkNavy,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
      ),
      drawer: const AppDrawer(currentRoute: 'home'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const Text(
                    'Cześć! ',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '👋',
                    style: TextStyle(fontSize: 28),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Co chcesz dzisiaj zorganizować?',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.darkGray,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Pill-shaped Category Buttons (vertical list)
              Expanded(
                child: Column(
                  children: [
                    _PillButton(
                      icon: Icons.folder_rounded,
                      title: 'Projekty',
                      subtitle: 'Organizuj swoje projekty',
                      color: AppColors.projectsBg,
                      iconColor: AppColors.yellowDark,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ProjectsScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _PillButton(
                      icon: Icons.book_rounded,
                      title: 'Dziennik',
                      subtitle: 'Zapisuj swoje myśli',
                      color: AppColors.diaryBg,
                      iconColor: const Color(0xFF9C27B0),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const DiaryScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _PillButton(
                      icon: Icons.checklist_rounded,
                      title: 'Listy',
                      subtitle: 'Twórz checklisty',
                      color: AppColors.listsBg,
                      iconColor: const Color(0xFF4CAF50),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ListsScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _PillButton(
                      icon: Icons.note_rounded,
                      title: 'Notatnik',
                      subtitle: 'Rób szybkie notatki',
                      color: AppColors.notesBg,
                      iconColor: const Color(0xFF2196F3),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const NotesScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _PillButton(
                      icon: Icons.notifications_active_rounded,
                      title: 'Przypomnienia',
                      subtitle: 'Zarządzaj przypomnieniami',
                      color: const Color(0xFFFFF3E0),
                      iconColor: const Color(0xFFFF9800),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const RemindersScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Sync Status Card
              const SyncStatusCard(),
              
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;

  const _PillButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2A2D3A) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon with colored background
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              // Title and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ],
                ),
              ),
              // Arrow icon
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.mediumGray,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
