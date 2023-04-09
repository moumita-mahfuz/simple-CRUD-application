//category: {
// id: 1801,
// name: Women's & Girls' Fashion,
// image: https://static-01.daraz.com.bd/p/50135c70caad9b6c5827aadee67516ac.jpg,
// description: Women's & Girls' Fashion}},
class Category {
  Category({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
  });
  int? id;
  String? name;
  String? image;
  String? description;
  factory Category.fromJson(Map<dynamic, dynamic> json) => Category(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      description: json['description']);
  Map<dynamic, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
        'description': description,
      };
}
