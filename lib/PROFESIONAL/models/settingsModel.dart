import 'package:firebase_database/firebase_database.dart';

class SettingsModelProfesional {
  String? sMapKey;
  String? sCurrency;
  String? sCurrencyPos;
  String? sServerKey;
  String? sAppName;
  String? sAppVer;
  String? sHelpPhone;
  String? sHelpWA;
  String? id;

  String? bankName;
  String? accountNumber;
  String? accountTitle;
  String? ibanNumber;

  String? vendorFee;
  String? dueLimit;

  SettingsModelProfesional({
    this.sMapKey = '',
    this.sCurrency = '',
    this.sCurrencyPos = '',
    this.sServerKey = '',
    this.sAppName = '',
    this.sAppVer = '',
    this.sHelpPhone = '',
    this.sHelpWA = '',
    this.id = '',
    this.bankName = '',
    this.accountNumber = '',
    this.accountTitle = '',
    this.ibanNumber = '',
    this.vendorFee = '',
    this.dueLimit = '',
  });

  SettingsModelProfesional.fromSnapshot(DataSnapshot snapshot) {
    id = snapshot.key;
    sMapKey = snapshot.child('mapkey').value.toString();
    sCurrency = snapshot.child('currency').value.toString();
    sCurrencyPos = snapshot.child('currencyPosition').value.toString();
    sServerKey = snapshot.child('serverKey').value.toString();
    sAppName = snapshot.child('appname').value.toString();
    sAppVer = snapshot.child('appVersion').value.toString();
    sHelpPhone = snapshot.child('helpPhone').value.toString();
    sHelpWA = snapshot.child('helpWhatsapp').value.toString();

    bankName = snapshot.child('payment').child('bankTransfer').child('bankName').value.toString();
    accountNumber = snapshot.child('payment').child('bankTransfer').child('accountNumber').value.toString();
    accountTitle = snapshot.child('payment').child('bankTransfer').child('accountTitle').value.toString();
    ibanNumber = snapshot.child('payment').child('bankTransfer').child('ibanNumber').value.toString();

    vendorFee = snapshot.child('vendorFee').value.toString();
    dueLimit = snapshot.child('dueLimit').value.toString();
  }
}
