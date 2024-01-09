import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';

import 'package:flutter_locales/flutter_locales.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:fullpro/PROFESIONAL/views/wallet/addCreditCard.dart';

import 'package:fullpro/config.dart';

import 'package:fullpro/controller/loader.dart';

import 'package:fullpro/pages/INTEGRATION/styles/color.dart';

import 'package:fullpro/pages/homepage.dart';

import 'package:fullpro/pages/pay/payItem.dart';

import 'package:fullpro/widgets/widget.dart';

import '../styles/statics.dart' as Static;

class PayListPage extends StatefulWidget {
  const PayListPage({Key? key}) : super(key: key);

  static const String id = 'TermsPage';

  @override
  State<PayListPage> createState() => _PayListPageState();
}

class _PayListPageState extends State<PayListPage> {
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

  @override
  void initState() {
    super.initState();

    DatabaseReference ref = FirebaseDatabase.instance.ref("creditcart");
    Stream<DatabaseEvent> stream = ref.onValue;
    stream.listen((DatabaseEvent event) {
      setState(() {});
    });
  }

  Widget stateIndicator0() {
    return FutureBuilder(
        initialData: 1,
        future: FirebaseDatabase.instance.ref().child('creditcard').once(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          try {
            if (snapshot.hasData) {
              DatabaseEvent response = snapshot.data;

              return response == null
                  ? Text("Cargando")
                  : ListView.builder(
                      itemCount: response.snapshot.children.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        DataSnapshot dataList = response.snapshot.children.toList()[index];

                        return GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        ListTile(
                                          title: new Text('Eliminar'),
                                          onTap: () {
                                            dataList.ref.remove().then((value) {
                                              AppWidget().itemMessage("Eliminado", context);

                                              setState(() {});
                                            });

                                            Navigator.pop(context);
                                          },
                                        ),
                                        ListTile(
                                          title: new Text('Actualizar'),
                                          onTap: () {
                                            Navigator.pop(context);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => MySample(
                                                          dataList: dataList,
                                                        )));
                                          },
                                        ),
                                        ListTile(
                                          title: new Text('Cancelar'),
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 10),
                              decoration: AppWidget().boxShandowGreyRectangule(),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  CircleAvatar(
                                    backgroundColor: Colors.grey.withOpacity(0.3),
                                    radius: 30,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                      child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 100,
                                      ),
                                      Text(
                                        dataList.child("number").value.toString(),
                                        style: TextStyle(color: secondryColor, fontSize: 14, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        dataList.child("cardHolder").value.toString(),
                                        style: TextStyle(color: Colors.black, fontSize: 10),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      SizedBox(
                                        height: 14,
                                      ),
                                    ],
                                  ))
                                ],
                              ),
                            ));
                      });
            } else {
              return AppWidget().loading();
            }

            ;
          } catch (e) {
            return AppWidget().loading();
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
                Container(
                    child: Text(
                  "Tus metodos de pago",
                  style: TextStyle(
                    color: secondryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )),
                Expanded(child: SizedBox()),
                GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MySample()));
                    },
                    child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: secondryColor),
                        child: SvgPicture.asset("images/icons/add.svg"))),
              ],
            ),

            SizedBox(
              height: 20,
            ),

            stateIndicator0(),

            // Expanded(child: StackedList()),
          ],
        ),
      ),
    );
  }
}
