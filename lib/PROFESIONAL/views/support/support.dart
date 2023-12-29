import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fullpro/PROFESIONAL/config.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:fullpro/styles/statics.dart' as Static;

class SupportPage extends StatefulWidget {
  const SupportPage({Key? key}) : super(key: key);
  static const String id = 'SupportPage';

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Static.dashboardBG,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Locales.string(context, 'lbl_get_help'),
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Static.dashboardBG,
        elevation: 0.0,
        toolbarHeight: 70,
        leadingWidth: 100,
        leading: IconButton(
          splashColor: Colors.transparent,
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
          icon: SvgPicture.asset('images/svg_icons/arrowLeft.svg'),
        ),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 24,
          ),
          child: Column(
            children: [
              Center(
                child: Container(
                  child: Image.asset(
                    'images/help_2.png',
                    width: 230,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                Locales.string(context, 'lbl_help_text'),
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'Roboto-Bold',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  launchUrl(Uri.parse("tel://$helpPhone"));
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: const [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Static.dashboardCard,
                          child: Icon(
                            FeatherIcons.phone,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          Locales.string(context, 'lbl_phone_number'),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'Roboto-Bold',
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          helpPhone!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Brand-Regular',
                            color: Static.colorTextLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  openwhatsapp(helpWhatsapp!);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Static.dashboardCard,
                          child: SvgPicture.asset(
                            'images/svg_icons/whatsapp.svg',
                            width: 25,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          Locales.string(context, 'lbl_whatsapp_number'),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'Roboto-Bold',
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          helpWhatsapp!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Brand-Regular',
                            color: Static.colorTextLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Image.asset(
                  'images/logo.png',
                  width: 120,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '$appName V$appVersion',
              ),
            ],
          ),
        ),
      ),
    );
  }

  openwhatsapp(String number) async {
    var whatsapp = number;
    var msg = Locales.string(context, 'lbl_whatsapp_msg');
    var whatsappURlAndroid = Uri.parse("whatsapp://send?phone=" + whatsapp + "&text=$msg");
    var whatappURLIos = Uri.parse("https://wa.me/$whatsapp?text=${Uri.parse(msg)}");
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunchUrl(whatappURLIos)) {
        await launchUrl(whatappURLIos);
      }
    } else {
      // android , web
      if (await canLaunchUrl(whatsappURlAndroid)) {
        await launchUrl(whatsappURlAndroid);
      } else {
        return false;
      }
    }
  }
}
