import 'package:chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:chat/models/Chat.dart';
import 'package:chat/screens/messages/components/body.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MessagesScreenRandom extends StatelessWidget {
   final String strangerId;
  IO.Socket socket;
   final String roomid;
  MessagesScreenRandom({@required this.strangerId,this.socket,this.roomid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Body(socket: socket,roomid:roomid),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          BackButton(),
          CircleAvatar(
            backgroundImage: AssetImage(""),
          ),
          SizedBox(width: mainDefaultPadding * 0.75),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strangerId,
                style: TextStyle(fontSize: 16),
              ),
            ],
          )
        ],
      ),
      actions: [
      IconButton(
        icon: Icon(Icons.favorite_rounded),
        onPressed: () {
          
        },
      ),
    
      SizedBox(width: mainDefaultPadding / 2),
    ],
    );
  }
}
