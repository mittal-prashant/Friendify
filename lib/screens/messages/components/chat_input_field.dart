import 'package:flutter/material.dart';
import 'package:chat/constants.dart';

class ChatInputField extends StatelessWidget {
  const ChatInputField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
            // Icon(
            //   Icons.mic,
            //   color: mainPrimaryColor,
            // ),
            // SizedBox(
            //   width: mainDefaultPadding,
            // ),
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
                    Icon(
                      Icons.sentiment_satisfied_alt_outlined,
                      color: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          .color
                          .withOpacity(0.64),
                    ),
                    SizedBox(width: mainDefaultPadding / 4),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Type message",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.attach_file,
                      color: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          .color
                          .withOpacity(0.64),
                    ),
                    SizedBox(width: mainDefaultPadding / 4),
                    Icon(
                      Icons.camera_alt_outlined,
                      color: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          .color
                          .withOpacity(0.64),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
