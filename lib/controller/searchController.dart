import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:fullpro/utils/globalConstants.dart';
import 'package:fullpro/models/searchServices.dart';
import 'package:fullpro/provider/Appdata.dart';

class SearchController {
  static void getSearchServices(context) async {
    DatabaseReference historyRef = FirebaseDatabase.instance.ref().child('sub_services');

    historyRef.once().then((e) async {
      final snapshot = e.snapshot;
      Map<dynamic, dynamic> values = snapshot.value as Map;
      snapshot.value;
      int tripCount = values.length;

      List<String> ServicesKeys = [];
      values.forEach((key, value) {
        ServicesKeys.add(key);
      });

      // update trip keys to data provider
      Provider.of<AppData>(context, listen: false).updateSearchServicesKeys(ServicesKeys);

      getSearchServicesData(context);
      searchDataLoaded = true;
      singleFoundedServices = Provider.of<AppData>(context, listen: false).searchServicedata;
    });
  }

  static void getSearchServicesData(context) {
    var keys = Provider.of<AppData>(context, listen: false).searchServiceKeys;

    for (String key in keys) {
      DatabaseReference historyRef = FirebaseDatabase.instance.ref().child('sub_services').child(key);

      historyRef.once().then((e) async {
        final snapshot = e.snapshot;
        if (snapshot.value != null) {
          var services = SearchServicesModel.fromSnapshot(snapshot);
          Provider.of<AppData>(context, listen: false).updateSearchServicesData(services);
        }
      });
    }
    searchListLoaded = true;
  }
}
