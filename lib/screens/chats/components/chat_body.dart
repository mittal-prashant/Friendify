import 'package:chat/providers/message_provider.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:chat/models/Chat.dart';
import 'package:chat/screens/messages/message_screen.dart';
import 'package:chat/screens/chats/components/chat_card.dart';
import 'package:chat/components/filled_outline_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  List chatsData = [];

  @override
  void initState() {
    super.initState();
    // Load user data from preferences
    loadData();
    getAllFriends();
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
    });
  }

  Future<void> getAllFriends() async {
    final pref = await SharedPreferences.getInstance();
    final responseString = pref.getString('friendsList');

    if (responseString != null) {
      final List<dynamic> responseData = json.decode(responseString);

      setState(() {
        chatsData = responseData.map((chat) {
          return Chat(
            name: chat['username'],
            email: chat['email'],
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
  Widget build(BuildContext context) {
    return Column(
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
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
