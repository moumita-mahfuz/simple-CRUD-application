import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_crud_application/Screens/Auth/loginScreen.dart';
import 'package:simple_crud_application/Screens/Common/addProductScreen.dart';
import 'package:simple_crud_application/Screens/Common/singleProductDetailsScreen.dart';
import 'package:simple_crud_application/Screens/User/userProfileScreen.dart';

import '../../Model/product.dart';

class ProductListScreen extends StatefulWidget {
  String token;
  ProductListScreen({Key? key, required this.token}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> _futureProductList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _futureProductList = getProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product List"),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: InkWell(
              onTap: () => {Get.to(AddProductScreen())},
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
          PopupMenuButton(
            icon: const Icon(
              Icons.more_vert_rounded,
              color: Colors.white,
            ),
            itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  value: 0,
                  child: Row(
                    children: const [
                      Icon(
                        Icons.account_circle_rounded,
                        color: Colors.blue,
                      ),
                      Text(" Profile"),
                    ],
                  ),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Row(
                    children: const [
                      Icon(
                        Icons.logout,
                        color: Colors.blue,
                      ),
                      Text(" Logout"),
                    ],
                  ),
                ),
              ];
            },
            onSelected: (value) async {
              if (value == 0) {
                Get.to(UserProfileScreen());
              } else if (value == 1) {
                logout();
              }
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _futureProductList,
        builder: (context, AsyncSnapshot<List<Product>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.blue,
            ));
          } else {
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final item = snapshot.data![index];
                    //Single Grid
                    return InkWell(
                      onTap: () =>
                          {Get.to(SingleProductDetailsScreen(product: item))},
                      child: Container(
                        height: 450,
                        color: Colors.blue,
                        // margin: const EdgeInsets.all(10.0),
                        // decoration: BoxDecoration(
                        //   image: DecorationImage(
                        //     image: _showImage(item.image.toString()),
                        //
                        //     fit: BoxFit.fill,
                        //   ),
                        //   borderRadius: const BorderRadius.all(
                        //     Radius.circular(20.0),
                        //   ),
                        // ),
                        child: Stack(
                          children: [
                            Container(
                              height: 450,
                              child: _showImage(item.image.toString()),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20.0),
                                  )
                              ),
                            ),

                            Container(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  height: 25,
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    color: Colors.black38,
                                    // borderRadius: BorderRadius.only(
                                    //     bottomLeft: Radius.circular(20.0),
                                    //     bottomRight: Radius.circular(20.0))
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      ('${item.productPrice!.price}'),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                      // child: Column(
                      //   children: [
                      //     Expanded(
                      //       flex: 3,
                      //       child: Container(
                      //         height: 400,
                      //        color: Colors.blue,
                      //        // margin: const EdgeInsets.all(10.0),
                      //         // decoration: BoxDecoration(
                      //         //   image: DecorationImage(
                      //         //     image: _showImage(item.image.toString()),
                      //         //
                      //         //     fit: BoxFit.fill,
                      //         //   ),
                      //         //   borderRadius: const BorderRadius.all(
                      //         //     Radius.circular(20.0),
                      //         //   ),
                      //         // ),
                      //         child: Stack(
                      //           children: [
                      //             Container(
                      //               height: 400,
                      //               child: _showImage(item.image.toString()),
                      //               decoration: BoxDecoration(
                      //                 borderRadius: BorderRadius.all(
                      //                   Radius.circular(20.0),
                      //                 )
                      //               ),
                      //             ),
                      //
                      //             Container(
                      //                 alignment: Alignment.bottomCenter,
                      //                 child: Container(
                      //                   height: 25,
                      //                   width: double.infinity,
                      //                   decoration: const BoxDecoration(
                      //                       color: Colors.black38,
                      //                       // borderRadius: BorderRadius.only(
                      //                       //     bottomLeft: Radius.circular(20.0),
                      //                       //     bottomRight: Radius.circular(20.0))
                      //                   ),
                      //                   child: Align(
                      //                     alignment: Alignment.center,
                      //                     child: Text(
                      //                       ('${item.productPrice!.price}'),
                      //                       style: const TextStyle(
                      //                           color: Colors.white,
                      //                           fontWeight: FontWeight.bold,
                      //                           fontSize: 18.0),
                      //                     ),
                      //                   ),
                      //                 )),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //     Expanded(
                      //       flex: 1,
                      //       child: Padding(
                      //         padding: EdgeInsets.only(left: 8.0, right: 8.0),
                      //         child: Text('',
                      //           // item.name!.length > 3
                      //           //     ? '${item.name!.substring(0, 20)}...'
                      //           //     : item.name!,
                      //           style: const TextStyle(
                      //               color: Colors.blue,
                      //               fontWeight: FontWeight.normal,
                      //               fontSize: 12.0),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    );
                  },
                ),
              ),
            );

            // return ListView.builder(
            //     itemCount: snapshot.data!.length,
            //     itemBuilder: (context, index) {
            //       final item = snapshot.data![index];
            //       return InkWell(
            //         onTap: () => SingleProductDetailsScreen(product: item,),
            //         child: ListTile(
            //           leading: CircleAvatar(
            //             radius: 20,
            //             backgroundColor: Colors.white,
            //             child: CircleAvatar(
            //               radius: 15,
            //               backgroundImage: NetworkImage(
            //                 item.image.toString(),
            //               ),
            //             ),
            //           ),
            //           title: Text(item.name.toString()),
            //           subtitle:
            //               Text("Price: ${item.productPrice!.price}"),
            //         ),
            //       );
            //     });
          }
        },
      ),
    );
  }

  ///get future product list
  Future<List<Product>> getProduct() async {
    List<Product> productList = [];
    Dio dio = Dio();
    final prefs = await SharedPreferences.getInstance();
    var url =
        'https://secure-falls-43052.herokuapp.com/api/products?page=0&size=20';
    var header = {
      'Content-type': 'application/json; charset=utf-8',
      'Authorization': 'Bearer ${prefs.getString('token')}'
    };
    // Perform GET request to the endpoint "/users/<id>"
    var response = await dio.get(
      url,
      options: Options(headers: header),
    );
    // var data = jsonDecode(response.data.toString());
    //print("RESPONCE: " + response.toString());
    if (response.statusCode == 200) {
      print(response.data);
      for (Map i in response.data) {
        productList.add(Product.fromJson(i));
      }
    }
    return productList;
  }

  logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    Get.offAll(const LoginScreen());
  }
  Widget _showImage(String imageString) {
    if (imageString.startsWith('http') || imageString.startsWith('https')) {
      print('The string starts with http or https.');
      return  Image.network(imageString, width: 300 - (20.0 * 2),fit: BoxFit.fill,);
    } else {
      print('The string does not start with http or https.');
      return Image.asset('assets/images/kameez-kurtis.jpg', width: 300 - (20.0 * 2),fit: BoxFit.cover,);
    }

  }
}
