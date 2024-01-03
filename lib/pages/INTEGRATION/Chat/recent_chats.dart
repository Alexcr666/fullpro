import 'package:cached_network_image/cached_network_image.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:fullpro/pages/INTEGRATION/Chat/Matches.dart';

import 'package:fullpro/pages/INTEGRATION/Chat/chatPage.dart';

import 'package:fullpro/pages/INTEGRATION/models/user_model.dart';

import 'package:fullpro/pages/INTEGRATION/styles/color.dart';
import 'package:fullpro/widgets/widget.dart';

import 'package:intl/intl.dart';

class RecentChats extends StatelessWidget {
  final db = FirebaseFirestore.instance;

  final User currentUser;

  final List<User> matches;

  RecentChats(this.currentUser, this.matches);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular(30.0),

                topRight: Radius.circular(30.0),
              ),
              child: ListView(
                  physics: ScrollPhysics(),
                  children: matches
                      .map((index) => GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (_) => ChatPage(
                                  chatId: chatId(currentUser, index),
                                  sender: currentUser,
                                  second: index,
                                  photo: "",
                                ),
                              ),
                            ),
                            child: StreamBuilder(
                                stream: db
                                    .collection("chats")
                                    .doc(chatId(currentUser, index))
                                    .collection('messages')
                                    .orderBy('time', descending: true)
                                    .snapshots(),
                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData)
                                    return Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: CupertinoActivityIndicator(),
                                      ),
                                    );
                                  else if (snapshot.data!.docs.length == 0) {
                                    return Container();
                                  }

                                  index.lastmsg = snapshot.data!.docs[0]['time'];

                                  return Container(
                                    margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 20.0),
                                    //  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                    decoration: BoxDecoration(
                                      /*color: snapshot.data!.docs[0]['sender_id'] != currentUser.id && !snapshot.data!.docs[0]['isRead']

                                          ? primaryColor.withOpacity(.1)

                                          : secondryColor.withOpacity(.1),*/

                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20.0),
                                        bottomRight: Radius.circular(20.0),
                                      ),
                                    ),
                                    child: ListTile(
                                      leading: FutureBuilder(
                                          future: FirebaseDatabase.instance
                                              .ref()
                                              .child('partners')
                                              .child(snapshot.data!.docs[0]['receiver_id'].toString())
                                              .once(),
                                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                                            if (snapshot.hasData) {
                                              DatabaseEvent response = snapshot.data;

                                              return AppWidget().circleProfile(response.snapshot.child("photo").value.toString(), size: 57);
                                            } else {
                                              return SizedBox();
                                            }
                                          }),
                                      title: Text(
                                        index.name!,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        snapshot.data!.docs[0]['image_url'].toString().length > 0
                                            ? "Photo"
                                            : snapshot.data!.docs[0]['text'],
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      trailing: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            snapshot.data!.docs[0]["time"] != null
                                                ? DateFormat.MMMd('en_US')
                                                    .add_jm()
                                                    .format(snapshot.data!.docs[0]["time"].toDate())
                                                    .toString()
                                                : "",
                                            style: TextStyle(
                                              color: Colors.grey,

                                              fontSize: 11.0,

                                              // fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          snapshot.data!.docs[0]['sender_id'] != currentUser.id && !snapshot.data!.docs[0]['isRead']
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
                                          snapshot.data!.docs[0]['sender_id'] == currentUser.id
                                              ? !snapshot.data!.docs[0]['isRead']
                                                  ? Icon(
                                                      Icons.done,
                                                      color: secondryColor,
                                                      size: 15,
                                                    )
                                                  : Icon(
                                                      Icons.done_all,
                                                      color: primaryColor,
                                                      size: 15,
                                                    )
                                              : Text("")
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ))
                      .toList()),
            )));
  }
}
