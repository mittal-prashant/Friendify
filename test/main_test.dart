import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat/main.dart';
import 'package:chat/screens/chats/chats_screen.dart';
import 'package:chat/screens/login/login.dart';

void main() {
  group('MyApp', () {
    testWidgets('displays loading indicator when checking login status',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({'isLoggedIn': null});

      await tester.pumpWidget(MyApp());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays LoginScreen when user is not logged in',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({'isLoggedIn': false});

      await tester.pumpWidget(MyApp());

      await tester.pump();

      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('displays ChatsScreen when user is logged in',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({'isLoggedIn': true});

      await tester.pumpWidget(MyApp());
      
      await tester.pump();

      expect(find.byType(ChatsScreen), findsOneWidget);
    });
  });
}
