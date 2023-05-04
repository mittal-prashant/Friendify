import 'package:chat/screens/login/components/gender_selector.dart';
import 'package:chat/screens/login/login.dart';
import 'package:chat/screens/login/signUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SelectPhotoScreen widget test', () {
    testWidgets('should display avatar images and select an avatar',
        (WidgetTester tester) async {
      final mockGender = 'male';

      await tester.pumpWidget(
        MaterialApp(
          home: SelectPhotoScreen(mockGender),
        ),
      );

      // Ensure the app bar title is displayed
      expect(find.text('Select Avatar'), findsOneWidget);

      // Ensure the "Select" button is disabled by default
      expect(
        tester.widget<ElevatedButton>(find.byType(ElevatedButton)).enabled,
        isFalse,
      );

      // Tap the first avatar image
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();

      // Ensure the selected avatar image has a border
      expect(
        tester
            .widget<Container>(
              find.byType(Container).first,
            )
            .decoration,
        BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: Theme.of(tester.element(find.text('Select Avatar')))
                .primaryColor,
            width: 3,
          ),
        ),
      );

      // Ensure the "Select" button is enabled after selecting an avatar
      expect(
        tester.widget<ElevatedButton>(find.byType(ElevatedButton)).enabled,
        isTrue,
      );

      // Tap the "Select" button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Ensure the screen is popped and the selected avatar image path is returned
      expect(find.byType(SelectPhotoScreen), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets('Test if SignUpPage is rendered', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SignUpPage()));

    final titleFinder = find.text('Register');
    final usernameFinder = find.widgetWithText(TextFormField, 'Username');
    final emailFinder = find.widgetWithText(TextFormField, 'Email');
    final passwordFinder = find.widgetWithText(TextFormField, 'Password');
    final continueButtonFinder =
        find.widgetWithText(ElevatedButton, 'Continue');

    expect(titleFinder, findsOneWidget);
    expect(usernameFinder, findsOneWidget);
    expect(emailFinder, findsOneWidget);
    expect(passwordFinder, findsOneWidget);
    expect(continueButtonFinder, findsOneWidget);
  });

  testWidgets('Test if SignUpPage form is submitted successfully',
      (WidgetTester tester) async {
    // Mock registerUser function
    bool hasRegistered = true;
    registerUser(String username, String email, String password, String gender,
        String avatarImage) async {
      return hasRegistered;
    }

    // Build the widget
    await tester.pumpWidget(MaterialApp(home: SignUpPage()));

    // Enter text into the text form fields
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Username'), 'johndoe');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'), 'johndoe@example.com');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'), 'password123');

    // Select gender
    await tester.tap(find.byType(GenderSelector).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Male').last);
    await tester.pumpAndSettle();

    // Submit the form
    await tester.tap(find.widgetWithText(ElevatedButton, 'Continue'));
    await tester.pumpAndSettle();
  });

  testWidgets('Continue button is disabled when gender is not selected',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SignUpPage()));

    // find the Continue button
    final continueButton = find.widgetWithText(ElevatedButton, 'Continue');

    // tap the Continue button
    await tester.tap(continueButton);

    // wait for the frame to be rendered
    await tester.pump();

    // verify that the button is disabled
    final elevatedButtonFinder = find.byType(ElevatedButton);
    final ElevatedButton elevatedButton =
        elevatedButtonFinder.evaluate().first.widget;
    expect(elevatedButton.enabled, isFalse);
  });
}
