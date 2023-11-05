// ignore_for_file: prefer_const_constructors
/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:fullpro/PROFESIONAL/controllers/mainController.dart';
import 'package:fullpro/PROFESIONAL/provider/Appdata.dart';
import 'package:fullpro/PROFESIONAL/styles/theme.dart';
import 'package:fullpro/PROFESIONAL/utils/globalConstants.dart';
import 'package:fullpro/PROFESIONAL/utils/userpreferences.dart';
import 'package:fullpro/PROFESIONAL/views/Authentication/CategorySelection.dart';
import 'package:fullpro/PROFESIONAL/views/Authentication/DatabaseEntry.dart';
import 'package:fullpro/PROFESIONAL/views/Authentication/loginpage.dart';
import 'package:fullpro/PROFESIONAL/views/Authentication/otp.dart';
import 'package:fullpro/PROFESIONAL/views/Authentication/register.dart';
import 'package:fullpro/PROFESIONAL/views/Authentication/registerationpage.dart';
import 'package:fullpro/PROFESIONAL/views/Orders/orders.dart';
import 'package:fullpro/PROFESIONAL/views/homepage.dart';
import 'package:fullpro/PROFESIONAL/views/stripe.dart';
import 'package:fullpro/PROFESIONAL/views/wallet/wallet.dart';
import 'package:provider/provider.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = "pk_test_51MVzfVJD6GFsjF8jq2jnRULZtIPFzMC4dlOpAhyEM4iEdV8OFOU7OozX2TUFqkWueBVnAyUWhFVmYBjn2it8txbC00XmD1ftqH";
  // Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  // Stripe.urlScheme = 'flutterstripe';
  // await Stripe.instance.applySettings();
  await Locales.init(
      ['en', 'af', 'ar', 'de', 'es', 'fr', 'hi', 'ur', 'id', 'ja', 'nl', 'pt', 'tr', 'it', 'ko', 'ne', 'ru', 'vi', 'he', 'th']);
  await Firebase.initializeApp();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  currentFirebaseUser = FirebaseAuth.instance.currentUser;

  await UserPreferences.init();
  MainControllerProfesional.getSettings();

  await Future.delayed(const Duration(seconds: 2), () {
    FlutterNativeSplash.remove();
  });

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
          debugShowCheckedModeBanner: false,
          localizationsDelegates: Locales.delegates,
          supportedLocales: Locales.supportedLocales,
          locale: locale,
          theme: myTheme,
          initialRoute: (currentFirebaseUser == null) ? RegistrationPage.id : HomePage.id,
          routes: {
            HomePage.id: (context) => HomePage(),
            StripeTest.id: (context) => StripeTest(),
            Register.id: (context) => Register(),
            RegistrationPage.id: (context) => RegistrationPage(),
            LoginPageProfesional.id: (context) => LoginPageProfesional(),
            OtpPage.id: (context) => OtpPage(),
            DatabaseEntry.id: (context) => DatabaseEntry(),
            CategorySelection.id: (context) => CategorySelection(),
            MyOrders.id: (context) => MyOrders(),
            Wallet.id: (context) => Wallet(),
          },
        ),
      ),
    );
  }
}
*/