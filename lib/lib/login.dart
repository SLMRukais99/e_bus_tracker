import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/signupback.jpg'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 29.0, top: 330.0),
              child: Text(
                'Login',
                style: TextStyle(color: Colors.deepPurple, fontSize: 32, fontWeight: FontWeight.w700),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.47),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          TextField(
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "User Name",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextField(
                            style: TextStyle(),
                            obscureText: true,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
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
                                      onPressed: () {
                                        // Navigate to Home page
                                      },
                                      child: Text('Log in',
                                        style: TextStyle(color: Colors.white, fontSize: 25),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.deepPurple,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25.0),
                                          )
                                      ),
                                    )
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Don't have an account",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(context, 'signup');
                                        },
                                        child: Text(
                                          'Sign Up',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              decoration: TextDecoration.underline,
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
                                      color: Colors.black,
                                      fontSize: 18),
                                ),
                                SizedBox(
                                    height: 40,
                                    width: 150,
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      child: Text('Google',
                                        style: TextStyle(color: Color(0xff4c505b), fontSize: 18),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey.shade100,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25.0),
                                          )
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

