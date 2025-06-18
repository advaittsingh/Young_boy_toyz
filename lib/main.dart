import 'package:flutter/material.dart';
import 'package:young_boy_toyz/features/splash/splash_screen.dart';
import 'package:young_boy_toyz/theme/app_theme.dart';
import 'core/services/auth_service.dart';
import 'features/auth/login_screen.dart';
import 'features/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await AuthService().initialize();
  } catch (e) {
    print('Error initializing AuthService: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Young Boy Toyz',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
