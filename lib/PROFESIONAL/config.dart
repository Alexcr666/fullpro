// App Variables
import 'package:fullpro/PROFESIONAL/utils/userpreferences.dart';

String? appName = "FullPro";
String? appVersion = UserPreferences.getAppVersion();
String? currencySymbol = UserPreferences.getCurrency();
String? currencyPos = UserPreferences.getCurrencyPos();

// You Google Maps Api
String? mapKey = UserPreferences.getMapKey();

// Your Firebase App Server Key
String? serverKey = UserPreferences.getServerKey();

//  Help & Support
String? helpPhone = UserPreferences.getHelpPhone();
String? helpWhatsapp = UserPreferences.getHelpWA();

// Bank Account Details
String? bankName = UserPreferences.getBankName();
String? accountNumber = UserPreferences.getAccountNumber();
String? accountTitle = UserPreferences.getAccountTitle();
String? ibanNumber = UserPreferences.getIbanNumber();

// Vendor Fee
double? vendorFee = double.parse(UserPreferences.getVendorFee()!);
double? dueLimit = double.parse(UserPreferences.getDuelimit()!);

// Stripe Variables
String stripePublishableKey = "sk_test_51MVzfVJD6GFsjF8jG6Wr0JvURsnnmSvVzmFWO5pRhaYHLZQR2kD1VKSYAMY4aJkEi0zTHQvz9vsvrTAZjawW5AMU00kruaHXdq";
String stripeSecretKey = "sk_test_51MVzfVJD6GFsjF8jG6Wr0JvURsnnmSvVzmFWO5pRhaYHLZQR2kD1VKSYAMY4aJkEi0zTHQvz9vsvrTAZjawW5AMU00kruaHXdq";
String stripeCurrency = "USD";
