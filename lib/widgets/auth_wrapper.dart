import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../screens/main_shell.dart';
import '../screens/welcome_screen.dart';
import '../screens/admin/admin_dashboard.dart';
import '../screens/cook/cook_dashboard.dart';
import '../screens/cashier/cashier_dashboard.dart';
import '../models/app_user.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AuthService.instance.isLoading,
      builder: (context, isLoading, _) {
        final user = AuthService.instance.currentUser;

        if (isLoading) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Color(0xFFD4AF37)),
                  const SizedBox(height: 20),
                  Text('Belle Envie', style: Theme.of(context).textTheme.headlineSmall),
                  if (user != null) ...[
                    const SizedBox(height: 10),
                    Text('UID: ${user.uid}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                    const Text('Attente des données Firestore...', style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ],
              ),
            ),
          );
        }

        return ValueListenableBuilder<AppUser?>(
          valueListenable: AuthService.instance.currentUserData,
          builder: (context, userData, _) {
            return ValueListenableBuilder<bool>(
              valueListenable: AuthService.instance.isGuestMode,
              builder: (context, isGuest, _) {
                final isLoggedIn = AuthService.instance.isLoggedIn.value;

                // 1. Si connecté mais profil introuvable après chargement
                if (isLoggedIn && userData == null) {
                  return Scaffold(
                    body: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 60),
                            const SizedBox(height: 20),
                            const Text('Compte connecté, mais profil introuvable', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            Text('Votre UID : ${user?.uid}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            const SizedBox(height: 30),
                            const Text('Vérifiez que ce UID existe dans la collection "users" de votre console Firebase.', textAlign: TextAlign.center),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () => AuthService.instance.logout(),
                              child: const Text('Se déconnecter'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                // 2. Si connecté et profil chargé
                if (isLoggedIn && userData != null) {
                  debugPrint('AuthWrapper: Redirection métier vers ${userData.role}');
                  switch (userData.role) {
                    case UserRole.admin:
                      return const AdminDashboard();
                    case UserRole.cook:
                      return const CookDashboard();
                    case UserRole.cashier:
                      return const CashierDashboard();
                    default:
                      return const MainShell();
                  }
                }

                // 2. Si non connecté mais en mode visiteur
                if (isGuest) {
                  return const MainShell();
                }

                // 3. Sinon, retour à l'écran de bienvenue
                return const WelcomeScreen();
              },
            );
          },
        );
      },
    );
  }
}
