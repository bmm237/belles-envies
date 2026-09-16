enum UserRole {
  client,
  admin,
  cook,
  cashier,
}

class AppUser {
  final String uid;
  final String email;
  final String name;
  final UserRole role;
  final String? phone;

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    this.phone,
  });

  factory AppUser.fromFirestore(Map<String, dynamic> data, String uid) {
    return AppUser(
      uid: uid,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      role: _parseRole(data['role']),
      phone: data['phone'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'role': role.name,
      'phone': phone,
    };
  }

  static UserRole _parseRole(String? roleStr) {
    return UserRole.values.firstWhere(
      (e) => e.name == roleStr,
      orElse: () => UserRole.client,
    );
  }
}
