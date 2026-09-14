import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends State<NotificationsSettingsScreen> {
  bool _orderUpdates = true;
  bool _promotions = false;
  bool _newRestaurants = true;
  bool _emailNewsletter = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Notifications')),
    body: Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _header(),
            const SizedBox(height: 32),
            _section('PUSH NOTIFICATIONS', [
              _toggle(
                'Order updates',
                'Follow your meal from kitchen to door.',
                Icons.delivery_dining_rounded,
                _orderUpdates,
                (v) => setState(() => _orderUpdates = v),
              ),
              _toggle(
                'Drops & offers',
                'Hear about limited menus and discounts.',
                Icons.local_offer_outlined,
                _promotions,
                (v) => setState(() => _promotions = v),
              ),
              _toggle(
                'New kitchens',
                'Meet new local spots as they arrive.',
                Icons.storefront_outlined,
                _newRestaurants,
                (v) => setState(() => _newRestaurants = v),
              ),
            ]),
            const SizedBox(height: 26),
            _section('IN YOUR INBOX', [
              _toggle(
                'The weekly bite',
                'A short edit of dishes worth trying.',
                Icons.mark_email_unread_outlined,
                _emailNewsletter,
                (v) => setState(() => _emailNewsletter = v),
              ),
            ]),
          ],
        ),
      ),
    ),
  );

  Widget _header() => Container(
    padding: const EdgeInsets.all(26),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF2A1F00), Color(0xFF1A1A1E)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: AppTheme.orange.withValues(alpha: .15)),
    ),
    child: const Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Stay in the loop.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Choose the updates that deserve your attention.',
                style: TextStyle(color: Colors.white70, height: 1.5),
              ),
            ],
          ),
        ),
        SizedBox(width: 16),
        CircleAvatar(
          radius: 30,
          backgroundColor: AppTheme.orange,
          child: Icon(Icons.notifications_active_outlined, color: AppTheme.ink),
        ),
      ],
    ),
  );

  Widget _section(String title, List<Widget> children) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 6, bottom: 12),
        child: Text(
          title,
          style: const TextStyle(
            color: AppTheme.muted,
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      ),
      Card(child: Column(children: children)),
    ],
  );

  Widget _toggle(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) => SwitchListTile(
    value: value,
    onChanged: onChanged,
    activeThumbColor: AppTheme.ink,
    activeTrackColor: AppTheme.orange,
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
    secondary: Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: AppTheme.orange.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(icon, color: AppTheme.orange),
    ),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
    subtitle: Text(subtitle, style: const TextStyle(color: AppTheme.muted)),
  );
}
