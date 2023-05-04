import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chat/screens/login/login.dart';
import 'package:chat/screens/login/signIn.dart';
import 'package:chat/screens/login/signUp.dart';

void main() {
  testWidgets('Login screen displays Sign In and Sign Up buttons',
      (WidgetTester tester) async {
    // Build the LoginScreen widget.
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));

    // Expect to find the "Sign In" button.
    expect(find.text('Sign In'), findsOneWidget);

    // Expect to find the "Sign Up" button.
    expect(find.text('Sign Up'), findsOneWidget);
  });

  testWidgets('Pressing Sign In button should navigate to Sign In screen',
      (WidgetTester tester) async {
    // Build the LoginScreen widget.
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));

    // Tap the "Sign In" button.
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    // Expect to find the SignInPage widget.
    expect(find.byType(SignInPage), findsOneWidget);
  });

  testWidgets('Pressing Sign Up button should navigate to Sign Up screen',
      (WidgetTester tester) async {
    // Build the LoginScreen widget.
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));

    // Tap the "Sign Up" button.
    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();

    // Expect to find the SignUpPage widget.
    expect(find.byType(SignUpPage), findsOneWidget);
  });
}
