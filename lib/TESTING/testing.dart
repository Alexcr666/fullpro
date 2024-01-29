import 'dart:developer';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:fullpro/Chat/home_screen.dart';
import 'package:fullpro/pages/INTEGRATION/Calling/incomingCall.dart';
import 'package:fullpro/pages/INTEGRATION/notification.dart';
import 'package:fullpro/pages/INTEGRATION/styles/color.dart';

import '../pages/INTEGRATION/models/user_model.dart' as userD;

class FirstPage extends StatefulWidget {
  static const String id = 'ChatTesting';
  @override
  _FirstPageState createState() => _FirstPageState();
}

List likedByList = [];
List userRemoved = [];

class _FirstPageState extends State<FirstPage> {
//late FirebaseMessaging _firebaseMessaging;
  CollectionReference docRef = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  userD.User? currentUser = userD.User(
    id: FirebaseAuth.instance.currentUser!.uid.toString(),
    name: "duvan",
  );
  List<userD.User> matches = [];
  List<userD.User> newmatches = [];

  List<userD.User> users = [];
  Map likedMap = {};
  Map disLikedMap = {};

  /// Past purchases

  //previous code
  //InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;

  bool isPuchased = false;

  Query query() {
    if (currentUser!.showGender == 'everyone') {
      return docRef
          .where(
            'age',
            isGreaterThanOrEqualTo: int.parse(currentUser!.ageRange!['min']),
          )
          .where('age', isLessThanOrEqualTo: int.parse(currentUser!.ageRange!['max']))
          .orderBy('age', descending: false);
    } else {
      return docRef
          .where('editInfo.userGender', isEqualTo: currentUser!.showGender)
          .where(
            'age',
            isGreaterThanOrEqualTo: int.parse(currentUser!.ageRange!['min']),
          )
          .where('age', isLessThanOrEqualTo: int.parse(currentUser!.ageRange!['max']))
          //FOR FETCH USER WHO MATCH WITH USER SEXUAL ORIENTAION
          // .where('sexualOrientation.orientation',
          //     arrayContainsAny: currentUser.sexualOrientation)
          .orderBy('age', descending: false);
    }
  }

  Future getUserList() async {
    List checkedUser = [];

    FirebaseFirestore.instance.collection('/Users/${currentUser!.id}/CheckedUser').get().then((event) {
      if (event.docs.length > 0) {
        event.docs.forEach((element) async {
          checkedUser.add(element.data()['LikedUser']);
          checkedUser.add(element.data()['DislikedUser']);
        });
      }
    }).then((v) {
      query().get().then((data) async {
        if (data.docs.length < 1) {
          print("no more data");
          return;
        }
        users.clear();
        userRemoved.clear();
        for (var doc in data.docs) {
          userD.User temp = userD.User.fromDocument(doc);
          var distance = calculateDistance(currentUser!.coordinates!['latitude'], currentUser!.coordinates!['longitude'],
              temp.coordinates!['latitude'], temp.coordinates!['longitude']);
          temp.distanceBW = distance.round();
          if (checkedUser.any(
            (value) {
              return value == temp.id;
            },
          )) {
          } else {
            if (distance <= currentUser!.maxDistance! && temp.id != currentUser!.id && !temp.isBlocked!) {
              users.add(temp);
            }
          }
        }
        if (mounted) setState(() {});
      });
    });
  }

  getLikedByList() {
    docRef.doc(currentUser!.id).collection("LikedBy").snapshots().listen((data) async {
      likedByList.addAll(data.docs.map((f) => f['LikedBy']));
    });
  }

  _getCurrentUser() async {
    User? user = await _firebaseAuth.currentUser;

    docRef.doc("${user!.uid}").snapshots().listen((data) async {
      currentUser = userD.User.fromDocument(data);
      currentUser!.id = FirebaseAuth.instance.currentUser!.uid;
      print('----------------$currentUser');
      if (mounted) setState(() {});
      users.clear();
      userRemoved.clear();
      // getUserList();
      //  getLikedByList();
      //  configurePushNotification(currentUser!);
      if (!isPuchased) {
        //  _getSwipedcount();
      }
      //return currentUser;
    }).onError(print);
    return currentUser;
  }

  List<String> added = [];

  String currentText = "";

  GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();

  _FirstPageState() {
    textField = SimpleAutoCompleteTextField(
      key: key,
      decoration: InputDecoration(errorText: "Beans"),
      controller: TextEditingController(text: "Starting Text"),
      suggestions: suggestions,
      textChanged: (text) => currentText = text,
      clearOnSubmit: true,
      textSubmitted: (text) => setState(() {
        if (text != "") {
          added.add(text);
        }
      }),
    );
  }

  List<String> suggestions = [
    "Apple",
    "Armidillo",
    "Actual",
    "Actuary",
    "America",
    "Argentina",
    "Australia",
    "Antarctica",
    "Blueberry",
    "Cheese",
    "Danish",
    "Eclair",
    "Fudge",
    "Granola",
    "Hazelnut",
    "Ice Cream",
    "Jely",
    "Kiwi Fruit",
    "Lamb",
    "Macadamia",
    "Nachos",
    "Oatmeal",
    "Palm Oil",
    "Quail",
    "Rabbit",
    "Salad",
    "T-Bone Steak",
    "Urid Dal",
    "Vanilla",
    "Waffles",
    "Yam",
    "Zest"
  ];

  SimpleAutoCompleteTextField? textField;

  bool showWhichErrorText = false;

  @override
  Widget build(BuildContext context) {
    Column body = Column(children: [
      ListTile(
          title: textField,
          trailing: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                textField!.triggerSubmitted();

                showWhichErrorText = !showWhichErrorText;

                textField!.updateDecoration(decoration: InputDecoration(errorText: showWhichErrorText ? "Beans" : "Tomatoes"));
              })),
    ]);

    body.children.addAll(added.map((item) {
      return ListTile(title: Text(item));
    }));

    return Scaffold(
      /*   appBar: AppBar(title: Text('AutoComplete TextField Demo Simple'), actions: [
        IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => showDialog(
                builder: (_) {
                  String text = "";

                  return AlertDialog(title: Text("Change Suggestions"), content: TextField(onChanged: (text) => text = text), actions: [
                    TextButton(
                        onPressed: () {
                          if (text != "") {
                            suggestions.add(text);

                            textField!.updateSuggestions(suggestions);
                          }

                          Navigator.pop(context);
                        },
                        child: Text("Add")),
                  ]);
                },
                context: context))
      ]),*/
      body: Column(children: [
        Expanded(child: HomeScreenChat(currentUser!, matches, newmatches)),
      ]),
    );
  }

  _getMatches() async {
    User user = await _firebaseAuth.currentUser!;

    log("idUser: " + user.uid.toString());
    return FirebaseFirestore.instance
        .collection('/Users/${user.uid}/Matches')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((ondata) {
      matches.clear();
      newmatches.clear();
      if (ondata.docs.length > 0) {
        ondata.docs.forEach((f) async {
          await docRef.doc(f.data()['Matches']).get().then((DocumentSnapshot doc) {
            if (doc.exists) {
              userD.User tempuser = userD.User.fromDocument(doc);

              /*  tempuser.distanceBW = calculateDistance(currentUser!.coordinates!['latitude'], currentUser!.coordinates!['longitude'],
                      tempuser.coordinates!['latitude'], tempuser.coordinates!['longitude'])
                  .round();*/

              matches.add(tempuser);
              newmatches.add(tempuser);
              if (mounted) setState(() {});
            }
          });
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null && message.data['type'] == 'Call') {
        print('=====${message.data}');
        Navigator.push(context, MaterialPageRoute(builder: (context) => Incoming(message.data)));
      } else {}
    });

    _getMatches();

    // _getCurrentUser();
  }
}
