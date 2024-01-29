import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:fullpro/Chat/recent_chats.dart';
import 'package:fullpro/pages/INTEGRATION/models/user_model.dart';
import 'package:fullpro/pages/INTEGRATION/styles/color.dart';

import 'Matches.dart';

class HomeScreenChat extends StatefulWidget {
  final User currentUser;
  final List<User> matches;
  final List<User> newmatches;
  HomeScreenChat(this.currentUser, this.matches, this.newmatches);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenChat> {
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
    return Scaffold(
      backgroundColor: secondryColor,
      appBar: AppBar(
        backgroundColor: secondryColor,
        automaticallyImplyLeading: false,
        title: Text(
          Locales.string(context, 'lang_messages'),
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        elevation: 0.0,
      ),
      body: Container(
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
                Matches(widget.currentUser, widget.newmatches),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    Locales.string(context, 'lang_recentmessage'),
                    style: TextStyle(
                      color: secondryColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                RecentChats(widget.currentUser, widget.matches),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
