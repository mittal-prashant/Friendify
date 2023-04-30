import 'package:flutter/material.dart';
import 'package:chat/constants.dart';
import 'package:chat/models/ChatMessage.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({
    Key key,
    @required this.message,
  }) : super(key: key);

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: mainDefaultPadding * 0.75,
          vertical: mainDefaultPadding / 2,
        ),
        decoration: BoxDecoration(
          color: mainPrimaryColor.withOpacity(message.isSender ? 1 : 0.1),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isSender
                ? Colors.white
                : Theme.of(context).textTheme.bodyLarge.color,
          ),
        ),
      ),
    );
  }
}
