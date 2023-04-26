import 'package:chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:chat/screens/messages/components/chat_input_field.dart';
import 'package:chat/models/ChatMessage.dart';
import 'package:chat/screens/messages/components/message.dart';


class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: mainDefaultPadding),
            child: ListView.builder(
              itemCount: demoChatMessages.length,
              itemBuilder: (context, index) => Message(
                message: demoChatMessages[index],
              ),
            ),
          ),
        ),
        ChatInputField(),
      ],
    );
  }
}