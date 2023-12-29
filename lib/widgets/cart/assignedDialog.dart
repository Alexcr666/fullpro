import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:fullpro/controller/loader.dart';
import 'package:fullpro/pages/profile/orderspage.dart';

class AssignedDialog extends StatefulWidget {
  String? orderID;

  AssignedDialog({required this.orderID});

  @override
  State<AssignedDialog> createState() => _AssignedDialogState();
}

class _AssignedDialogState extends State<AssignedDialog> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        backgroundColor: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(16.0),
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  Locales.string(context, 'lbl_partner_assigned'),
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '${Locales.string(context, 'lbl_order_number')}${widget.orderID}',
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Center(
                    child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.black,
                    ),
                    foregroundColor: MaterialStateProperty.all(
                      Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Loader.page(
                        context,
                        MyOrdersProfile(
                          tabIndicator: 1,
                        ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Text(Locales.string(context, 'lbl_check_orders')),
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
