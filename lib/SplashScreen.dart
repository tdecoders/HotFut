import 'dart:async';
import 'package:flutter/material.dart';
import 'views/login_screen.dart';
import 'package:my_github/views/welcomeScreen.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  void startTimer() {
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Home();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff000000),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Image.asset(
                  "assets/images/BALL3.gif",
                  // height: size.height * 0.9,
                ),
              ),
              SizedBox(
                height: size.height * 0.1,
              ),
              Text(
                "HOT-FUT",
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.8,
                    color: Colors.white,
                    fontSize: 40),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
