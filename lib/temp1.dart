import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Temp1 extends StatefulWidget {
  const Temp1({Key? key}) : super(key: key);

  @override
  _Temp1State createState() => _Temp1State();
}

class _Temp1State extends State<Temp1> {
  List<String> contacts = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    solve();
  }

  void _incrementCounter1(List<String> Users) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("userslist", Users);
    List<String>? savedStrList = prefs.getStringList('userslist');
    if (savedStrList != null) {
      // print(savedStrList);
      contacts = savedStrList;
      setState(() {});
    }
  }

  void solve1() async {
    if (await Permission.contacts.request().isGranted) {
      Set<String> phoneContacts = Set();
      var map = new Map();
      Iterable<Contact> contacts =
          await ContactsService.getContacts(withThumbnails: false);
      contacts.forEach((contact) {
        var x = contact.phones;
        var y = contact.displayName;
        if (x != null && x.length > 0) {
          String s = x.first.value.toString();
          s = s.replaceAll(" ", "");
          String ss = x.last.value.toString();
          ss = ss.replaceAll(" ", "");
          String a = s.padLeft(10).substring(math.max(s.length - 10, 0)).trim();
          String b =
              ss.padLeft(10).substring(math.max(ss.length - 10, 0)).trim();
          map[a] = y;
          map[b] = y;
          phoneContacts.add(a);
          phoneContacts.add(b);
        }
      });

      List<String> numbers = [];
      final _firestore = FirebaseFirestore.instance;

      await _firestore.collection("USERS").get().then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          numbers.add(result.data()["mobile"].toString());
        });
      });
      // print(numbers);
      List<String> Users = [];
      for (int i = 0; i < numbers.length; i++) {
        if (map[numbers[i]] != null) {
          Users.add(numbers[i].toString() + " " + map[numbers[i]].toString());
        }
      }

      _incrementCounter1(Users);
    }
  }

  void solve() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedStrList = prefs.getStringList('userslist');
    if (savedStrList != null) {
      setState(() {
        contacts = savedStrList;
      });
    } else {
      solve1();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: contacts.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
//                 color:Colors.blueAccent,
                          color: Color((math.Random().nextDouble() * 0x808080)
                                  .toInt())
                              .withOpacity(0.8),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                            child: Text(contacts[index][11].toUpperCase(),
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)))),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
//               height: 50,
//       color: Colors.amber[colorCodes[index]],
                            child: Text(
                              contacts[index].toString().substring(11),
                              style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold,
                                letterSpacing: 0.4,
//                             fontFamily:
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Container(
//               height: 50,
//       color: Colors.amber[colorCodes[index]],
                            child: Text(
                              contacts[index].toString().substring(0, 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.black26,
                  indent: 60,
                  endIndent: 10,
                  thickness: 0.4,
                ),
              ],
            ),
          );
        });
  }
}
