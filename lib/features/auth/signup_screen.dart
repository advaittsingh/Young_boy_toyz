import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';
import 'otp_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isOtpSignup = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signupWithOtp() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final otp = await AuthService().sendOtp(email, isSignup: true);
      if (otp != null) {
        setState(() => _isLoading = false);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OTPScreen(
              isSignup: true,
              email: email,
              emailOtp: otp,
              name: name,
            ),
          ),
        );
      } else {
        throw Exception('OTP sending failed');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _signupWithPassword() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final success = await AuthService().signupWithPassword(name, email, password);
    if (success) {
      setState(() => _isLoading = false);
      Navigator.pop(context); // back to login
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Sign-up failed';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              const Text(
                'Sign Up',
                style: TextStyle(fontSize: 32, color: Colors.white),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(Icons.person, color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(Icons.email, color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (!_isOtpSignup)
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.white),
                    prefixIcon: Icon(Icons.lock, color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : _isOtpSignup
                        ? _signupWithOtp
                        : _signupWithPassword,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(_isOtpSignup ? 'Sign Up with OTP' : 'Sign Up with Password'),
              ),
              TextButton(
                onPressed: () => setState(() {
                  _isOtpSignup = !_isOtpSignup;
                  _errorMessage = null;
                }),
                child: Text(
                  _isOtpSignup ? 'Use Password Instead' : 'Use OTP Instead',
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
