import 'package:cloud_firestore/cloud_firestore.dart';

enum ReservationStatus {
  pending,
  confirmed,
  cancelled,
  completed,
}

class Reservation {
  final String id;
  final String userId;
  final String userName;
  final DateTime dateTime;
  final int guests;
  final String? notes;
  final ReservationStatus status;

  Reservation({
    required this.id,
    required this.userId,
    required this.userName,
    required this.dateTime,
    required this.guests,
    this.notes,
    required this.status,
  });

  factory Reservation.fromFirestore(Map<String, dynamic> data, String id) {
    return Reservation(
      id: id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      dateTime: (data['dateTime'] as Timestamp).toDate(),
      guests: data['guests'] ?? 1,
      notes: data['notes'],
      status: _parseStatus(data['status']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userName': userName,
      'dateTime': Timestamp.fromDate(dateTime),
      'guests': guests,
      'notes': notes,
      'status': status.name,
    };
  }

  static ReservationStatus _parseStatus(String? statusStr) {
    return ReservationStatus.values.firstWhere(
      (e) => e.name == statusStr,
      orElse: () => ReservationStatus.pending,
    );
  }
}
