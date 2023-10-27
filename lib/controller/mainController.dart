import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fullpro/config.dart';
import 'package:fullpro/models/settingsModel.dart';
import 'package:fullpro/models/userdata.dart';
import 'package:fullpro/utils/globalConstants.dart';
import 'package:fullpro/controller/RequestController.dart';
import 'package:fullpro/models/address.dart';
import 'package:fullpro/models/services.dart';
import 'package:fullpro/provider/Appdata.dart';
import 'package:fullpro/utils/userpreferences.dart';
import 'package:http/http.dart' as http;

class MainController {
  //

  static Future<String> findCordinateAddress(Position position, context) async {
    String placeAddress = '';

    var connectivityResults = await Connectivity().checkConnectivity();

    if (connectivityResults != ConnectivityResult.mobile && connectivityResults != ConnectivityResult.wifi) {
      return placeAddress;
    }

    var url = Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey');

    var response = await RequestController.getRequest(url, context);

    if (response != 'failed') {
      placeAddress = response['results'][0]['formatted_address'];

      // ignore: unnecessary_new
      Address pickupAddress =
          new Address(latitude: position.latitude, longitude: position.longitude, placeFormattedAddress: '', placeId: '', placeName: '');
      pickupAddress.longitude = position.longitude;
      pickupAddress.latitude = position.latitude;
      pickupAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false).updatePickupAddress(pickupAddress);
    }

    return placeAddress;
  }

  // Gt Manual Address Pin Location
  static Future<String> getAddressPin(LatLng position, context) async {
    String placeAddress = '';

    var connectivityResults = await Connectivity().checkConnectivity();

    if (connectivityResults != ConnectivityResult.mobile && connectivityResults != ConnectivityResult.wifi) {
      return placeAddress;
    }

    var url = Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey');

    var response = await RequestController.getRequest(url, context);

    if (response != 'failed') {
      placeAddress = response['results'][0]['formatted_address'];

      // ignore: unnecessary_new
      Address pickupAddress =
          new Address(latitude: position.latitude, longitude: position.longitude, placeFormattedAddress: '', placeId: '', placeName: '');
      pickupAddress.longitude = position.longitude;
      pickupAddress.latitude = position.latitude;
      pickupAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false).updatePickupAddress(pickupAddress);
    }

    return placeAddress;
  }

  // Date Function

  static String formatMyDate(String datestring) {
    DateTime thisDate = DateTime.parse(datestring);
    String formattedDate =
        '${DateFormat.MMMd().format(thisDate)}, ${DateFormat.y().format(thisDate)} - ${DateFormat.jm().format(thisDate)}';

    return formattedDate;
  }

  // Get User Info
  static void getUserInfo(context) async {
    currentFirebaseUser = FirebaseAuth.instance.currentUser;
    String? userid = currentFirebaseUser?.uid;

    final UserRef = FirebaseDatabase.instance.ref().child("users").child(userid!);
    UserRef.once().then((e) async {
      final DataSnapshot = e.snapshot;

      if (DataSnapshot != null) {
        currentUserInfo = UserData.fromSnapshot(DataSnapshot);

        if (currentUserInfo?.fullName.toString() != null) {
          UserPreferences.setUsername(currentUserInfo!.fullName!);
        }
        if (currentUserInfo?.phone.toString() == null) {
          UserPreferences.setUserPhone(currentUserInfo!.phone!);
        }
      }
    });
  }

  // Get Settings Data
  static void getSettings() async {
    final settRef = FirebaseDatabase.instance.ref().child("settings");
    settRef.once().then((e) async {
      final _dataSnapshot = e.snapshot;

      if (_dataSnapshot.exists) {
        fetchsettings = SettingsModel.fromSnapshot(_dataSnapshot);
        if (fetchsettings?.sMapKey.toString() != null) {
          UserPreferences.setMapKey(fetchsettings!.sMapKey!);
        }
        if (fetchsettings?.sServerKey.toString() != null) {
          UserPreferences.setServerKey(fetchsettings!.sServerKey!);
        }
        if (fetchsettings?.sAppName.toString() != null) {
          UserPreferences.setAppName(fetchsettings!.sAppName!);
        }
        if (fetchsettings?.sAppVer.toString() != null) {
          UserPreferences.setAppVersion(fetchsettings!.sAppVer!);
        }
        if (fetchsettings?.sHelpPhone.toString() != null) {
          UserPreferences.setHelpPhone(fetchsettings!.sHelpPhone!);
        }
        if (fetchsettings?.sHelpWA.toString() != null) {
          UserPreferences.setHelpWA(fetchsettings!.sHelpWA!);
        }
        if (fetchsettings?.sCurrency.toString() != null) {
          UserPreferences.setCurrency(fetchsettings!.sCurrency!);
        }
        if (fetchsettings?.sCurrencyPos.toString() != null) {
          UserPreferences.setCurrencyPos(fetchsettings!.sCurrencyPos!);
        }
      }
    });
  }

  static sendNotification(String token, context, String? rideId, String? itemNames) async {
    print('names ${itemNames}');
    // var destination =
    //     Provider.of<AppData>(context, listen: false).destinationAddress;

    Map<String, String> headerMap = {
      'Content-Type': 'application/json',
      'Authorization': 'key=${serverKey}',
    };

    Map notificationMap = {'title': 'New Service Request', 'body': 'Services: ${itemNames!}', 'sound': "default"};

    Map dataMap = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'ride_id': rideId,
    };

    Map bodyMap = {
      'notification': notificationMap,
      'data': dataMap,
      'priority': 'high',
      'to': token,
    };

    var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    var response = await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'), headers: headerMap, body: jsonEncode(bodyMap));
  }

  static sendPaymentNotification(String token, context, String? amount, String orderID) async {
    print('names $amount');
    // var destination =
    //     Provider.of<AppData>(context, listen: false).destinationAddress;

    Map<String, String> headerMap = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };

    Map notificationMap = {'title': 'Payment Recieved!', 'body': 'Amount: ${amount!}', 'sound': "default"};

    Map dataMap = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'payment': 'done',
      'amount': amount,
      'order_id': orderID,
    };

    Map bodyMap = {
      'notification': notificationMap,
      'data': dataMap,
      'priority': 'high',
      'to': token,
    };

    var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    var response = await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'), headers: headerMap, body: jsonEncode(bodyMap));
  }

  static String capitalize(String str) {
    return str.split(' ').map((word) => word.substring(0, 1).toUpperCase() + word.substring(1)).join(' ');
  }

  // Check Internet Connection
  static Future<void> checkNetwork(context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      debugPrint('I am connected to a mobile network.');
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      debugPrint('I am connected to a wifi network.');
    } else {
      if (connectionChecked == true) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('images/wifi_off.gif', width: 80),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'No Internet access found to Wifi or Celular Data Network!',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              connectionChecked = true;
                            },
                            child: const Text('Try Again'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
      connectionChecked = false;
    }
  }
}
