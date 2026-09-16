import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/firestore_service.dart';
import '../../models/app_user.dart';

class ManageEmployeesScreen extends StatelessWidget {
  const ManageEmployeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.black,
        title: const Text('Gérer les employés', style: TextStyle(color: AppColors.gold)),
      ),
      body: StreamBuilder<List<AppUser>>(
        stream: FirestoreService.instance.getEmployees(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final employees = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: employees.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final emp = employees[index];
              return ListTile(
                tileColor: AppColors.surface,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                title: Text(emp.name),
                subtitle: Text(emp.role.name.toUpperCase(), style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold)),
                trailing: PopupMenuButton<UserRole>(
                  onSelected: (role) => FirestoreService.instance.updateUserRole(emp.uid, role),
                  itemBuilder: (context) => UserRole.values
                      .map((role) => PopupMenuItem(value: role, child: Text(role.name)))
                      .toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
