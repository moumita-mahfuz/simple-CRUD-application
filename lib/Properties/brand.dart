//brand: {
// id: 1901,
// name: Arong,
// description: Arong,
// image: https://static-01.daraz.com.bd/p/50135c70caad9b6c5827aadee67516ac.jpg},

class Brand {
  Brand({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
  });
  int? id;
  String? name;
  String? description;
  String? image;
  factory Brand.fromJson(Map<dynamic, dynamic> json) => Brand(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        image: json['image'],
      );
  Map<dynamic, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'image': image,
      };
}
