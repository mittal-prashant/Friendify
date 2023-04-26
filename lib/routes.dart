import 'package:chat/screens/chats/chats_screen.dart';
import 'package:chat/screens/login/login.dart';
import 'package:chat/screens/login/signIn.dart';
import 'package:chat/screens/login/signUp.dart';
import 'package:chat/screens/messages/message_screen.dart';
import 'package:chat/screens/welcome/welcome_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String signin = '/signin';
  static const String signup = '/signup';
  static const String chat = '/chat';
  static const String message = '/message';

  static List<GetPage> pages = [
    GetPage(name: welcome, page: () => WelcomeScreen()),
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: signin, page: () => SignInPage()),
    GetPage(name: signup, page: () => SignUpPage()),
    GetPage(name: message, page: () => MessagesScreen()),
    GetPage(name: chat, page: () => ChatsScreen()),
  ];
}
