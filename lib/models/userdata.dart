import 'package:firebase_database/firebase_database.dart';

class UserData {
  String? fullName;
  String? currentAddress;
  String? currentAddressLatitude;
  String? currentAddressLongitude;
  String? manualAddress;
  String? manualAddressLatitude;
  String? manualAddressLongitude;
  String? addressinUse;
  String? email;
  String? phone;
  String? id;

  UserData({
    this.fullName = '',
    this.currentAddress = '',
    this.currentAddressLatitude = '',
    this.currentAddressLongitude = '',
    this.manualAddress = '',
    this.manualAddressLatitude = '',
    this.manualAddressLongitude = '',
    this.addressinUse = '',
    this.email = '',
    this.phone = '',
    this.id = '',
  });

  UserData.fromSnapshot(DataSnapshot snapshot) {
    id = snapshot.key;
    phone = snapshot.child('phone').value.toString();
    // Current Address
    currentAddress =
        snapshot.child('currentAddress').child('placename').value.toString();
    currentAddressLatitude = snapshot
        .child('currentAddress')
        .child('location')
        .child('latitude')
        .value
        .toString();
    currentAddressLongitude = snapshot
        .child('currentAddress')
        .child('location')
        .child('longitude')
        .value
        .toString();

    // Manual Address
    manualAddress =
        snapshot.child('manualAddress').child('placename').value.toString();
    manualAddressLatitude = snapshot
        .child('manualAddress')
        .child('location')
        .child('latitude')
        .value
        .toString();
    manualAddressLongitude = snapshot
        .child('manualAddress')
        .child('location')
        .child('longitude')
        .value
        .toString();

    addressinUse = snapshot.child('AddressinUse').value.toString();
    fullName = snapshot.child('fullname').value.toString();
  }
}
