import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fullpro/PROFESIONAL/views/homepage.dart';
import 'package:fullpro/config.dart';
import 'package:fullpro/controller/loader.dart';
import 'package:fullpro/pages/INTEGRATION/styles/color.dart';
import 'package:fullpro/pages/homepage.dart';
import 'package:fullpro/widgets/widget.dart';
import 'package:power_file_view/power_file_view.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:path_provider/path_provider.dart';

class PayMethodProfessionalPage extends StatefulWidget {
  PayMethodProfessionalPage({Key? key, this.state}) : super(key: key);
  int? state;

  @override
  State<PayMethodProfessionalPage> createState() => _PayMethodProfessionalPageState();
}

List<String> titles = [
  "",
  "Politicas de privacidad",
  "Terminos y condiciones",
  "Acerca de la aplicación",
];

WebViewController controller = WebViewController();

final TextEditingController _numberController = new TextEditingController();

List<String> listBack = [
  "BANCO DE BOGOTA DESARROLLO 2013",
  "BANCO POPULAR",
  "Banco union Colombia Credito",
  "BANCO UNION COLOMBIANO FD2",
  "ITAU",
  "BANCOLOMBIA",
  "CITIBANK COLOMBIA S.A.",
  "BANCO GNB COLOMBIA (ANTES HSBC)",
  "BANCO GNB SUDAMERIS",
  "BBVA COLOMBIA S.A.",
  "SCOTIABANK COLPATRIA DESARROLLO",
  "BANCO UNION COLOMBIANO",
  "BANCO DE OCCIDENTE",
  "BANCO CAJA SOCIAL DESARROLLO"
      "BANCO CAJA SOCIAL",
  "BANCO TEQUENDAMA",
  "BANCO DE BOGOTA"
      "BANCO AGRARIO",
  "BANCO DAVIVIENDA",
  "BANCO COMERCIAL AVVILLAS S.A.",
  "Banco Web Service ACH WSE 3.0",
  "BANCO CREDIFINANCIERA",
  "BANCAMIA",
  "BANCO PICHINCHA S.A.",
  "BANCO COOMEVA S.A. - BANCOOMEVA",
  "BANCO FALABELLA",
  "BANCO FINANDINA S.A BIC",
  "BANCO SANTANDER COLOMBIA",
  "BANCO COOPERATIVO COOPCENTRAL",
  "BANCO SERFINANZA",
  "LULO BANK",
  "BANKA",
  "SCOTIABANK COLPATRIA UAT",
  "Banco PSE",
  "NEQUI CERTIFICACION"
];

late String downloadPath;
String? downloadUrl;
String selectBack = "Selecciona banco";

class _PayMethodProfessionalPageState extends State<PayMethodProfessionalPage> {
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
              height: 20,
            ),
            Text(
              "Registrar cuenta",
              style: TextStyle(color: secondryColor, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 40,
            ),
            DropdownButton<String>(
              items: listBack.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                selectBack = value.toString();
                setState(() {});
              },
              hint: Flexible(
                  child: Container(
                child: Text(
                  selectBack,
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.end,
                ),
              )),
              style: TextStyle(color: Colors.black, decorationColor: Colors.red),
            ),
            SizedBox(
              height: 20,
            ),
            AppWidget().texfieldFormat(controller: _numberController, title: "Número de cuenta", number: true),
            SizedBox(
              height: 50,
            ),
            AppWidget().buttonFormColor(context, Locales.string(context, "lang_saved"), secondryColor, tap: () {
              userInfoPartners!.ref.update({"numberPay": _numberController.text, "bankPay": selectBack}).then((value) {
                AppWidget().itemMessage("Datos guardados", context);
              }).catchError((onError) {
                AppWidget().itemMessage(Locales.string(context, "lang_error"), context);
              });
            })
          ],
        ),
      ),
    );
  }

  @override
  initState() {
    super.initState();

    if (userInfoPartners != null) {
      if (userInfoPartners!.child("numberPay").value != null) {
        _numberController.text = userInfoPartners!.child("numberPay").value.toString();
      }
      if (userInfoPartners!.child("bankPay").value != null) {
        selectBack = userInfoPartners!.child("bankPay").value.toString();
      }
      Timer.run(() {
        setState(() {});
      });
    }
  }
}
