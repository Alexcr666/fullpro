import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fullpro/config.dart';
import 'package:fullpro/controller/loader.dart';
import 'package:fullpro/pages/aboutMore.dart';
import 'package:fullpro/pages/searchPage.dart';
import '../styles/statics.dart' as Static;

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);
  static const String id = 'AboutPage';

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Static.dashboardBG,
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          Locales.string(context, 'lbl_about'),
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Static.dashboardBG,
        elevation: 0.0,
        toolbarHeight: 70,
        leadingWidth: 10,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                Navigator.pop(context);
                Navigator.pop(context);
                Loader.page(context, kSearchPage());
              });
            },
            icon: const Icon(
              FeatherIcons.search,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
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
                    '${Locales.string(context, 'lbl_about')} $appName',
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Roboto-Regular',
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    Locales.string(context, 'lbl_home_care'),
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'Roboto-Bold',
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    Locales.string(context, 'lbl_service_provider'),
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'Roboto-Bold',
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    Locales.string(context, 'lbl_app_description'),
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Roboto-Regular',
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 40),
                  MaterialButton(
                    onPressed: () {
                      Loader.page(context, const AboutDetails());
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
                      '${Locales.string(context, 'lbl_learn_more')}  ━━━',
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
