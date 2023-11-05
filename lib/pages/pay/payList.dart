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
                Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: secondryColor),
                    child: SvgPicture.asset("images/icons/add.svg")),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(child: StackedList()),
          ],
        ),
      ),
    );
  }
}
