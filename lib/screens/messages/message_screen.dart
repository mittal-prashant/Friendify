import 'package:chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:chat/screens/messages/components/body.dart';

class MessagesScreen extends StatelessWidget {
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
            backgroundImage: AssetImage("assets/images/user_2.png"),
          ),
          SizedBox(width: mainDefaultPadding * 0.75),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Shyam",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "Active 3m ago",
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
