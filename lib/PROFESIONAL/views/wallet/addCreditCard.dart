import 'package:calender_picker/extra/color.dart';

import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:fullpro/pages/INTEGRATION/styles/color.dart';

import 'package:fullpro/widgets/widget.dart';

class MySample extends StatefulWidget {
  MySample({Key? key, this.dataList}) : super(key: key);
  DataSnapshot? dataList;

  @override
  State<StatefulWidget> createState() => MySampleState();
}

class MySampleState extends State<MySample> {
  bool isLightTheme = true;

  String cardNumber = '';

  String expiryDate = '';

  String cardHolderName = '';

  String cvvCode = '';

  bool isCvvFocused = false;

  bool useGlassMorphism = false;

  bool useBackgroundImage = false;

  bool useFloatingAnimation = true;

  final OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey.withOpacity(0.7),
      width: 2.0,
    ),
  );

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      isLightTheme ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
    );

    return MaterialApp(
      title: 'Flutter Credit Card View Demo',
      debugShowCheckedModeBanner: false,
      themeMode: isLightTheme ? ThemeMode.light : ThemeMode.dark,
      theme: ThemeData(
        textTheme: const TextTheme(
          // Text style for text fields' input.

          titleMedium: TextStyle(color: Colors.black, fontSize: 18),
        ),

        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,

          seedColor: Colors.white,

          background: Colors.black,

          // Defines colors like cursor color of the text fields.

          primary: Colors.black,
        ),

        // Decoration theme for the text fields.

        inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(color: Colors.black),
          labelStyle: const TextStyle(color: Colors.black),
          focusedBorder: border,
          enabledBorder: border,
        ),
      ),
      darkTheme: ThemeData(
        textTheme: const TextTheme(
          // Text style for text fields' input.

          titleMedium: TextStyle(color: Colors.white, fontSize: 18),
        ),

        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,

          seedColor: Colors.black,

          background: Colors.white,

          // Defines colors like cursor color of the text fields.

          primary: Colors.white,
        ),

        // Decoration theme for the text fields.

        inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(color: Colors.white),
          labelStyle: const TextStyle(color: Colors.white),
          focusedBorder: border,
          enabledBorder: border,
        ),
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Builder(
          builder: (BuildContext context) {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ExactAssetImage(
                    isLightTheme ? 'assets/bg-light.png' : 'assets/bg-dark.png',
                  ),
                  fit: BoxFit.fill,
                ),
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      onPressed: () => setState(() {
                        isLightTheme = !isLightTheme;
                      }),
                      icon: Icon(
                        isLightTheme ? Icons.light_mode : Icons.dark_mode,
                      ),
                    ),
                    CreditCardWidget(
                      enableFloatingCard: false,
                      glassmorphismConfig: _getGlassmorphismConfig(),
                      cardNumber: cardNumber,
                      expiryDate: expiryDate,
                      cardHolderName: cardHolderName,
                      cvvCode: cvvCode,
                      bankName: 'Axis Bank',
                      frontCardBorder: useGlassMorphism ? null : Border.all(color: Colors.grey),
                      backCardBorder: useGlassMorphism ? null : Border.all(color: Colors.grey),
                      showBackView: isCvvFocused,
                      obscureCardNumber: true,
                      obscureCardCvv: true,
                      isHolderNameVisible: true,
                      cardBgColor: secondryColor,
                      backgroundImage: useBackgroundImage ? 'assets/card_bg.png' : null,
                      isSwipeGestureEnabled: true,
                      onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
                      customCardTypeIcons: <CustomCardTypeIcon>[
                        CustomCardTypeIcon(
                          cardType: CardType.mastercard,
                          cardImage: Image.asset(
                            'assets/mastercard.png',
                            height: 48,
                            width: 48,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            CreditCardForm(
                              formKey: formKey,
                              obscureCvv: true,
                              obscureNumber: true,
                              cardNumber: cardNumber,
                              cvvCode: cvvCode,
                              isHolderNameVisible: true,
                              isCardNumberVisible: true,
                              isExpiryDateVisible: true,
                              cardHolderName: cardHolderName,
                              expiryDate: expiryDate,
                              inputConfiguration: const InputConfiguration(
                                cardNumberDecoration: InputDecoration(
                                  labelText: 'Numero',
                                  hintText: 'XXXX XXXX XXXX XXXX',
                                ),
                                expiryDateDecoration: InputDecoration(
                                  labelText: 'Fecha de expiración',
                                  hintText: 'XX/XX',
                                ),
                                cvvCodeDecoration: InputDecoration(
                                  labelText: 'CVV',
                                  hintText: 'XXX',
                                ),
                                cardHolderDecoration: InputDecoration(
                                  labelText: 'Nombre',
                                ),
                              ),
                              onCreditCardModelChange: onCreditCardModelChange,
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: _onValidate,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: secondryColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Validate',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    package: 'flutter_credit_card',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onValidate() {
    if (formKey.currentState?.validate() ?? false) {
      print('valid!');

      savedData() {
        DatabaseReference newUserRef = FirebaseDatabase.instance.ref().child('creditcard').push();

        // Prepare data to be saved on users table

        Map userMap = {
          'number': cardNumber,
          'cvv': cvvCode,
          'expiryDate': expiryDate,
          'cardHolder': cardHolderName,
        };

        newUserRef.set(userMap).then((value) {
          Navigator.pop(context);

          AppWidget().itemMessage("Guardado", context);
        }).catchError((onError) {
          AppWidget().itemMessage("Error al guardar", context);
        });
      }

      savedData();
    } else {
      print('invalid!');
    }
  }

  Glassmorphism? _getGlassmorphismConfig() {
    if (!useGlassMorphism) {
      return null;
    }

    final LinearGradient gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[Colors.grey.withAlpha(50), Colors.grey.withAlpha(50)],
      stops: const <double>[0.3, 0],
    );

    return isLightTheme ? Glassmorphism(blurX: 8.0, blurY: 16.0, gradient: gradient) : Glassmorphism.defaultConfig();
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;

      expiryDate = creditCardModel.expiryDate;

      cardHolderName = creditCardModel.cardHolderName;

      cvvCode = creditCardModel.cvvCode;

      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.dataList != null) {
      cardNumber = widget.dataList!.child("number").value.toString();
      cardHolderName = widget.dataList!.child("cardHolder").value.toString();
      cvvCode = widget.dataList!.child("cvv").value.toString();
      expiryDate = widget.dataList!.child("expiryDate").value.toString();
    }
  }
}
