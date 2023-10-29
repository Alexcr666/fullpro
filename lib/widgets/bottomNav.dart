import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fullpro/controller/loader.dart';
import 'package:fullpro/pages/INTEGRATION/Chat/home_screen.dart';
import 'package:fullpro/pages/INTEGRATION/maps/maps.dart';
import 'package:fullpro/pages/INTEGRATION/notification.dart';
import 'package:fullpro/pages/INTEGRATION/styles/color.dart';

import 'package:fullpro/pages/profile/account.dart';
import 'package:fullpro/pages/profile/orderspage.dart';
import 'package:fullpro/pages/support.dart';
import 'package:fullpro/pages/INTEGRATION/models/user_model.dart' as userD;

List userRemoved = [];
int countswipe = 1;

List likedByList = [];
userD.User? currentUser;

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  //late FirebaseMessaging _firebaseMessaging;
  CollectionReference docRef = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  List<userD.User> matches = [];
  List<userD.User> newmatches = [];

  List<userD.User> users = [];

  /* Map likedMap = {};
  Map disLikedMap = {};

  /// Past purchases
  List<PurchaseDetails> purchases = [];
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  //previous code
  //InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
  InAppPurchase _iap = InAppPurchase.instance;
  bool isPuchased = false;
  @override
  void initState() {
    final Stream<List<PurchaseDetails>> purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) async {
      setState(() {
        purchases.addAll(purchaseDetailsList);
        _listenToPurchaseUpdated(purchaseDetailsList);
      });
    }, onDone: () {
      _subscription!.cancel();
    }, onError: (error) {
      _subscription!.cancel();
    });

    super.initState();
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null && message.data['type'] == 'Call') {
        print('=====${message.data}');
        Navigator.push(context, MaterialPageRoute(builder: (context) => Incoming(message.data)));
      } else {}
    });
    // Show payment success alert.
    if (widget.isPaymentSuccess != null && widget.isPaymentSuccess!) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Alert(
          context: context,
          type: AlertType.success,
          title: "Confirmation".tr().toString(),
          desc: "You have successfully subscribed to our ".tr().toString() + "${widget.plan}",
          buttons: [
            DialogButton(
              child: Text(
                "Ok".tr().toString(),
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();
      });
    }*/

  @override
  void initState() {
    _getCurrentUser();
    _getMatches();
  }

  _getMatches() async {
    User user = await _firebaseAuth.currentUser!;
    return FirebaseFirestore.instance
        .collection('/Users/Mkoc6GZaIWMf6yO2mDAHlZucj9V2/Matches')

        // .collection('/Users/${user.uid}/Matches')
        .orderBy('timestamp', descending: true)
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
              tempuser.distanceBW = calculateDistance(currentUser!.coordinates!['latitude'], currentUser!.coordinates!['longitude'],
                      tempuser.coordinates!['latitude'], tempuser.coordinates!['longitude'])
                  .round();

              matches.add(tempuser);
              newmatches.add(tempuser);
              if (mounted) setState(() {});
            }
          });
        });
      }
    });
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

  configurePushNotification(userD.User user) async {
    await FirebaseMessaging.instance.requestPermission(alert: true, badge: true, sound: true, provisional: false).then((value) {
      return null;
    });

    FirebaseMessaging.instance.getToken().then((token) {
      print('token)))))))))$token');
      docRef.doc(user.id).update({
        'pushToken': token,
      });
    });
    //FirebaseMessaging.instance.

    // FirebaseMessaging.instance
    //     .getInitialMessage()
    //     .then((RemoteMessage? message) async {
    //   print('getInitialMessage data: ${message}');
    // });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage data: ${message.data}");
      print("onmessage${message.data['type']}");

      if (Platform.isIOS && message.data['type'] == 'Call') {
        Map callInfo = {};
        callInfo['channel_id'] = message.data['channel_id'];
        callInfo['senderName'] = message.data['senderName'];
        callInfo['senderPicture'] = message.data['senderPicture'];
        //changed
        // Navigator.push(context, MaterialPageRoute(builder: (context) => Incoming(callInfo)));
      } else if (Platform.isAndroid && message.data['type'] == 'Call') {
        //   Navigator.push(context, MaterialPageRoute(builder: (context) => Incoming(message.data)));
      } else
        print("object>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    });

    // replacement for onResume: When the app is in the background and opened directly from the push notification.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print('onMessageOpenedApp data: ${message.data}');
      if (Platform.isIOS && message.data['type'] == 'Call') {
        Map callInfo = {};
        callInfo['channel_id'] = message.data['channel_id'];
        callInfo['senderName'] = message.data['senderName'];
        callInfo['senderPicture'] = message.data['senderPicture'];
        bool iscallling = _checkcallState(message.data['channel_id']);
        print("=================$iscallling");
        if (iscallling) {
          //changed
          // Navigator.push(context, MaterialPageRoute(builder: (context) => Incoming(message.data)));
        }
      } else if (Platform.isAndroid && message.data['type'] == 'Call') {
        bool iscallling = await _checkcallState(message.data['channel_id']);
        print("=================$iscallling");
        if (iscallling) {
          //changed
          //  Navigator.push(context, MaterialPageRoute(builder: (context) => Incoming(message.data)));
        } else {
          print("Timeout");
        }
      }
    });

    // FirebaseMessaging.onMessage.listen((event) async {
    //   print("onmessage${event.data['data']['type']}");

    //   if (Platform.isIOS && event.data['type'] == 'Call') {
    //     Map callInfo = {};
    //     callInfo['channel_id'] = event.data['channel_id'];
    //     callInfo['senderName'] = event.data['senderName'];
    //     callInfo['senderPicture'] = event.data['senderPicture'];
    //     await Navigator.push(context,
    //         MaterialPageRoute(builder: (context) => Incoming(callInfo)));
    //   } else if (Platform.isAndroid && event.data['data']['type'] == 'Call') {
    //     print('=======================tttttttttttttttttttt');
    //     await Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (context) => Incoming(event.data['data'])));
    //   } else
    //     print("object>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    // });

    // FirebaseMessaging.onMessageOpenedApp.listen((event) async {
    //   print('===============onLaunch$event');
    //   if (Platform.isIOS && event.data['type'] == 'Call') {
    //     Map callInfo = {};
    //     callInfo['channel_id'] = event.data['channel_id'];
    //     callInfo['senderName'] = event.data['senderName'];
    //     callInfo['senderPicture'] = event.data['senderPicture'];
    //     bool iscallling = await _checkcallState(event.data['channel_id']);
    //     print("=================$iscallling");
    //     if (iscallling) {
    //       print('######################');
    //       await Navigator.push(context,
    //           MaterialPageRoute(builder: (context) => Incoming(event.data)));
    //     }
    //   } else if (Platform.isAndroid && event.data['data']['type'] == 'Call') {
    //     bool iscallling =
    //         await _checkcallState(event.data['data']['channel_id']);
    //     print("=================$iscallling");
    //     if (iscallling) {
    //       await Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //               builder: (context) => Incoming(event.data['data'])));
    //     } else {
    //       print("Timeout");
    //     }
    //   }
    // });
  }

  _checkcallState(channelId) async {
    bool iscalling = await FirebaseFirestore.instance.collection("calls").doc(channelId).get().then((value) {
      return value.data()!["calling"] ?? false;
    });
    return iscalling;
  }

  _getCurrentUser() async {
    User? user = await _firebaseAuth.currentUser;

    docRef.doc(/*"${user!.uid}"*/ "Mkoc6GZaIWMf6yO2mDAHlZucj9V2").snapshots().listen((data) async {
      currentUser = userD.User.fromDocument(data);
      print('----------------$currentUser');
      if (mounted) setState(() {});
      users.clear();
      userRemoved.clear();
      getUserList();
      getLikedByList();
      configurePushNotification(currentUser!);
      /* if (!isPuchased) {
        _getSwipedcount();
      }*/
      //return currentUser;
    }).onError(print);
    return currentUser;
  }

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

  @override
  void dispose() {
    //_subscription!.cancel();
    //  super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      //  notchMargin: 15,
      color: secondryColor,

      child: SizedBox(
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MaterialButton(
                  height: 50,
                  //  shape: CircleBorder(),
                  onPressed: () {
                    //
                  },
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
                MaterialButton(
                  height: 50,
                  shape: CircleBorder(),
                  onPressed: () {
                    //
                    Loader.page(context, OrdersPage());
                  },
                  child: SvgPicture.asset(
                    "images/icons/bottom2.svg",
                    width: 30,
                    color: Colors.white,
                  ),
                ),
                //
                //
                MaterialButton(
                  height: 50,
                  shape: CircleBorder(),
                  onPressed: () {
                    //
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Notifications()),
                    );
                    /*   Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MapSample()),
                    );*/
                    // Loader.page(context, Account());
                  },
                  child: SvgPicture.asset(
                    "images/icons/bottom3.svg",
                    width: 30,
                    color: Colors.white,
                  ),
                ),

                //
                //

                MaterialButton(
                  height: 50,
                  shape: CircleBorder(),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen(currentUser!, matches, newmatches)),
                    );
                    //
                    // Loader.page(context, SupportPage());
                  },
                  child: SvgPicture.asset(
                    "images/icons/bottom4.svg",
                    width: 30,
                    color: Colors.white,
                  ),
                ),
                /* MaterialButton(
                  height: 50,
                  shape: CircleBorder(),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MapSample()),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen(currentUser!, matches, newmatches)),
                    );
                    //
                    // Loader.page(context, SupportPage());
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "images/svg_icons/navigation/support.png",
                        width: 26,
                      ),
                    ],
                  ),
                ),*/
                //
                //
              ],
            ),
            //
          ],
        ),
      ),
    );
  }
}
