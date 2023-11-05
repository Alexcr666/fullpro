// ignore_for_file: file_names

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fullpro/PROFESIONAL/models/categoriesModel.dart';
import 'package:fullpro/PROFESIONAL/models/ordersModel.dart';
import 'package:fullpro/PROFESIONAL/models/partner.dart';
import 'package:fullpro/PROFESIONAL/models/settingsModel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fullpro/models/ordersModel.dart';
import 'package:fullpro/models/settingsModel.dart';

// User Current Location Variable
late Position currentPosition;

// Google Maps Camera Position
const CameraPosition googlePlex = CameraPosition(target: LatLng(24.860966, 66.990501), zoom: 14.4746);

User? currentFirebaseUser;
Partner? currentPartnerInfo;
SettingsModelProfesional? fetchsettings;

// App Padding
double leftPadding = 13;
double rightPadding = 13;
double topPadding = 0;
double bottomPadding = 0;

final assetsAudioPlayer = AssetsAudioPlayer();

String? fullname;
String? userPhone;

DatabaseReference? rideRef;

TabController? tabController;
int selecetdIndex = 0;

// Parent Category Data Loading
bool parentCatDataLoaded = false;
bool parentCatListLoaded = false;
List<CategoriesModel> parentCatItemsList = [];
// Sub Category Data Loading
bool subCatDataLoaded = false;
bool subCatListLoaded = false;
List<CategoriesModel> subCatItemsList = [];

//
List<dynamic> subNamesList = [];

// Orders History Data Loading
bool ordersDataLoaded = false;
bool ordersListLoaded = false;
List<OrdersProfesionalModel> ordersItemsList = [];
// Details
bool orderDetailsDataLoaded = false;
bool orderDetailsListLoaded = false;
List<OrdersProfesionalModel> orderDetailsItemsList = [];

// Available Orders Data Loading
bool ordersAvailableDataLoaded = false;
bool ordersAvailableListLoaded = false;
List<OrdersProfesionalModel> ordersAvailableItemsList = [];
// Details
bool orderAvailableDetailsDataLoaded = false;
bool orderAvailableDetailsListLoaded = false;
List<OrdersProfesionalModel> orderAvailableDetailsItemsList = [];

// Global Durations
const repeatTime = Duration(seconds: 2); // Function Repeater
const pageLoadAnimation = Duration(milliseconds: 150); // Page Loading

// Earnings Variables
String? getUserEarning = '';
bool earningDataLoading = true;
bool earningsCountLoaded = false;
double dueBalanceValue = 0;
