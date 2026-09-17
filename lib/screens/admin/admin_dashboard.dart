import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import '../../services/firestore_service.dart';
import 'manage_employees_screen.dart';
import 'manage_inventory_screen.dart';
import 'admin_reservations_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final admin = AuthService.instance.currentUserData.value;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.black,
        title: const Text('Dashboard Admin', style: TextStyle(color: AppColors.gold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.gold),
            onPressed: () => AuthService.instance.logout(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec les infos admin intégrées
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 25),
              decoration: BoxDecoration(
                color: AppColors.black,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: AppColors.gold,
                    child: Icon(Icons.person, color: AppColors.black),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(admin?.name ?? 'administrateur', 
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      Text(admin?.email ?? 'okadministrateuradmin@gmail.com', 
                          style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      Text(admin?.phone ?? '688109782', 
                          style: const TextStyle(color: AppColors.gold, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Aperçu du restaurant', style: Theme.of(context).textTheme.headlineSmall),
                IconButton(
                  icon: const Icon(Icons.refresh, color: AppColors.gold),
                  onPressed: () async {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Initialisation des données en cours...')));
                    await FirestoreService.instance.seedData();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Données initialisées !')));
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Cartes de statistiques rapides
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Réservations',
                    icon: Icons.calendar_today,
                    stream: FirestoreService.instance.getReservations(),
                    builder: (data) => Text('${data.length}', style: Theme.of(context).textTheme.displaySmall),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _StatCard(
                    title: 'Alertes Stock',
                    icon: Icons.inventory_2,
                    stream: FirestoreService.instance.getInventory(),
                    builder: (data) {
                      final lowStock = data.where((item) => item.isLowStock).length;
                      return Text('$lowStock', style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.red));
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 30),
            Text('Gestion', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 15),
            
            _MenuTile(
              title: 'Employés',
              subtitle: 'Gérer les rôles et le personnel',
              icon: Icons.people_outline,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ManageEmployeesScreen()));
              },
            ),
            const SizedBox(height: 12),
            _MenuTile(
              title: 'Stocks',
              subtitle: 'Inventaire et approvisionnement',
              icon: Icons.storage,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ManageInventoryScreen()));
              },
            ),
            const SizedBox(height: 12),
            _MenuTile(
              title: 'Réservations',
              subtitle: 'Voir toutes les tables réservées',
              icon: Icons.event_note,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AdminReservationsScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard<T> extends StatelessWidget {
  final String title;
  final IconData icon;
  final Stream<List<T>> stream;
  final Widget Function(List<T>) builder;

  const _StatCard({
    required this.title,
    required this.icon,
    required this.stream,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.gold, size: 24),
          const SizedBox(height: 10),
          Text(title, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 5),
          StreamBuilder<List<T>>(
            stream: stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Text('...');
              return builder(snapshot.data!);
            },
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _MenuTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppColors.black, borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: AppColors.gold),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.chevron_right),
      tileColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.gold.withValues(alpha: 0.1)),
      ),
    );
  }
}
