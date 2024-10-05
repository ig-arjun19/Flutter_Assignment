import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'otp_verification_screen.dart'; // Import OTP screen
import 'email_signup_screen.dart'; // Import email signup screen

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;
Future<bool> sendPhoneNumber() async {
    final String phoneNumber = _phoneController.text.trim();
    String deviceId = "62b341aeb0ab5ebe28a758a3"; // Replace with the actual device ID if necessary

    // Validate phone number format
    if (phoneNumber.isEmpty || !RegExp(r'^[0-9]+$').hasMatch(phoneNumber)) {
        _showSnackBar('Please enter a valid phone number');
        return false;
    }

    setState(() {
        _isLoading = true;
    });

    try {
        var url = Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/otp'); // Your backend API
        var response = await http.post(
            url,
            body: json.encode({
                'mobileNumber': phoneNumber,
                'deviceId': deviceId
            }),
            headers: {
                'Content-Type': 'application/json',
            },
        );

        // Log the response status and body
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
            _showSnackBar('OTP sent to $phoneNumber');
            return true; // OTP sent successfully
        } else {
            _showSnackBar('Failed to send OTP. Please try again.');
            return false;
        }
    } catch (error) {
        _showSnackBar('Error: $error');
        return false;
    } finally {
        setState(() {
            _isLoading = false;
        });
    }
}

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Authentication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Glad to see you!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text('Please provide your phone number'),
            const SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        bool success = await sendPhoneNumber();

                        if (success) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OtpVerificationScreen(
                                phoneNumber: _phoneController.text,
                              ),
                            ),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding: const EdgeInsets.all(16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('SEND CODE'),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Navigate to the email signup screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EmailSignupScreen()),
                );
              },
              child: const Text('Sign up with Email'),
            ),
          ],
        ),
      ),
    );
  }
}
