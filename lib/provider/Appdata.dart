import 'package:fullpro/models/SingleServices.dart';
import 'package:fullpro/models/address.dart';
import 'package:fullpro/models/cartservices.dart';
import 'package:fullpro/models/homeTrendingServices.dart';
import 'package:fullpro/models/ordersModel.dart';
import 'package:fullpro/models/searchServices.dart';
import 'package:fullpro/models/services.dart';
import 'package:flutter/material.dart';
import 'package:fullpro/models/trendingServices.dart';
import 'package:fullpro/pages/onboarding/pages/boarding/data/onboard_page_data.dart';

class AppData extends ChangeNotifier {
  // Trending Services List
  List<String> ServiceKeys = [];
  List<Services> Servicedata = [];

  // Trending Services List
  List<String> trendingServiceKeys = [];
  List<TrendingServices> trendingServicedata = [];

  // Trending Services List
  List<String> searchServiceKeys = [];
  List<SearchServicesModel> searchServicedata = [];

  // Homepage Trending Services List
  List<String> homeTrendingKeys = [];
  List<HomeTrendingServices> homeTrendingData = [];

  // Sub Services Lists
  List<String> SubServiceKeys = [];
  List<Services> SubServiceData = [];

  // Single Category Services Lists
  List<String> SingleCatServiceKeys = [];
  List<SingleServices> SingleCatServiceData = [];

  // User Cart Services Lists
  List<String> cartKeys = [];
  List<CartServices> userCartData = [];

  // User Order Services Lists
  List<String> requestKeys = [];
  List<String> requestServicesKeys = [];
  List<OrdersModel> requestdata = [];

  // Order Details Lists
  List<String> orderDetailsKeys = [];
  List<OrdersModel> orderDetailsData = [];

  // Trending Services
  void updateServicesKeys(List<String> newKeys) {
    ServiceKeys = newKeys;
    notifyListeners();
  }

  void updateServices(Services servicesItem) {
    Servicedata.add(servicesItem);
    notifyListeners();
  }

  // Orders Data
  void updateOrdersKeys(List<String> newKeys) {
    requestKeys = newKeys;
    notifyListeners();
  }

  void updateOrdersItemsKeys(List<String> newKeys) {
    requestServicesKeys = newKeys;
    notifyListeners();
  }

  void updateOrdersData(OrdersModel servicesItem) {
    requestdata.add(servicesItem);
    notifyListeners();
  }

  // Selected Order Details
  void updateOrderDetailsKeys(List<String> newKeys) {
    orderDetailsKeys = newKeys;
    notifyListeners();
  }

  void updateOrderDetailsData(OrdersModel servicesItem) {
    orderDetailsData.add(servicesItem);
    notifyListeners();
  }

  //
  // Break
  //
  // Trending Services
  void updateTrendingServicesKeys(List<String> newKeys) {
    trendingServiceKeys = newKeys;
    notifyListeners();
  }

  void updateTrendingServicesData(TrendingServices servicesItem) {
    trendingServicedata.add(servicesItem);
    notifyListeners();
  }

  // Homepage Trending Services
  void updateHomeTrendingKeys(List<String> newKeys) {
    homeTrendingKeys = newKeys;
    notifyListeners();
  }

  void updateHomeTrendingData(HomeTrendingServices trendingservicesItem) {
    homeTrendingData.add(trendingservicesItem);
    notifyListeners();
  }

  // Sub Serivces
  void updateSubServicesKeys(List<String> newKeys) {
    SubServiceKeys = newKeys;
    notifyListeners();
  }

  void updateSubServices(Services subservicesItem) {
    SubServiceData.add(subservicesItem);
    notifyListeners();
  }

  // Single Cat Serivces
  void updateSingleCatServicesKeys(List<String> newKeys) {
    SingleCatServiceKeys = newKeys;
    notifyListeners();
  }

  void updateSingleCatServices(SingleServices SingleCatservicesItem) {
    SingleCatServiceData.add(SingleCatservicesItem);
    notifyListeners();
  }

  // user Cart Serivces List
  void updateCartKeys(List<String> newKeys) {
    cartKeys = newKeys;
    notifyListeners();
  }

  void updateCartData(CartServices cartItem) {
    userCartData.add(cartItem);
    notifyListeners();
  }

  // Search Services
  void updateSearchServicesKeys(List<String> newKeys) {
    searchServiceKeys = newKeys;
    notifyListeners();
  }

  void updateSearchServicesData(SearchServicesModel servicesItem) {
    searchServicedata.add(servicesItem);
    notifyListeners();
  }

  // Get User Current Address
  Address? pickupAddress;

  Address? destinationAddress;

  void updatePickupAddress(Address pickup) {
    pickupAddress = pickup;
    notifyListeners();
  }

  void updateDestinationAddress(Address destination) {
    destinationAddress = destination;
    notifyListeners();
  }

  Color _color = onboardData[0].accentColor; //default color

  Color get color => _color;

  set color(Color color) {
    _color = color;
    notifyListeners();
  }
}
