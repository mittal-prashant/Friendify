import 'package:flutter/material.dart';

class FriendRequestDialog extends StatefulWidget {
  bool added=null;
  @override
  _FriendRequestDialogState createState() => _FriendRequestDialogState();
}

class _FriendRequestDialogState extends State<FriendRequestDialog> {
  void handleresponse(int f){
    if(f==1)widget.added=true;
    else widget.added=false;
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
            handleresponse(0);
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: Text('Accept request'),
          onPressed: () {
            // Perform the logic to send the friend request
            handleresponse(0);
              
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
