import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../faq/faq_screen.dart';
import 'chatbot_screen.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      backgroundColor: AppTheme.primaryBlack,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Contact Information Card
          Card(
            color: AppTheme.secondaryBlack,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contact Us',
                    style: TextStyle(
                      color: AppTheme.textWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildContactItem(
                    icon: Icons.email,
                    title: 'Email',
                    subtitle: 'Nidhisingh@youngboyztoyz.com',
                    onTap: () {
                      // TODO: Implement email launch
                    },
                  ),
                  const Divider(color: AppTheme.textGrey),
                  _buildContactItem(
                    icon: Icons.phone,
                    title: 'Phone',
                    subtitle: '+91 9619007705',
                    onTap: () {
                      // TODO: Implement phone call
                    },
                  ),
                  const Divider(color: AppTheme.textGrey),
                  _buildContactItem(
                    icon: Icons.location_on,
                    title: 'Address',
                    subtitle: 'Plot no C-433, T.T.C, M.I.D.C, near Indira Nagar, opp. BASF, Turbhe, Navi Mumbai, Maharashtra 400705',
                    onTap: () {
                      // TODO: Implement map launch
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Support Options Card
          Card(
            color: AppTheme.secondaryBlack,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Support Options',
                    style: TextStyle(
                      color: AppTheme.textWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSupportOption(
                    icon: Icons.chat,
                    title: 'Live Chat',
                    subtitle: 'Chat with our support team',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ChatbotScreen()),
                      );
                    },
                  ),
                  const Divider(color: AppTheme.textGrey),
                  _buildSupportOption(
                    icon: Icons.question_answer,
                    title: 'FAQ',
                    subtitle: 'Frequently asked questions',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const FAQScreen()),
                      );
                    },
                  ),
                  const Divider(color: AppTheme.textGrey),
                  _buildSupportOption(
                    icon: Icons.help_outline,
                    title: 'Report an Issue',
                    subtitle: 'Report bugs or technical issues',
                    onTap: () {
                      // TODO: Implement issue reporting
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

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.accentRed),
      title: Text(title, style: const TextStyle(color: AppTheme.textWhite)),
      subtitle: Text(subtitle, style: const TextStyle(color: AppTheme.textGrey)),
      onTap: onTap,
    );
  }

  Widget _buildSupportOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.accentRed),
      title: Text(title, style: const TextStyle(color: AppTheme.textWhite)),
      subtitle: Text(subtitle, style: const TextStyle(color: AppTheme.textGrey)),
      trailing: const Icon(Icons.chevron_right, color: AppTheme.textGrey),
      onTap: onTap,
    );
  }
} 