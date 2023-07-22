import 'package:e_bus_tracker/utils/utils.dart';
import 'package:e_bus_tracker/verified.dart';
import 'package:e_bus_tracker/widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'auth_provider/auth.dart';

class VerifyAccountScreen extends StatefulWidget {
  final String verificationId;
  final String phone;
  VerifyAccountScreen(
      {super.key, required this.verificationId, required this.phone});

  @override
  _VerifyAccountScreenState createState() => _VerifyAccountScreenState();
}

class _VerifyAccountScreenState extends State<VerifyAccountScreen> {
  String? otpCode;

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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/Twofactor.png',
                width: 200,
                height: 200,
              ),
              SizedBox(height: 24.0),
              Text(
                'Please enter the 6 digit code sent to your phone ${widget.phone}',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              Pinput(
                length: 6,
                showCursor: true,
                defaultPinTheme: PinTheme(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.purple.shade200,
                    ),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onCompleted: (value) {
                  setState(() {
                    otpCode = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive a pin?",
                    style: TextStyle(fontSize: 16),
                  ),
                  TextButton(
                    onPressed: resendCode,
                    child: Text(
                      'Resend',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 24.0,
              ),
              SizedBox(
                  height: 50,
                  width: 150,
                  child: ButtonWidget(
                    title: "Verify",
                    onPress: () {
                      if (otpCode != null) {
                        verifyOtp(context, otpCode!);
                      } else {
                        showSnackBar(context, "Enter 6-Digit code");
                      }
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }

  // verify otp
  void verifyOtp(BuildContext context, String userOtp) {
    AuthProvider ap = new AuthProvider();
    ap.verifyOtp(
      context: context,
      verificationId: widget.verificationId,
      userOtp: userOtp,
      onSuccess: () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => VerificationScreen(),
            ),
            (route) => false);
      },
    );
  }

  void resendCode() {
    String phoneNumber = "${widget.phone}";
    AuthProvider ap = new AuthProvider();
    ap.signInWithPhone(context, "$phoneNumber");
  }
}
