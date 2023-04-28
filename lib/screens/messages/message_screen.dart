import 'package:chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:chat/models/Chat.dart';
import 'package:chat/screens/messages/components/body.dart';

class MessagesScreen extends StatelessWidget {
   final Chat chat;

  MessagesScreen({@required this.chat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Body(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          BackButton(),
          CircleAvatar(
            backgroundImage: AssetImage(chat.image),
          ),
          SizedBox(width: mainDefaultPadding * 0.75),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chat.name,
                style: TextStyle(fontSize: 16),
              ),
              Text(
                chat.gender,
                style: TextStyle(fontSize: 12),
              )
            ],
          )
        ],
      ),
      actions: [
      IconButton(
        icon: Icon(Icons.local_phone),
        onPressed: () {},
      ),
      IconButton(
        icon: Icon(Icons.videocam),
        onPressed: () {},
      ),
      SizedBox(width: mainDefaultPadding / 2),
    ],
    );
  }
}
