import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_bus_tracker/progressdialog.dart';
import 'package:e_bus_tracker/welcome.dart';
import 'package:e_bus_tracker/login.dart';
import 'package:e_bus_tracker/widget/button_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum UserType { passenger, busOperator }

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

final _formkey = GlobalKey<FormState>();
final _auth = FirebaseAuth.instance;

TextEditingController _usernameTextController = TextEditingController();
TextEditingController _passwordTextController = TextEditingController();
TextEditingController _confirmpasswordTextController = TextEditingController();
TextEditingController _emailTextController = TextEditingController();

UserType? _selectedUserType; // Default selected option
String? _errorMessage;

void clearUserInput() {
  _usernameTextController.clear();
  _emailTextController.clear();
  _passwordTextController.clear();
  _confirmpasswordTextController.clear();
}

ValidateForm(BuildContext context) async {
  if (_selectedUserType == null) {
    Fluttertoast.showToast(msg: "Please Select a User Type. ");
  } else if (_usernameTextController.text.isEmpty ||
      _emailTextController.text.isEmpty ||
      _passwordTextController.text.isEmpty ||
      _confirmpasswordTextController.text.isEmpty) {
    Fluttertoast.showToast(msg: "All fields are required");
  } else if (!isValidEmail(_emailTextController.text)) {
    Fluttertoast.showToast(msg: "Invalid Email address. ");
  } else if (_passwordTextController.text.length < 6) {
    Fluttertoast.showToast(
        msg: "Password must be at least 6 characters long. ");
  } else if (_passwordTextController.text !=
      _confirmpasswordTextController.text) {
    Fluttertoast.showToast(msg: "Passwords do not match. ");
  } else {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return ProgressDialog(
            message: "Processing. Please wait...",
          );
        });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => WelcomeScreen(userType: _selectedUserType!),
        // Convert enum to string
      ),
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailTextController.text.trim(),
        password: _passwordTextController.text,
      ); // Account creation successful, navigate to the next screen

      // Store user type and other details in Firestore
      await postDetailsToFirestore(
        _emailTextController.text,
        _selectedUserType == UserType.passenger ? 'passenger' : 'busOperator',
      );

      clearUserInput(); // Call the function to clear user input
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? "Unknown error occurred.";
    }
  }
}

var _isObscured1 = true;
var _isObscured2 = true;

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/images/signupback.png'),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: size.width * 0.08),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 32,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(10)),
                            child: DropdownButton<UserType>(
                              value: _selectedUserType,
                              hint: Text(
                                "Select User Type",
                                style: TextStyle(color: Colors.black),
                              ),
                              dropdownColor: Colors.white,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 36,
                              isExpanded: true,
                              underline: SizedBox(),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              onChanged: (UserType? newValue) {
                                setState(() {
                                  _selectedUserType = newValue!;
                                });
                              },
                              items: [
                                DropdownMenuItem<UserType>(
                                  value: UserType.passenger,
                                  child: Text('Passenger'),
                                ),
                                DropdownMenuItem<UserType>(
                                  value: UserType.busOperator,
                                  child: Text('Bus Operator'),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: _usernameTextController,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                suffixIcon: Padding(
                                  padding:
                                      EdgeInsetsDirectional.only(end: 10.0),
                                  child: Icon(Icons.person),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "User Name",
                                hintStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: _emailTextController,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                suffixIcon: Padding(
                                  padding:
                                      EdgeInsetsDirectional.only(end: 10.0),
                                  child: Icon(Icons.mail),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: _passwordTextController,
                            style: TextStyle(color: Colors.black),
                            obscureText: _isObscured1,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  padding:
                                      EdgeInsetsDirectional.only(end: 10.0),
                                  icon: _isObscured1
                                      ? Icon(Icons.visibility)
                                      : Icon(Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      _isObscured1 = !_isObscured1;
                                    });
                                  },
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: _confirmpasswordTextController,
                            style: TextStyle(color: Colors.black),
                            obscureText: _isObscured2,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  padding:
                                      EdgeInsetsDirectional.only(end: 10.0),
                                  icon: _isObscured2
                                      ? Icon(Icons.visibility)
                                      : Icon(Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      _isObscured2 = !_isObscured2;
                                    });
                                  },
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "Confirm Password",
                                hintStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          if (_errorMessage != null)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                _errorMessage!,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                              height: 50,
                              width: 150,
                              child: ButtonWidget(
                                  title: "Sign Up",
                                  onPress: () {
                                    ValidateForm(context);
                                  })),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Login()));
                                  },
                                  child: Text(
                                    'Login',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Color(0xff4c505b),
                                        fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

void signUp(String email, String password, String role) async {
  CircularProgressIndicator();
  if (_formkey.currentState!.validate()) {
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) => {postDetailsToFirestore(email, role)})
        .catchError((e) {});
  }
}

postDetailsToFirestore(String email, String role) async {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  var user = _auth.currentUser;
  CollectionReference ref = FirebaseFirestore.instance.collection('users');
  await ref.doc(user!.uid).set({'email': email, 'role': role});
}

bool isValidEmail(String email) {
  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return emailRegex.hasMatch(email);
}
