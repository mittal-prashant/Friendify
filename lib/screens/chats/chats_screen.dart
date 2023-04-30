import 'package:chat/constants.dart';
import 'package:chat/screens/chats/components/chat_body.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/profile_body.dart';
import 'components/random_body.dart';

class ChatsScreen extends StatefulWidget {
  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  String page_title = 'Chats';
  int _selectedIndex = 0;
  bool _showSearch = true;
  String avatarImage = '';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      avatarImage = prefs.getString('avatarImage');
    });
  }

  void _toggleSearch() {
    setState(() {
      _showSearch = !_showSearch;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: _selectedIndex == 0
          ? Random_Body()
          : _selectedIndex == 1
              ? Chat_Body()
              : Profile_Body(),
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
                _showSearch = false;
              });
            },
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 14,
              child: Icon(
                Icons.chat_bubble,
                color: Colors.grey,
              ),
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
                _showSearch = true;
              });
            },
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 14,
              child: Icon(
                Icons.people,
                color: Colors.grey,
              ),
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
                _showSearch = false;
              });
            },
            child: avatarImage != ""
                ? CircleAvatar(
                    radius: 14,
                    backgroundImage: AssetImage(avatarImage),
                  )
                : CircleAvatar(
                    backgroundColor: Colors.transparent,
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
        if (_showSearch)
          IconButton(
            onPressed: _toggleSearch,
            icon: Icon(Icons.search),
          ),
      ],
    );
  }
}
