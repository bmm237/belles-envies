import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';
import '../models/app_user.dart';
import '../widgets/account_required_view.dart';
import 'settings_screen.dart';
import 'admin/admin_dashboard.dart';
import 'cook/cook_dashboard.dart';
import 'cashier/cashier_dashboard.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        centerTitle: true,
        title: Text('Mon profil', style: AppTheme.appBarTitle),
      ),
      body: ValueListenableBuilder<AppUser?>(
        valueListenable: AuthService.instance.currentUserData,
        builder: (context, user, _) {
          if (user == null) {
            return const AccountRequiredView(
              message: 'Connectez-vous ou créez un compte pour accéder à votre profil',
            );
          }

          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(color: AppColors.black, shape: BoxShape.circle),
                      child: const Icon(Icons.person, color: AppColors.gold, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.name, style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 3),
                          Text(user.email, style: Theme.of(context).textTheme.bodyMedium),
                          if (user.role != UserRole.client)
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.gold.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                user.role.name.toUpperCase(),
                                style: const TextStyle(color: AppColors.gold, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                
                // Section réservée au personnel
                if (user.role != UserRole.client) ...[
                  _ProfileTile(
                    icon: Icons.dashboard_outlined,
                    title: 'Tableau de bord ${user.role.name}',
                    subtitle: 'Accéder aux outils de gestion',
                    onTap: () {
                      Widget dashboard;
                      switch (user.role) {
                        case UserRole.admin:
                          dashboard = const AdminDashboard();
                          break;
                        case UserRole.cook:
                          dashboard = const CookDashboard();
                          break;
                        case UserRole.cashier:
                          dashboard = const CashierDashboard();
                          break;
                        default:
                          return;
                      }
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => dashboard));
                    },
                  ),
                  const SizedBox(height: 12),
                ],

                _ProfileTile(
                  icon: Icons.settings_outlined,
                  title: 'Paramètres',
                  subtitle: 'Compte, notifications, langue, sécurité...',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  ),
                ),
                const SizedBox(height: 12),
                _ProfileTile(
                  icon: Icons.favorite_border,
                  title: 'Mes plats favoris',
                  subtitle: 'Retrouvez vos plats préférés',
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Écran des favoris à venir')),
                  ),
                ),
                const SizedBox(height: 28),
                Center(
                  child: TextButton.icon(
                    onPressed: () => AuthService.instance.logout(),
                    icon: const Icon(Icons.logout, color: AppColors.inkSoft),
                    label: const Text('Se déconnecter', style: TextStyle(color: AppColors.inkSoft)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.gold.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: AppColors.black, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: AppColors.gold),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 3),
                  Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.inkSoft),
          ],
        ),
      ),
    );
  }
}
