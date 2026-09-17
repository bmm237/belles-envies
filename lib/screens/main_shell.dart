import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'reservation_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatefulWidget {
  /// Onglet affiché au démarrage (0 = Menu). Utile pour atterrir directement
  /// sur l'onglet Profil juste après une connexion ou une inscription.
  final int initialIndex;

  const MainShell({super.key, this.initialIndex = 0});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _currentIndex = widget.initialIndex;

  void _goToTab(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(onRequireAccount: () => _goToTab(3)),
      const ReservationScreen(),
      const OrdersScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(index: _currentIndex, children: screens),
          // Indicateur de rôle temporaire pour le debug
          Positioned(
            bottom: 80,
            left: 20,
            child: ValueListenableBuilder(
              valueListenable: AuthService.instance.currentUserData,
              builder: (context, user, _) {
                if (user == null) return const SizedBox.shrink();
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.8), borderRadius: BorderRadius.circular(4)),
                  child: Text('DEBUG: Connecté en tant que ${user.role.name}', style: const TextStyle(color: Colors.white, fontSize: 10)),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _goToTab,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.black,
        selectedItemColor: AppColors.gold,
        unselectedItemColor: Colors.white54,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Menu'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: 'Réserver'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: 'Commandes'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profil'),
        ],
      ),
    );
  }
}
