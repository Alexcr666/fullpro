// ignore_for_file: file_names
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fullpro/PROFESIONAL/config.dart';
import 'package:fullpro/PROFESIONAL/config.dart';

import 'package:fullpro/PROFESIONAL/controllers/requesthelper.dart';
import 'package:fullpro/PROFESIONAL/models/directiondetails.dart';
import 'package:fullpro/PROFESIONAL/models/partner.dart';
import 'package:fullpro/PROFESIONAL/models/settingsModel.dart';
import 'package:fullpro/PROFESIONAL/utils/globalConstants.dart';
import 'package:fullpro/PROFESIONAL/utils/userpreferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:fullpro/styles/statics.dart' as appcolors;

class MainControllerProfesional {
  // Get Current User Info
  static void getcurrentPartnerInfo() async {
    currentFirebaseUser = FirebaseAuth.instance.currentUser;
    String? userid = currentFirebaseUser?.uid;

    final userRef = FirebaseDatabase.instance.ref().child("Partners").child(userid!);
    userRef.once().then((e) async {
      final _dataSnapshot = e.snapshot;

      if (_dataSnapshot.value != null) {
        currentPartnerInfo = Partner.fromSnapshot(_dataSnapshot);
        //
      }
    });
  }

  // Get Settings Data
  static void getSettings() async {
    final settRef = FirebaseDatabase.instance.ref().child("settings");
    settRef.once().then((e) async {
      final _dataSnapshot = e.snapshot;

      if (_dataSnapshot.exists) {
        fetchsettings = SettingsModelProfesional.fromSnapshot(_dataSnapshot);
        if (fetchsettings?.sMapKey.toString() != null) {
          UserPreferences.setMapKey(fetchsettings!.sMapKey!);
        }
        if (fetchsettings?.sServerKey.toString() != null) {
          UserPreferences.setServerKey(fetchsettings!.sServerKey!);
        }
        if (fetchsettings?.sCurrency.toString() != null) {
          UserPreferences.setCurrency(fetchsettings!.sCurrency!);
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

        if (fetchsettings?.bankName.toString() != null) {
          UserPreferences.setBankName(fetchsettings!.bankName!);
        }
        if (fetchsettings?.accountNumber.toString() != null) {
          UserPreferences.setAccountNumber(fetchsettings!.accountNumber!);
        }
        if (fetchsettings?.accountTitle.toString() != null) {
          UserPreferences.setAccountTitle(fetchsettings!.accountTitle!);
        }
        if (fetchsettings?.ibanNumber.toString() != null) {
          UserPreferences.setIbanNumber(fetchsettings!.ibanNumber!);
        }
        if (fetchsettings?.dueLimit.toString() != null) {
          UserPreferences.setDuelimit(fetchsettings!.dueLimit!);
        }
        if (fetchsettings?.vendorFee.toString() != null) {
          UserPreferences.setVendorFee(fetchsettings!.vendorFee!);
        }
        if (fetchsettings?.sCurrencyPos.toString() != null) {
          UserPreferences.setCurrencyPos(fetchsettings!.sCurrencyPos!);
        }
      }
    });
  }

  // Get User Address From LatLng
  static Future<DirectionDetails> getDirectionDetails(LatLng startPosition, LatLng endPosition) async {
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&mode=driving&key=$mapKey');

    var response = await RequestHelper.getRequest(url);

    if (response == 'failed') {}

    DirectionDetails directionDetails = DirectionDetails();

    try {
      directionDetails.durationText = response['routes'][0]['legs'][0]['duration']['text'];
      directionDetails.durationValue = response['routes'][0]['legs'][0]['duration']['value'];

      directionDetails.distanceText = response['routes'][0]['legs'][0]['distance']['text'];
      directionDetails.distanceValue = response['routes'][0]['legs'][0]['distance']['value'];

      directionDetails.encodedPoints = response['routes'][0]['overview_polyline']['points'];
    } catch (e) {
      debugPrint(e.toString());
    }
    return directionDetails;
  }

  // Format Date Mathod
  static String formatMyDate(String datestring) {
    DateTime thisDate = DateTime.parse(datestring);
    String formattedDate =
        '${DateFormat.MMMd().format(thisDate)}, ${DateFormat.y().format(thisDate)} - ${DateFormat.jm().format(thisDate)}';

    return formattedDate;
  }

  // Check Earnings
  static void checkEarning() async {
    currentFirebaseUser = FirebaseAuth.instance.currentUser;
    String? userid = currentFirebaseUser?.uid;
    final userRef = FirebaseDatabase.instance.ref().child("partners").child(userid!);

    userRef.once().then((e) async {
      final _dataSnapshot = e.snapshot;

      earningsCountLoaded = true;
      earningDataLoading = false;
      currentPartnerInfo = Partner.fromSnapshot(_dataSnapshot);
      String getEarning = _dataSnapshot.child('earnings').value.toString();
      if (getEarning.isEmpty) {
        if (UserPreferences.getUserEarning() != null) {
          getUserEarning = UserPreferences.getUserEarning();
        } else {
          getUserEarning = '';
        }
      } else {
        getUserEarning = getEarning;
        UserPreferences.setUserEarning(getUserEarning!);
      }
    });
  }

  static void dueBalance() async {
    currentFirebaseUser = FirebaseAuth.instance.currentUser;

    final earningsRef = FirebaseDatabase.instance.ref().child('partners').child(currentFirebaseUser!.uid).child('earnings');

    earningsRef.once().then((e) async {
      final _dataSnapshot = e.snapshot;

      if (_dataSnapshot.value != null) {
        double oldEarnings = double.parse(_dataSnapshot.value.toString());
        double getDueBalance = (oldEarnings.toDouble() * vendorFee! / 100);

        if (getDueBalance.toString().isEmpty) {
          if (UserPreferences.getDueBalance() != null) {
            dueBalanceValue = double.parse(UserPreferences.getDueBalance().toString());
          } else {
            dueBalanceValue = 0;
          }
        } else {
          dueBalanceValue = getDueBalance;
          UserPreferences.setDueBalance(getDueBalance.toString());
        }
      }
    });
  }

  static void cleardueBalance() async {
    currentFirebaseUser = FirebaseAuth.instance.currentUser;

    final earningsRef = FirebaseDatabase.instance.ref().child('partners').child(currentFirebaseUser!.uid).child('earnings');

    earningsRef.set('0');
  }

  // Send Order Accpeted Notification
  static sendOrderAssignedNoti(String title, String body, String token, String? orderID, context) async {
    Map<String, String> headerMap = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };

    Map notificationMap = {
      'title': title,
      'body': body,
    };

    Map dataMap = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'order_id': orderID,
    };

    Map bodyMap = {
      'notification': notificationMap,
      'data': dataMap,
      'priority': 'high',
      'to': token,
    };

    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'), headers: headerMap, body: jsonEncode(bodyMap));
  }

  // Send Notification While Order is Declined
  static sendOrderDeclineNoti(String title, String body, String token, String? orderID, context) async {
    Map<String, String> headerMap = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };

    Map notificationMap = {
      'title': title,
      'body': body,
    };

    Map dataMap = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'link': 'www.google.com',
      'id': '1',
      'status': 'done',
      'order_status': 'decline',
    };

    Map bodyMap = {
      'notification': notificationMap,
      'data': dataMap,
      'priority': 'high',
      'to': token,
    };

    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'), headers: headerMap, body: jsonEncode(bodyMap));
  }

  // Send Payment Request Notification
  static sendPaymentNoti(String title, String body, String token, String amount, String reqID, context) async {
    Map<String, String> headerMap = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };

    Map notificationMap = {
      'title': title,
      'body': body,
    };

    Map dataMap = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'amount': amount,
      'orderID': reqID,
    };

    Map bodyMap = {
      'notification': notificationMap,
      'data': dataMap,
      'priority': 'high',
      'to': token,
    };

    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'), headers: headerMap, body: jsonEncode(bodyMap));
  }

  // Capitalize Mathod
  static String capitalize(String str) {
    return str.split(' ').map((word) => word.substring(0, 1).toUpperCase() + word.substring(1)).join(' ');
  }

  // Show Error Dialog
  static void showErrorDialog(context, String title, String message) {
    // set up the AlertDialog
    final AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      actionsAlignment: MainAxisAlignment.center,
      title: Text(
        title,
        textAlign: TextAlign.center,
      ),
      content: Text(
        '\n$message',
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text(
            'Okay',
            textAlign: TextAlign.center,
          ),
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

  //  Bottom Sheet
  static void bottomSheet(context, String title, Function() onPressed) {
    showModalBottomSheet(
      enableDrag: true,
      isDismissible: false,
      backgroundColor: Colors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.only(left: 40, top: 24, right: 24, bottom: 10),
        child: Wrap(
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.black54,
                  ),
                  height: 4,
                  width: 50,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 50, top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MaterialButton(
                        onPressed: () => Navigator.pop(context),
                        elevation: 0.0,
                        hoverElevation: 0.0,
                        focusElevation: 0.0,
                        highlightElevation: 0.0,
                        color: appcolors.dashboardCard,
                        textColor: Colors.black,
                        minWidth: 50,
                        height: 15,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 20,
                        ),
                        child: const Text('Cancel'),
                      ),
                      MaterialButton(
                        onPressed: onPressed,
                        elevation: 0.0,
                        hoverElevation: 0.0,
                        focusElevation: 0.0,
                        highlightElevation: 0.0,
                        color: Colors.red,
                        textColor: Colors.white,
                        minWidth: 50,
                        height: 15,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 20,
                        ),
                        child: const Text('Confirm'),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
