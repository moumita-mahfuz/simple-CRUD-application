class Quantity {
  Quantity({
    required this.quantity,
    required this.unit,
    required this.unitValue,
    required this.pastQuantity,
  });

  int? quantity;
  String? unit;
  double? unitValue;
  int? pastQuantity;
  factory Quantity.fromJson(Map<dynamic, dynamic> json) => Quantity(
      quantity: json['quantity'],
      unit: json['unit'],
      unitValue: json['unitValue'],
      pastQuantity: json['pastQuantity']
  );
  Map<dynamic, dynamic> toJson() => {
    'quantity': quantity,
    'unit': unit,
    'unitValue': unitValue,
    'pastQuantity': pastQuantity,
  };
}
