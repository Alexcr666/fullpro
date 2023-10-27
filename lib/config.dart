import 'package:fullpro/utils/userpreferences.dart';

// App Variables
String? appName = 'FullPro';
String? packageName = "com.app.fullpro";
String? appVersion = UserPreferences.getAppVersion();
String? currencySymbol = UserPreferences.getCurrency();
String? currencyPos = UserPreferences.getCurrencyPos();

// You Google Maps Api
String? mapKey = 'AIzaSyCfsvZ1kjO-mlfDbbu19sJuYKKd7gcfgqw';

// Your Firebase App Server Key
String? serverKey = UserPreferences.getServerKey();

// App Padding
double leftPadding = 13;
double rightPadding = 13;
double topPadding = 0;
double bottomPadding = 0;

//  Help & Support
String? helpPhone = UserPreferences.getHelpPhone();
String? helpWhatsapp = UserPreferences.getHelpWA();

// Cart Variables
String? kselectedTime = '7AM - 8AM'; // Default Selected Time

// Enter Names You Want User to Select These Services as Only Once
// * Names Must be lowercase
List<dynamic> singleService = [
  'ac installation',
  'ac repairing',
  'ac mounting',
  'ac dismounting',
];

// HomePage Slider
List<dynamic> mainSlider = [
  'images/banner1.png',
  'images/banner1.png',
];
