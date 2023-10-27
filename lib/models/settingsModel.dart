import 'package:firebase_database/firebase_database.dart';

class SettingsModel {
  String? sMapKey;
  String? sCurrency;
  String? sCurrencyPos;
  String? sServerKey;
  String? sAppName;
  String? sAppVer;
  String? sHelpPhone;
  String? sHelpWA;
  String? id;

  SettingsModel({
    this.sMapKey = '',
    this.sCurrency = '',
    this.sCurrencyPos = '',
    this.sServerKey = '',
    this.sAppName = '',
    this.sAppVer = '',
    this.sHelpPhone = '',
    this.sHelpWA = '',
    this.id = '',
  });

  SettingsModel.fromSnapshot(DataSnapshot snapshot) {
    id = snapshot.key;
    sMapKey = snapshot.child('mapkey').value.toString();
    sCurrency = snapshot.child('currency').value.toString();
    sCurrencyPos = snapshot.child('currencyPosition').value.toString();
    sServerKey = snapshot.child('serverKey').value.toString();
    sAppName = snapshot.child('appname').value.toString();
    sAppVer = snapshot.child('appVersion').value.toString();
    sHelpPhone = snapshot.child('helpPhone').value.toString();
    sHelpWA = snapshot.child('helpWhatsapp').value.toString();
  }
}
