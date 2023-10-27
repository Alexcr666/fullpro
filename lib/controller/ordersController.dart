import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fullpro/config.dart';
import 'package:fullpro/utils/globalConstants.dart';
import 'package:fullpro/controller/mainController.dart';
import 'package:fullpro/models/ordersModel.dart';
import 'package:fullpro/provider/Appdata.dart';
import 'package:fullpro/widgets/DataLoadedProgress.dart';

class OrdersController {
  // Get Order Keys
  static void getOrders(context) async {
    DatabaseReference orderRef = FirebaseDatabase.instance.ref().child('users').child('${currentUserInfo?.id}').child('history');

    orderRef.once().then((e) async {
      final snapshot = e.snapshot;

      if (snapshot.exists) {
        Map<dynamic, dynamic> values = snapshot.value as Map;
        snapshot.value;
        int tripCount = values.length;
        print('History length is ${tripCount}');

        List<String> ServicesKeys = [];
        values.forEach((key, value) {
          ServicesKeys.add(key);
        });
        Provider.of<AppData>(context, listen: false).updateOrdersKeys(ServicesKeys);
      }
      ordersDataLoaded = true;
      getOrdersDataItems(context);
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
          print('List is ${snapshot.value}');
          var services = OrdersModel.fromSnapshot(snapshot);
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
            print('List is ${snapshot.value}');
            var services = OrdersModel.fromSnapshot(snapshot);
            Provider.of<AppData>(context, listen: false).updateOrdersData(services);
          }
        });
      }
    }
    ordersListLoaded = true;
  }

  static void getOrderDetailsKeys(String key, context) {
    print(key);

    DatabaseReference historyRef = FirebaseDatabase.instance.ref().child('requests').child(key).child('items');

    historyRef.once().then((e) async {
      final snapshot = e.snapshot;
      Map<dynamic, dynamic> values = snapshot.value as Map;
      snapshot.value;
      int tripCount = values.length;

      List<String> ServicesKeys = [];
      values.forEach((key, value) {
        ServicesKeys.add(key);
      });

      // update order keys to data provider
      Provider.of<AppData>(context, listen: false).updateOrderDetailsKeys(ServicesKeys);

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
          var OrderData = OrdersModel.fromSnapshot(snapshot);
          print(OrderData.name);
          Provider.of<AppData>(context, listen: false).updateOrderDetailsData(OrderData);
        }
      });
    }
    orderDetailsListLoaded = true;
  }

  static void cancelOrder(String reqkey, String reason, String declinedBy, context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => const Center(
        child: DataLoadedProgress(),
      ),
    );

    DatabaseReference decbyID = FirebaseDatabase.instance.ref().child('requests').child(reqkey).child('declineByID');
    DatabaseReference decReason = FirebaseDatabase.instance.ref().child('requests').child(reqkey).child('decline_reason');
    DatabaseReference decReq = FirebaseDatabase.instance.ref().child('requests').child(reqkey).child('status');

    decReq.set('canceled');
    decReason.set(reason);
    decbyID.set(declinedBy);

    DatabaseReference _geoRef = FirebaseDatabase.instance.ref().child('ordersAvailable').child(reqkey);
    _geoRef.remove();

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
                  const Text(
                    'Order has been Canceled!',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'You will need $appName again, Stay Connected!',
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
                    child: const Text('Close'),
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static void payPartner(String? usdtID, String? totalprice, String? reqID, context) {
    // Update Partner Earnings
    int? oldEarnings;
    DatabaseReference payRef = FirebaseDatabase.instance.ref().child('partners').child(usdtID!);

    payRef.once().then((e) async {
      final snapshot = e.snapshot;

      if (snapshot.exists) {
        if (snapshot.child('earnings').value.toString() != null) {
          oldEarnings = int.tryParse(snapshot.child('earnings').value.toString());

          payRef.update({'earnings': oldEarnings! + int.tryParse(totalprice!)!});
        } else {
          payRef.update({'earnings': int.tryParse(totalprice!)!});
        }
      } else {
        payRef.update({'earnings': int.tryParse(totalprice!)!});
      }
    });
    // End

    // Update Order Data
    DatabaseReference orderRef = FirebaseDatabase.instance.ref().child('requests').child(reqID!);

    orderRef.update({'status': 'Completed'});

    orderRef.once().then((e) async {
      final snapshot = e.snapshot;

      if (snapshot.exists) {
        //
        String partnerID = snapshot.child('partner_id').value.toString();
        String amount = snapshot.child('totalprice').value.toString();

        // Get Partner Token
        DatabaseReference partnerToken = FirebaseDatabase.instance.ref().child('partners').child(partnerID).child('token');

        partnerToken.once().then((e) async {
          final snapshot = e.snapshot;

          MainController.sendPaymentNotification(snapshot.value.toString(), context, amount, reqID);
        });
      }
    });
    Navigator.pop(context);
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
                    'Payment Successfull',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Thank You for using $appName Service',
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
