// import 'package:chat/providers/message_provider.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:chat/models/Chat.dart';
import 'package:chat/screens/messages/message_screen.dart';
import 'package:chat/screens/chats/components/chat_card.dart';
import 'package:chat/screens/messages/components/OfflineMessage.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../providers/message_provider.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../../../providers/api_routes.dart';

class Chat_Body extends StatefulWidget {
  @override
  State<Chat_Body> createState() => _Chat_BodyState();
}

class _Chat_BodyState extends State<Chat_Body> {
  String user_data = '',
      username = '',
      gender = '',
      email = '',
      avatarImage = '',
      user_id = '';
  List<OfflineMessage> offlinemessages;
  List chatsData = [];
  // IO.Socket socket = null;

  @override
  void initState() {
    super.initState();
    // Load user data from preferences
    loadData();
    getAllFriends();
    // socket = IO.io(host, <String, dynamic>{
    //   'transports': ['websocket'],
    //   'autoConnect': false,
    // });
  }

  Future<void> handleuser() {
    // print("userid");
    // print(user_id);
    // socket.emit('add-user', {'userId': user_id});
    // socket.on(
    //     'offlineMessages',
    //     (messages) => {
    //           print('offlinemessages here:'),
    //           // print(messages),
    //           handleofflinemessages(messages.toString()),
    //         });
  }

  void handleofflinemessages(String jsonString) {
    // Add quotes to the property names and string values

    final modifiedJsonString = jsonString
        .replaceAll('ashishrajprashantshyam', '"ashishrajprashantshyam"')
        .replaceAll('prashantrajprashantshyam', '"prashantrajprashantshyam"')
        .replaceAll('shyamrajprashantshyam', '"shyamrajprashantshyam"');

// print(modifiedJsonString);
    final parsedJson = jsonDecode(modifiedJsonString.toString());
    final messagesJson = parsedJson['ashishrajprashantshyam'];
    setState(() {
      offlinemessages = messagesJson.map<OfflineMessage>((json) {
        return OfflineMessage(
          senderid: json['prashantrajprashantshyam'].toString(),
          message: json['shyamrajprashantshyam'].toString(),
        );
      }).toList();
    });

    for (OfflineMessage message in offlinemessages) {
      print(message.senderid);
      print(message.message);
    }

    // print(offlinemessages.elementAt(0).senderid);

    // return messages;
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      user_data = prefs.getString('userData') ?? '';
      user_id = prefs.getString('userId');
      gender = prefs.getString('gender');
      avatarImage = prefs.getString('avatarImage');
      email = prefs.getString('email');
      // print(user_id);
    });
    // if (socket != null) {
    //   socket.connect();
    //   socket.onConnect(
    //     (data) => print("Connected"),
    //   );
    //   handleuser();
    // }
  }

  Future<void> getAllFriends() async {
    final responseString = await getFriends();

    if (responseString != null) {
      final List responseData = responseString;

      setState(() {
        chatsData = responseData.map((chat) {
          // print(chat.toString());
          return Chat(
            name: chat['username'],
            email: chat['email'],
            user_id: chat['_id'],
            gender: chat['gender'],
            image: (chat['avatarImage'] == ""
                ? (chat['gender'] == 'male'
                    ? "assets/images/male.png"
                    : "assets/images/female.png")
                : chat['avatarImage']),
          );
        }).toList();
      });
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return chatsData.length == 0
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Looks like you have no friends yet.',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                Text(
                  'Make some new friends now!',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          )
        : Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: chatsData.length,
                  itemBuilder: (context, index) => ChatCard(
                    chat: chatsData[index],
                    press: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MessagesScreen(
                            chat: chatsData[index],
                            // socket: socket,
                            offlinemessages: offlinemessages),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
  }

  //  @override
  // void dispose(){
  //   socket.emit('disconnectprivate',{'userid':user_id});

  //   super.dispose();
  // }
}
