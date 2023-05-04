import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/mockito.dart';
import 'package:chat/screens/messages/components/friend_profile.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  // create a mock SharedPreferences instance
  MockSharedPreferences mockSharedPreferences = MockSharedPreferences();

  group('Friend_Profile Widget Test', () {
    testWidgets('Should render Friend_Profile widget',
        (WidgetTester tester) async {
      // set the expected data for the widget

      SharedPreferences.setMockInitialValues({
        'friend_name': 'John Doe',
        'friend_gender': 'male',
        'friend_avatar': 'assets/images/user_2.png',
        'friend_rating': 3.5,
        'friend_ratedby': 10
      });

      // build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Friend_Profile('dummy_tester_account'),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Username: John Doe'), findsOneWidget);
    });
  });
}
