import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:fullpro/pages/INTEGRATION/Chat/chatPage.dart';

import 'package:fullpro/pages/INTEGRATION/models/user_model.dart';

import 'package:fullpro/pages/INTEGRATION/styles/color.dart';
import 'package:fullpro/widgets/widget.dart';

class Matches extends StatelessWidget {
  final User currentUser;

  final List<User> matches;

  Matches(this.currentUser, this.matches);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'New results'.toString(),
                  style: TextStyle(
                    color: secondryColor,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.more_horiz,
                  ),
                  iconSize: 30.0,
                  color: Colors.white,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Container(
              height: 120.0,
              child: matches.length > 0
                  ? ListView.builder(
                      padding: EdgeInsets.only(left: 10.0),
                      scrollDirection: Axis.horizontal,
                      itemCount: matches.length,
                      itemBuilder: (BuildContext context, int index) {
                        print("chatid:" + currentUser.id.toString());
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (_) => ChatPage(
                                sender: currentUser,
                                chatId: /*chatId(*/ currentUser.id.toString() /*, matches[index])*/,
                                second: matches[index],
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                FutureBuilder(
                                    future: FirebaseDatabase.instance.ref().child('partners').child(matches[index].id.toString()).once(),
                                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                                      if (snapshot.hasData) {
                                        DatabaseEvent response = snapshot.data;

                                        return AppWidget().circleProfile(response.snapshot.child("photo").value.toString(), size: 57);
                                      } else {
                                        return SizedBox();
                                      }
                                    }),
                                /* CircleAvatar(
                                  backgroundColor: secondryColor,
                                  radius: 35.0,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(90),
                                    child: CachedNetworkImage(
                                      imageUrl: /* matches[index].imageUrl![0] ??*/ '',
                                      useOldImageOnUrlChange: true,
                                      placeholder: (context, url) => CupertinoActivityIndicator(
                                        radius: 15,
                                      ),
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                    ),
                                  ),
                                ),*/

                                SizedBox(height: 6.0),
                                Text(
                                  matches[index].name!,
                                  style: TextStyle(
                                    color: secondryColor,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                      "No match found".toString(),
                      style: TextStyle(color: secondryColor, fontSize: 16),
                    ))),
        ],
      ),
    );
  }
}

var groupChatId;

chatId(currentUser, sender) {
  if (currentUser.id.hashCode <= sender.id.hashCode) {
    return groupChatId = '${currentUser.id}';
  } else {
    return groupChatId = '${sender.id}';
  }
}
/*
chatId(currentUser, sender) {
  if (currentUser.id.hashCode <= sender.id.hashCode) {
    return groupChatId = '${currentUser.id}-${sender.id}';
  } else {
    return groupChatId = '${sender.id}-${currentUser.id}';
  }
}*/
