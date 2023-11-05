import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fullpro/PROFESIONAL/config.dart';
import 'package:fullpro/PROFESIONAL/controllers/loader.dart';
import 'package:fullpro/PROFESIONAL/utils/userpreferences.dart';
import 'package:fullpro/PROFESIONAL/views/onboarding/pages/boarding/onboarding.dart';

import 'package:fullpro/styles/statics.dart' as Static;

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);
  static const String id = 'GetStarted';

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  Timer? timer;

  // Initialization
  @override
  void initState() {
    super.initState();
    // Repeating Function
    timer = Timer.periodic(
      const Duration(seconds: 2),
      (Timer t) => setState(() {
        //  Get Settings
        appName = UserPreferences.getAppName();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Static.dashboardBG,
      body: Center(
        child: SingleChildScrollView(
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
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Static.themeColor[500]!,
                    child: SvgPicture.asset(
                      'images/appicon.svg',
                      color: Colors.white,
                      width: 40,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    Locales.string(context, 'lbl_welcome'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Roboto-Regular',
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    Locales.string(context, 'lbl_home_care'),
                    style: const TextStyle(
                      fontSize: 25,
                      fontFamily: 'Roboto-Bold',
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    Locales.string(context, 'lbl_service_provider'),
                    style: const TextStyle(
                      fontSize: 25,
                      fontFamily: 'Roboto-Bold',
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    Locales.string(context, 'lbl_app_description'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Roboto-Regular',
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 40),
                  MaterialButton(
                    onPressed: () {
                      Loader.page(context, Onboarding());
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    elevation: 0,
                    highlightElevation: 0,
                    color: Colors.black87,
                    textColor: Colors.white,
                    child: Text(
                      '${Locales.string(context, 'lbl_get_started')}  ━━━',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
