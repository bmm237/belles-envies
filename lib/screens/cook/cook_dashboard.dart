import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/firestore_service.dart';
import 'manage_menu_screen.dart';

class CookDashboard extends StatelessWidget {
  const CookDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.black,
        title: const Text('Cuisine', style: TextStyle(color: AppColors.gold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Gestion de la cuisine', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 20),
            
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  _CookActionCard(
                    title: 'Le Menu',
                    icon: Icons.restaurant_menu,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => ManageMenuScreen()));
                    },
                  ),
                  _CookActionCard(
                    title: 'Commandes',
                    icon: Icons.receipt_long,
                    onTap: () {
                      // TODO: Naviguer vers les commandes en cuisine
                    },
                  ),
                  _CookActionCard(
                    title: 'Stocks Bas',
                    icon: Icons.warning_amber_rounded,
                    onTap: () {
                      // TODO: Voir les alertes stock
                    },
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

class _CookActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _CookActionCard({required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.gold.withValues(alpha: 0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.gold, size: 40),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
