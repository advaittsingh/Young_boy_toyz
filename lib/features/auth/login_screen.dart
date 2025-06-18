import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';
import 'signup_screen.dart';
import 'otp_screen.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _adminEmailController = TextEditingController();
  final _adminPasswordController = TextEditingController();
  final _userEmailController = TextEditingController();
  final _userNumberController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _adminEmailController.dispose();
    _adminPasswordController.dispose();
    _userEmailController.dispose();
    _userNumberController.dispose();
    super.dispose();
  }

  void _loginSuperAdmin() {
    if (_adminEmailController.text.isEmpty || _adminPasswordController.text.isEmpty) {
      setState(() { _errorMessage = 'Please fill in all fields.'; });
      return;
    }

    setState(() { _isLoading = true; _errorMessage = null; });
    final success = AuthService().loginSuperAdmin(
      _adminEmailController.text.trim(),
      _adminPasswordController.text.trim(),
    );
    setState(() { _isLoading = false; });
    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      setState(() { _errorMessage = 'Invalid super admin credentials.'; });
    }
  }

  void _loginUser() {
    if (_userEmailController.text.isEmpty || _userNumberController.text.isEmpty) {
      setState(() { _errorMessage = 'Please fill in all fields.'; });
      return;
    }

    setState(() { _isLoading = true; _errorMessage = null; });
    final otp = AuthService().loginUser(
      _userEmailController.text.trim(),
      _userNumberController.text.trim(),
    );
    setState(() { _isLoading = false; });
    if (otp != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OTPScreen(
            isLogin: true,
            email: _userEmailController.text.trim(),
            number: _userNumberController.text.trim(),
          ),
        ),
      );
    } else {
      setState(() { _errorMessage = 'User not found. Please sign up.'; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              'Welcome Back',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Super Admin'),
                Tab(text: 'User'),
              ],
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Theme.of(context).primaryColor,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Super Admin Login
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: _adminEmailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _adminPasswordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _loginSuperAdmin,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: _isLoading 
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Login'),
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
                  // User Login
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: _userEmailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _userNumberController,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _loginUser,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Send OTP'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const SignupScreen()),
                            );
                          },
                          child: const Text('Don\'t have an account? Sign up'),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 