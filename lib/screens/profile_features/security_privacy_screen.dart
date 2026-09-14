import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class SecurityPrivacyScreen extends StatelessWidget {
  const SecurityPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Security & privacy')),
    body: Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Container(
              padding: const EdgeInsets.all(26),
              decoration: BoxDecoration(
                color: AppTheme.lavender,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: const Color(0xFF333338),
                ),
              ),
              child: const Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'You are in control.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Review how your account and data are protected.',
                          style: TextStyle(color: AppTheme.muted, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppTheme.orange,
                    child: Icon(Icons.shield_outlined, color: AppTheme.ink),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _label('SECURITY'),
            Card(
              child: Column(
                children: [
                  _item(
                    Icons.lock_outline_rounded,
                    'Change password',
                    'Update your sign-in credentials',
                  ),
                  const Divider(height: 1, indent: 82, color: Color(0xFF333338)),
                  _item(
                    Icons.phonelink_lock_outlined,
                    'Two-factor authentication',
                    'Currently off',
                    badge: 'OFF',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            _label('PRIVACY'),
            Card(
              child: Column(
                children: [
                  _item(
                    Icons.tune_rounded,
                    'Data preferences',
                    'Choose how your data is used',
                  ),
                  const Divider(height: 1, indent: 82, color: Color(0xFF333338)),
                  _item(
                    Icons.description_outlined,
                    'Privacy policy',
                    'Read our current policy',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            _label('ACCOUNT'),
            Card(
              child: _item(
                Icons.delete_outline_rounded,
                'Delete account',
                'Permanently remove this account',
                destructive: true,
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(left: 6, bottom: 12),
    child: Text(
      text,
      style: const TextStyle(
        color: AppTheme.muted,
        fontSize: 11,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.5,
      ),
    ),
  );

  Widget _item(
    IconData icon,
    String title,
    String subtitle, {
    String? badge,
    bool destructive = false,
  }) {
    final color = destructive ? const Color(0xFFFF6B6B) : AppTheme.orange;
    return ListTile(
      onTap: () {},
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      leading: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: destructive
              ? const Color(0xFF2A1515)
              : AppTheme.orange.withValues(alpha: .12),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w800,
          color: destructive ? const Color(0xFFFF6B6B) : Colors.white,
        ),
      ),
      subtitle: Text(subtitle, style: const TextStyle(color: AppTheme.muted)),
      trailing: badge == null
          ? const Icon(Icons.chevron_right_rounded)
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2F),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                badge,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.muted,
                ),
              ),
            ),
    );
  }
}
