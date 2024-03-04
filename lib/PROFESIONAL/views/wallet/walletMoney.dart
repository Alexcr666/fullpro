import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fullpro/PROFESIONAL/detailsOrderProfessional.dart';
import 'package:fullpro/config.dart';
import 'package:fullpro/controller/loader.dart';
import 'package:fullpro/pages/INTEGRATION/styles/color.dart';
import 'package:fullpro/pages/aboutMore.dart';
import 'package:fullpro/pages/searchPage.dart';
import 'package:fullpro/widgets/widget.dart';
import 'package:intl/intl.dart';
import 'package:money_formatter/money_formatter.dart';

class WallletPage extends StatefulWidget {
  const WallletPage({Key? key}) : super(key: key);
  static const String id = 'AboutPage';

  @override
  State<WallletPage> createState() => _WallletPageState();
}

class _WallletPageState extends State<WallletPage> {
  getTotalPay() {
    FirebaseDatabase.instance
        .ref()
        .child('ordens')
        .orderByChild("professional")
        .equalTo(FirebaseAuth.instance.currentUser!.uid.toString())
        .once()
        .then((value) {});
  }

  TextEditingController _filterStart = TextEditingController();
  TextEditingController _filterEnd = TextEditingController();

  void _showAlertFilter(ctx, int index) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              height: 190,
              color: Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  Container(
                    height: 180,
                    child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: DateTime.now(),
                        maximumDate: DateTime.now(),
                        onDateTimeChanged: (val) {
                          setState(() {
                            final f = new DateFormat('yyyy-MM-dd');

                            if (index == 1) {
                              _filterStart.text = f.format(val);
                            } else {
                              _filterEnd.text = f.format(val);
                            }

                            //    dateController.text = f.format(val);
                            //  dateSelected = val.toString();
                          });
                        }),
                  ),
                ],
              ),
            ));
  }

  bool cartera = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                AppWidget().back(context),
                SizedBox(
                  height: 20,
                ),
                AppWidget().titleAdd("Cartera", tap: () {
                  cartera = !cartera;
                  setState(() {});
                }),
                SizedBox(
                  height: 20,
                ),
                cartera == false
                    ? SizedBox()
                    : Column(
                        children: [
                          GestureDetector(
                              onTap: () {
                                _showAlertFilter(context, 1);
                              },
                              child: AppWidget().texfieldFormat(title: "Fecha inicio", controller: _filterStart, enabled: true)),
                          SizedBox(
                            height: 5,
                          ),
                          GestureDetector(
                              onTap: () {
                                _showAlertFilter(context, 2);
                              },
                              child: AppWidget().texfieldFormat(title: "Fecha fin", controller: _filterEnd, enabled: true)),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                FutureBuilder(
                    future: FirebaseDatabase.instance
                        .ref()
                        .child('ordens')
                        .orderByChild("professional")
                        .equalTo(FirebaseAuth.instance.currentUser!.uid.toString())
                        .once(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      bool result = false;
                      if (snapshot.hasData) {
                        DatabaseEvent response = snapshot.data;

                        DataSnapshot? dataListObject = null;
                        double total = 0;

                        double totalPorcent = 0;

                        for (var i = 0; i < response.snapshot.children.toList().length; i++) {
                          DataSnapshot data = response.snapshot.children.toList()[i];

                          total += int.parse(data.child("price").value.toString());
                        }
                        totalPorcent = (total - (total / 10));

                        //return Text(dataListObject!.child("name").value.toString());

                        return response.snapshot.children.toList().length == 0
                            ? AppWidget().noResult(context)
                            : Container(
                                width: double.infinity,
                                height: 140,
                                child: Center(
                                    child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Total",
                                          style: TextStyle(color: Colors.white, fontSize: 20),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          MoneyFormatter(amount: totalPorcent).output.withoutFractionDigits.toString(),
                                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 70,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Comision",
                                          style: TextStyle(color: Colors.white, fontSize: 20),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          MoneyFormatter(amount: (total / 10)).output.withoutFractionDigits.toString(),
                                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: secondryColor),
                              );
                      }

                      // }

                      return AppWidget().loading(context);
                    }),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Transacciones",
                  style: TextStyle(
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.left,
                ),
                pageOrdensWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget pageOrdensWidget() {
    return FutureBuilder(
        future: FirebaseDatabase.instance
            .ref()
            .child('ordens')
            .orderByChild("professional")
            .equalTo(FirebaseAuth.instance.currentUser!.uid.toString())
            .once(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          bool result = false;
          if (snapshot.hasData) {
            DatabaseEvent response = snapshot.data;

            DataSnapshot? dataListObject = null;

            //   for (var i = 0; i < response.snapshot.children.toList().length; i++) {

            //return Text(dataListObject!.child("name").value.toString());

            return response.snapshot.children.toList().length == 0
                ? AppWidget().noResult(context)
                : ListView.builder(
                    padding: EdgeInsets.only(left: 10.0),
                    itemCount: response.snapshot.children.toList().length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int i) {
                      DataSnapshot dataList = response.snapshot.children.toList()[i];

                      getCancelButton() {
                        if (dataList.child("state").value.toString() == "3" || dataList.child("state").value.toString() == "4") {
                          return true;
                        } else {
                          return false;
                        }
                      }

                      DatabaseEvent? responseUser = null;

                      return ListTile(
                        title: Text(dataList.child("name").value.toString()),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailsOrderProfessionalPage(
                                        dataList: dataList,
                                      )));
                        },
                        leading: Icon(
                          Icons.arrow_upward_outlined,
                          color: secondryColor,
                          size: 30,
                        ),
                        subtitle: Text(
                          MoneyFormatter(amount: double.parse(dataList.child("price").value.toString()))
                              .output
                              .withoutFractionDigits
                              .toString(),
                          style: TextStyle(color: secondryColor, fontSize: 18),
                        ),
                      );
                    });
          }

          // }

          return AppWidget().loading(context);
        });
  }
}
