
import 'package:hive/hive.dart';

import '../Model/product.dart';

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 0;

  @override
  Product read(BinaryReader reader) {
    return Product(
      id: reader.read(),
      name: reader.read(),
      barcode: reader.read(),
      description:  reader.read(),
      image:  reader.read(),
        //Data.fromJson(json['data'])
      subCategory:  reader.read(),
      brand:  reader.read(),
      quantity:  reader.read(),
      productPrice:  reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer.write(obj.name);
    writer.write(obj.description);
    writer.write(obj.barcode);
    writer.write(obj.description);
    writer.write(obj.image);
    writer.write(obj.subCategory);
    writer.write(obj.brand);
    writer.write(obj.quantity);
    writer.write(obj.productPrice);
  }
}