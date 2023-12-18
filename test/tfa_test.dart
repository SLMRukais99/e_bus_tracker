/*import 'package:e_bus_tracker/tfa.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinput/pinput.dart';

void main() {
  testWidgets('VerifyAccountScreen UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: VerifyAccountScreen(
          verificationId: 'mockVerificationId',
          phone: '1234567890',
        ),
      ),
    );

    // Verify that the initial UI is correct.
    expect(find.text('Verify Your Account'), findsOneWidget);
    expect(
      find.text('Please enter the 6 digit code sent to your phone 1234567890'),
      findsOneWidget,
    );

    // Enter OTP in the Pinput widget.
    await tester.enterText(find.byType(Pinput), '123456');

    // Verify that the entered OTP is correct.
    expect(find.text('123456'), findsOneWidget);

    // Tap the 'Verify' button.
    await tester.tap(find.text('Verify'));
    await tester.pumpAndSettle();
  });
}*/
