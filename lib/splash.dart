import 'package:flutter/material.dart';

class SplashScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/Background.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 160, // adjust the position of the button as needed
              left: 85,
              child: SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'signup');
                  },
                  child: Text('Sign up',
                      style: TextStyle(
                        color: Colors.white,
                      )),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      )),
                ),
              ),
            ),
            Positioned(
              bottom: 160,
              right: 85,
              child: SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'login');
                  },
                  child: Text(
                    'Log in',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      )),
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Container(
                child: Column(
                  children: [
                    Text(
                      'By Continuing, you agree with our',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Terms of Service ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'and ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'Privacy Policy',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
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
