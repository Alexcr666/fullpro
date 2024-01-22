// ignore_for_file: prefer_const_constructors
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fullpro/PROFESIONAL/controllers/mainController.dart';
import 'package:fullpro/PROFESIONAL/views/homepage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:power_file_view/power_file_view.dart';
import 'package:provider/provider.dart';
import 'package:fullpro/controller/mainController.dart';
import 'package:fullpro/pages/Authentication/Database_Entry.dart';

import 'package:fullpro/pages/Authentication/register.dart';
import 'package:fullpro/pages/Authentication/registerationpage.dart';
import 'package:fullpro/pages/Authentication/loginpage.dart';
import 'package:fullpro/pages/trending.dart';
import 'package:fullpro/provider/Appdata.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fullpro/utils/globalConstants.dart';
import 'package:fullpro/styles/theme.dart';
import 'package:fullpro/pages/homepage.dart';
import 'package:fullpro/utils/userpreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/onboarding/pages/boarding/onboarding.dart';
import 'package:flutter_locales/flutter_locales.dart';

bool professionalState = false;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = "pk_test_51MVzfVJD6GFsjF8jq2jnRULZtIPFzMC4dlOpAhyEM4iEdV8OFOU7OozX2TUFqkWueBVnAyUWhFVmYBjn2it8txbC00XmD1ftqH";
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
  PowerFileViewManager.initEngine();
  await Locales.init(
      ['en', 'af', 'ar', 'de', 'es', 'fr', 'hi', 'ur', 'id', 'ja', 'nl', 'pt', 'tr', 'it', 'ko', 'ne', 'ru', 'vi', 'he', 'th']);

  // Initialize Firebase
  await Firebase.initializeApp();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Check if User Loggedin
  currentFirebaseUser = FirebaseAuth.instance.currentUser;
  // User Shared Prefrences
  await UserPreferences.init();
  MainController.getSettings();
  MainControllerProfesional.getSettings();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getBool("professional") != null) {
    professionalState = prefs.getBool("professional")!;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: LocaleBuilder(
        builder: (locale) => MaterialApp(
          localizationsDelegates: Locales.delegates,
          supportedLocales: Locales.supportedLocales,
          locale: locale,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            radioTheme: RadioThemeData(
              fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
            ),
            textTheme: GoogleFonts.montserratTextTheme(
              Theme.of(context).textTheme,
            ),
            primaryColor: Color(0xff111111),
            primarySwatch: PrimaryMaterialColor,
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Color.fromARGB(255, 74, 64, 64),
                ),
              ),
            ),
          ),
          initialRoute: currentFirebaseUser != null
              ? professionalState == true
                  ? HomePage.id
                  : kHomePage.id
              : LoginPage.id,
          routes: {
            kHomePage.id: (context) => kHomePage(),
            kTrending.id: (context) => kTrending(),
            Onboarding.id: (context) => Onboarding(),
            Register.id: (context) => Register(),
            DatabaeEntry.id: (context) => DatabaeEntry(),
            RegistrationPage.id: (context) => RegistrationPage(),
            LoginPage.id: (context) => LoginPage(),
            HomePage.id: (context) => HomePage(),
          },
        ),
      ),
    );
  }
}
