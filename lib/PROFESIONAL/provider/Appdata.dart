// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:fullpro/PROFESIONAL/models/categoriesModel.dart';
import 'package:fullpro/PROFESIONAL/models/ordersModel.dart';
import 'package:fullpro/PROFESIONAL/views/onboarding/pages/boarding/data/onboard_page_data.dart';

import 'package:fullpro/models/ordersModel.dart';

class AppData extends ChangeNotifier {
  String? earnings = '0';
  int tripCount = 0;

  // Parent Category Services Lists
  List<String> parentCategoryKeys = [];
  List<CategoriesModel> parentCategorydata = [];

  // Sub Category Services Lists
  List<String> subCatKeys = [];
  List<String> subCatServicesKeys = [];
  List<CategoriesModel> subCatdata = [];

  // User Order Services Lists
  List<String> requestKeys = [];
  List<String> requestServicesKeys = [];
  List<OrdersProfesionalModel> requestdata = [];

  // Order Details Lists
  List<String> orderDetailsKeys = [];
  List<OrdersProfesionalModel> orderDetailsData = [];

  //
  // User Order Available Services Lists
  List<String> requestAvailableKeys = [];
  List<String> requestAvailableServicesKeys = [];
  List<OrdersProfesionalModel> requestAvailabledata = [];

  // Order Available Details Lists
  List<String> orderAvailableDetailsKeys = [];
  List<OrdersProfesionalModel> orderAvailableDetailsData = [];

  // Parent Category Data
  void updateParentCategoryKeys(List<String> newKeys) {
    parentCategoryKeys = newKeys;
    notifyListeners();
  }

  void updateParentCategoryData(CategoriesModel servicesItem) {
    parentCategorydata.add(servicesItem);
    notifyListeners();
  }

  // Sub Category Data
  // Orders List Data
  void updateSubCatKeys(List<String> newKeys) {
    subCatKeys = newKeys;
    notifyListeners();
  }

  void updateSubCatItemsKeys(List<String> newKeys) {
    subCatServicesKeys = newKeys;
    notifyListeners();
  }

  void updateSubCatData(CategoriesModel servicesItem) {
    subCatdata.add(servicesItem);
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

  void updateOrdersData(OrdersProfesionalModel servicesItem) {
    requestdata.add(servicesItem);
    notifyListeners();
  }

  // Selected Order Details
  void updateOrderDetailsKeys(List<String> newKeys) {
    orderDetailsKeys = newKeys;
    notifyListeners();
  }

  void updateOrderDetailsData(OrdersProfesionalModel servicesItem) {
    orderDetailsData.add(servicesItem);
    notifyListeners();
  }
  // END

  // Orders List Data
  void updateOrdersAvailableKeys(List<String> newKeys) {
    requestAvailableKeys = newKeys;
    notifyListeners();
  }

  void updateOrdersAvailableItemsKeys(List<String> newKeys) {
    requestAvailableServicesKeys = newKeys;
    notifyListeners();
  }

  void updateOrdersAvailableData(OrdersProfesionalModel servicesItem) {
    requestAvailabledata.add(servicesItem);
    notifyListeners();
  }

  // Selected Order Details
  void updateOrderAvailableDetailsKeys(List<String> newKeys) {
    orderAvailableDetailsKeys = newKeys;
    notifyListeners();
  }

  void updateOrderAvailableDetailsData(OrdersProfesionalModel servicesItem) {
    orderAvailableDetailsData.add(servicesItem);
    notifyListeners();
  }
  // END

  void updateEarnings(String newEarnings) {
    earnings = newEarnings;
    notifyListeners();
  }

  void updateTripCount(int newTripCount) {
    tripCount = newTripCount;
    notifyListeners();
  }

  Color _color = onboardData[0].accentColor; //default color

  Color get color => _color;

  set color(Color color) {
    _color = color;
    notifyListeners();
  }
}
