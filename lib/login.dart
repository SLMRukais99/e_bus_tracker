import 'package:e_bus_tracker/forgot_password.dart';
import 'package:e_bus_tracker/phone.dart';
import 'package:e_bus_tracker/services/firebase_services.dart';
import 'package:e_bus_tracker/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  static const routeName = "Login";
  @override
  State<Login> createState() => _LoginState();
}

TextEditingController _passwordTextController = TextEditingController();
TextEditingController _emailTextController = TextEditingController();

var _isObscured = true;

class _LoginState extends State<Login> {
  String? _emailError;
  String? _passwordError;

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
                      'Login',
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
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 35, right: 35),
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _emailTextController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return ("Please Enter Your Email");
                                    }
                                    if (!RegExp(
                                            "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                        .hasMatch(value)) {
                                      return ("Please Enter a valid Email");
                                    }
                                    return null;
                                  },
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    suffixIcon: Padding(
                                      padding:
                                          EdgeInsetsDirectional.only(end: 10.0),
                                      child: Icon(Icons.mail),
                                    ),
                                    hintText: "Email",
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    errorText: _emailError,
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                TextFormField(
                                  controller: _passwordTextController,
                                  validator: (value) {
                                    RegExp regex = new RegExp(r'^.{6,}$');
                                    if (value!.isEmpty) {
                                      return ("Password is required for login");
                                    }
                                    if (!regex.hasMatch(value)) {
                                      return ("Please enter valid password(min. 6 character)");
                                    }
                                  },
                                  style: TextStyle(),
                                  obscureText: _isObscured,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      padding:
                                          EdgeInsetsDirectional.only(end: 10.0),
                                      icon: _isObscured
                                          ? Icon(Icons.visibility)
                                          : Icon(Icons.visibility_off),
                                      onPressed: () {
                                        setState(() {
                                          _isObscured = !_isObscured;
                                        });
                                      },
                                    ),
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    hintText: "Password",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    errorText: _passwordError,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ForgotPasswordScreen()));
                                          },
                                          child: Text(
                                            'Forgot Password?',
                                            style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Color(0xff4c505b),
                                              fontSize: 18,
                                            ),
                                          )),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      SizedBox(
                                          height: 50,
                                          width: 150,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              String email =
                                                  _emailTextController.text
                                                      .trim();
                                              String password =
                                                  _passwordTextController.text;

                                              if (email.isEmpty) {
                                                setState(() {
                                                  _emailError =
                                                      "Please Enter Your Email";
                                                  _passwordError = null;
                                                });
                                                return;
                                              }

                                              if (!RegExp(
                                                      r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\.[a-z]")
                                                  .hasMatch(email)) {
                                                setState(() {
                                                  _emailError =
                                                      "Please Enter a valid Email";
                                                  _passwordError = null;
                                                });
                                                return;
                                              }

                                              if (password.isEmpty) {
                                                setState(() {
                                                  _passwordError =
                                                      "Password is required for login";
                                                  _emailError = null;
                                                });
                                                return;
                                              }

                                              RegExp regex = RegExp(r'^.{6,}$');
                                              if (!regex.hasMatch(password)) {
                                                setState(() {
                                                  _passwordError =
                                                      "Please enter valid password (min. 6 characters)";
                                                  _emailError = null;
                                                });
                                                return;
                                              }

                                              // If the validation passes, attempt to sign in.
                                              await FirebaseAuth.instance
                                                  .signInWithEmailAndPassword(
                                                      email: email,
                                                      password: password)
                                                  .then((value) {
                                                // Success, navigate to the next screen.
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            TwoFactorAuthScreen()));
                                              }).onError((error, stackTrace) {
                                                // Error during sign-in, print the error.
                                                print(
                                                    "Error ${error.toString()}");
                                                // Show a generic error message.
                                                setState(() {
                                                  _passwordError =
                                                      "Invalid email or password";
                                                  _emailError = null;
                                                });
                                              });
                                            },
                                            child: Text(
                                              'Log in',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.deepPurple,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25.0),
                                                )),
                                          )),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Don't have an account",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const SignUp()));
                                              },
                                              child: Text(
                                                'Sign Up',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    color: Color(0xff4c505b),
                                                    fontSize: 18),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Or continue with",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 18),
                                      ),
                                      SizedBox(
                                          height: 40,
                                          width: 135,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              await FirebaseServices()
                                                  .signInWithGoogle();
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          TwoFactorAuthScreen()));
                                            },
                                            child: Row(
                                              children: <Widget>[
                                                Image.asset(
                                                  "assets/images/googlelogo.png",
                                                  width: 35,
                                                  height: 30,
                                                ),
                                                Text(
                                                  'Google',
                                                  style: TextStyle(
                                                      color: Color(0xff4c505b),
                                                      fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.grey.shade100,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25.0),
                                                )),
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
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
