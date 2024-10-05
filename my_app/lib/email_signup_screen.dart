import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmailSignupScreen extends StatefulWidget {
  const EmailSignupScreen({super.key});

  @override
  _EmailSignupScreenState createState() => _EmailSignupScreenState();
}

class _EmailSignupScreenState extends State<EmailSignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _referralController = TextEditingController();

  bool _isLoading = false;

  Future<void> signUp() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String referralCode = _referralController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Please enter your email and password');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var url = Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/email/referral');
      var response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'referralCode': referralCode.isNotEmpty ? referralCode : null,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        _showSnackBar('Signup successful! Redirecting...');
        Navigator.pushReplacementNamed(context, '/home'); // Navigate to home page
      } else if (response.statusCode == 409) {
        // If email already exists, redirect to home page
        _showSnackBar('Email already exists, redirecting to home page...');
        Navigator.pushReplacementNamed(context, '/home'); // Navigate to home page
      } else {
        String errorMessage = json.decode(response.body)['data']['message'] ?? 'Signup failed. Please try again.';
        _showSnackBar(errorMessage);
      }
    } catch (error) {
      _showSnackBar('An error occurred: $error');
    } finally {
      setState(() {
        _isLoading = false; // Stop loading indicator
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
        title: const Text('Email Signup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Let's Begin!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text('Please enter your credentials to proceed'),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Your Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Create Password',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.visibility_off),  // Eye icon to toggle password visibility
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _referralController,
              decoration: const InputDecoration(
                labelText: 'Referral Code (Optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : signUp, // Disable button while loading
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.all(16),
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text('SIGN UP'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
