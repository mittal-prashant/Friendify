import 'package:chat/constants.dart';
import 'package:chat/screens/chats/components/chat_body.dart';
import 'package:flutter/material.dart';

import '../profile/profile_view.dart';
import 'components/profile_body.dart';
import 'components/random_body.dart';

class ChatsScreen extends StatefulWidget {
  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  String page_title = 'Chats';
  int _selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: _selectedIndex == 0
          ? Random_Body()
          : _selectedIndex == 1
              ? Chat_Body()
              : Profile_Body(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   backgroundColor: mainPrimaryColor,
      //   child: Icon(
      //     Icons.person_add_alt_1,
      //     color: Colors.white,
      //   ),
      // ),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: (value) {
        setState(() {
          _selectedIndex = value;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = 0;
                page_title = "Chats";
              });
            },
            child: CircleAvatar(
              radius: 14,
              child: Icon(Icons.chat_bubble),
            ),
          ),
          label: "Chats",
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = 1;
                page_title = "People";
              });
            },
            child: CircleAvatar(
              radius: 14,
              child: Icon(Icons.people),
            ),
          ),
          label: "People",
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = 2;
                page_title = "Profile";
              });
            },
            child: CircleAvatar(
              radius: 14,
              backgroundImage: AssetImage("assets/images/user_2.png"),
            ),
          ),
          label: "Profile",
        ),
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(page_title),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.search),
        )
      ],
    );
  }
}
