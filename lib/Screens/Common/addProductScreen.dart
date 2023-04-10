import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
// This is the file that will be used to store the image
  File? _image;

  // This is the image picker
  final _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final _quantityFormKey = GlobalKey<FormState>();
  final _priceFormKey = GlobalKey<FormState>();
  bool quantityState = false, priceState = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController barcodeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController subCategoryController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController unitValueController = TextEditingController();
  TextEditingController pastQuantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController unitPriceController = TextEditingController();
  TextEditingController mrpController = TextEditingController();

  bool _quantityCircularIndicator = false;
  bool _priceCircularIndicator = false;
  bool _circularIndicator = false;
  ButtonStyle quantityButtonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.blue));
  ButtonStyle priceButtonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.blue));

  late String  name_f, barcode_f, description_f, subCategory_f, brand_f, quantity_f,
  unit_f, unitValue_f, pastQuantity_f, price_f, unitPrice_f, mrp_f;

  addProduct() async {
    Dio dio = Dio(BaseOptions(
      receiveTimeout: Duration(seconds: 5), // Wait for 5 seconds to receive a response
      connectTimeout: Duration(seconds: 5),// Wait for 5 seconds to establish a connection with the server
    ));
    final prefs = await SharedPreferences.getInstance();
    var url = 'https://secure-falls-43052.herokuapp.com/api/create-products';
    //https://secure-falls-43052.herokuapp.com/api/create-products

//data will be the object which we want to send.
//In my case I am sending a product to insert.
    //Product product = Product(name:'Pizza', price: 130.00);
    var header = {
      'Content-type': 'application/json; charset=utf-8',
      'Authorization': 'Bearer ${prefs.getString('token')}'
    };
    print("$name_f  $barcode_f  $description_f  $_image " +
        " $subCategory_f  $brand_f  $quantity_f  $unit_f" +
        " $unitValue_f $pastQuantity_f  $price_f" + " $unitPrice_f $mrp_f" );
    try {
      final response = await dio.post(
        url,
        data: {
          "name": name_f.toString(),
          "barcode": barcode_f.toString(),
          "description": description_f.toString(),
          "image": _image.toString(),
          "subCategory": subCategory_f,
          "brand": brand_f,
          "quantity": {
            "quantity": quantity_f,
            "unit": unit_f.toString(),
            "unitValue": unitValue_f,
            "pastQuantity": pastQuantity_f
          },
          "productPrice": {
            "price": price_f,
            "unitPrice": unitPrice_f,
            "mrp": mrp_f
          }
        },
        options: Options(headers: header),
      );
      print(response.statusCode);

      if (response.statusCode == 200) {
        setState(() {
          _circularIndicator = false;
        });
        final jsonData = jsonDecode(response.data);
        // do something with the fetched data
      } else {
        setState(() {
          _circularIndicator = false;
        });
        throw Exception('Failed to post data');
      }
    } catch (e) {
      setState(() {
        _circularIndicator = false;
      });
      throw Exception('Failed to post data' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Product'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: ElevatedButton(
              onPressed: () {
                if(quantityState == false) {
                  setState(() {
                    quantityButtonStyle = ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red));
                  });
                } else {
                  quantityButtonStyle = ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue));
                }

                if(priceState == false) {
                  setState(() {
                    priceButtonStyle = ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red));
                  });
                } else {
                  priceButtonStyle = ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue));
                }
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate() && priceState == true && quantityState == true) {

                  if( _image != null) {
                    setState(() {
                      name_f = nameController.text;
                      barcode_f = barcodeController.text;
                      description_f = descriptionController.text;
                      subCategory_f = subCategoryController.text;
                      brand_f = brandController.text;
                      _circularIndicator = true;
                    });
                    addProduct();
                  } else {
                    Get.snackbar("Warning", "Product Photo is required!");
                  }

                } else {

                }
              },
              child: (_circularIndicator) ? Text("Loading...") : const Text('Submit'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(35, 20, 35, 20),
            child: Column(
              children: [
                Center(
                  child: InkWell(
                    onTap: () => _bottomSheet(),
                    child: Stack(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: 300,
                          color: Colors.grey[300],
                          child: _image != null
                              ? Image.file(_image!, fit: BoxFit.cover)
                              : const Text('Please select an image'),
                        ),
                        Positioned(bottom: 20, right: 20, child: _cameraIcon()),
                      ],
                    ),
                    ),
                  ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 20,),
                      _textInputField('Name', nameController, TextInputType.name),
                      const SizedBox(height: 20,),
                      _textInputField('Barcode', barcodeController, TextInputType.number),
                      const SizedBox(height: 20,),
                      _textInputField('Description', descriptionController, TextInputType.text),
                      const SizedBox(height: 20,),
                      _textInputField('SubCategory', subCategoryController, TextInputType.number),
                      const SizedBox(height: 20,),
                      _textInputField('Brand', brandController, TextInputType.number),
                      const SizedBox(height: 20,),
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: ElevatedButton.icon(
                          onPressed: () => _quantityBottomSheet(),
                          icon: Icon(Icons.add),  //icon data for elevated button
                          label: Text("Add Quantity"),
                          style: quantityButtonStyle,//label text
                        ),
                      ),
                      const SizedBox(width: 20,),
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: ElevatedButton.icon(
                          onPressed: () => _productPriceBottomSheet(),
                          icon: Icon(Icons.add),  //icon data for elevated button
                          label: Text("Add Product Price"),
                          style: priceButtonStyle,//label text
                        ),
                      ),
                     ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _quantityBottomSheet() {
    return Get.bottomSheet(
      isScrollControlled: true,
      Container(
        height: 550,
        color: Colors.white,
        padding: EdgeInsets.only(left: 20,right: 20,top: 10, bottom: 10),
        child: Center(
          child: Form(
            key: _quantityFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                //quantity": 0, "unit": "string", "unitValue": 0, "pastQuantity": 0
                _textInputField('Quantity', quantityController, TextInputType.number),
                const SizedBox(height: 20,),
                _textInputField('Unit', unitController, TextInputType.text),
                const SizedBox(height: 20,),
                _textInputField('UnitValue', unitValueController, TextInputType.number),
                const SizedBox(height: 20,),
                _textInputField('PastQuantity', pastQuantityController, TextInputType.number),
                const SizedBox(height: 20,),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 20,),
                    ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_quantityFormKey.currentState!.validate()) {
                          // login();
                          _quantityValueStore(quantityController.text, unitController.text,
                              unitValueController.text, pastQuantityController.text);
                          setState(() {
                            quantityState = true;
                            _quantityCircularIndicator = true;
                            quantityButtonStyle = ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.blue));
                          });
                          Get.back();
                        }
                      },
                      child: (_quantityCircularIndicator) ? Text("Loading...") : const Text('okay'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      isDismissible: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(35),
      ),
      enableDrag: false,
    );
  }
  _quantityValueStore(String quantity, unit, unitValue, pastQuantity) {
    //quantity": 0, "unit": "string", "unitValue": 0, "pastQuantity": 0
    setState(() {
      quantity_f = quantity;
      unit_f = unit;
      unitValue_f = unitValue;
      pastQuantity_f = pastQuantity;
    });
  }

  _productPriceBottomSheet() {
    return Get.bottomSheet(
      isScrollControlled: true,
      Container(
        height: 450,
        color: Colors.white,
        padding: EdgeInsets.only(left: 20,right: 20,top: 10, bottom: 10),
        child: Center(
          child: Form(
            key: _priceFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                //{ "price": 0, "unitPrice": 0, "mrp": 0 } }
                _textInputField('Price', priceController, TextInputType.number),
                const SizedBox(height: 20,),
                _textInputField('UnitPrice', unitPriceController, TextInputType.number),
                const SizedBox(height: 20,),
                _textInputField('MRP', mrpController, TextInputType.number),
                const SizedBox(height: 20,),
                Row(
                  children: [
                    Padding(padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text("Cancel"),
                      ),),
                    const SizedBox(width: 20,),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_priceFormKey.currentState!.validate()) {
                            // login();
                            _productPriceValueStore(priceController.text, unitPriceController.text, mrpController.text);
                            setState(() {
                              priceState = true;
                              _priceCircularIndicator = true;
                              priceButtonStyle = ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.blue));
                            });
                            Get.back();
                          }
                        },
                        child: (_priceCircularIndicator) ? Text("Loading...") : const Text('okay'),
                      ),
                    ),
                  ],
                )

              ],
            ),
          ),
        ),
      ),
      isDismissible: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(35),
      ),
      enableDrag: false,
    );
  }

  _productPriceValueStore(String price, unitPrice, mrp) {
    //{ "price": 0, "unitPrice": 0, "mrp": 0 } }
    setState(() {
      price_f = price;
      unitPrice_f = unitPrice;
      mrp_f = mrp;
    });

  }

  Widget _textInputField(String field, TextEditingController controller, TextInputType inputType) {
    return TextFormField(
      controller: controller,
      textInputAction: TextInputAction.next,
      keyboardType: inputType,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: '$field',
      ),
      // The validator receives the text that the user has entered.
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$field is required';
        }
        return null;
      },
    );
  }

  // Implementing the image picker
  Future<void> _openImagePicker(ImageSource source) async {
    final XFile? pickedImage =
    await _picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  getImage(int sourceValue) {
    if(sourceValue == 1) {
      _openImagePicker(ImageSource.gallery);
    } else {
      _openImagePicker(ImageSource.camera);
    }
  }

  _bottomSheet() {
    return Get.bottomSheet(
      Container(
        height: 100,
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElevatedButton(
                  onPressed: () async {
                    getImage(1);
                    Get.back();
                  },
                  child: const Text('Pick Image from Gallery')),
              ElevatedButton(
                  onPressed: () async {
                    getImage(2);
                    Get.back();
                  },
                  child: const Text('Pick Image from Camera')),
              // ElevatedButton(
              //   child: const Text('Close BottomSheet'),
              //   onPressed: () => Navigator.pop(context),
              // ),
            ],
          ),
        ),
      ),
      //barrierColor: Colors.red[50],
      isDismissible: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(35),
        // side: BorderSide(
        //     width: 5,
        //     color: Colors.black
        // )
      ),
      enableDrag: false,
    );
  }

  Widget _cameraIcon() {
    return const Padding(
      padding: EdgeInsets.all(8),
      child: CircleAvatar(
        backgroundColor: Colors.blue,
        radius: 20,
        child: Icon(
          Icons.camera_alt,
          color: Colors.white,
        ),
      ),
    );
  }
}
