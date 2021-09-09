import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {
  final groupid;
  final groupname;
  @override
  _ChatPageState createState() => _ChatPageState();

  ChatPage(this.groupid, this.groupname);
}

class _ChatPageState extends State<ChatPage> {
  int flag = 0;

  Map<String, String> inputs = {};
  TextEditingController _textFieldController1 = TextEditingController();
  TextEditingController _textFieldController2 = TextEditingController();
  TextEditingController _textFieldController3 = TextEditingController();
  TextEditingController _textFieldController4 = TextEditingController();
  TextEditingController _textFieldController5 = TextEditingController();
  bool _validate = false;
  List<String> codeDialog = ["", "", "", "", ""];
  String valueText = "";
  String date = "";
  String time1 = "";
  String location = "";
  String description = "";

  Future<void> createEve(
      int event_no, String name, String time, String date, String location, String description, int message_no) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final CollectionReference groupCollection1 = FirebaseFirestore.instance.collection('GROUPS');
    final CollectionReference groupCollection =
        FirebaseFirestore.instance.collection('GROUPS').doc(widget.groupid).collection("EVENTS");

    final CollectionReference messageCollection =
        FirebaseFirestore.instance.collection('GROUPS').doc(widget.groupid).collection("MESSAGES");

    DocumentReference eventDocRef = await groupCollection.add({
      'event_no': event_no,
      'name': name,
      'location': location,
      'participants': [],
      'event_id': '',
      'description': description,
      'date': date,
      'time': time,
      'isactive': true,
    });
    String? userid = prefs.getString("documentid");
    await eventDocRef.update({
      'participants': FieldValue.arrayUnion([userid]),
      'event_id': eventDocRef.id
    });

    DocumentReference messageDocRef = await messageCollection.add({
      'type': "create",
      'sender': prefs.getString('firstname').toString() + " " + prefs.getString("lastname").toString(),
      'sender_id': prefs.getString("documentid").toString(),
      'message_no': message_no,
      'description': description,
      'date': date,
      'time': time,
      'event_name': name,
      'location': location,
      'event_id': eventDocRef.id,
      'isactive': true,
    });
    await messageDocRef.update({'message_id': messageDocRef.id});

    await groupCollection1
        .doc(widget.groupid)
        .update({'event_no': event_no, 'ongoingEvent': eventDocRef.id, 'message_no': message_no});
  }

  void createEvent(List<String> codeDialog) async {
    await FirebaseFirestore.instance.collection("GROUPS").doc(widget.groupid).get().then((value) {
      print(value.data()!["event_no"].toString());
      createEve(value.data()!["event_no"] + 1, codeDialog[0], codeDialog[2], codeDialog[1], codeDialog[3], codeDialog[4],
              value.data()!["message_no"] + 1)
          .then((value) => print('eventcreated'));
    });
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _displayTextInputDialog1(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Enter Event Details'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Enter Event Name",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        valueText = value;
                      });

                      if (valueText.length == 0) {
                        flag = 1;
                      } else {
                        flag = 0;
                      }
                    },
                    controller: _textFieldController1,
                    decoration: InputDecoration(
                      hintText: "enter event name",
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Enter date",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  TextField(
                    onTap: () {
                      setState(() async {
                        await _selectDate(context);
                        _textFieldController2.text = selectedDate.toString().substring(0, 10);
                        date = selectedDate.toString().substring(0, 10);
                      });
                    },
                    // onChanged: (value1) {
                    //   setState(() {
                    //     date = value1;
                    //   });
                    //   if (date.length == 0) {
                    //     flag = 1;
                    //   } else {
                    //     flag = 0;
                    //   }
                    // },
                    controller: _textFieldController2,
                    decoration: InputDecoration(hintText: "select date"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Enter time",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(hintText: "select time"),
                    controller: _textFieldController3, // add this line.
                    onTap: () async {
                      TimeOfDay time = TimeOfDay.now();
                      FocusScope.of(context).requestFocus(new FocusNode());

                      TimeOfDay? picked = await showTimePicker(context: context, initialTime: time);
                      if (picked != null && picked != time) {
                        _textFieldController3.text = picked.format(context); // add this line.
                        setState(() {
                          time = picked;
                          time1 = picked.format(context).toString();
                        });
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Enter location",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        location = value;
                      });
//                     print(location.length);
                      if (location.length == 0) {
                        flag = 1;
                      } else {
                        flag = 0;
                      }
                    },
                    controller: _textFieldController4,
                    decoration: InputDecoration(hintText: "enter location"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        description = value;
                      });
                    },
                    controller: _textFieldController5,
                    decoration: InputDecoration(hintText: "enter description (optional)"),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    _textFieldController1.clear();
                    _textFieldController2.clear();
                    _textFieldController3.clear();
                    _textFieldController4.clear();
                    _textFieldController5.clear();
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () async {
                  if (valueText.length == 0 || date.length == 0 || location.length == 0 || time1.length == 0) {
                    await _displayTextInputDialog(context, "please fill all fields correctly");
                  } else {
                    setState(() {
                      codeDialog = [valueText, date, time1, location, description];
                      _textFieldController1.clear();
                      _textFieldController2.clear();
                      _textFieldController3.clear();
                      _textFieldController4.clear();
                      _textFieldController5.clear();
                      createEvent(codeDialog);
                      Navigator.pop(context);
                    });
                  }
                },
              ),
            ],
          );
        });
  }

  Future<void> _displayTextInputDialog(BuildContext context, String s) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(s, textAlign: TextAlign.center),
              SizedBox(
                height: 15,
              ),
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('Ok'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  bool eventCancel = false;
  void cancelEvent(String message_id) async {
    await FirebaseFirestore.instance.collection('GROUPS').doc(widget.groupid).update({'ongoingEvent': ''});
    await FirebaseFirestore.instance
        .collection('GROUPS')
        .doc(widget.groupid)
        .collection("MESSAGES")
        .doc(message_id)
        .update({'isactive': false});
    setState(() {
      eventCancel = true;
      x = 0;
    });
  }

  String _description = "asd asdsd dfg dfg fdgdfgd dfg dfgdfg dfffdfgdfg";

  String sender_id = "";
  void getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    sender_id = prefs.getString("documentid")!;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserName();
  }

  Widget _onPressed1() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("GROUPS")
          .doc(widget.groupid)
          .collection("MESSAGES")
          .orderBy('message_no')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Center(
                child: new Container(
              child: Text("fetching chats"),
            ));
          default:
            return new ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (ctx, index) => Padding(
                padding: const EdgeInsets.fromLTRB(6, 6, 30, 6),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8, right: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data!.docs[index]['sender'].toString(),
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.pinkAccent),
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: Text(
                            snapshot.data!.docs[index]['event_name'].toString(),
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.alarm, size: 16, color: Colors.blue),
                            SizedBox(width: 3),
                            Text(snapshot.data!.docs[index]['time']),
                            SizedBox(width: 20),
                            Icon(Icons.calendar_today, size: 15),
                            SizedBox(width: 3),
                            Text(snapshot.data!.docs[index]['date']),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
//                   mainAxisSize:MainAxisSize.min,
                          children: [
                            Icon(Icons.location_pin, size: 15, color: Colors.red),
                            SizedBox(width: 2),
                            Expanded(
                                child: Text(
                              snapshot.data!.docs[index]['location'].toString(),
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            )),
                          ],
                        ),
                        SizedBox(height: 4),
                        (_description.length == 0)
                            ? Container()
                            : Row(
//                   mainAxisSize:MainAxisSize.min,
                                children: [
                                  Icon(Icons.description, size: 15, color: Colors.black54),
                                  SizedBox(width: 2),
                                  Expanded(
                                      child: Text(
                                    snapshot.data!.docs[index]['description'],
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  )),
                                ],
                              ),
                        SizedBox(
                          height: 10,
                        ),
                        snapshot.data!.docs[index]['isactive'] == false
                            ? Text(
                                "this event has been cancelled!",
                                style: TextStyle(color: Colors.red),
                              )
                            : sender_id == snapshot.data!.docs[index]['sender_id'].toString()
                                ? eventCancel == true && snapshot.data!.docs[index]['type'] == 'create'
                                    ? Text(
                                        "this event has been cancelled!",
                                        style: TextStyle(color: Colors.red),
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          cancelEvent(snapshot.data!.docs[index]['message_id']);
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                color: Colors.red,
                                              ),
                                              height: 35,
                                              child: Padding(
                                                padding: const EdgeInsets.all(4.0),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.cancel,
                                                      color: Colors.white,
                                                    ),
                                                    Text(
                                                      'CANCEL EVENT',
                                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                : Container(),
                      ],
                    ),
                  ),
                ),
              ),
            );
        }
      },
    );
  }

  int x = 0;

  Future<void> checkIfEventActive() async {
    await FirebaseFirestore.instance.collection("GROUPS").doc(widget.groupid).get().then((value) {
      print(value.data()!['ongoingEvent'].toString());
      if (value.data()!['ongoingEvent'].toString().length > 5) {
        setState(() {
          x = 1;
        });
      }
    });
  }

  String dropdownValue = '/Create Event ';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
// child:
      appBar: AppBar(
        titleSpacing: 0,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_sharp,
              color: Colors.black,
            )),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(color: Colors.lightBlueAccent, borderRadius: BorderRadius.circular(50)),
              child: Center(child: Text(widget.groupname[0])),
            ),
            SizedBox(
              width: 10,
            ),
            Text(widget.groupname, style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600)),
          ],
        ),
//         centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            // _chatMessages(),
            _onPressed1(),
            // Container(),
            Container(
              alignment: Alignment.bottomCenter,
//               width:
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: dropdownValue,
                        icon: Visibility(
                          visible: true,
                          child: Container(
                            height: 25.0,
                            width: 25.0,
                            decoration: BoxDecoration(
//                           color: Colors.blu,
                                border: Border.all(color: Colors.black45),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(child: Text("/")),
                          ),
                        ),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.black),
                        underline: Container(
                          height: 0.71,
                          color: Colors.black,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        items: <String>['/Create Event ', '/Edit event', '/In', '/Out', '/Pay']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(value),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
//

                    SizedBox(width: 12.0),
                    GestureDetector(
                      onTap: () async {
                        if (dropdownValue == '/Create Event ') {
                          await checkIfEventActive();

                          x == 1
                              ? _displayTextInputDialog(
                                  context, "another event is going onn please wait till it overs before creating a new one!")
                              : _displayTextInputDialog1(context);
                        }
                      },
                      child: Icon(Icons.send, color: Colors.blue),
                    )
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
