import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';

import 'package:flutter_locales/flutter_locales.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:fullpro/config.dart';

import 'package:fullpro/controller/loader.dart';

import 'package:fullpro/pages/INTEGRATION/styles/color.dart';

import 'package:fullpro/pages/homepage.dart';

import 'package:fullpro/pages/support/newSupport.dart';
import 'package:fullpro/utils/utils.dart';

import 'package:fullpro/widgets/widget.dart';
import 'package:money_formatter/money_formatter.dart';

import '../styles/statics.dart' as Static;

class PortafolioPage extends StatefulWidget {
  const PortafolioPage({Key? key}) : super(key: key);

  static const String id = 'TermsPage';

  @override
  State<PortafolioPage> createState() => _PortafolioPageState();
}

class _PortafolioPageState extends State<PortafolioPage> {
  Widget stateIndicator0() {
    return FutureBuilder(

        // initialData: 1,

        future: FirebaseDatabase.instance
            .ref()
            .child('portafolio')
            .orderByChild("user")
            .equalTo(FirebaseAuth.instance.currentUser!.uid.toString())
            .once(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          try {
            if (snapshot.hasData) {
              DatabaseEvent response = snapshot.data;

              return response == null
                  ? AppWidget().loading(context)
                  : response.snapshot.children.length == 0
                      ? AppWidget().noResult(context)
                      : ListView.builder(
                          itemCount: response.snapshot.children.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            DataSnapshot dataList = response.snapshot.children.toList()[index];

                            execute() {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        ListTile(
                                          title: new Text(Locales.string(context, 'lang_location')),
                                          onTap: () {
                                            Navigator.pop(context);

                                            AppWidget().optionsEnabled(
                                                "¿Estas seguro que quieres " + Locales.string(context, 'lang_location') + "?", context,
                                                tap: () {
                                              Navigator.pop(context);
                                              dataList.ref.remove().then((value) {
                                                AppWidget().itemMessage("Eliminado", context);

                                                setState(() {});
                                              });
                                            }, tap2: () {
                                              Navigator.pop(context);
                                            });
                                          },
                                        ),
                                        ListTile(
                                          title: new Text(Locales.string(context, "lang_update")),
                                          onTap: () {
                                            Navigator.pop(context);

                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => NewPortafolioPage(
                                                          data: dataList,
                                                        )));
                                          },
                                        ),
                                        ListTile(
                                          title: new Text(Locales.string(context, 'lang_cancel')),
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            }

                            return GestureDetector(
                                onTap: () {
                                  execute();
                                },
                                child: Container(
                                    decoration: AppWidget().boxShandowGrey(),
                                    margin: EdgeInsets.only(top: 10),
                                    padding: EdgeInsets.only(top: 20, right: 20, bottom: 20),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: Image.network(
                                            dataList.child("foto").value == null ? "" : dataList.child("foto").value.toString(),
                                            errorBuilder: (BuildContext? context, Object? exception, StackTrace? stackTrace) {
                                              return Container(
                                                width: 70,
                                                height: 70,
                                                color: Colors.grey.withOpacity(0.3),
                                                child: Icon(
                                                  Icons.image_not_supported_outlined,
                                                  size: 30,
                                                  color: Colors.black.withOpacity(0.2),
                                                ),
                                              );
                                            },
                                            width: 70,
                                            height: 70,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                            width: 160,
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
                                                        Text(
                                                          dataList.child("name").value.toString().capitalize(),
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: secondryColor),
                                                        ),
                                                        Text(
                                                          dataList.child("category").value.toString().capitalize(),
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(fontSize: 10, color: secondryColor),
                                                        ),
                                                        Text(
                                                          '\$' +
                                                              MoneyFormatter(amount: double.parse(dataList.child("price").value.toString()))
                                                                  .output
                                                                  .withoutFractionDigits
                                                                  .toString(),
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(fontSize: 10, color: secondryColor),
                                                        ),
                                                      ],
                                                    )),

                                                    // Expanded(child: SizedBox()),
                                                  ],
                                                ),
                                              ],
                                            )),
                                        MaterialButton(
                                            height: 30,
                                            shape: CircleBorder(),
                                            color: Colors.grey.withOpacity(0.1),
                                            onPressed: () {
                                              execute();

                                              /*  dataList.ref.remove().then((value) {

                                        AppWidget().itemMessage("Eliminado", context);

                                        setState(() {});

                                      });*/
                                            },
                                            child: Icon(
                                              Icons.more_vert_rounded,
                                            ))
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
  void initState() {
    super.initState();
    DatabaseReference ref = FirebaseDatabase.instance.ref("portafolio");

// Get the Stream
    Stream<DatabaseEvent> stream = ref.onValue;

    stream.listen((DatabaseEvent event) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
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
                    "images/icons/maletin.svg",
                    color: secondryColor,
                    width: 35,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                      child: Text(
                    Locales.string(context, "lang_list_portafolio"),
                    style: TextStyle(
                      color: secondryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  Expanded(child: SizedBox()),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => NewPortafolioPage()));
                      },
                      child: Container(
                          width: 40,
                          height: 40,
                          padding: EdgeInsets.all(7),
                          decoration: BoxDecoration(shape: BoxShape.circle, color: secondryColor),
                          child: SvgPicture.asset("images/icons/add.svg"))),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              stateIndicator0(),
            ],
          ),
        ),
      ),
    );
  }
}
