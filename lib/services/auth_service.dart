import 'dart:async';
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
        isLoading.value = false;
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
  final ValueNotifier<bool> isLoading = ValueNotifier(true);
  final ValueNotifier<bool> isGuestMode = ValueNotifier(false);
  final ValueNotifier<AppUser?> currentUserData = ValueNotifier(null);

  StreamSubscription<DocumentSnapshot>? _userSubscription;

  User? get currentUser => _auth.currentUser;

  void setGuestMode(bool value) {
    isGuestMode.value = value;
  }

  Future<void> _fetchUserData(String uid) async {
    isLoading.value = true;
    
    Timer(const Duration(seconds: 10), () {
      if (isLoading.value) {
        debugPrint('AuthService: Timeout de récupération des données.');
        isLoading.value = false;
      }
    });

    await _userSubscription?.cancel();
    
    debugPrint('AuthService: Tentative de récupération pour UID: $uid');
    
    // 1. Première tentative par UID
    final doc = await _db.collection('users').doc(uid).get();
    
    if (doc.exists) {
      _startUserSubscription(uid);
    } else {
      // 2. Fallback : Recherche par EMAIL si l'UID ne correspond pas
      final email = _auth.currentUser?.email;
      debugPrint('AuthService: UID non trouvé, tentative par email: $email');
      
      if (email != null) {
        final query = await _db.collection('users').where('email', isEqualTo: email).limit(1).get();
        
        if (query.docs.isNotEmpty) {
          final oldDoc = query.docs.first;
          debugPrint('AuthService: Utilisateur trouvé par email. Migration de ${oldDoc.id} vers $uid');
          
          // Migration automatique vers le nouvel UID pour corriger le problème définitivement
          final userData = oldDoc.data();
          await _db.collection('users').doc(uid).set(userData);
          // Optionnel : supprimer l'ancien document s'il a un ID différent de l'email et du nouvel UID
          if (oldDoc.id != uid) {
            await _db.collection('users').doc(oldDoc.id).delete();
          }
          
          _startUserSubscription(uid);
        } else {
          debugPrint('AuthService: Aucun profil trouvé par UID ou par Email.');
          currentUserData.value = null;
          isLoading.value = false;
        }
      } else {
        currentUserData.value = null;
        isLoading.value = false;
      }
    }
  }

  void _startUserSubscription(String uid) {
    _userSubscription = _db.collection('users').doc(uid).snapshots().listen(
      (doc) {
        if (doc.exists) {
          currentUserData.value = AppUser.fromFirestore(doc.data()!, uid);
          debugPrint('AuthService: Profil chargé en temps réel. Rôle: ${currentUserData.value?.role}');
        }
        isLoading.value = false;
      },
      onError: (e) {
        debugPrint('AuthService Subscription Error: $e');
        isLoading.value = false;
      },
    );
  }

  Future<void> login(String email, String password) async {
    isGuestMode.value = false; // Désactiver le mode visiteur immédiatement
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signup(String email, String password, String name) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    if (credential.user != null) {
      await credential.user?.updateDisplayName(name);
      
      final newUser = AppUser(
        uid: credential.user!.uid,
        email: email,
        name: name,
        role: UserRole.client,
      );
      
      await _db.collection('users').doc(credential.user!.uid).set(newUser.toFirestore());
    }
  }

  Future<void> logout() async {
    await _userSubscription?.cancel();
    _userSubscription = null;
    isGuestMode.value = false;
    await _auth.signOut();
  }
}
