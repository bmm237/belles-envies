import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/dish.dart';

class FirestoreService {
  FirestoreService._();
  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Récupère la liste des plats en temps réel.
  Stream<List<Dish>> getDishes() {
    return _db.collection('dishes').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Dish.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  /// Récupère les catégories uniques depuis Firestore.
  /// Pour simplifier, on peut aussi les garder en dur ou les lire dans une collection dédiée.
  Stream<List<String>> getCategories() {
    return _db.collection('categories').snapshots().map((snapshot) {
      final cats = snapshot.docs.map((doc) => doc.id).toList();
      if (!cats.contains('Tous')) {
        cats.insert(0, 'Tous');
      }
      return cats;
    });
  }
}
