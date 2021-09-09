import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:my_github/chatpage.dart';
import 'package:my_github/temp.dart';
import 'package:my_github/temp1.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static List<String> contacts = [];
  String codeDialog = "";
  String valueText = "";
  String? firstName = "";
  String? lastName = "";
  String? documentId = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    solve();
  }

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('USERS');
  final CollectionReference groupCollection = FirebaseFirestore.instance.collection('GROUPS');

  Future createGroup(String userName, String groupName) async {
    DocumentReference groupDocRef = await groupCollection.add({
      'groupName': groupName,
      'adminID': documentId,
      'admin': firstName,
      'members': [],
      'groupId': '',
      'ongoingEvent': "",
      'event_no': 0,
      'message_no':0
    });

    await groupDocRef.update({
      'members': FieldValue.arrayUnion([documentId]),
      'groupId': groupDocRef.id
    });

    DocumentReference userDocRef = userCollection.doc(documentId);
    return await userDocRef.update({
      'groups': FieldValue.arrayUnion([groupDocRef.id])
    }).then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChatPage(groupDocRef.id, groupName);
        })));
  }

  TextEditingController _textFieldController = TextEditingController();

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Enter the group name'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "enter group name here"),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    _textFieldController.clear();
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    codeDialog = valueText;
                    createGroup(firstName!, codeDialog);
                    _textFieldController.clear();
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  void _incrementCounter1(List<String> Users) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("userslist", Users);
    List<String>? savedStrList = prefs.getStringList('userslist');
    if (savedStrList != null) {
      // print(savedStrList);
      contacts = savedStrList;
      setState(() {
        print(contacts);
      });
    }
  }

  void solve1() async {
    if (await Permission.contacts.request().isGranted) {
      Set<String> phoneContacts = Set();
      var map = new Map();
      Iterable<Contact> contacts = await ContactsService.getContacts(withThumbnails: false);
      contacts.forEach((contact) {
        var x = contact.phones;
        var y = contact.displayName;
        if (x != null && x.length > 0) {
          String s = x.first.value.toString();
          s = s.replaceAll(" ", "");
          String ss = x.last.value.toString();
          ss = ss.replaceAll(" ", "");
          String a = s.padLeft(10).substring(math.max(s.length - 10, 0)).trim();
          String b = ss.padLeft(10).substring(math.max(ss.length - 10, 0)).trim();
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

  List s = [];
  Map groups = new Map();

  getUserGroups() async {
    // await FirebaseFirestore.instance.collection('USERS').doc(documentId).get().then((value) {
    //   print(value.data()!['groups']); // Access your after your get the data
    // });

    var collection = FirebaseFirestore.instance.collection('USERS');
    collection.doc(documentId).snapshots().listen((docSnapshot) async {
      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data();

        // You can then retrieve the value from the Map like this:
        var value = data?['groups'];
        s = value;
        for (int i = 0; i < s.length; i++) {
          await FirebaseFirestore.instance.collection("GROUPS").doc(s[i].toString()).get().then((value) {
            // print(value.data()!["groupName"]);
            groups[s[i].toString()] = value.data()!["groupName"].toString();
          });
        }
        setState(() {
          print(groups);
        });
      }
    });
  }

  void solve() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    firstName = prefs.getString("firstname");
    lastName = prefs.getString("lastname");
    documentId = prefs.getString("documentid");
    await getUserGroups();

    List<String>? savedStrList = prefs.getStringList('userslist');
    if (savedStrList != null) {
      setState(() {
        contacts = savedStrList;
      });
    } else {
      solve1();
    }
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _selectedIndex == 0 ? _displayTextInputDialog(context) : solve1();
        },
        tooltip: _selectedIndex == 0 ? "Create Group" : "Refresh",
        child: Icon(_selectedIndex == 0 ? Icons.group : Icons.refresh),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Center(
          child: _selectedIndex == 0
              ? groups.length != 0
                  ? Temp(s, groups)
                  : Container()
              : Temp1(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Groups',
//             backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Contacts',
//             backgroundColor: Colors.green,
          ),
        ],
        currentIndex: _selectedIndex,

        selectedItemColor: Colors.pink,
//         backgroundColor:colors[_selectedIndex],
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        onTap: _onItemTapped,
      ),
    );
  }
}
