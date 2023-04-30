import 'package:chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:chat/models/Chat.dart';
import 'package:chat/screens/messages/components/body.dart';
import '../../../providers/api_routes.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class MessagesScreen extends StatefulWidget {
   final Chat chat;
  
  MessagesScreen({@required this.chat});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  IO.Socket socket;

    @override
  void initState() {
    super.initState();
    // loadData();
    socket = IO.io(host, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
    socket.onConnect(
      (data) => print("Connected"),
    );
   
  }


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
            backgroundImage: AssetImage(widget.chat.image),
          ),
          SizedBox(width: mainDefaultPadding * 0.75),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.chat.name,
                style: TextStyle(fontSize: 16),
              ),
              Text(
                widget.chat.gender,
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
