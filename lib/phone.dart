import 'package:e_bus_tracker/auth_provider/auth.dart';
import 'package:flutter/material.dart';
import 'package:e_bus_tracker/widget/button_widget.dart';

class TwoFactorAuthScreen extends StatefulWidget {
  const TwoFactorAuthScreen({super.key});

  @override
  State<TwoFactorAuthScreen> createState() => _TwoFactorAuthScreenState();
}

class _TwoFactorAuthScreenState extends State<TwoFactorAuthScreen> {
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          'Verify Your Account',
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
              CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage('assets/images/phonenum.png')),
              SizedBox(height: 24.0),
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
  }
}
