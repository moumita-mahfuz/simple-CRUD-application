import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_crud_application/Screens/Common/productListScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isChecked = false;
  bool _circularIndicator = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        // decoration: const BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage("assets/images/background.png"),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: userNameController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Username',
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Username is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: passwordController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                    ),
                    _rememberMe(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            login();
                            setState(() {
                              _circularIndicator = true;
                            });
                          }
                        },
                        child: (_circularIndicator) ? Text("Loading...") : const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rememberMe() {
    return Row(
      children: [
        Checkbox(
          checkColor: Colors.white,
          //fillColor: MaterialStateProperty.resolveWith(getColor),
          value: isChecked,
          onChanged: (bool? value) {
            _handleRememberMe(value!);
            // setState(() {
            //   isChecked = value!;
            // });
          },
        ),
        SizedBox(
          width: 10,
        ),
        Text("Remember me"),
      ],
    );
  }

  void _handleRememberMe(bool value) {
    print("Handle Remember Me");
    isChecked = value;
    // SharedPreferences.getInstance().then(
    //   (prefs) {
    //     prefs.setBool("remember_me", value);
    //     prefs.setString('username', userNameController.text);
    //     prefs.setString('password', passwordController.text);
    //   },
    // );
    setState(() {
      isChecked = value;
    });
  }

  login() async {
    Dio dio = Dio();
    var url = 'https://secure-falls-43052.herokuapp.com/api/authenticate';
    String username = userNameController.text.trimRight();
    String password = passwordController.text.trimRight();

//data will be the object which we want to send.
//In my case I am sending a product to insert.
    //Product product = Product(name:'Pizza', price: 130.00);
    var header = {'Content-type': 'application/json; charset=utf-8'};
    var data = {'username': username, 'password': password, 'rememberMe': true};
    try {
      var response = await dio.post(
        url,
        data: data,
        options: Options(headers: header),
      );

      if (response.statusCode == 200) {
        // Status is the message receiving in responce saying product
        //inserted successfully.
        setState(() {
          _circularIndicator = false;
        });
        print(response.data);
        final temp = response.data.toString().split(':');
        //print(temp[0] +" okay "+ temp[1]);
        final token = temp[1].toString().replaceAll('}', '');
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', true);
        prefs.setString('token', token);
        prefs.setString('username', username);
        prefs.setString('login-pass', password);
        Get.off(ProductListScreen(token: token,));
      }
      else if(response.statusCode == 401) {
        Get.snackbar('Warning','Please check your Username & Password again!');
        setState(() {
          _circularIndicator = false;
        });
      }
      else {
        setState(() {
          _circularIndicator = false;
        });
      }
    } on Exception catch (e) {
      // TODO
      Get.snackbar(
        "Warning",
        'Please check your Username & Password again!',
        //colorText: Colors.white,
        //icon: Icon(Icons.person, color: Colors.white),
        snackPosition: SnackPosition.BOTTOM,
       // backgroundColor: Color(0xFF926AD3),
        duration: Duration(seconds: 4),
        isDismissible: true,
      );
      setState(() {
        _circularIndicator = false;
        });
      print(e);
    }
  }
}
