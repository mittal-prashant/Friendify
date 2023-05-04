import 'package:chat/screens/chats/components/chat_body.dart';
import 'package:chat/screens/chats/components/profile_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chat/screens/chats/chats_screen.dart';

void main() {
  testWidgets(
      'Chat screen displays Random body with random button and find user',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ChatsScreen()));
    // Expect to find the "Random" button.
    expect(find.byKey(Key('random')), findsOneWidget);
    // Expect to find the "Find User" button.
    expect(find.text('Find User'), findsOneWidget);
  });

  testWidgets('Pressing Random button with valid name should set randomName',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ChatsScreen()));
    final randomNameField = find.byKey(Key('random'));
    await tester.enterText(randomNameField, '/TEST/');
    final setRandomButton = find.widgetWithText(ElevatedButton, 'Random');
    await tester.tap(setRandomButton);
    await tester.pumpAndSettle();

    expect(setRandomButton, findsOneWidget);
  });

  testWidgets('Pressing Random button with invalid name should show snackbar',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ChatsScreen()));
    final randomNameField = find.byKey(Key('random'));
    await tester.enterText(randomNameField, 'a');
    final setRandomButton = find.widgetWithText(ElevatedButton, 'Random');
    await tester.tap(setRandomButton);
    await tester.pumpAndSettle();

    final snackBarFinder = find.byKey(Key('snackbar'));

    expect(find.text('Random Username Must Be Atleast 5 characters!'),
        findsOneWidget);
    expect(snackBarFinder, findsOneWidget);
  });

  testWidgets('Pressing find User button when randomName is not set',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ChatsScreen()));
    final findUserButton = find.widgetWithText(ElevatedButton, 'Find User');
    await tester.tap(findUserButton);
    await tester.pumpAndSettle();

    final snackBarFinder = find.byKey(Key('snackbar'));
    expect(find.text('Set a Random Username!'), findsOneWidget);
    expect(snackBarFinder, findsOneWidget);
  });

  testWidgets('Pressing find User button when randomName is not set',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ChatsScreen()));
    final findUserButton = find.widgetWithText(ElevatedButton, 'Find User');
    await tester.tap(findUserButton);
    await tester.pumpAndSettle();

    final snackBarFinder = find.byKey(Key('snackbar'));
    expect(find.text('Set a Random Username!'), findsOneWidget);
    expect(snackBarFinder, findsOneWidget);
  });

  testWidgets('Testing Chat Body when no Friends added', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Chat_Body()));
    
    final friendsText = find.text('Looks like you have no friends yet.');
    expect(friendsText, findsOneWidget);
  });

  testWidgets('Testing Profile Body for logout button', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Profile_Body()));

    final logoutButton = find.byType(ElevatedButton);
    await tester.tap(logoutButton);
    
    expect(find.text('Gender: Female'), findsOneWidget);
    expect(find.text('Username: '), findsOneWidget);
    expect(find.text('Email: '), findsOneWidget);
    expect(logoutButton, findsOneWidget);
  });
}
