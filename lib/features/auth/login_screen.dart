import 'package:flutter/material.dart';
import '../../features/auth/otp_screen.dart';
import '../../theme/app_theme.dart';
import '../../core/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isOtpMode = false;
  bool isLoading = false;
  String? error;

  void toggleLoginMode() {
    setState(() {
      isOtpMode = !isOtpMode;
      error = null;
    });
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      error = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      if (isOtpMode) {
        final otpResult = await AuthService().sendOtpForLogin(email);
        if (otpResult != null) {
          if (!mounted) return;
          Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => OTPScreen(
      isLogin: true,
      email: email,
    ),
  ),
);

        } else {
          setState(() => error = 'Failed to send OTP.');
        }
      } else {
        final success = await AuthService().loginWithPassword(
          email: email,
          password: password,
        );
        if (success) {
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          setState(() => error = 'Invalid email or password.');
        }
      }
    } catch (e) {
      setState(() => error = 'Something went wrong: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _emailController,
                style: const TextStyle(color: AppTheme.textWhite),
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: AppTheme.textGrey),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter email' : null,
              ),
              if (!isOtpMode) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  style: const TextStyle(color: AppTheme.textWhite),
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: AppTheme.textGrey),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter password' : null,
                ),
              ],
              const SizedBox(height: 24),
              if (error != null)
                Text(
                  error!,
                  style: const TextStyle(color: Colors.red),
                ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _handleLogin,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : Text(isOtpMode ? 'Send OTP' : 'Login'),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: toggleLoginMode,
                child: Text(
                  isOtpMode
                      ? 'Login with Password'
                      : 'Login with OTP instead',
                  style: const TextStyle(color: AppTheme.accentRed),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/signup'),
                child: const Text(
                  "Don't have an account? Sign up",
                  style: TextStyle(color: AppTheme.textGrey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
