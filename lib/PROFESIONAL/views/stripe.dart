import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fullpro/PROFESIONAL/config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeTest extends StatefulWidget {
  const StripeTest({Key? key}) : super(key: key);
  static const String id = 'StripePay';

  @override
  _StripeTestState createState() => _StripeTestState();
}

class _StripeTestState extends State<StripeTest> {
  Map<String, dynamic>? paymentIntent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stripe Payment'),
      ),
      body: Center(
          child: Column(
        children: [
          TextButton(
            child: const Text('Make Payment'),
            onPressed: () async {
              await makePayment();
            },
          ),
          TextButton(
            child: const Text('Create Payment'),
            onPressed: () async {
              await createClient();
            },
          ),
          TextButton(
            child: const Text('Create Transfers'),
            onPressed: () async {
              await createTransfers();
            },
          ),
        ],
      )),
    );
  }

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent('10', 'USD');
      //Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  // applePay: const PaymentSheetApplePay(merchantCountryCode: '+92',),
                  // googlePay: const PaymentSheetGooglePay(testEnv: true, currencyCode: "US", merchantCountryCode: "+92"),
                  style: ThemeMode.light,
                  merchantDisplayName: 'Adnan'))
          .then((value) async {});

      ///now finally display payment sheeet
      displayPaymentSheet();
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          Text("Payment Successfull"),
                        ],
                      ),
                    ],
                  ),
                ));
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("paid successfully")));

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
    }
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

  createClient() async {
    try {
      Map<String, dynamic> body = {
        // 'type': 'custom',
        //'country': 'US',
        'name': 'alex enrique',
        'email': 'alexecr66@gmail.com',
        /* 'capabilities': {
          'card_payments': {
            'requested': true,
          },
          'transfers': {
            'requested': true,
          },
        },*/
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/customers'),
        headers: {'Authorization': 'Bearer $stripeSecretKey', 'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );
      // ignore: avoid_print
      log('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      // ignore: avoid_print
      print('err charging user: ${err.toString()}');
    }
  }

  createTransfers() async {
    try {
      Map<String, dynamic> body = {
        // 'type': 'custom',
        //'country': 'US',
        'amount': '50000',
        'currency': 'usd',
        'destination': 'acct_1OoSilGheOR3kQ6y',
        'source_transaction': 'ch_3OoA5bGnUWGQvfrC0r0WLPY5'
        /* 'capabilities': {
          'card_payments': {
            'requested': true,
          },
          'transfers': {
            'requested': true,
          },
        },*/
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/transfers'),
        headers: {'Authorization': 'Bearer $stripeSecretKey', 'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );
      // ignore: avoid_print
      log('Payment Intent Body->>> ${response.body.toString()}');
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
