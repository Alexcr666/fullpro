import 'package:flutter/material.dart';

import 'package:fullpro/pages/INTEGRATION/Chat/recent_chats.dart';

import 'package:fullpro/pages/INTEGRATION/models/user_model.dart';

import 'package:fullpro/pages/INTEGRATION/styles/color.dart';

import 'package:fullpro/styles/styles.dart';
import 'package:fullpro/widgets/widget.dart';

import 'Matches.dart';

class HomeScreen extends StatefulWidget {
  final User currentUser;

  final List<User> matches;

  final List<User> newmatches;

  HomeScreen(this.currentUser, this.matches, this.newmatches);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 500), () {
      if (widget.matches.length > 0 && widget.matches[0].lastmsg != null) {
        widget.matches.sort((a, b) {
          if (a.lastmsg != null && b.lastmsg != null) {
            var adate = a.lastmsg; //before -> var adate = a.expiry;

            var bdate = b.lastmsg; //before -> var bdate = b.expiry;

            return bdate!.compareTo(adate!); //to get the order other way just switch `adate & bdate`
          }

          return 1;
        });

        setState(() {});
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: gradientColor(),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                SizedBox(
                  height: 40,
                ),
                Container(margin: EdgeInsets.only(top: 40), child: AppWidget().back(context)),
                Container(
                  margin: EdgeInsets.only(top: 120),
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)), color: Colors.white),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
                    child: GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          /*Text(
                            widget.newmatches.toString(),
                            style: TextStyle(color: Colors.black),
                          ),*/
                          Matches(widget.currentUser, widget.newmatches),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              'Recent messages'.toString(),
                              style: TextStyle(
                                color: secondryColor,
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                          //  Text(widget.matches.length.toString()),
                          RecentChats(widget.currentUser, widget.matches),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                    child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                            margin: EdgeInsets.only(top: 20),
                            child: CircleAvatar(
                              child: Image.asset("images/user.png"),
                              radius: 70,
                              backgroundColor: Colors.grey,
                            )))),
              ],
            )));
  }
}
