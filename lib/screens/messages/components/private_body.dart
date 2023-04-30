import 'package:chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:chat/screens/messages/components/chat_input_field.dart';
import 'package:chat/models/ChatMessage.dart';
import 'package:chat/screens/messages/components/message.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat/screens/messages/components/OfflineMessage.dart';

class Body extends StatefulWidget {
  final IO.Socket socket;
  final String friendid;
  List<OfflineMessage> offlinemessages;

  Body(
      {@required this.socket,
      @required this.friendid,
      @required this.offlinemessages});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<ChatMessage> messages = [];

  String user_id;
  final _textinputcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
    print(widget.offlinemessages);
    if (widget.offlinemessages != null) {
      loadofflinemessages();
    }
    widget.socket.on(
      'msg-recieve',
      (data) => {
        print("this is msg receive event"),
        print(data),
        setState(() {
          String messg = data['message'];
          bool f = (user_id == data['from']);
          if (!f) {
            ChatMessage msg = ChatMessage(
                messageType: ChatMessageType.text,
                messageStatus: MessageStatus.viewed,
                isSender: false,
                text: messg);

            messages.add(msg);
          }
        })
      },
    );
  }

  @override
  void dispose() {
    _textinputcontroller.dispose();
    super.dispose();
  }

  void loadofflinemessages() {
    print("ddd");
    setState(() {
      print("dddddddffffffffffhhhhhhh");
      for (OfflineMessage message in widget.offlinemessages) {
        // print(message.senderid);
        // print(message.message);
        print(message.senderid == widget.friendid);
        if (message.senderid == widget.friendid) {
          messages.add(ChatMessage(
              messageType: ChatMessageType.text,
              messageStatus: MessageStatus.viewed,
              isSender: false,
              text: message.message));
        }
      }

      // widget.offlinemessages.map((chat) {
      //   // print(chat.toString());
      //   if (chat.senderid == widget.friendid) {
      //     messages.add(ChatMessage(
      //       messageType: ChatMessageType.text,
      //       messageStatus: MessageStatus.viewed,
      //       isSender: false,
      //       text: chat.message,
      //     ));
      //   }
      // });
    });
  }

  void handlesend() {
    widget.socket.emit("send-msg", {
      'from': user_id,
      'to': widget.friendid,
      'message': _textinputcontroller.text.toString(),
    });
    setState(() {
      ChatMessage msg = ChatMessage(
          messageType: ChatMessageType.text,
          messageStatus: MessageStatus.viewed,
          isSender: true,
          text: _textinputcontroller.text.toString());

      _textinputcontroller.clear();
      messages.add(msg);
    });
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      user_id = prefs.getString('userId');
    });
  }

  // Body({@required this.messages});
  @override
  Widget build(BuildContext context) {
    if (widget.offlinemessages != null) {
      for (OfflineMessage message in widget.offlinemessages) {
        print(message.senderid);
        print(message.message);
      }
    }
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: mainDefaultPadding),
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) => Message(
                message: messages[index],
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: mainDefaultPadding,
            vertical: mainDefaultPadding / 2,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 4),
                blurRadius: 32,
                color: Color(0xFF087949).withOpacity(0.08),
              )
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                Icon(
                  Icons.mic,
                  color: mainPrimaryColor,
                ),
                SizedBox(
                  width: mainDefaultPadding,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: mainDefaultPadding * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: mainPrimaryColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => {},
                          icon: Icon(
                            Icons.sentiment_satisfied_alt_outlined,
                            color: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                .color
                                .withOpacity(0.64),
                          ),
                        ),
                        SizedBox(width: mainDefaultPadding / 4),
                        Expanded(
                          child: TextField(
                            controller: _textinputcontroller,
                            decoration: InputDecoration(
                              hintText: "Type message",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        // Icon(
                        //   Icons.attach_file,
                        //   color: Theme.of(context)
                        //       .textTheme
                        //       .bodyLarge
                        //       .color
                        //       .withOpacity(0.64),
                        // ),
                        SizedBox(width: mainDefaultPadding / 4),
                        IconButton(
                          onPressed: () => {handlesend()},
                          icon: Icon(
                            Icons.send,
                            color: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                .color
                                .withOpacity(0.64),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
