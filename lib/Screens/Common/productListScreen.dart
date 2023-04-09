import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_crud_application/Screens/Auth/loginScreen.dart';

import '../../Model/product.dart';

class ProductListScreen extends StatefulWidget {
  String token;
  ProductListScreen({Key? key, required this.token}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> productlist = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProduct();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product List"),
        actions: [
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
                        //color: Color(0xFF926AD3),
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
                        //color: Color(0xFF926AD3),
                      ),
                      Text(" Logout"),
                    ],
                  ),
                ),
              ];
            },
            onSelected: (value) async {
              if (value == 0) {
              } else if (value == 1) {
                logout();
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> getProduct() async {
    Dio dio = Dio();
    final prefs = await SharedPreferences.getInstance();
    var url = 'https://secure-falls-43052.herokuapp.com/api/products?page=0&size=20';
    var header = {'Content-type': 'application/json; charset=utf-8',
      'Authorization': 'Bearer ${prefs.getString('token')}'
    };
    // Perform GET request to the endpoint "/users/<id>"
    var response = await dio.get(
      url,
      options: Options(headers: header),
    );
   // var data = jsonDecode(response.data.toString());
    if(response.statusCode == 200) {

      print(response.data);
      for(Map i in response.data) {
        productlist.add(Product.fromJson(i));
      }

     // List<Product> productlist = Product.fromJson(response.data);

    }

    // Prints the raw data returned by the server
    //print('User Info: ${userData.data}');

    // Parsing the raw JSON data to the User class
   // User user = User.fromJson(userData.data);

    //return user;
  }
  logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    Get.offAll(const LoginScreen());
  }
}
