import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Service d'authentification utilisant Firebase.
class AuthService {
  AuthService._() {
    // Écoute les changements d'état d'authentification
    _auth.authStateChanges().listen((User? user) {
      isLoggedIn.value = user != null;
    });
  }
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ValueNotifier<bool> isLoggedIn = ValueNotifier(false);

  User? get currentUser => _auth.currentUser;

  Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signup(String email, String password, String name) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    // On pourrait mettre à jour le nom ici si besoin
    await credential.user?.updateDisplayName(name);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
