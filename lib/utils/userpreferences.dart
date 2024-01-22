import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreference {
  Future setUser(
    BuildContext context,
    String user,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('user', user);
  }

  Future setProfessional(
    BuildContext context,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool('professional', true);
  }

  Future getUser(
    BuildContext context,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('email');
  }
}

class UserPreferences {
  static SharedPreferences? _preferences;

  static const _keyUsername = 'username';
  static const _keyPhone = 'phone';
  static const _keyEmail = 'email';
  static const _keyLocation = 'location';
  static const _keyAddressStatus = 'addressStatus';
  static const _keyManualLocation = 'manuallocation';
  static const _keycartStatus = 'cartStatus';
  static const _keyWallet = 'wallet';

  static Future init() async => _preferences = await SharedPreferences.getInstance();

  static Future setUsername(String username) async => await _preferences?.setString(_keyUsername, username);

  static String? getUsername() => _preferences?.getString(_keyUsername);

  static Future setUserPhone(String phone) async => await _preferences?.setString(_keyPhone, phone);

  static String? getUserPhone() => _preferences?.getString(_keyPhone);

  static Future setUserEmail(String email) async => await _preferences?.setString(_keyEmail, email);

  static String? getUserEmail() => _preferences?.getString(_keyEmail);

  // User Current Location
  static Future setUserLocation(String location) async => await _preferences?.setString(_keyLocation, location);

  static String? getUserLocation() => _preferences?.getString(_keyLocation);

  // User Manual Location
  static Future setManualLocation(String manuallocation) async => await _preferences?.setString(_keyManualLocation, manuallocation);

  static String? getManualLocation() => _preferences?.getString(_keyManualLocation);

  // User Current Location
  static Future setAddressStatus(String addressStatus) async => await _preferences?.setString(_keyAddressStatus, addressStatus);

  static String? getAddressStatus() => _preferences?.getString(_keyAddressStatus);

  // User Current Location
  static Future setcartStatus(String cartStatus) async => await _preferences?.setString(_keycartStatus, cartStatus);

  static String? getcartStatus() => _preferences?.getString(_keycartStatus);

  // User Wallet Balance
  static Future setUserWallet(String wallet) async => await _preferences?.setString(_keyWallet, wallet);

  static String? getUserWallet() => _preferences?.getString(_keyWallet);

  // =====================
  // SETTINGS
  // ====================
  static const _kuMapkey = 'umapkey';
  static const _kServerKey = 'uServerKey';

  static const _kAppName = 'appname';
  static const _kAppVer = 'appver';

  static const _khphone = 'hphone';
  static const _khelpWa = 'helpwa';
  static const _currency = 'currency';
  static const _currencyPos = 'currencyPos';

  static Future setCurrency(String currency) async => await _preferences?.setString(_currency, currency);
  static String? getCurrency() => _preferences?.getString(_currency);

  static Future setCurrencyPos(String currencyPos) async => await _preferences?.setString(_currencyPos, currencyPos);
  static String? getCurrencyPos() => _preferences?.getString(_currencyPos);

  static Future setMapKey(String umapkey) async => await _preferences?.setString(_kuMapkey, umapkey);
  static String? getMapKey() => _preferences?.getString(_kuMapkey);

  static Future setServerKey(String uServerKey) async => await _preferences?.setString(_kServerKey, uServerKey);
  static String? getServerKey() => _preferences?.getString(_kServerKey);

  static Future setAppName(String appname) async => await _preferences?.setString(_kAppName, appname);
  static String? getAppName() => _preferences?.getString(_kAppName);
  static Future setAppVersion(String appver) async => await _preferences?.setString(_kAppVer, appver);
  static String? getAppVersion() => _preferences?.getString(_kAppVer);

  static Future setHelpPhone(String hphone) async => await _preferences?.setString(_khphone, hphone);
  static String? getHelpPhone() => _preferences?.getString(_khphone);

  static Future setHelpWA(String helpwa) async => await _preferences?.setString(_khelpWa, helpwa);
  static String? getHelpWA() => _preferences?.getString(_khelpWa);
}
