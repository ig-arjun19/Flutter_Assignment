import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({super.key, required this.phoneNumber});

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

  Future<void> verifyOtp() async {
    final String otpCode = _otpController.text.trim();

    if (otpCode.isEmpty) {
      _showSnackBar('Please enter the OTP code');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Replace with actual logic to get deviceId and userId dynamically
    String deviceId = "62b43472c84bb6dac82e0504"; // Example Device ID
    String userId = "62b43547c84bb6dac82e0525"; // Example User ID

    try {
      var url = Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/otp/verification');

      // Debug log for request body
      print('Request body: ${json.encode({
        'phone': widget.phoneNumber,
        'otp': otpCode,
        'deviceId': deviceId,
        'userId': userId,
      })}');

      var response = await http.post(
        url,
        body: json.encode({
          'phone': widget.phoneNumber,
          'otp': otpCode,
          'deviceId': deviceId,
          'userId': userId,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      // Debug log for response
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (mounted) {
        if (response.statusCode == 200) {
          // OTP verification successful
          _showSnackBar('OTP verified successfully!');
          Navigator.pushReplacementNamed(context, '/home'); // Navigate to home page
        } else {
          // OTP verification failed
          _showSnackBar('Invalid OTP. Please try again.');
        }
      }
    } catch (error) {
      if (mounted) {
        _showSnackBar('An error occurred: $error');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // Stop loading indicator
        });
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              'Enter the OTP sent to ${widget.phoneNumber}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'OTP Code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : verifyOtp,  // Disable button while loading
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.all(16),
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text('VERIFY OTP'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
