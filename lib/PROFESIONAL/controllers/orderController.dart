// ignore_for_file: file_names

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:fullpro/PROFESIONAL/controllers/mainController.dart';
import 'package:fullpro/PROFESIONAL/provider/Appdata.dart';
import 'package:fullpro/PROFESIONAL/utils/globalConstants.dart';
import 'package:fullpro/PROFESIONAL/widget/DataLoadedProgress.dart';
import 'package:provider/provider.dart';

import '../models/ordersModel.dart';

class OrderController {
  // Get Order Keys
  static void getOrders(context) async {
    DatabaseReference orderRef = FirebaseDatabase.instance.ref().child('partners').child(currentFirebaseUser!.uid).child('history');

    orderRef.once().then((e) async {
      final snapshot = e.snapshot;

      if (snapshot.exists && snapshot.value != "0") {
        Map<dynamic, dynamic> values = snapshot.value as Map;
        snapshot.value;

        List<String> servicesKeys = [];
        values.forEach((key, value) {
          servicesKeys.add(key);
        });
        Provider.of<AppData>(context, listen: false).updateOrdersKeys(servicesKeys);
        getOrdersDataItems(context);
      } else {
        ordersListLoaded = true;
      }
      ordersDataLoaded = true;
      ordersItemsList = Provider.of<AppData>(context, listen: false).requestdata;
    });
  }

  // Get Order Items Keys
  static void getOrdersDataItems(context) {
    var keys = Provider.of<AppData>(context, listen: false).requestKeys;

    for (String key in keys) {
      DatabaseReference currentReq = FirebaseDatabase.instance.ref().child('requests').child(key);

      currentReq.once().then((e) async {
        final snapshot = e.snapshot;
        if (snapshot.value != null) {
          var services = OrdersProfesionalModel.fromSnapshot(snapshot);
          Provider.of<AppData>(context, listen: false).updateOrdersData(services);
        }
      });
    }
    ordersListLoaded = true;
  }

  // Get Order Items
  static void getOrdersData(context) {
    var reqkeys = Provider.of<AppData>(context, listen: false).requestKeys;

    var keys = Provider.of<AppData>(context, listen: false).requestServicesKeys;

    for (String key in keys) {
      for (String key1 in reqkeys) {
        DatabaseReference historyRef = FirebaseDatabase.instance.ref().child('requests').child(key1).child('items').child(key);

        historyRef.once().then((e) async {
          final snapshot = e.snapshot;
          if (snapshot.value != null) {
            var services = OrdersProfesionalModel.fromSnapshot(snapshot);
            Provider.of<AppData>(context, listen: false).updateOrdersData(services);
          }
        });
      }
    }
    ordersListLoaded = true;
  }

  static void getOrderDetailsKeys(String key, context) {
    DatabaseReference historyRef = FirebaseDatabase.instance.ref().child('requests').child(key).child('items');

    historyRef.once().then((e) async {
      final snapshot = e.snapshot;
      Map<dynamic, dynamic> values = snapshot.value as Map;
      snapshot.value;

      List<String> servicesKeys = [];
      values.forEach((key, value) {
        servicesKeys.add(key);
      });

      // update order keys to data provider
      Provider.of<AppData>(context, listen: false).updateOrderDetailsKeys(servicesKeys);

      getorderDetailsdata(key, context);
      orderDetailsDataLoaded = true;
      orderDetailsItemsList = Provider.of<AppData>(context, listen: false).orderDetailsData;
    });
  }

  static void getorderDetailsdata(String reqkey, context) {
    var keys = Provider.of<AppData>(context, listen: false).orderDetailsKeys;

    for (String key in keys) {
      DatabaseReference historyRef = FirebaseDatabase.instance.ref().child('requests').child(reqkey).child('items').child(key);

      historyRef.once().then((e) async {
        final snapshot = e.snapshot;
        if (snapshot.value != null) {
          var orderData = OrdersProfesionalModel.fromSnapshot(snapshot);
          Provider.of<AppData>(context, listen: false).updateOrderDetailsData(orderData);
        }
      });
    }
    orderDetailsListLoaded = true;
  }

  static void declineOrder(String reqkey, String reason, String declinedBy, context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => const Center(
        child: DataLoadedProgress(),
      ),
    );

    DatabaseReference historyRef =
        FirebaseDatabase.instance.ref().child('partners').child(currentPartnerInfo!.id!).child('history').child(reqkey);
    DatabaseReference decbyID = FirebaseDatabase.instance.ref().child('requests').child(reqkey).child('declineByID');
    DatabaseReference decReason = FirebaseDatabase.instance.ref().child('requests').child(reqkey).child('decline_reason');
    DatabaseReference partnerName = FirebaseDatabase.instance.ref().child('requests').child(reqkey).child('partner_name');
    DatabaseReference partnerPhone = FirebaseDatabase.instance.ref().child('requests').child(reqkey).child('partner_phone');
    DatabaseReference status = FirebaseDatabase.instance.ref().child('requests').child(reqkey).child('status');

    status.set(Locales.string(context, 'lbl_pending'));
    decReason.set(reason);
    decbyID.set(declinedBy);
    partnerName.set('Waiting');
    partnerPhone.set('Waiting');
    historyRef.remove();
    DatabaseReference orderNotiRef = FirebaseDatabase.instance.ref().child('requests').child(reqkey);

    orderNotiRef.once().then((e) {
      final snapshot = e.snapshot;

      String ordernmbr = snapshot.child('order_number').value.toString();
      String token = snapshot.child('booker_token').value.toString();

      MainControllerProfesional.sendOrderDeclineNoti(
        Locales.string(context, 'lbl_partner_declined'),
        Locales.string(context, 'lbl_new_partner_will_be_assigned'),
        token,
        ordernmbr,
        context,
      );
    });

    // Back
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);

    // Dialog
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
                  Text(
                    Locales.string(context, 'lbl_order_declined'),
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    Locales.string(context, 'lbl_keep_the_app_running'),
                    style: const TextStyle(fontSize: 14),
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
}
