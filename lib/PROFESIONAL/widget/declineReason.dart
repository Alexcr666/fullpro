// ignore_for_file: file_names

import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter/material.dart';
import 'package:fullpro/PROFESIONAL/controllers/orderController.dart';
import 'package:geolocator/geolocator.dart';
import '../styles/statics.dart' as appcolors;

class DeclineReasonDialog extends StatefulWidget {
  final String? reqID;
  final String? partnerID;

  const DeclineReasonDialog({Key? key, this.reqID, this.partnerID}) : super(key: key);

  @override
  State<DeclineReasonDialog> createState() => _DeclineReasonDialogState();
}

class _DeclineReasonDialogState extends State<DeclineReasonDialog> {
  late Position currentPosition;
  int _groupValue = 1;
  String? reason = "I don't need this Order anymore";

  @override
  void initState() {
    super.initState();
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
            const SizedBox(height: 8),
            addressRadio(
              selected: true,
              title: Locales.string(context, 'cancel_reason_one'),
              value: 1,
              onChanged: (status) {
                setState(() => _groupValue = 1);
                reason = Locales.string(context, 'cancel_reason_one');
              },
            ),
            addressRadio(
              selected: false,
              title: Locales.string(context, 'cancel_reason_two'),
              value: 2,
              onChanged: (status) {
                setState(() => _groupValue = 2);
                reason = Locales.string(context, 'cancel_reason_two');
              },
            ),
            addressRadio(
              selected: false,
              title: Locales.string(context, 'cancel_reason_three'),
              value: 3,
              onChanged: (status) {
                setState(() => _groupValue = 3);
                reason = Locales.string(context, 'cancel_reason_three');
              },
            ),
            //
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: MaterialButton(
                      elevation: 0,
                      highlightElevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      color: appcolors.dashboardCard,
                      textColor: Colors.black,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(Locales.string(context, 'lbl_cancel')),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: MaterialButton(
                      highlightElevation: 0,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      color: appcolors.themeColor[500],
                      textColor: Colors.white,
                      onPressed: () {
                        OrderController.declineOrder(widget.reqID!, reason!, widget.partnerID!, context);
                      },
                      child: Text(Locales.string(context, 'lbl_confirm')),
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

  Widget addressRadio({required String title, required int value, required bool selected, required Function(int?) onChanged}) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(0),
        child: Theme(
          data: Theme.of(context).copyWith(),
          child: RadioListTile(
            value: value,
            groupValue: _groupValue,
            onChanged: onChanged,
            selected: selected,
            title: Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
