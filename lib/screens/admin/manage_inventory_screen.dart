import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/firestore_service.dart';
import '../../models/inventory_item.dart';

class ManageInventoryScreen extends StatelessWidget {
  const ManageInventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.black,
        title: const Text('Gestion des stocks', style: TextStyle(color: AppColors.gold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.gold),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.gold),
            onPressed: () => _showAddItemDialog(context),
          ),
        ],
      ),
      body: StreamBuilder<List<InventoryItem>>(
        stream: FirestoreService.instance.getInventory(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final items = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                color: AppColors.surface,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Quantité: ${item.quantity} ${item.unit}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (item.isLowStock)
                        const Icon(Icons.warning, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => _showUpdateDialog(context, item),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showUpdateDialog(BuildContext context, InventoryItem item) {
    final controller = TextEditingController(text: item.quantity.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Mise à jour: ${item.name}'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'Nouvelle quantité (${item.unit})'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              final qty = double.tryParse(controller.text);
              if (qty != null) {
                FirestoreService.instance.updateStock(item.id, qty);
                Navigator.pop(context);
              }
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    final nameController = TextEditingController();
    final qtyController = TextEditingController();
    final unitController = TextEditingController(text: 'kg');
    final thresholdController = TextEditingController(text: '5');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter un article'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nom')),
            TextField(controller: qtyController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Quantité initiale')),
            TextField(controller: unitController, decoration: const InputDecoration(labelText: 'Unité (kg, litres...)')),
            TextField(controller: thresholdController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Seuil d\'alerte')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              final item = InventoryItem(
                id: '',
                name: nameController.text,
                quantity: double.tryParse(qtyController.text) ?? 0,
                unit: unitController.text,
                minThreshold: double.tryParse(thresholdController.text) ?? 5,
              );
              FirestoreService.instance.addInventoryItem(item);
              Navigator.pop(context);
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }
}
