import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:flutter/scheduler.dart';

import 'package:flutter_locales/flutter_locales.dart';

//import 'package:google_fonts/google_fonts.dart';

import 'package:pinput/pinput.dart';

import 'package:fullpro/config.dart';

import 'package:fullpro/pages/homepage.dart';

import 'package:fullpro/pages/Authentication/Database_Entry.dart';

import 'package:fullpro/styles/statics.dart' as Static;

import 'package:fullpro/widgets/DataLoadedProgress.dart';


class OtpPage extends StatefulWidget {

  static const String id = 'verify_top';


  bool _isInit = true;

  var _contact = '';


  @override

  _OtpPageState createState() => _OtpPageState();

}


class _OtpPageState extends State<OtpPage> {

  String? phoneNo;

  String smsOTP = '';

  String? verificationId;

  String? errorMessage = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Timer? _timer;

  bool _dataisLoading = true;


  //

  final skcontroller = TextEditingController();

  final focusNode = FocusNode();


  //this is method is used to initialize data

  @override

  void didChangeDependencies() {

    super.didChangeDependencies();

    // Load data only once after screen load

    if (widget._isInit) {

      widget._contact = ModalRoute.of(context)?.settings.arguments as String;


      generateOtp(widget._contact);

      widget._isInit = false;

      _dataisLoading = false;


      // Future.delayed(Duration(seconds: 1), () {});

    }

  }


  @override

  void initState() {

    super.initState();

  }


  //dispose controllers

  @override

  void dispose() {

    super.dispose();

    skcontroller.dispose();

    focusNode.dispose();

  }


  //build method for UI

  @override

  Widget build(BuildContext context) {

    const borderColor = Color.fromRGBO(30, 60, 87, 1);

    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);

    const fillColor = Color.fromRGBO(243, 246, 249, 0);

    final defaultPinTheme = PinTheme(

      width: 56,

      height: 56,

      /* textStyle: GoogleFonts.poppins(
        fontSize: 22,
        color: const Color.fromRGBO(30, 60, 87, 1),
      ),*/

      decoration: const BoxDecoration(),

    );


    final cursor = Column(

      mainAxisAlignment: MainAxisAlignment.end,

      children: [

        Container(

          width: 56,

          height: 3,

          decoration: BoxDecoration(

            color: borderColor,

            borderRadius: BorderRadius.circular(8),

          ),

        ),

      ],

    );

    final preFilledWidget = Column(

      mainAxisAlignment: MainAxisAlignment.end,

      children: [

        Container(

          width: 56,

          height: 3,

          decoration: BoxDecoration(

            color: Colors.white,

            borderRadius: BorderRadius.circular(8),

          ),

        ),

      ],

    );


    return _dataisLoading == true

        ? Center(

            child: Container(color: Static.dashboardCard, child: const Center(child: DataLoadedProgress())),

          )

        : Scaffold(

            resizeToAvoidBottomInset: false,

            backgroundColor: Static.dashboardCard,

            body: SafeArea(

              child: Padding(

                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),

                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    Align(

                      alignment: Alignment.topLeft,

                      child: GestureDetector(

                        onTap: () => Navigator.pop(context),

                        child: const Icon(

                          Icons.arrow_back,

                          size: 32,

                          color: Colors.black54,

                        ),

                      ),

                    ),

                    const SizedBox(height: 30),


                    // Container(

                    //   width: 150,

                    //   child: Image.asset(

                    //     'images/otp_sent.gif',

                    //   ),

                    // ),

                    const SizedBox(

                      height: 5,

                    ),

                    Text(

                      Locales.string(context, 'lbl_enter_verification_code'),

                      style: const TextStyle(

                        fontSize: 25,

                        fontWeight: FontWeight.bold,

                      ),

                    ),

                    const SizedBox(

                      height: 10,

                    ),

                    Text(

                      widget._contact.toString(),

                      style: const TextStyle(

                        fontSize: 16,

                        color: Colors.black45,

                      ),

                      textAlign: TextAlign.center,

                    ),

                    const SizedBox(

                      height: 15,

                    ),

                    Container(

                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),

                      decoration: BoxDecoration(

                        color: Static.dashboardCard,

                        borderRadius: BorderRadius.circular(12),

                      ),

                      child: Column(

                        children: [

                          // Pin Input

                          Pinput(

                            length: 6,

                            pinAnimationType: PinAnimationType.slide,

                            controller: skcontroller,

                            focusNode: focusNode,

                            defaultPinTheme: defaultPinTheme,

                            showCursor: true,

                            cursor: cursor,

                            androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsRetrieverApi,

                            listenForMultipleSmsOnAndroid: true,

                            preFilledWidget: preFilledWidget,

                            onClipboardFound: (value) {

                              debugPrint('onClipboardFound: $value');

                              skcontroller.setText(value);

                            },

                            hapticFeedbackType: HapticFeedbackType.lightImpact,

                            onCompleted: (pin) {

                              verifyOtp();

                            },

                            onChanged: (e) {

                              smsOTP = e;

                            },

                            submittedPinTheme: defaultPinTheme.copyWith(

                              decoration: defaultPinTheme.decoration!.copyWith(

                                color: Colors.white,

                                borderRadius: BorderRadius.circular(3),

                              ),

                            ),

                            errorPinTheme: defaultPinTheme.copyWith(

                              decoration: defaultPinTheme.decoration!.copyWith(

                                border: Border.all(color: Colors.redAccent),

                                borderRadius: BorderRadius.circular(3),

                              ),

                            ),

                          ),

                        ],

                      ),

                    ),

                    const SizedBox(

                      height: 18,

                    ),

                    Text(

                      Locales.string(context, 'lbl_did_not_received_code'),

                      style: const TextStyle(

                        fontSize: 14,

                        fontWeight: FontWeight.bold,

                        color: Colors.black38,

                      ),

                      textAlign: TextAlign.center,

                    ),

                    const SizedBox(

                      height: 18,

                    ),

                    TextButton(

                      onPressed: () => Navigator.pop(context),

                      child: Text(

                        Locales.string(context, 'lbl_resend_code'),

                        style: const TextStyle(

                          fontSize: 18,

                          fontWeight: FontWeight.bold,

                          color: Colors.black,

                        ),

                        textAlign: TextAlign.center,

                      ),

                    ),

                  ],

                ),

              ),

            ),

          );

  }


  //Method for generate otp from firebase

  Future<void> generateOtp(String contact) async {

    smsOTPSent(String verId, [int? forceCodeResend]) {

      verificationId = verId;

    }


    try {

      SchedulerBinding.instance.addPostFrameCallback((_) {

        showDialog(

          barrierDismissible: false,

          context: context,

          builder: (BuildContext context) => const Center(

            child: DataLoadedProgress(),

          ),

        );

      });

      await _auth.verifyPhoneNumber(

        phoneNumber: contact,

        codeAutoRetrievalTimeout: (String verId) {

          verificationId = verId;

          Navigator.pop(context);


          ErrorDialog(context, Locales.string(context, 'error_verification_timeout'));

        },

        codeSent: smsOTPSent,

        timeout: const Duration(seconds: 60),

        verificationCompleted: (AuthCredential phoneAuthCredential) {

          Navigator.pop(context);

        },

        verificationFailed: (e) {

          Navigator.pop(context);

          handleError(e);

        },

      );

    } on FirebaseAuthException catch (e) {

      Navigator.pop(context);

      handleError(e);

    }

  }


  //Method for verify otp entered by user

  Future<void> verifyOtp() async {

    showDialog(

      context: context,

      builder: (BuildContext context) => const Center(

        child: DataLoadedProgress(),

      ),

    );

    try {

      final AuthCredential credential = PhoneAuthProvider.credential(

        verificationId: verificationId!,

        smsCode: smsOTP,

      );

      final UserCredential user = await _auth.signInWithCredential(credential);

      final User? currentUser = _auth.currentUser;

      assert(user.user?.uid == currentUser?.uid);


      DatabaseReference phoneRef = FirebaseDatabase.instance.ref().child('users/${currentUser!.uid}');


      phoneRef.once().then((e) async {

        final snapshot = e.snapshot;

        if (snapshot.exists) {

          return;

        } else {

          Map userMap = {

            'fullname': '$appName User',

            'currentAddress': Locales.string(context, 'lbl_set_current_address'),

            'manualAddress': Locales.string(context, 'lbl_set_manual_address'),

            'phone': widget._contact,

            'AddressinUse': "current",

          };

          phoneRef.set(userMap);

        }

      });


      DatabaseReference nameRef = FirebaseDatabase.instance.ref().child('users/${currentUser.uid}').child('fullname');


      nameRef.once().then((e) async {

        final snapshot = e.snapshot;

        if (snapshot.exists) {

          Navigator.pushReplacement(

            context,

            MaterialPageRoute(builder: (context) => const kHomePage()),

          );

        } else {

          Navigator.pushReplacement(

            context,

            MaterialPageRoute(

              builder: (context) => DatabaeEntry(

                phone: widget._contact,

                userid: currentUser.uid,

              ),

            ),

          );

        }

      });

    } on FirebaseAuthException catch (e) {

      Navigator.pop(context);

      handleError(e);

    }

  }


  //Method for handle the errors

  void handleError(FirebaseAuthException error) {

    switch (error.code) {

      case 'ERROR_INVALID_VERIFICATION_CODE':

        ErrorDialog(context, Locales.string(context, 'error_verification_invalid'));

        break;

      case 'invalid-verification-code':

        ErrorDialog(context, Locales.string(context, 'error_verification_invalid'));

        break;

      default:

        ErrorDialog(context, error.message!);

        break;

    }

  }


  void ErrorDialog(BuildContext context, String message) {

    showDialog(

      barrierDismissible: false,

      context: context,

      builder: (BuildContext context) => Center(

        child: Dialog(

          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),

          backgroundColor: Colors.transparent,

          child: Container(

            margin: const EdgeInsets.all(16.0),

            width: double.infinity,

            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),

            child: Padding(

              padding: const EdgeInsets.all(16),

              child: Column(

                mainAxisSize: MainAxisSize.min,

                children: <Widget>[

                  const Icon(

                    Icons.close,

                    size: 35,

                    color: Colors.red,

                  ),

                  const SizedBox(height: 10),

                  Center(

                    child: Text(

                      '\n$message',

                      style: const TextStyle(fontSize: 14),

                    ),

                  ),

                  const SizedBox(height: 10),

                  Center(

                      child: TextButton(

                    style: ButtonStyle(

                      backgroundColor: MaterialStateProperty.all(

                        Colors.black,

                      ),

                      foregroundColor: MaterialStateProperty.all(

                        Colors.white,

                      ),

                    ),

                    onPressed: () {

                      Navigator.pop(context);

                    },

                    child: Text(Locales.string(context, 'lbl_close')),

                  ))

                ],

              ),

            ),

          ),

        ),

      ),

    );

  }


  //Basic alert dialogue for alert errors and confirmations

  void showAlertDialog(BuildContext context, String message) {

    // set up the AlertDialog

    final CupertinoAlertDialog alert = CupertinoAlertDialog(

      title: const Text('Error'),

      content: Text('\n$message'),

      actions: <Widget>[

        CupertinoDialogAction(

          isDefaultAction: true,

          child: Text(Locales.string(context, 'lbl_ok')),

          onPressed: () {

            Navigator.of(context).pop();

          },

        )

      ],

    );

    // show the dialog

    showDialog(

      context: context,

      builder: (BuildContext context) {

        return alert;

      },

    );

  }

}

