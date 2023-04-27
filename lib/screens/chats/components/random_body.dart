import 'package:flutter/material.dart';
import 'package:chat/constants.dart';
import 'package:chat/models/Chat.dart';
import 'package:chat/screens/messages/message_screen.dart';
import 'package:chat/screens/chats/components/chat_card.dart';
import 'package:chat/components/filled_outline_button.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

class Random_Body extends StatefulWidget {
  @override
  _Random_BodyState createState() => _Random_BodyState();
}

class _Random_BodyState extends State<Random_Body> {
  String _foundUser;
  bool _isLoading = false;

  Future<void> _findUser() async {
    setState(() {
      _isLoading = true;
    });

    // Call some asynchronous function to find a user
    // and wait for its response
    // String user = await someAsyncFunction();

    // Fake asynchronous call for demonstration purposes
    await Future.delayed(Duration(seconds: 3));
    String user = "John Doe";

    setState(() {
      _foundUser = user;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!_isLoading)
            ElevatedButton(
              onPressed: _findUser,
              child: Text('Find User'),
            ),
          SizedBox(height: 20),
          if (_isLoading)
            SpinKitFadingCube(
              color: Colors.blue,
              size: 50.0,
            ),
          if (!_isLoading)
            if (_foundUser != null) Text('Found user: $_foundUser'),
        ],
      ),
    );
  }
}
