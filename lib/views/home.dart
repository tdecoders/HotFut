import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_github/controller/phone_authentication.dart';
import 'package:my_github/utils/colors.dart';
import 'package:my_github/utils/size_config.dart';
import 'package:my_github/views/welcomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PhoneController pController = Get.put(PhoneController("", ""));
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light,
            systemNavigationBarDividerColor: Colors.transparent),
        child: SafeArea(
          child: SingleChildScrollView(
            child: GetX<PhoneController>(builder: (controller) {
              // ignore: unrelated_type_equality_checks
              return Container(
                height: SizeConfig.screenHeight -
                    MediaQuery.of(context).padding.top,
                width: SizeConfig.screenWidth,
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.widthMultiplier * 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${controller.mobile.value}',
                      textAlign: TextAlign.center,
                      style: Get.textTheme.bodyText1!.copyWith(
                        color: AppColor.primaryColor,
                        fontSize: SizeConfig.textMultiplier * 4.5,
                        // height: Get.height * 0.036,
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 8,
                    ),
                    Text(
                      'Successfully Logged In',
                      textAlign: TextAlign.center,
                      style: Get.textTheme.bodyText1!.copyWith(
                        color: AppColor.darkColor1,
                        fontSize: SizeConfig.textMultiplier * 3.5,
                        // height: Get.height * 0.036,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        FirebaseAuth auth = FirebaseAuth.instance;
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.remove('loggedIn');
                        auth.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Home();
                            },
                          ),
                        );
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
            }),
          ),
        ),
      ),
    );
  }
}
