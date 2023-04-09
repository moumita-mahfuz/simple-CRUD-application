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
              onTap: () => {},
              child: Icon(
                Icons.add, color: Colors.white,
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
      body: FutureBuilder (
        future: _futureProductList,
        builder: (context, AsyncSnapshot<List<Product>> snapshot) {
          if(!snapshot.hasData) {
            return Center(
                child: const CircularProgressIndicator(
                  color: Colors.blue,
                ));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
                itemBuilder:  (context, index) {
                final item = snapshot.data![index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundImage: NetworkImage(
                        item.image.toString(),
                      ),
                    ),
                  ),
                  title: Text(item.name.toString()),
                  subtitle: Text("Price: " + item.productPrice!.price.toString()),

                );
                });
          }
        },
      ),
    );
  }

  Future<List<Product>> getProduct() async {
    List<Product> productList = [];
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
    //print("RESPONCE: " + response.toString());
    if(response.statusCode == 200) {

      print(response.data);
      for(Map i in response.data) {
        productList.add(Product.fromJson(i));
      }

     // List<Product> productlist = Product.fromJson(response.data);

    }
    return productList;
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
