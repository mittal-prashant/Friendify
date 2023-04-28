import 'package:chat/screens/chats/components/profile_body.dart';
import 'package:chat/screens/login/signIn.dart';
import 'package:flutter/material.dart';
import 'package:chat/constants.dart';
import 'package:chat/models/Chat.dart';
import 'package:chat/screens/messages/message_screen.dart';
import 'package:chat/screens/chats/components/chat_card.dart';
import 'package:chat/components/filled_outline_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../providers/api_routes.dart';

class Random_Body extends StatefulWidget {
  @override
  _Random_BodyState createState() => _Random_BodyState();
}

class _Random_BodyState extends State<Random_Body> {
  String _foundUser;
  bool _isLoading = false;
  IO.Socket socket;
  bool isRoomFilled;

  @override
  void initState() {
    super.initState();
    socket = IO.io(host, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
    socket.onConnect(
      (data) => print("Connected"),
    );
    socket.on(
      'private ack',
      (data) => {
        setState(() {
          print(data['message']);
          print(data['roomID']);
          print(data['isfilled']);
          if (data['isfilled']) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SignInPage(),
              ),
            );
          }
        })
      },
    );
  }

  void _handlePrivateRoom() async {
    _isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    socket.emit('privateRoom', prefs.getString('userId'));
  }

  Future<void> _findUser() async {
    await socket.onConnect;
    await _handlePrivateRoom();

    print("okkk");

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

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }
}
