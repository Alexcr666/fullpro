// ignore_for_file: file_names

import 'package:firebase_database/firebase_database.dart';
import 'package:fullpro/PROFESIONAL/models/ordersModel.dart';
import 'package:fullpro/PROFESIONAL/provider/Appdata.dart';
import 'package:fullpro/PROFESIONAL/utils/globalConstants.dart';
import 'package:provider/provider.dart';

class OrderListController {
  // Get Order Keys
  static void getOrdersList(context) async {
    DatabaseReference orderRef = FirebaseDatabase.instance.ref().child('ordersAvailable');

    orderRef.once().then((e) async {
      final snapshot = e.snapshot;

      if (snapshot.exists) {
        Map<dynamic, dynamic> values = snapshot.value as Map;
        snapshot.value;

        List<String> servicesKeys = [];
        values.forEach((key, value) {
          servicesKeys.add(key);
        });
        Provider.of<AppData>(context, listen: false).updateOrdersAvailableKeys(servicesKeys);
        //
        getOrdersDataItems(context);
      } else {
        ordersAvailableListLoaded = true;
      }
      ordersAvailableDataLoaded = true;
      ordersAvailableItemsList = Provider.of<AppData>(context, listen: false).requestAvailabledata;
    });
  }

  // Get Order Items Keys
  static void getOrdersDataItems(context) {
    var keys = Provider.of<AppData>(context, listen: false).requestAvailableKeys;

    for (String key in keys) {
      Query currentReq = FirebaseDatabase.instance.ref().child('requests').child(key);

      currentReq.once().then((e) async {
        final snapshot = e.snapshot;
        if (snapshot.value != null) {
          var services = OrdersProfesionalModel.fromSnapshot(snapshot);
          Provider.of<AppData>(context, listen: false).updateOrdersAvailableData(services);
        }
      });
    }
    // ordersAvailableListLoaded = true;
  }

  // Get Order Items
  static void getOrdersData(context) {
    var reqkeys = Provider.of<AppData>(context, listen: false).requestAvailableKeys;

    var keys = Provider.of<AppData>(context, listen: false).requestAvailableServicesKeys;

    for (String key in keys) {
      for (String key1 in reqkeys) {
        DatabaseReference historyRef = FirebaseDatabase.instance.ref().child('requests').child(key1).child('items').child(key);

        historyRef.once().then((e) async {
          final snapshot = e.snapshot;
          if (snapshot.value != null) {
            var services = OrdersProfesionalModel.fromSnapshot(snapshot);
            Provider.of<AppData>(context, listen: false).updateOrdersAvailableData(services);
          }
        });
      }
    }
    ordersAvailableListLoaded = true;
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
      Provider.of<AppData>(context, listen: false).updateOrderAvailableDetailsKeys(servicesKeys);

      getorderDetailsdata(key, context);
      orderAvailableDetailsDataLoaded = true;
      orderAvailableDetailsItemsList = Provider.of<AppData>(context, listen: false).orderAvailableDetailsData;
    });
  }

  static void getorderDetailsdata(String reqkey, context) {
    var keys = Provider.of<AppData>(context, listen: false).orderAvailableDetailsKeys;

    for (String key in keys) {
      DatabaseReference historyRef = FirebaseDatabase.instance.ref().child('requests').child(reqkey).child('items').child(key);

      historyRef.once().then((e) async {
        final snapshot = e.snapshot;
        if (snapshot.value != null) {
          var orderData = OrdersProfesionalModel.fromSnapshot(snapshot);
          Provider.of<AppData>(context, listen: false).updateOrderAvailableDetailsData(orderData);
        }
      });
    }
    orderAvailableDetailsListLoaded = true;
  }
}
