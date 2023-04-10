import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/User.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

//{id: 1, login: admin, firstName: Administrator, lastName: Administrator,
// email: admin@localhost.com, phone: +8801795888218, imageUrl: https://firebasestorage.googleapis.com/v0/b/inventory-51bca.appspot.com/o/test%2Fd61a99ea-32e2-4593-a2b8-131c89306f32.jpg?alt=media&token=d61a99ea-32e2-4593-a2b8-131c89306f32.jpg,
// activated: true, langKey: en, createdBy: system, createdDate: null, lastModifiedBy: admin,
// lastModifiedDate: 2023-03-25T14:44:13.198288Z, authorities: [ROLE_USER, ROLE_ADMIN]}

class _UserProfileScreenState extends State<UserProfileScreen> {
  //Define a variable to store user data;
  late User _userData;
  // Define a variable to store the loading state
  bool _isLoading = true;

  // Define a function to fetch the user profile data from the API endpoint
  Future<void> _fetchUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    var header = {
      'Content-type': 'application/json; charset=utf-8',
      'Authorization': 'Bearer ${prefs.getString('token')}'
    };
    try {
      // Make a GET request to the API endpoint using Dio
      final response = await Dio().get('https://secure-falls-43052.herokuapp.com/api/account', options: Options(headers: header),);
      print(response.statusCode);
      // If the response is successful, store the user profile data in the _userData variable
      if (response.statusCode == 200) {
        setState(() {
          _isLoading = false;
        });
        print(response.statusCode);
        print(response.data);
        _userData = User.fromJson(response.data);
        print(_userData.firstName);
      } else {
        throw Exception('Failed to fetch user profile data');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to fetch user profile data' + e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    // Call the _fetchUserProfile function when the widget is first created
    _fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          SizedBox(height: 16),
          CircleAvatar(
            radius: 64,
            backgroundImage: NetworkImage(_userData.imageUrl.toString()),
          ),
          SizedBox(height: 16),
          Text(
            _userData.firstName.toString() +" " + _userData.lastName.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            _userData.email.toString(),
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text(_userData.phone.toString()),
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text(_userData.langKey.toString()),
          ),
        ],
      ),
    );
  }

}