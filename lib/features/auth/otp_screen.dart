import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';
import '../../theme/app_theme.dart';

class OTPScreen extends StatefulWidget {
  final bool isLogin;
  final String email;

  const OTPScreen({
    super.key,
    required this.isLogin,
    required this.email,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _otpController = TextEditingController();
  bool isLoading = false;
  String? error;

  Future<void> _verifyOtp() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    final otp = _otpController.text.trim();

    try {
      bool success;
      if (widget.isLogin) {
        success = await AuthService().verifyLoginOtp(
          email: widget.email,
          otp: otp,
        );
      } else {
        success = await AuthService().verifySignupOtp(
          email: widget.email,
          otp: otp,
        );
      }

      if (success) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() => error = 'Invalid OTP');
      }
    } catch (e) {
      setState(() => error = 'Error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _otpController,
              style: const TextStyle(color: AppTheme.textWhite),
              decoration: const InputDecoration(
                labelText: 'Enter OTP',
                labelStyle: TextStyle(color: AppTheme.textGrey),
              ),
            ),
            const SizedBox(height: 24),
            if (error != null)
              Text(error!, style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: isLoading ? null : _verifyOtp,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}
