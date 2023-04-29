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

const snackBar = SnackBar(
  content: Text(
    'Random Username Must Be Atleast 5 characters!',
    style: TextStyle(fontSize: 16, color: Colors.white),
  ),
  backgroundColor: Colors.red, // Set the background color of the Snackbar
  behavior: SnackBarBehavior.floating, // Set the behavior of the Snackbar
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
        Radius.circular(8)), // Set the border radius of the Snackbar
  ),
  duration: Duration(
      seconds: 3), // Set the duration for how long the Snackbar is displayed
);

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
  String randomName;
  bool isRoomFilled = false;
  String user_id = '', username = '', gender = '', email = '', avatarImage = '';

  String _selectedUserName = '';

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
          roomid = data['roomID'];
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
            _stranger = (_user1 == user_id ? (_user2) : (_user1));
            Navigator.push(
              // Use pushReplacement to navigate to MessageScreen
              context,
              MaterialPageRoute(
                builder: (context) => MessagesScreenRandom(
                  strangerId: _stranger,
                  socket: socket,
                  roomid: roomid,
                  user_id: user_id,
                ), // Pass the socket to MessageScreen
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    socket.emit('privateRoom', prefs.getString('userId'));
  }

  Future<void> _findUser() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(Duration(seconds: 3));

    await _handlePrivateRoom();

    print("okkk");

    String user = "John Doe";

    setState(() {
      _foundUser = user;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter a random user name',
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        _selectedUserName = value;
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (_selectedUserName.length > 4) {
                        // _getRandomUserName();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: Text('Random'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
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
                      color: Theme.of(context).primaryColor,
                      size: 50.0,
                    ),
                  if (!_isLoading && _foundUser == null)
                    Text(
                      'No user found.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                      ),
                    ),
                  if (!_isLoading && _foundUser != null)
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'User Details',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Name: ${_foundUser}',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }
}
