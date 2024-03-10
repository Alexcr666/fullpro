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
            child: const Text('Create Client'),
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
      paymentIntent = await createPaymentIntent('100000', 'USD');
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
    // try {
    /*
      Map<String, dynamic> body = {
        "country": "US",
        "type": "custom",
        "email": "jenny.rosen@example.com",
        "capabilities": {
          "card_payments": {"requested": "true"},
          "transfers": {"requested": "true"}
        }
      };*/

    final msg = jsonEncode({
      "country": "US",
      "type": "custom",
      "email": "jenny.rosen@example.com",
      "capabilities": {
        "card_payments": {"requested": "true"},
        "transfers": {"requested": "true"}
      },
      "business_type": "individual",
      "individual": {
        "address": "",
        "relationship": {"title": "servicio"},
        "email": "alexecr66@gmail.com",
        "first_name": "alex",
        "gender": "male",
        "id_number": "12345567",
        "last_name": "alex enrique",
        "phone": "3013928129",
        "political_exposure": "none",
        "registered_address": {
          "city": "City",
          "country": "3232",
          "postal_code": "77777",
          "state": "country",
        }
      },
      "business_profile": {"url": "www.fullpro.com"}
    });

    var response = await http.post(
      Uri.parse('https://api.stripe.com/v1/accounts'),
      headers: {'Authorization': 'Bearer $stripeSecretKey', 'Content-Type': 'application/x-www-form-urlencoded'},
      body:
          "type=express&country=US&email=jenny22.rosen%40example.com&capabilities%5Bcard_payments%5D%5Brequested%5D=true&capabilities%5Btransfers%5D%5Brequested%5D=true",
    );
    log(stripeSecretKey);

    // ignore: avoid_print
    log(response.statusCode.toString() + 'Payment Intent Body->>> ${response.body.toString()}');
    return jsonDecode(response.body);
    // } catch (err) {
    // ignore: avoid_print
    // print('err charging user: ${err.toString()}');
    //}
  }

  createTransfers() async {
    try {
      Map<String, dynamic> body = {
        // 'type': 'custom',
        //'country': 'US',
        'amount': '5000',
        'currency': 'usd',
        'destination': 'acct_1OstVoGhxnVdPdcz',
        'source_transaction': 'ch_3OstkeGnUWGQvfrC0Z03KYz3'
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
