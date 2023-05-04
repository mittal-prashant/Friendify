import 'package:chat/models/Chat.dart';
import 'package:flutter/material.dart';
import 'package:chat/constants.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({
    Key key,
    @required this.chat,
    @required this.press,
  }) : super(key: key);

  final Chat chat;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    IconData genderIcon;
    Color genderColor;

    if (chat.gender == 'male') {
      genderIcon = Icons.male;
      genderColor = Colors.blue;
    } else if (chat.gender == 'female') {
      genderIcon = Icons.female;
      genderColor = Colors.pink;
    } else {
      // Default icon and color when gender is unknown or other value
      genderIcon = Icons.help_outline;
      genderColor = Colors.grey;
    }

    return InkWell(
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: mainDefaultPadding,
            vertical: mainDefaultPadding * 0.75),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage(chat.image),
                ),
                // if (chat.isActive)
                //   Positioned(
                //     right: 0,
                //     bottom: 0,
                //     child: Container(
                //       height: 16,
                //       width: 16,
                //       decoration: BoxDecoration(
                //         color: mainPrimaryColor,
                //         shape: BoxShape.circle,
                //         border: Border.all(
                //             color: Theme.of(context).scaffoldBackgroundColor,
                //             width: 3),
                //       ),
                //     ),
                //   )
              ],
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: mainDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat.name,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 8),
                    Opacity(
                      opacity: 0.64,
                      child: Text(
                        chat.email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Icon(
              genderIcon,
              color: genderColor,
            ),
          ],
        ),
      ),
    );
  }
}
