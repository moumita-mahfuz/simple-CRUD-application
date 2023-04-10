
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_crud_application/Screens/Common/productListScreen.dart';

import '../../Model/product.dart';
import '../Component/cartButton.dart';

class SingleProductDetailsScreen extends StatefulWidget {
  Product product;
  SingleProductDetailsScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<SingleProductDetailsScreen> createState() => _SingleProductDetailsScreenState();
}

class _SingleProductDetailsScreenState extends State<SingleProductDetailsScreen> {

  _delete() async {
    Dio dio = Dio(BaseOptions(
      receiveTimeout: Duration(seconds: 5), // Wait for 5 seconds to receive a response
      connectTimeout: Duration(seconds: 5),// Wait for 5 seconds to establish a connection with the server
    ));
    final prefs = await SharedPreferences.getInstance();
    var header = {
      'Content-type': 'application/json; charset=utf-8',
      'Authorization': 'Bearer ${prefs.getString('token')}'
    };
    int id = widget.product.id!;
    String token = prefs.getString('token').toString();
    var url = 'https://secure-falls-43052.herokuapp.com/api/products/$id';
    try {
      final response = await dio.delete(url, options: Options(headers: header));
      print(response.statusCode);

      if (response.statusCode == 200) {
        // do something with the fetched data
        Get.offAll(ProductListScreen(token: token));
      } else {
        throw Exception('Failed to post data');
      }
    } catch (e) {
      throw Exception('Failed to post data' + e.toString());
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          InkWell(
            onTap: () {
              Get.bottomSheet(
                  Container(
                    height: 100,
                    color: Colors.blue,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                            onPressed: () async {
                              print("Pressed delete");
                              _delete();
                              // deleteContact();
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(200, 40),
                              maximumSize: const Size(200, 40),
                              backgroundColor: Colors.white,
                            ),
                            child: const Text(
                              'Delete Product',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            )),
                        ElevatedButton(
                            onPressed: () async {
                              print("Pressed Cancel");
                              Get.back();
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(200, 40),
                              maximumSize: const Size(200, 40),
                              backgroundColor: Colors.white,
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            )),
                      ],
                    ),
                  ),
              );
            },
            child: Container(
              padding:
              const EdgeInsets.only(left: 0, top: 10, bottom: 10, right: 10),
              //Icon(Icons.more_vert)
              child: Icon(Icons.delete_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        widget.product.name!,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),

                    SizedBox(height: 20.0),

                    // Product Image
                    Center(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.network(widget.product.image!, width: 300 - (20.0 * 2))
                      ),
                    ),

                    SizedBox(height: 20.0),

                    // Price
                    Text(
                      "\$" + widget.product.productPrice!.price!.toString(),
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.blue
                      ),
                    ),

                    SizedBox(height: 20.0),

                    // Dropdown List
                    Row(
                      children: [
                        Column(
                          children: [
                            Text("Brand: ${widget.product.brand!.name!}"),
                            //Text("Type: ${widget.product.subCategory!.description!}"),
                          ],
                        ),

                        SizedBox(width: 20.0),

                        Column(
                          children: [
                            Text("Category: ${widget.product.subCategory!.category!.name!}"),
                            Text("Sub-Category: ${widget.product.subCategory!.name!}"),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    // Cart Button
                    CartButton(
                        tapEvent: () { }
                    ),

                    SizedBox(height: 20),

                    // Description
                    Text(
                      widget.product.description!,
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 15,
                          fontWeight: FontWeight.w700
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
