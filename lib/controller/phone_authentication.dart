import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:my_github/otpVerify.dart';
import 'package:my_github/views/home.dart';
import 'package:my_github/views/otp_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhoneController extends GetxController {
  PhoneController(this.firstName, this.lastName);

  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) =>
      String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  FirebaseAuth auth = FirebaseAuth.instance;

  var status = "".obs;
  var mobile = "".obs;
  var loading = false.obs;
  var codeSent = 'no'.obs;
  var verificationID = '1'.obs;
  var firstName = "";
  var lastName = "";

  var gStatus = 0.obs;
  // ignore: non_constant_identifier_names
  int get google_status_result => gStatus.value;
  // ignore: non_constant_identifier_names
  String get status_result => status.value;
  // ignore: non_constant_identifier_names
  String get codeSent_result => codeSent.value;
  // ignore: non_constant_identifier_names
  String get verId_result => verificationID.value;
  bool get loadingResult => loading.value;

  signInWithPhone({
    required String phoneNumber,
  }) async {
    loading.value = true;
    await auth.verifyPhoneNumber(
      // Phone Number
      phoneNumber: '+91' + phoneNumber,
      //Triggers if Number verification completed
      verificationCompleted: (val) {
        loading.value = false;
      },
      //Triggers if verification fails
      verificationFailed: (FirebaseAuthException exception) {
        status.value = "Verification failed";
        loading.value = false;
      },
      //Triggers if firebase sends you the code
      codeSent: (val, id) {
        codeSent.value = "yes";
        verificationID.value = val;
        loading.value = false;
        Get.to(() => OTPScreen(
              mobileNumber: phoneNumber,
              firstName: firstName,
              lastName: lastName,
            ));
      },
      //After new Code generated
      codeAutoRetrievalTimeout: (val) {},
      //After t seconds resend code,
      timeout: Duration(seconds: 30),
    );
  }

  myCredentials(String verId, String input, String mobileNumber, bool flag) async {
    AuthCredential authCredential = PhoneAuthProvider.credential(verificationId: verId, smsCode: input);
    // ignore: non_constant_identifier_names
    auth.signInWithCredential(authCredential).then((UserCredential) async {
      void solve12() {}
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final CollectionReference userCollection = FirebaseFirestore.instance.collection('USERS');
      //If Success Move to Home Page
      if (flag) {
        DocumentReference userDocRef = await userCollection.add({
          'fname': firstName,
          'lname': lastName,
          'mobile': mobileNumber,
          'groups': [],
        });

        await userDocRef.update({'username': userDocRef.id});

        await prefs.setString("documentid", userDocRef.id.toString());
        await prefs.setString("firstname", firstName);
        await prefs.setString("lastname", lastName);
      } else {
        print('Trying to login');
      }
      prefs.setString('loggedIn', 'true');
      loading.value = true;
      mobile.value = mobileNumber;
      Get.offAll(() => HomeScreen());
    }).catchError((e) {
      loading.value = false;
      Get.to(() => otpVerify());
    });
  }
}
