//subCategory: {
// id: 1851,
// name: Traditional Clothing,
// image: null,
// description: Traditional Clothing,

import 'category.dart';

class SubCategory {
  SubCategory({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.category,
  });
  int? id;
  String? name;
  String? image;
  String? description;
  final Category? category;
  factory SubCategory.fromJson(Map<dynamic, dynamic> json) => SubCategory(
        id: json['id'],
        name: json['name'],
        image: json['image'],
        description: json['description'],
        category: Category.fromJson(json['category']),
      );
  Map<dynamic, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
        'description': description,
        'category': category,
      };
}
