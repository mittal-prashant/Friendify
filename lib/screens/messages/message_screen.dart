import 'package:chat/constants.dart';
import 'package:chat/screens/chats/chats_screen.dart';
import 'package:flutter/material.dart';
import 'package:chat/models/Chat.dart';
import 'package:chat/screens/messages/components/private_body.dart';
import 'package:chat/screens/messages/components/OfflineMessage.dart';
import '../../providers/login_provider.dart';
import 'components/friend_profile.dart';

// ignore: must_be_immutable
class MessagesScreen extends StatefulWidget {
  final Chat chat;
  List<OfflineMessage> offlinemessages;
  MessagesScreen({@required this.chat, this.offlinemessages});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  void initState() {
    super.initState();
    // loadData();
  }

  @override
  Widget build(BuildContext context) {
    // print("messagescreen");
    // print(widget.offlinemessages);
    return Scaffold(
      appBar: buildAppBar(),
      body: Body(
          friendid: widget.chat.user_id,
          offlinemessages: widget.offlinemessages),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Friend_Profile(widget.chat.name),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
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
                ),
              ],
            ),
            IconButton(onPressed: () async {
              bool shouldPop = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Are you sure you want to go back?'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('No'),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      TextButton(
                        child: Text('Yes'),
                        onPressed: () {
                          deleteFriend(widget.chat.user_id);
                          Navigator.of(context)
                              .pop(true); // close the p
                        },
                      ),
                    ],
                  );
                },
              );

              if (shouldPop == true) {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatsScreen(),
                  ),
                );
              }
            },
           icon: Icon(Icons.delete))
          ],
        ),
      ),
    );
  }
}
