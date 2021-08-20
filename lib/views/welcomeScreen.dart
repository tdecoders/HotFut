import 'package:flutter/material.dart';
import 'package:my_github/utils/constants.dart';
import 'package:my_github/views/register.dart';
import 'login_screen.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xff000000),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 4,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // Positioned(
                  //   top: 100.0,
                  //   left: 0.0,
                  //   right: 0.0,
                  //   child: Container(
                  //     height: 150.0,
                  //     width: double.infinity,
                  //     decoration: BoxDecoration(
                  //       image: DecorationImage(
                  //         image: AssetImage("assets/images/cloth_faded.png"),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Image.asset(
                      "assets/images/welcome.png",
                      width: size.width,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Constants.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    topLeft: Radius.circular(30.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.0),
                    Text(
                      "Welcome to HOT-FUT!",
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(19, 22, 33, 1),
                          ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),

                    SizedBox(
                      height: 20.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return LoginScreen();
                        }));
                      },
                      child: Container(
                        height: 60,
                        width: size.width * 0.8,
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Text(
                            "LOGIN",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return RegisterScreen();
                        }));
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
                            "REGISTER",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1),
                          ),
                        ),
                      ),
                    ),

                    // Let's create a generic button widget
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
