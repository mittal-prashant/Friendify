import 'package:chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:chat/models/Chat.dart';
import 'package:chat/screens/messages/components/body.dart';
// import 'package:chat/screens/messages/components/request_popup.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class MessagesScreenRandom extends StatefulWidget {
  final String strangerId;
  IO.Socket socket;
  final String roomid;
  final String user_id;
  bool added = false;

  MessagesScreenRandom(
      {@required this.strangerId, this.socket, this.roomid, this.user_id});
  @override
  State<MessagesScreenRandom> createState() => _MessagesScreenRandomState();
}

class _MessagesScreenRandomState extends State<MessagesScreenRandom> {
  @override
  void initState() {
    super.initState();

    widget.socket.on(
        "receiverequest",
        (data) => {
              print(data),
              if (data['senderid'] != widget.user_id)
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return FriendRequestDialog(
                      onFriendRequestAccepted: _handleFriendRequestAccepted,
                      onFriendRequestRejected: _handleFriendRequestRejected,
                    );
                  },
                )
            });

    widget.socket.on(
        "requestresponse",
        (data) => {
              print(data),
              if (data['senderid'] != widget.user_id)
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return FriendRequestDialog(
                      onFriendRequestAccepted: _handleFriendRequestAccepted,
                      onFriendRequestRejected: _handleFriendRequestRejected,
                    );
                  },
                )
            });
  }

  void handlefriendresponse(bool f) {
    widget.socket.emit("respondrequest",
        {'room': widget.roomid, 'from': widget.user_id, 'response': f});
  }

  void _handleFriendRequestAccepted() {
    setState(() {
      widget.added = true;
      handlefriendresponse(true);
      // _friendRequestCount++;
    });
  }

  void _handleFriendRequestRejected() {
    setState(() {
      widget.added = false;
      handlefriendresponse(false);

      // _friendRequestCount++;
    });
    // Perform any desired actions when a friend request is rejected
  }

  void handleadd() {
    widget.socket
        .emit("sendrequest", {'room': widget.roomid, 'from': widget.user_id});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Body(socket: widget.socket, roomid: widget.roomid),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          BackButton(),
          CircleAvatar(
            backgroundImage: AssetImage("assets/images/male.png"),
          ),
          SizedBox(width: mainDefaultPadding * 0.75),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.strangerId,
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
            handleadd();
          },
        ),
        SizedBox(width: mainDefaultPadding / 2),
      ],
    );
  }
}

class FriendRequestDialog extends StatefulWidget {
  final VoidCallback onFriendRequestAccepted;
  final VoidCallback onFriendRequestRejected;

  FriendRequestDialog({
    @required this.onFriendRequestAccepted,
    @required this.onFriendRequestRejected,
  });

  @override
  _FriendRequestDialogState createState() => _FriendRequestDialogState();
}

class _FriendRequestDialogState extends State<FriendRequestDialog> {
  void _acceptFriendRequest() {
    widget.onFriendRequestAccepted();
    Navigator.of(context).pop();
  }

  void _rejectFriendRequest() {
    widget.onFriendRequestRejected();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Friend'),
      content: Text('Stranger has requested you to be his friend'),
      actions: [
        ElevatedButton(
          child: Text('Reject'),
          onPressed: () {
            _rejectFriendRequest();

            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: Text('Accept request'),
          onPressed: () {
            // Perform the logic to send the friend request
            // handleresponse(0);
            _acceptFriendRequest();

            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
