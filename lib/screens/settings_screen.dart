import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _emailUpdates = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        centerTitle: true,
        title: Text('Paramètres', style: AppTheme.appBarTitle),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _SectionLabel('Compte'),
            _SettingsTile(
              icon: Icons.person_outline,
              title: 'Modifier mes informations',
              onTap: () => _comingSoon(context, 'Modifier mes informations'),
            ),
            _SettingsTile(
              icon: Icons.lock_outline,
              title: 'Changer mon mot de passe',
              onTap: () => _comingSoon(context, 'Changer le mot de passe'),
            ),
            const SizedBox(height: 24),
            _SectionLabel('Notifications'),
            _SettingsSwitchTile(
              icon: Icons.notifications_outlined,
              title: 'Notifications push',
              subtitle: 'Statut de commande et réservation en temps réel',
              value: _notifications,
              onChanged: (v) => setState(() => _notifications = v),
            ),
            _SettingsSwitchTile(
              icon: Icons.mail_outline,
              title: 'Offres par email',
              subtitle: 'Promotions et nouveautés du menu',
              value: _emailUpdates,
              onChanged: (v) => setState(() => _emailUpdates = v),
            ),
            const SizedBox(height: 24),
            _SectionLabel('Général'),
            _SettingsTile(
              icon: Icons.language_outlined,
              title: 'Langue',
              trailing: 'Français',
              onTap: () => _comingSoon(context, 'Langue'),
            ),
            _SettingsTile(
              icon: Icons.help_outline,
              title: 'Aide et support',
              onTap: () => _comingSoon(context, 'Aide et support'),
            ),
            _SettingsTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Confidentialité',
              onTap: () => _comingSoon(context, 'Confidentialité'),
            ),
            _SettingsTile(
              icon: Icons.info_outline,
              title: 'À propos de Belle Envie',
              onTap: () => _comingSoon(context, 'À propos'),
            ),
            const SizedBox(height: 24),
            _SettingsTile(
              icon: Icons.delete_outline,
              title: 'Supprimer mon compte',
              titleColor: Colors.red.shade700,
              onTap: () => _comingSoon(context, 'Suppression de compte'),
            ),
            _SettingsTile(
              icon: Icons.logout,
              title: 'Se déconnecter',
              onTap: () {
                AuthService.instance.logout();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _comingSoon(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label — écran à venir')),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.inkSoft,
            ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailing;
  final Color? titleColor;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailing,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: titleColor ?? AppColors.black),
      title: Text(title, style: TextStyle(color: titleColor, fontWeight: FontWeight.w600)),
      trailing: trailing != null
          ? Text(trailing!, style: const TextStyle(color: AppColors.inkSoft))
          : const Icon(Icons.chevron_right, color: AppColors.inkSoft),
      onTap: onTap,
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      secondary: Icon(icon, color: AppColors.black),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
      value: value,
      activeColor: AppColors.gold,
      onChanged: onChanged,
    );
  }
}
