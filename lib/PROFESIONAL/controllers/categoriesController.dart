// ignore_for_file: file_names
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:fullpro/PROFESIONAL/models/categoriesModel.dart';
import 'package:fullpro/PROFESIONAL/provider/Appdata.dart';
import 'package:fullpro/PROFESIONAL/utils/globalConstants.dart';
import 'package:provider/provider.dart';

class CategoriesController {
  // Get Parent Category Keys
  static void getParentCategory(context) async {
    DatabaseReference parentCatRef = FirebaseDatabase.instance.ref().child('services');

    parentCatRef.once().then((e) async {
      final snapshot = e.snapshot;

      if (snapshot.exists) {
        Map<dynamic, dynamic> values = snapshot.value as Map;
        snapshot.value;
        print("data: " + snapshot.value.toString());

        List<String> servicesKeys = [];
        values.forEach((key, value) {
          servicesKeys.add(key);
        });
        Provider.of<AppData>(context, listen: false).updateParentCategoryKeys(servicesKeys);
        getParentCategoryData(context);
      }
      parentCatDataLoaded = true;
      parentCatItemsList = Provider.of<AppData>(context, listen: false).parentCategorydata;
    });
  }

  // Get Parent Category Items
  static void getParentCategoryData(context) {
    var keys = Provider.of<AppData>(context, listen: false).parentCategoryKeys;

    for (String key in keys) {
      DatabaseReference parentCatRef = FirebaseDatabase.instance.ref().child('services').child(key);

      parentCatRef.once().then((e) async {
        final snapshot = e.snapshot;
        if (snapshot.value != null) {
          var services = CategoriesModel.fromSnapshot(snapshot);
          Provider.of<AppData>(context, listen: false).updateParentCategoryData(services);
        }
      });
    }
    parentCatListLoaded = true;
  }

  //
  //
  //
  //
  //
  //
  //
  //
  //
  //
  //
  //
  //
  //
  //
  //
  //
  //
  // Get Sub Category Keys
  static void getSubCategory(context, String key) {
    DatabaseReference historyRef = FirebaseDatabase.instance.ref().child('services').child(key);

    historyRef.once().then((e) async {
      final snapshot = e.snapshot;
      Map<dynamic, dynamic> values = snapshot.value as Map;
      snapshot.value;

      List<String> servicesKeys = [];
      values.forEach((key, value) {
        servicesKeys.add(key);
      });

      // update order keys to data provider
      Provider.of<AppData>(context, listen: false).updateSubCatKeys(servicesKeys);

      getSubCatData(key, context);
      subCatDataLoaded = true;
      subCatItemsList = Provider.of<AppData>(context, listen: false).subCatdata;
    });
  }

  static void getSubCatData(String reqkey, context) {
    var keys = Provider.of<AppData>(context, listen: false).subCatKeys;

    for (String key in keys) {
      DatabaseReference historyRef = FirebaseDatabase.instance.ref().child('services').child(reqkey).child(key);

      historyRef.once().then((e) async {
        final snapshot = e.snapshot;
        if (snapshot.value != null) {
          var orderData = CategoriesModel.fromSnapshot(snapshot);
          Provider.of<AppData>(context, listen: false).updateSubCatData(orderData);
        }
      });
    }
    subCatListLoaded = true;
  }
}
