import 'package:flutter/material.dart';
import 'features/home/home_screen.dart'; // Change this to your actual home screen
import 'features/auth/login_screen.dart';
import 'core/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authService = AuthService();
  final isLoggedIn = await authService.isLoggedIn();

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Your App',
      theme: ThemeData.dark(), // or your custom AppTheme
      home: isLoggedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}
