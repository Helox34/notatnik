import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/data_provider.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize Date Formatting
  await initializeDateFormatting('pl_PL', null);
  
  // Data is now stored using SharedPreferences (JSON)
  // TODO: Later migrate to Hive with proper type adapters
  
  runApp(const YellowNoteApp());
}

class YellowNoteApp extends StatelessWidget {
  const YellowNoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create:  (_) => AuthProvider()),
        ChangeNotifierProvider(create: (context) {
          final provider = DataProvider();
          provider.initialize(); // Load data from storage
          return provider;
        }),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'YellowNote',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
