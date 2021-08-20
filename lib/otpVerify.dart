import 'package:flutter/material.dart';
import 'package:my_github/widgets/dialog.dart';

class otpVerify extends StatefulWidget {
  @override
  _otpVerifyState createState() => _otpVerifyState();
}

class _otpVerifyState extends State<otpVerify> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "You Have Entered Invalid OTP!!! Please re-check the OTP and try again.",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w600,
              fontSize: 21,
              letterSpacing: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 40,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: 60,
              width: size.width * 0.8,
              margin: const EdgeInsets.symmetric(horizontal: 15),
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(40),
                color: Colors.black,
              ),
              child: Center(
                child: Text(
                  "OK",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
