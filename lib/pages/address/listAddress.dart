import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:flutter_locales/flutter_locales.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:fullpro/config.dart';

import 'package:fullpro/controller/loader.dart';

import 'package:fullpro/pages/INTEGRATION/styles/color.dart';

import 'package:fullpro/pages/homepage.dart';

import 'package:fullpro/pages/pay/payItem.dart';

import 'package:fullpro/widgets/widget.dart';

import '../styles/statics.dart' as Static;

class ListAddressPage extends StatefulWidget {
  const ListAddressPage({Key? key}) : super(key: key);

  static const String id = 'TermsPage';

  @override
  State<ListAddressPage> createState() => _ListAddressPageState();
}

class _ListAddressPageState extends State<ListAddressPage> {
  Widget item() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Container(
            margin: EdgeInsets.only(left: 10),
            child: CircleAvatar(
              backgroundColor: Colors.grey.withOpacity(0.3),
            )),
        SizedBox(
          height: 15,
        ),
        Container(
            margin: EdgeInsets.only(left: 30),
            child: Column(
              children: [
                Text(MediaQuery.of(context).size.height.toString()),
                Text(
                  "3034934903",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Manuel felipe",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                )
              ],
            ))
      ],
    );
  }

  Widget pageAddress() {
    return FutureBuilder(
        future: FirebaseDatabase.instance.ref().child('address').once(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            DatabaseEvent response = snapshot.data;

            DataSnapshot? dataListObject = null;

            //   for (var i = 0; i < response.snapshot.children.toList().length; i++) {

            //return Text(dataListObject!.child("name").value.toString());

            return ListView.builder(
                padding: EdgeInsets.only(left: 10.0),
                itemCount: response.snapshot.children.toList().length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int i) {
                  DataSnapshot dataList = response.snapshot.children.toList()[i];

                  return /*dataList.child("user").value.toString() == "LapnDojkb8QGfSOioTXLkiPAiNt2"

                      ? SizedBox()

                      :*/

                      Row(
                    children: [
                      Container(
                          decoration: AppWidget().boxShandowGreyRectangule(),
                          padding: EdgeInsets.only(left: 30, right: 20, top: 15, bottom: 15),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dataList.child("name").value.toString(),
                                    style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    dataList.child("price").value.toString(),
                                    style: TextStyle(color: Colors.black, fontSize: 23, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    dataList.child("description").value.toString(),
                                    style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold),
                                  ),

                                  /*  Text(

                                    "+8,956",

                                    style: TextStyle(color: secondryColor, fontSize: 15, fontWeight: FontWeight.bold),

                                  ),*/
                                ],
                              ),
                              SizedBox(
                                width: 25,
                              ),
                              Container(
                                width: 55,
                                height: 55,
                                padding: EdgeInsets.all(10),
                                child: SvgPicture.asset(
                                  "images/icons/calendar.svg",
                                  color: Colors.white,
                                ),
                                color: secondryColor,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                            ],
                          ))
                    ],
                  );
                });
          }

          // }

          return Text("hola");
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
                Container(
                    child: Text(
                  "Agregar o escoge una direccións",
                  style: TextStyle(
                    color: secondryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )),
                Expanded(child: SizedBox()),
                Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: secondryColor),
                    child: SvgPicture.asset("images/icons/add.svg")),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Container(
                    child: Text(
                  "Ubicación Actual",
                  style: TextStyle(
                    color: secondryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )),
                Expanded(child: SizedBox()),
                Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: secondryColor),
                    child: SvgPicture.asset("images/icons/add.svg")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
