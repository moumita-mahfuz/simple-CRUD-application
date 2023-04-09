import 'package:simple_crud_application/Properties/brand.dart';
import 'package:simple_crud_application/Properties/quantity.dart';
import 'package:simple_crud_application/Properties/subCategory.dart';

import '../Properties/productPrice.dart';

class Product {
  Product({
    required this.data,
  });
  Data? data;

  factory Product.fromJson(Map<dynamic, dynamic> json) => Product(
        data: Data.fromJson(json['data']),
      );
  Map<dynamic, dynamic> toJson() => {
        'data': data?.toJson(),
      };
}

class Data {
  Data({
    required this.id,
    required this.name,
    required this.barcode,
    required this.description,
    required this.image,
    required this.subCategory,
    required this.brand,
    required this.quantity,
    required this.productPrice,
  });
  int? id;
  String? name;
  String? barcode;
  String? description;
  String? image;
  List<SubCategory>? subCategory;
  List<Brand>? brand;
  List<Quantity>? quantity;
  List<ProductPrice>? productPrice;
  factory Data.fromJson(Map<dynamic, dynamic> json) => Data(
      id: json['id'],
      name: json['name'],
      barcode: json['barcode'],
      description: json['description'],
      image: json['image'],
      subCategory: json['subCategory'],
      brand: json['brand'],
      quantity: json['quantity'],
      productPrice: json['productPrice']);
  Map<dynamic, dynamic> toJson() => {
        'id': id,
        'name': name,
        'barcode': barcode,
        'description': description,
        'image': image,
        'subCategory': subCategory,
        'brand': brand,
        'quantity': quantity,
        'productPrice': productPrice
      };
}
