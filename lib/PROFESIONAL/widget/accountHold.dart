// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:fullpro/PROFESIONAL/config.dart';
import 'package:fullpro/PROFESIONAL/controllers/loader.dart';
import 'package:fullpro/PROFESIONAL/views/wallet/wallet.dart';

class AccountHold extends StatefulWidget {
  const AccountHold({Key? key}) : super(key: key);

  @override
  State<AccountHold> createState() => _AccountHoldState();
}

class _AccountHoldState extends State<AccountHold> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            Locales.string(context, 'warn_account_on_hold'),
            style: const TextStyle(
              color: Colors.red,
              fontSize: 20,
              fontFamily: 'Roboto-Regular',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            '${Locales.string(context, 'warn_due_balance_exceed')} ${dueLimit!}',
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontFamily: 'Roboto-Regular',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            Locales.string(context, 'warn_pay_now_for_more_orders'),
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontFamily: 'Roboto-Bold',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Icon(Icons.arrow_downward),
          const SizedBox(height: 20),
          MaterialButton(
            onPressed: () {
              Loader.page(context, const Wallet());
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 15,
            ),
            elevation: 0,
            highlightElevation: 0,
            color: Colors.black87,
            textColor: Colors.white,
            child: Text(
              '${Locales.string(context, 'lbl_pay_now')} ━━━',
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
