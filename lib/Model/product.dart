import 'package:hive/hive.dart';
import 'package:simple_crud_application/Properties/brand.dart';
import 'package:simple_crud_application/Properties/quantity.dart';
import 'package:simple_crud_application/Properties/subCategory.dart';

import '../Properties/productPrice.dart';

// class Product {
//   Product({
//     required this.data,
//   });
//   Data? data;
//
//   factory Product.fromJson(Map<dynamic, dynamic> json) => Product(
//         data: Data.fromJson(json['data']),
//       );
//   Map<dynamic, dynamic> toJson() => {
//         'data': data?.toJson(),
//       };
// }
@HiveType(typeId: 0)
class Product extends HiveObject {
  Product({
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

  @HiveField(0)
  int? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? barcode;

  @HiveField(3)
  String? description;

  @HiveField(4)
  String? image;

  @HiveField(5)
  final SubCategory? subCategory;

  @HiveField(6)
  final Brand? brand;

  @HiveField(7)
  final Quantity? quantity;

  @HiveField(8)
  final ProductPrice? productPrice;

  factory Product.fromJson(Map<dynamic, dynamic> json) => Product(
      id: json['id'],
      name: json['name'],
      barcode: json['barcode'],
      description: json['description'],
      image: json['image'],
      //Data.fromJson(json['data'])
      subCategory: SubCategory.fromJson(json['subCategory']),
      brand: Brand.fromJson(json['brand']),
      quantity: Quantity.fromJson(json['quantity']),
      productPrice: ProductPrice.fromJson(json['productPrice']));
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
