import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fullpro/config.dart';
import 'package:fullpro/controller/loader.dart';
import 'package:fullpro/pages/INTEGRATION/styles/color.dart';
import 'package:fullpro/pages/homepage.dart';
import 'package:fullpro/widgets/widget.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../styles/statics.dart' as Static;

class TermsPage extends StatefulWidget {
  TermsPage({Key? key, this.state}) : super(key: key);
  bool? state;

  @override
  State<TermsPage> createState() => _TermsPageState();
}

WebViewController controller = WebViewController();

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
                    widget.state != true ? "Acerca de la applicación" : "Términos , condiciones y políticas de privacidad : ",
                    style: TextStyle(
                      color: secondryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              SizedBox(
                height: 50,
              ),

              Container(width: double.infinity, height: 200, child: WebViewWidget(controller: controller)),

              /* Text(
                '$appName ${Locales.string(context, 'lbl_terms_para_one')}',
                style: const TextStyle(
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),*/

              const SizedBox(height: 30),
              //
              //
              const SizedBox(height: 40),
              Container(
                  margin: EdgeInsets.only(left: 70, right: 70),
                  child: AppWidget().buttonFormColor(context, "Regresar", Colors.white, colorText: secondryColor, tap: () {
                    //Loader.PagewithHome(context, const kHomePage());
                    Navigator.pop(context);
                  })),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  @override
  initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Color(0x00000000))
      ..enableZoom(false)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {
            print("step1: " + url.toString());
          },
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://fullprorestoration.luislagunaworks.com/login')).then((value) {
        setState(() {});
      });
  }
}
