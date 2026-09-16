import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/firestore_service.dart';
import '../../models/reservation.dart';
import 'package:intl/intl.dart';

class AdminReservationsScreen extends StatelessWidget {
  const AdminReservationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.black,
        title: const Text('Toutes les réservations', style: TextStyle(color: AppColors.gold)),
      ),
      body: StreamBuilder<List<Reservation>>(
        stream: FirestoreService.instance.getReservations(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final res = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: res.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final r = res[index];
              return Card(
                color: AppColors.surface,
                child: ListTile(
                  title: Text('${r.userName} - ${r.guests} pers.'),
                  subtitle: Text(DateFormat('dd/MM/yyyy HH:mm').format(r.dateTime)),
                  trailing: DropdownButton<ReservationStatus>(
                    value: r.status,
                    onChanged: (status) => FirestoreService.instance.updateReservationStatus(r.id, status!),
                    items: ReservationStatus.values.map((s) => DropdownMenuItem(value: s, child: Text(s.name))).toList(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
