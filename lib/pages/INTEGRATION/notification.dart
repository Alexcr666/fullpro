import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

import 'package:fullpro/pages/INTEGRATION/styles/color.dart';

import 'package:fullpro/styles/styles.dart';
import 'package:fullpro/utils/utils.dart';
import 'package:fullpro/widgets/widget.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Notifications extends StatefulWidget {
  // final User currentUser;

  Notifications(/*this.currentUser*/);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final db = FirebaseFirestore.instance;

  late CollectionReference matchReference;

  @override
  void initState() {
    // matchReference = db.collection("Users").doc("Mkoc6GZaIWMf6yO2mDAHlZucj9V2").collection('Matches');

    super.initState();
    /*Future.delayed(Duration(seconds: 3), () {
      FirebaseDatabase.instance.ref().child('notifications').once().then((value) {
        for (var i = 0; i < value.snapshot.children.length; i++) {
          DataSnapshot data = value.snapshot.children.toList()[i];

          data.ref.child("view").child(FirebaseAuth.instance.currentUser!.uid.toString()).set({"date", DateTime.now().toString()});
        }
      });
    });*/

    // Future.delayed(Duration(seconds: 1), () {

    //   if (widget.notification.length > 1) {

    //     widget.notification.sort((a, b) {

    //       var adate = a.time; //before -> var adate = a.expiry;

    //       var bdate = b.time; //before -> var bdate = b.expiry;

    //       return bdate.compareTo(

    //           adate); //to get the order other way just switch `adate & bdate`

    //     });

    //   }

    // });

    // if (mounted) setState(() {});
  }

  Widget pageOrdensHistory() {
    return FutureBuilder(

        //   kkk

        future: FirebaseDatabase.instance.ref().child('notifications').once(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          var response = snapshot.data;

          return response == null
              ? AppWidget().loading()
              : response.snapshot.children.toList().length == 0
                  ? AppWidget().noResult(context)
                  : Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: Card(
                          child: ListView.builder(
                              padding: EdgeInsets.only(left: 10.0),
                              itemCount: response.snapshot.children.toList().length,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int i) {
                                DataSnapshot dataList = response.snapshot.children.toList().reversed.toList()[i];
                                bool noView = false;

                                /* dataList.ref.child("view").child(FirebaseAuth.instance.currentUser!.uid.toString()).once().then((value) {
                                  if (value.snapshot.exists == false) {
                                    noView = false;
                                  } else {
                                    noView = true;
                                  }
                                });*/

                                return dataList.child("view").value != null
                                    ? SizedBox()
                                    : Column(
                                        children: [
                                          ListTile(
                                            onTap: () async {
                                              if (dataList.child("url").value != null) {
                                                final Uri url = Uri.parse(dataList.child("url").value.toString());
                                                if (!await launchUrl(url)) {
                                                  throw Exception('Could not launch');
                                                }
                                              }
                                            },
                                            title: Text(dataList.child("description").value.toString().capitalize()),
                                            subtitle: Text(
                                              DateFormat('yyyy-MM-dd – KK:mm a')
                                                  .format(DateTime.parse(dataList.child("date").value.toString())),
                                              style: TextStyle(fontSize: 11),
                                            ),
                                            trailing: GestureDetector(
                                                onTap: () {
                                                  dataList.ref.update({"view": true}).then((value) {
                                                    setState(() {});
                                                  });
                                                },
                                                child: Icon(Icons.delete)),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(right: 25, left: 10),
                                            width: double.infinity,
                                            height: 0.5,
                                            color: secondryColor,
                                          )
                                        ],
                                      );
                              })));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        // appBar: AppBar(

        //   automaticallyImplyLeading: false,

        //   title: Text(

        //     'Notifications'.toString(),

        //     style: TextStyle(

        //       color: Colors.white,

        //       fontSize: 18.0,

        //       fontWeight: FontWeight.bold,

        //       letterSpacing: 1.0,

        //     ),

        //   ),

        //   elevation: 0,

        // ),

        backgroundColor: primaryColor,
        body: Container(
          decoration: gradientColor(),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                AppWidget().back(context),
                SizedBox(
                  height: 50,
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Locales.string(context, "lang_notificaciones_text"),
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    /*   Text(
                      "Cambios de estados del servicio",
                      style: TextStyle(fontSize: 19, color: Colors.white),
                    ),*/
                  ],
                ),

                // Padding(

                //   padding: const EdgeInsets.all(10),

                //   child: Text(

                //     'this week',

                //     style: TextStyle(

                //       color: primaryColor,

                //       fontSize: 18.0,

                //       fontWeight: FontWeight.bold,

                //       letterSpacing: 1.0,

                //     ),

                //   ),

                // ),

                pageOrdensHistory(),

                Expanded(child: SizedBox()),

                SizedBox(
                  height: 20,
                ),

                Container(
                    width: 130,
                    child: Image.asset(
                      "images/logo.png",
                      color: Colors.white,
                    )),

                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ));
  }
}

double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;

  var c = cos;

  var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;

  return 12742 * asin(sqrt(a));
}
