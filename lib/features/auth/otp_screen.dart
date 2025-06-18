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
    this.emailOtp,
    this.numberOtp,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _emailOtpController = TextEditingController();
  final _numberOtpController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  String? _validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the OTP';
    }
    if (value.length != 6) {
      return 'OTP must be 6 digits';
    }
    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return 'OTP must contain only digits';
    }
    return null;
  }

  void _verifyOtp() {
    if (_emailOtpController.text.isEmpty || _numberOtpController.text.isEmpty) {
      setState(() { _errorMessage = 'Please enter both OTPs'; });
      return;
    }

    setState(() { _isLoading = true; _errorMessage = null; });
    bool success;
    if (widget.isLogin) {
      success = AuthService().verifyLoginOtp(
        _emailOtpController.text.trim(),
        _numberOtpController.text.trim(),
      );
    } else {
      success = AuthService().verifyUserOtp(
        _emailOtpController.text.trim(),
        _numberOtpController.text.trim(),
      );
    }
    setState(() { _isLoading = false; });
    if (success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } else {
      setState(() { _errorMessage = 'Invalid OTP(s). Please try again.'; });
    }
  }

  @override
  void dispose() {
    _emailOtpController.dispose();
    _numberOtpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              const Text(
                'OTP Verification',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Text(
                'Enter the OTPs sent to:',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                widget.email,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                widget.number,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              if (widget.emailOtp != null && widget.numberOtp != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Demo OTPs (for testing)',
                        style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Email OTP: ${widget.emailOtp}',
                        style: TextStyle(color: Colors.green[700]),
                      ),
                      Text(
                        'Number OTP: ${widget.numberOtp}',
                        style: TextStyle(color: Colors.green[700]),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _emailOtpController,
                decoration: const InputDecoration(
                  labelText: 'Email OTP',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.number,
                maxLength: 6,
                validator: _validateOtp,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _numberOtpController,
                decoration: const InputDecoration(
                  labelText: 'Number OTP',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.number,
                maxLength: 6,
                validator: _validateOtp,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _verifyOtp,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Verify'),
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
      ),
    );
  }
} 