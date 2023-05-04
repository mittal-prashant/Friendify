import 'package:chat/screens/messages/components/friend_profile.dart';
import 'package:chat/screens/messages/message_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chat/models/Chat.dart';
import 'package:chat/screens/messages/components/OfflineMessage.dart';

void main() {
  testWidgets('MessagesScreen displays the correct chat information',
      (WidgetTester tester) async {
    // Create a Chat object for testing
    Chat chat = Chat(
        user_id: '1',
        name: 'John Doe',
        gender: 'Male',
        image: 'assets/images/user_2.png',
        email: 'john.doe@gmail.com');

    // Create a list of OfflineMessage objects for testing
    List<OfflineMessage> offlineMessages = [];

    // Build the MessagesScreen widget
    await tester.pumpWidget(
      MaterialApp(
        home: MessagesScreen(
          chat: chat,
          offlinemessages: offlineMessages,
        ),
      ),
    );

    // Verify that the AppBar displays the correct chat information
    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('Male'), findsOneWidget);

    await tester.tap(find.text('John Doe'));
    await tester.pumpAndSettle();

    // Verify that the Friend_Profile screen is pushed onto the navigation stack
    expect(find.byType(Friend_Profile), findsOneWidget);
  });
}
