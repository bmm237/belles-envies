class InventoryItem {
  final String id;
  final String name;
  final double quantity;
  final String unit; // ex: "kg", "litres", "pièces"
  final double minThreshold; // Seuil d'alerte

  InventoryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.minThreshold,
  });

  bool get isLowStock => quantity <= minThreshold;

  factory InventoryItem.fromFirestore(Map<String, dynamic> data, String id) {
    return InventoryItem(
      id: id,
      name: data['name'] ?? '',
      quantity: (data['quantity'] ?? 0).toDouble(),
      unit: data['unit'] ?? '',
      minThreshold: (data['minThreshold'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'minThreshold': minThreshold,
    };
  }
}
