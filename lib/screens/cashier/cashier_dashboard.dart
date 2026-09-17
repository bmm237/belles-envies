import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';

class CashierDashboard extends StatelessWidget {
  const CashierDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.black,
        title: const Text('Caisse', style: TextStyle(color: AppColors.gold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.gold),
            onPressed: () => AuthService.instance.logout(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Point de Vente', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 20),
          
          _CashierTile(
            title: 'Nouvelle Commande',
            icon: Icons.add_shopping_cart,
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _CashierTile(
            title: 'Réservations du jour',
            icon: Icons.today,
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _CashierTile(
            title: 'Historique des ventes',
            icon: Icons.history,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _CashierTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _CashierTile({required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppColors.gold),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      tileColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.gold.withValues(alpha: 0.1)),
      ),
    );
  }
}
