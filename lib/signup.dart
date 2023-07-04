import 'package:e_bus_tracker/widget/button_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

TextEditingController _usernameTextController = TextEditingController();
TextEditingController _passwordTextController = TextEditingController();
TextEditingController _confirmpasswordTextController = TextEditingController();
TextEditingController _emailTextController = TextEditingController();

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
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                              height: 50,
                              width: 150,
                              child: ButtonWidget(
                                  title: "Sign Up",
                                  onPress: () async {
                                    await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                            email: _emailTextController.text
                                                .trim(),
                                            password:
                                                _passwordTextController.text)
                                        .then((value) {
                                      print("Created New Account");
                                      Navigator.pushNamed(context, 'tfa');
                                      print("ok");
                                    }).onError((error, stackTrace) {
                                      print("Error ${error.toString()}");
                                    });
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
                                    Navigator.pushNamed(context, 'login');
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
