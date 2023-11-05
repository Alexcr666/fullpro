import 'package:firebase_database/firebase_database.dart';

class Partner {
  String? newtrip;
  String? fullName;
  String? email;
  String? phone;
  String? id;
  String? carModel;
  String? carColor;
  String? vehicleNumber;

  Partner({
    this.newtrip = '',
    this.fullName = '',
    this.email = '',
    this.phone = '',
    this.id = '',
    this.carModel = '',
    this.carColor = '',
    this.vehicleNumber = '',
  });

  Partner.fromSnapshot(DataSnapshot snapshot) {
    newtrip = snapshot.child('newtrip').value.toString();
    id = snapshot.key;
    email = snapshot.child('email').value.toString();
    phone = snapshot.child('phone').value.toString();
    fullName = snapshot.child('fullname').value.toString();
    carModel =
        snapshot.child('vehicle_details').child('vehicle_model').value.toString();
    carColor =
        snapshot.child('vehicle_details').child('vehicle_color').value.toString();
    vehicleNumber = snapshot
        .child('vehicle_details')
        .child('vehicle_number')
        .value
        .toString();
  }
}
