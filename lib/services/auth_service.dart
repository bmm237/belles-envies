import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';

/// Service d'authentification utilisant Firebase.
class AuthService {
  AuthService._() {
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        isLoggedIn.value = false;
        currentUserData.value = null;
      } else {
        isLoggedIn.value = true;
        _fetchUserData(user.uid);
      }
    });
  }
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  final ValueNotifier<bool> isLoggedIn = ValueNotifier(false);
  final ValueNotifier<AppUser?> currentUserData = ValueNotifier(null);

  User? get currentUser => _auth.currentUser;

  Future<void> _fetchUserData(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      currentUserData.value = AppUser.fromFirestore(doc.data()!, uid);
    }
  }

  Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signup(String email, String password, String name) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    if (credential.user != null) {
      await credential.user?.updateDisplayName(name);
      
      // Créer le profil utilisateur dans Firestore
      final newUser = AppUser(
        uid: credential.user!.uid,
        email: email,
        name: name,
        role: UserRole.client,
      );
      
      await _db.collection('users').doc(credential.user!.uid).set(newUser.toFirestore());
      currentUserData.value = newUser;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
