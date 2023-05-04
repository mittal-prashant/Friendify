import 'dart:convert';

import 'package:chat/providers/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../login/login.dart';

class Profile_Body extends StatefulWidget {
  @override
  _Profile_BodyState createState() => _Profile_BodyState();
}

class _Profile_BodyState extends State<Profile_Body> {
  int _selectedIndex = 2;
  String user_data = '',
      username = '',
      gender = '',
      email = '',
      avatarImage = '';
  double rating = 0;
  int ratedBy = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await getRating();

    setState(() {
      username = prefs.getString('username');
      user_data = prefs.getString('userData') ?? '';
      gender = prefs.getString('gender');
      avatarImage = prefs.getString('avatarImage');
      email = prefs.getString('email');
      rating = prefs.getDouble('rating');
      ratedBy = prefs.getInt('ratedby');
      // print(avatarImage);
      // print(rating);
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
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
              if (avatarImage != '')
                CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage("$avatarImage"),
                ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Show rating stars
                  for (var i = 0; i < rating.floor(); i++)
                    Icon(Icons.star, color: Colors.yellow),
                  if (rating.floor() != rating)
                    Icon(Icons.star_half, color: Colors.yellow),
                  if (rating.round() < 5)
                    for (var i = 0;
                        i <
                            (5 -
                                rating.floor() -
                                (rating.floor() != rating ? 1 : 0));
                        i++)
                      Icon(Icons.star_border, color: Colors.yellow),
                  SizedBox(width: 10),
                  Text('(Rated by $ratedBy users)',
                      style: TextStyle(fontSize: 16)),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Gender: ' + (gender == 'male' ? 'Male' : 'Female'),
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
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Logout'),
                onPressed: () => _logout(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
