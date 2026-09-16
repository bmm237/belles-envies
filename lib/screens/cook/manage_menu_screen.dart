import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/firestore_service.dart';
import '../../models/dish.dart';

class ManageMenuScreen extends StatelessWidget {
  const ManageMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.black,
        title: const Text('Gérer le menu', style: TextStyle(color: AppColors.gold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.gold),
            onPressed: () {
              // TODO: Ajouter un plat
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Dish>>(
        stream: FirestoreService.instance.getDishes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final dishes = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: dishes.length,
            itemBuilder: (context, index) {
              final dish = dishes[index];
              return ListTile(
                leading: dish.imagePath.startsWith('http') 
                  ? Image.network(dish.imagePath, width: 50, height: 50, fit: BoxFit.cover)
                  : const Icon(Icons.restaurant, color: AppColors.gold),
                title: Text(dish.name),
                subtitle: Text('${dish.price} FCFA'),
                trailing: const Icon(Icons.edit_outlined),
                onTap: () {
                  // TODO: Modifier le plat
                },
              );
            },
          );
        },
      ),
    );
  }
}
