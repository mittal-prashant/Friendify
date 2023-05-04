import 'package:chat/screens/login/login.dart';
import 'package:chat/screens/login/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Welcome screen displays welcome message and skip button', (WidgetTester tester) async {
    // Build the widget tree and trigger a frame
    await tester.pumpWidget(MaterialApp(home: WelcomeScreen()));

    // Verify that the welcome message is displayed
    expect(find.text('Welcome to Friendify \nmessaging app'), findsOneWidget);

    // Verify that the skip button is displayed
    expect(find.text('Skip'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);
    
    // Tap the skip button and verify that the login screen is pushed
    await tester.tap(find.byType(TextButton));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
