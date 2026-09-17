import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/admin/admin_dashboard.dart';
import 'theme/app_theme.dart';

/// Point d'entrée spécial pour le Dashboard Admin (idéal pour le Web)
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const AdminApp());
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Belle Envie - Administration',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const AdminDashboard(),
    );
  }
}
