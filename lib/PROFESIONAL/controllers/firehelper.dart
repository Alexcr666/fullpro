import 'package:fullpro/PROFESIONAL/models/nearbyOrders.dart';

class FireHelper {
  static List<NearbyOrders> nearbyOrdersList = [];

  //
  static void removeNearbyOrdersFromList(String key) {
    int index = nearbyOrdersList.indexWhere((element) => element.key == key);

    if (nearbyOrdersList.isNotEmpty) {
      nearbyOrdersList.removeAt(index);
    }
  }

  static void updateNearbyOrdersLocation(NearbyOrders order) {
    int index = nearbyOrdersList.indexWhere((element) => element.key == order.key);

    nearbyOrdersList[index].longitude = order.longitude;
    nearbyOrdersList[index].latitude = order.latitude;
  }
}
