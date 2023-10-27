import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:fullpro/utils/globalConstants.dart';
import 'package:fullpro/models/homeTrendingServices.dart';
import 'package:fullpro/models/trendingServices.dart';
import 'package:fullpro/provider/Appdata.dart';

class TrendingController {
  static void getTrendingServices(context) async {
    DatabaseReference historyRef = FirebaseDatabase.instance.ref().child('trending_services');

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
      Provider.of<AppData>(context, listen: false).updateTrendingServicesKeys(ServicesKeys);

      getTrendingServicesData(context);
      trendingDataLoaded = true;
      trendingItemsList = Provider.of<AppData>(context, listen: false).trendingServicedata;
    });
  }

  static void getTrendingServicesData(context) {
    var keys = Provider.of<AppData>(context, listen: false).trendingServiceKeys;

    for (String key in keys) {
      Query historyRef = FirebaseDatabase.instance.ref().child('trending_services').child(key);

      historyRef.once().then((e) async {
        final snapshot = e.snapshot;
        if (snapshot.value != null) {
          var services = TrendingServices.fromSnapshot(snapshot);
          Provider.of<AppData>(context, listen: false).updateTrendingServicesData(services);
        }
      });
    }
    trendingListLoaded = true;
  }

  static void getHomeTrendingServices(context) async {
    DatabaseReference historyRef = FirebaseDatabase.instance.ref().child('trending_services');

    historyRef.once().then((e) async {
      final snapshot = e.snapshot;
      Map<dynamic, dynamic> values = snapshot.value as Map;
      snapshot.value;
      int tripCount = values.length;

      List<String> ServicesKeys = [];
      values.forEach((key, value) {
        ServicesKeys.add(key);
      });
      Provider.of<AppData>(context, listen: false).updateHomeTrendingKeys(ServicesKeys);

      getHomeTrendingServicesData(context);
      hometrendingDataLoaded = true;
    });
  }

  static void getHomeTrendingServicesData(context) {
    var keys = Provider.of<AppData>(context, listen: false).homeTrendingKeys;

    for (String key in keys) {
      DatabaseReference historyRef = FirebaseDatabase.instance.ref().child('trending_services').child(key);

      historyRef.once().then((e) async {
        final snapshot = e.snapshot;
        if (snapshot.value != null) {
          var services = HomeTrendingServices.fromSnapshot(snapshot);
          Provider.of<AppData>(context, listen: false).updateHomeTrendingData(services);
        }
      });
    }
  }
}
