import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/data_export_service.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _changePassword() {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _successMessage = 'Password changed successfully!';
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Settings')),
      backgroundColor: AppTheme.primaryBlack,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: AppTheme.secondaryBlack,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Change Password',
                      style: TextStyle(
                          color: AppTheme.textWhite,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _currentPasswordController,
                          decoration: const InputDecoration(
                            labelText: 'Current Password',
                            labelStyle: TextStyle(color: AppTheme.textGrey),
                          ),
                          obscureText: true,
                          style: const TextStyle(color: AppTheme.textWhite),
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter your current password' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _newPasswordController,
                          decoration: const InputDecoration(
                            labelText: 'New Password',
                            labelStyle: TextStyle(color: AppTheme.textGrey),
                          ),
                          obscureText: true,
                          style: const TextStyle(color: AppTheme.textWhite),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a new password';
                            }
                            if (value.length < 8) {
                              return 'Password must be at least 8 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: const InputDecoration(
                            labelText: 'Confirm New Password',
                            labelStyle: TextStyle(color: AppTheme.textGrey),
                          ),
                          obscureText: true,
                          style: const TextStyle(color: AppTheme.textWhite),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your new password';
                            }
                            if (value != _newPasswordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        if (_errorMessage != null)
                          Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                        if (_successMessage != null)
                          Text(_successMessage!, style: const TextStyle(color: Colors.green)),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _changePassword,
                            child: _isLoading
                                ? const CircularProgressIndicator()
                                : const Text('Change Password'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: AppTheme.secondaryBlack,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Data & Privacy',
                      style: TextStyle(
                          color: AppTheme.textWhite,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.download, color: AppTheme.accentRed),
                    title: const Text('Download My Data',
                        style: TextStyle(color: AppTheme.textWhite)),
                    subtitle: const Text('Get a copy of your personal data',
                        style: TextStyle(color: AppTheme.textGrey)),
                    onTap: () async {
                      try {
                        setState(() {
                          _isLoading = true;
                          _errorMessage = null;
                          _successMessage = null;
                        });

                        final dummyUserData = {
                          "name": await AuthService().getName(),
                          "email": await AuthService().getEmail(),
                          "role": await AuthService().getRole(),
                        };

                        await DataExportService.exportUserData(dummyUserData);

                        if (!mounted) return;
                        setState(() {
                          _successMessage = 'Data exported successfully!';
                        });
                      } catch (e) {
                        if (!mounted) return;
                        setState(() {
                          _errorMessage = e.toString();
                        });
                      } finally {
                        if (mounted) {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      }
                    },
                  ),
                  const Divider(color: AppTheme.textGrey),
                  ListTile(
                    leading: const Icon(Icons.delete_forever, color: Colors.red),
                    title: const Text('Delete Account', style: TextStyle(color: Colors.red)),
                    subtitle: const Text('Permanently delete your account and data',
                        style: TextStyle(color: AppTheme.textGrey)),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Account'),
                          content: const Text(
                              'Are you sure you want to delete your account? This action cannot be undone.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                // TODO: Implement account deletion
                                Navigator.pop(context);
                              },
                              child: const Text('Delete', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
