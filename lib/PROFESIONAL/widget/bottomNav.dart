// ignore_for_file: file_names

import 'dart:collection';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fullpro/PROFESIONAL/controllers/loader.dart';
import 'package:fullpro/PROFESIONAL/views/Orders/orders.dart';
import 'package:fullpro/PROFESIONAL/views/Orders/ordersList.dart';
import 'package:fullpro/PROFESIONAL/views/account.dart';
import 'package:fullpro/PROFESIONAL/views/profile/menuProfile.dart';
import 'package:fullpro/TESTING/testing.dart';
import 'package:fullpro/pages/INTEGRATION/Chat/home_screen.dart';
import 'package:fullpro/pages/INTEGRATION/styles/color.dart';
import 'package:fullpro/pages/profesional/profileProfesional.dart';
import 'package:fullpro/pages/profile/profileOptions.dart';
import 'package:fullpro/pages/support/newSupport.dart';
import 'package:fullpro/pages/INTEGRATION/models/user_model.dart' as userD;

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  List<userD.User> matches = [];
  List<userD.User> newmatches = [];
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  CollectionReference docRef = FirebaseFirestore.instance.collection('Users');
  userD.User? currentUser;
  @override
  void initState() {
    _getCurrentUser();
    // _getMatches();
  }

  _getCurrentUser() async {
    User? user = await _firebaseAuth.currentUser;

    docRef.doc(/*"${user!.uid}"*/ user!.uid.toString()).snapshots().listen((data) async {
      currentUser = userD.User.fromDocument(data);
      print('----------------$currentUser');
      if (mounted) setState(() {});
      //users.clear();
      //  userRemoved.clear();
      // _getMatches();
      // getUserList();
      //  getLikedByList();
      //configurePushNotification(currentUser!);
      /* if (!isPuchased) {
        _getSwipedcount();
      }*/
      //return currentUser;
    }).onError(print);
    return currentUser;
  }

  _getMatches() async {
    User user = await _firebaseAuth.currentUser!;
    return FirebaseFirestore.instance
        .collection('/Users/' + user.uid + '/Matches')

        // .collection('/Users/${user.uid}/Matches')
        //.orderBy('timestamp', descending: true)
        .snapshots()
        .listen((ondata) {
      log("data: " + ondata.toString());
      matches.clear();
      newmatches.clear();
      if (ondata.docs.length > 0) {
        ondata.docs.forEach((f) async {
          await docRef.doc(f.data()['Matches']).get().then((DocumentSnapshot doc) {
            if (doc.exists) {
              userD.User tempuser = userD.User.fromDocument(doc);
              /* tempuser.distanceBW = calculateDistance(currentUser!.coordinates!['latitude'], currentUser!.coordinates!['longitude'],
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
  Widget build(BuildContext context) {
    return BottomAppBar(
      //kkk
      color: secondryColor,
      child: SizedBox(
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20),
                  height: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "images/icons/bottom1.svg",
                        width: 30,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                //
                //
                GestureDetector(
                    onTap: () {
                      Loader.page(
                          context,
                          MyOrders(
                            tabIndicator: 3,
                          ));
                    },
                    child: Container(
                      height: 50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "images/icons/bottom2.svg",
                            width: 30,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    )),
                //
                //
                GestureDetector(
                    onTap: () {
                      //  Loader.page(context, const OrdersList());
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileOptionsProfessionalPage()),
                      );
                    },
                    child: Container(
                      height: 50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "images/icons/bottom3.svg",
                            width: 30,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    )),
                //
                //

                GestureDetector(
                    onTap: () {
                      //   _getMatches();

                      /*  List<userD.User> result = LinkedHashSet<userD.User>.from(matches).toList();

                      List<userD.User> newMatchesResult = LinkedHashSet<userD.User>.from(newmatches).toList();
                      log("iduser: " + FirebaseAuth.instance.currentUser!.uid.toString());
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen(currentUser!, result, newMatchesResult)),
                      );*/
                      Navigator.push(context, MaterialPageRoute(builder: (context) => FirstPage()));
                    },
                    child: Container(
                      height: 50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon(FeatherIcons.user, color: Colors.black),
                          SvgPicture.asset(
                            "images/icons/message.svg",
                            width: 35,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    )),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileProfesionalPage(id: FirebaseAuth.instance.currentUser!.uid.toString())));
                    },
                    child: Container(
                      height: 50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon(FeatherIcons.user, color: Colors.black),
                          SvgPicture.asset(
                            "images/icons/user.svg",
                            width: 25,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    )),
              ],
            ),
            //
          ],
        ),
      ),
    );
  }
}
