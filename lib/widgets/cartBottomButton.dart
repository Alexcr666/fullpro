import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:fullpro/utils/globalConstants.dart';
import 'package:fullpro/controller/loader.dart';
import 'package:fullpro/pages/cartPage.dart';
import 'package:fullpro/pages/homepage.dart';
import 'package:fullpro/styles/statics.dart' as Static;

class CartBottomButton extends StatefulWidget {
  const CartBottomButton({
    Key? key,
  }) : super(key: key);

  @override
  State<CartBottomButton> createState() => _CartBottomButtonState();
}

class _CartBottomButtonState extends State<CartBottomButton> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: cartbottomsheetHeight + 10,
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
            child: MaterialButton(
              color: Static.themeColor[500],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(0),
              onPressed: () {
                //
                Loader.PagewithHome(context, const CartPage());
              },
              child: SizedBox(
                height: cartbottomsheetHeight - 10,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Locales.string(context, 'lbl_cart_full'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Brand-Bold',
                          fontSize: 16,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(width: 15),
                      const Icon(
                        FeatherIcons.arrowRight,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
