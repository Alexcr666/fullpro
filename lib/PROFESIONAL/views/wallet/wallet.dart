import 'dart:async';

import 'package:flutter_locales/flutter_locales.dart';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
//import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fullpro/PROFESIONAL/config.dart';
import 'package:fullpro/PROFESIONAL/controllers/mainController.dart';
import 'package:fullpro/PROFESIONAL/utils/globalConstants.dart';
import 'package:fullpro/PROFESIONAL/utils/userpreferences.dart';
import 'package:fullpro/PROFESIONAL/widget/DataLoadedProgress.dart';

import '../../styles/statics.dart' as appcolors;

import 'package:http/http.dart' as http;
import 'dart:convert';

class Wallet extends StatefulWidget {
  const Wallet({Key? key}) : super(key: key);
  static const String id = 'wallet';

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  Timer? timer;
  String selected = 'bank';
  Map<String, dynamic>? paymentIntent;

  // Controllers
  var bankNameController = TextEditingController();
  var accountNumberController = TextEditingController();
  var accountTitleController = TextEditingController();
  var ibanNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();

    bankNameController.text = bankName.toString()!;
    accountNumberController.text = accountNumber!;
    ibanNumberController.text = ibanNumber!;
    accountTitleController.text = accountTitle!;

    // Repeating Function
    timer = Timer.periodic(
      repeatTime,
      (Timer t) => setState(() {
        MainControllerProfesional.checkEarning();
        MainControllerProfesional.dueBalance();
      }),
    );
  }

  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      MainControllerProfesional.checkEarning();
      MainControllerProfesional.dueBalance();
    });
  }

  @override
  void dispose() {
    super.dispose();
    bankNameController.dispose();
    accountNumberController.dispose();
    ibanNumberController.dispose();
    accountTitleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: refreshKey,
      onRefresh: refreshList,
      color: appcolors.secondaryColorSharp,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            Locales.string(context, 'lbl_wallet'),
            style: const TextStyle(color: Colors.black),
          ),
          backgroundColor: appcolors.dashboardBG,
          elevation: 0.0,
          toolbarHeight: 70,
          leading: IconButton(
            onPressed: () {
              setState(() {
                Navigator.pop(context);
              });
            },
            icon: const Icon(
              FeatherIcons.arrowLeft,
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(50)),
                    image: DecorationImage(
                      image: AssetImage("images/drawerbg.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  width: double.infinity,
                  height: 125,
                  child: Stack(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                          ),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        Locales.string(context, 'lbl_current_earnings'),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: appcolors.primaryColorblue,
                                        ),
                                      ),
                                      earningDataLoading
                                          ? const DataLoadedProgress()
                                          : Text(
                                              currencyPos == 'left'
                                                  ? '$currencySymbol${UserPreferences.getUserEarning() ?? getUserEarning}'
                                                  : '${UserPreferences.getUserEarning() ?? getUserEarning}$currencySymbol',
                                              style: const TextStyle(
                                                color: appcolors.primaryColorblue,
                                                fontSize: 30,
                                                fontFamily: 'Brand-Bold',
                                              ),
                                            )
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 30,
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            Locales.string(context, 'lbl_pay_to_admin'),
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 15,
                                              fontFamily: 'Brand-Bold',
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            currencyPos == 'left'
                                                ? '$currencySymbol${dueBalanceValue.toInt()}'
                                                : '${dueBalanceValue.toInt()}$currencySymbol',
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 15,
                                              fontFamily: 'Brand-Bold',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * .68,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    children: [
                      const SizedBox(height: 20),
                      dueBalanceValue.toInt() > dueLimit!
                          ? Text(
                              Locales.string(context, 'warn_account_on_hold'),
                              style: const TextStyle(
                                color: Colors.red,
                                fontFamily: 'Roboto-Bold',
                              ),
                              textAlign: TextAlign.center,
                            )
                          : const SizedBox(),
                      dueBalanceValue < dueLimit!
                          ? const SizedBox()
                          : Text(
                              '${Locales.string(context, 'warn_due_balance_exceed')} ${dueLimit!.toInt()}',
                              style: const TextStyle(
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.center,
                            ),
                      const SizedBox(height: 10),
                      Text(
                        Locales.string(context, 'warn_pay_now_for_more_orders'),
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              selected = 'stripe';
                              bankNameController.text = bankName!;
                              accountNumberController.text = accountNumber!;
                              ibanNumberController.text = ibanNumber!;
                              accountTitleController.text = accountTitle!;
                            },
                            child: Column(
                              children: [
                                Image.asset(
                                  'images/bankpay.png',
                                  width: 60,
                                ),
                                selected == 'stripe' ? const Icon(Icons.arrow_drop_down) : const SizedBox(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              Locales.string(context, 'lbl_how_to_pay'),
                              style: const TextStyle(
                                fontSize: 18,
                                fontFamily: 'Roboto-Bold',
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 15),
                            Text(
                              Locales.string(context, 'lbl_payment_step_one'),
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'Roboto-Regular',
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              Locales.string(context, 'lbl_payment_step_two'),
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'Roboto-Regular',
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              Locales.string(context, 'lbl_payment_step_three'),
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'Roboto-Regular',
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              Locales.string(context, 'lbl_payment_step_four'),
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'Roboto-Regular',
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.black26,
                      ),
                      MaterialButton(
                        onPressed: dueBalanceValue.toInt() == 0
                            ? null
                            : () {
                                makePayment();
                              },
                        disabledColor: Colors.grey.shade400,
                        height: 50,
                        color: appcolors.themeColor[500],
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          Locales.string(context, 'lbl_pay_now'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> makePayment() async {
    /* try {
      String dbalance = dueBalanceValue.toInt().toString();
      paymentIntent = await createPaymentIntent(dbalance, stripeCurrency);
      //Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'], style: ThemeMode.light, merchantDisplayName: appName))
          .then((value) {});

      ///now finally display payment sheeet
      displayPaymentSheet();
    } catch (e, s) {
      print('exception:$e$s');
    }*/
  }

  displayPaymentSheet() async {
    /*
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        // Clear Due Balance
        MainControllerProfesional.cleardueBalance();

        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          Text(
                            Locales.string(context, 'lbl_payment_successful'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ));

        paymentIntent = null;
      }).onError((error, stackTrace) {
        print('Error is:--->$error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }*/
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {'amount': calculateAmount(amount), 'currency': currency, 'payment_method_types[]': 'card'};

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {'Authorization': 'Bearer $stripeSecretKey', 'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );
      // ignore: avoid_print
      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      // ignore: avoid_print
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }
}
