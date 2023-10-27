import 'package:fullpro/models/nearbyPartner.dart';

class FireController {
  static List<NearbyPartner> nearbyPartnerList = [];

  static void removeFromList(String key) {
    int index = nearbyPartnerList.indexWhere((element) => element.key == key);

    if (nearbyPartnerList.isNotEmpty) {
      nearbyPartnerList.removeAt(index);
    }
  }

  static void updateNearbyLocation(NearbyPartner partner) {
    int index = nearbyPartnerList.indexWhere((element) => element.key == partner.key);

    nearbyPartnerList[index].longitude = partner.longitude;
    nearbyPartnerList[index].latitude = partner.latitude;
  }
}
