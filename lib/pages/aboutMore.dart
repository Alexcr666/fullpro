import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fullpro/config.dart';
import 'package:fullpro/controller/loader.dart';
import 'package:fullpro/pages/homepage.dart';
import '../styles/statics.dart' as Static;

class AboutDetails extends StatefulWidget {
  const AboutDetails({Key? key}) : super(key: key);
  static const String id = 'AboutDetails';

  @override
  State<AboutDetails> createState() => _AboutDetailsState();
}

class _AboutDetailsState extends State<AboutDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Static.dashboardBG,
      appBar: AppBar(
        backgroundColor: Static.dashboardBG,
        elevation: 0.0,
        toolbarHeight: 80,
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
                  Text(
                    Locales.string(context, 'lbl_about_heading_one'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto-Bold',
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '$appName ${Locales.string(context, 'lbl_about_para_one')}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Roboto-Regular',
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 30),
                  //
                  //
                  Text(
                    Locales.string(context, 'lbl_about_heading_two'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto-Bold',
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    Locales.string(context, 'lbl_about_para_two'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Roboto-Regular',
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 30),
                  //
                  //
                  Text(
                    Locales.string(context, 'lbl_about_heading_three'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto-Bold',
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    Locales.string(context, 'lbl_about_para_three'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Roboto-Regular',
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 40),
                  MaterialButton(
                    onPressed: () {
                      Loader.PagewithHome(context, kHomePage());
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
                      '${Locales.string(context, 'lbl_go_home')} ━━━',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
