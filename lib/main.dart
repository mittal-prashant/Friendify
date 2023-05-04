import 'package:chat/screens/chats/chats_screen.dart';
import 'package:chat/screens/login/login.dart';
import 'package:chat/screens/login/welcome/welcome_screen.dart';
import 'package:chat/theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance()
          .then((prefs) => prefs.getBool('isLoggedIn')),
      builder: (context, snapshot) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightThemeData(context),
        darkTheme: darkThemeData(context),
        title: 'Friendify',
        home: snapshot.connectionState == ConnectionState.waiting
            ? Scaffold(body: Center(child: CircularProgressIndicator()))
            : snapshot.hasData && snapshot.data == true
                ? ChatsScreen()
                : LoginScreen(),
      ),
    );
  }
}
