import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fullpro/models/settingsModel.dart';
import 'package:fullpro/models/userdata.dart';
import 'package:fullpro/models/SingleServices.dart';
import 'package:fullpro/models/cartservices.dart';
import 'package:fullpro/models/ordersModel.dart';
import 'package:fullpro/models/searchServices.dart';
import 'package:fullpro/models/trendingServices.dart';

// User Variables
User? currentFirebaseUser;
String? fullname;
String? userPhone;
String? userToken;
// Current User Info
late Position currentPosition;
UserData? currentUserInfo;
String? userLocation;
String? userManualLocation = 'Set Manual Address';

SettingsModel? fetchsettings;
// Order Variables
DatabaseReference? orderRef;

// ========= Data Loading Variables ========= //
// ==========================================//
// Sub Services Data Loading
bool catDataLoaded = false;
bool catListLoaded = false;
List<SingleServices> categoryServicesList = [];

// Cart Services Data Loading
bool cartDataLoaded = false;
bool cartListLoaded = false;
List<CartServices> cartItemsList = [];

//
List<dynamic> itemNamesList = [];

// Cart Items lists
List<dynamic> cartItemsNames = [];
List<dynamic> cartItems = [];

// Trending Services Data Loading
bool trendingDataLoaded = false;
bool trendingListLoaded = false;
List<TrendingServices> trendingItemsList = [];

// Orders History Data Loading
bool ordersDataLoaded = false;
bool ordersListLoaded = false;
List<OrdersModel> ordersItemsList = [];

StreamSubscription<DatabaseEvent>? orderSubscription;

// Details
bool orderDetailsDataLoaded = false;
bool orderDetailsListLoaded = false;
List<OrdersModel> orderDetailsItemsList = [];

// Home Trending Services Data Loading
bool hometrendingDataLoaded = false;
bool hometrendingListLoaded = false;

// Trending Data Loading
bool searchDataLoaded = false;
bool searchListLoaded = false;
List<SearchServicesModel> singleFoundedServices = [];
// ================== END ================== //

// Cart Variables
String? cartStatus = 'empty';
double cartbottomsheetHeight = 0;
var kSelectedDate;
int? ktotalprice = 0;

// Global Durations
const repeatTime = Duration(seconds: 2); // Function Repeater
const pageLoad_Animation = Duration(milliseconds: 150); // Page Loading

// Cart Icon
String cartEmpty = 'images/cart_empty.png';
String cartfull = 'images/cart_full_anim.gif';
String cartIcon = cartEmpty;

// Connection Status
bool? connectionChecked = true;
