import 'package:chat/providers/login_provider.dart';
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
import 'package:chat/screens/messages/message_screen_random.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../providers/api_routes.dart';

class Random_Body extends StatefulWidget {
  @override
  _Random_BodyState createState() => _Random_BodyState();
}

class _Random_BodyState extends State<Random_Body> {
  String _foundUser;
  bool _isLoading = false;
  String _user1, _user2;
  String _stranger;
  IO.Socket socket;
  String roomid;
  bool isRoomFilled = false;
    String user_id = '',
      username = '',
      gender = '',
      email = '',
      avatarImage = '';

  @override
  void initState() {
    super.initState();
    loadData();
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
          roomid=data['roomID'];
          print(data['message']);
          print(data['roomID']);
          print(data['isfilled']);
          if (data['isfilled']) {
            isRoomFilled = true;
          }
        })
      },
    );

    socket.on(
      'strangerConnected',
      (data) {
        setState(
          () {
            _user1 = data['user1'];
            _user2 = data['user2'];
            _stranger = (_user1==user_id?(_user2):(_user1));
            Navigator.push( // Use pushReplacement to navigate to MessageScreen
              context,
              MaterialPageRoute(
                builder: (context) => MessagesScreenRandom(strangerId: _stranger, socket: socket,roomid:roomid,), // Pass the socket to MessageScreen
              ),
            );
          },
        );
      },
    );
  }



  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      username = prefs.getString('username');
      user_id = prefs.getString('userId');
      gender = prefs.getString('gender');
      avatarImage = prefs.getString('avatarImage');
      email = prefs.getString('email');
      print(user_id);
    });
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
