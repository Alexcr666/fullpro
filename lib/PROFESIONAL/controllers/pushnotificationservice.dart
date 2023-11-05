import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fullpro/PROFESIONAL/models/requestDetails.dart';
import 'package:fullpro/PROFESIONAL/utils/globalConstants.dart';
import 'package:fullpro/PROFESIONAL/widget/DataLoadedProgress.dart';
import 'package:fullpro/PROFESIONAL/widget/NotificationDialog.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PushNotificationService {
  final FirebaseMessaging fcm = FirebaseMessaging.instance;

  // Future<void> _firebaseMessagingBackgroundHandler(
  //     RemoteMessage message) async {
  //   await Firebase.initializeApp();
  // }

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
        if (message.data['ride_id'] != null) {
          fetchRideInfo(getRideID(message), context);
        }
        if (message.data['payment'] != null) {
          paymentDone(message.data['order_id'], message.data['amount'], context);
        }
      }

      //
      if (message.notification != null) {
        debugPrint('Message Data: ${message.notification?.toMap()}');
      }
    });
  }

  Future getToken() async {
    String? token = await fcm.getToken();
    debugPrint('token: $token');

    DatabaseReference tokenRef = FirebaseDatabase.instance.ref().child('partners').child(currentFirebaseUser!.uid).child('token');
    tokenRef.set(token);

    fcm.subscribeToTopic('alldrivers');
    fcm.subscribeToTopic('allusers');
  }

  String getRideID(RemoteMessage message) {
    String rideID = '';

    if (Platform.isAndroid) {
      rideID = message.data['ride_id'];
    }
    return rideID;
  }

  void paymentDone(String orderID, String amount, context) {
    //show please wait dialog
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
                    'Payment Recieved',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Amount Rs.$amount',
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
                      Navigator.pop(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Text('Close'),
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

void fetchRideInfo(String rideID, context) async {
  //show please wait dialog
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) => const Center(
      child: DataLoadedProgress(),
    ),
  );

  final reqRef = FirebaseDatabase.instance.ref().child('requests').child(rideID);
  reqRef.once().then((e) async {
    final _dataSnapshot = e.snapshot;
    Navigator.pop(context);

    if (_dataSnapshot.value != null) {
      assetsAudioPlayer.open(
        Audio("sounds/alert.mp3"),
        autoStart: false,
      );
      assetsAudioPlayer.play();
      //

      double destinationLat = double.parse(_dataSnapshot.child('location').child('latitude').value.toString());
      double destinationLng = double.parse(_dataSnapshot.child('location').child('longitude').value.toString());
      String destinationAddress = _dataSnapshot.child('address').value.toString();
      String paymentMethod = _dataSnapshot.child('payment_method').value.toString();
      String bookerName = _dataSnapshot.child('bookerName').value.toString();
      String bookerToken = _dataSnapshot.child('booker_token').value.toString();
      String orderNumber = _dataSnapshot.child('order_number').value.toString();
      String serviceName = _dataSnapshot.child('itemsNames').value.toString().replaceAll('[', '').replaceAll('_', ' ').replaceAll(']', '');

      String orderStatus = _dataSnapshot.child('status').value.toString();

      RequestDetails krequestDetails = RequestDetails();

      krequestDetails.rideID = rideID;
      krequestDetails.bookerName = bookerName;
      krequestDetails.bookerToken = bookerToken;
      krequestDetails.orderNumber = orderNumber;
      //
      krequestDetails.serviceName = serviceName;
      krequestDetails.destinationAddress = destinationAddress;
      krequestDetails.destination = LatLng(destinationLat, destinationLng);
      krequestDetails.paymentMethod = paymentMethod;

      krequestDetails.orderStatus = orderStatus;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => NotificationDialog(
          krequestDetails: krequestDetails,
        ),
      );
    }
  });
}
