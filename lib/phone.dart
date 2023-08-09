import 'package:e_bus_tracker/auth_provider/auth.dart';
import 'package:flutter/material.dart';
import 'package:e_bus_tracker/widget/button_widget.dart';

class TwoFactorAuthScreen extends StatefulWidget {
  const TwoFactorAuthScreen({super.key});

  @override
  State<TwoFactorAuthScreen> createState() => _TwoFactorAuthScreenState();
}

String? _errorMessage;

class _TwoFactorAuthScreenState extends State<TwoFactorAuthScreen> {
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          'Verify Your Phone Number',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 24.0),
              CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage('assets/images/phonenum.png')),
              SizedBox(height: 30.0),
              Text(
                'Please Enter Your Phone Number',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.0),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number(+94xxxxxxxxx)',
                  errorText: _errorMessage,
                ),
              ),
              SizedBox(height: 30.0),
              SizedBox(
                height: 50,
                width: 150,
                child: ButtonWidget(
                  title: "Next",
                  onPress: () {
                    sendPhoneNumber();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sendPhoneNumber() {
    String phoneNumber = phoneController.text;
    AuthProvider ap = new AuthProvider();
    ap.signInWithPhone(context, "$phoneNumber");

    bool isPhoneNumValid(String phoneNumber) {
      phoneNumber = phoneNumber.trim();
      final phoneRegex = RegExp(r'^\+94\d{9}$');
      return phoneRegex.hasMatch(phoneNumber);
    }

    if (!isPhoneNumValid(phoneNumber)) {
      setState(() {
        _errorMessage = 'Please enter a valid phone number.';
      });
      return;
    }

    try {
      AuthProvider ap = AuthProvider();
      ap.signInWithPhone(context, phoneNumber);
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('An error occurred while processing your request.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                ),
              ],
            );
          });
    }
  }
}
