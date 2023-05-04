import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat/main.dart';
import 'package:chat/screens/login/login.dart';
import 'package:chat/screens/chats/chats_screen.dart';

void main() {
  group('MyApp', () {
    testWidgets('should display login screen if user is not logged in',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({'isLoggedIn': false});

      await tester.pumpWidget(MyApp());

      await tester.pump();

      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets(
        'should display progress indicator while waiting for SharedPreferences',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({'isLoggedIn': false});

      await tester.pumpWidget(MyApp());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
