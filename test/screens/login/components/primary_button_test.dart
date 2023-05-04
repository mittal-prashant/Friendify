import 'package:chat/screens/login/components/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PrimaryButton widget', () {
    const buttonText = 'Continue';
    final mockOnPressed = () => print('Button Pressed!');
    testWidgets('should render properly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: buttonText,
              press: mockOnPressed,
            ),
          ),
        ),
      );

      // find widgets
      final buttonWidget = find.byType(MaterialButton);
      final textWidget = find.text(buttonText);

      // assert widgets
      expect(buttonWidget, findsOneWidget);
      expect(textWidget, findsOneWidget);
    });

    testWidgets('should call press function when button is pressed',
        (WidgetTester tester) async {
      var pressed = false;
      void onPressed() {
        pressed = true;
      }

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: buttonText,
              press: onPressed,
            ),
          ),
        ),
      );

      // tap button
      await tester.tap(find.text(buttonText));
      await tester.pumpAndSettle();

      // assert function called
      expect(pressed, true);
    });
  });
}
