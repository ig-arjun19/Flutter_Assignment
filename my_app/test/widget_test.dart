import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// Import your main app
import 'package:my_app/otp_verification_screen.dart'; // Import OTP screen
import 'package:my_app/home_screen.dart'; // Import HomeScreen
import 'package:my_app/phone_auth_screen.dart'; // Import PhoneAuthScreen

void main() {
  testWidgets('Phone Authentication and OTP Verification', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: PhoneAuthScreen()));

    // Verify the title of the screen
    expect(find.text('Phone Authentication'), findsOneWidget);

    // Enter the phone number
    await tester.enterText(find.byType(TextField), '9011470243'); // Simulating phone number input

    // Tap the SEND CODE button
    await tester.tap(find.text('SEND CODE'));
    await tester.pumpAndSettle(); // Wait for any animations to finish

    // Verify that we are on the OTP Verification screen now
    expect(find.byType(OtpVerificationScreen), findsOneWidget);
    
    // Verify that the OTP input prompt is correct
    expect(find.text('Enter the OTP sent to 1234567890'), findsOneWidget);

    // Enter the OTP
    await tester.enterText(find.byType(TextField), '123456'); // Simulating correct OTP input

    // Tap the VERIFY OTP button
    await tester.tap(find.text('VERIFY OTP'));
    await tester.pumpAndSettle(); // Wait for the navigation

    // Expect to navigate to HomeScreen
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
