import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _form(),
            ],
          ),
        ),
      ),
    );
  }
  Widget _form() {
    return Form(
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
          SizedBox(height: 20,),
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
                return 'Password is requird';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                  login();

                }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
  login() async {
    Dio dio = Dio();
    var url = 'https://secure-falls-43052.herokuapp.com/api/authenticate';
//data will be the object which we want to send.
//In my case I am sending a product to insert.
    //Product product = Product(name:'Pizza', price: 130.00);
    var header = {'Content-type': 'application/json; charset=utf-8'};
    var data = {'username': userNameController.text ,
    'password': passwordController.text, 'rememberMe': true };
    var responce = await dio.post(url,data: data,
      options: Options(
          headers: header
      ),);
    if(responce.statusCode == 200){
      // Status is the message receiving in responce saying product
      //inserted successfully.
      print(responce.statusCode);
      print(responce.data['Status']);
    }
    else {
      print(responce.statusCode);
    }
  }

}
