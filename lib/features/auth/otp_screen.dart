import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';
import '../home/home_screen.dart';

class OTPScreen extends StatefulWidget {
  final bool isLogin;
  final String email;
  final String number;
  final String? emailOtp;
  final String? numberOtp;

  const OTPScreen({
    super.key,
    required this.isLogin,
    required this.email,
    required this.number,
    required this.emailOtp,
    required this.numberOtp,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _emailOtpController = TextEditingController();
  final _numberOtpController = TextEditingController();
  String? _errorMessage;
  bool _isVerifying = false;

  @override
  void dispose() {
    _emailOtpController.dispose();
    _numberOtpController.dispose();
    super.dispose();
  }

  void _verifyOtp() {
    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    final enteredEmailOtp = _emailOtpController.text.trim();
    final enteredNumberOtp = _numberOtpController.text.trim();

    bool isVerified = widget.isLogin
        ? AuthService().verifyLoginOtp(enteredEmailOtp, enteredNumberOtp)
        : AuthService().verifyUserOtp(enteredEmailOtp, enteredNumberOtp);

    setState(() => _isVerifying = false);

    if (isVerified) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } else {
      setState(() {
        _errorMessage = 'Invalid OTPs. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.isLogin ? 'Verify Login OTP' : 'Verify Signup OTP'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Enter OTP sent to your Email and Phone',
              style: TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _emailOtpController,
              decoration: InputDecoration(
                labelText: 'Email OTP',
                prefixIcon: const Icon(Icons.email),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _numberOtpController,
              decoration: InputDecoration(
                labelText: 'Phone OTP',
                prefixIcon: const Icon(Icons.phone),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isVerifying ? null : _verifyOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: _isVerifying
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text('Verify OTP'),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
