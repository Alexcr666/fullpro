import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fullpro/config.dart';
import 'package:fullpro/controller/loader.dart';
import 'package:fullpro/pages/INTEGRATION/styles/color.dart';
import 'package:fullpro/pages/homepage.dart';
import 'package:fullpro/widgets/widget.dart';
import 'package:power_file_view/power_file_view.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../styles/statics.dart' as Static;
import 'package:path_provider/path_provider.dart';

class TermsPage extends StatefulWidget {
  TermsPage({Key? key, this.state}) : super(key: key);
  int? state;

  @override
  State<TermsPage> createState() => _TermsPageState();
}

List<String> titles = [
  "",
  "Politicas de privacidad",
  "Terminos y condiciones",
  "Acerca de la aplicación",
];

WebViewController controller = WebViewController();

late String downloadPath;
String? downloadUrl;

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
            Container(
                margin: EdgeInsets.only(left: 50, right: 50),
                child: Text(
                  titles[widget.state!].toString(),
                  style: TextStyle(
                    color: secondryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            SizedBox(
              height: 50,
            ),

            downloadUrl == null
                ? AppWidget().loading(context)
                : Expanded(
                    child: PDF().cachedFromUrl(
                    downloadUrl!,
                    placeholder: (progress) => Center(child: Text('$progress %')),
                    errorWidget: (error) => Center(child: Text(error.toString())),
                  )),
            SizedBox(height: 30),
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
    );
  }

  @override
  initState() {
    super.initState();

    FirebaseDatabase.instance.ref().child('terms').child(widget.state.toString()).once().then((value) {
      String url = value.snapshot.child("value").value.toString();
      downloadUrl = url.toString();
      setState(() {});

      /*  controller = WebViewController()
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
        ..loadRequest(Uri.parse(
                "https://firebasestorage.googleapis.com/v0/b/hospital-23671.appspot.com/o/terms%2F1705866114437.jpg?alt=media&token=ce506597-b228-412b-88a5-acd3affbd0f2"))
            .then((value) {
          setState(() {});
        });
      setState(() {});*/
    });
  }
}
