import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/reservation.dart';
import '../widgets/account_required_view.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  DateTime? _date;
  TimeOfDay? _time;
  int _guests = 2;
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (result != null) setState(() => _date = result);
  }

  Future<void> _pickTime() async {
    final result = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 19, minute: 0));
    if (result != null) setState(() => _time = result);
  }

  void _submit() async {
    if (_date == null || _time == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choisis une date et une heure')),
      );
      return;
    }

    final user = AuthService.instance.currentUser;
    final userData = AuthService.instance.currentUserData.value;
    
    if (user == null || userData == null) return;

    final reservationDateTime = DateTime(
      _date!.year,
      _date!.month,
      _date!.day,
      _time!.hour,
      _time!.minute,
    );

    final reservation = Reservation(
      id: '', // Firestore générera l'ID
      userId: user.uid,
      userName: userData.name,
      dateTime: reservationDateTime,
      guests: _guests,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      status: ReservationStatus.pending,
    );

    try {
      await FirestoreService.instance.createReservation(reservation);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Demande de réservation envoyée — en attente de confirmation')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        centerTitle: true,
        title: Text('Réserver une table', style: AppTheme.appBarTitle),
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: AuthService.instance.isLoggedIn,
        builder: (context, loggedIn, _) {
          if (!loggedIn) {
            return const AccountRequiredView(
              message: 'Connectez-vous pour réserver une table',
            );
          }
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Quand souhaitez-vous venir ?', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _PickerTile(
                          icon: Icons.calendar_today_outlined,
                          label: _date == null
                              ? 'Date'
                              : '${_date!.day}/${_date!.month}/${_date!.year}',
                          onTap: _pickDate,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _PickerTile(
                          icon: Icons.access_time,
                          label: _time == null ? 'Heure' : _time!.format(context),
                          onTap: _pickTime,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('Nombre de personnes', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _guests > 1 ? () => setState(() => _guests--) : null,
                        icon: const Icon(Icons.remove_circle_outline, color: AppColors.black),
                      ),
                      Text('$_guests', style: Theme.of(context).textTheme.titleMedium),
                      IconButton(
                        onPressed: () => setState(() => _guests++),
                        icon: const Icon(Icons.add_circle_outline, color: AppColors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('Note (optionnel)', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: const InputDecoration(hintText: 'Ex: table près de la fenêtre, anniversaire...'),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Confirmer la réservation'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PickerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PickerTile({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.gold, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
            ),
          ],
        ),
      ),
    );
  }
}
