import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fullpro/config.dart';
import 'package:fullpro/utils/globalConstants.dart';
import 'package:fullpro/controller/ordersController.dart';
import 'package:fullpro/widgets/DataLoadedProgress.dart';
import 'package:fullpro/widgets/cart/assignedDialog.dart';
import 'package:fullpro/widgets/cart/declinedDialog.dart';

class PushNotificationService {
  final FirebaseMessaging fcm = FirebaseMessaging.instance;

  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
  }

  Future initialize(context) async {
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (Platform.isAndroid) {
        String orderID = message.data['order_id'];
        String orderStatus = message.data['order_status'];
        String amount = message.data['amount'];

        if (message.data['order_status'] != null) {
          showDeclineDialod(getorderStatus(message), context);
        } else if (message.data['order_id'] != null) {
          fetchOrderInfo(getorderID(message), context);
        }

        if (message.data['amount'] != null) {
          print('uper amount ${message.data['amount']}');
          payDialog(message.data['amount'], message.data['orderID'], context);
        }
      }
      //
      if (message.notification != null) {
        print('Message Data: ${message.notification?.toMap()}');
      }
    });
  }

  Future getToken() async {
    String? token = await fcm.getToken();
    userToken = token;
    print('token: $userToken');

    DatabaseReference tokenRef = FirebaseDatabase.instance.ref().child('users').child(currentFirebaseUser!.uid).child('token');
    tokenRef.set(token);

    fcm.subscribeToTopic('alldrivers');
    fcm.subscribeToTopic('allusers');
  }

  String getorderID(RemoteMessage message) {
    String orderID = '';

    if (Platform.isAndroid) {
      orderID = message.data['order_id'];
    }
    return orderID;
  }

  String getorderStatus(RemoteMessage message) {
    String orderStatus = '';

    if (Platform.isAndroid) {
      orderStatus = message.data['order_status'];
    }
    return orderStatus;
  }

  void showDeclineDialod(String orderStatus, context) async {
    //show please wait dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => const Center(
        child: DataLoadedProgress(),
      ),
    );

    Navigator.pop(context);
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => DeclinedDialog(orderStatus: orderStatus),
    );
  }

  // Order Assigned Dialog
  void fetchOrderInfo(String orderID, context) async {
    //show please wait dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => const Center(
        child: DataLoadedProgress(),
      ),
    );

    Navigator.pop(context);
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AssignedDialog(orderID: orderID),
    );
  }

  // Payment Dialg / Notification
  void payDialog(String amount, String orderID, context) async {
    //show please wait dialog

    print('amount is $orderID');
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => const Center(
        child: DataLoadedProgress(),
      ),
    );

    Navigator.pop(context);
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
                  Image.asset(
                    'images/confirm/chear.gif',
                    width: 300,
                  ),
                  const Text(
                    'Order Completed',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    currencyPos == 'left' ? 'Pay $currencySymbol$amount' : 'Pay $amount$currencySymbol',
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
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
                      // Update Order Data
                      DatabaseReference orderRef = FirebaseDatabase.instance.ref().child('requests').child(orderID);

                      orderRef.update({'status': 'Completed'});

                      orderRef.once().then((e) {
                        final snapshot = e.snapshot;
                        String partnerID = snapshot.child('partner_id').value.toString();

                        String amount = snapshot.child('totalprice').value.toString();

                        OrdersController.payPartner(partnerID, amount, orderID, context);
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Text('Pay Now'),
                    ),
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
