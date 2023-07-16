import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final auth = FirebaseAuth.instance;

  String? _errorMessage;

  void _sendPasswordResetEmail() {
    String email = _emailController.text;

    if (!_isEmailValid(email)) {
      setState(() {
        _errorMessage = 'Please enter a valid email address.';
      });
      return;
    }

    auth.sendPasswordResetEmail(email: email).then((value) {
      // Password reset email sent successfully
      // Show success message to the user
      
      showDialog(context: context, builder: (context){
        return AlertDialog(
          content: Text('Password reset link sent! Please check your email'),
        );
      });
    }).catchError((error) {
      // An error occurred while sending the password reset email
      // Handle the error or display an error message to the user
      String errorMessage = error.toString();
      if (errorMessage.contains('no user record')) {
        errorMessage = 'There is no user record corresponding to this email address.\nThe user may have been deleted.';
      }
      setState(() {
        _errorMessage = errorMessage;
      });
    });
  }

  bool _isEmailValid(String email) {
    // Basic email validation using regular expression
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Enter your Email and we will send you a password reset link\n',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.deepPurple),
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Enter an email:',
                errorText: _errorMessage,
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: _sendPasswordResetEmail,
              child: Text('Reset Password'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurple),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
