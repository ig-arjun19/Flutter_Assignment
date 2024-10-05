import 'package:flutter/material.dart';
import 'phone_auth_screen.dart';
import 'email_signup_screen.dart';
import 'otp_verification_screen.dart';  // Import the OTP screen
import 'home_screen.dart';  // Import the Home screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Auth Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Define the initial screen (PhoneAuthScreen) as the home screen
      home: const PhoneAuthScreen(),
      routes: {
        '/phoneAuth': (context) => const PhoneAuthScreen(),
        '/emailSignup': (context) => const EmailSignupScreen(),
        '/otpVerification': (context) => const OtpVerificationScreen(phoneNumber: ''),  // Add OTP screen route (temp phone)
        '/home': (context) => const  HomeScreen(),  // Home page after successful OTP verification
      },
    );
  }
}
