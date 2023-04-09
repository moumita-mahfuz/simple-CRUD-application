class ProductPrice {
  ProductPrice({
    required this.price,
    required this.unitPrice,
    required this.mrp,
  });
  double? price;
  double? unitPrice;
  double? mrp;
  factory ProductPrice.fromJson(Map<dynamic, dynamic> json) => ProductPrice(
      price: json['price'],
      unitPrice: json['unitPrice'],
      mrp: json['mrp'],
  );
  Map<dynamic, dynamic> toJson() => {
    'price': price,
    'unitPrice': unitPrice,
    'mrp': mrp,
  };
}
