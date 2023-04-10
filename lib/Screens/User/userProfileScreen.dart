import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  // Define a variable to store the user profile data
  Map<String, dynamic> _userData = {};

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
        print(response.statusCode);
        print(response.data);
        setState(() {
          _userData = response.data;
          _isLoading = false;
        });
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
      // body: _isLoading
      //     ? Center(child: CircularProgressIndicator())
      //     : Column(
      //   children: [
      //     SizedBox(height: 16),
      //     CircleAvatar(
      //       radius: 64,
      //       backgroundImage: NetworkImage(_userData['avatar']),
      //     ),
      //     SizedBox(height: 16),
      //     Text(
      //       _userData['name'],
      //       style: TextStyle(
      //         fontSize: 24,
      //         fontWeight: FontWeight.bold,
      //       ),
      //     ),
      //     SizedBox(height: 8),
      //     Text(
      //       _userData['email'],
      //       style: TextStyle(
      //         fontSize: 16,
      //       ),
      //     ),
      //     SizedBox(height: 16),
      //     ListTile(
      //       leading: Icon(Icons.phone),
      //       title: Text(_userData['phone']),
      //     ),
      //     ListTile(
      //       leading: Icon(Icons.location_on),
      //       title: Text(_userData['address']),
      //     ),
      //   ],
      // ),
    );
  }
}