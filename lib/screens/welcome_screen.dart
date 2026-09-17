import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Text(
              'Belle Envie',
              style: AppTheme.appBarTitle.copyWith(fontSize: 48, color: AppColors.gold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Les saveurs authentiques du Cameroun',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const Spacer(),
            
            // Boutons d'action
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: AppColors.black,
                ),
                child: const Text('Se connecter'),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SignupScreen()),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.gold),
                  foregroundColor: AppColors.gold,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Créer un compte'),
              ),
            ),
            const SizedBox(height: 30),
            
            TextButton(
              onPressed: () => AuthService.instance.setGuestMode(true),
              child: const Text(
                'Continuer en tant que visiteur',
                style: TextStyle(color: Colors.white60, decoration: TextDecoration.underline),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
