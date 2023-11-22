import 'dart:math';


import 'package:cached_network_image/cached_network_image.dart';


import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:flutter/cupertino.dart';


import 'package:flutter/material.dart';


import 'package:fullpro/pages/INTEGRATION/information.dart';


import 'package:fullpro/pages/INTEGRATION/models/user_model.dart';


import 'package:fullpro/pages/INTEGRATION/styles/color.dart';


import 'package:fullpro/styles/styles.dart';


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

    matchReference = db.collection("Users").doc("Mkoc6GZaIWMf6yO2mDAHlZucj9V2").collection('Matches');


    super.initState();


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

                  height: 100,

                ),


                Column(

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    Text(

                      "Notificaciones push",

                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),

                    ),

                    Text(

                      "Cambios de estados del servicio",

                      style: TextStyle(fontSize: 19, color: Colors.white),

                    ),

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


                StreamBuilder<QuerySnapshot>(

                    stream: matchReference.orderBy('timestamp', descending: true).snapshots(),

                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                      if (!snapshot.hasData)

                        return Center(

                            child: Text(

                          "No Notification".toString(),

                          style: TextStyle(color: secondryColor, fontSize: 16),

                        ));

                      else if (snapshot.data!.docs.length == 0) {

                        return Center(

                            child: Text(

                          "No Notification".toString(),

                          style: TextStyle(color: secondryColor, fontSize: 16),

                        ));

                      }


                      return Expanded(

                        child: ListView(

                          children: snapshot.data!.docs

                              .map((doc) => Padding(

                                    padding: const EdgeInsets.all(8.0),

                                    child: Container(

                                        decoration: BoxDecoration(

                                            borderRadius: BorderRadius.circular(20),

                                            color: !doc.get('isRead') ? Colors.white : Colors.white),

                                        child: ListTile(

                                          contentPadding: EdgeInsets.all(5),


                                          leading: CircleAvatar(

                                            radius: 25,


                                            backgroundColor: secondryColor,


                                            child: ClipRRect(

                                              borderRadius: BorderRadius.circular(

                                                25,

                                              ),

                                              child: CachedNetworkImage(

                                                imageUrl: doc.get('pictureUrl') ?? "",

                                                fit: BoxFit.cover,

                                                useOldImageOnUrlChange: true,

                                                placeholder: (context, url) => CupertinoActivityIndicator(

                                                  radius: 20,

                                                ),

                                                errorWidget: (context, url, error) => Icon(

                                                  Icons.error,

                                                  color: Colors.black,

                                                ),

                                              ),

                                            ),


                                            // backgroundImage:


                                            //     NetworkImage(


                                            //   widget.notification[index]


                                            //       .sender.imageUrl[0],


                                            // )

                                          ),


                                          //title: Text(


                                          //    "you are matched with ${doc.data['userName'] ?? "__"}".toString()),


                                          title: Text(

                                            doc.get('userName').toString(),

                                            style: TextStyle(color: secondryColor, fontWeight: FontWeight.bold),

                                          ),


                                          subtitle: Text(

                                            "${(doc.get('timestamp').toDate())}",

                                            style: TextStyle(color: Colors.grey),

                                          ),


                                          //  Text(


                                          //     "Now you can start chat with ${notification[index].sender.name}"),


                                          // "if you want to match your profile with ${notifications[index].sender.name} just like ${notifications[index].sender.name}'s profile"),


                                          trailing: Padding(

                                            padding: const EdgeInsets.only(right: 10),

                                            child: Column(

                                              mainAxisAlignment: MainAxisAlignment.spaceAround,

                                              children: <Widget>[

                                                !doc.get('isRead')

                                                    ? Container(

                                                        width: 40.0,

                                                        height: 20.0,

                                                        decoration: BoxDecoration(

                                                          color: primaryColor,

                                                          borderRadius: BorderRadius.circular(30.0),

                                                        ),

                                                        alignment: Alignment.center,

                                                        child: Text(

                                                          'NEW',

                                                          style: TextStyle(

                                                            color: Colors.white,

                                                            fontSize: 12.0,

                                                            fontWeight: FontWeight.bold,

                                                          ),

                                                        ),

                                                      )

                                                    : Text(""),

                                              ],

                                            ),

                                          ),


                                          onTap: () async {

                                            /*  print(doc.get("Matches"));


                                            showDialog(

                                                context: context,

                                                builder: (context) {

                                                  return Center(

                                                      child: CircularProgressIndicator(

                                                    strokeWidth: 2,

                                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),

                                                  ));

                                                });


                                            DocumentSnapshot userdoc = await db.collection("Users").doc(doc.get("Matches")).get();


                                            if (userdoc.exists) {

                                              Navigator.pop(context);


                                              User tempuser = User.fromDocument(userdoc);


                                              tempuser.distanceBW = calculateDistance(

                                                      widget.currentUser.coordinates!['latitude'],

                                                      widget.currentUser.coordinates!['longitude'],

                                                      tempuser.coordinates!['latitude'],

                                                      tempuser.coordinates!['longitude'])

                                                  .round();


                                              await showDialog(

                                                  barrierDismissible: false,

                                                  context: context,

                                                  builder: (context) {

                                                    if (!doc.get("isRead")) {

                                                      FirebaseFirestore.instance

                                                          .collection("/Users/Mkoc6GZaIWMf6yO2mDAHlZucj9V2/Matches")

                                                          .doc('${doc.get("Matches")}')

                                                          .update({'isRead': true});

                                                    }


                                                    return Info(tempuser, "", null);

                                                  });*/

                                          },

                                        )


                                        //  : Container()


                                        ),

                                  ))

                              .toList(),

                        ),

                      );

                    }),


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

