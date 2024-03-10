import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

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

    DatabaseReference ref = FirebaseDatabase.instance.ref("creditcard");
    Stream<DatabaseEvent> stream = ref.onValue;
    stream.listen((DatabaseEvent event) {
      setState(() {});
    });
  }

  Widget stateIndicator0() {
    return FutureBuilder(
        future: FirebaseDatabase.instance
            .ref()
            .child('creditcard')
            .orderByChild("user")
            .equalTo(FirebaseAuth.instance.currentUser!.uid.toString())
            .once(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
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

                          return GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        ListTile(
                                          title: new Text(Locales.string(context, 'lang_location')),
                                          onTap: () {
                                            dataList.ref.remove().then((value) {
                                              AppWidget().itemMessage("Eliminado", context);

                                              setState(() {});
                                            });

                                            Navigator.pop(context);
                                          },
                                        ),
                                        ListTile(
                                          title: Text(Locales.string(context, "lang_update")),
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
                                          title: new Text(Locales.string(context, 'lang_cancel')),
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: CreditCardWidget(
                              enableFloatingCard: false,
                              glassmorphismConfig: _getGlassmorphismConfig(),
                              cardNumber: dataList.child("number").value.toString(),
                              expiryDate: dataList.child("expiryDate").value.toString(),
                              cardHolderName: dataList.child("cardHolder").value.toString(),
                              cvvCode: dataList.child("cvv").value.toString(),
                              // textStyle: TextStyle(color: Colors.white, fontSize: 13),
                              bankName: 'Axis Bank',
                              frontCardBorder: Border.all(color: Colors.grey),
                              backCardBorder: Border.all(color: Colors.grey),
                              showBackView: false,
                              obscureCardNumber: true,
                              obscureCardCvv: false,
                              isHolderNameVisible: true,
                              cardBgColor: secondryColor,
                              backgroundImage: 'assets/card_bg.png',
                              isSwipeGestureEnabled: false,
                              onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
                              customCardTypeIcons: <CustomCardTypeIcon>[
                                CustomCardTypeIcon(
                                  cardType: CardType.mastercard,
                                  cardImage: Image.asset(
                                    'assets/mastercard.png',
                                    height: 48,
                                    width: 48,
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
          } else {
            return AppWidget().loading(context);
          }

          ;
        });
  }

  Glassmorphism? _getGlassmorphismConfig() {
    final LinearGradient gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[secondryColor, secondryColor],
      stops: const <double>[0.3, 0],
    );

    return Glassmorphism(blurX: 0, blurY: 0, gradient: gradient);
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
                  Locales.string(context, 'lang_methodpay'),
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
