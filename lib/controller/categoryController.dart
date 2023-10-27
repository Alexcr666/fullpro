import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:fullpro/utils/globalConstants.dart';
import 'package:fullpro/models/SingleServices.dart';
import 'package:fullpro/provider/Appdata.dart';

class CategoryController {
  // AC Services
  static void getSingleServiceCat(String serviceId, context) async {
    DatabaseReference historyRef = FirebaseDatabase.instance.ref().child('services').child(serviceId);

    historyRef.once().then((e) async {
      final snapshot = e.snapshot;
      if (snapshot.exists) {
        Map<dynamic, dynamic> values = snapshot.value as Map;
        snapshot.value;

        List<String> ServicesKeys = [];
        values.forEach((key, value) {
          ServicesKeys.add(key);
        });
        Provider.of<AppData>(context, listen: false).updateServicesKeys(ServicesKeys);

        getSingleServiceCatData(serviceId, context);
        catDataLoaded = true;
        categoryServicesList = Provider.of<AppData>(context, listen: false).SingleCatServiceData;
      } else {
        catDataLoaded = true;
        catListLoaded = true;
      }
    });
  }

  static void getSingleServiceCatData(String serviceId, context) {
    var keys = Provider.of<AppData>(context, listen: false).ServiceKeys;

    for (String key in keys) {
      DatabaseReference historyRef = FirebaseDatabase.instance.ref().child('services').child(serviceId).child(key);

      historyRef.once().then((e) async {
        final snapshot = e.snapshot;
        if (snapshot.value != null) {
          var services = SingleServices.fromSnapshot(snapshot);
          Provider.of<AppData>(context, listen: false).updateSingleCatServices(services);
        }
      });
    }
    catListLoaded = true;
  }
}
