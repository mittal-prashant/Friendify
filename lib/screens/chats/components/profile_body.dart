import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile_Body extends StatefulWidget {
  @override
  _Profile_BodyState createState() => _Profile_BodyState();
}

class _Profile_BodyState extends State<Profile_Body> {
  int _selectedIndex = 2;
  String user_data = '', username = '', gender = '', email = '';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      username = prefs.getString('username');
      user_data = prefs.getString('userData') ?? '';
      gender = prefs.getString('gender');
      email = prefs.getString('email');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage('assets/images/male.png'),
              ),
              SizedBox(height: 20),
              Text(
                'Gender: ' + gender,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Username: ' + username,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Email: ' + email,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
