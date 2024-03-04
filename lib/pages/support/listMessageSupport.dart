import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';

import 'package:flutter_locales/flutter_locales.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:fullpro/config.dart';

import 'package:fullpro/const.dart';

import 'package:fullpro/controller/loader.dart';

import 'package:fullpro/pages/INTEGRATION/styles/color.dart';

import 'package:fullpro/pages/homepage.dart';

import 'package:fullpro/pages/support/newSupport.dart';

import 'package:fullpro/pages/support/support.dart';
import 'package:fullpro/utils/utils.dart';

import 'package:fullpro/widgets/widget.dart';
import 'package:intl/intl.dart';

import '../styles/statics.dart' as Static;

class ListMessageSupportPage extends StatefulWidget {
  ListMessageSupportPage({Key? key, this.id, this.title, this.state}) : super(key: key);

  String? id;
  String? title;
  bool? state;

  @override
  State<ListMessageSupportPage> createState() => _ListMessageSupportPageState();
}

class _ListMessageSupportPageState extends State<ListMessageSupportPage> {
  final TextEditingController _messageController = new TextEditingController();
  Widget stateIndicator0() {
    return FutureBuilder(
        future: FirebaseDatabase.instance.ref().child('support').child(widget.id.toString()).child("message").once(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          try {
            if (snapshot.hasData) {
              DatabaseEvent response = snapshot.data;

              return response == null
                  ? AppWidget().loading()
                  : response.snapshot.children.length == 0
                      ? AppWidget().noResult(context)
                      : ListView.builder(
                          itemCount: response.snapshot.children.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            DataSnapshot dataList = response.snapshot.children.toList()[index];

                            return GestureDetector(
                                onTap: () {},
                                child: Container(
                                    decoration: AppWidget().boxShandowGrey(),
                                    margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                                    padding: EdgeInsets.only(top: 20, right: 20, bottom: 20),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                            width: 300,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Flexible(
                                                        child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        dataList.child("nameUser").value == null
                                                            ? SizedBox()
                                                            : Text(
                                                                dataList.child("nameUser").value.toString().capitalize(),
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(fontSize: 13, color: Colors.grey),
                                                              ),
                                                        Text(
                                                          dataList.child("description").value.toString(),
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: secondryColor),
                                                        ),
                                                      ],
                                                    )),
                                                    Text(
                                                      dataList.child("date").value == null
                                                          ? Locales.string(context, 'lang_nodisponible')
                                                          : dataList.child("date").value.toString(),
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(fontSize: 12, color: secondryColor),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )),
                                      ],
                                    )));
                          });
            } else {
              return AppWidget().loading(context);
            }

            ;
          } catch (e) {
            return AppWidget().loading(context);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
            ),
            AppWidget().back(context),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                SvgPicture.asset(
                  "images/icons/miprofile6.svg",
                  color: secondryColor,
                  width: 32,
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                    child: Text(
                  widget.title.toString(),
                  style: TextStyle(
                    color: secondryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )),
                Expanded(child: SizedBox()),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Expanded(child: stateIndicator0()),
            widget.state == true
                ? SizedBox()
                : Row(
                    children: [
                      Flexible(child: AppWidget().texfieldFormat(title: "Mensaje", controller: _messageController)),
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        child: Icon(
                          Icons.send_outlined,
                          color: _messageController.text.toString().trim() == 0 ? Colors.grey : secondryColor,
                        ),
                        onTap: () {
                          if (_messageController.text.isNotEmpty) {
                            FirebaseDatabase.instance.ref().child('support').child(widget.id.toString()).child("message").push().set({
                              "description": _messageController.text,
                              "date": DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
                              "nameUser": userDataProfile!.child("fullname").value.toString(),
                              "user": FirebaseAuth.instance.currentUser!.uid.toString()
                            }).then((value) {
                              _messageController.clear();

                              AppWidget().itemMessage("Enviado", context);
                            }).catchError((onError) {
                              AppWidget().itemMessage(Locales.string(context, "lang_error"), context);
                            });
                          }
                        },
                      ),
                    ],
                  )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    DatabaseReference ref = FirebaseDatabase.instance.ref().child('support').child(widget.id.toString()).child("message");
    Stream<DatabaseEvent> stream = ref.onValue;
    stream.listen((DatabaseEvent event) {
      setState(() {});
    });
  }
}
