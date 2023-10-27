import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fullpro/config.dart';
import 'package:fullpro/controller/loader.dart';
import 'package:fullpro/pages/INTEGRATION/styles/color.dart';
import 'package:fullpro/pages/homepage.dart';
import 'package:fullpro/widgets/widget.dart';
import '../styles/statics.dart' as Static;

class TermsPage extends StatefulWidget {
  const TermsPage({Key? key}) : super(key: key);
  static const String id = 'TermsPage';

  @override
  State<TermsPage> createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Static.dashboardBG,
      /* appBar: AppBar(
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
      ),*/
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
              Container(
                  margin: EdgeInsets.only(left: 50, right: 50),
                  child: Text(
                    "Términos , condiciones y políticas de privacidad : ",
                    style: TextStyle(
                      color: secondryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              SizedBox(
                height: 50,
              ),

              Text(
                '$appName ${Locales.string(context, 'lbl_terms_para_one')}',
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Roboto-Regular',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              //
              //
              const SizedBox(height: 40),
              Container(
                  margin: EdgeInsets.only(left: 70, right: 70),
                  child: AppWidget().buttonFormWhite(context, "Regresar", tap: () {
                    Loader.PagewithHome(context, const kHomePage());
                  })),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
