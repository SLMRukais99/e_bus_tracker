/*import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e_bus_tracker/login.dart';

void main() {
  testWidgets('Login Widget Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const Login());

    // Check if the login screen is displayed.
    expect(find.text('Login'), findsOneWidget);

    // Enter invalid email and password and try to login.
    await tester.enterText(find.byType(TextFormField).first, 'invalid_email');
    await tester.enterText(find.byType(TextFormField).last, 'short');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Check if error messages are displayed.
    expect(find.text('Please Enter Your Email'), findsOneWidget);
    expect(find.text('Password is required for login'), findsOneWidget);

    // Clear text fields.
    await tester.enterText(find.byType(TextFormField).first, '');
    await tester.enterText(find.byType(TextFormField).last, '');

    // Enter valid email and password and try to login.
    await tester.enterText(
        find.byType(TextFormField).first, 'valid_email@example.com');
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Check if error messages are cleared.
    expect(find.text('Please Enter Your Email'), findsNothing);
    expect(find.text('Password is required for login'), findsNothing);
  });
}*/
