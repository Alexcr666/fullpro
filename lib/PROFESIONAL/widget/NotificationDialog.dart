// ignore_for_file: file_names

import 'package:flutter_locales/flutter_locales.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fullpro/PROFESIONAL/config.dart';
import 'package:fullpro/PROFESIONAL/controllers/mainController.dart';
import 'package:fullpro/PROFESIONAL/models/requestDetails.dart';
import 'package:fullpro/PROFESIONAL/utils/globalConstants.dart';
import 'package:fullpro/PROFESIONAL/widget/DataLoadedProgress.dart';
import 'package:fullpro/PROFESIONAL/widget/brandDivider.dart';
import 'package:geolocator/geolocator.dart';
import '../styles/statics.dart' as appcolors;

class NotificationDialog extends StatefulWidget {
  final RequestDetails? krequestDetails;

  const NotificationDialog({Key? key, this.krequestDetails}) : super(key: key);

  @override
  State<NotificationDialog> createState() => _NotificationDialogState();
}

class _NotificationDialogState extends State<NotificationDialog> {
  late Position currentPosition;
  void getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
  }

  @override
  void initState() {
    super.initState();
    getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(4),
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: 30.0,
            ),
            Image.asset(
              'images/logo.png',
              width: 100,
            ),
            const SizedBox(
              height: 16.0,
            ),
            Text(
              '${Locales.string(context, 'lbl_new')} $appName ${Locales.string(context, 'lbl_request')}',
              style: const TextStyle(fontFamily: 'Roboto-Bold', fontSize: 18),
            ),
            const SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          child: Text(
                        MainControllerProfesional.capitalize(widget.krequestDetails!.serviceName),
                        style: const TextStyle(fontSize: 18),
                      ))
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          child: Text(
                        MainControllerProfesional.capitalize(widget.krequestDetails!.destinationAddress),
                        style: const TextStyle(fontSize: 18),
                      ))
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const BrandDivider(),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: MaterialButton(
                      child: Text(Locales.string(context, 'lbl_decline')),
                      color: appcolors.primaryColorblue,
                      textColor: Colors.white,
                      onPressed: () async {
                        assetsAudioPlayer.stop();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: MaterialButton(
                      child: Text(Locales.string(context, 'lbl_accept')),
                      textColor: Colors.black,
                      color: appcolors.secondaryColorSharp,
                      onPressed: () async {
                        assetsAudioPlayer.stop();
                        checkAvailablity(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  void checkAvailablity(context) async {
    //show please wait dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => const Center(
        child: DataLoadedProgress(),
      ),
    );
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);

    if (widget.krequestDetails?.orderStatus == "Pending") {
      acceptTrip(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(Locales.string(context, 'lbl_order_been_assigned'))));
    } else if (widget.krequestDetails?.orderStatus == "canceled") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(Locales.string(context, 'lbl_order_been_canceled'))));
    } else if (widget.krequestDetails?.orderStatus == Locales.string(context, 'lbl_timeout')) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(Locales.string(context, 'lbl_order_timedout'))));
    } else if (widget.krequestDetails?.orderStatus == "Assigned") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(Locales.string(context, 'lbl_order_accepted_by_other_user'))));
    }
  }

  void acceptTrip(context) async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;

    String? rideID = widget.krequestDetails?.rideID;
    DatabaseReference rideRef = FirebaseDatabase.instance.ref().child('requests').child(rideID!);

    rideRef.child('status').set("Assigned");
    rideRef.child('partner_name').set(currentPartnerInfo?.fullName);
    rideRef.child('partner_phone').set(currentPartnerInfo?.phone);
    rideRef.child('partner_id').set(currentPartnerInfo?.id);

    DatabaseReference historyRef = FirebaseDatabase.instance.ref().child('partners/${currentFirebaseUser?.uid}/history/$rideID');
    historyRef.set(true);

    MainControllerProfesional.sendOrderAssignedNoti(
        Locales.string(context, 'lbl_provider_assigned'),
        '${Locales.string(context, 'lbl_order_number')} ${widget.krequestDetails?.orderNumber}',
        widget.krequestDetails!.bookerToken,
        widget.krequestDetails?.orderNumber,
        context);
  }
}
