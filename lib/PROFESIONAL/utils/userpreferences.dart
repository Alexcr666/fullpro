import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static SharedPreferences? _preferences;

  static const _keyUsername = 'username';
  static const _keyPhone = 'phone';
  static const _keyEmail = 'email';
  static const _keyEarning = 'earning';
  static const _keyDueBalance = 'duebalance';

  static Future init() async => _preferences = await SharedPreferences.getInstance();

  static Future setUsername(String username) async => await _preferences?.setString(_keyUsername, username);

  static String? getUsername() => _preferences?.getString(_keyUsername);

  static Future setUserPhone(String phone) async => await _preferences?.setString(_keyPhone, phone);

  static String? getUserPhone() => _preferences?.getString(_keyPhone);

  static Future setUserEmail(String email) async => await _preferences?.setString(_keyEmail, email);

  static String? getUserEmail() => _preferences?.getString(_keyEmail);

  static Future setUserEarning(String earning) async => await _preferences?.setString(_keyEarning, earning);

  static String? getUserEarning() => _preferences?.getString(_keyEarning);

  static Future setDueBalance(String duebalance) async => await _preferences?.setString(_keyDueBalance, duebalance);

  static String? getDueBalance() => _preferences?.getString(_keyDueBalance);

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

  static const _kbankName = 'bankName';
  static const _kAccountTitle = 'accountTitle';
  static const _kAccountNumber = 'accountNumber';
  static const _kibanNumber = '_kBankName';

  static Future setBankName(String bankName) async => await _preferences?.setString(_kbankName, bankName);
  static String? getBankName() => _preferences?.getString(_kbankName);

  static Future setAccountTitle(String accountTitle) async => await _preferences?.setString(_kAccountTitle, accountTitle);
  static String? getAccountTitle() => _preferences?.getString(_kAccountTitle);

  static Future setAccountNumber(String accountNumber) async => await _preferences?.setString(_kAccountNumber, accountNumber);
  static String? getAccountNumber() => _preferences?.getString(_kAccountNumber);

  static Future setIbanNumber(String ibanNumber) async => await _preferences?.setString(_kibanNumber, ibanNumber);
  static String? getIbanNumber() => _preferences?.getString(_kibanNumber);

  static const _kvendorFee = '0.0';
  static const _kdueLimit = '0.0';

  static Future setVendorFee(String vendorFee) async => await _preferences?.setString(_kvendorFee, vendorFee);
  static String? getVendorFee() {
    /* if (_preferences?.getString(_kvendorFee) == null) {
      return "10.0";
    } else {
      return _preferences?.getString(_kvendorFee);
    }*/
    return "1000.0";
  }

  static Future setDuelimit(String dueLimit) async => await _preferences?.setString(_kdueLimit, dueLimit);
  static String? getDuelimit() {
    /* changed   if (_preferences?.getString(_kdueLimit) == null) {
      return "10.0";
    } else {
      return _preferences?.getString(_kdueLimit);
    }*/
    return "10000.0";
  }
}
