// ignore_for_file: file_names

import 'package:google_maps_flutter/google_maps_flutter.dart';

class RequestDetails {
  String destinationAddress;
  String pickupAddress;
  LatLng pickup;
  LatLng destination;
  String rideID;
  String paymentMethod;
  String bookerName;
  String serviceName;
  String bookerPhone;
  String bookerToken;
  String orderNumber;

  String orderStatus;

  RequestDetails({
    this.pickupAddress = '',
    this.rideID = '',
    this.destinationAddress = '',
    this.destination = const LatLng(24.860966, 66.990501),
    this.pickup = const LatLng(24.860966, 66.990501),
    this.paymentMethod = '',
    this.bookerName = '',
    this.serviceName = '',
    this.bookerPhone = '',
    this.orderStatus = '',
    this.bookerToken = '',
    this.orderNumber = '',
  });
}
