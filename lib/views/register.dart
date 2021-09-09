import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_github/controller/phone_authentication.dart';
import 'package:my_github/utils/colors.dart';
import 'package:my_github/utils/loader.dart';
import 'package:my_github/utils/size_config.dart';
import 'package:my_github/widgets/dialog.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final PhoneController pController = Get.put(PhoneController("", ""));
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _firstnameController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  TextEditingController _lastnameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
            child: Stack(
              children: [
                GetX<PhoneController>(
                  builder: (controller) {
                    // ignore: unrelated_type_equality_checks
                    return controller.loading == true
                        ? Loader.dualRingLoader(AppColor.primaryColor)
                        : Container(
                            height: SizeConfig.screenHeight - MediaQuery.of(context).padding.top,
                            width: SizeConfig.screenWidth,
                            padding: EdgeInsets.symmetric(horizontal: SizeConfig.widthMultiplier * 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Enter Your First Name',
                                  style: Get.textTheme.bodyText1!.copyWith(
                                    color: AppColor.darkColor1,
                                    fontSize: SizeConfig.textMultiplier * 2.5,
                                    // height: Get.height * 0.036,
                                  ),
                                ),
                                SizedBox(
                                  height: SizeConfig.heightMultiplier * 1.5,
                                ),
                                TextFormField(
                                  controller: _firstnameController,
                                  keyboardType: TextInputType.text,
                                  style: Get.textTheme.bodyText2!.copyWith(
                                    color: AppColor.blackColor,
                                    fontSize: SizeConfig.textMultiplier * 1.5,
                                    // height: Get.height * 0.036,
                                  ),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.appBlue),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.appBlue),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.primaryColor),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.secondaryColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.appBlue),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.secondaryColor),
                                    ),
                                    hintText: 'Enter First Name',
                                    prefixStyle: Get.textTheme.bodyText2!.copyWith(
                                      color: AppColor.blackColor.withOpacity(0.5),
                                      fontSize: SizeConfig.textMultiplier * 1.5,
                                      // height: Get.height * 0.036,
                                    ),
                                    hintStyle: Get.textTheme.bodyText2!.copyWith(
                                      color: AppColor.blackColor.withOpacity(0.5),
                                      fontSize: SizeConfig.textMultiplier * 1.5,
                                      // height: Get.height * 0.036,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Enter Your Last Name',
                                  style: Get.textTheme.bodyText1!.copyWith(
                                    color: AppColor.darkColor1,
                                    fontSize: SizeConfig.textMultiplier * 2.5,
                                    // height: Get.height * 0.036,
                                  ),
                                ),
                                SizedBox(
                                  height: SizeConfig.heightMultiplier * 1.5,
                                ),
                                TextFormField(
                                  controller: _lastnameController,
                                  keyboardType: TextInputType.text,
                                  style: Get.textTheme.bodyText2!.copyWith(
                                    color: AppColor.blackColor,
                                    fontSize: SizeConfig.textMultiplier * 1.5,
                                    // height: Get.height * 0.036,
                                  ),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.appBlue),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.appBlue),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.primaryColor),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.secondaryColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.appBlue),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.secondaryColor),
                                    ),
                                    hintText: 'Enter Last Name',
                                    prefixStyle: Get.textTheme.bodyText2!.copyWith(
                                      color: AppColor.blackColor.withOpacity(0.5),
                                      fontSize: SizeConfig.textMultiplier * 1.5,
                                      // height: Get.height * 0.036,
                                    ),
                                    hintStyle: Get.textTheme.bodyText2!.copyWith(
                                      color: AppColor.blackColor.withOpacity(0.5),
                                      fontSize: SizeConfig.textMultiplier * 1.5,
                                      // height: Get.height * 0.036,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Enter Your Mobile Number',
                                  style: Get.textTheme.bodyText1!.copyWith(
                                    color: AppColor.darkColor1,
                                    fontSize: SizeConfig.textMultiplier * 2.5,
                                    // height: Get.height * 0.036,
                                  ),
                                ),
                                SizedBox(
                                  height: SizeConfig.heightMultiplier * 1.5,
                                ),
                                TextFormField(
                                  controller: _mobileController,
                                  keyboardType: TextInputType.number,
                                  style: Get.textTheme.bodyText2!.copyWith(
                                    color: AppColor.blackColor,
                                    fontSize: SizeConfig.textMultiplier * 1.5,
                                    // height: Get.height * 0.036,
                                  ),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.appBlue),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.appBlue),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.primaryColor),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.secondaryColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.appBlue),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.secondaryColor),
                                    ),
                                    hintText: 'Mobile Number',
                                    prefixText: '+91-',
                                    prefixStyle: Get.textTheme.bodyText2!.copyWith(
                                      color: AppColor.blackColor.withOpacity(0.5),
                                      fontSize: SizeConfig.textMultiplier * 1.5,
                                      // height: Get.height * 0.036,
                                    ),
                                    hintStyle: Get.textTheme.bodyText2!.copyWith(
                                      color: AppColor.blackColor.withOpacity(0.5),
                                      fontSize: SizeConfig.textMultiplier * 1.5,
                                      // height: Get.height * 0.036,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: SizeConfig.heightMultiplier * 2.5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        if (_firstnameController.text.length == 0) {
                                          DialogWidget.errorDialog(context, 'Enter a valid First Name', () {});
                                        } else if (_lastnameController.text.length == 0) {
                                          DialogWidget.errorDialog(context, 'Enter a valid Last Name', () {});
                                        } else if (_mobileController.text.length == 10) {
                                          bool f = false;
                                          await _firestore.collection("USERS").get().then((querySnapshot) {
                                            querySnapshot.docs.forEach((result) {
                                              if (result.data()["mobile"].toString() == _mobileController.text.toString()) {
                                                f = true;
                                              }
                                            });
                                            if (f == true) {
                                              DialogWidget.errorDialog(context, "Account already Exists!", () {});
                                            } else {
                                              pController.lastName = _lastnameController.text.trim();
                                              pController.firstName = _firstnameController.text.trim();
                                              controller.signInWithPhone(
                                                phoneNumber: _mobileController.text,
                                              );
                                            }
                                          });
                                        } else {
                                          DialogWidget.errorDialog(context, 'Enter a valid mobile number', () {});
                                        }
                                      },
                                      child: Container(
                                        // width: SizeConfig.widthMultiplier * 20,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: SizeConfig.widthMultiplier * 8,
                                            vertical: SizeConfig.heightMultiplier * 1.25),
                                        decoration:
                                            BoxDecoration(color: AppColor.appBlue, borderRadius: BorderRadius.circular(5)),
                                        // ignore: deprecated_member_use
                                        child: Center(
                                          child: Text(
                                            'Continue',
                                            style: Get.textTheme.bodyText2!.copyWith(
                                              color: Colors.white,
                                              fontSize: SizeConfig.textMultiplier * 1.5,
                                              // height: Get.height * 0.036,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
