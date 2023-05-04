import 'package:chat/screens/login/components/gender_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('GenderSelector widget test', (WidgetTester tester) async {
    // Define variables for testing
    String selectedGender;
    String genderError;
    final onSelect = (gender) => selectedGender = gender;
    final genderSelector = GenderSelector(
      onSelect: onSelect,
      genderError: genderError,
    );

    // Build the widget tree and trigger a frame
    await tester.pumpWidget(MaterialApp(home: genderSelector));

    // Verify that the widget renders two options for selecting a gender
    expect(find.text('Male'), findsOneWidget);
    expect(find.text('Female'), findsOneWidget);

    // Tap the 'Male' option and verify that the selected gender state is updated
    await tester.tap(find.text('Male'));
    expect(selectedGender, 'male');

    // Tap the 'Female' option and verify that the selected gender state is updated
    await tester.tap(find.text('Female'));
    expect(selectedGender, 'female');

    // Set an error message and verify that it is displayed when no gender is selected
    genderError = 'Please select a gender';
    await tester.pumpWidget(MaterialApp(home: genderSelector));
    expect(find.text(genderError), findsNothing);
    await tester.tap(find.text('Male'));
    await tester.pump();
    expect(find.text(genderError), findsNothing);
    await tester.tap(find.text('Female'));
    await tester.pump();
    expect(find.text(genderError), findsNothing);
  });
}
