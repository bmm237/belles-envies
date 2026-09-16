import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/dish.dart';
import '../models/inventory_item.dart';
import '../models/reservation.dart';
import '../models/app_user.dart';

class FirestoreService {
  FirestoreService._();
  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- PLATS (MENU) ---
  Stream<List<Dish>> getDishes() {
    return _db.collection('dishes').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Dish.fromFirestore(doc.data(), doc.id)).toList();
    });
  }

  Stream<List<String>> getCategories() {
    return _db.collection('categories').snapshots().map((snapshot) {
      final cats = snapshot.docs.map((doc) => doc.id).toList();
      if (!cats.contains('Tous')) cats.insert(0, 'Tous');
      return cats;
    });
  }

  // --- INVENTAIRE (STOCKS) ---
  Stream<List<InventoryItem>> getInventory() {
    return _db.collection('inventory').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => InventoryItem.fromFirestore(doc.data(), doc.id)).toList();
    });
  }

  Future<void> updateStock(String id, double quantity) {
    return _db.collection('inventory').doc(id).update({'quantity': quantity});
  }

  Future<void> addInventoryItem(InventoryItem item) {
    return _db.collection('inventory').add(item.toFirestore());
  }

  // --- RÉSERVATIONS ---
  Stream<List<Reservation>> getReservations() {
    return _db.collection('reservations').orderBy('dateTime', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Reservation.fromFirestore(doc.data(), doc.id)).toList();
    });
  }

  Future<void> createReservation(Reservation reservation) {
    return _db.collection('reservations').add(reservation.toFirestore());
  }

  Future<void> updateReservationStatus(String id, ReservationStatus status) {
    return _db.collection('reservations').doc(id).update({'status': status.name});
  }

  // --- EMPLOYÉS (UTILISATEURS) ---
  Stream<List<AppUser>> getEmployees() {
    return _db.collection('users').where('role', isNotEqualTo: 'client').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => AppUser.fromFirestore(doc.data(), doc.id)).toList();
    });
  }

  Future<void> updateUserRole(String uid, UserRole role) {
    return _db.collection('users').doc(uid).update({'role': role.name});
  }
}
