import 'package:chat/screens/chats/chats_screen.dart';
import 'package:chat/screens/login/signIn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat/providers/login_provider.dart';

void main() {
  testWidgets('should show snackbar if invalid credentials',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'isVerified': true});

    await tester.pumpWidget(GetMaterialApp(
      home: SignInPage(),
    ));

    final usernameField = find.byKey(Key('username'));
    final passwordField = find.byKey(Key('password'));
    final loginButton = find.byType(ElevatedButton);

    await tester.enterText(usernameField, 'invalid_user');
    await tester.enterText(passwordField, 'invalid_password');
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    final snackBarFinder = find.byKey(Key('snackbar'));
    expect(snackBarFinder, findsOneWidget);

    expect(find.text('Invalid Username or Password!'), findsOneWidget);
  });

  testWidgets('should show snackbar if email is not verified',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'isVerified': false});

    await tester.pumpWidget(GetMaterialApp(
      home: SignInPage(),
    ));

    final usernameField = find.byKey(Key('username'));
    final passwordField = find.byKey(Key('password'));
    final loginButton = find.byType(ElevatedButton);

    await tester.enterText(usernameField, 'valid_user');
    await tester.enterText(passwordField, 'valid_password');
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(find.text('Email is not verified!'), findsOneWidget);
  });

  testWidgets('should navigate to ChatsScreen if valid credentials',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'isVerified': true});

    // loginMockSuccess = true;

    await tester.pumpWidget(GetMaterialApp(
      home: SignInPage(),
    ));

    final usernameField = find.byKey(Key('username'));
    final passwordField = find.byKey(Key('password'));
    final loginButton = find.byType(ElevatedButton);

    await tester.enterText(usernameField, 'valid_user');
    await tester.enterText(passwordField, 'valid_password');
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(find.byType(ChatsScreen), findsOneWidget);
  });
}
