import 'dart:math';

import 'package:chat/constants.dart';
import 'package:chat/providers/message_provider.dart';
import 'package:chat/screens/chats/chats_screen.dart';
import 'package:chat/screens/chats/components/random_body.dart';
import 'package:flutter/material.dart';
import 'package:chat/models/Chat.dart';
import 'package:chat/screens/messages/components/body.dart';
import 'package:chat/providers/login_provider.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

const snackBar = SnackBar(
  content: Text(
    'User left the chat!',
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
        'alone',
        (data) => {
              if (data['randomid'] != widget.user_id)
                {
                  ScaffoldMessenger.of(context).showSnackBar(snackBar),
                  showRatingPrompt(context),
                }
            });

    widget.socket.on(
        "receiverequest",
        (data) => {
              // print(data),
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
              setState(() {
                // print(data);
                if (data['senderid'] != widget.user_id) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ResponseDialog(response: data['response']);
                    },
                  );
                }

                if (data['response']) widget.added = true;
              })
            });
  }

  void handlefriendresponse(bool f) {
    widget.socket.emit("respondrequest",
        {'room': widget.roomid, 'from': widget.user_id, 'response': f});
  }

  void _handleFriendRequestAccepted() async {
    await addFriend(widget.user_id, widget.strangerId);
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

  void disconnect() {
    widget.socket.emit('disconnectRandom', {'userid': widget.user_id});
    // widget.socket.dispose();
  }

  void showRatingPrompt(BuildContext context) {
    int rating = 0;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text('Rate the user: '),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      5,
                      (index) => InkWell(
                        onTap: () {
                          setState(() {
                            rating = index + 1;
                          });
                        },
                        child: Icon(
                          index < rating
                              ? Icons.star
                              : Icons.star_border_outlined,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              rating == 0
                  ? ElevatedButton(
                      child: Text('Submit'),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        widget.socket.dispose();
                        rateUser(widget.strangerId, rating);
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatsScreen(),
                          ),
                        );
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      },
                      child: Text('Submit'),
                    ),
            ],
          );
        },
      ),
      behavior: SnackBarBehavior.floating,
      duration: Duration(days: 365),
    ));
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
          BackButton(
            onPressed: () async {
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
                          disconnect();
                          Navigator.of(context)
                              .pop(); // close the previous dialog
                          showRatingPrompt(context);
                        },
                      ),
                    ],
                  );
                },
              );

              if (shouldPop == true) {
                Navigator.of(context).pop();
              }
            },
          ),
          // CircleAvatar(
          //   backgroundImage: AssetImage("assets/images/male.png"),
          // ),
          // SizedBox(width: mainDefaultPadding * 0.75),
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

            // Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: Text('Accept request'),
          onPressed: () {
            // Perform the logic to send the friend request
            // handleresponse(0);
            _acceptFriendRequest();

            // Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class ResponseDialog extends StatelessWidget {
  bool response;
  ResponseDialog({@required this.response});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Stranger's response"),
      content: response
          ? Text('Stranger has accepted your request')
          : Text('Stranger has rejected your request'),
      actions: [
        ElevatedButton(
          child: Text('close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
